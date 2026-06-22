package com.blooddonor.service;

import com.blooddonor.entity.Donor;
import com.blooddonor.entity.User;
import com.blooddonor.repository.DonorRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class DonorService {

    private static final Logger log = LoggerFactory.getLogger(DonorService.class);

    @Autowired
    private DonorRepository donorRepository;

    /**
     * Save or update a donor profile.
     */
    public Donor saveDonor(Donor donor) {
        donor.updateBadge();
        return donorRepository.save(donor);
    }

    /**
     * Find donor by User.
     */
    @Transactional(readOnly = true)
    public Optional<Donor> findByUser(User user) {
        return donorRepository.findByUser(user);
    }

    /**
     * Find donor by User ID.
     */
    @Transactional(readOnly = true)
    public Optional<Donor> findByUserId(Long userId) {
        return donorRepository.findByUser_Id(userId);
    }

    /**
     * Get all donors.
     */
    @Transactional(readOnly = true)
    public List<Donor> findAll() {
        return donorRepository.findAll();
    }

    /**
     * Smart Emergency Matching:
     * Ranks donors based on:
     * 1. City match (priority)
     * 2. Availability
     * 3. Last donation date (longest ago = most eligible)
     */
    @Transactional(readOnly = true)
    public List<Donor> findMatchingDonors(String bloodGroup, String city) {
        return donorRepository.findAvailableDonorsByBloodGroupAndCity(bloodGroup, city).stream()
                .filter(Donor::isEligibleToDonate)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<Donor> findAvailableDonorsByBloodGroupAndCity(String bloodGroup, String city) {
        return donorRepository.findAvailableDonorsByBloodGroupAndCity(bloodGroup, city);
    }

    /**
     * Find nearest available donors using Haversine formula.
     */
    @Transactional(readOnly = true)
    public List<Donor> findNearestDonors(String bloodGroup, Double lat, Double lon) {
        List<Donor> donors = donorRepository.findAvailableDonorsByBloodGroup(bloodGroup);
        
        if (lat != null && lon != null) {
            donors.forEach(donor -> {
                User u = donor.getUser();
                if (u.getLatitude() != null && u.getLongitude() != null) {
                    donor.setDistance(calculateDistance(lat, lon, u.getLatitude(), u.getLongitude()));
                } else {
                    donor.setDistance(9999.0); // Unknown distance
                }
            });
            
            return donors.stream()
                    .filter(Donor::isEligibleToDonate)
                    .sorted((d1, d2) -> Double.compare(d1.getDistance(), d2.getDistance()))
                    .toList();
        }
        
        return donors.stream()
                .filter(Donor::isEligibleToDonate)
                .toList();
    }

    private double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371; // Earth radius in km
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    /**
     * Toggle donor availability status.
     */
    public Donor toggleAvailability(Long donorId) {
        Donor donor = donorRepository.findById(donorId)
                .orElseThrow(() -> new IllegalArgumentException("Donor not found: " + donorId));

        if (donor.getAvailabilityStatus() == Donor.AvailabilityStatus.AVAILABLE) {
            donor.setAvailabilityStatus(Donor.AvailabilityStatus.NOT_AVAILABLE);
        } else {
            donor.setAvailabilityStatus(Donor.AvailabilityStatus.AVAILABLE);
        }

        log.info("Donor {} availability toggled to {}", donorId, donor.getAvailabilityStatus());
        return donorRepository.save(donor);
    }

    /**
     * Check if donor is eligible to donate.
     */
    @Transactional(readOnly = true)
    public boolean isEligible(Long donorId) {
        return donorRepository.findById(donorId)
                .map(Donor::isEligibleToDonate)
                .orElse(false);
    }

    /**
     * Get total available donor count.
     */
    @Transactional(readOnly = true)
    public long countAvailableDonors() {
        return donorRepository.countByAvailabilityStatus(Donor.AvailabilityStatus.AVAILABLE);
    }

    /**
     * Get total donor count.
     */
    @Transactional(readOnly = true)
    public long getTotalDonorCount() {
        return donorRepository.count();
    }

    /**
     * Sum of all 'totalDonations' across all donor profiles.
     */
    @Transactional(readOnly = true)
    public long getGlobalDonationCount() {
        Long sum = donorRepository.sumTotalDonations();
        return (sum != null) ? sum : 0L;
    }
}
