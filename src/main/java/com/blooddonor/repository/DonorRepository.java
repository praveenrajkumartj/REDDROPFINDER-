package com.blooddonor.repository;

import com.blooddonor.entity.Donor;
import com.blooddonor.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

/**
 * Repository for Donor entity with smart matching queries.
 */
@Repository
public interface DonorRepository extends JpaRepository<Donor, Long> {

    Optional<Donor> findByUser(User user);

    Optional<Donor> findByUser_Id(Long userId);

    List<Donor> findByBloodGroup(String bloodGroup);

    List<Donor> findByBloodGroupAndAvailabilityStatus(String bloodGroup, Donor.AvailabilityStatus status);

    List<Donor> findByUser_City(String city);

    List<Donor> findByBloodGroupAndUser_City(String bloodGroup, String city);

    /**
     * Smart matching: find available donors by blood group ordered by last donation date (ascending).
     * This ensures donors who donated longest ago appear first.
     */
    @Query("SELECT d FROM Donor d WHERE d.bloodGroup = :bloodGroup " +
           "AND d.availabilityStatus = 'AVAILABLE' " +
           "AND d.user.city = :city " +
           "ORDER BY d.lastDonationDate ASC NULLS FIRST")
    List<Donor> findAvailableDonorsByBloodGroupAndCity(
            @Param("bloodGroup") String bloodGroup,
            @Param("city") String city);

    /**
     * Find all available donors with given blood group (any city).
     */
    @Query("SELECT d FROM Donor d WHERE d.bloodGroup = :bloodGroup " +
           "AND d.availabilityStatus = 'AVAILABLE' " +
           "ORDER BY d.lastDonationDate ASC NULLS FIRST")
    List<Donor> findAvailableDonorsByBloodGroup(@Param("bloodGroup") String bloodGroup);

    long countByAvailabilityStatus(Donor.AvailabilityStatus status);

    @Query("SELECT SUM(d.totalDonations) FROM Donor d")
    Long sumTotalDonations();
}
