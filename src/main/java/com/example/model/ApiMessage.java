package com.example.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class ApiMessage {
    private String code;
    private String message;
    private int userId;
    private int role;

    public ApiMessage(String code, String message) {
        this.code = code;
        this.message = message;
    }

    public ApiMessage(String message) {
        this.message = message;
    }

    public ApiMessage(String message, int userId, int role) {
        this.message = message;
        this.userId = userId;
        this.role = role;
    }

}
