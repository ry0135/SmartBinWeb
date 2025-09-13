package com.example.dto;

import java.util.Date;

public class BinDTO {
    private int binId;
    private String binCode;
    private double latitude;
    private double longitude;
    private double capacity;
    private double currentFill;

    private String street;
    private String wardName;
    private String provinceName;

    private int status;       // 1 = hoạt động, 0 = bảo trì, 2 = đầy
    private Date lastUpdated; // timestamp millis hoặc epoch second

    public BinDTO() {}

    public BinDTO(int binId, String binCode, double latitude, double longitude,
                  double capacity, double currentFill,
                  String street, String wardName, String provinceName,
                  int status, Date lastUpdated) {
        this.binId = binId;
        this.binCode = binCode;
        this.latitude = latitude;
        this.longitude = longitude;
        this.capacity = capacity;
        this.currentFill = currentFill;
        this.street = street;
        this.wardName = wardName;
        this.provinceName = provinceName;
        this.status = status;
        this.lastUpdated = lastUpdated;
    }

    // Getters & Setters
    public int getBinId() { return binId; }
    public void setBinId(int binId) { this.binId = binId; }

    public String getBinCode() { return binCode; }
    public void setBinCode(String binCode) { this.binCode = binCode; }

    public double getLatitude() { return latitude; }
    public void setLatitude(double latitude) { this.latitude = latitude; }

    public double getLongitude() { return longitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }

    public double getCapacity() { return capacity; }
    public void setCapacity(double capacity) { this.capacity = capacity; }

    public double getCurrentFill() { return currentFill; }
    public void setCurrentFill(double currentFill) { this.currentFill = currentFill; }

    public String getStreet() { return street; }
    public void setStreet(String street) { this.street = street; }

    public String getWardName() { return wardName; }
    public void setWardName(String wardName) { this.wardName = wardName; }

    public String getProvinceName() { return provinceName; }
    public void setProvinceName(String provinceName) { this.provinceName = provinceName; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public Date getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(Date lastUpdated) { this.lastUpdated = lastUpdated; }


}
