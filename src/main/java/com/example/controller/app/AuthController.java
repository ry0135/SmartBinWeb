package com.example.controller.app;

import com.example.model.Account;
import com.example.model.ApiMessage;
import com.example.repository.AccountRepository;
import com.example.service.AccountService;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;
import java.util.Date;
import java.util.Map;
import java.util.UUID;


@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AccountService accountService; // Service để lưu/tìm user

    @Autowired
    private AccountRepository accountRepository; // Service để lưu/tìm user

    @PostMapping("/login/google")
    public ResponseEntity<ApiMessage> loginWithGoogle(@RequestBody Map<String, String> body) {
        try {
            String idTokenString = body.get("idToken");

            // ✅ Verify token bằng Google API
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    new NetHttpTransport(),
                    JacksonFactory.getDefaultInstance()
            )
                    .setAudience(Collections.singletonList("1012649425671-cj7thogqrusmaegel8gnm800gect4tsd.apps.googleusercontent.com")) // client_id
                    .build();

            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken != null) {
                GoogleIdToken.Payload payload = idToken.getPayload();

                String userId = payload.getSubject(); // Google ID
                String email = payload.getEmail();
                String name = (String) payload.get("name");

                // ✅ Lưu user nếu chưa tồn tại
                Account account = accountRepository.findByEmailAccount(email);

                if (account == null) {
                    account = new Account();
                    account.setEmail(email);
                    account.setFullName(name);
                    account.setRole(4); // ví dụ: role=4 là citizen
                    // đặt mật khẩu name nhiên (dummy)
                    account.setPassword(UUID.randomUUID().toString());


                    // Nếu có status mặc định
                    account.setStatus(1);
                    account.setCreatedAt(new Date());
                    accountService.saveGoogle(account);
                }

                ApiMessage msg = new ApiMessage("Login thành công", account.getAccountId(), account.getRole());
                return ResponseEntity.ok(msg);
            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(new ApiMessage("Token không hợp lệ"));
            }

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ApiMessage("Lỗi server: " + e.getMessage()));
        }
    }
}

