package com.blooddonor.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "blood_requests")
public class BloodRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "patient_name", nullable = false)
    private String patientName;

    @Column(name = "blood_group", nullable = false)
    private String bloodGroup;

    @Column(name = "hospital_name", nullable = false)
    private String hospitalName;

    private String city;
    private Double latitude;
    private Double longitude;

    @Enumerated(EnumType.STRING)
    @Column(name = "urgency_level")
    private UrgencyLevel urgencyLevel;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private RequestStatus status = RequestStatus.PENDING;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "contact_phone")
    private String contactPhone;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by")
    private User createdBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "accepted_by")
    private User acceptedBy;

    private Double distance;
    private String eta;

    @Column(name = "live_latitude")
    private Double liveLatitude;

    @Column(name = "live_longitude")
    private Double liveLongitude;

    @Column(name = "verification_code")
    private String verificationCode;

    @PrePersist
    public void prePersist() {
        if (createdAt == null) createdAt = LocalDateTime.now();
    }

    public enum UrgencyLevel { CRITICAL, HIGH, MEDIUM, LOW }
    public enum RequestStatus { 
        PENDING, 
        ACCEPTED, 
        ON_THE_WAY, 
        REACHED_HOSPITAL, 
        FULFILLED, 
        CANCELLED 
    }

    public BloodRequest() {}

    // ===== Getters =====
    public Long getId() { return id; }
    public String getPatientName() { return patientName; }
    public String getBloodGroup() { return bloodGroup; }
    public String getHospitalName() { return hospitalName; }
    public String getCity() { return city; }
    public Double getLatitude() { return latitude; }
    public Double getLongitude() { return longitude; }
    public UrgencyLevel getUrgencyLevel() { return urgencyLevel; }
    public RequestStatus getStatus() { return status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public String getContactPhone() { return contactPhone; }
    public User getCreatedBy() { return createdBy; }
    public User getAcceptedBy() { return acceptedBy; }
    public Double getDistance() { return distance; }
    public String getEta() { return eta; }
    public Double getLiveLatitude() { return liveLatitude; }
    public Double getLiveLongitude() { return liveLongitude; }
    public String getVerificationCode() { return verificationCode; }

    // ===== Setters =====
    public void setId(Long id) { this.id = id; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
    public void setHospitalName(String hospitalName) { this.hospitalName = hospitalName; }
    public void setCity(String city) { this.city = city; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }
    public void setUrgencyLevel(UrgencyLevel urgencyLevel) { this.urgencyLevel = urgencyLevel; }
    public void setStatus(RequestStatus status) { this.status = status; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }
    public void setCreatedBy(User createdBy) { this.createdBy = createdBy; }
    public void setAcceptedBy(User acceptedBy) { this.acceptedBy = acceptedBy; }
    public void setDistance(Double distance) { this.distance = distance; }
    public void setEta(String eta) { this.eta = eta; }
    public void setLiveLatitude(Double liveLatitude) { this.liveLatitude = liveLatitude; }
    public void setLiveLongitude(Double liveLongitude) { this.liveLongitude = liveLongitude; }
    public void setVerificationCode(String verificationCode) { this.verificationCode = verificationCode; }
}
