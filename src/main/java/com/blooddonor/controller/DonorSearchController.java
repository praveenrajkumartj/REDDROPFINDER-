package com.blooddonor.controller;

import com.blooddonor.entity.Donor;
import com.blooddonor.service.DonorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class DonorSearchController {

    @Autowired
    private DonorService donorService;

    @GetMapping("/search-donor")
    public String searchDonor(@RequestParam(required = false) String bloodGroup,
                              @RequestParam(required = false) String city,
                              @RequestParam(required = false) Double lat,
                              @RequestParam(required = false) Double lon,
                              Model model) {
        model.addAttribute("bloodGroups", new String[]{"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"});

        if (bloodGroup != null && !bloodGroup.isBlank()) {
            List<Donor> donors;
            if (lat != null && lon != null) {
                donors = donorService.findNearestDonors(bloodGroup, lat, lon);
            } else {
                donors = donorService.findMatchingDonors(bloodGroup, city);
            }
            model.addAttribute("donors", donors);
            model.addAttribute("searchBloodGroup", bloodGroup);
            model.addAttribute("searchCity", city);
            model.addAttribute("searchLat", lat);
            model.addAttribute("searchLon", lon);
            model.addAttribute("resultCount", donors.size());
        } else {
            // Fill empty state with recent heroes
            model.addAttribute("recentDonors", donorService.findAll().stream()
                    .filter(d -> d.getUser().isActive())
                    .limit(6).toList());
        }
        return "search-donor";
    }
}
