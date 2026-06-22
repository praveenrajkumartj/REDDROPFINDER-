<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donor Dashboard - Blood Donor Emergency Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Leaflet -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <style>
        .tracking-card { background: linear-gradient(135deg, #1d3557 0%, #0d1b2a 100%); color: white; border-radius: 20px; overflow: hidden; }
        .emergency-pulse { animation: pulse-red 2s infinite; border: 2px solid #e63946; border-radius: 50%; width: 12px; height: 12px; display: inline-block; background: #e63946; margin-right: 8px; }
        @keyframes pulse-red { 0% { box-shadow: 0 0 0 0 rgba(230, 57, 70, 0.7); } 70% { box-shadow: 0 0 0 10px rgba(230, 57, 70, 0); } 100% { box-shadow: 0 0 0 0 rgba(230, 57, 70, 0); } }
        #trackingMap { height: 250px; border-radius: 15px; margin-top: 1rem; }
        .notif-icon-circle { width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.9rem; flex-shrink: 0; }
        .notification-item { transition: background 0.2s; cursor: pointer; border-left: 3px solid transparent; }
        .notification-item:hover { background: #f8f9fa !important; border-left-color: var(--primary); }
    </style>
    <!-- Store User Coordinates for fallback -->
    <div id="userProfileCoords" 
         data-lat="${not empty user.latitude ? user.latitude : '20.5937'}" 
         data-lon="${not empty user.longitude ? user.longitude : '78.9629'}" 
         style="display:none;"></div>
</head>
<body>
<div class="dashboard-layout">

    <!-- ===== SIDEBAR ===== -->
    <aside class="sidebar">
        <a href="${pageContext.request.contextPath}/" class="sidebar-brand-new pt-1 text-decoration-none">
            <img src="${pageContext.request.contextPath}/images/reddrop_pulse_logo.png" alt="Logo" class="sidebar-logo-clean" 
                 style="height: 48px; filter: brightness(1.1) drop-shadow(0 0 12px rgba(255, 30, 66, 0.3));">
            <div class="sidebar-brand-text">
                <span class="brand-part-white">REDDROP</span><span class="brand-part-red">FINDER</span>
            </div>
        </a>
        
        <div class="sidebar-role mb-4">LIFE SAVER</div>
        
        <div class="text-center mb-5">
            <a href="${pageContext.request.contextPath}/profile" class="text-decoration-none">
                <div class="avatar-dashboard mx-auto shadow-sm position-relative overflow-hidden" style="background:var(--primary);">
                    <c:choose>
                        <c:when test="${not empty user.profileImage}">
                            <img src="${pageContext.request.contextPath}/uploads/profiles/${user.profileImage}" alt="${user.name}" style="width:100%; height:100%; object-fit:cover;">
                        </c:when>
                        <c:otherwise>
                            <span class="text-white fw-800" style="font-size:2rem;">${user.name.charAt(0)}</span>
                        </c:otherwise>
                    </c:choose>
                    <div class="avatar-hover-overlay">
                        <i class="fas fa-edit text-white" style="font-size: 1rem;"></i>
                    </div>
                </div>
            </a>
            <div class="text-white mt-3 fw-bold" style="font-size:1.15rem; letter-spacing: 0.3px;">${user.name}</div>
            <div class="d-flex align-items-center justify-content-center mt-1" style="color:rgba(255,255,255,0.45); font-size:0.85rem; font-weight: 500;">
                <i class="fas fa-location-dot me-2" style="font-size: 0.75rem;"></i>${user.city}
            </div>
        </div>

        <ul class="sidebar-nav sidebar-nav-main">
            <li class="nav-item">
                <a class="nav-link active" href="${pageContext.request.contextPath}/donor/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/donor/donation-history">
                    <i class="fas fa-history"></i> Donation History
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/search-donor">
                    <i class="fas fa-search"></i> Find Donors
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/blood-camps">
                    <i class="fas fa-hospital"></i> Blood Camps
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/impact">
                    <i class="fas fa-chart-line"></i> Impact Stats
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/support/verify">
                    <i class="fas fa-award"></i> Badges & Verification
                </a>
            </li>
        </ul>

        <div class="mt-auto">
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

    <!-- ===== MAIN CONTENT ===== -->
    <main class="dashboard-content">
        <!-- Header -->
        <div class="dashboard-header d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
            <div>
                <h1 class="dashboard-title mb-1">
                    <span class="text-primary"><i class="fas fa-tachometer-alt me-2"></i></span>Donor Overview
                </h1>
                <p class="text-muted small mb-0">Monitor your contributions and track active missions.</p>
            </div>
            <div class="d-flex align-items-center gap-3">
                <!-- Notification Bell -->
                <div class="dropdown">
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
                                                <div class="notif-icon-circle ${n.notificationType == 'BLOOD_REQUEST' ? 'bg-danger-subtle text-danger' : 'bg-primary-subtle text-primary'}">
                                                    <i class="fas ${n.notificationType == 'BLOOD_REQUEST' ? 'fa-heartbeat' : 'fa-info-circle'}"></i>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <div class="d-flex justify-content-between align-items-start">
                                                        <h6 class="mb-1 small fw-bold text-dark">${n.title}</h6>
                                                        <small class="text-muted" style="font-size: 0.7rem;">
                                                            <fmt:parseDate value="${n.createdTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
                                                            <fmt:formatDate value="${parsedDateTime}" pattern="HH:mm" />
                                                        </small>
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

                <div class="d-flex gap-2">
                    <c:choose>
                        <c:when test="${isEligible}">
                            <span class="badge bg-success-subtle text-success d-flex align-items-center"><i class="fas fa-check-circle me-1"></i> Eligible to Donate</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-warning-subtle text-warning d-flex align-items-center"><i class="fas fa-clock me-1"></i> Next cycle pending</span>
                        </c:otherwise>
                    </c:choose>
                    <span id="gpsStatus" class="badge bg-light text-dark d-flex align-items-center"><i class="fas fa-location-dot me-1 text-primary"></i> GPS Ready</span>
                </div>
            </div>
        </div>

        <!-- Flash Messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-auto-dismiss d-flex align-items-center gap-2 mb-4 shadow-sm border-0">
                <i class="fas fa-check-circle"></i>${successMessage}
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-auto-dismiss d-flex align-items-center gap-2 mb-4 shadow-sm border-0">
                <i class="fas fa-exclamation-triangle"></i>${errorMessage}
            </div>
        </c:if>
        
        <!-- ACTIVE REQUESTS (LIVE TRACKING) -->
        <c:if test="${not empty activeRequests}">
            <c:forEach var="req" items="${activeRequests}">
                <div class="tracking-card p-4 mb-4 shadow-lg border-0">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <span class="badge bg-danger mb-2"><i class="fas fa-ambulance me-2"></i>ACTIVE MISSION</span>
                            <h4 class="mb-0">Request for ${req.bloodGroup} Blood</h4>
                            <p class="text-white-50 small mb-0"><i class="fas fa-hospital me-1"></i> Destination: ${req.hospitalName}</p>
                        </div>
                        <div class="text-end">
                            <div class="h3 mb-0 text-danger fw-bold" id="liveEta">${not empty req.eta ? req.eta : '--'}</div>
                            <div class="small text-white-50">Est. Arrival</div>
                        </div>
                    </div>
                    
                    <div class="row g-3 align-items-center">
                        <div class="col-md-8">
                            <div id="trackingMap_${req.id}" 
                                 class="request-tracking-container"
                                 style="height: 180px; border-radius:15px; border: 1px solid #eee;"
                                 data-request-id="${req.id}"
                                 data-lat="${not empty req.liveLatitude ? req.liveLatitude : 20.5937}"
                                 data-lon="${not empty req.liveLongitude ? req.liveLongitude : 78.9629}"
                                 data-csrf-p="${_csrf.parameterName}"
                                 data-csrf-t="${_csrf.token}"
                                 data-update-url="${pageContext.request.contextPath}/donor/update-location">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="bg-white bg-opacity-10 p-3 rounded-4 h-100">
                                <h6 class="text-white-50 small text-uppercase mb-3">Donor Instructions</h6>
                                <p class="small mb-4">Your live location is being shared with the patient. Please maintain a safe speed.</p>
                                
                                <c:choose>
                                    <c:when test="${req.status == 'ACCEPTED'}">
                                        <form action="${pageContext.request.contextPath}/donor/update-status" method="post" class="mb-2">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <input type="hidden" name="requestId" value="${req.id}">
                                            <input type="hidden" name="status" value="ON_THE_WAY">
                                            <button type="submit" class="btn btn-warning w-100 fw-bold py-2 rounded-3 shadow-sm">
                                                <i class="fas fa-motorcycle me-2"></i>I am On The Way
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:when test="${req.status == 'ON_THE_WAY'}">
                                        <form action="${pageContext.request.contextPath}/donor/update-status" method="post" class="mb-2">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <input type="hidden" name="requestId" value="${req.id}">
                                            <input type="hidden" name="status" value="REACHED_HOSPITAL">
                                            <button type="submit" class="btn btn-info w-100 fw-bold py-2 rounded-3 shadow-sm text-white">
                                                <i class="fas fa-hospital me-2"></i>I Have Reached
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-info py-2 small mb-2" style="background:rgba(255,255,255,0.1); border:none; color:white;">
                                            <i class="fas fa-check-circle me-1"></i> Ready for Handshake.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                                <c:choose>
                                    <c:when test="${hospitalRegisteredMap[req.id] == false}">
                                        <div class="mt-3 p-3 text-center rounded-4" style="background: rgba(255,255,255,0.08); border: 1px dashed rgba(255,255,255,0.2);">
                                            <div class="small text-white-50 text-uppercase mb-1" style="letter-spacing:1px;">Handshake Code</div>
                                            <div class="h3 mb-0 fw-bold text-warning" style="letter-spacing:4px;">
                                        <c:choose>
                                            <c:when test="${not empty req.verificationCode}">${req.verificationCode}</c:when>
                                            <c:otherwise><span style="letter-spacing:normal; font-size:1rem; opacity:0.7;">GENERATING...</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                            <div class="small text-white-50 mt-1">Share this with the patient to verify donation.</div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="mt-3 p-3 text-center rounded-4" style="background: rgba(0, 163, 255, 0.1); border: 1px solid rgba(0, 163, 255, 0.2);">
                                            <div class="text-primary fw-bold small"><i class="fas fa-hospital-user me-2"></i>Verified Hospital Facility</div>
                                            <div class="text-white-50 small mt-1">Fulfillment will be handled by medical staff.</div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <a href="https://www.google.com/maps/dir/?api=1&destination=${req.hospitalName}" target="_blank" class="btn btn-outline-light w-100 btn-sm rounded-3 mt-3">
                                    <i class="fas fa-directions me-2"></i>Open Navigation
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>

        <!-- INCOMING EMERGENCY ALERTS (Global Pool) -->
        <c:if test="${not empty availableRequests}">
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card border-0 shadow-sm p-4" style="background:#fff5f5; border-left: 5px solid #e63946 !important; border-radius: 15px;">
                        <div class="d-flex align-items-center gap-3 mb-3">
                            <div class="emergency-pulse"></div>
                            <h5 class="mb-0 text-danger fw-bold">Live Emergency Feed - All Locations</h5>
                        </div>
                        <div class="row g-3">
                            <c:forEach var="req" items="${availableRequests}">
                                <div class="col-md-6">
                                    <div class="p-3 bg-white rounded-3 shadow-sm border ${req.bloodGroup eq donor.bloodGroup ? 'border-danger-subtle' : ''}">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <div>
                                                <div class="d-flex align-items-center gap-2 mb-1">
                                                    <span class="badge ${req.bloodGroup eq donor.bloodGroup ? 'bg-danger' : 'bg-secondary'}">${req.bloodGroup}</span>
                                                    <span class="badge bg-light text-dark border"><i class="fas fa-city me-1 text-primary"></i>${req.city}</span>
                                                    <c:if test="${req.bloodGroup eq donor.bloodGroup}">
                                                        <span class="badge bg-success-subtle text-success small" style="font-size:0.6rem;">MATCH</span>
                                                    </c:if>
                                                </div>
                                                <h6 class="mb-0 fw-bold">${req.hospitalName}</h6>
                                                <small class="text-muted"><i class="fas fa-user-injured me-1"></i>Patient: ${req.patientName}</small>
                                                <div class="mt-1">
                                                    <small class="text-danger fw-bold" style="font-size: 0.75rem;"><i class="fas fa-bolt me-1"></i>${req.urgencyLevel} PRIORITY</small>
                                                </div>
                                            </div>
                                            <div class="text-end">
                                                <c:choose>
                                                    <c:when test="${req.bloodGroup eq donor.bloodGroup}">
                                                        <button type="button" class="btn btn-danger px-4 rounded-pill fw-bold shadow-sm"
                                                                data-req-id="${req.id}" 
                                                                data-lat="${not empty req.latitude ? req.latitude : 0}" 
                                                                data-lon="${not empty req.longitude ? req.longitude : 0}" 
                                                                data-hosp="${req.hospitalName}"
                                                                onclick="handleAcceptClick(this)"
                                                                ${isEligible ? '' : 'disabled'}>
                                                            ${isEligible ? 'ACCEPT' : 'INACTIVE'}
                                                        </button>
                                                        <!-- Hidden acceptance form -->
                                                        <form id="acceptForm_${req.id}" action="${pageContext.request.contextPath}/donor/accept-request" method="post" style="display:none;">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                            <input type="hidden" name="requestId" value="${req.id}">
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-muted border px-3 rounded-pill" style="font-size: 0.7rem;">
                                                            TYPE MISMATCH
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Standardized Stats Row -->
        <div class="row g-4 mb-4 d-flex align-items-stretch">
            <!-- Total Donations -->
            <div class="col-sm-6 col-xl-3">
                <div class="modern-stat-card h-100">
                    <div class="stat-mini-icon stat-v-red">
                        <i class="fas fa-tint"></i>
                    </div>
                    <div class="main-stat-visual text-danger">
                        <i class="fas fa-droplet pf-2"></i>
                    </div>
                    <div class="stat-val-main">${totalDonations}</div>
                    <div class="stat-label-main">Total Donations</div>
                </div>
            </div>

            <!-- Potential Lives Saved -->
            <div class="col-sm-6 col-xl-3">
                <div class="modern-stat-card h-100">
                    <div class="stat-mini-icon stat-v-blue">
                        <i class="fas fa-heart"></i>
                    </div>
                    <div class="main-stat-visual text-primary">
                        <i class="fas fa-hand-holding-heart pb-2"></i>
                    </div>
                    <div class="stat-val-main">${totalDonations * 3}</div>
                    <div class="stat-label-main">Lives Saved</div>
                </div>
            </div>

            <!-- Current Status -->
            <div class="col-sm-6 col-xl-3">
                <div class="modern-stat-card h-100">
                    <div class="stat-mini-icon stat-v-green">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="main-stat-visual">
                        <c:choose>
                            <c:when test="${donor.availabilityStatus == 'AVAILABLE'}">
                                <i class="fas fa-check-circle text-success pb-2"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-times-circle text-danger pb-2"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-val-main">
                        <c:choose>
                            <c:when test="${donor.availabilityStatus == 'AVAILABLE'}">Active</c:when>
                            <c:otherwise>Offline</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-label-main">Current Status</div>
                </div>
            </div>

            <!-- Badge Earned -->
            <div class="col-sm-6 col-xl-3">
                <div class="modern-stat-card h-100">
                    <div class="stat-mini-icon stat-v-orange">
                        <i class="fas fa-award"></i>
                    </div>
                    <div class="main-stat-visual">
                        <c:choose>
                            <c:when test="${donor.badge != null}">
                                <i class="fas fa-medal text-warning pulse-badge pb-2"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-medal text-muted opacity-25 pb-2"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-val-main text-primary">
                        <c:choose>
                            <c:when test="${donor.badge != null}">${donor.badge}</c:when>
                            <c:otherwise>None Yet</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-label-main">Badge Earned</div>
                </div>
            </div>
        </div>

        <!-- Donor Profile + Availability Toggle -->
        <div class="row g-4 mb-4">
            <div class="col-lg-6">
                <div class="card-modern">
                    <div class="card-title-modern">
                        <i class="fas fa-id-card text-primary"></i>Donor Profile
                    </div>
                    <c:if test="${donor != null}">
                    <table class="table-modern" style="border-radius:0;">
                        <tbody>
                        <tr>
                            <td><i class="fas fa-user me-2 text-muted"></i><strong>Name</strong></td>
                            <td>${user.name}</td>
                        </tr>
                        <tr>
                            <td><i class="fas fa-tint me-2 text-danger"></i><strong>Blood Group</strong></td>
                            <td><span class="blood-group-badge">${donor.bloodGroup}</span></td>
                        </tr>
                        <tr>
                            <td><i class="fas fa-phone me-2 text-muted"></i><strong>Phone</strong></td>
                            <td>${user.phone}</td>
                        </tr>
                        <tr>
                            <td><i class="fas fa-city me-2 text-muted"></i><strong>City</strong></td>
                            <td>${user.city}</td>
                        </tr>
                        <tr>
                            <td><i class="fas fa-calendar me-2 text-muted"></i><strong>Last Donation</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${donor.lastDonationDate != null}">${donor.lastDonationDate}</c:when>
                                    <c:otherwise><span class="text-muted">Not recorded</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td><i class="fas fa-heartbeat me-2 text-muted"></i><strong>Status</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${donor.availabilityStatus == 'AVAILABLE'}">
                                        <span class="status-badge status-available">
                                            <span class="pulse-dot"></span>Available
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-unavailable">
                                            <i class="fas fa-times-circle"></i>Not Available
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                             </td>
                         </tr>
                         <tr>
                            <td><i class="fas fa-award me-2 text-warning"></i><strong>Eligibility</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${isEligible}">
                                        <span class="badge bg-success" style="font-size: 0.75rem; border-radius: 20px;">
                                            <i class="fas fa-check me-1"></i> READY TO DONATE
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary" style="font-size: 0.75rem; border-radius: 20px;">
                                            <i class="fas fa-hourglass-half me-1"></i> RECOVERY PERIOD
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                         </tr>
                         </tbody>
                    </table>
                    </c:if>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="card-modern">
                    <div class="card-title-modern">
                        <i class="fas fa-toggle-on text-primary"></i>Availability Control
                    </div>
                    <div class="text-center p-4">
                        <div class="mb-3">
                            <c:choose>
                                <c:when test="${donor.availabilityStatus == 'AVAILABLE'}">
                                    <div style="width:100px;height:100px;border-radius:50%;background:linear-gradient(135deg,#2dc653,#1a9f3e);
                                         display:flex;align-items:center;justify-content:center;margin:0 auto;
                                         box-shadow:0 10px 30px rgba(45,198,83,0.3);">
                                        <i class="fas fa-check fa-2xl" style="color:white;font-size:2.5rem;"></i>
                                    </div>
                                    <h5 class="mt-3 text-success">Currently Available</h5>
                                    <p class="text-muted">You're visible to patients searching for donors.</p>
                                </c:when>
                                <c:otherwise>
                                    <div style="width:100px;height:100px;border-radius:50%;background:linear-gradient(135deg,#e63946,#c1121f);
                                         display:flex;align-items:center;justify-content:center;margin:0 auto;
                                         box-shadow:0 10px 30px rgba(230,57,70,0.3);">
                                        <i class="fas fa-times fa-2xl" style="color:white;font-size:2.5rem;"></i>
                                    </div>
                                    <h5 class="mt-3 text-danger">Currently Unavailable</h5>
                                    <p class="text-muted">You are hidden from donor search results.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <form action="${pageContext.request.contextPath}/donor/toggle-availability" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <c:choose>
                                <c:when test="${donor.availabilityStatus == 'AVAILABLE'}">
                                    <button type="submit" class="btn-outline-custom" style="padding:0.7rem 2rem;">
                                        <i class="fas fa-ban me-2"></i>Set as Unavailable
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" class="btn-primary-custom" style="padding:0.7rem 2rem;">
                                        <i class="fas fa-check me-2"></i>Set as Available
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Volunteer Transport Status -->
        <c:if test="${not empty transportRequests}">
            <div class="card-modern border-primary" style="background: rgba(0, 163, 255, 0.02);">
                <div class="card-title-modern">
                    <i class="fas fa-truck-pickup text-primary"></i>Volunteer Transport Status
                </div>
                <div class="row g-4">
                    <c:forEach var="tr" items="${transportRequests}">
                        <div class="col-md-12">
                            <div class="p-3 border rounded-4 bg-white shadow-sm">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="stat-icon stat-icon-blue" style="width:40px;height:40px;font-size:1rem;">
                                            <i class="fas fa-ambulance"></i>
                                        </div>
                                        <div>
                                            <h6 class="mb-0 fw-bold">
                                                <c:choose>
                                                    <c:when test="${not empty tr.volunteer}">
                                                        Volunteer: ${tr.volunteer.user.name} (${tr.volunteer.vehicleType})
                                                    </c:when>
                                                    <c:otherwise>Searching for nearby volunteer...</c:otherwise>
                                                </c:choose>
                                            </h6>
                                            <div class="d-flex align-items-center gap-2 mt-1">
                                                <span class="badge bg-light text-dark rounded-pill border small">${tr.status}</span>
                                                <c:if test="${not empty tr.eta}">
                                                    <span class="text-primary small fw-bold"><i class="fas fa-clock me-1"></i>${tr.eta}</span>
                                                </c:if>
                                                <c:if test="${not empty tr.distance}">
                                                    <span class="text-muted small"><i class="fas fa-road me-1"></i>${tr.distance} km</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                    <c:if test="${not empty tr.volunteer}">
                                        <a href="tel:${tr.volunteer.user.phone}" class="btn btn-sm btn-outline-primary rounded-pill">
                                            <i class="fas fa-phone me-1"></i>Contact
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
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

        <!-- Recent Donations -->
        <div class="card-modern">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="card-title-modern mb-0">
                    <i class="fas fa-history text-primary"></i>Recent Donations
                </div>
                <a href="${pageContext.request.contextPath}/donor/donation-history"
                   class="btn-outline-custom" style="padding:0.4rem 1rem;font-size:0.85rem;">
                    View All
                </a>
            </div>

            <c:choose>
                <c:when test="${not empty donationHistory}">
                <div class="table-responsive">
                    <table class="table-modern">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Hospital</th>
                            <th>Patient</th>
                            <th>Date</th>
                            <th>Units</th>
                            <th>Certificate</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="hist" items="${donationHistory}" begin="0" end="4" varStatus="status">
                        <tr>
                            <td>${status.count}</td>
                            <td><i class="fas fa-hospital me-1 text-muted"></i>${hist.hospitalName}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty hist.patientName}">${hist.patientName}</c:when>
                                    <c:otherwise><span class="text-muted">Anonymous</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td><i class="fas fa-calendar me-1 text-muted"></i>${hist.donationDate}</td>
                            <td><span class="blood-group-badge" style="font-size:0.75rem;">${hist.unitsDonated} Unit(s)</span></td>
                            <td><code style="font-size:0.75rem;">${hist.certificateNumber}</code></td>
                        </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                </c:when>
                <c:otherwise>
                <div class="text-center py-5">
                    <i class="fas fa-history fa-3x text-muted mb-3"></i>
                    <h6 class="text-muted">No donations recorded yet</h6>
                    <p class="text-muted small">Your donation history will appear here after your first donation.</p>
                </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<!-- Donor Assistance Modal -->
<div class="modal fade" id="assistanceModal" tabindex="-1" aria-labelledby="assistanceModalLabel" aria-hidden="true" data-bs-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content rounded-4 shadow-lg border-0">
      <div class="modal-header border-0 pb-0">
        <h5 class="modal-title fw-bold" id="assistanceModalLabel">Need Help Reaching the Hospital?</h5>
      </div>
      <div class="modal-body py-4">
        <div class="text-center mb-4">
            <div class="stat-icon mx-auto mb-3" style="width:60px; height:60px; background: #e0eaff; color: #007bff; display:flex; align-items:center; justify-content:center; border-radius:50%;">
                <i class="fas fa-truck-pickup fa-xl"></i>
            </div>
            <p class="mb-0 text-muted">The hospital (<span id="modalHospName" class="text-dark fw-bold">--</span>) is more than <span id="distVal" class="fw-bold text-danger">--</span> km from your location.</p>
            <p class="text-muted small px-3">Would you like assistance from a volunteer to help you reach the hospital efficiently?</p>
        </div>
      </div>
      <div class="modal-footer border-0 pt-0 flex-column gap-2">
        <button type="button" class="btn btn-primary w-100 py-3 fw-bold rounded-3 shadow-sm d-flex align-items-center justify-content-center" id="confirmHelpBtn">
            <i class="fas fa-hands-helping me-2"></i>Request Volunteer Help
        </button>
        <button type="button" class="btn btn-light w-100 py-2 rounded-3" id="ignoreHelpBtn">No Thanks, I Can Manage</button>
      </div>
    </div>
  </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Handle active requests
        const requestContainers = document.querySelectorAll('.request-tracking-container');
        requestContainers.forEach(container => {
            const reqId = container.dataset.requestId;
            const initialLat = parseFloat(container.dataset.lat) || 20.5937;
            const initialLon = parseFloat(container.dataset.lon) || 78.9629;
            const csrfP = container.dataset.csrfP;
            const csrfT = container.dataset.csrfT;
            const updateUrl = container.dataset.updateUrl;

            var map = L.map('trackingMap_' + reqId).setView([initialLat, initialLon], 13);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
            
            var donorMarker = L.marker([initialLat, initialLon], {
                icon: L.divIcon({
                    className: 'donor-div-icon',
                    html: '<div style="background:#2dc653;width:15px;height:15px;border-radius:50%;border:2px solid white;box-shadow:0 0 10px rgba(0,0,0,0.3);"></div>'
                })
            }).addTo(map);

            // Start tracking
            if (navigator.geolocation) {
                navigator.geolocation.watchPosition(function(position) {
                    var lat = position.coords.latitude;
                    var lon = position.coords.longitude;
                    
                    donorMarker.setLatLng([lat, lon]);
                    map.panTo([lat, lon]);
                    
                    // Send to server
                    var formData = new URLSearchParams();
                    formData.append('requestId', reqId);
                    formData.append('lat', lat);
                    formData.append('lon', lon);
                    formData.append(csrfP, csrfT);

                    fetch(updateUrl, {
                        method: 'POST',
                        body: formData
                    });
                    
                    const gpsIcon = document.getElementById('gpsStatus');
                    if(gpsIcon) gpsIcon.innerHTML = '<i class="fas fa-satellite-dish me-1 text-success"></i> Tracking Active';
                }, function(err) {
                    console.error("Tracking error:", err);
                    const gpsIcon = document.getElementById('gpsStatus');
                    if(gpsIcon) gpsIcon.innerText = "GPS Error";
                }, {
                    enableHighAccuracy: true
                });
            }
        });
        
        let pendingAcceptanceId = null;
        let pendingUserLat = null;
        let pendingUserLon = null;
        const assistanceModal = new bootstrap.Modal(document.getElementById('assistanceModal'));

        window.handleAcceptClick = function(btn) {
            const requestId = btn.dataset.reqId;
            const hospLat = parseFloat(btn.dataset.lat);
            const hospLon = parseFloat(btn.dataset.lon);
            const hospName = btn.dataset.hosp;
            checkTravelDistance(requestId, hospLat, hospLon, hospName);
        };

        window.checkTravelDistance = function(requestId, hospLat, hospLon, hospName) {
            const profileCoords = document.getElementById('userProfileCoords');
            const profileLat = parseFloat(profileCoords.dataset.lat);
            const profileLon = parseFloat(profileCoords.dataset.lon);

            const performDistanceCheck = (userLat, userLon) => {
                const dist = calculateHaversine(userLat, userLon, hospLat, hospLon);
                console.log("Calculated distance: " + dist + " km");

                if (dist > 3.0) {
                    pendingAcceptanceId = requestId;
                    pendingUserLat = userLat;
                    pendingUserLon = userLon;
                    document.getElementById('distVal').innerText = dist.toFixed(1);
                    document.getElementById('modalHospName').innerText = hospName;
                    assistanceModal.show();
                } else {
                    document.getElementById('acceptForm_' + requestId).submit();
                }
            };

            if (!navigator.geolocation) {
                console.warn("Geolocation not supported, using profile coordinates.");
                performDistanceCheck(profileLat, profileLon);
                return;
            }

            navigator.geolocation.getCurrentPosition(function(pos) {
                performDistanceCheck(pos.coords.latitude, pos.coords.longitude);
            }, function(err) {
                console.warn("GPS error (" + err.code + "), using profile coordinates fallback.");
                performDistanceCheck(profileLat, profileLon);
            }, {
                timeout: 3000,
                maximumAge: 60000
            });
        };

        function calculateHaversine(lat1, lon1, lat2, lon2) {
            const R = 6371;
            const dLat = (lat2 - lat1) * Math.PI / 180;
            const dLon = (lon2 - lon1) * Math.PI / 180;
            const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                      Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
                      Math.sin(dLon / 2) * Math.sin(dLon / 2);
            const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
            return R * c;
        }

        document.getElementById('confirmHelpBtn').addEventListener('click', function() {
            // First submit acceptance
            const form = document.getElementById('acceptForm_' + pendingAcceptanceId);
            
            // We need to also request assistance. 
            // To do this simply without complex AJAX sequencing, we can submit a different form or add a field.
            // But let's use a dynamic form submission for assistance.
            const assistanceForm = document.createElement('form');
            assistanceForm.method = 'POST';
            assistanceForm.action = '${pageContext.request.contextPath}/donor/request-assistance';
            
            const fields = {
                'requestId': pendingAcceptanceId,
                'lat': pendingUserLat,
                'lon': pendingUserLon,
                '${_csrf.parameterName}': '${_csrf.token}'
            };

            for (const key in fields) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = key;
                input.value = fields[key];
                assistanceForm.appendChild(input);
            }

            // We need to accept the request first. 
            // In a real app, you'd use fetch(). For simplicity here, we'll AJAX the acceptance and then submit the assistance form.
            // Disable button to prevent double clicks
            const btn = document.getElementById('confirmHelpBtn');
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Processing...';

            fetch(form.action, {
                method: 'POST',
                body: new FormData(form)
            }).then(response => {
                if (response.ok) {
                    document.body.appendChild(assistanceForm);
                    assistanceForm.submit();
                } else {
                    alert('Acceptance failed. Please try again.');
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fas fa-hands-helping me-2"></i>Request Volunteer Help';
                }
            }).catch(err => {
                console.error('Network error during acceptance:', err);
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-hands-helping me-2"></i>Request Volunteer Help';
            });
        });

        document.getElementById('ignoreHelpBtn').addEventListener('click', function() {
            document.getElementById('acceptForm_' + pendingAcceptanceId).submit();
        });

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

        // Auto-dismiss alerts
        const alerts = document.querySelectorAll('.alert-auto-dismiss');
        alerts.forEach(alert => {
            setTimeout(() => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }, 5000);
        });
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
