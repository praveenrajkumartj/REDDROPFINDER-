package com.blooddonor.service;

import com.blooddonor.entity.*;
import com.blooddonor.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
@Transactional
public class UserService {

    private static final Logger log = LoggerFactory.getLogger(UserService.class);
    private static final String GEODATA_API = "https://nominatim.openstreetmap.org/search?format=json&q=";

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private EmailNotificationService notificationService;

    @Autowired
    private PasswordResetTokenRepository tokenRepository;

    /**
     * Register a new user.
     */
    public User registerUser(User user) {
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new IllegalArgumentException("Email already registered: " + user.getEmail());
        }
        // Encode password before saving
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        User saved = userRepository.save(user);
        log.info("New user registered: {} with role {}", saved.getEmail(), saved.getRole());
        return saved;
    }

    /**
     * Find user by email.
     */
    @Transactional(readOnly = true)
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    /**
     * Find user by ID.
     */
    @Transactional(readOnly = true)
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    /**
     * Get all users.
     */
    @Transactional(readOnly = true)
    public List<User> findAllUsers() {
        return userRepository.findAll();
    }

    /**
     * Update user profile.
     */
    public User updateUser(User user) {
        User saved = userRepository.save(user);
        try {
            notificationService.sendProfileUpdateEmail(saved);
        } catch (Exception e) {
            log.error("Failed to send profile update email: {}", e.getMessage());
        }
        return saved;
    }

    /**
     * Activate a user.
     */
    public void activateUser(String email) {
        userRepository.findByEmail(email).ifPresent(user -> {
            user.setActive(true);
            userRepository.save(user);
            log.info("User {} activated via OTP.", email);
        });
    }

    /**
     * Toggle user active status.
     */
    public void toggleUserStatus(Long id) {
        userRepository.findById(id).ifPresent(user -> {
            user.setActive(!user.isActive());
            userRepository.save(user);
            log.info("User {} status toggled to: {}", user.getEmail(), user.isActive());
        });
    }

    /**
     * Get count by role.
     */
    @Transactional(readOnly = true)
    public long countByRole(User.Role role) {
        return userRepository.countByRole(role);
    }

    /**
     * Get total user count.
     */
    @Transactional(readOnly = true)
    public long getTotalUserCount() {
        return userRepository.count();
    }

    /**
     * Validate login credentials.
     */
    @Transactional(readOnly = true)
    public Optional<User> validateLogin(String email, String rawPassword) {
        return userRepository.findByEmail(email)
                .filter(user -> passwordEncoder.matches(rawPassword, user.getPassword()))
                .filter(User::isActive);
    }

    /**
     * Generate password reset token.
     */
    public String createPasswordResetToken(User user) {
        // Delete any existing token for user and flush to avoid duplicate entry error
        tokenRepository.findByUser(user).ifPresent(token -> {
            tokenRepository.delete(token);
            tokenRepository.flush(); // Crucial to sync delete with DB before re-inserting user_id
        });
        
        // Generate 6-digit OTP
        Random random = new Random();
        String otp = String.valueOf(100000 + random.nextInt(900000));
        
        PasswordResetToken resetToken = new PasswordResetToken(otp, user, 15); // 15 mins expiry
        tokenRepository.save(resetToken);
        return otp;
    }

    /**
     * Find user by OTP.
     */
    @Transactional(readOnly = true)
    public Optional<User> getUserByPasswordResetOtp(String email, String otp) {
        return tokenRepository.findByToken(otp)
                .filter(t -> t.getUser().getEmail().equals(email))
                .filter(t -> !t.isExpired())
                .map(PasswordResetToken::getUser);
    }

    /**
     * Complete password reset.
     */
    public void resetPassword(User user, String newPassword) {
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        // Clear token
        tokenRepository.findByUser(user).ifPresent(tokenRepository::delete);
        
        try {
            notificationService.sendPasswordChangeEmail(user);
        } catch (Exception e) {
            log.error("Failed to send password change notification: {}", e.getMessage());
        }
    }

    @Transactional(readOnly = true)
    public boolean isHospitalRegistered(String hospitalName) {
        if (hospitalName == null || hospitalName.isBlank()) return false;
        return userRepository.findByHospitalNameAndRole(hospitalName, User.Role.HOSPITAL).isPresent();
    }

    /**
     * Synchronize and fill missing coordinates for all users based on their city.
     */
    public void syncMissingCoordinates() {
        List<User> usersToFix = userRepository.findAll().stream()
                .filter(u -> u.getLatitude() == null || u.getLongitude() == null)
                .filter(u -> u.getCity() != null && !u.getCity().isBlank())
                .toList();

        if (usersToFix.isEmpty()) {
            log.info("No users found with missing coordinates.");
            return;
        }

        HttpClient client = HttpClient.newHttpClient();
        ObjectMapper mapper = new ObjectMapper();

        for (User user : usersToFix) {
            try {
                String query = user.getCity() + ", " + (user.getState() != null ? user.getState() : "");
                String encodedQuery = java.net.URLEncoder.encode(query, "UTF-8");
                
                HttpRequest req = HttpRequest.newBuilder()
                        .uri(URI.create(GEODATA_API + encodedQuery))
                        .header("User-Agent", "REDDROP-BloodDonor-App")
                        .build();

                HttpResponse<String> response = client.send(req, HttpResponse.BodyHandlers.ofString());
                JsonNode root = mapper.readTree(response.body());

                if (root.isArray() && !root.isEmpty()) {
                    JsonNode result = root.get(0);
                    user.setLatitude(result.get("lat").asDouble());
                    user.setLongitude(result.get("lon").asDouble());
                    userRepository.save(user);
                    log.info("Updated coordinates for user: {} ({}, {})", user.getEmail(), user.getLatitude(), user.getLongitude());
                } else {
                    log.warn("Could not find coordinates for city: {}", user.getCity());
                }
                
                // Sleep briefly to respect Nominatim usage policy (1s delay)
                Thread.sleep(1000);
                
            } catch (Exception e) {
                log.error("Failed to sync location for user {}: {}", user.getEmail(), e.getMessage());
            }
        }
    }
}
