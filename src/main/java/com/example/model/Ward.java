package com.example.model;

import javax.persistence.*;

@Entity
@Table(name = "Wards")
public class Ward {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "WardID")
    private Long wardId;

    @Column(name = "WardName", nullable = false, length = 200)
    private String wardName;

    @ManyToOne
    @JoinColumn(name = "ProvinceID", nullable = false)
    private Province province;

    // Getter & Setter
    public Long getWardId() {
        return wardId;
    }

    public void setWardId(Long wardId) {
        this.wardId = wardId;
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
