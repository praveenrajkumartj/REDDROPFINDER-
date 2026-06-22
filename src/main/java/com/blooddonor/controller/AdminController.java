package com.blooddonor.controller;

import com.blooddonor.entity.*;
import com.blooddonor.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.blooddonor.repository.NotificationRepository;
import org.springframework.security.core.Authentication;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserService userService;
    @Autowired
    private DonorService donorService;
    @Autowired
    private BloodRequestService bloodRequestService;
    @Autowired
    private VolunteerService volunteerService;
    @Autowired
    private BloodCampService bloodCampService;
    @Autowired
    private DonationHistoryService donationHistoryService;
    @Autowired
    private NotificationRepository notificationRepository;

    @GetMapping("/dashboard")
    public String dashboard(Authentication auth, Model model) {
        model.addAttribute("totalUsers", userService.getTotalUserCount());
        model.addAttribute("totalDonors", donorService.getTotalDonorCount());
        model.addAttribute("availableDonors", donorService.countAvailableDonors());
        model.addAttribute("totalRequests", bloodRequestService.getTotalCount());
        model.addAttribute("pendingRequests", bloodRequestService.getPendingCount());
        model.addAttribute("livesSaved", bloodRequestService.getFulfilledCount());
        model.addAttribute("totalDonations", donationHistoryService.getTotalDonationCount());
        model.addAttribute("totalCamps", bloodCampService.getTotalCampCount());

        model.addAttribute("donorCount", donorService.getTotalDonorCount());
        model.addAttribute("patientCount", userService.countByRole(User.Role.PATIENT));
        model.addAttribute("hospitalCount", userService.countByRole(User.Role.HOSPITAL));
        model.addAttribute("volunteerCount", volunteerService.getTotalVolunteerCount());

        model.addAttribute("recentRequests", bloodRequestService.findAllOrderedByDate().stream().limit(5).toList());
        model.addAttribute("allUsers", userService.findAllUsers().stream().limit(10).toList());

        User user = userService.findByEmail(auth.getName()).orElse(null);
        if (user != null) {
            model.addAttribute("user", user);
            model.addAttribute("notifications", notificationRepository.findByUserOrderByCreatedTimeDesc(user));
            model.addAttribute("unreadCount", notificationRepository.countByUserAndReadStatusFalse(user));
        }
        return "admin-dashboard";
    }


    @PostMapping("/toggle-user/{id}")
    public String toggleUserStatus(@PathVariable Long id, jakarta.servlet.http.HttpServletRequest request, RedirectAttributes redirectAttributes) {
        userService.toggleUserStatus(id);
        redirectAttributes.addFlashAttribute("successMessage", "User status updated successfully.");
        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/admin/dashboard");
    }

    @PostMapping("/update-request-status")
    public String updateRequestStatus(@RequestParam Long requestId,
                                      @RequestParam BloodRequest.RequestStatus status,
                                      jakarta.servlet.http.HttpServletRequest request,
                                      RedirectAttributes redirectAttributes) {
        bloodRequestService.updateStatus(requestId, status);
        redirectAttributes.addFlashAttribute("successMessage", "Request status updated.");
        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/admin/dashboard");
    }

    @PostMapping("/delete-request/{id}")
    public String deleteRequest(@PathVariable Long id, jakarta.servlet.http.HttpServletRequest request, RedirectAttributes redirectAttributes) {
        bloodRequestService.deleteRequest(id);
        redirectAttributes.addFlashAttribute("successMessage", "Request deleted.");
        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/admin/dashboard");
    }

    @GetMapping("/users")
    public String manageUsers(Model model) {
        model.addAttribute("allUsers", userService.findAllUsers());
        return "admin-users";
    }

    @GetMapping("/requests")
    public String manageRequests(Model model) {
        model.addAttribute("allRequests", bloodRequestService.findAllOrderedByDate());
        model.addAttribute("statuses", BloodRequest.RequestStatus.values());
        return "admin-requests";
    }

    @GetMapping("/map")
    public String globalView(Model model) {
        model.addAttribute("allUsers", userService.findAllUsers());
        model.addAttribute("allCamps", bloodCampService.getAllCamps());
        return "admin-map";
    }

    @PostMapping("/sync-locations")
    public String syncLocations(RedirectAttributes ra) {
        try {
            userService.syncMissingCoordinates();
            ra.addFlashAttribute("successMessage", "Location synchronization completed in background check logs for details.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Sync failed: " + e.getMessage());
        }
        return "redirect:/admin/dashboard";
    }
}
