package com.blooddonor.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Handle profile image uploads
        Path profileDir = Paths.get(System.getProperty("user.dir") + "/uploads/profiles/");
        String profilePath = profileDir.toFile().getAbsolutePath();
        
        registry.addResourceHandler("/uploads/profiles/**")
                .addResourceLocations("file:" + profilePath + "/");
                
        // Add other static handlers if needed
    }
}
