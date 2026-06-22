package com.blooddonor.service;

import com.blooddonor.entity.*;
import com.blooddonor.repository.NotificationRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class EmailNotificationService {

    private static final Logger log = LoggerFactory.getLogger(EmailNotificationService.class);

    @Autowired
    private EmailService emailService;

    @Autowired
    private NotificationRepository notificationRepository;

    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private void saveAndSend(User user, String title, String body, String type) {
        // Save to DB
        Notification notification = new Notification(user, title, body, type);
        notificationRepository.save(notification);

        // Send Email
        try {
            log.info("Attempting to send {} email to: {}", type, user.getEmail());
            emailService.sendEmail(user.getEmail(), title, body);
        } catch (Exception e) {
            log.error("Failed to queue email to {}: {}", user.getEmail(), e.getMessage());
        }
    }

    public void sendRegistrationEmail(User user) {
        String title = "Welcome to REDDROPFINDER";
        String body = "Hello " + user.getName() + ",\n\n" +
                "Welcome to REDDROPFINDER.\n\n" +
                "Your account has been successfully created and verified.\n\n" +
                "You can now log in and start using the platform to find blood donors, request blood, or help save lives.\n\n" +
                "Thank you for joining the REDDROPFINDER community.\n\n" +
                "REDDROPFINDER Team";
        saveAndSend(user, title, body, "REGISTRATION");
    }

    public void sendLoginAlertEmail(User user) {
        String title = "Login Notification – REDDROPFINDER";
        String body = "Hello " + user.getName() + ",\n\n" +
                "Your REDDROPFINDER account was successfully logged in.\n\n" +
                "Login Time: " + LocalDateTime.now().format(formatter) + "\n\n" +
                "If this login was not performed by you, please change your password immediately.\n\n" +
                "REDDROPFINDER Team";
        saveAndSend(user, title, body, "LOGIN_ALERT");
    }

    public void sendBloodRequestEmail(User donor, BloodRequest request) {
        String title = "Emergency Blood Request Near You – REDDROPFINDER";
        String body = "Hello " + donor.getName() + ",\n\n" +
                "An emergency blood request has been created near your location.\n\n" +
                "Blood Group Required: " + request.getBloodGroup() + "\n" +
                "Hospital: " + request.getHospitalName() + "\n" +
                "Location: " + request.getCity() + "\n\n" +
                "If you are available to donate, please login to REDDROPFINDER and respond.\n\n" +
                "Your donation can save a life.\n\n" +
                "REDDROPFINDER Team";
        saveAndSend(donor, title, body, "BLOOD_REQUEST");
    }

    public void sendDonorAcceptedEmail(User recipient, User donor, BloodRequest request) {
        String title = "Donor Found for Your Blood Request";
        String body = "Hello,\n\n" +
                "Good news!\n\n" +
                "A donor has accepted your blood request.\n\n" +
                "Donor Name: " + donor.getName() + "\n" +
                "Donor Blood Group: " + request.getBloodGroup() + "\n" +
                "Hospital: " + request.getHospitalName() + "\n\n" +
                "Please coordinate with the hospital staff.\n\n" +
                "REDDROPFINDER Team";
        saveAndSend(recipient, title, body, "DONOR_ACCEPTED");
    }

    public void sendTransportRequestEmail(User volunteer, TransportRequest tr) {
        String title = "New Transport Mission Available – REDDROPFINDER";
        String body = "Hello " + volunteer.getName() + ",\n\n" +
                "An urgent transport mission is available.\n\n" +
                "From: " + tr.getDonor().getCity() + "\n" +
                "To: " + tr.getHospital().getHospitalName() + "\n\n" +
                "If you are available to help, please login to REDDROPFINDER and accept the ride.\n\n" +
                "Your assistance can save a life.\n\n" +
                "REDDROPFINDER Team";
        saveAndSend(volunteer, title, body, "TRANSPORT_ALERT");
    }

    public void sendVolunteerAssistanceEmail(User volunteer, TransportRequest tr, double distance) {
        String title = "🚨 Donor Needs Assistance - REDDROPFINDER";
        String body = "Hello " + volunteer.getName() + ",\n\n" +
                "A blood donor needs help reaching the hospital.\n\n" +
                "Donor Name: " + tr.getDonor().getName() + "\n" +
                "Distance from you: " + distance + " km\n" +
                "Hospital: " + tr.getHospital().getHospitalName() + "\n\n" +
                "This is marked as Emergency Travel Assistance. Would you like to assist this donor?\n\n" +
                "Please login to your dashboard to accept.\n\n" +
                "REDDROPFINDER Team";
        saveAndSend(volunteer, title, body, "TRANSPORT_HELP_REQUEST");
    }

    public void sendVolunteerTransportEmail(User recipient, Volunteer volunteer, TransportRequest tr) {
        String title = "Volunteer Transport Assigned";
        String body = "Hello,\n\n" +
                "A volunteer driver is on the way to pick up the donor.\n\n" +
                "Volunteer Name: " + volunteer.getUser().getName() + "\n" +
                "Vehicle Type: " + volunteer.getVehicleType() + "\n\n" +
                "You can track the route in your REDDROPFINDER dashboard.\n\n" +
                "REDDROPFINDER Team";
        saveAndSend(recipient, title, body, "VOLUNTEER_ASSIGNED");
    }

    public void sendDonationCompletedEmail(User donor, DonationHistory history) {
        String title = "Thank You for Saving a Life";
        String body = "Hello " + donor.getName() + ",\n\n" +
                "Thank you for donating blood today.\n\n" +
                "Your generosity has helped save a life.\n\n" +
                "Hospital: " + history.getHospitalName() + "\n" +
                "Donation Date: " + history.getDonationDate() + "\n\n" +
                "We truly appreciate your contribution.\n\n" +
                "REDDROPFINDER Team";
        saveAndSend(donor, title, body, "DONATION_COMPLETED");
    }

    public void sendBloodCampEmail(User donor, BloodCamp camp) {
        String title = "New Blood Donation Camp Announcement";
        String body = "Hello,\n\n" +
                "A new blood donation camp has been organized.\n\n" +
                "Camp Name: " + camp.getCampName() + "\n" +
                "Location: " + camp.getLocation() + "\n" +
                "Date: " + camp.getDate() + "\n\n" +
                "You are invited to participate and help save lives.\n\n" +
                "Register now through REDDROPFINDER.\n\n" +
                "REDDROPFINDER Team";
        saveAndSend(donor, title, body, "CAMP_ANNOUNCEMENT");
    }

    public void sendProfileUpdateEmail(User user) {
        String title = "Profile Updated Successfully";
        String body = "Hello " + user.getName() + ",\n\n" +
                "Your REDDROPFINDER profile has been successfully updated.\n\n" +
                "If you did not perform this action, please contact support immediately.\n\n" +
                "REDDROPFINDER Team";
        saveAndSend(user, title, body, "PROFILE_UPDATE");
    }

    public void sendPasswordChangeEmail(User user) {
        String title = "Password Changed – REDDROPFINDER";
        String body = "Hello " + user.getName() + ",\n\n" +
                "Your REDDROPFINDER account password has been successfully changed.\n\n" +
                "If this was not done by you, please reset your password immediately.\n\n" +
                "REDDROPFINDER Team";
        saveAndSend(user, title, body, "PASSWORD_CHANGE");
    }

    public void sendPasswordResetEmail(User user, String otp) {
        String title = "Reset Your Password OTP – REDDROPFINDER";
        String body = "Hello " + user.getName() + ",\n\n" +
                "You have requested to reset your password.\n\n" +
                "Your Password Reset OTP: " + otp + "\n\n" +
                "Enter this code on the reset page to set a new password.\n\n" +
                "This OTP will expire in 15 minutes.\n\n" +
                "If you did not request this, please ignore this email and your password will remain unchanged.\n\n" +
                "REDDROPFINDER Team";
        saveAndSend(user, title, body, "PASSWORD_RESET_REQUEST");
    }

    public void sendCampEnrollmentEmail(User donor, BloodCamp camp) {
        String title = "Registration Confirmed - " + camp.getCampName();
        String body = "Hello " + donor.getName() + ",\n\n" +
                "You have successfully registered for the blood donation camp: " + camp.getCampName() + ".\n\n" +
                "Camp Details:\n" +
                "Organizer: " + camp.getOrganizer() + "\n" +
                "Location: " + camp.getLocation() + "\n" +
                "Date: " + camp.getDate() + "\n\n" +
                "What to do next:\n" +
                "1. Arrive at the location on the specified date.\n" +
                "2. Bring a valid government ID.\n" +
                "3. Ensure you have a good meal and stay hydrated before donating.\n\n" +
                "Thank you for your commitment to saving lives.\n\n" +
                "REDDROPFINDER Team";
        saveAndSend(donor, title, body, "CAMP_ENROLLMENT");
    }

    public void sendCampReminderEmail(User donor, BloodCamp camp) {
        String title = "REMINDER: Blood Donation Camp Tomorrow - " + camp.getCampName();
        String body = "Hello " + donor.getName() + ",\n\n" +
                "This is a reminder that you have registered for the blood donation camp happening tomorrow!\n\n" +
                "Camp Details:\n" +
                "Name: " + camp.getCampName() + "\n" +
                "Location: " + camp.getLocation() + "\n" +
                "Date: " + camp.getDate() + "\n\n" +
                "Prep Reminder:\n" +
                "- Get a good night's sleep tonight.\n" +
                "- Eat a iron-rich meal tomorrow morning.\n" +
                "- Keep drinking plenty of fluids.\n" +
                "- Don't forget your photo ID!\n\n" +
                "Your presence can save up to three lives. See you there!\n\n" +
                "REDDROPFINDER Team";
        saveAndSend(donor, title, body, "CAMP_REMINDER");
    }

    @Transactional
    public void markAllAsRead(User user) {
        notificationRepository.findByUserOrderByCreatedTimeDesc(user).forEach(n -> {
            n.setReadStatus(true);
            notificationRepository.save(n);
        });
    }
}
