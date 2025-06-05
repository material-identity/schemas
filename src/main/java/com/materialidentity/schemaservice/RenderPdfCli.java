package com.materialidentity.schemaservice;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Command-line interface for rendering PDF certificates without running the full Spring Boot service.
 * This allows for faster development cycles as XSLT files are loaded fresh on each execution.
 * 
 * Note: This implementation uses the API service for rendering. For a truly standalone version
 * that doesn't require the service to be running, we would need to refactor the FOP configuration
 * to work without Spring's classpath resource loading.
 */
public class RenderPdfCli {
    
    private static final ObjectMapper objectMapper = new ObjectMapper();
    
    public static void main(String[] args) {
        if (args.length < 2 || !args[0].equals("--certificatePath")) {
            System.err.println("Usage: java RenderPdfCli --certificatePath <path> [--output <directory>]");
            System.err.println("");
            System.err.println("Note: This tool requires the schema service to be running on http://localhost:8081");
            System.err.println("Start the service with: mvn spring-boot:run");
            System.exit(1);
        }
        
        String certificatePath = args[1];
        String outputDirectory = null;
        
        // Parse optional output directory
        if (args.length >= 4 && args[2].equals("--output")) {
            outputDirectory = args[3];
        }
        
        try {
            // Read certificate JSON
            Path inputPath = Paths.get(certificatePath).toAbsolutePath();
            String jsonContent = Files.readString(inputPath);
            
            // Parse JSON to validate it's valid JSON
            objectMapper.readTree(jsonContent);
            
            // Determine output path
            Path outputPath;
            if (outputDirectory != null) {
                Path outputDir = Paths.get(outputDirectory).toAbsolutePath();
                Files.createDirectories(outputDir);
                String inputFilename = inputPath.getFileName().toString().replaceFirst("\\.json$", ".pdf");
                outputPath = outputDir.resolve(inputFilename);
            } else {
                // Save in same directory as input
                String inputFilename = inputPath.getFileName().toString().replaceFirst("\\.json$", ".pdf");
                outputPath = inputPath.getParent().resolve(inputFilename);
            }
            
            // Call the API service to render the PDF
            String serviceUrl = System.getProperty("schema.service.url", "http://localhost:8081");
            java.net.http.HttpClient client = java.net.http.HttpClient.newHttpClient();
            java.net.http.HttpRequest request = java.net.http.HttpRequest.newBuilder()
                .uri(java.net.URI.create(serviceUrl + "/api/render"))
                .header("Content-Type", "application/json")
                .POST(java.net.http.HttpRequest.BodyPublishers.ofString(jsonContent))
                .build();
            
            java.net.http.HttpResponse<byte[]> response = client.send(request, 
                java.net.http.HttpResponse.BodyHandlers.ofByteArray());
            
            if (response.statusCode() != 200) {
                throw new RuntimeException("Service returned status " + response.statusCode() + 
                    ": " + new String(response.body()));
            }
            
            byte[] pdfBytes = response.body();
            
            // Write PDF to output file
            try (FileOutputStream fos = new FileOutputStream(outputPath.toFile())) {
                fos.write(pdfBytes);
            }
            
            System.out.println("PDF saved as '" + outputPath + "'.");
            
        } catch (java.net.ConnectException e) {
            System.err.println("Error: Cannot connect to schema service at http://localhost:8081");
            System.err.println("Make sure the service is running with: mvn spring-boot:run");
            System.exit(1);
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}