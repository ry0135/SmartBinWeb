package com.example.repository;

import com.example.model.ManagerApplication;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ManagerApplicationRepository extends JpaRepository<ManagerApplication, Integer> {

    List<ManagerApplication> findByStatus(int status);

    ManagerApplication findByApplicationId(int applicationId);
}
