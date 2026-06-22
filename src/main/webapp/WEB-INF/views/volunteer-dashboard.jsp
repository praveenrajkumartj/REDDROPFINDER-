<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volunteer Dashboard - REDDROP Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Leaflet -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="https://unpkg.com/leaflet-routing-machine@3.2.12/dist/leaflet-routing-machine.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="https://unpkg.com/leaflet-routing-machine@3.2.12/dist/leaflet-routing-machine.js"></script>
    <style>
        #missionMap { height: 450px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); margin-top: 1rem; border: 1px solid rgba(0,0,0,0.05); }
        .mission-step { flex: 1; text-align: center; padding: 1.5rem; position: relative; }
        .mission-step:not(:last-child)::after { content: ''; position: absolute; top: 50%; right: -15px; width: 30px; height: 1px; background: #cbd5e1; z-index: 1; }
        .step-icon { width: 45px; height: 45px; border-radius: 50%; background: #f1f5f9; display: flex; align-items: center; justify-content: center; margin: 0 auto 0.5rem; border: 2px solid #fff; z-index: 2; position: relative; }
        .step-active .step-icon { background: var(--primary); color: white; border-color: var(--primary); box-shadow: 0 0 15px rgba(255, 30, 66, 0.3); }
        .step-completed .step-icon { background: #2dc653; color: white; border-color: #2dc653; }
        .notif-icon-circle { width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.9rem; flex-shrink: 0; }
        .notification-item { transition: background 0.2s; cursor: pointer; border-left: 3px solid transparent; }
        .notification-item:hover { background: #f8f9fa !important; border-left-color: var(--primary); }
    </style>
</head>
<body>
<div class="dashboard-layout">
    <!-- Sidebar -->
    <aside class="sidebar">
        <a href="${pageContext.request.contextPath}/" class="sidebar-brand-new pt-1 text-decoration-none">
            <img src="${pageContext.request.contextPath}/images/reddrop_pulse_logo.png" alt="Logo" class="sidebar-logo-clean" 
                 style="height: 48px; filter: brightness(1.1) drop-shadow(0 0 12px rgba(255, 30, 66, 0.3));">
            <div class="sidebar-brand-text">
                <span class="brand-part-white">REDDROP</span><span class="brand-part-red">FINDER</span>
            </div>
        </a>
        
        <div class="sidebar-role mb-4">TRANSPORT VOLUNTEER</div>
        
        <div class="text-center mb-5">
            <a href="${pageContext.request.contextPath}/profile" class="text-decoration-none">
                <div class="avatar-dashboard mx-auto shadow-sm position-relative overflow-hidden" style="background: linear-gradient(135deg, #00A3FF, #0066CC);">
                    <c:choose>
                        <c:when test="${not empty user.profileImage}">
                            <img src="${pageContext.request.contextPath}/uploads/profiles/${user.profileImage}" alt="${user.name}" style="width:100%; height:100%; object-fit:cover;">
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-car text-white"></i>
                        </c:otherwise>
                    </c:choose>
                    <div class="avatar-hover-overlay">
                        <i class="fas fa-edit text-white" style="font-size: 1rem;"></i>
                    </div>
                </div>
            </a>
            <div class="text-white mt-3 fw-bold" style="font-size:1.15rem;">${user.name}</div>
            <div class="d-flex align-items-center justify-content-center mt-1" style="color:rgba(255,255,255,0.45); font-size:0.85rem;">
                <span class="dot me-2 ${volunteer.availabilityStatus == 'AVAILABLE' ? 'bg-success' : 'bg-danger'}" style="width:8px;height:8px;border-radius:50%;"></span>
                ${volunteer.availabilityStatus}
            </div>
        </div>

        <ul class="sidebar-nav sidebar-nav-main">
            <li class="nav-item">
                <a class="nav-link active" href="#">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/volunteer/history">
                    <i class="fas fa-route"></i> Transport History
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/volunteer/vehicle">
                    <i class="fas fa-id-card"></i> Vehicle Info
                </a>
            </li>
        </ul>

        <div class="mt-auto">
            <form action="${pageContext.request.contextPath}/volunteer/toggle-availability" method="post" class="px-3 mb-4">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="btn ${volunteer.availabilityStatus == 'AVAILABLE' ? 'btn-outline-danger' : 'btn-success'} w-100 rounded-pill fw-bold">
                    ${volunteer.availabilityStatus == 'AVAILABLE' ? 'Go Offline' : 'Go Online'}
                </button>
            </form>
            <div class="sidebar-divider mb-4"></div>
            <ul class="sidebar-nav">
                <li class="nav-item">
                    <form action="${pageContext.request.contextPath}/logout" method="post" class="p-0 m-0">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn-logout-sidebar">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </button>
                    </form>
                </li>
            </ul>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="dashboard-content">
        <div class="dashboard-header d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
            <div>
                <h1 class="dashboard-title mb-1">
                    <i class="fas fa-ambulance me-2" style="color:#e63946;"></i>Volunteer Dashboard
                </h1>
                <p class="text-muted small mb-0">Monitor your rescue missions and availability.</p>
            </div>
            <div class="d-flex align-items-center gap-3">
                <button class="btn btn-light position-relative rounded-circle p-2 border shadow-sm" type="button" data-bs-toggle="dropdown" aria-expanded="false" id="notifBell">
                    <i class="fas fa-bell fs-5" style="color: #00A3FF;"></i>
                    <c:if test="${unreadCount > 0}">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" id="notifBadge">
                            ${unreadCount}
                        </span>
                    </c:if>
                </button>
                <div class="dropdown-menu dropdown-menu-end shadow-lg border-0 p-0 rounded-4 mt-2" style="width: 350px; overflow: hidden;">
                    <div class="p-3 bg-primary text-white d-flex justify-content-between align-items-center">
                        <h6 class="mb-0 fw-bold">Notifications</h6>
                        <button onclick="markAllRead()" class="btn btn-link text-white btn-sm p-0 text-decoration-none small" style="font-size: 0.75rem;">Mark all as read</button>
                    </div>
                    <div class="notification-list" style="max-height: 400px; overflow-y: auto;">
                        <c:choose>
                            <c:when test="${not empty notifications}">
                                <c:forEach var="n" items="${notifications}">
                                    <div class="p-3 border-bottom notification-item ${n.readStatus ? '' : 'bg-light'}">
                                        <div class="d-flex gap-3">
                                            <div class="notif-icon-circle ${n.notificationType == 'TRANSPORT_ALERT' ? 'bg-info-subtle text-info' : (n.notificationType == 'TRANSPORT_HELP_REQUEST' ? 'bg-danger-subtle text-danger' : 'bg-primary-subtle text-primary')}">
                                                <i class="fas ${n.notificationType == 'TRANSPORT_ALERT' ? 'fa-truck-loading' : (n.notificationType == 'TRANSPORT_HELP_REQUEST' ? 'fa-ambulance' : 'fa-info-circle')}"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <h6 class="mb-1 small fw-bold text-dark">${n.title}</h6>
                                                    <fmt:parseDate value="${n.createdTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
                                                    <small class="text-muted" style="font-size: 0.7rem;"><fmt:formatDate value="${parsedDateTime}" pattern="HH:mm" /></small>
                                                </div>
                                                <p class="mb-0 text-muted small" style="font-size: 0.8rem; line-height: 1.4;">${n.message}</p>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="p-5 text-center text-muted">
                                    <i class="fas fa-bell-slash fa-2x mb-2 opacity-25"></i>
                                    <p class="small mb-0">No notifications yet</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="p-2 text-center bg-light border-top">
                        <a href="${pageContext.request.contextPath}/notifications" class="text-decoration-none small text-primary fw-bold">See all notifications</a>
                    </div>
                </div>
            </div>
        </div>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show rounded-4 shadow-sm mb-4" role="alert">
                <div class="d-flex align-items-center gap-3">
                    <div class="alert-icon bg-success text-white rounded-circle d-flex align-items-center justify-content-center" style="width:30px;height:30px;flex-shrink:0;">
                        <i class="fas fa-check small"></i>
                    </div>
                    <div><strong>Success!</strong> ${successMessage}</div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show rounded-4 shadow-sm mb-4" role="alert">
                <div class="d-flex align-items-center gap-3">
                    <div class="alert-icon bg-danger text-white rounded-circle d-flex align-items-center justify-content-center" style="width:30px;height:30px;flex-shrink:0;">
                        <i class="fas fa-exclamation small"></i>
                    </div>
                    <div><strong>Error!</strong> ${errorMessage}</div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Stats Grid -->
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon stat-icon-blue"><i class="fas fa-road"></i></div>
                    <div class="stat-number text-danger">${not empty totalMissions ? totalMissions : 0}</div>
                    <div class="stat-label">Total Missions</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon stat-icon-red"><i class="fas fa-star"></i></div>
                    <div class="stat-number text-danger">5.0</div>
                    <div class="stat-label">Rating</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon stat-icon-green"><i class="fas fa-check-circle"></i></div>
                    <div class="stat-number text-danger" style="font-size: 1.8rem;">${volunteer.availabilityStatus}</div>
                    <div class="stat-label">System Status</div>
                </div>
            </div>
        </div>

        <c:if test="${not empty activeRequests}">
            <c:forEach var="mission" items="${activeRequests}">
                <div class="card-modern mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="mb-0 fw-800"><i class="fas fa-map-marker-alt text-primary me-2"></i>Active Transport Mission</h4>
                        <span class="badge bg-primary px-3 py-2 rounded-pill">${mission.status}</span>
                    </div>

                    <div class="row g-4 mb-4">
                        <div class="col-md-4">
                            <div class="p-3 bg-light rounded-4">
                                <small class="text-muted d-block mb-1">PICKUP DONOR</small>
                                <h6 class="mb-0 fw-bold">${mission.donor.name}</h6>
                                <p class="small text-muted mb-0">${mission.donor.phone}</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3 bg-light rounded-4">
                                <small class="text-muted d-block mb-1">DESTINATION HOSPITAL</small>
                                <h6 class="mb-0 fw-bold">${mission.hospital.name}</h6>
                                <p class="small text-muted mb-0">${mission.hospital.city}</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3 bg-primary bg-opacity-10 rounded-4 border border-primary border-opacity-25 h-100">
                                <small class="text-primary d-block mb-1 fw-bold">ESTIMATED ARRIVAL</small>
                                <h4 class="mb-0 fw-800 text-primary mission-eta">Calculating...</h4>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3 bg-light rounded-4">
                                <small class="text-muted d-block mb-1">VEHICLE</small>
                                <h6 class="mb-0 fw-bold">${volunteer.vehicleType}</h6>
                                <p class="small text-muted mb-0">${volunteer.vehicleNumber}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Workflow -->
                    <div class="d-flex mb-4">
                        <div class="mission-step ${mission.status == 'ACCEPTED' ? 'step-active' : 'step-completed'}">
                            <div class="step-icon"><i class="fas fa-hand-holding-heart"></i></div>
                            <small class="fw-bold">Accepted</small>
                        </div>
                        <div class="mission-step ${mission.status == 'ON_THE_WAY' ? 'step-active' : (mission.status == 'PICKED_UP' || mission.status == 'REACHED_HOSPITAL' || mission.status == 'COMPLETED' ? 'step-completed' : '')}">
                            <div class="step-icon"><i class="fas fa-route"></i></div>
                            <small class="fw-bold">On the Way</small>
                        </div>
                        <div class="mission-step ${mission.status == 'PICKED_UP' ? 'step-active' : (mission.status == 'REACHED_HOSPITAL' || mission.status == 'COMPLETED' ? 'step-completed' : '')}">
                            <div class="step-icon"><i class="fas fa-user-check"></i></div>
                            <small class="fw-bold">Picked Up</small>
                        </div>
                        <div class="mission-step ${mission.status == 'REACHED_HOSPITAL' ? 'step-active' : (mission.status == 'COMPLETED' ? 'step-completed' : '')}">
                            <div class="step-icon"><i class="fas fa-hospital"></i></div>
                            <small class="fw-bold">At Hospital</small>
                        </div>
                    </div>

                    <div id="missionMap"></div>

                    <div class="mt-4 d-flex gap-2">
                        <c:if test="${mission.status == 'ACCEPTED'}">
                            <form action="${pageContext.request.contextPath}/volunteer/update-status" method="post" class="flex-grow-1">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="requestId" value="${mission.id}"/>
                                <input type="hidden" name="status" value="ON_THE_WAY"/>
                                <button type="submit" class="btn btn-primary w-100 py-3 rounded-4 fw-bold shadow-sm">Start Journey</button>
                            </form>
                        </c:if>
                        <c:if test="${mission.status == 'ON_THE_WAY'}">
                            <form action="${pageContext.request.contextPath}/volunteer/update-status" method="post" class="flex-grow-1">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="requestId" value="${mission.id}"/>
                                <input type="hidden" name="status" value="PICKED_UP"/>
                                <button type="submit" class="btn btn-warning w-100 py-3 rounded-4 fw-bold shadow-sm">Mark Picked Up</button>
                            </form>
                        </c:if>
                        <c:if test="${mission.status == 'PICKED_UP'}">
                            <form action="${pageContext.request.contextPath}/volunteer/update-status" method="post" class="flex-grow-1">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="requestId" value="${mission.id}"/>
                                <input type="hidden" name="status" value="REACHED_HOSPITAL"/>
                                <button type="submit" class="btn btn-success w-100 py-3 rounded-4 fw-bold shadow-sm">Reached Hospital</button>
                            </form>
                        </c:if>
                        <c:if test="${mission.status == 'REACHED_HOSPITAL'}">
                            <form action="${pageContext.request.contextPath}/volunteer/update-status" method="post" class="flex-grow-1">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="requestId" value="${mission.id}"/>
                                <input type="hidden" name="status" value="COMPLETED"/>
                                <button type="submit" class="btn btn-dark w-100 py-3 rounded-4 fw-bold shadow-sm">Finish Mission</button>
                            </form>
                        </c:if>
                        
                        <a href="https://www.google.com/maps/dir/?api=1&destination=${mission.requestLatitude},${mission.requestLongitude}" 
                           target="_blank" class="btn btn-outline-info py-3 px-4 rounded-4 fw-bold shadow-sm">
                            <i class="fas fa-map-marked-alt me-1"></i>Map
                        </a>
                        
                        <!-- Premium Cancel Confirmation Modal Trigger -->
                        <button type="button" class="btn btn-outline-danger py-3 px-4 rounded-4 fw-bold" 
                                data-bs-toggle="modal" data-bs-target="#cancelModal-${mission.id}">
                            <i class="fas fa-times me-1"></i> Cancel
                        </button>
                    </div>
                <div id="missionData" 
                     data-dlat="${not empty mission.requestLatitude ? mission.requestLatitude : 0}"
                     data-dlon="${not empty mission.requestLongitude ? mission.requestLongitude : 0}"
                     data-hlat="${not empty mission.hospital.latitude ? mission.hospital.latitude : 0}"
                     data-hlon="${not empty mission.hospital.longitude ? mission.hospital.longitude : 0}"
                     data-status="${mission.status}"
                     data-id="${mission.id}"
                     data-csrf-p="${_csrf.parameterName}"
                     data-csrf-t="${_csrf.token}"
                     data-url="${pageContext.request.contextPath}/volunteer/update-location">
                </div>

                <script>
                    document.addEventListener('DOMContentLoaded', function() {
                        var dataEl = document.getElementById('missionData');
                        var dLat = parseFloat(dataEl.dataset.dlat);
                        var dLon = parseFloat(dataEl.dataset.dlon);
                        var hLat = parseFloat(dataEl.dataset.hlat);
                        var hLon = parseFloat(dataEl.dataset.hlon);
                        var mStatus = dataEl.dataset.status;
                        var mId = dataEl.dataset.id;
                        
                        if (dLat === 0 && dLon === 0) return;

                        var map = L.map('missionMap').setView([dLat, dLon], 13);
                        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

                        var donorIcon = L.divIcon({ className: 'custom-div-icon', html: "<i class='fas fa-user-circle' style='color:#e63946;font-size:32px;'></i>" });
                        var hospitalIcon = L.divIcon({ className: 'custom-div-icon', html: "<i class='fas fa-hospital' style='color:#1d3557;font-size:32px;'></i>" });
                        var volunteerIcon = L.divIcon({ className: 'custom-div-icon', html: "<i class='fas fa-motorcycle' style='color:#2dc653;font-size:32px;'></i>" });

                        var donorMarker = L.marker([dLat, dLon], { icon: donorIcon }).addTo(map).bindPopup("Donor");
                        var hospitalMarker = L.marker([hLat, hLon], { icon: hospitalIcon }).addTo(map).bindPopup("Hospital");
                        var volunteerMarker = L.marker([dLat, dLon], { icon: volunteerIcon }).addTo(map).bindPopup("Your Location");

                        var routingControl = L.Routing.control({
                            waypoints: [],
                            routeWhileDragging: false,
                            addWaypoints: false,
                            createMarker: function() { return null; }
                        }).addTo(map);

                        // Start tracking
                        if (navigator.geolocation && (mStatus !== "COMPLETED")) {
                            navigator.geolocation.watchPosition(function(pos) {
                                var vLat = pos.coords.latitude;
                                var vLon = pos.coords.longitude;
                                
                                volunteerMarker.setLatLng([vLat, vLon]);
                                
                                // Determine destination based on status
                                var destLat = dLat;
                                var destLon = dLon;
                                if (mStatus === "PICKED_UP" || mStatus === "ON_THE_WAY") {
                                    destLat = hLat;
                                    destLon = hLon;
                                }

                                routingControl.setWaypoints([
                                    L.latLng(vLat, vLon),
                                    L.latLng(destLat, destLon)
                                ]);

                                routingControl.on('routesfound', function(e) {
                                    var routes = e.routes;
                                    var summary = routes[0].summary;
                                    var distanceKm = (summary.totalDistance / 1000).toFixed(2);
                                    var timeMin = Math.round(summary.totalTime / 60);
                                    
                                    // Update UI
                                    const etaDisplay = document.querySelector('.mission-eta');
                                    if(etaDisplay) etaDisplay.innerText = timeMin + ' mins (' + distanceKm + ' km)';

                                    // Send to server
                                    var formData = new URLSearchParams();
                                    formData.append('requestId', mId);
                                    formData.append('lat', vLat);
                                    formData.append('lon', vLon);
                                    formData.append('distance', distanceKm);
                                    formData.append('eta', timeMin + ' mins');
                                    formData.append(dataEl.dataset.csrfP, dataEl.dataset.csrfT);

                                    fetch(dataEl.dataset.url, {
                                        method: 'POST',
                                        body: formData
                                    });
                                });
                            }, function(err) {
                                console.error(err);
                            }, { enableHighAccuracy: true });
                        }
                    });
                </script>
            </c:forEach>
        </c:if>
        <!-- My Registered Camps -->
        <c:if test="${not empty registeredCamps}">
            <div class="card-modern mb-4">
                <div class="card-title-modern">
                    <i class="fas fa-tent text-primary"></i>My Registered Camps
                </div>
                <div class="row g-4 mt-2">
                    <c:forEach var="camp" items="${registeredCamps}">
                        <div class="col-md-6 col-lg-4">
                            <div class="p-3 border rounded-4 bg-white shadow-sm position-relative">
                                <div class="position-absolute top-0 end-0 mt-3 me-3">
                                    <span class="badge bg-success-subtle text-success"><i class="fas fa-check-circle me-1"></i> Registered</span>
                                </div>
                                <h6 class="fw-bold mb-1" style="max-width: 80%;">${camp.campName}</h6>
                                <div class="text-muted small mb-2"><i class="fas fa-building me-1"></i>${camp.organizer}</div>
                                <div class="d-flex align-items-center gap-3 text-muted" style="font-size: 0.85rem;">
                                    <div><i class="fas fa-calendar-alt me-1 text-primary"></i> ${camp.date}</div>
                                    <div><i class="fas fa-map-marker-alt me-1 text-danger"></i> ${camp.location}</div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <!-- New Requests Section -->
        <div class="card-modern">
            <h4 class="card-title-modern mb-4"><i class="fas fa-bell text-warning me-2"></i>Nearby Transport Requests</h4>
            <div class="table-responsive">
                <table class="table-modern">
                    <thead>
                        <tr>
                            <th>Donor</th>
                            <th>From</th>
                            <th>Hospital</th>
                            <th>Urgency</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="req" items="${pendingRequests}">
                            <tr class="${req.status == 'PENDING' ? 'table-warning-subtle' : ''}">
                                <td>
                                    <div class="fw-bold">${req.donor.name}</div>
                                </td>
                                <td>
                                    <div class="small"><i class="fas fa-location-dot text-primary me-1"></i>${req.donor.city}</div>
                                </td>
                                <td>
                                    <div class="small fw-bold">${req.hospital.name}</div>
                                </td>
                                <td>
                                    <span class="badge bg-danger rounded-pill shadow-sm">
                                        <i class="fas fa-bolt me-1"></i>EMERGENCY HELP
                                    </span>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/volunteer/accept-request" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <input type="hidden" name="requestId" value="${req.id}"/>
                                        <button type="submit" class="btn btn-sm btn-primary rounded-pill px-3 shadow-sm fw-bold">
                                            <i class="fas fa-check me-1"></i>Accept Help
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty pendingRequests}">
                            <tr>
                                <td colspan="5" class="text-center py-4 text-muted">No pending transport requests in your area.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>
<script>
    // Mark All Read API
    window.markAllRead = function() {
        fetch('${pageContext.request.contextPath}/notifications/mark-read', {
            method: 'POST',
            headers: { 'X-CSRF-TOKEN': '${_csrf.token}' }
        }).then(() => {
            const badge = document.getElementById('notifBadge');
            if(badge) badge.remove();
            document.querySelectorAll('.notification-item').forEach(item => item.classList.remove('bg-light'));
        });
    };
</script>
<!-- Global Modals -->
<c:if test="${not empty activeRequests}">
    <c:forEach var="mission" items="${activeRequests}">
        <!-- Cancel Mission Modal -->
        <div class="modal fade" id="cancelModal-${mission.id}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content rounded-5 border-0 shadow-lg">
                    <div class="modal-body p-5 text-center">
                        <div class="mb-4">
                            <i class="fas fa-exclamation-triangle text-warning display-1 opacity-25"></i>
                        </div>
                        <h3 class="fw-800 mb-3" style="color:#1d3557;">Cancel Mission?</h3>
                        <p class="text-muted mb-5">Are you sure you want to cancel this mission? This request will be returned to the pool for another hero to complete.</p>
                        
                        <div class="d-flex gap-3 justify-content-center">
                            <button type="button" class="btn btn-light px-4 py-2 rounded-pill fw-bold" data-bs-dismiss="modal">Go Back</button>
                            <form action="${pageContext.request.contextPath}/volunteer/update-status" method="post">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="requestId" value="${mission.id}"/>
                                <input type="hidden" name="status" value="CANCELLED"/>
                                <button type="submit" class="btn btn-danger px-4 py-2 rounded-pill fw-bold" style="background-color: #e63946; border: none;">Yes, Cancel Ride</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
</c:if>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
