package com.blooddonor.controller;

import com.blooddonor.entity.User;
import com.blooddonor.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.*;
import java.util.UUID;

@Controller
@RequestMapping("/profile")
public class ProfileController {

    @Autowired
    private UserService userService;

    private static final String UPLOAD_DIR = System.getProperty("user.dir") + "/uploads/profiles/";

    @GetMapping
    public String viewProfile(Authentication auth, Model model) {
        if (auth == null) return "redirect:/login";
        User user = userService.findByEmail(auth.getName()).orElse(null);
        model.addAttribute("user", user);
        return "profile";
    }

    @PostMapping("/update")
    public String updateProfile(Authentication auth, 
                                @RequestParam("name") String name,
                                @RequestParam("phone") String phone,
                                @RequestParam("city") String city,
                                @RequestParam(value = "latitude", required = false) Double latitude,
                                @RequestParam(value = "longitude", required = false) Double longitude,
                                @RequestParam(value = "image", required = false) MultipartFile image,
                                RedirectAttributes ra) {
        if (auth == null) return "redirect:/login";
        
        User user = userService.findByEmail(auth.getName()).orElse(null);
        if (user == null) return "redirect:/login";

        user.setName(name);
        user.setPhone(phone);
        user.setCity(city);
        if (latitude != null) user.setLatitude(latitude);
        if (longitude != null) user.setLongitude(longitude);

        if (image != null && !image.isEmpty()) {
            try {
                // Ensure directory exists
                Path uploadPath = Paths.get(UPLOAD_DIR);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }

                // Generate unique filename
                String fileName = UUID.randomUUID().toString() + "_" + image.getOriginalFilename();
                Path filePath = uploadPath.resolve(fileName);
                Files.copy(image.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

                // Save filename in DB
                user.setProfileImage(fileName);
            } catch (IOException e) {
                ra.addFlashAttribute("error", "Failed to upload image: " + e.getMessage());
                return "redirect:/profile";
            }
        }

        userService.updateUser(user);
        ra.addFlashAttribute("success", "Profile updated successfully!");
        return "redirect:/profile";
    }
}
