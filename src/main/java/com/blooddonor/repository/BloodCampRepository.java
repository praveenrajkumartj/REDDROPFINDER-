package com.blooddonor.repository;

import com.blooddonor.entity.BloodCamp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * Repository for BloodCamp entity.
 */
@Repository
public interface BloodCampRepository extends JpaRepository<BloodCamp, Long> {

    List<BloodCamp> findByStatus(BloodCamp.CampStatus status);

    List<BloodCamp> findByOrderByDateAsc();

    List<BloodCamp> findByStatusOrderByDateAsc(BloodCamp.CampStatus status);
    List<BloodCamp> findByStatusAndDateGreaterThanEqualOrderByDateAsc(BloodCamp.CampStatus status, java.time.LocalDate date);
    List<BloodCamp> findByCreatedByOrderByDateAsc(com.blooddonor.entity.User user);
}
