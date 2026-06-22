package com.blooddonor.service;

import com.blooddonor.entity.TransportRequest;
import com.blooddonor.entity.User;
import com.blooddonor.entity.Volunteer;
import com.blooddonor.repository.TransportRequestRepository;
import com.blooddonor.repository.VolunteerRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@Transactional
public class TransportService {

    private static final Logger log = LoggerFactory.getLogger(TransportService.class);

    @Autowired
    private TransportRequestRepository transportRequestRepository;

    @Autowired
    @Lazy
    private BloodRequestService bloodRequestService;

    @Autowired
    private EmailNotificationService notificationService;

    @Autowired
    private VolunteerRepository volunteerRepository;

    public TransportRequest createTransportRequest(User donor, User hospital, Double lat, Double lon, Long bloodRequestId) {
        TransportRequest request = new TransportRequest();
        request.setDonor(donor);
        request.setHospital(hospital);
        request.setRequestLatitude(lat);
        request.setRequestLongitude(lon);
        request.setBloodRequestId(bloodRequestId);
        request.setStatus(TransportRequest.TransportStatus.PENDING);
        
        TransportRequest saved = transportRequestRepository.save(request);
        log.info("Transport request created: ID={} for Donor={}", saved.getId(), donor.getEmail());

        // Notify only the 5 nearest volunteers to avoid spam
        try {
            List<Volunteer> allVolunteers = volunteerRepository.findByAvailabilityStatus(Volunteer.AvailabilityStatus.AVAILABLE);
            
            allVolunteers.sort((v1, v2) -> {
                double d1 = calculateDistance(lat, lon, v1.getUser().getLatitude(), v1.getUser().getLongitude());
                double d2 = calculateDistance(lat, lon, v2.getUser().getLatitude(), v2.getUser().getLongitude());
                return Double.compare(d1, d2);
            });

            int count = 0;
            for (Volunteer v : allVolunteers) {
                if (count >= 5) break;
                
                double dist = calculateDistance(lat, lon, v.getUser().getLatitude(), v.getUser().getLongitude());
                notificationService.sendVolunteerAssistanceEmail(v.getUser(), saved, dist);
                count++;
            }
        } catch (Exception e) {
            log.error("Failed to notify nearest volunteers for transport request {}: {}", saved.getId(), e.getMessage());
        }

        return saved;
    }

    private double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
        if (lat1 == 0 || lon1 == 0 || lat2 == 0 || lon2 == 0) return 999;
        final int R = 6371; // Radius of the earth
        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return Math.round(R * c * 10.0) / 10.0; // Round to 1 decimal place
    }

    @Transactional(readOnly = true)
    public List<TransportRequest> findPendingRequests() {
        return transportRequestRepository.findByStatus(TransportRequest.TransportStatus.PENDING);
    }

    @Transactional(readOnly = true)
    public List<TransportRequest> findActiveForVolunteer(Volunteer volunteer) {
        return transportRequestRepository.findByVolunteerAndStatusIn(volunteer, 
                List.of(TransportRequest.TransportStatus.ACCEPTED, 
                        TransportRequest.TransportStatus.ON_THE_WAY, 
                        TransportRequest.TransportStatus.PICKED_UP,
                        TransportRequest.TransportStatus.REACHED_HOSPITAL));
    }

    public TransportRequest acceptRequest(Long requestId, Volunteer volunteer) {
        TransportRequest request = transportRequestRepository.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException("Request not found"));
        
        if (request.getStatus() != TransportRequest.TransportStatus.PENDING) {
            throw new IllegalStateException("Request already handled");
        }

        request.setVolunteer(volunteer);
        request.setStatus(TransportRequest.TransportStatus.ACCEPTED);
        volunteer.setAvailabilityStatus(Volunteer.AvailabilityStatus.BUSY);
        
        TransportRequest saved = transportRequestRepository.save(request);

        // Notify donor and hospital
        try {
            notificationService.sendVolunteerTransportEmail(saved.getDonor(), volunteer, saved);
            notificationService.sendVolunteerTransportEmail(saved.getHospital(), volunteer, saved);
        } catch (Exception e) {
            log.error("Failed to send transport notifications: {}", e.getMessage());
        }

        return saved;
    }

    public TransportRequest updateStatus(Long requestId, TransportRequest.TransportStatus status) {
        TransportRequest request = transportRequestRepository.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException("Request not found"));
        
        if (status == TransportRequest.TransportStatus.CANCELLED) {
            if (request.getVolunteer() != null) {
                Volunteer v = request.getVolunteer();
                v.setAvailabilityStatus(Volunteer.AvailabilityStatus.AVAILABLE);
                // Status is updated via dirty checking, but we ensure it's returned to pool
            }
            request.setVolunteer(null);
            request.setStatus(TransportRequest.TransportStatus.PENDING);
            log.info("Transport request {} cancelled by volunteer and returned to PENDING pool", requestId);
        } else {
            request.setStatus(status);
            if (status == TransportRequest.TransportStatus.COMPLETED) {
                if (request.getVolunteer() != null) {
                    request.getVolunteer().setAvailabilityStatus(Volunteer.AvailabilityStatus.AVAILABLE);
                }
            }
        }
        
        return transportRequestRepository.save(request);
    }

    public void updateLiveLocation(Long requestId, Double lat, Double lon, Double distance, String eta) {
        transportRequestRepository.findById(requestId).ifPresent(req -> {
            req.setLiveLatitude(lat);
            req.setLiveLongitude(lon);
            if (distance != null) req.setDistance(distance);
            if (eta != null) req.setEta(eta);
            transportRequestRepository.save(req);

            // Sync with BloodRequest tracking
            if (req.getBloodRequestId() != null) {
                bloodRequestService.updateLiveLocation(req.getBloodRequestId(), lat, lon, eta, distance);
            }
        });
    }

    @Transactional(readOnly = true)
    public List<TransportRequest> findByDonor(Long donorId) {
        return transportRequestRepository.findByDonor_IdOrderByCreatedAtDesc(donorId);
    }

    @Transactional(readOnly = true)
    public List<TransportRequest> findHistoryByVolunteer(Volunteer volunteer) {
        return transportRequestRepository.findByVolunteerOrderByCreatedAtDesc(volunteer);
    }

    public long countCompletedMissions(Volunteer volunteer) {
        return transportRequestRepository.countByVolunteerAndStatus(volunteer, TransportRequest.TransportStatus.COMPLETED);
    }
}
