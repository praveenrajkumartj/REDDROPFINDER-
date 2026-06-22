package com.blooddonor.util;

import com.blooddonor.entity.DonationHistory;
import com.blooddonor.entity.Donor;
import com.blooddonor.entity.User;
import com.blooddonor.entity.Volunteer;
import com.blooddonor.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

/**
 * Seeds the database with a default admin user and test data.
 */
@Component
public class DataInitializer implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DataInitializer.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private DonorRepository donorRepository;

    @Autowired
    private VolunteerRepository volunteerRepository;

    @Autowired
    private DonationHistoryRepository donationHistoryRepository;

    @Override
    @Transactional
    public void run(String... args) throws Exception {
        // 1. Create Admin User if not exists
        if (!userRepository.existsByEmail("admin@blooddonor.com")) {
            User admin = new User();
            admin.setName("System Admin");
            admin.setEmail("admin@blooddonor.com");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setRole(User.Role.ADMIN);
            admin.setCity("NEW YORK");
            admin.setActive(true);
            admin.setPhone("1234567890");
            
            userRepository.save(admin);
            log.info("Default admin user created: admin@blooddonor.com / admin123");
        }

        // 2. Create Hospital User (Apollo) if not exists
        if (!userRepository.existsByEmail("apollo@hospital.com")) {
            User hospital = new User();
            hospital.setName("Apollo Staff");
            hospital.setHospitalName("Apollo");
            hospital.setEmail("apollo@hospital.com");
            hospital.setPassword(passwordEncoder.encode("hospital123"));
            hospital.setRole(User.Role.HOSPITAL);
            hospital.setCity("salem");
            hospital.setActive(true);
            hospital.setPhone("9876543210");
            
            userRepository.save(hospital);
            log.info("Default hospital user created: apollo@hospital.com / hospital123");
        }

        // 3. Create Scenario: Ramesh (Patient in Salem)
        if (!userRepository.existsByEmail("ramesh@patient.com")) {
            User ramesh = new User();
            ramesh.setName("Ramesh");
            ramesh.setEmail("ramesh@patient.com");
            ramesh.setPassword(passwordEncoder.encode("ramesh123"));
            ramesh.setRole(User.Role.PATIENT);
            ramesh.setCity("salem");
            ramesh.setLatitude(11.6643);
            ramesh.setLongitude(78.1460);
            ramesh.setActive(true);
            ramesh.setPhone("9123456781");
            userRepository.save(ramesh);
            log.info("Scenario Patient created: Ramesh (Salem)");
        }

        // 4. Create Scenario: Gokul (Donor in Erode - B+)
        if (!userRepository.existsByEmail("gokul@donor.com")) {
            User gokulUser = new User();
            gokulUser.setName("Gokul");
            gokulUser.setEmail("gokul@donor.com");
            gokulUser.setPassword(passwordEncoder.encode("gokul123"));
            gokulUser.setRole(User.Role.DONOR);
            gokulUser.setCity("erode");
            gokulUser.setLatitude(11.3410);
            gokulUser.setLongitude(77.7172);
            gokulUser.setActive(true);
            gokulUser.setPhone("9123456782");
            userRepository.save(gokulUser);

            Donor gokul = new Donor();
            gokul.setUser(gokulUser);
            gokul.setBloodGroup("B+");
            gokul.setAvailabilityStatus(Donor.AvailabilityStatus.AVAILABLE);
            gokul.setTotalDonations(3);
            donorRepository.save(gokul);
            log.info("Scenario Donor created: Gokul (Erode, B+)");
        }

        // 5. Create Scenario: Ramanathan (Volunteer in Erode)
        if (!userRepository.existsByEmail("ramanathan@volunteer.com")) {
            User ramanUser = new User();
            ramanUser.setName("ramanathan");
            ramanUser.setEmail("ramanathan@volunteer.com");
            ramanUser.setPassword(passwordEncoder.encode("ramanathan123"));
            ramanUser.setRole(User.Role.VOLUNTEER);
            ramanUser.setCity("erode");
            ramanUser.setLatitude(11.3411);
            ramanUser.setLongitude(77.7173);
            ramanUser.setActive(true);
            ramanUser.setPhone("9123456783");
            userRepository.save(ramanUser);

            Volunteer raman = new Volunteer();
            raman.setUser(ramanUser);
            raman.setVehicleType("Car");
            raman.setVehicleNumber("TN 33 AB 1234");
            raman.setLicenseNumber("DL-987654321");
            raman.setAvailabilityStatus(Volunteer.AvailabilityStatus.AVAILABLE);
            volunteerRepository.save(raman);
            log.info("Scenario Volunteer created: Ramanathan (Erode)");
        }

        // 2. Seed Missing History for Donors who have a 'totalDonations' count
        List<Donor> donors = donorRepository.findAll();
        for (Donor donor : donors) {
            long currentCount = donationHistoryRepository.countByDonor(donor);
            if (donor.getTotalDonations() != null && donor.getTotalDonations() > currentCount) {
                log.info("Seeding {} missing history records for donor: {}", 
                        (donor.getTotalDonations() - currentCount), donor.getUser().getName());
                
                for (int i = 0; i < (donor.getTotalDonations() - currentCount); i++) {
                    DonationHistory history = new DonationHistory();
                    history.setDonor(donor);
                    history.setBloodGroup(donor.getBloodGroup());
                    history.setUnitsDonated(1);
                    history.setHospitalName("City General Hospital - Hyderabad");
                    history.setPatientName("Emergency Support Patient");
                    // Spread dates back: 1st donation long ago, last one 90 days ago
                    history.setDonationDate(LocalDate.now().minusDays(100L + (i * 120L)));
                    history.setCertificateNumber("CERT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                    
                    donationHistoryRepository.save(history);
                }
            }
        }
    }
}
