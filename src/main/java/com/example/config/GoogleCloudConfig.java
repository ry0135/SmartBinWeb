package com.example.config;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.annotation.PostConstruct;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;

@Configuration
public class GoogleCloudConfig {

    @Value("${gcp.credentials.location}")
    private String credentialsPath;

    @Bean
    public Storage googleStorage() throws IOException {
        GoogleCredentials credentials = GoogleCredentials
                .fromStream(new FileInputStream(credentialsPath))
                .createScoped(Collections.singletonList("https://www.googleapis.com/auth/cloud-platform"));

        return StorageOptions.newBuilder().setCredentials(credentials).build().getService();
    }

    @PostConstruct
    public void init() {
        System.out.println(">>>>> GCP CREDENTIAL PATH = " + credentialsPath);
    }
}





