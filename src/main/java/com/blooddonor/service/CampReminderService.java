package com.blooddonor.service;

import com.blooddonor.entity.CampRegistration;
import com.blooddonor.repository.CampRegistrationRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class CampReminderService {

    private static final Logger log = LoggerFactory.getLogger(CampReminderService.class);

    @Autowired
    private CampRegistrationRepository registrationRepository;

    @Autowired
    private EmailNotificationService notificationService;

    /**
     * Run every day at 08:00 AM (server time).
     * Sends reminders for camps happening tomorrow.
     */
    @Scheduled(cron = "0 0 8 * * *")
    public void sendCampReminders() {
        LocalDate tomorrow = LocalDate.now().plusDays(1);
        log.info("Checking for blood camp reminders for date: {}", tomorrow);

        List<CampRegistration> registrations = registrationRepository.findByBloodCampDate(tomorrow);
        
        if (registrations.isEmpty()) {
            log.info("No camps scheduled for tomorrow ({}). No reminders to send.", tomorrow);
            return;
        }

        log.info("Found {} registrations for tomorrow. Sending reminders...", registrations.size());

        for (CampRegistration reg : registrations) {
            try {
                notificationService.sendCampReminderEmail(reg.getUser(), reg.getBloodCamp());
                log.info("Reminder sent to: {} for camp: {}", reg.getUser().getEmail(), reg.getBloodCamp().getCampName());
            } catch (Exception e) {
                log.error("Failed to send reminder to {}: {}", reg.getUser().getEmail(), e.getMessage());
            }
        }
    }
}
