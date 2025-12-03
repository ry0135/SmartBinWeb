package com.example.repository;

import com.example.model.Ward;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WardRepository extends JpaRepository<Ward, Integer> {
    List<Ward> findByProvince_ProvinceId(Integer provinceId);

    List<Ward> findAllByOrderByWardNameAsc();

    // ===================== ADD-ON =====================
    Ward findByWardId(int wardId);
    @Query("SELECT COUNT(w) FROM Ward w")
    long countAllWards();
    @Query("SELECT w FROM Ward w ORDER BY w.wardName ASC")
    List<Ward> findAllWards();


    boolean existsByWardNameIgnoreCaseAndProvince_ProvinceId(String wardName, Integer provinceId);

    @Query("SELECT w.province.provinceId FROM Ward w WHERE w.wardId = :wardId")
    Integer findProvinceIdByWardId(@Param("wardId") Integer wardId);
}
