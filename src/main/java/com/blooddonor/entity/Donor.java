package com.blooddonor.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "donors")
public class Donor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "blood_group", nullable = false)
    private String bloodGroup;

    @Column(name = "last_donation_date")
    private LocalDate lastDonationDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "availability_status")
    private AvailabilityStatus availabilityStatus = AvailabilityStatus.AVAILABLE;

    @Column(name = "total_donations")
    private Integer totalDonations = 0;

    @Enumerated(EnumType.STRING)
    @Column(name = "badge")
    private Badge badge;

    @Transient
    private Double distance;

    public enum AvailabilityStatus { AVAILABLE, NOT_AVAILABLE }
    public enum Badge { LIFE_SAVER, HERO_DONOR, SUPER_DONOR }

    public Donor() {}

    /** Checks if donor is eligible to donate based on 15-day rule. */
    public boolean isEligibleToDonate() {
        if (lastDonationDate == null) return true;
        return lastDonationDate.isBefore(LocalDate.now().minusDays(15));
    }

    /** Updates badge based on total donations. */
    public void updateBadge() {
        if (totalDonations >= 20) this.badge = Badge.SUPER_DONOR;
        else if (totalDonations >= 10) this.badge = Badge.HERO_DONOR;
        else if (totalDonations >= 3) this.badge = Badge.LIFE_SAVER;
    }

    // ===== Getters =====
    public Long getId() { return id; }
    public User getUser() { return user; }
    public String getBloodGroup() { return bloodGroup; }
    public LocalDate getLastDonationDate() { return lastDonationDate; }
    public AvailabilityStatus getAvailabilityStatus() { return availabilityStatus; }
    public Integer getTotalDonations() { return totalDonations; }
    public Badge getBadge() { return badge; }
    public Double getDistance() { return distance; }

    // ===== Setters =====
    public void setId(Long id) { this.id = id; }
    public void setUser(User user) { this.user = user; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
    public void setLastDonationDate(LocalDate lastDonationDate) { this.lastDonationDate = lastDonationDate; }
    public void setAvailabilityStatus(AvailabilityStatus availabilityStatus) { this.availabilityStatus = availabilityStatus; }
    public void setTotalDonations(Integer totalDonations) { this.totalDonations = totalDonations; }
    public void setBadge(Badge badge) { this.badge = badge; }
    public void setDistance(Double distance) { this.distance = distance; }
}
