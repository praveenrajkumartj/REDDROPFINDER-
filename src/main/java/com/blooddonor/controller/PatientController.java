package com.blooddonor.controller;

import com.blooddonor.entity.BloodRequest;
import com.blooddonor.entity.User;
import com.blooddonor.service.BloodRequestService;
import com.blooddonor.service.UserService;
import com.blooddonor.service.BloodCampService;
import com.blooddonor.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/patient")
public class PatientController {

    @Autowired
    private BloodRequestService bloodRequestService;
    @Autowired
    private UserService userService;
    @Autowired
    private BloodCampService bloodCampService;
    @Autowired
    private NotificationRepository notificationRepository;

    @GetMapping("/dashboard")
    public String dashboard(Authentication auth, Model model) {
        User user = getUser(auth);
        List<BloodRequest> myRequests = bloodRequestService.findByUserId(user.getId());

        model.addAttribute("user", user);
        model.addAttribute("myRequests", myRequests);
        model.addAttribute("pendingCount", myRequests.stream()
                .filter(r -> r.getStatus() == BloodRequest.RequestStatus.PENDING).count());
        model.addAttribute("fulfilledCount", myRequests.stream()
                .filter(r -> r.getStatus() == BloodRequest.RequestStatus.FULFILLED).count());
        model.addAttribute("registeredCamps", bloodCampService.getRegisteredCamps(user));
        // Check if hospitals for each request are registered
        java.util.Map<Long, Boolean> hospitalRegisteredMap = new java.util.HashMap<>();
        for (BloodRequest req : myRequests) {
            hospitalRegisteredMap.put(req.getId(), userService.isHospitalRegistered(req.getHospitalName()));
        }
        model.addAttribute("hospitalRegisteredMap", hospitalRegisteredMap);
        
        // Notifications
        model.addAttribute("notifications", notificationRepository.findByUserOrderByCreatedTimeDesc(user));
        model.addAttribute("unreadCount", notificationRepository.countByUserAndReadStatusFalse(user));

        return "patient-dashboard";
    }


    @GetMapping("/request-blood")
    public String requestBloodForm(Authentication auth, Model model) {
        User user = getUser(auth);
        model.addAttribute("user", user);
        model.addAttribute("request", new BloodRequest());
        model.addAttribute("bloodGroups", new String[]{"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"});
        model.addAttribute("urgencyLevels", BloodRequest.UrgencyLevel.values());
        return "request-blood";
    }

    @PostMapping("/request-blood")
    public String submitRequest(@ModelAttribute BloodRequest request,
                                Authentication auth,
                                RedirectAttributes redirectAttributes) {
        User user = getUser(auth);
        request.setCreatedBy(user);

        bloodRequestService.createRequest(request);
        redirectAttributes.addFlashAttribute("successMessage",
                "Emergency blood request submitted! Nearby donors will be alerted.");
        return "redirect:/patient/dashboard";
    }



    @PostMapping("/fulfill-request")
    public String fulfillRequest(@RequestParam Long requestId, @RequestParam String code, RedirectAttributes ra) {
        try {
            bloodRequestService.fulfillByPatient(requestId, code);
            ra.addFlashAttribute("successMessage", "Donation successfully verified and fulfilled! Thank you for the contribution.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/patient/dashboard";
    }

    @GetMapping("/track-donor/{id}")
    public String trackDonor(@PathVariable Long id, Model model) {
        BloodRequest request = bloodRequestService.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Request not found"));
        model.addAttribute("req", request);
        return "track-donor";
    }

    private User getUser(Authentication auth) {
        return userService.findByEmail(auth.getName())
                .orElseThrow(() -> new IllegalStateException("User not found"));
    }
}
