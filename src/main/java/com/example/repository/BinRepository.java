package com.example.repository;

import com.example.model.Bin;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface BinRepository extends JpaRepository<Bin, Integer> {


    Bin findByBinCode(String binCode);

    // JOIN để lấy thông tin đầy đủ bao gồm Ward và Province
    @Query("SELECT b FROM Bin b JOIN FETCH b.ward w JOIN FETCH w.province WHERE b.binID = :id")
    Optional<Bin> findByIdWithWardAndProvince(@Param("id") int id);

    // JOIN để lấy tất cả bins với thông tin đầy đủ
    @Query("SELECT b FROM Bin b JOIN FETCH b.ward w JOIN FETCH w.province")
    List<Bin> findAllWithWardAndProvince();

    // JOIN để lấy bins theo wardID với thông tin đầy đủ
    @Query("SELECT b FROM Bin b JOIN FETCH b.ward w JOIN FETCH w.province WHERE b.wardID = :wardID")
    List<Bin> findByWardIDWithWardAndProvince(@Param("wardID") int wardID);
    @Query("SELECT b FROM Bin b JOIN FETCH b.ward w JOIN FETCH w.province WHERE b.status = 1 AND b.currentFill > 60")
    List<Bin> findActiveBinsWithHighFill();

    @Query("SELECT b FROM Bin b JOIN FETCH b.ward w JOIN FETCH w.province WHERE b.status = 2")
    List<Bin> findOffLineBins();
    boolean existsByBinCode(String binCode);
}