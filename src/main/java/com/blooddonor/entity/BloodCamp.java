package com.blooddonor.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "blood_camps")
public class BloodCamp {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "camp_name", nullable = false)
    private String campName;

    @Column(nullable = false)
    private String organizer;

    @Column(nullable = false)
    private String location;

    private LocalDate date;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "max_participants")
    private Integer maxParticipants = 100;

    @Column(name = "registered_count")
    private Integer registeredCount = 0;

    @Column(name = "contact_email")
    private String contactEmail;

    @Column(name = "contact_phone")
    private String contactPhone;

    @Enumerated(EnumType.STRING)
    private CampStatus status = CampStatus.UPCOMING;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by")
    private User createdBy;

    public enum CampStatus { UPCOMING, ONGOING, COMPLETED, CANCELLED }

    public BloodCamp() {}

    // ===== Getters =====
    public Long getId() { return id; }
    public String getCampName() { return campName; }
    public String getOrganizer() { return organizer; }
    public String getLocation() { return location; }
    public LocalDate getDate() { return date; }
    public String getDescription() { return description; }
    public Integer getMaxParticipants() { return maxParticipants != null ? maxParticipants : 100; }
    public Integer getRegisteredCount() { return registeredCount != null ? registeredCount : 0; }
    public String getContactEmail() { return contactEmail; }
    public String getContactPhone() { return contactPhone; }
    public CampStatus getStatus() { return status; }
    public User getCreatedBy() { return createdBy; }

    // ===== Setters =====
    public void setId(Long id) { this.id = id; }
    public void setCampName(String campName) { this.campName = campName; }
    public void setOrganizer(String organizer) { this.organizer = organizer; }
    public void setLocation(String location) { this.location = location; }
    public void setDate(LocalDate date) { this.date = date; }
    public void setDescription(String description) { this.description = description; }
    public void setMaxParticipants(Integer maxParticipants) { this.maxParticipants = maxParticipants; }
    public void setRegisteredCount(Integer registeredCount) { this.registeredCount = registeredCount; }
    public void setContactEmail(String contactEmail) { this.contactEmail = contactEmail; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }
    public void setStatus(CampStatus status) { this.status = status; }
    public void setCreatedBy(User createdBy) { this.createdBy = createdBy; }
}
