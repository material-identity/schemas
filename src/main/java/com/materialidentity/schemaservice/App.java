package com.materialidentity.schemaservice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import io.sentry.Sentry;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.core.env.Environment;

@SpringBootApplication
public class App {

  private static final Logger log = LoggerFactory.getLogger(App.class);

  public static void main(String[] args) {

    ConfigurableApplicationContext applicationContext = SpringApplication.run(App.class, args);
    Environment env = applicationContext.getBean(Environment.class);
    String sentryDsn = env.getProperty("sentry.dsn");
    String environment = env.getProperty("spring.profiles.active");

    Sentry.init(options -> {
      options.setDsn(sentryDsn);
      options.setTracesSampleRate(1.0);
      options.setEnvironment(environment);
    });
  }
}
