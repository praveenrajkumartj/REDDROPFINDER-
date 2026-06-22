package com.blooddonor.repository;

import com.blooddonor.entity.User;
import com.blooddonor.entity.Volunteer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.List;

@Repository
public interface VolunteerRepository extends JpaRepository<Volunteer, Long> {
    Optional<Volunteer> findByUser(User user);
    Optional<Volunteer> findByUser_Id(Long userId);
    List<Volunteer> findByAvailabilityStatus(Volunteer.AvailabilityStatus status);
}
