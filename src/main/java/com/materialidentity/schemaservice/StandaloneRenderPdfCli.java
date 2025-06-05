package com.materialidentity.schemaservice;

import com.materialidentity.schemaservice.resource.FileSystemResourceLoader;

import java.io.FileOutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Standalone command-line interface for rendering PDF certificates.
 * This version works without the Spring Boot web service and loads XSLT files
 * fresh on each execution, enabling faster development cycles.
 */
public class StandaloneRenderPdfCli {
    
    public static void main(String[] args) {
        if (args.length < 2 || !args[0].equals("--certificatePath")) {
            System.err.println("Usage: java StandaloneRenderPdfCli --certificatePath <path> [--output <directory>]");
            System.err.println("");
            System.err.println("Examples:");
            System.err.println("  java StandaloneRenderPdfCli --certificatePath test/fixtures/EN10168/v0.4.1/valid_certificate_1.json");
            System.err.println("  java StandaloneRenderPdfCli --certificatePath cert.json --output /tmp/pdfs");
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
            
            // Determine the base path for resources
            // Look for src/main/resources first, then current directory
            Path resourceBasePath = findResourcePath();
            
            System.out.println("Using resource base path: " + resourceBasePath);
            System.out.println("Processing certificate: " + inputPath);
            
            // Create file system resource loader
            FileSystemResourceLoader resourceLoader = new FileSystemResourceLoader(resourceBasePath);
            
            // Create core PDF service
            CorePdfService pdfService = new CorePdfService(resourceLoader);
            
            // Render PDF
            byte[] pdfBytes = pdfService.renderCertificate(jsonContent, true, null);
            
            // Write PDF to output file
            try (FileOutputStream fos = new FileOutputStream(outputPath.toFile())) {
                fos.write(pdfBytes);
            }
            
            System.out.println("PDF saved as '" + outputPath + "'.");
            System.out.println("File size: " + pdfBytes.length + " bytes");
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
    
    /**
     * Find the resource base path by looking for known schema directories
     */
    private static Path findResourcePath() {
        // Try different possible locations
        String[] candidatePaths = {
            "src/main/resources",
            "target/classes", 
            ".",
            "../src/main/resources",
            "../target/classes"
        };
        
        for (String candidatePath : candidatePaths) {
            Path path = Paths.get(candidatePath).toAbsolutePath();
            Path schemasPath = path.resolve("schemas");
            
            if (Files.exists(schemasPath) && Files.isDirectory(schemasPath)) {
                System.out.println("Found schemas directory at: " + schemasPath);
                return path;
            }
        }
        
        // Default to current directory if nothing found
        System.out.println("Warning: Could not find schemas directory, using current directory");
        return Paths.get(".").toAbsolutePath();
    }
}