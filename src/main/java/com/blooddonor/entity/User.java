package com.blooddonor.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Name is required")
    @Column(nullable = false)
    private String name;

    @NotBlank(message = "Email is required")
    @Email(message = "Please enter a valid email")
    @Column(unique = true, nullable = false)
    private String email;

    @NotBlank(message = "Password is required")
    @Column(nullable = false)
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;

    @Pattern(regexp = "^[0-9]{10}$", message = "Phone must be 10 digits")
    private String phone;

    private String city;
    private String state;
    private String pincode;
    
    @Column(name = "full_address")
    private String fullAddress;

    private Double latitude;
    private Double longitude;

    @Column(name = "live_latitude")
    private Double liveLatitude;

    @Column(name = "live_longitude")
    private Double liveLongitude;

    @Column(name = "hospital_name")
    private String hospitalName;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "is_active")
    private boolean active = false;

    @Column(name = "profile_image")
    private String profileImage;

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Donor donor;

    @PrePersist
    public void prePersist() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }

    public enum Role { DONOR, PATIENT, HOSPITAL, ADMIN, VOLUNTEER }

    // ===== Constructors =====
    public User() {}

    // ===== Getters =====
    public Long getId() { return id; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public Role getRole() { return role; }
    public String getPhone() { return phone; }
    public String getCity() { return city; }
    public String getState() { return state; }
    public String getPincode() { return pincode; }
    public String getFullAddress() { return fullAddress; }
    public Double getLatitude() { return latitude; }
    public Double getLongitude() { return longitude; }
    public Double getLiveLatitude() { return liveLatitude; }
    public Double getLiveLongitude() { return liveLongitude; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public boolean isActive() { return active; }

    // ===== Setters =====
    public void setId(Long id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setEmail(String email) { this.email = email; }
    public void setPassword(String password) { this.password = password; }
    public void setRole(Role role) { this.role = role; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setCity(String city) { this.city = city; }
    public void setState(String state) { this.state = state; }
    public void setPincode(String pincode) { this.pincode = pincode; }
    public void setFullAddress(String fullAddress) { this.fullAddress = fullAddress; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }
    public void setLiveLatitude(Double liveLatitude) { this.liveLatitude = liveLatitude; }
    public void setLiveLongitude(Double liveLongitude) { this.liveLongitude = liveLongitude; }
    public String getHospitalName() { return hospitalName; }
    public void setHospitalName(String hospitalName) { this.hospitalName = hospitalName; }

    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public void setActive(boolean active) { this.active = active; }

    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }

    public Donor getDonor() { return donor; }
    public void setDonor(Donor donor) { this.donor = donor; }
}
