package com.blooddonor.service;

import com.blooddonor.entity.BloodRequest;
import com.blooddonor.entity.DonationHistory;
import com.blooddonor.entity.Donor;
import com.blooddonor.entity.User;
import com.blooddonor.repository.BloodRequestRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class BloodRequestService {

    private static final Logger log = LoggerFactory.getLogger(BloodRequestService.class);

    @Autowired
    private BloodRequestRepository bloodRequestRepository;

    @Autowired
    @Lazy
    private DonationHistoryService donationHistoryService;

    @Autowired
    @Lazy
    private DonorService donorService;

    @Autowired
    @Lazy
    private TransportService transportService;

    @Autowired
    @Lazy
    private UserService userService;

    @Autowired
    private EmailNotificationService notificationService;

    /**
     * Create a new blood request.
     */
    public BloodRequest createRequest(BloodRequest request) {
        BloodRequest saved = bloodRequestRepository.save(request);
        log.info("Blood request created: ID={}, BloodGroup={}, Urgency={}",
                saved.getId(), saved.getBloodGroup(), saved.getUrgencyLevel());
        
        // Notify all donors
        try {
            List<Donor> donors = donorService.findAll();
            for (Donor donor : donors) {
                notificationService.sendBloodRequestEmail(donor.getUser(), saved);
            }
        } catch (Exception e) {
            log.error("Failed to notify all donors for request {}: {}", saved.getId(), e.getMessage());
        }
        
        return saved;
    }

    public BloodRequest save(BloodRequest request) {
        return bloodRequestRepository.save(request);
    }

    /**
     * Get all requests ordered by newest first.
     */
    @Transactional(readOnly = true)
    public List<BloodRequest> findAllOrderedByDate() {
        return bloodRequestRepository.findByOrderByCreatedAtDesc();
    }

    @Transactional(readOnly = true)
    public List<BloodRequest> findByStatus(BloodRequest.RequestStatus status) {
        return bloodRequestRepository.findByStatus(status);
    }

    /**
     * Find requests by city and status.
     */
    @Transactional(readOnly = true)
    public List<BloodRequest> findByCityAndStatus(String city, BloodRequest.RequestStatus status) {
        return bloodRequestRepository.findByCityAndStatus(city, status);
    }

    /**
     * Find requests by user.
     */
    @Transactional(readOnly = true)
    public List<BloodRequest> findByUserId(Long userId) {
        return bloodRequestRepository.findByCreatedBy_IdOrderByCreatedAtDesc(userId);
    }

    @Transactional(readOnly = true)
    public List<BloodRequest> findIncomingByHospital(String hospitalName) {
        return bloodRequestRepository.findByHospitalNameAndStatusIn(hospitalName, 
                List.of(BloodRequest.RequestStatus.ACCEPTED, 
                        BloodRequest.RequestStatus.ON_THE_WAY, 
                        BloodRequest.RequestStatus.REACHED_HOSPITAL));
    }

    @Transactional(readOnly = true)
    public List<BloodRequest> findActiveByDonor(Long donorId) {
        return bloodRequestRepository.findByAcceptedBy_IdAndStatusIn(donorId, 
                List.of(BloodRequest.RequestStatus.ACCEPTED, 
                        BloodRequest.RequestStatus.ON_THE_WAY, 
                        BloodRequest.RequestStatus.REACHED_HOSPITAL));
    }

    /**
     * Find by ID.
     */
    @Transactional(readOnly = true)
    public Optional<BloodRequest> findById(Long id) {
        return bloodRequestRepository.findById(id);
    }

    /**
     * Update request status.
     */
    public BloodRequest updateStatus(Long id, BloodRequest.RequestStatus status) {
        BloodRequest request = bloodRequestRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Request not found: " + id));
        
        // If transitioning to FULFILLED, update donor stats
        if (status == BloodRequest.RequestStatus.FULFILLED && request.getStatus() != BloodRequest.RequestStatus.FULFILLED) {
            handleFulfillment(request);
        }

        request.setStatus(status);
        log.info("Blood request {} status updated to {}", id, status);
        return bloodRequestRepository.save(request);
    }

    private void handleFulfillment(BloodRequest request) {
        User acceptingUser = request.getAcceptedBy();
        if (acceptingUser == null) return;

        Optional<Donor> donorOpt = donorService.findByUser(acceptingUser);
        if (donorOpt.isPresent()) {
            Donor donor = donorOpt.get();
            
            // 1. Update Donor Statistics
            donor.setTotalDonations(donor.getTotalDonations() + 1);
            donor.setLastDonationDate(LocalDate.now());
            donor.updateBadge();
            donorService.saveDonor(donor);

            // 2. Create Donation History Record
            DonationHistory history = new DonationHistory();
            history.setHospitalName(request.getHospitalName());
            history.setPatientName(request.getPatientName());
            history.setUnitsDonated(1); // Default to 1 unit
            donationHistoryService.recordDonation(history, donor);
            
            log.info("Fulfillment side effects completed for request {} and donor {}", 
                    request.getId(), donor.getId());
        }
    }

    /**
     * Get pending request count.
     */
    @Transactional(readOnly = true)
    public long getPendingCount() {
        return bloodRequestRepository.countByStatus(BloodRequest.RequestStatus.PENDING);
    }

    /**
     * Get fulfilled request count (lives saved).
     */
    @Transactional(readOnly = true)
    public long getFulfilledCount() {
        return bloodRequestRepository.countByStatus(BloodRequest.RequestStatus.FULFILLED);
    }

    /**
     * Get total request count.
     */
    @Transactional(readOnly = true)
    public long getTotalCount() {
        return bloodRequestRepository.count();
    }

    /**
     * Accept a blood request.
     */
    public BloodRequest acceptRequest(Long requestId, User donor) {
        BloodRequest request = bloodRequestRepository.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException("Request not found"));
        
        if (request.getStatus() != BloodRequest.RequestStatus.PENDING) {
            throw new IllegalStateException("Request is already " + request.getStatus());
        }

        request.setAcceptedBy(donor);
        request.setStatus(BloodRequest.RequestStatus.ACCEPTED);
        
        // Generate a 6-digit internal handshake code
        String code = String.valueOf((int)(Math.random() * 900000) + 100000);
        request.setVerificationCode(code);
        
        log.info("Request {} accepted by donor {}. Code generated.", requestId, donor.getEmail());
        BloodRequest saved = bloodRequestRepository.save(request);

        // Notify patient/organizer
        try {
            notificationService.sendDonorAcceptedEmail(saved.getCreatedBy(), donor, saved);
        } catch (Exception e) {
            log.error("Failed to notify patient for accepted request {}: {}", saved.getId(), e.getMessage());
        }

        return saved;
    }

    /**
     * Patient fulfills request via a mutual handshake code.
     */
    public void fulfillByPatient(Long requestId, String code) {
        BloodRequest request = bloodRequestRepository.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException("Request not found"));
        
        if (request.getVerificationCode() == null || !request.getVerificationCode().equals(code)) {
            throw new IllegalArgumentException("Invalid Handshake Code. Please ask the donor for the correct code.");
        }

        updateStatus(requestId, BloodRequest.RequestStatus.FULFILLED);
        log.info("Request {} fulfilled via patient-donor handshake.", requestId);
    }


    /**
     * Update live tracking location.
     */
    public BloodRequest updateLiveLocation(Long requestId, Double lat, Double lon, String eta, Double distance) {
        BloodRequest request = bloodRequestRepository.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException("Request not found"));
        
        request.setLiveLatitude(lat);
        request.setLiveLongitude(lon);
        if (eta != null) request.setEta(eta);
        if (distance != null) request.setDistance(distance);
        
        return bloodRequestRepository.save(request);
    }

    /**
     * Delete a request.
     */
    public void deleteRequest(Long id) {
        bloodRequestRepository.deleteById(id);
        log.info("Blood request deleted: ID={}", id);
    }
}
