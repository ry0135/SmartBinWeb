package com.example.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.*;

// Spring Security 5.5.x (Boot 2.5.6) vẫn dùng WebSecurityConfigurerAdapter được
@EnableWebSecurity
@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .csrf() // giữ CSRF
                .and()
                .authorizeRequests()
                .antMatchers(
                        "/forgot-password", "/verify-code",
                        "/dev/mail-test",                // chỉ để test, xong thì xoá
                        "/css/**", "/js/**", "/images/**", "/img/**", "/webjars/**"
                ).permitAll()
                .anyRequest().authenticated()
                .and()
                .formLogin()
                .loginPage("/login")      // đổi path theo trang login của bạn nếu khác
                .permitAll()
                .and()
                .logout()
                .permitAll();
    }
}
