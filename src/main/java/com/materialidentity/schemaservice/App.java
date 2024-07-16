package com.materialidentity.schemaservice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.core.env.Environment;

import io.sentry.Sentry;

@SpringBootApplication
@EnableCaching
public class App {

  private static final Logger log = LoggerFactory.getLogger(App.class);

  public static void main(String[] args) {
    ConfigurableApplicationContext applicationContext = SpringApplication.run(App.class, args);
    Environment env = applicationContext.getBean(Environment.class);
    String sentryDsn = env.getProperty("sentry.dsn");
    String environment = env.getProperty("spring.profiles.active");

    if (sentryDsn != null) {
      Sentry.init(options -> {
        options.setDsn(sentryDsn);
        options.setTracesSampleRate(1.0);
        options.setEnvironment(environment);
      });
    }
  }
}
