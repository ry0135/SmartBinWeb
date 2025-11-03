

package com.example.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Feedbacks")
public class Feedback {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "FeedbackID")
    private int feedbackID;

    // Liên kết ManyToOne đến Account (người gửi feedback)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AccountID", referencedColumnName = "AccountID", insertable = false, updatable = false)
    private Account account;

    @Column(name = "AccountID")
    private Integer accountID;

    @Column(name = "WardID")
    private Integer wardID;

    // 🔹 Thêm phần liên kết tới bảng Wards (để lấy tên phường)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "WardID", referencedColumnName = "WardID", insertable = false, updatable = false)
    private Ward ward;

    @Column(name = "Rating")
    private Integer rating;

    @Column(name = "Comment")
    private String comment;

    @Column(name = "ReportID")
    private Integer reportID;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CreatedAt")
    private Date createdAt;

    @Column(name = "adminReply")
    private String adminReply;

    @Column(name = "autoReply")
    private String autoReply;

    // =================== GETTERS & SETTERS ===================

    public int getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(int feedbackID) {
        this.feedbackID = feedbackID;
    }

    public Integer getAccountID() {
        return accountID;
    }

    public void setAccountID(Integer accountID) {
        this.accountID = accountID;
    }

    public Integer getWardID() {
        return wardID;
    }

    public void setWardID(Integer wardID) {
        this.wardID = wardID;
    }

    public Ward getWard() {
        return ward;
    }

    public void setWard(Ward ward) {
        this.ward = ward;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Integer getReportID() {
        return reportID;
    }

    public void setReportID(Integer reportID) {
        this.reportID = reportID;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getAdminReply() {
        return adminReply;
    }

    public void setAdminReply(String adminReply) {
        this.adminReply = adminReply;
    }

    public String getAutoReply() {
        return autoReply;
    }

    public void setAutoReply(String autoReply) {
        this.autoReply = autoReply;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }
}
