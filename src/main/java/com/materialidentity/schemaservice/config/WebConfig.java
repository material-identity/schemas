package com.materialidentity.schemaservice.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

  @Autowired
  private SentryTransactionIdInterceptor sentryTransactionIdInterceptor;

  @Override
  public void addInterceptors(InterceptorRegistry registry) {
    registry.addInterceptor(sentryTransactionIdInterceptor);
  }

  @Override
  public void addCorsMappings(@SuppressWarnings("null") CorsRegistry registry) {
    registry
        .addMapping("/api/**")
        .allowedOriginPatterns(
          // Local development
          "http://localhost:4200", 
          "http://localhost:8081", 
          // Schemas service environments
          "https://schemas-service.development.s1seven.com", 
          "https://schemas-service.staging.s1seven.com", 
          "https://schemas-service.s1seven.com",
          // DMP environments 
          "https://dmp.development.s1seven.com", 
          "https://dmp.staging.s1seven.com", 
          "https://dmp.s1seven.com",
          // Heroku review apps patterns
          "https://s1-schemas-pr-*.herokuapp.com",
          "https://dmp-pr-*.herokuapp.com")
        .allowedMethods("GET", "POST", "PUT", "DELETE")
        .allowedHeaders("*")
        .allowCredentials(false);
  }
}