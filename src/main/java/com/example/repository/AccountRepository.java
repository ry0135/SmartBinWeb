package com.example.repository;

import com.example.model.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

// ---------- THÊM CÁC HÀM PHÂN TRANG / TÌM KIẾM ----------
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
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
    // Thêm phương thức mới


    @Query("SELECT a FROM Account a LEFT JOIN FETCH a.ward WHERE a.role = 3 AND a.wardID = :wardID")
        List<Account> findWorkersByWard(@Param("wardID") int wardID);

    @Query("SELECT a.fcmToken FROM Account a WHERE a.accountId = :id")
    String findFcmTokenByAccountId(@Param("id") int id);


//    @Query("SELECT a FROM Account a LEFT JOIN FETCH a.ward WHERE a.role = 5 AND a.wardID = :wardID")
//    List<Account> findWorkersByWardandrole5(@Param("wardID") int wardID);

    @Query("SELECT DISTINCT a FROM Account a " +
            "LEFT JOIN FETCH a.ward w " +
            "LEFT JOIN FETCH w.province p " +
            "WHERE a.role = 5 " +
            "AND (a.wardID = :wardID OR p.provinceId = :provinceId)")
    List<Account> findWorkersByWardAndProvince(
            @Param("wardID") int wardID,
            @Param("provinceId") int provinceId
    );
    // ========== BỔ SUNG HÀM PHÂN TRANG / TÌM KIẾM ==========

    // List theo role (phân trang/sort)
    Page<Account> findByRole(int role, Pageable pageable);

    // List theo role + status
    Page<Account> findByRoleAndStatus(int role, int status, Pageable pageable);

    // Search theo email (theo role)
    Page<Account> findByRoleAndEmailContainingIgnoreCase(int role, String emailKeyword, Pageable pageable);

    // Search theo tên (theo role)
    Page<Account> findByRoleAndFullNameContainingIgnoreCase(int role, String nameKeyword, Pageable pageable);

    // Search theo status + email
    Page<Account> findByRoleAndStatusAndEmailContainingIgnoreCase(int role, int status, String emailKeyword, Pageable pageable);

    // Search theo status + tên
    Page<Account> findByRoleAndStatusAndFullNameContainingIgnoreCase(int role, int status, String nameKeyword, Pageable pageable);

    @Query("SELECT a FROM Account a " +
            "JOIN a.ward w " +
            "JOIN w.province p " +
            "WHERE a.role = 2 " +
            "AND p.provinceId = (" +
            "   SELECT p2.provinceId FROM Bin b2 " +
            "   JOIN b2.ward w2 " +
            "   JOIN w2.province p2 " +
            "   WHERE b2.binID = :binId )")
    List<Account> findManagersSameProvinceByBin(@Param("binId") int binId);

}
