<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Blood Donor Emergency Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
        
        <div class="sidebar-role mb-4">ADMINISTRATOR</div>
        
        <div class="text-center mb-5">
            <a href="${pageContext.request.contextPath}/profile" class="text-decoration-none">
                <div class="avatar-dashboard mx-auto shadow-sm position-relative overflow-hidden" style="background: linear-gradient(135deg, #e63946, #c1121f);">
                    <c:choose>
                        <c:when test="${not empty user.profileImage}">
                            <img src="${pageContext.request.contextPath}/uploads/profiles/${user.profileImage}" alt="System Admin" style="width:100%; height:100%; object-fit:cover;">
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-shield-alt text-white"></i>
                        </c:otherwise>
                    </c:choose>
                    <div class="avatar-hover-overlay">
                        <i class="fas fa-edit text-white" style="font-size: 1rem;"></i>
                    </div>
                </div>
            </a>
            <div class="text-white mt-3 fw-bold" style="font-size:1.15rem; letter-spacing: 0.3px;">System Admin</div>
            <div class="d-flex align-items-center justify-content-center mt-1" style="color:rgba(255,255,255,0.45); font-size:0.85rem; font-weight: 500;">
                <i class="fas fa-tower-broadcast me-2" style="font-size: 0.75rem;"></i>Full Control
            </div>
        </div>

        <ul class="sidebar-nav sidebar-nav-main">
            <li class="nav-item">
                <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                    <i class="fas fa-users"></i> Manage Users
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/requests">
                    <i class="fas fa-clipboard-list"></i> Blood Requests
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
            <li class="nav-item mt-4">
                <a class="nav-link" href="${pageContext.request.contextPath}/">
                    <i class="fas fa-globe"></i> View Website
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
                    <span class="text-primary"><i class="fas fa-shield-alt me-2"></i></span>Admin Control
                </h1>
                <p class="text-muted small mb-0">Comprehensive system monitoring & management</p>
            </div>
            <div class="d-flex align-items-center gap-3">
                <!-- Location Sync Trigger -->
                <form id="syncForm" action="${pageContext.request.contextPath}/admin/sync-locations" method="post" class="m-0">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="button" class="btn btn-navy d-flex align-items-center gap-2 rounded-pill px-3 shadow-sm border-0" 
                            style="background: #1d3557; color: white; transition: all 0.3s ease;"
                            onclick="confirmSync()">
                        <i class="fas fa-location-crosshairs"></i>
                        <span class="d-none d-lg-inline">Fix Missing Locations</span>
                    </button>
                </form>

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
                                                <div class="notif-icon-circle bg-primary-subtle text-primary">
                                                    <i class="fas fa-info-circle"></i>
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
                    </div>
                </div>
            </div>
        </div>

        <div class="dashboard-content-body">
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-auto-dismiss mb-4 shadow-sm border-0" 
                     style="border-radius:15px; background: rgba(45,198,83,0.1); color:#2dc653;">
                    <i class="fas fa-check-circle me-2"></i>${successMessage}
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-auto-dismiss mb-4 shadow-sm border-0" 
                     style="border-radius:15px; background: rgba(230,57,70,0.1); color:#e63946;">
                    <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                </div>
            </c:if>

            <!-- Stats Grid -->
            <div class="row g-4 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card border-bottom border-primary border-4">
                        <div class="stat-icon" style="background:rgba(29,53,87,0.1);">
                            <i class="fas fa-users" style="color:#1d3557;"></i>
                        </div>
                        <div class="stat-number counter-animate" data-target="${totalUsers}">${totalUsers}</div>
                        <div class="stat-label">Total Users</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card border-bottom border-danger border-4">
                        <div class="stat-icon stat-icon-red">
                            <i class="fas fa-tint"></i>
                        </div>
                        <div class="stat-number counter-animate" data-target="${totalDonors}">${totalDonors}</div>
                        <div class="stat-label">Verified Donors</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card border-bottom border-warning border-4">
                        <div class="stat-icon stat-icon-orange">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                        <div class="stat-number counter-animate" data-target="${pendingRequests}">${pendingRequests}</div>
                        <div class="stat-label">Active Requests</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card border-bottom border-success border-4">
                        <div class="stat-icon stat-icon-green">
                            <i class="fas fa-heart"></i>
                        </div>
                        <div class="stat-number counter-animate" data-target="${livesSaved}">${livesSaved}</div>
                        <div class="stat-label">Impact Score</div>
                    </div>
                </div>
            </div>

            <!-- Role Distribution & Summary -->
            <div class="row g-4 mb-4">
                <div class="col-lg-5">
                    <div class="card-modern h-100">
                        <div class="card-title-modern">
                            <i class="fas fa-chart-pie text-primary"></i>User Distribution
                        </div>
                        <div class="chart-container py-3">
                            <canvas id="impactChart"
                                    data-donors="${donorCount}"
                                    data-requests="${patientCount}"
                                    data-donations="${totalDonations}"
                                    data-camps="${totalCamps}"
                                    style="max-height:250px;"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-lg-7">
                    <div class="card-modern h-100">
                        <div class="card-title-modern">
                            <i class="fas fa-server text-primary"></i>System Health Overview
                        </div>
                        <div class="row g-3">
                            <div class="col-6">
                                <div class="p-4 rounded-4 bg-light border-start border-4 border-danger">
                                    <div class="display-6 fw-bold text-danger mb-1">${donorCount}</div>
                                    <div class="text-muted small fw-600">Active Donors</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-4 rounded-4 bg-light border-start border-4 border-primary">
                                    <div class="display-6 fw-bold text-primary mb-1">${patientCount}</div>
                                    <div class="text-muted small fw-600">Care Receivers</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-4 rounded-4 bg-light border-start border-4 border-info">
                                    <div class="display-6 fw-bold text-info mb-1">${hospitalCount}</div>
                                    <div class="text-muted small fw-600">Medical Centers</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-4 rounded-4 bg-light border-start border-4 border-success">
                                    <div class="display-6 fw-bold text-success mb-1">${availableDonors}</div>
                                    <div class="text-muted small fw-600">Donors Online</div>
                                </div>
                            </div>
                            <div class="col-12 mt-3">
                                <div class="p-4 rounded-4 bg-light border-start border-4 border-warning">
                                    <div class="display-6 fw-bold text-warning mb-1">${volunteerCount}</div>
                                    <div class="text-muted small fw-600">Registered Volunteers</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pending Blood Requests -->
            <div class="card-modern mb-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="card-title-modern mb-0">
                        <i class="fas fa-exclamation-triangle text-warning"></i>Open Blood Requests
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/requests"
                       class="btn-outline-custom py-2 px-3 small">
                        Full List
                    </a>
                </div>
                <c:choose>
                    <c:when test="${not empty recentRequests}">
                    <div class="table-responsive">
                        <table class="table-modern">
                            <thead>
                            <tr>
                                <th>Patient</th>
                                <th>Group</th>
                                <th>Hospital</th>
                                <th>City</th>
                                <th>Urgency</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="req" items="${recentRequests}">
                            <tr>
                                <td><strong>${req.patientName}</strong></td>
                                <td><span class="blood-group-badge">${req.bloodGroup}</span></td>
                                <td><i class="fas fa-hospital me-1 text-muted small"></i>${req.hospitalName}</td>
                                <td><i class="fas fa-map-marker-alt me-1 text-muted small"></i>${req.city}</td>
                                <td>
                                    <span class="urgency-${req.urgencyLevel.toString().toLowerCase()}">
                                        <i class="fas fa-circle me-2" style="font-size:8px;"></i>${req.urgencyLevel}
                                    </span>
                                </td>
                                <td>
                                    <div class="d-flex gap-2">
                                        <form action="${pageContext.request.contextPath}/admin/update-request-status"
                                              method="post" class="m-0">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <input type="hidden" name="requestId" value="${req.id}"/>
                                            <input type="hidden" name="status" value="FULFILLED"/>
                                            <button type="submit" class="btn btn-sm btn-link text-success p-0" title="Mark Fulfilled">
                                                <i class="fas fa-check-circle fa-lg"></i>
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/delete-request/${req.id}"
                                              method="post" class="m-0">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <button type="submit" class="btn btn-sm btn-link text-danger p-0"
                                                    onclick='return confirm("Delete this request?")' title="Delete">
                                                <i class="fas fa-trash-alt fa-lg"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    </c:when>
                    <c:otherwise>
                    <div class="text-center py-5" style="border: 1px dashed #ddd; border-radius: 12px; background: #fafafa;">
                        <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                        <p class="text-muted m-0 fw-bold">No pending blood requests at the moment.</p>
                    </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- All Users Table -->
            <div class="card-modern">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="card-title-modern mb-0">
                        <i class="fas fa-user-gear text-primary"></i>User Management
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/users"
                       class="btn-outline-custom py-2 px-3 small">
                        System Users
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="table-modern">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Identity</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>City</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="u" items="${allUsers}" varStatus="status">
                        <tr>
                            <td><span class="text-muted small">${status.count}</span></td>
                            <td><strong>${u.name}</strong></td>
                            <td>${u.email}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.role == 'DONOR'}">
                                        <span class="badge bg-danger-subtle text-danger px-2 py-1 rounded-pill small">Donor</span>
                                    </c:when>
                                    <c:when test="${u.role == 'PATIENT'}">
                                        <span class="badge bg-primary-subtle text-primary px-2 py-1 rounded-pill small">Patient</span>
                                    </c:when>
                                    <c:when test="${u.role == 'HOSPITAL'}">
                                        <span class="badge bg-success-subtle text-success px-2 py-1 rounded-pill small">Hospital</span>
                                    </c:when>
                                    <c:when test="${u.role == 'VOLUNTEER'}">
                                        <span class="badge bg-info-subtle text-info px-2 py-1 rounded-pill small">Volunteer</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning-subtle text-warning px-2 py-1 rounded-pill small">Admin</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><i class="fas fa-map-marker-alt me-1 text-muted small"></i>${u.city}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.active}">
                                        <span class="status-badge status-available">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-unavailable">Disabled</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${u.role != 'ADMIN'}">
                                <form action="${pageContext.request.contextPath}/admin/toggle-user/${u.id}"
                                      method="post" class="m-0" id="toggleUserForm_${status.index}">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="button" class="btn btn-sm ${u.active ? 'btn-outline-danger' : 'btn-outline-success'} px-3 rounded-pill"
                                            onclick="confirmToggle(${status.index}, '${u.name.replaceAll("'", "\\'")}', ${u.active})">
                                        ${u.active ? 'Deactivate' : 'Activate'}
                                    </button>
                                </form>
                                </c:if>
                            </td>
                        </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    function confirmSync() {
        Swal.fire({
            title: 'Synchronize Locations?',
            text: "This will geocode all users missing coordinates based on their city. This process may take a few moments.",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#1d3557',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, start sync',
            background: '#ffffff',
            borderRadius: '20px',
            customClass: {
                title: 'fw-bold',
                confirmButton: 'rounded-pill px-4',
                cancelButton: 'rounded-pill px-4'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire({
                    title: 'Processing...',
                    text: 'Please wait while we sync geographical data.',
                    allowOutsideClick: false,
                    didOpen: () => { Swal.showLoading(); }
                });
                document.getElementById('syncForm').submit();
            }
        });
    }

    function confirmToggle(index, name, isActive) {
        const action = isActive ? 'Deactivate' : 'Activate';
        const color = isActive ? '#e63946' : '#2dc653';
        
        Swal.fire({
            title: action + ' User?',
            text: "Are you sure you want to " + action.toLowerCase() + " " + name + "?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: color,
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, ' + action,
            borderRadius: '20px'
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById('toggleUserForm_' + index).submit();
            }
        });
    }

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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
