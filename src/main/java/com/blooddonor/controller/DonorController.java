package com.blooddonor.controller;

import com.blooddonor.entity.BloodRequest;
import com.blooddonor.entity.Donor;
import com.blooddonor.entity.DonationHistory;
import com.blooddonor.entity.User;
import com.blooddonor.service.BloodRequestService;
import com.blooddonor.service.DonorService;
import com.blooddonor.service.DonationHistoryService;
import com.blooddonor.service.UserService;
import com.blooddonor.service.TransportService;
import com.blooddonor.service.BloodCampService;
import com.blooddonor.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/donor")
public class DonorController {

    @Autowired
    private DonorService donorService;
    @Autowired
    private DonationHistoryService donationHistoryService;
    @Autowired
    private UserService userService;
    @Autowired
    private BloodRequestService bloodRequestService;
    @Autowired
    private TransportService transportService;
    @Autowired
    private BloodCampService bloodCampService;
    @Autowired
    private NotificationRepository notificationRepository;

    @GetMapping("/dashboard")
    public String dashboard(Authentication auth, Model model) {
        User user = getUser(auth);
        Optional<Donor> donorOpt = donorService.findByUser(user);

        if (donorOpt.isEmpty()) {
            model.addAttribute("error", "Donor profile not found.");
            return "donor-dashboard";
        }

        Donor donor = donorOpt.get();
        List<DonationHistory> history = donationHistoryService.findByDonor(donor);

        model.addAttribute("user", user);
        model.addAttribute("donor", donor);
        model.addAttribute("donationHistory", history);
        model.addAttribute("isEligible", donor.isEligibleToDonate());
        model.addAttribute("totalDonations", donor.getTotalDonations());
        
        // Find all available pending requests (Global pool)
        List<BloodRequest> availableRequests = bloodRequestService.findByStatus(BloodRequest.RequestStatus.PENDING);
        model.addAttribute("availableRequests", availableRequests);
        
        // Find if donor currently has an accepted/en-route active request
        List<BloodRequest> activeRequests = bloodRequestService.findActiveByDonor(user.getId());
        model.addAttribute("activeRequests", activeRequests);

        // Volunteer Transport Info
        model.addAttribute("transportRequests", transportService.findByDonor(user.getId()));

        // Registered Camps
        model.addAttribute("registeredCamps", bloodCampService.getRegisteredCamps(user));

        // Check registered status and ensure codes exist for active requests
        java.util.Map<Long, Boolean> hospitalRegisteredMap = new java.util.HashMap<>();
        for (BloodRequest active : activeRequests) {
            boolean isRegistered = userService.isHospitalRegistered(active.getHospitalName());
            hospitalRegisteredMap.put(active.getId(), isRegistered);
            
            // If code is missing for an active mission, generate and save it now
            if (!isRegistered && (active.getVerificationCode() == null || active.getVerificationCode().isBlank())) {
                String code = String.valueOf((int)(Math.random() * 900000) + 100000);
                active.setVerificationCode(code);
                bloodRequestService.save(active);
            }
        }
        model.addAttribute("hospitalRegisteredMap", hospitalRegisteredMap);

        // Notifications
        model.addAttribute("notifications", notificationRepository.findByUserOrderByCreatedTimeDesc(user));
        model.addAttribute("unreadCount", notificationRepository.countByUserAndReadStatusFalse(user));

        return "donor-dashboard";
    }


    @PostMapping("/toggle-availability")
    public String toggleAvailability(Authentication auth, RedirectAttributes redirectAttributes) {
        User user = getUser(auth);
        donorService.findByUser(user).ifPresent(donor -> donorService.toggleAvailability(donor.getId()));
        redirectAttributes.addFlashAttribute("successMessage", "Availability status updated!");
        return "redirect:/donor/dashboard";
    }

    @GetMapping("/donation-history")
    public String donationHistory(Authentication auth, Model model) {
        User user = getUser(auth);
        Optional<Donor> donorOpt = donorService.findByUser(user);

        if (donorOpt.isPresent()) {
            Donor donor = donorOpt.get();
            model.addAttribute("donations", donationHistoryService.findByDonor(donor));
            model.addAttribute("donor", donor);
            model.addAttribute("user", user);
        }
        return "donation-history";
    }

    @PostMapping("/accept-request")
    public String acceptRequest(@RequestParam Long requestId, Authentication auth, RedirectAttributes ra) {
        User user = getUser(auth);
        try {
            bloodRequestService.acceptRequest(requestId, user);
            ra.addFlashAttribute("successMessage", "Request accepted! Please head to the location.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/donor/dashboard";
    }

    @PostMapping("/update-status")
    public String updateStatus(@RequestParam Long requestId, @RequestParam String status, Authentication auth, RedirectAttributes ra) {
        try {
            bloodRequestService.updateStatus(requestId, BloodRequest.RequestStatus.valueOf(status));
            ra.addFlashAttribute("successMessage", "Status updated successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/donor/dashboard";
    }

    @PostMapping("/update-location")
    @ResponseBody
    public ResponseEntity<?> updateLocation(@RequestParam Long requestId, 
                                          @RequestParam Double lat, 
                                          @RequestParam Double lon,
                                          @RequestParam(required = false) String eta,
                                          @RequestParam(required = false) Double distance) {
        bloodRequestService.updateLiveLocation(requestId, lat, lon, eta, distance);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/request-assistance")
    public String requestAssistance(@RequestParam Long requestId, 
                                   @RequestParam Double lat, 
                                   @RequestParam Double lon, 
                                   Authentication auth, 
                                   RedirectAttributes ra) {
        User user = getUser(auth);
        try {
            BloodRequest bloodRequest = bloodRequestService.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException("Blood request not found"));
            
            // Destination is the hospital (the user who created the blood request)
            transportService.createTransportRequest(user, bloodRequest.getCreatedBy(), lat, lon, requestId);
            ra.addFlashAttribute("successMessage", "Volunteer assistance requested! Nearby volunteers have been notified.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Failed to request assistance: " + e.getMessage());
        }
        return "redirect:/donor/dashboard";
    }

    private User getUser(Authentication auth) {
        return userService.findByEmail(auth.getName())
                .orElseThrow(() -> new IllegalStateException("User not found"));
    }
}
