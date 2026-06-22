package com.blooddonor.repository;

import com.blooddonor.entity.TransportRequest;
import com.blooddonor.entity.Volunteer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface TransportRequestRepository extends JpaRepository<TransportRequest, Long> {
    List<TransportRequest> findByVolunteerAndStatusIn(Volunteer volunteer, List<TransportRequest.TransportStatus> statuses);
    List<TransportRequest> findByStatus(TransportRequest.TransportStatus status);
    List<TransportRequest> findByDonor_IdOrderByCreatedAtDesc(Long donorId);
    List<TransportRequest> findByBloodRequestId(Long bloodRequestId);
    List<TransportRequest> findByVolunteerOrderByCreatedAtDesc(Volunteer volunteer);
    long countByVolunteerAndStatus(Volunteer volunteer, TransportRequest.TransportStatus status);
}
