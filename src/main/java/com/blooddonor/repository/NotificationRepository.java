package com.blooddonor.repository;

import com.blooddonor.entity.Notification;
import com.blooddonor.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByUserOrderByCreatedTimeDesc(User user);
    long countByUserAndReadStatusFalse(User user);
}
