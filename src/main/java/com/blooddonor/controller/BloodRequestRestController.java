package com.blooddonor.controller;

import com.blooddonor.service.BloodRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class BloodRequestRestController {

    @Autowired
    private BloodRequestService bloodRequestService;

    @GetMapping("/request-status/{id}")
    public ResponseEntity<Map<String, Object>> getRequestStatus(@PathVariable Long id) {
        return bloodRequestService.findById(id)
                .map(req -> {
                    Map<String, Object> data = new HashMap<>();
                    data.put("id", req.getId());
                    data.put("status", req.getStatus());
                    data.put("latitude", req.getLiveLatitude());
                    data.put("longitude", req.getLiveLongitude());
                    data.put("eta", req.getEta());
                    data.put("distance", req.getDistance());
                    return ResponseEntity.ok(data);
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
