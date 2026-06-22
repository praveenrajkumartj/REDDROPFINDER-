package com.blooddonor.controller;

import com.blooddonor.repository.NotificationRepository;
import com.blooddonor.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalControllerAdvice {

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private UserService userService;

    @ModelAttribute
    public void addGlobalAttributes(Authentication auth, Model model) {
        if (auth != null && auth.isAuthenticated()) {
            userService.findByEmail(auth.getName()).ifPresent(user -> {
                model.addAttribute("user", user);
                model.addAttribute("unreadCount", notificationRepository.countByUserAndReadStatusFalse(user));
                model.addAttribute("notifications", notificationRepository.findByUserOrderByCreatedTimeDesc(user));
            });
        }
    }
}
