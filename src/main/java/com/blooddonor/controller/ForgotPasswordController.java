package com.blooddonor.controller;

import com.blooddonor.entity.User;
import com.blooddonor.service.UserService;
import com.blooddonor.service.EmailNotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

@Controller
public class ForgotPasswordController {

    @Autowired
    private UserService userService;

    @Autowired
    private EmailNotificationService notificationService;

    @GetMapping("/forgot-password")
    public String showForgotPasswordForm() {
        return "forgot-password";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam("email") String email, 
                                       Model model) {
        Optional<User> userOptional = userService.findByEmail(email);
        
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            String otp = userService.createPasswordResetToken(user);
            
            try {
                notificationService.sendPasswordResetEmail(user, otp);
                model.addAttribute("success", "Password reset OTP sent to your email!");
                model.addAttribute("email", email);
                return "verify-forgot-password-otp";
            } catch (Exception e) {
                model.addAttribute("error", "Failed to send email. Please try again later.");
            }
        } else {
            model.addAttribute("success", "If an account exists with that email, a reset OTP has been sent.");
        }
        
        return "forgot-password";
    }

    @GetMapping("/verify-forgot-password-otp")
    public String showVerifyOtpForm(@RequestParam("email") String email, Model model) {
        model.addAttribute("email", email);
        return "verify-forgot-password-otp";
    }

    @PostMapping("/verify-forgot-password-otp")
    public String verifyOtp(@RequestParam("email") String email,
                            @RequestParam("otp") String otp,
                            Model model) {
        Optional<User> userOptional = userService.getUserByPasswordResetOtp(email, otp);
        
        if (userOptional.isEmpty()) {
            model.addAttribute("error", "Invalid or expired OTP.");
            model.addAttribute("email", email);
            return "verify-forgot-password-otp";
        }
        
        model.addAttribute("email", email);
        model.addAttribute("otp", otp);
        return "reset-password";
    }

    @PostMapping("/reset-password")
    public String processResetPassword(@RequestParam("email") String email,
                                      @RequestParam("otp") String otp,
                                      @RequestParam("password") String password,
                                      @RequestParam("confirmPassword") String confirmPassword,
                                      Model model,
                                      RedirectAttributes redirectAttributes) {
        
        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match!");
            model.addAttribute("email", email);
            model.addAttribute("otp", otp);
            return "reset-password";
        }

        Optional<User> userOptional = userService.getUserByPasswordResetOtp(email, otp);
        
        if (userOptional.isEmpty()) {
            model.addAttribute("error", "Invalid or expired OTP.");
            return "forgot-password";
        }

        userService.resetPassword(userOptional.get(), password);
        redirectAttributes.addFlashAttribute("successMessage", "Password successfully reset. You can now login.");
        
        return "redirect:/login";
    }
}
