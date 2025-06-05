package com.materialidentity.schemaservice.resource;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * ResourceLoader implementation that loads resources from the filesystem.
 * Used by the standalone CLI application to access schema files, fonts, etc.
 */
public class FileSystemResourceLoader implements ResourceLoader {
    
    private final Path basePath;
    
    public FileSystemResourceLoader(String basePath) {
        this.basePath = Paths.get(basePath).toAbsolutePath();
    }
    
    public FileSystemResourceLoader(Path basePath) {
        this.basePath = basePath.toAbsolutePath();
    }
    
    @Override
    public InputStream getResource(String path) throws IOException {
        Path resourcePath = basePath.resolve(path);
        if (!Files.exists(resourcePath)) {
            throw new IOException("Resource not found: " + resourcePath);
        }
        return new FileInputStream(resourcePath.toFile());
    }
    
    @Override
    public boolean exists(String path) {
        Path resourcePath = basePath.resolve(path);
        return Files.exists(resourcePath);
    }
    
    @Override
    public List<InputStream> getResources(String pattern) throws IOException {
        List<String> resourceNames = getResourceNames(pattern);
        List<InputStream> streams = new ArrayList<>();
        for (String name : resourceNames) {
            streams.add(getResource(name));
        }
        return streams;
    }
    
    @Override
    public List<String> getResourceNames(String pattern) throws IOException {
        // Convert glob pattern to file system search
        // For example: "schemas/*/translations.json" -> find all matching files
        
        if (pattern.contains("*")) {
            return findMatchingFiles(pattern);
        } else {
            // Single file
            if (exists(pattern)) {
                return List.of(pattern);
            } else {
                return List.of();
            }
        }
    }
    
    private List<String> findMatchingFiles(String pattern) throws IOException {
        // Simple pattern matching for common cases like "schemas/*/translations.json"
        String[] parts = pattern.split("/");
        Path currentPath = basePath;
        
        List<String> results = new ArrayList<>();
        findMatchingFilesRecursive(currentPath, parts, 0, "", results);
        return results;
    }
    
    private void findMatchingFilesRecursive(Path currentPath, String[] patternParts, 
                                           int partIndex, String relativePath, 
                                           List<String> results) throws IOException {
        if (partIndex >= patternParts.length) {
            return;
        }
        
        String currentPart = patternParts[partIndex];
        
        if ("*".equals(currentPart)) {
            // Wildcard - search all subdirectories
            if (Files.isDirectory(currentPath)) {
                try (Stream<Path> stream = Files.list(currentPath)) {
                    for (Path subPath : stream.filter(Files::isDirectory).collect(Collectors.toList())) {
                        String newRelativePath = relativePath.isEmpty() ? 
                            subPath.getFileName().toString() : 
                            relativePath + "/" + subPath.getFileName().toString();
                        findMatchingFilesRecursive(subPath, patternParts, partIndex + 1, 
                                                 newRelativePath, results);
                    }
                }
            }
        } else {
            // Literal path component
            Path nextPath = currentPath.resolve(currentPart);
            String newRelativePath = relativePath.isEmpty() ? 
                currentPart : 
                relativePath + "/" + currentPart;
                
            if (partIndex == patternParts.length - 1) {
                // Last part - this should be a file
                if (Files.exists(nextPath) && Files.isRegularFile(nextPath)) {
                    results.add(newRelativePath);
                }
            } else {
                // Intermediate part - continue recursion
                if (Files.exists(nextPath) && Files.isDirectory(nextPath)) {
                    findMatchingFilesRecursive(nextPath, patternParts, partIndex + 1, 
                                             newRelativePath, results);
                }
            }
        }
    }
}