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
        .allowedOrigins("http://localhost:4200", "https://dmp.development.s1seven.com", "https://dmp.staging.s1seven.com", "https://dmp.s1seven.com") // Angular development server
        .allowedMethods("GET", "POST", "PUT", "DELETE")
        .allowedHeaders("*")
        .allowCredentials(false);
  }
}