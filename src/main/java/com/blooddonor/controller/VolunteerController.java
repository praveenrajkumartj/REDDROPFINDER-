package com.blooddonor.controller;

import com.blooddonor.entity.TransportRequest;
import com.blooddonor.entity.User;
import com.blooddonor.entity.Volunteer;
import com.blooddonor.service.TransportService;
import com.blooddonor.service.UserService;
import com.blooddonor.service.VolunteerService;
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
@RequestMapping("/volunteer")
public class VolunteerController {

    @Autowired
    private VolunteerService volunteerService;

    @Autowired
    private TransportService transportService;

    @Autowired
    private UserService userService;

    @Autowired
    private BloodCampService bloodCampService;
    @Autowired
    private NotificationRepository notificationRepository;

    @GetMapping("/dashboard")
    public String dashboard(Authentication auth, Model model) {
        User user = getUser(auth);
        Optional<Volunteer> volunteerOpt = volunteerService.findByUser(user);

        if (volunteerOpt.isEmpty()) {
            model.addAttribute("error", "Volunteer profile not found.");
            return "volunteer-dashboard";
        }

        Volunteer volunteer = volunteerOpt.get();
        model.addAttribute("volunteer", volunteer);
        model.addAttribute("user", user);

        // Pending transport requests (nearby logic usually in service, for now all pending)
        List<TransportRequest> pendingRequests = transportService.findPendingRequests();
        model.addAttribute("pendingRequests", pendingRequests);

        // Active mission
        List<TransportRequest> activeRequests = transportService.findActiveForVolunteer(volunteer);
        model.addAttribute("activeRequests", activeRequests);

        // Registered Camps
        model.addAttribute("registeredCamps", bloodCampService.getRegisteredCamps(user));

        // Notifications
        model.addAttribute("notifications", notificationRepository.findByUserOrderByCreatedTimeDesc(user));
        model.addAttribute("unreadCount", notificationRepository.countByUserAndReadStatusFalse(user));

        // Stats
        model.addAttribute("totalMissions", transportService.countCompletedMissions(volunteer));

        return "volunteer-dashboard";
    }


    @PostMapping("/accept-request")
    public String acceptRequest(@RequestParam Long requestId, Authentication auth, RedirectAttributes ra) {
        User user = getUser(auth);
        Volunteer volunteer = volunteerService.findByUser(user).orElseThrow();
        
        try {
            transportService.acceptRequest(requestId, volunteer);
            ra.addFlashAttribute("successMessage", "Transport mission accepted! Head to pick up the donor.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/volunteer/dashboard";
    }

    @PostMapping("/update-status")
    public String updateStatus(@RequestParam Long requestId, @RequestParam String status, RedirectAttributes ra) {
        try {
            transportService.updateStatus(requestId, TransportRequest.TransportStatus.valueOf(status));
            ra.addFlashAttribute("successMessage", "Mission status updated successfully.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/volunteer/dashboard";
    }

    @PostMapping("/toggle-availability")
    public String toggleAvailability(Authentication auth) {
        User user = getUser(auth);
        volunteerService.findByUser(user).ifPresent(v -> volunteerService.toggleAvailability(v.getId()));
        return "redirect:/volunteer/dashboard";
    }

    @GetMapping("/history")
    public String history(Authentication auth, Model model) {
        User user = getUser(auth);
        Volunteer volunteer = volunteerService.findByUser(user).orElseThrow();
        model.addAttribute("volunteer", volunteer);
        model.addAttribute("user", user);
        model.addAttribute("history", transportService.findHistoryByVolunteer(volunteer));
        model.addAttribute("notifications", notificationRepository.findByUserOrderByCreatedTimeDesc(user));
        model.addAttribute("unreadCount", notificationRepository.countByUserAndReadStatusFalse(user));
        return "volunteer-history";
    }

    @GetMapping("/vehicle")
    public String vehicle(Authentication auth, Model model) {
        User user = getUser(auth);
        Volunteer volunteer = volunteerService.findByUser(user).orElseThrow();
        model.addAttribute("volunteer", volunteer);
        model.addAttribute("user", user);
        model.addAttribute("notifications", notificationRepository.findByUserOrderByCreatedTimeDesc(user));
        model.addAttribute("unreadCount", notificationRepository.countByUserAndReadStatusFalse(user));
        return "volunteer-vehicle";
    }

    @PostMapping("/vehicle/update")
    public String updateVehicle(@RequestParam String vehicleType,
                              @RequestParam String vehicleNumber,
                              @RequestParam String licenseNumber,
                              Authentication auth, RedirectAttributes ra) {
        User user = getUser(auth);
        Volunteer volunteer = volunteerService.findByUser(user).orElseThrow();
        volunteer.setVehicleType(vehicleType);
        volunteer.setVehicleNumber(vehicleNumber);
        volunteer.setLicenseNumber(licenseNumber);
        volunteerService.registerVolunteer(volunteer); // Re-save to update
        ra.addFlashAttribute("successMessage", "Vehicle information updated successfully.");
        return "redirect:/volunteer/vehicle";
    }

    @PostMapping("/update-location")
    @ResponseBody
    public ResponseEntity<?> updateLocation(@RequestParam Long requestId, 
                                          @RequestParam Double lat, 
                                          @RequestParam Double lon,
                                          @RequestParam(required = false) Double distance,
                                          @RequestParam(required = false) String eta) {
        transportService.updateLiveLocation(requestId, lat, lon, distance, eta);
        return ResponseEntity.ok().build();
    }

    private User getUser(Authentication auth) {
        return userService.findByEmail(auth.getName())
                .orElseThrow(() -> new IllegalStateException("User not found"));
    }
}
