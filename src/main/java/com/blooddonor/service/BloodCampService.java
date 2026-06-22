package com.blooddonor.service;

import com.blooddonor.dto.ParticipantDTO;
import com.blooddonor.entity.BloodCamp;
import com.blooddonor.entity.CampRegistration;
import com.blooddonor.entity.User;
import com.blooddonor.repository.BloodCampRepository;
import com.blooddonor.repository.CampRegistrationRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.time.LocalDate;

@Service
@Transactional
public class BloodCampService {

    private static final Logger log = LoggerFactory.getLogger(BloodCampService.class);

    @Autowired
    private BloodCampRepository bloodCampRepository;

    @Autowired
    private CampRegistrationRepository registrationRepository;

    @Autowired
    @Lazy
    private UserService userService;

    @Autowired
    private EmailNotificationService notificationService;

    /**
     * Create or update a blood camp.
     */
    public BloodCamp saveCamp(BloodCamp camp) {
        BloodCamp saved = bloodCampRepository.save(camp);
        log.info("Blood camp saved: ID={}, Name={}", saved.getId(), saved.getCampName());
        
        // Notify all donors
        try {
            List<User> donors = userService.findAllUsers().stream()
                    .filter(u -> u.getRole() == User.Role.DONOR)
                    .toList();
            for (User donor : donors) {
                notificationService.sendBloodCampEmail(donor, saved);
            }
        } catch (Exception e) {
            log.error("Failed to send camp notifications: {}", e.getMessage());
        }
        
        return saved;
    }

    /**
     * Get all upcoming camps.
     */
    @Transactional(readOnly = true)
    public List<BloodCamp> getUpcomingCamps() {
        return bloodCampRepository.findByStatusAndDateGreaterThanEqualOrderByDateAsc(
                BloodCamp.CampStatus.UPCOMING, java.time.LocalDate.now());
    }

    /**
     * Get all camps ordered by date, with automatic status synchronization.
     */
    public List<BloodCamp> getAllCamps() {
        List<BloodCamp> camps = bloodCampRepository.findByOrderByDateAsc();
        LocalDate today = LocalDate.now();
        boolean changed = false;

        for (BloodCamp camp : camps) {
            if (camp.getDate() != null && camp.getDate().isBefore(today)) {
                if (camp.getStatus() == BloodCamp.CampStatus.UPCOMING || 
                    camp.getStatus() == BloodCamp.CampStatus.ONGOING) {
                    camp.setStatus(BloodCamp.CampStatus.COMPLETED);
                    bloodCampRepository.save(camp);
                    changed = true;
                }
            }
        }
        
        // If any status was updated, return the fresh list from DB
        return changed ? bloodCampRepository.findByOrderByDateAsc() : camps;
    }

    /**
     * Find by ID.
     */
    @Transactional(readOnly = true)
    public Optional<BloodCamp> findById(Long id) {
        return bloodCampRepository.findById(id);
    }

    /**
     * Register a participant for a camp.
     */
    public BloodCamp registerForCamp(Long campId, User user) {
        BloodCamp camp = bloodCampRepository.findById(campId)
                .orElseThrow(() -> new IllegalArgumentException("Camp not found: " + campId));

        if (registrationRepository.existsByUserAndBloodCamp(user, camp)) {
            throw new IllegalStateException("You are already registered for this camp.");
        }

        if (camp.getRegisteredCount() >= camp.getMaxParticipants()) {
            throw new IllegalStateException("Camp is fully booked.");
        }

        camp.setRegisteredCount(camp.getRegisteredCount() + 1);
        bloodCampRepository.save(camp);

        CampRegistration registration = new CampRegistration(user, camp);
        registrationRepository.save(registration);

        // Notify donor of successful enrollment
        try {
            notificationService.sendCampEnrollmentEmail(user, camp);
        } catch (Exception e) {
            log.error("Failed to send camp enrollment notification: {}", e.getMessage());
        }

        log.info("User {} registered for camp: {}", user.getEmail(), camp.getCampName());
        return camp;
    }

    @Transactional(readOnly = true)
    public List<Long> getRegisteredCampIds(User user) {
        if (user == null) return List.of();
        return registrationRepository.findByUser(user).stream()
                .map(reg -> reg.getBloodCamp().getId())
                .toList();
    }

    @Transactional(readOnly = true)
    public List<BloodCamp> getRegisteredCamps(User user) {
        if (user == null) return List.of();
        return registrationRepository.findByUser(user).stream()
                .map(reg -> reg.getBloodCamp())
                .toList();
    }

    /**
     * Delete a camp.
     */
    public void deleteCamp(Long id) {
        bloodCampRepository.deleteById(id);
        log.info("Blood camp deleted: ID={}", id);
    }

    @Transactional(readOnly = true)
    public List<BloodCamp> getCampsByCreator(User user) {
        return bloodCampRepository.findByCreatedByOrderByDateAsc(user);
    }
    
    @Transactional(readOnly = true)
    public List<ParticipantDTO> getParticipantDetailsForCamp(Long campId) {
        try {
            log.info("Starting participant fetch for campId: {}", campId);
            List<Object[]> results = registrationRepository.findRawParticipantsByCampId(campId);
            log.info("Query returned {} raw rows", results.size());
            
            return results.stream().map(row -> {
                return new ParticipantDTO(
                    (String) row[0], // name
                    (String) row[1], // email
                    (String) row[2], // phone
                    (String) row[3], // city
                    (String) row[4]  // bloodGroup
                );
            }).toList();
        } catch (Exception e) {
            log.error("CRITICAL: Error in getParticipantDetailsForCamp for ID {}: {}", campId, e.getMessage(), e);
            throw e;
        }
    }

    /**
     * Get total camp count.
     */
    @Transactional(readOnly = true)
    public long getTotalCampCount() {
        return bloodCampRepository.count();
    }
}
