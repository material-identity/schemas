package com.materialidentity.schemaservice;

import com.beust.jcommander.JCommander;
import com.beust.jcommander.Parameter;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class App {

  @Parameter(
    names = "--verify",
    description = "Starts the verification process"
  )
  private boolean verify = false;

  @Parameter(names = "--render", description = "Starts the rendering process")
  private boolean render = false;

  // You can also define parameters for additional options
  // @Parameter(names = "--option", description = "Description")

  public static void main(String[] args) {
    App app = new App();
    JCommander.newBuilder().addObject(app).build().parse(args);

    app.run();
  }

  public void run() {
    if (verify) {
      startVerificationProcess();
    } else if (render) {
      startRenderingProcess();
    } else {
      startWebServer();
    }
  }

  private void startVerificationProcess() {
    System.out.println("Verification process started.");
  }

  private void startRenderingProcess() {
    System.out.println("Rendering process started.");
  }

  private void startWebServer() {
    System.out.println("Web server started.");
    SpringApplication.run(App.class);
  }
}
