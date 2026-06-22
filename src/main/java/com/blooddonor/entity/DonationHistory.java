package com.blooddonor.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "donation_history")
public class DonationHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "donor_id", nullable = false)
    private Donor donor;

    @Column(name = "hospital_name", nullable = false)
    private String hospitalName;

    @Column(name = "donation_date", nullable = false)
    private LocalDate donationDate;

    @Column(name = "patient_name")
    private String patientName;

    @Column(name = "blood_group")
    private String bloodGroup;

    @Column(name = "units_donated")
    private Integer unitsDonated = 1;

    @Column(name = "certificate_number")
    private String certificateNumber;

    @PrePersist
    public void prePersist() {
        if (donationDate == null) donationDate = LocalDate.now();
    }

    public DonationHistory() {}

    // ===== Getters =====
    public Long getId() { return id; }
    public Donor getDonor() { return donor; }
    public String getHospitalName() { return hospitalName; }
    public LocalDate getDonationDate() { return donationDate; }
    public String getPatientName() { return patientName; }
    public String getBloodGroup() { return bloodGroup; }
    public Integer getUnitsDonated() { return unitsDonated; }
    public String getCertificateNumber() { return certificateNumber; }

    // ===== Setters =====
    public void setId(Long id) { this.id = id; }
    public void setDonor(Donor donor) { this.donor = donor; }
    public void setHospitalName(String hospitalName) { this.hospitalName = hospitalName; }
    public void setDonationDate(LocalDate donationDate) { this.donationDate = donationDate; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
    public void setUnitsDonated(Integer unitsDonated) { this.unitsDonated = unitsDonated; }
    public void setCertificateNumber(String certificateNumber) { this.certificateNumber = certificateNumber; }
}
