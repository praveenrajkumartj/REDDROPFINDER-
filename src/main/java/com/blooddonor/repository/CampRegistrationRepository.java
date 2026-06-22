package com.blooddonor.repository;


import com.blooddonor.entity.BloodCamp;
import com.blooddonor.entity.CampRegistration;
import com.blooddonor.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CampRegistrationRepository extends JpaRepository<CampRegistration, Long> {
    boolean existsByUserAndBloodCamp(User user, BloodCamp bloodCamp);
    List<CampRegistration> findByUser(User user);
    
    // Find all registrations for a specific camp date (for reminders)
    List<CampRegistration> findByBloodCampDate(java.time.LocalDate date);

    @Query("SELECT u.name, u.email, u.phone, u.city, d.bloodGroup " +
           "FROM CampRegistration r JOIN r.user u LEFT JOIN u.donor d " +
           "WHERE r.bloodCamp.id = :campId")
    List<Object[]> findRawParticipantsByCampId(@Param("campId") Long campId);
    
    List<CampRegistration> findByBloodCamp(BloodCamp bloodCamp);
    int countByBloodCamp(BloodCamp bloodCamp);
}
