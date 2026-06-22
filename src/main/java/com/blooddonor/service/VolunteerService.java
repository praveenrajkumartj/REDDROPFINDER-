package com.blooddonor.service;

import com.blooddonor.entity.User;
import com.blooddonor.entity.Volunteer;
import com.blooddonor.repository.VolunteerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class VolunteerService {

    @Autowired
    private VolunteerRepository volunteerRepository;

    public Volunteer registerVolunteer(Volunteer volunteer) {
        return volunteerRepository.save(volunteer);
    }

    @Transactional(readOnly = true)
    public Optional<Volunteer> findByUser(User user) {
        return volunteerRepository.findByUser(user);
    }

    @Transactional(readOnly = true)
    public Optional<Volunteer> findById(Long id) {
        return volunteerRepository.findById(id);
    }

    public void toggleAvailability(Long id) {
        volunteerRepository.findById(id).ifPresent(v -> {
            if (v.getAvailabilityStatus() == Volunteer.AvailabilityStatus.AVAILABLE) {
                v.setAvailabilityStatus(Volunteer.AvailabilityStatus.OFFLINE);
            } else {
                v.setAvailabilityStatus(Volunteer.AvailabilityStatus.AVAILABLE);
            }
            volunteerRepository.save(v);
        });
    }

    public void updateStatus(Long id, Volunteer.AvailabilityStatus status) {
        volunteerRepository.findById(id).ifPresent(v -> {
            v.setAvailabilityStatus(status);
            volunteerRepository.save(v);
        });
    }

    @Transactional(readOnly = true)
    public List<Volunteer> findAvailableVolunteers() {
        return volunteerRepository.findByAvailabilityStatus(Volunteer.AvailabilityStatus.AVAILABLE);
    }

    @Transactional(readOnly = true)
    public long getTotalVolunteerCount() {
        return volunteerRepository.count();
    }
}
