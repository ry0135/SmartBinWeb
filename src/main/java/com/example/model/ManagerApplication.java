package com.example.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "ManagerApplications")
public class ManagerApplication {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ApplicationID")
    private int applicationId;

    @Column(name = "FullName", nullable = false, length = 100)
    private String fullName;

    @Column(name = "Email", nullable = false, length = 100)
    private String email;

    @Column(name = "Phone", length = 20)
    private String phone;

    @Column(name = "Address", length = 255)
    private String address;

    @Column(name = "WardID", nullable = false)
    private int wardID;

    @Column(name = "ContractPath", length = 255)
    private String contractPath;

    @Column(name = "CMNDPath", length = 255)
    private String cmndPath;

    @Column(name = "Status")
    private int status;   // 0=Pending, 2=Approved, 3=Rejected

    @Column(name = "AdminNotes", length = 500)
    private String adminNotes;

    @Column(name = "RejectionReason", length = 500)
    private String rejectionReason;

    @Column(name = "AccountID")
    private Integer accountId;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CreatedAt", updatable = false)
    private Date createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = new Date();
    }

    // ===== Getters/Setters =====
    public int getApplicationId() { return applicationId; }
    public void setApplicationId(int applicationId) { this.applicationId = applicationId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public int getWardID() { return wardID; }
    public void setWardID(int wardID) { this.wardID = wardID; }

    public String getContractPath() { return contractPath; }
    public void setContractPath(String contractPath) { this.contractPath = contractPath; }

    public String getCmndPath() { return cmndPath; }
    public void setCmndPath(String cmndPath) { this.cmndPath = cmndPath; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public String getAdminNotes() { return adminNotes; }
    public void setAdminNotes(String adminNotes) { this.adminNotes = adminNotes; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public Integer getAccountId() { return accountId; }
    public void setAccountId(Integer accountId) { this.accountId = accountId; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
