package com.blooddonor.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "email_verification")
public class EmailVerification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String email;

    @Column(nullable = false)
    private String otp;

    @Column(name = "created_time", nullable = false)
    private LocalDateTime createdTime;

    @Column(name = "expiry_time", nullable = false)
    private LocalDateTime expiryTime;

    @Column(name = "verified_status")
    private boolean verifiedStatus = false;

    public EmailVerification() {}

    public EmailVerification(String email, String otp, int expiryMinutes) {
        this.email = email;
        this.otp = otp;
        this.createdTime = LocalDateTime.now();
        this.expiryTime = this.createdTime.plusMinutes(expiryMinutes);
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getOtp() { return otp; }
    public void setOtp(String otp) { this.otp = otp; }

    public LocalDateTime getCreatedTime() { return createdTime; }
    public void setCreatedTime(LocalDateTime createdTime) { this.createdTime = createdTime; }

    public LocalDateTime getExpiryTime() { return expiryTime; }
    public void setExpiryTime(LocalDateTime expiryTime) { this.expiryTime = expiryTime; }

    public boolean isVerifiedStatus() { return verifiedStatus; }
    public void setVerifiedStatus(boolean verifiedStatus) { this.verifiedStatus = verifiedStatus; }
}
