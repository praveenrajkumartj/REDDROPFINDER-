package com.blooddonor.controller;

import com.blooddonor.dto.ParticipantDTO;
import com.blooddonor.entity.BloodCamp;
import com.blooddonor.entity.BloodRequest;
import com.blooddonor.entity.User;
import com.blooddonor.service.*;
import com.blooddonor.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.List;

@Controller
@RequestMapping("/hospital")
public class HospitalController {

    @Autowired
    private BloodCampService bloodCampService;
    @Autowired
    private BloodRequestService bloodRequestService;
    @Autowired
    private DonorService donorService;
    @Autowired
    private UserService userService;
    @Autowired
    private NotificationRepository notificationRepository;

    @GetMapping("/dashboard")
    public String dashboard(Authentication auth, Model model) {
        User user = getUser(auth);
        
        // Use optimized query for my camps
        List<BloodCamp> myCamps = bloodCampService.getCampsByCreator(user);

        model.addAttribute("user", user);
        model.addAttribute("myCamps", myCamps);
        // Using a VERY loud and unique string for sync check
        model.addAttribute("hotReloadTest", "BACKEND_SYNC_VER_3_" + System.currentTimeMillis());
        
        // Incoming donors for this hospital
        String hospitalSearchName = (user.getHospitalName() != null && !user.getHospitalName().isBlank()) 
                                    ? user.getHospitalName() : user.getName();
        model.addAttribute("incomingRequests", bloodRequestService.findIncomingByHospital(hospitalSearchName));
        
        // Only show requests in the hospital's city for better relevance
        model.addAttribute("pendingRequests", 
                bloodRequestService.findByCityAndStatus(user.getCity(), BloodRequest.RequestStatus.PENDING));
        
        model.addAttribute("totalDonors", donorService.countAvailableDonors());
        
        // Notifications
        model.addAttribute("notifications", notificationRepository.findByUserOrderByCreatedTimeDesc(user));
        model.addAttribute("unreadCount", notificationRepository.countByUserAndReadStatusFalse(user));

        return "hospital-dashboard";
    }


    @PostMapping("/update-request-status")
    public String updateRequestStatus(@RequestParam Long requestId, 
                                     @RequestParam String status, 
                                     RedirectAttributes redirectAttributes) {
        try {
            bloodRequestService.updateStatus(requestId, BloodRequest.RequestStatus.valueOf(status));
            redirectAttributes.addFlashAttribute("successMessage", "Request status updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating request: " + e.getMessage());
        }
        return "redirect:/hospital/dashboard";
    }

    @GetMapping("/add-camp")
    public String addCampForm(Authentication auth, Model model) {
        model.addAttribute("user", getUser(auth));
        model.addAttribute("camp", new BloodCamp());
        return "add-camp";
    }

    @PostMapping("/add-camp")
    public String addCamp(@ModelAttribute BloodCamp camp,
                          Authentication auth,
                          RedirectAttributes redirectAttributes) {
        User user = getUser(auth);
        camp.setCreatedBy(user);
        camp.setStatus(BloodCamp.CampStatus.UPCOMING);
        bloodCampService.saveCamp(camp);
        redirectAttributes.addFlashAttribute("successMessage", "Blood camp created successfully!");
        return "redirect:/hospital/dashboard";
    }

    @PostMapping("/delete-camp/{id}")
    public String deleteCamp(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        bloodCampService.deleteCamp(id);
        redirectAttributes.addFlashAttribute("successMessage", "Camp deleted.");
        return "redirect:/hospital/dashboard";
    }

    @PostMapping("/register-camp/{id}")
    public String registerForCamp(@PathVariable Long id, Authentication auth, RedirectAttributes redirectAttributes) {
        try {
            User user = getUser(auth);
            bloodCampService.registerForCamp(id, user);
            redirectAttributes.addFlashAttribute("successMessage", "You have successfully registered for the blood camp!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/blood-camps";
    }

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(HospitalController.class);

    @GetMapping(value = "/camp-participants/{id}", produces = "application/json")
    public org.springframework.http.ResponseEntity<?> getParticipants(@PathVariable Long id) {
        log.info("AJAX: Fetching participants for camp ID: {}", id);
        try {
            List<ParticipantDTO> participants = bloodCampService.getParticipantDetailsForCamp(id);
            log.info("AJAX: Successfully found {} participants", participants.size());
            return org.springframework.http.ResponseEntity.ok(participants);
        } catch (Exception e) {
            log.error("AJAX_ERROR: Failed to fetch participants for camp {}: {}", id, e.getMessage());
            return org.springframework.http.ResponseEntity.status(500)
                    .body(java.util.Map.of("error", "Failed to retrieve: " + e.getMessage()));
        }
    }

    private User getUser(Authentication auth) {
        return userService.findByEmail(auth.getName())
                .orElseThrow(() -> new IllegalStateException("User not found"));
    }
}
