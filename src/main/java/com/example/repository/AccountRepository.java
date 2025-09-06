package com.example.repository;

import com.example.model.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account, Integer> {

    Optional<Account> findByEmail(String email);
    Account findByAccountId(int accountID);
    Account findByEmailAndCode(String email, String code);
    @Query("SELECT a FROM Account a WHERE a.email = :email")
    Account findByEmailAccount(@Param("email") String email);
    boolean existsByAccountId(int accountID);
    boolean existsByEmail(String email);

    boolean existsByEmailAndIsVerifiedTrue(String email);
    boolean existsByEmailAndIsVerifiedFalse(String email);
    @Query("SELECT a FROM Account a WHERE a.email = :email AND a.password = :password")
    Optional<Account> findByEmailAndPassword(@Param("email") String email,
                                             @Param("password") String password);



}
