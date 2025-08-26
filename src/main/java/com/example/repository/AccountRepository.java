package com.example.repository;

import com.example.model.Account;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account, Integer> {

    Optional<Account> findByEmail(String email);
    Account findByAccountId(int accountID);
    Account findByEmailAndCode(String email, String code);

    boolean existsByAccountId(int accountID);
    boolean existsByEmail(String email);

    boolean existsByEmailAndIsVerifiedTrue(String email);
    boolean existsByEmailAndIsVerifiedFalse(String email);

}
