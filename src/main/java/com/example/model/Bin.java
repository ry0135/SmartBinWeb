package com.example.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Bins")
public class Bin {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "BinID")
    private int binId;

    @Column(name = "BinCode", length = 50, nullable = false, unique = true)
    private String binCode;

    @Column(name = "Street", length = 255)
    private String street;

    @Column(name = "Ward", length = 255)
    private String ward;

    @Column(name = "City", length = 255)
    private String city;

    @Column(name = "Latitude")
    private double latitude;

    @Column(name = "Longitude")
    private double longitude;

    @Column(name = "Capacity")
    private double capacity;

    @Column(name = "CurrentFill", columnDefinition = "FLOAT DEFAULT 0")
    private double currentFill = 0;

    @Column(name = "Status", columnDefinition = "INT DEFAULT 1")
    private int status = 1; // 1 = hoạt động, 0 = bảo trì, 2 = đầy

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "LastUpdated", columnDefinition = "DATETIME DEFAULT GETDATE()")
    private Date lastUpdated = new Date();




    // Getters và Setters
    public int getBinId() {
        return binId;
    }
    public void setBinId(int binId) {
        this.binId = binId;
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

    public String getWard() {
        return ward;
    }
    public void setWard(String ward) {
        this.ward = ward;
    }

    public String getCity() {
        return city;
    }
    public void setCity(String city) {
        this.city = city;
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

}
