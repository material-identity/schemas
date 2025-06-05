package com.materialidentity.schemaservice.resource;

import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * ResourceLoader implementation that uses Spring's classpath resource loading.
 * Used by the web service to maintain existing behavior.
 */
public class ClassPathResourceLoader implements ResourceLoader {
    
    private final PathMatchingResourcePatternResolver resolver;
    
    public ClassPathResourceLoader() {
        this.resolver = new PathMatchingResourcePatternResolver();
    }
    
    @Override
    public InputStream getResource(String path) throws IOException {
        org.springframework.core.io.Resource resource = resolver.getResource("classpath:" + path);
        if (!resource.exists()) {
            throw new IOException("Resource not found: " + path);
        }
        return resource.getInputStream();
    }
    
    @Override
    public boolean exists(String path) {
        org.springframework.core.io.Resource resource = resolver.getResource("classpath:" + path);
        return resource.exists();
    }
    
    @Override
    public List<InputStream> getResources(String pattern) throws IOException {
        Resource[] resources = resolver.getResources("classpath*:" + pattern);
        List<InputStream> streams = new ArrayList<>();
        for (Resource resource : resources) {
            streams.add(resource.getInputStream());
        }
        return streams;
    }
    
    @Override
    public List<String> getResourceNames(String pattern) throws IOException {
        Resource[] resources = resolver.getResources("classpath*:" + pattern);
        List<String> names = new ArrayList<>();
        for (Resource resource : resources) {
            // Extract relative path from URI
            String uri = resource.getURI().toString();
            if (uri.contains("!")) {
                // JAR resource
                String path = uri.substring(uri.lastIndexOf("!") + 1);
                if (path.startsWith("/")) {
                    path = path.substring(1);
                }
                names.add(path);
            } else {
                // File resource
                String path = resource.getFilename();
                if (path != null) {
                    names.add(path);
                }
            }
        }
        return names;
    }
}