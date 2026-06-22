<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard - Blood Donor Emergency Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .notif-icon-circle { width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.9rem; flex-shrink: 0; }
        .notification-item { transition: background 0.2s; cursor: pointer; border-left: 3px solid transparent; }
        .notification-item:hover { background: #f8f9fa !important; border-left-color: var(--primary); }
    </style>
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
        
        <div class="sidebar-role mb-4">CARE RECEIVER</div>
        
        <div class="text-center mb-5">
            <a href="${pageContext.request.contextPath}/profile" class="text-decoration-none">
                <div class="avatar-dashboard mx-auto shadow-sm position-relative overflow-hidden">
                    <c:choose>
                        <c:when test="${not empty user.profileImage}">
                            <img src="${pageContext.request.contextPath}/uploads/profiles/${user.profileImage}" alt="${user.name}" style="width:100%; height:100%; object-fit:cover;">
                        </c:when>
                        <c:otherwise>
                            <span class="text-white fw-800" style="font-size:2rem;">
                                <c:choose>
                                    <c:when test="${not empty user.name}">${user.name.charAt(0)}</c:when>
                                    <c:otherwise>P</c:otherwise>
                                </c:choose>
                            </span>
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
                <a class="nav-link active" href="${pageContext.request.contextPath}/patient/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/patient/request-blood">
                    <i class="fas fa-heartbeat"></i> Request Blood
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
        <div class="dashboard-header d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
            <div>
                <h1 class="dashboard-title mb-1">
                    <span class="text-primary"><i class="fas fa-procedures me-2"></i></span>Patient Overview
                </h1>
                <p class="text-muted small mb-0">Monitor your recovery and blood requests.</p>
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
                                                <div class="notif-icon-circle ${n.notificationType == 'DONOR_ACCEPTED' ? 'bg-success-subtle text-success' : 'bg-primary-subtle text-primary'}">
                                                    <i class="fas ${n.notificationType == 'DONOR_ACCEPTED' ? 'fa-user-check' : 'fa-info-circle'}"></i>
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

                <a href="${pageContext.request.contextPath}/patient/request-blood"
                   class="btn-primary-custom shadow-sm">
                    <i class="fas fa-plus me-2"></i>New Blood Request
                </a>
            </div>
        </div>

        <!-- Flash Messages -->
        <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-auto-dismiss d-flex align-items-center gap-2 mb-4 shadow-sm border-0">
            <i class="fas fa-check-circle"></i>${successMessage}
        </div>
        </c:if>

        <div class="dashboard-content-body">
            <!-- Stats -->
            <div class="row g-4 mb-4">
                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card">
                        <div class="stat-icon stat-icon-red">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                        <div class="stat-number">${myRequests.size()}</div>
                        <div class="stat-label">Total Requests</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card">
                        <div class="stat-icon stat-icon-orange">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-number">${pendingCount}</div>
                        <div class="stat-label">Pending Requests</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card">
                        <div class="stat-icon stat-icon-green">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="stat-number">${fulfilledCount}</div>
                        <div class="stat-label">Fulfilled Requests</div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <div class="card-modern h-100 text-center p-5">
                        <div class="icon-circle mx-auto mb-4" style="background:rgba(230,57,70,0.1); width: 80px; height: 80px; display: flex; align-items: center; justify-content: center; border-radius: 50%;">
                            <i class="fas fa-heartbeat fa-2x" style="color:#e63946;"></i>
                        </div>
                        <div class="card-title-modern justify-content-center">
                            Emergency Blood Request
                        </div>
                        <p class="text-muted mb-4 small">Submit an urgent request for blood. Our high-priority system will alert compatible donors in your area immediately.</p>
                        <a href="${pageContext.request.contextPath}/patient/request-blood"
                           class="btn-primary-custom w-100 justify-content-center py-3">
                            <i class="fas fa-plus me-2"></i>Request Blood Now
                        </a>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card-modern h-100 text-center p-5">
                        <div class="icon-circle mx-auto mb-4" style="background:rgba(29,53,87,0.1); width: 80px; height: 80px; display: flex; align-items: center; justify-content: center; border-radius: 50%;">
                            <i class="fas fa-search fa-2x" style="color:#1d3557;"></i>
                        </div>
                        <div class="card-title-modern justify-content-center">
                            Search Available Donors
                        </div>
                        <p class="text-muted mb-4 small">Find available blood donors by group and city. Our algorithm prioritizes active and nearby donors for faster response.</p>
                        <a href="${pageContext.request.contextPath}/search-donor"
                           class="btn-secondary-custom w-100 justify-content-center py-3">
                            <i class="fas fa-search me-2"></i>Search Donors
                        </a>
                    </div>
                </div>
            </div>

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

            <!-- My Blood Requests -->
            <div class="card-modern">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="card-title-modern mb-0">
                        <i class="fas fa-list-ul text-primary"></i>My Blood Requests
                    </div>
                </div>
                
                <c:choose>
                    <c:when test="${not empty myRequests}">
                    <div class="table-responsive">
                        <table class="table-modern">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Blood Group</th>
                                <th>Hospital</th>
                                <th>City</th>
                                <th>Urgency</th>
                                <th>Status</th>
                                <th>Date Submitted</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="req" items="${myRequests}" varStatus="status">
                            <tr>
                                <td><span class="text-muted fw-600">${status.count}</span></td>
                                <td><span class="blood-group-badge">${req.bloodGroup}</span></td>
                                <td><i class="fas fa-hospital me-1 text-muted small"></i>${req.hospitalName}</td>
                                <td><i class="fas fa-map-marker-alt me-1 text-muted small"></i>${req.city}</td>
                                <td>
                                    <span class="urgency-${req.urgencyLevel.toString().toLowerCase()}">
                                        <i class="fas fa-circle me-2" style="font-size:8px;"></i>${req.urgencyLevel}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${req.status == 'PENDING'}">
                                            <span class="status-badge status-pending">Pending</span>
                                        </c:when>
                                        <c:when test="${req.status == 'ACCEPTED' || req.status == 'ON_THE_WAY' || req.status == 'REACHED_HOSPITAL'}">
                                            <div class="d-flex flex-column gap-1">
                                                <span class="status-badge status-available">
                                                    <i class="fas fa-motorcycle me-1"></i>En Route
                                                </span>
                                                <a href="${pageContext.request.contextPath}/patient/track-donor/${req.id}" 
                                                   class="btn btn-sm btn-outline-danger py-0 px-2" style="font-size:0.75rem;">
                                                    <i class="fas fa-map-location-dot me-1"></i>Track Hero
                                                </a>
                                                <c:choose>
                                                    <c:when test="${hospitalRegisteredMap[req.id] == false}">
                                                        <button type="button" class="btn btn-sm btn-success py-0 px-2 mt-1" style="font-size:0.75rem;" 
                                                                onclick="openVerifyModal(${req.id}, '${req.bloodGroup}')">
                                                            <i class="fas fa-handshake me-1"></i>Verify Fulfillment
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted mt-1" style="font-size:0.7rem;"><i class="fas fa-info-circle me-1"></i> Hospital will verify</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </c:when>
                                        <c:when test="${req.status == 'FULFILLED'}">
                                            <span class="status-badge status-fulfilled">Fulfilled <i class="fas fa-check ms-1"></i></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge bg-light text-muted">Cancelled</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="font-size:0.85rem;color:#6c757d;">${req.createdAt}</td>
                            </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    </c:when>
                    <c:otherwise>
                    <div class="text-center py-5">
                        <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-4" style="width: 100px; height: 100px;">
                            <i class="fas fa-clipboard fa-3x text-muted"></i>
                        </div>
                        <h5 class="text-muted fw-bold">No blood requests yet</h5>
                        <p class="text-muted small mb-4">Your emergency blood request history will be displayed here.</p>
                        <a href="${pageContext.request.contextPath}/patient/request-blood"
                           class="btn-primary-custom py-2 px-4">
                            <i class="fas fa-plus me-2"></i>Create First Request
                        </a>
                    </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

<!-- Verify Fulfillment Modal -->
<div class="modal fade" id="verifyHandshakeModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-5 border-0 shadow-lg">
            <div class="modal-header border-0 pb-0 pt-4 px-4">
                <h5 class="fw-900" style="color:#1d3557;"><i class="fas fa-handshake text-success me-2"></i>Mutual Handshake Verification</h5>
            </div>
            <div class="modal-body p-4">
                <p class="text-muted small mb-4">You are about to mark a donation for <span id="vBloodGroup" class="fw-bold text-danger"></span> as fulfilled. Please obtain the <b>6-digit Handshake Code</b> from the donor sitting next to you to verify.</p>
                <form id="verifyForm" action="${pageContext.request.contextPath}/patient/fulfill-request" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="requestId" id="vRequestId">
                    <div class="mb-4">
                        <label class="form-label small fw-bold text-uppercase">HANDSHAKE CODE</label>
                        <input type="text" name="code" class="form-control form-control-lg text-center fw-bold" 
                               placeholder="X X X X X X" 
                               style="letter-spacing: 12px; font-size: 2rem; border-radius: 15px; border: 2px solid #eee;" 
                               maxlength="6" required>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-0 p-4 pt-0 gap-2">
                <button type="submit" form="verifyForm" class="btn btn-success w-100 py-3 fw-bold rounded-4 shadow-sm">
                    Confirm & Verify Donation
                </button>
                <button type="button" class="btn btn-light w-100 py-2 rounded-4" data-bs-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>

<script>
    let verifyModal;
    document.addEventListener('DOMContentLoaded', function() {
        const verifyModalElement = document.getElementById('verifyHandshakeModal');
        if (verifyModalElement) {
            verifyModal = new bootstrap.Modal(verifyModalElement);
        }
    });

    window.openVerifyModal = function(requestId, bloodGroup) {
        document.getElementById('vRequestId').value = requestId;
        document.getElementById('vBloodGroup').innerText = bloodGroup;
        if (verifyModal) {
            verifyModal.show();
        } else {
            // Lazy fallback if needed
            const verifyModalElement = document.getElementById('verifyHandshakeModal');
            if (verifyModalElement) {
                verifyModal = new bootstrap.Modal(verifyModalElement);
                verifyModal.show();
            }
        }
    };

    // Mark All Read API
    window.markAllRead = function() {
        if (typeof fetch !== 'function') return;
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
