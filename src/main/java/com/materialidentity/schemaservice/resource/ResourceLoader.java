package com.materialidentity.schemaservice.resource;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

/**
 * Abstraction for loading resources from different sources (classpath, filesystem, etc.)
 * This interface enables the PDF generation components to work both in Spring Boot
 * web service context and standalone CLI applications.
 */
public interface ResourceLoader {
    
    /**
     * Load a single resource as an input stream
     * @param path the resource path
     * @return input stream for the resource
     * @throws IOException if the resource cannot be loaded
     */
    InputStream getResource(String path) throws IOException;
    
    /**
     * Check if a resource exists at the given path
     * @param path the resource path
     * @return true if the resource exists
     */
    boolean exists(String path);
    
    /**
     * Load multiple resources matching a pattern
     * @param pattern the resource pattern
     * @return list of input streams for matching resources
     * @throws IOException if resources cannot be loaded
     */
    List<InputStream> getResources(String pattern) throws IOException;
    
    /**
     * Get the names of resources matching a pattern
     * @param pattern the resource pattern
     * @return list of resource names/paths
     * @throws IOException if resources cannot be discovered
     */
    List<String> getResourceNames(String pattern) throws IOException;
}