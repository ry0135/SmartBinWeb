package com.example.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.Date;
import javax.persistence.*;

@Entity
@Table(name = "Accounts")
public class Account {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "AccountID")
    private int accountId;

    @Column(name = "FullName", length = 100, nullable = false)
    private String fullName;

    @Column(name = "Email", length = 100, unique = true, nullable = false)
    private String email;

    @JsonIgnore // Không để password lộ ra ngoài JSON
    @Column(name = "Password", length = 255, nullable = false)
    private String password;

    @Column(name = "Role")
    private int role; // 1 = Admin, 2 = Nhân viên, 3 = Người dân

    @Column(name = "Status")
    private int status; // 1 = hoạt động, 0 = khóa

    @Column(name = "Code")
    private String code;

    @Column(name = "WardID")
    private int wardID;

    @JsonIgnore
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CreatedAt", updatable = false)
    private Date createdAt;

    @Column(name = "IsVerified")
    private Boolean isVerified;

    @Column(name = "fcm_token")
    private String fcmToken;

    // Relationship với Ward
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "WardID", insertable = false, updatable = false)
    @JsonIgnore   // thêm cái này
    private Ward ward;

    // Field tạm (không lưu DB)
    @Transient
    private int taskCount;

    // ========== Constructors ==========
    public Account() {
    }

    public Account(String email, String code) {
        this.email = email;
        this.code = code;
    }

    public Account(String email, String code, Boolean isVerified) {
        this.email = email;
        this.code = code;
        this.isVerified = isVerified;
    }

    // ========== Getters & Setters ==========
    public int getAccountId() {
        return accountId;
    }
    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getFullName() {
        return fullName;
    }
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    public int getRole() {
        return role;
    }
    public void setRole(int role) {
        this.role = role;
    }

    public String getCode() {
        return code;
    }
    public void setCode(String code) {
        this.code = code;
    }

    public int getWardID() {
        return wardID;
    }
    public void setWardID(int wardID) {
        this.wardID = wardID;
    }

    public int getStatus() {
        return status;
    }
    public void setStatus(int status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    @PrePersist
    protected void onCreate() {
        this.createdAt = new Date();
    }

    public Boolean getIsVerified() {
        return isVerified;
    }
    public void setIsVerified(Boolean isVerified) {
        this.isVerified = isVerified;
    }

    public Ward getWard() {
        return ward;
    }
    public void setWard(Ward ward) {
        this.ward = ward;
    }

    public int getTaskCount() {
        return taskCount;
    }
    public void setTaskCount(int taskCount) {
        this.taskCount = taskCount;
    }

    public String getFcmToken() {
        return fcmToken;
    }

    public void setFcmToken(String fcmToken) {
        this.fcmToken = fcmToken;
    }
}
