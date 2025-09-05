package com.example.model;


import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Bins")
public class Bin {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int binID;

    @Column(unique = true)
    private String binCode;

    private String street;
    private String ward;
    private String city;

    private double latitude;
    private double longitude;

    private double capacity;
    private double currentFill;

    private int status;

    @Temporal(TemporalType.TIMESTAMP)
    private Date lastUpdated = new Date();

    // ====== GETTER & SETTER ======
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

