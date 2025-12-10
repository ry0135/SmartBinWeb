package com.example.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Bean
    public TaskScheduler messageBrokerTaskScheduler() {
        ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
        scheduler.setPoolSize(1);
        scheduler.setThreadNamePrefix("wss-heartbeat-thread-");
        scheduler.initialize();
        return scheduler;
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {

        // Web Browser (SockJS)
        registry.addEndpoint("/ws-bin-sockjs")
                .setAllowedOrigins("https://smartbinx.duckdns.org")
                .withSockJS();

        // Android (native WebSocket)
        registry.addEndpoint("/ws-bin")
                .setAllowedOrigins("https://smartbinx.duckdns.org");
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {

        registry.enableSimpleBroker("/topic")
                .setTaskScheduler(messageBrokerTaskScheduler()) //  BẮT BUỘC KHI DÙNG HEARTBEAT
                .setHeartbeatValue(new long[]{10000, 10000});

        registry.setApplicationDestinationPrefixes("/app");
    }
}
