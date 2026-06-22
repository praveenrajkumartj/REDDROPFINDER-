package com.blooddonor.service;

import com.blooddonor.entity.EmailVerification;
import com.blooddonor.repository.EmailVerificationRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@Service
@Transactional
public class OTPService {

    private static final Logger log = LoggerFactory.getLogger(OTPService.class);

    @Autowired
    private EmailVerificationRepository repository;

    @Autowired
    private EmailService emailService;

    public String generateOTP(String email) {
        // Find existing record and delete it
        repository.findByEmail(email).ifPresent(repository::delete);

        // Generate 6-digit OTP
        Random random = new Random();
        String otp = String.valueOf(100000 + random.nextInt(900000));

        // Save into DB (Valid for 5 mins)
        EmailVerification verification = new EmailVerification(email, otp, 5);
        repository.save(verification);

        log.info("Generated OTP for email: {} is: {}", email, otp);
        return otp;
    }

    public void sendOTPEmail(String email, String otp) {
        String subject = "Email Verification - REDDROPFINDER";
        String body = "Hello,\n\n" +
                "Welcome to REDDROPFINDER – Smart Blood Donor Emergency Finder.\n\n" +
                "To complete your registration, please verify your email using the OTP below.\n\n" +
                "Your OTP: " + otp + "\n\n" +
                "This OTP is valid for 5 minutes.\n\n" +
                "Do not share this code with anyone.\n\n" +
                "Thank you for joining REDDROPFINDER and helping save lives.\n\n" +
                "Regards,\n" +
                "REDDROPFINDER Team";

        try {
            emailService.sendEmail(email, subject, body);
        } catch (Exception e) {
            log.error("Error sending email to {}: {}", email, e.getMessage());
            throw new RuntimeException("Wait! We could not send the verification email. Please check your email address.");
        }
    }

    public boolean verifyOTP(String email, String otp) {
        Optional<EmailVerification> entryOpt = repository.findByEmailAndOtp(email, otp);

        if (entryOpt.isPresent()) {
            EmailVerification entry = entryOpt.get();
            if (entry.getExpiryTime().isAfter(LocalDateTime.now())) {
                entry.setVerifiedStatus(true);
                repository.save(entry);
                return true;
            } else {
                repository.delete(entry);
                log.warn("OTP expired for email: {}", email);
            }
        }
        return false;
    }
}
