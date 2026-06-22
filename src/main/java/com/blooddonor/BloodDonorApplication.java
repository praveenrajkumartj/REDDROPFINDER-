package com.blooddonor;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.EnableAsync;

/**
 * Main entry point for Blood Donor Emergency Finder Application.
 */
@SpringBootApplication
@EnableScheduling
@EnableAsync
public class BloodDonorApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(BloodDonorApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(BloodDonorApplication.class, args);
    }
}
