package com.blooddonor.repository;

import com.blooddonor.entity.BloodRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * Repository for BloodRequest entity.
 */
@Repository
public interface BloodRequestRepository extends JpaRepository<BloodRequest, Long> {

    List<BloodRequest> findByStatus(BloodRequest.RequestStatus status);

    List<BloodRequest> findByBloodGroup(String bloodGroup);

    List<BloodRequest> findByCity(String city);

    List<BloodRequest> findByBloodGroupAndCity(String bloodGroup, String city);

    List<BloodRequest> findByCreatedBy_IdOrderByCreatedAtDesc(Long userId);

    long countByStatus(BloodRequest.RequestStatus status);
    List<BloodRequest> findByCityAndStatus(String city, BloodRequest.RequestStatus status);
    List<BloodRequest> findByHospitalNameAndStatusIn(String hospitalName, List<BloodRequest.RequestStatus> statuses);
    List<BloodRequest> findByAcceptedBy_IdAndStatusIn(Long userId, List<BloodRequest.RequestStatus> statuses);
    List<BloodRequest> findByOrderByCreatedAtDesc();
}
