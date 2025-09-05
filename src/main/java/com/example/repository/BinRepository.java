package com.example.repository;

import com.example.model.Bin;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BinRepository extends JpaRepository<Bin, Integer> {

    // Custom query để lấy danh sách bin theo status
    List<Bin> findByStatus(int status);

    // Custom query để lấy danh sách bin sắp xếp theo thời gian cập nhật
    @Query("SELECT b FROM Bin b ORDER BY b.lastUpdated DESC")
    List<Bin> findAllOrderByLastUpdatedDesc();
    // Thêm vào cuối interface
    @Query("SELECT b FROM Bin b WHERE b.currentFill >= :threshold ORDER BY b.currentFill DESC")
    List<Bin> findByCurrentFillGreaterThanEqual(@Param("threshold") double threshold);
    Optional<Bin> findByBinCode(String binCode);
}