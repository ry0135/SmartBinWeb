package com.example.repository;

import com.example.model.Ward;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WardRepository extends JpaRepository<Ward, Integer> {
    List<Ward> findByProvince_ProvinceId(Integer provinceId);

    List<Ward> findAllByOrderByWardNameAsc();

    // ===================== ADD-ON =====================
    Ward findByWardId(int wardId);
}
