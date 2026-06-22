package com.blooddonor.controller;

import com.blooddonor.entity.Donor;
import com.blooddonor.entity.User;
import com.blooddonor.entity.Volunteer;
import com.blooddonor.service.UserService;
import com.blooddonor.service.DonorService;
import com.blooddonor.service.VolunteerService;
import com.blooddonor.service.OTPService;
import com.blooddonor.service.EmailNotificationService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.time.LocalDate;

/**
 * Authentication controller - handles login, logout, and registration.
 */
@Controller
public class AuthController {

    @Autowired
    private UserService userService;
    @Autowired
    private DonorService donorService;
    @Autowired
    private VolunteerService volunteerService;
    @Autowired
    private OTPService otpService;
    @Autowired
    private EmailNotificationService notificationService;

    @GetMapping("/login")
    public String loginPage(@RequestParam(required = false) String error,
                            @RequestParam(required = false) String logout,
                            Model model) {
        if (error != null) {
            model.addAttribute("errorMessage", "Invalid email or password!");
        }
        if (logout != null) {
            model.addAttribute("successMessage", "You have been logged out successfully.");
        }
        return "login";
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("bloodGroups", new String[]{"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"});
        model.addAttribute("roles", User.Role.values());
        return "register";
    }

    @PostMapping("/register")
    public String registerSubmit(@Valid @ModelAttribute("user") User user,
                                 BindingResult bindingResult,
                                 @RequestParam(required = false) String bloodGroup,
                                 @RequestParam(required = false) String lastDonationDate,
                                 @RequestParam(required = false) String vehicleType,
                                 @RequestParam(required = false) String vehicleNumber,
                                 @RequestParam(required = false) String licenseNumber,
                                 RedirectAttributes redirectAttributes,
                                 Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("bloodGroups", new String[]{"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"});
            model.addAttribute("roles", User.Role.values());
            return "register";
        }

        try {
            User savedUser = userService.registerUser(user);

            if (savedUser.getRole() == User.Role.DONOR && bloodGroup != null && !bloodGroup.isBlank()) {
                Donor donor = new Donor();
                donor.setUser(savedUser);
                donor.setBloodGroup(bloodGroup);
                donor.setAvailabilityStatus(Donor.AvailabilityStatus.AVAILABLE);
                donor.setTotalDonations(0);

                if (lastDonationDate != null && !lastDonationDate.isBlank()) {
                    donor.setLastDonationDate(LocalDate.parse(lastDonationDate));
                }

                donorService.saveDonor(donor);
            } else if (savedUser.getRole() == User.Role.VOLUNTEER) {
                Volunteer volunteer = new Volunteer();
                volunteer.setUser(savedUser);
                volunteer.setVehicleType(vehicleType);
                volunteer.setVehicleNumber(vehicleNumber);
                volunteer.setLicenseNumber(licenseNumber);
                volunteer.setAvailabilityStatus(Volunteer.AvailabilityStatus.AVAILABLE);

                volunteerService.registerVolunteer(volunteer);
            }

            // Start OTP Verification Flow
            String otp = otpService.generateOTP(savedUser.getEmail());
            otpService.sendOTPEmail(savedUser.getEmail(), otp);

            redirectAttributes.addAttribute("email", savedUser.getEmail());
            redirectAttributes.addFlashAttribute("successMessage", "OTP sent to your email. Please verify.");
            return "redirect:/verify-otp";

        } catch (Exception e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("bloodGroups", new String[]{"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"});
            model.addAttribute("roles", User.Role.values());
            return "register";
        }
    }

    @GetMapping("/verify-otp")
    public String verifyOtpPage(@RequestParam String email, Model model) {
        model.addAttribute("email", email);
        return "verify-otp";
    }

    @PostMapping("/verify-otp")
    public String verifyOtp(@RequestParam String email, 
                            @RequestParam String otp, 
                            RedirectAttributes ra, 
                            Model model) {
        if (otpService.verifyOTP(email, otp)) {
            userService.activateUser(email);
            userService.findByEmail(email).ifPresent(notificationService::sendRegistrationEmail);
            ra.addFlashAttribute("successMessage", "Email verified! You can now login.");
            return "redirect:/login";
        } else {
            model.addAttribute("email", email);
            model.addAttribute("errorMessage", "Invalid or expired OTP!");
            return "verify-otp";
        }
    }

    @PostMapping("/resend-otp")
    public String resendOtp(@RequestParam String email, RedirectAttributes ra) {
        try {
            String otp = otpService.generateOTP(email);
            otpService.sendOTPEmail(email, otp);
            ra.addFlashAttribute("successMessage", "A new OTP has been sent to your email.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        }
        ra.addAttribute("email", email);
        return "redirect:/verify-otp";
    }
}
