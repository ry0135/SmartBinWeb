package com.example.repository;

import com.example.model.Account;
import com.example.model.Bin;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BinRepository extends JpaRepository<Bin, Integer> {

}
