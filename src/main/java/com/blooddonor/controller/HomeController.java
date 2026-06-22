package com.blooddonor.controller;

import com.blooddonor.entity.BloodRequest;
import com.blooddonor.service.*;
import java.util.List;
import java.util.ArrayList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @Autowired
    private DonorService donorService;
    @Autowired
    private BloodRequestService bloodRequestService;
    @Autowired
    private DonationHistoryService donationHistoryService;
    @Autowired
    private BloodCampService bloodCampService;
    @Autowired
    private UserService userService;

    @GetMapping("/dashboard")
    public String dashboardRedirect(Authentication auth) {
        if (auth == null) return "redirect:/login";
        String role = auth.getAuthorities().iterator().next().getAuthority();
        if (role.equals("ROLE_ADMIN")) return "redirect:/admin/dashboard";
        if (role.equals("ROLE_DONOR")) return "redirect:/donor/dashboard";
        if (role.equals("ROLE_PATIENT")) return "redirect:/patient/dashboard";
        if (role.equals("ROLE_HOSPITAL")) return "redirect:/hospital/dashboard";
        if (role.equals("ROLE_VOLUNTEER")) return "redirect:/volunteer/dashboard";
        return "redirect:/";
    }

    @GetMapping({"/", "/home"})
    public String home(Model model) {
        long globalDonations = donorService.getGlobalDonationCount();
        model.addAttribute("totalDonors", donorService.getTotalDonorCount());
        model.addAttribute("availableDonors", donorService.countAvailableDonors());
        model.addAttribute("totalRequests", bloodRequestService.getTotalCount());
        model.addAttribute("totalDonations", globalDonations);
        model.addAttribute("livesSaved", globalDonations * 3);

        model.addAttribute("upcomingCamps", bloodCampService.getUpcomingCamps()
                .stream().limit(3).toList());

        model.addAttribute("recentRequests", bloodRequestService.findByStatus(BloodRequest.RequestStatus.PENDING)
                .stream().limit(5).toList());

        return "index";
    }

    @GetMapping("/access-denied")
    public String accessDenied() {
        return "access-denied";
    }

    @GetMapping("/impact")
    public String impact(Model model) {
        long globalDonations = donorService.getGlobalDonationCount();
        model.addAttribute("totalDonors", donorService.getTotalDonorCount());
        model.addAttribute("availableDonors", donorService.countAvailableDonors());
        model.addAttribute("totalRequests", bloodRequestService.getTotalCount());
        model.addAttribute("totalDonations", globalDonations);
        model.addAttribute("livesSaved", globalDonations * 3);
        model.addAttribute("pendingRequests", bloodRequestService.getPendingCount());
        model.addAttribute("totalCamps", bloodCampService.getTotalCampCount());
        
        model.addAttribute("recentDonations", donationHistoryService.getRecentDonations(10));
        return "impact-dashboard";
    }

    @GetMapping("/blood-camps")
    public String bloodCamps(Model model, Authentication auth) {
        model.addAttribute("camps", bloodCampService.getAllCamps());
        model.addAttribute("upcomingCamps", bloodCampService.getUpcomingCamps());

        List<Long> registeredCampIds = new ArrayList<>();
        if (auth != null && auth.isAuthenticated()) {
            userService.findByEmail(auth.getName()).ifPresent(user -> {
                registeredCampIds.addAll(bloodCampService.getRegisteredCampIds(user));
            });
        }
        model.addAttribute("registeredCampIds", registeredCampIds);

        return "blood-camps";
    }

    @GetMapping("/support/{type}")
    public String information(@org.springframework.web.bind.annotation.PathVariable String type, Model model) {
        String title = switch (type) {
            case "help" -> "Help Center";
            case "privacy" -> "Privacy Policy";
            case "terms" -> "Terms of Service";
            case "api" -> "API Documentation";
            case "verify" -> "Certificate Verification";
            case "security" -> "Security Protocols";
            case "about" -> "About REDDROP Finder";
            case "contact" -> "Contact Support";
            default -> "Information Registry";
        };
        model.addAttribute("title", title);
        model.addAttribute("type", type);
        return "information";
    }

    @GetMapping("/api/verify-certificate")
    @org.springframework.web.bind.annotation.ResponseBody
    public org.springframework.http.ResponseEntity<?> verifyCertificate(@org.springframework.web.bind.annotation.RequestParam String code) {
        return donationHistoryService.getDonationByCertificate(code)
            .map(history -> {
                java.util.Map<String, Object> response = new java.util.HashMap<>();
                response.put("valid", true);
                response.put("donorName", history.getDonor().getUser().getName());
                response.put("bloodGroup", history.getBloodGroup());
                response.put("hospital", history.getHospitalName());
                response.put("date", history.getDonationDate().toString());
                response.put("units", history.getUnitsDonated());
                return org.springframework.http.ResponseEntity.ok(response);
            })
            .orElse(org.springframework.http.ResponseEntity.status(404).body(java.util.Map.of("valid", false, "message", "Certificate not found in ledger")));
    }
}
