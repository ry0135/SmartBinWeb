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
    long countByStatus(int status); // 1 = hoạt động tốt



    // Tổng số thùng
    @Query("SELECT COUNT(b) FROM Bin b")
    long countAllBins();

    // Thùng đang hoạt động
    @Query("SELECT COUNT(b) FROM Bin b WHERE b.status = 1")
    long countActiveBins();

    // Thùng đầy (>=90%)
    @Query("SELECT COUNT(b) FROM Bin b WHERE b.currentFill >= 90")
    long countFullBins();

    // --- Thống kê số thùng theo tháng (dùng native query để chắc chắn hoạt động) ---
    @Query(value = "SELECT MONTH(LastUpdated) AS month, COUNT(*) AS total " +
            "FROM Bins " +
            "WHERE LastUpdated IS NOT NULL " +
            "GROUP BY MONTH(LastUpdated) " +
            "ORDER BY MONTH(LastUpdated)", nativeQuery = true)
    List<Object[]> countBinsAddedPerMonth();

    // --- Thống kê trạng thái thùng rác ---
    @Query(value = "SELECT " +
            "SUM(CASE WHEN Status = 1 THEN 1 ELSE 0 END) AS activeCount, " +
            "SUM(CASE WHEN CurrentFill >= 90 THEN 1 ELSE 0 END) AS fullCount, " +
            "SUM(CASE WHEN Status = 0 THEN 1 ELSE 0 END) AS maintenanceCount " +
            "FROM Bins", nativeQuery = true)
    List<Object[]> countBinStatusSummary();
    @Query(value = "SELECT COUNT(*) FROM Bins WHERE WardID = :wardId", nativeQuery = true)
    long countBinsByWard(@Param("wardId") int wardId);

    @Query(value = "SELECT COUNT(*) FROM Bins WHERE Status = 1 AND WardID = :wardId", nativeQuery = true)
    long countActiveBinsByWard(@Param("wardId") int wardId);

    @Query(value = "SELECT COUNT(*) FROM Bins WHERE CurrentFill >= 90 AND WardID = :wardId", nativeQuery = true)
    long countFullBinsByWard(@Param("wardId") int wardId);

    @Query(value = "SELECT ISNULL(MONTH(LastUpdated), 0) AS month, COUNT(*) AS total " +
            "FROM Bins WHERE WardID = :wardId AND LastUpdated IS NOT NULL " +
            "GROUP BY MONTH(LastUpdated) ORDER BY MONTH(LastUpdated)", nativeQuery = true)
    List<Object[]> countBinsAddedPerMonthByWard(@Param("wardId") int wardId);

    @Query(value = "SELECT " +
            "ISNULL(SUM(CASE WHEN Status = 1 THEN 1 ELSE 0 END), 0) AS activeCount, " +
            "ISNULL(SUM(CASE WHEN CurrentFill >= 90 THEN 1 ELSE 0 END), 0) AS fullCount, " +
            "ISNULL(SUM(CASE WHEN Status = 0 THEN 1 ELSE 0 END), 0) AS maintenanceCount " +
            "FROM Bins WHERE WardID = :wardId", nativeQuery = true)
    Object[] countBinStatusSummaryByWard(@Param("wardId") int wardId);






}