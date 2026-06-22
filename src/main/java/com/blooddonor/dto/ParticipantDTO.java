package com.blooddonor.dto;

public class ParticipantDTO {
    private String name;
    private String email;
    private String phone;
    private String city;
    private String bloodGroup;

    public ParticipantDTO() {}

    public ParticipantDTO(String name, String email, String phone, String city, String bloodGroup) {
        this.name = (name != null) ? name : "Unknown";
        this.email = (email != null) ? email : "N/A";
        this.phone = (phone != null) ? phone : "N/A";
        this.city = (city != null) ? city : "N/A";
        this.bloodGroup = (bloodGroup != null) ? bloodGroup : "N/A";
    }

    @Override
    public String toString() {
        return "ParticipantDTO{name='" + name + "', bloodGroup='" + bloodGroup + "'}";
    }

    // Getters
    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public String getCity() { return city; }
    public String getBloodGroup() { return bloodGroup; }

    // Setters
    public void setName(String name) { this.name = name; }
    public void setEmail(String email) { this.email = email; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setCity(String city) { this.city = city; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
}
