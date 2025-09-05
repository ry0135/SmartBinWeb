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

    @Column(name = "BinCode", unique = true)
    private String binCode;

    @Column(name = "Street")
    private String street;

    @Column(name = "Ward")
    private String ward;

    @Column(name = "City")
    private String city;

    @Column(name = "Latitude")
    private double latitude;

    @Column(name = "Longitude")
    private double longitude;

    @Column(name = "Capacity")
    private double capacity;

    @Column(name = "CurrentFill")
    private double currentFill;



    @Column(name = "Status")
    private int status;  // 0: Bảo trì, 1: Hoạt động, 2: Đầy

    @Column(name = "LastUpdated")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastUpdated;

    // Getters
    public int getBinId() {
        return binId;
    }

    public String getBinCode() {
        return binCode;
    }

    public String getStreet() {
        return street;
    }

    public String getWard() {
        return ward;
    }

    public String getCity() {
        return city;
    }

    public double getLatitude() {
        return latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public double getCapacity() {
        return capacity;
    }

    public double getCurrentFill() {
        return currentFill;
    }


    public int getStatus() {
        return status;
    }

    public Date getLastUpdated() {
        return lastUpdated;
    }

    // Setters
    public void setBinId(int binId) {
        this.binId = binId;
    }

    public void setBinCode(String binCode) {
        this.binCode = binCode;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public void setCapacity(double capacity) {
        this.capacity = capacity;
    }

    public void setCurrentFill(double currentFill) {
        this.currentFill = currentFill;
    }



    public void setStatus(int status) {
        this.status = status;
    }

    public void setLastUpdated(Date lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
// Generate getters and setters (Alt + Insert)
}