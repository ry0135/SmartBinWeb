package com.example.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Bins")
public class Bin {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "BinID")
    private int binID;

    @Column(name = "BinCode", length = 50, unique = true, nullable = false)
    private String binCode;

    @Column(name = "Street", length = 255)
    private String street;

    @Column(name = "WardID") // Sửa từ "Ward" thành "WardID"
    private int wardID; // Sửa từ ward thành wardID

    @Column(name = "Latitude")
    private double latitude;

    @Column(name = "Longitude")
    private double longitude;

    @Column(name = "Capacity")
    private double capacity;

    @Column(name = "CurrentFill")
    private double currentFill;

    @Column(name = "Status")
    private int status;  // 1 = hoạt động, 0 = bảo trì, 2 = đầy

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "LastUpdated")
    private Date lastUpdated = new Date();

    // Thêm relationship với Ward
    @ManyToOne(fetch = FetchType.EAGER) // Thay LAZY bằng EAGER
    @JoinColumn(name = "WardID", insertable = false, updatable = false)
    private Ward ward;

    // Getters và Setters
    public int getBinID() {
        return binID;
    }
    public void setBinID(int binID) {
        this.binID = binID;
    }

    public String getBinCode() {
        return binCode;
    }
    public void setBinCode(String binCode) {
        this.binCode = binCode;
    }

    public String getStreet() {
        return street;
    }
    public void setStreet(String street) {
        this.street = street;
    }

    public int getWardID() {
        return wardID;
    }
    public void setWardID(int wardID) {
        this.wardID = wardID;
    }

    public double getLatitude() {
        return latitude;
    }
    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }
    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public double getCapacity() {
        return capacity;
    }
    public void setCapacity(double capacity) {
        this.capacity = capacity;
    }

    public double getCurrentFill() {
        return currentFill;
    }
    public void setCurrentFill(double currentFill) {
        this.currentFill = currentFill;
    }

    public int getStatus() {
        return status;
    }
    public void setStatus(int status) {
        this.status = status;
    }

    public Date getLastUpdated() {
        return lastUpdated;
    }
    public void setLastUpdated(Date lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public Ward getWard() {
        return ward;
    }
    public void setWard(Ward ward) {
        this.ward = ward;
    }

    // Thêm phương thức getWardName() để tương thích với code cũ
    public String getWardName() {
        return ward != null ? ward.getWardName() : "";
    }

    // Thêm phương thức getCity() để tương thích với code cũ
    public String getCity() {
        return ward != null && ward.getProvince() != null ? ward.getProvince().getProvinceName() : "";
    }
}