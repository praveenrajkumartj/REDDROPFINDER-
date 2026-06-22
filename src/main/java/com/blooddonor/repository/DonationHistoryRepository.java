package com.blooddonor.repository;

import com.blooddonor.entity.DonationHistory;
import com.blooddonor.entity.Donor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * Repository for DonationHistory entity.
 */
@Repository
public interface DonationHistoryRepository extends JpaRepository<DonationHistory, Long> {

    List<DonationHistory> findByDonorOrderByDonationDateDesc(Donor donor);

    List<DonationHistory> findByDonor_Id(Long donorId);

    long countByDonor(Donor donor);

    List<DonationHistory> findByOrderByDonationDateDesc();

    java.util.Optional<DonationHistory> findByCertificateNumber(String certificateNumber);
}
