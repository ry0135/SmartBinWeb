package com.example.model;

import javax.persistence.*;

@Entity
@Table(name = "Wards")
public class Ward {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "WardID")
    private Integer wardID;

    @Column(name = "WardName", nullable = false, length = 200)
    private String wardName;

    @ManyToOne
    @JoinColumn(name = "ProvinceID", nullable = false)
    private Province province;

    // Getter & Setter
    public Integer getWardID() {
        return wardID;
    }

    public void setWardID(Long wardId) {
        this.wardID = wardID;
    }

    public String getWardName() {
        return wardName;
    }

    public void setWardName(String wardName) {
        this.wardName = wardName;
    }

    public Province getProvince() {
        return province;
    }

    public void setProvince(Province province) {
        this.province = province;
    }
}
