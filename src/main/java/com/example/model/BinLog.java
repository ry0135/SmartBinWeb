package com.example.model;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Date;

@Entity
@Table(name = "BinLog")
public class BinLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int logId;

    private int binId;

    @Column(name = "CurrentFill")
    private double currentFill;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "RecordedAt", insertable = false, updatable = false)
    private Date recordedAt;

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getBinId() {
        return binId;
    }

    public void setBinId(int binId) {
        this.binId = binId;
    }

    public double getCurrentFill() {
        return currentFill;
    }

    public void setCurrentFill(double currentFill) {
        this.currentFill = currentFill;
    }

    public Date getRecordedAt() {
        return recordedAt;
    }

    public void setRecordedAt(Date recordedAt) {
        this.recordedAt = recordedAt;
    }

    // Getter & Setter
}
