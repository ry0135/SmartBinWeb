package com.example.repository;

import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Repository
public class TaskGateway {

    @PersistenceContext
    private EntityManager em;

    public long countByBinId(int binId) {
        Number n = (Number) em.createNativeQuery(
                        "SELECT COUNT(*) FROM Tasks WHERE BinID = :binId"
                ).setParameter("binId", binId)
                .getSingleResult();
        return n.longValue();
    }
}
