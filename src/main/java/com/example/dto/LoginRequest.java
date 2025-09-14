package com.example.dto;

public class LoginRequest {
    private String email;
    private String password;

    // Constructor
    public LoginRequest() {}
    public LoginRequest(String email, String password) {
        this.email = email;
        this.password = password;
    }

    // Getter / Setter
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
}
