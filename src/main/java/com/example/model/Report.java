package com.example.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Reports")
public class Report {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ReportID")
    private int reportID;

    @Column(name = "BinID", nullable = false)
    private int binID;

    @Column(name = "AccountID", nullable = false)
    private int accountID;

    @Column(name = "ReportType", length = 50, nullable = false)
    private String reportType;

    @Column(name = "Description", length = 1000)
    private String description;

    @Column(name = "Status", length = 20, nullable = false)
    private String status;

    @Column(name = "AssignedTo")
    private Integer assignedTo;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CreatedAt")
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "UpdatedAt")
    private Date updatedAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ResolvedAt")
    private Date resolvedAt;

    // ✅ Liên kết tới bảng Account, chỉ để đọc (không làm thay đổi database)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "AccountID", insertable = false, updatable = false)
    @JsonIgnore
    private Account account;

    // ===== GETTERS & SETTERS =====
    public int getReportID() {
        return reportID;
    }

    public void setReportID(int reportID) {
        this.reportID = reportID;
    }

    public int getBinID() {
        return binID;
    }

    public void setBinID(int binID) {
        this.binID = binID;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public String getReportType() {
        return reportType;
    }

    public void setReportType(String reportType) {
        this.reportType = reportType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(Integer assignedTo) {
        this.assignedTo = assignedTo;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Date getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(Date resolvedAt) {
        this.resolvedAt = resolvedAt;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }
}
