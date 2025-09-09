package com.example.model;


import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "Provinces")
public class Province {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // IDENTITY cho SQL Server
    @Column(name = "ProvinceID")
    private Long provinceId;

    @Column(name = "ProvinceName", nullable = false, length = 200)
    private String provinceName;

    @OneToMany(mappedBy = "province", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JsonIgnore
    private List<Ward> wards;

    // Getter & Setter
    public Long getProvinceId() {
        return provinceId;
    }

    public void setProvinceId(Long provinceId) {
        this.provinceId = provinceId;
    }

    public String getProvinceName() {
        return provinceName;
    }

    public void setProvinceName(String provinceName) {
        this.provinceName = provinceName;
    }

    public List<Ward> getWards() {
        return wards;
    }

    public void setWards(List<Ward> wards) {
        this.wards = wards;
    }
}
