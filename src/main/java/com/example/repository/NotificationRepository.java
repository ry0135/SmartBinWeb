package com.example.repository;
import com.example.model.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Integer> {
    List<Notification> findByReceiverIdOrderByCreatedAtDesc(Integer receiverId);
    @Query("SELECT COUNT(n) FROM Notification n WHERE n.receiverId = :receiverId AND n.isRead = false")
    int countUnreadByUserId(@Param("receiverId") Integer receiverId);



        boolean existsByReceiverIdAndType(Integer receiverId, String type);


}
