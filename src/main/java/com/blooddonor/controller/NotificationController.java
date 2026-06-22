package com.blooddonor.controller;

import com.blooddonor.entity.User;
import com.blooddonor.repository.NotificationRepository;
import com.blooddonor.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class NotificationController {

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private UserService userService;

    @GetMapping("/notifications")
    public String showAllNotifications(Authentication auth, Model model) {
        if (auth == null || !auth.isAuthenticated()) {
            return "redirect:/login";
        }
        
        User user = userService.findByEmail(auth.getName())
                .orElseThrow(() -> new IllegalStateException("User not found"));
        
        model.addAttribute("user", user);
        model.addAttribute("notifications", notificationRepository.findByUserOrderByCreatedTimeDesc(user));
        model.addAttribute("unreadCount", notificationRepository.countByUserAndReadStatusFalse(user));
        
        return "notifications";
    }

    @PostMapping("/notifications/mark-read")
    public org.springframework.http.ResponseEntity<?> markNotificationsRead(Authentication auth) {
        User user = userService.findByEmail(auth.getName())
                .orElseThrow(() -> new IllegalStateException("User not found"));
        
        notificationRepository.findByUserOrderByCreatedTimeDesc(user).forEach(n -> {
            n.setReadStatus(true);
            notificationRepository.save(n);
        });
        return org.springframework.http.ResponseEntity.ok().build();
    }
}
