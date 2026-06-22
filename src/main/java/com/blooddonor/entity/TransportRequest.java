package com.blooddonor.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "transport_requests")
public class TransportRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "donor_id", nullable = false)
    private User donor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hospital_id", nullable = false)
    private User hospital;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "volunteer_id")
    private Volunteer volunteer;

    @Column(name = "request_latitude")
    private Double requestLatitude;

    @Column(name = "request_longitude")
    private Double requestLongitude;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private TransportStatus status = TransportStatus.PENDING;

    @Column(name = "live_latitude")
    private Double liveLatitude;

    @Column(name = "live_longitude")
    private Double liveLongitude;

    private Double distance;
    private String eta;

    @Column(name = "blood_request_id")
    private Long bloodRequestId;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    public enum TransportStatus { 
        PENDING, ACCEPTED, ON_THE_WAY, PICKED_UP, REACHED_HOSPITAL, COMPLETED, CANCELLED 
    }

    @PrePersist
    public void prePersist() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }

    public TransportRequest() {}

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getDonor() { return donor; }
    public void setDonor(User donor) { this.donor = donor; }

    public User getHospital() { return hospital; }
    public void setHospital(User hospital) { this.hospital = hospital; }

    public Volunteer getVolunteer() { return volunteer; }
    public void setVolunteer(Volunteer volunteer) { this.volunteer = volunteer; }

    public Double getRequestLatitude() { return requestLatitude; }
    public void setRequestLatitude(Double requestLatitude) { this.requestLatitude = requestLatitude; }

    public Double getRequestLongitude() { return requestLongitude; }
    public void setRequestLongitude(Double requestLongitude) { this.requestLongitude = requestLongitude; }

    public TransportStatus getStatus() { return status; }
    public void setStatus(TransportStatus status) { this.status = status; }

    public Double getLiveLatitude() { return liveLatitude; }
    public void setLiveLatitude(Double liveLatitude) { this.liveLatitude = liveLatitude; }

    public Double getLiveLongitude() { return liveLongitude; }
    public void setLiveLongitude(Double liveLongitude) { this.liveLongitude = liveLongitude; }

    public Double getDistance() { return distance; }
    public void setDistance(Double distance) { this.distance = distance; }

    public String getEta() { return eta; }
    public void setEta(String eta) { this.eta = eta; }

    public Long getBloodRequestId() { return bloodRequestId; }
    public void setBloodRequestId(Long bloodRequestId) { this.bloodRequestId = bloodRequestId; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
