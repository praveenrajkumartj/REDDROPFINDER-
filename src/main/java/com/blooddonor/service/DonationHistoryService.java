package com.blooddonor.service;

import com.blooddonor.entity.DonationHistory;
import com.blooddonor.entity.Donor;
import com.blooddonor.repository.DonationHistoryRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import com.blooddonor.service.EmailNotificationService;

@Service
@Transactional
public class DonationHistoryService {

    private static final Logger log = LoggerFactory.getLogger(DonationHistoryService.class);

    @Autowired
    private DonationHistoryRepository donationHistoryRepository;

    @Autowired
    private EmailNotificationService notificationService;

    /**
     * Record a new donation.
     */
    public DonationHistory recordDonation(DonationHistory history, Donor donor) {
        history.setDonor(donor);
        history.setDonationDate(LocalDate.now());
        history.setBloodGroup(donor.getBloodGroup());
        // Generate a certificate number
        history.setCertificateNumber("CERT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());

        DonationHistory saved = donationHistoryRepository.save(history);
        log.info("Donation recorded for donor ID={}, Hospital={}",
                donor.getId(), history.getHospitalName());

        // Send thank you email
        try {
            notificationService.sendDonationCompletedEmail(donor.getUser(), saved);
        } catch (Exception e) {
            log.error("Failed to send thank you email: {}", e.getMessage());
        }

        return saved;
    }

    /**
     * Get donation history for a donor.
     */
    @Transactional(readOnly = true)
    public List<DonationHistory> findByDonor(Donor donor) {
        return donationHistoryRepository.findByDonorOrderByDonationDateDesc(donor);
    }

    /**
     * Get donation history by donor ID.
     */
    @Transactional(readOnly = true)
    public List<DonationHistory> findByDonorId(Long donorId) {
        return donationHistoryRepository.findByDonor_Id(donorId);
    }

    /**
     * Get total donation count across all donors.
     */
    @Transactional(readOnly = true)
    public long getTotalDonationCount() {
        return donationHistoryRepository.count();
    }

    /**
     * Get recent donations across the platform.
     */
    @Transactional(readOnly = true)
    public List<DonationHistory> getRecentDonations(int limit) {
        return donationHistoryRepository.findByOrderByDonationDateDesc().stream()
                .limit(limit)
                .toList();
    }

    @Transactional(readOnly = true)
    public java.util.Optional<DonationHistory> getDonationByCertificate(String certificateNumber) {
        if (certificateNumber == null || certificateNumber.isBlank()) return java.util.Optional.empty();
        return donationHistoryRepository.findByCertificateNumber(certificateNumber.trim());
    }
}
