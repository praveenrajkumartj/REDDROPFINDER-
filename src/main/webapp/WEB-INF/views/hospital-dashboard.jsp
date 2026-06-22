<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hospital Dashboard - Blood Donor Emergency Finder</title>
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
        
        <div class="sidebar-role mb-4">HOSPITAL PANEL</div>
        
        <div class="text-center mb-5">
            <a href="${pageContext.request.contextPath}/profile" class="text-decoration-none">
                <div class="avatar-dashboard mx-auto shadow-sm position-relative overflow-hidden" style="background: linear-gradient(135deg, #457b9d, #1d3557);">
                    <c:choose>
                        <c:when test="${not empty user.profileImage}">
                            <img src="${pageContext.request.contextPath}/uploads/profiles/${user.profileImage}" alt="${user.name}" style="width:100%; height:100%; object-fit:cover;">
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-hospital text-white"></i>
                        </c:otherwise>
                    </c:choose>
                    <div class="avatar-hover-overlay">
                        <i class="fas fa-edit text-white" style="font-size: 1rem;"></i>
                    </div>
                </div>
            </a>
            <div class="text-white mt-3 fw-bold" style="font-size:1.15rem; letter-spacing: 0.3px;">
                ${not empty user.hospitalName ? user.hospitalName : user.name}
            </div>
            <div class="d-flex align-items-center justify-content-center mt-1" style="color:rgba(255,255,255,0.45); font-size:0.85rem; font-weight: 500;">
                <i class="fas fa-location-dot me-2" style="font-size: 0.75rem;"></i>${user.city}
            </div>
        </div>

        <ul class="sidebar-nav sidebar-nav-main">
            <li class="nav-item">
                <a class="nav-link active" href="${pageContext.request.contextPath}/hospital/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/hospital/add-camp">
                    <i class="fas fa-plus-circle"></i> Create Camp
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/search-donor">
                    <i class="fas fa-search"></i> Find Donors
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/blood-camps">
                    <i class="fas fa-calendar-alt"></i> Blood Camps
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
                    <span class="text-primary"><i class="fas fa-hospital me-2"></i></span>Hospital Panel
                </h1>
                <p class="text-muted small mb-0">System-wide monitoring of blood procurement. <span class="d-none" id="debug-check">${hotReloadTest}</span></p>
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
                        <div class="p-2 text-center bg-light border-top">
                            <a href="${pageContext.request.contextPath}/notifications" class="text-decoration-none small text-primary fw-bold">See all notifications</a>
                        </div>
                    </div>
                </div>

                <a href="${pageContext.request.contextPath}/hospital/add-camp"
                   class="btn-primary-custom shadow-sm mt-3 mt-md-0">
                    <i class="fas fa-plus me-2"></i>Create Blood Camp
                </a>
            </div>
        </div>

        <div class="dashboard-content-body">
            <!-- Flash Messages -->
            <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-auto-dismiss d-flex align-items-center gap-2 mb-4 shadow-sm border-0">
                <i class="fas fa-check-circle"></i>${successMessage}
            </div>
            </c:if>

            <!-- Quick Stats -->
            <div class="row g-4 mb-4">
                <div class="col-sm-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: rgba(69, 123, 157, 0.1);">
                            <i class="fas fa-calendar-alt" style="color:#457b9d;"></i>
                        </div>
                        <div class="stat-number">${myCamps.size()}</div>
                        <div class="stat-label">My Camps</div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="stat-card">
                        <div class="stat-icon stat-icon-orange">
                            <i class="fas fa-heartbeat"></i>
                        </div>
                        <div class="stat-number">${pendingRequests.size()}</div>
                        <div class="stat-label">Open Requests</div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="stat-card">
                        <div class="stat-icon stat-icon-green">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-number">${totalDonors}</div>
                        <div class="stat-label">Available Donors</div>
                    </div>
                </div>
            </div>

            <!-- My Blood Camps -->
            <div class="card-modern mb-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="card-title-modern mb-0">
                        <i class="fas fa-calendar-check text-primary"></i>My Blood Camps
                    </div>
                    <a href="${pageContext.request.contextPath}/hospital/add-camp"
                       class="btn-outline-custom py-2 px-3 small">
                        <i class="fas fa-plus me-1"></i>Add New Camp
                    </a>
                </div>

                <c:choose>
                    <c:when test="${not empty myCamps}">
                    <div class="table-responsive">
                        <table class="table-modern">
                            <thead>
                            <tr>
                                <th>Camp Name</th>
                                <th>Date</th>
                                <th>Location</th>
                                <th>Status</th>
                                <th>Registrations</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="camp" items="${myCamps}">
                            <tr>
                                <td><strong>${camp.campName}</strong></td>
                                <td><i class="fas fa-calendar-day me-1 text-muted small"></i>${camp.date}</td>
                                <td><i class="fas fa-map-marker-alt me-1 text-muted small"></i>${camp.location}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${camp.status == 'UPCOMING'}">
                                            <span class="status-badge status-available">Upcoming</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge bg-light text-muted">${camp.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="fw-bold text-dark">${camp.registeredCount}</span>
                                        <span class="text-muted small">/ ${camp.maxParticipants}</span>
                                        <c:if test="${camp.registeredCount > 0}">
                                            <button class="btn btn-sm btn-link p-0 text-primary ms-1 view-participants-btn" 
                                                    data-id="${camp.id}"
                                                    data-name="${fn:escapeXml(camp.campName)}"
                                                    title="View Registered Donors">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                        </c:if>
                                    </div>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <form action="${pageContext.request.contextPath}/hospital/delete-camp/${camp.id}"
                                              method="post" class="d-inline">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <button type="submit" class="btn btn-sm btn-link text-danger p-0 border-0"
                                                    onclick="return confirm('Are you sure you want to delete this camp?')" title="Delete">
                                                <i class="fas fa-trash-alt"></i>
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
                    <div class="text-center py-5">
                        <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-4" style="width: 100px; height: 100px;">
                            <i class="fas fa-calendar-times fa-3x text-muted"></i>
                        </div>
                        <h6 class="text-muted fw-bold">No blood camps created yet</h6>
                        <a href="${pageContext.request.contextPath}/hospital/add-camp"
                           class="btn-primary-custom mt-3">
                            <i class="fas fa-plus me-2"></i>Create First Camp
                        </a>
                    </div>
                    </c:otherwise>
                </c:choose>
            <!-- Incoming Donors for this Hospital -->
            <div class="card-modern mb-4 shadow-sm border-0" style="border-top: 4px solid #457b9d !important;">
                <div class="card-title-modern">
                    <i class="fas fa-truck-medical text-primary"></i>Incoming Donors
                </div>
                <c:choose>
                    <c:when test="${not empty incomingRequests}">
                    <div class="table-responsive">
                        <table class="table-modern">
                            <thead>
                            <tr>
                                <th>Donor (Accepted By)</th>
                                <th>Blood Group</th>
                                <th>Current Status</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="req" items="${incomingRequests}">
                            <tr>
                                <td>
                                    <strong>${not empty req.acceptedBy ? req.acceptedBy.name : 'Unknown'}</strong>
                                    <div class="small text-muted">${not empty req.acceptedBy ? req.acceptedBy.phone : ''}</div>
                                </td>
                                <td><span class="blood-group-badge">${req.bloodGroup}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${req.status == 'REACHED_HOSPITAL'}">
                                            <span class="badge bg-success shadow-sm"><i class="fas fa-check-double me-1"></i>On-Site</span>
                                        </c:when>
                                        <c:when test="${req.status == 'ON_THE_WAY'}">
                                            <span class="badge bg-info text-white shadow-sm"><i class="fas fa-motorcycle me-1"></i>En-Route</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary shadow-sm">${req.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${req.status == 'REACHED_HOSPITAL'}">
                                        <form action="${pageContext.request.contextPath}/hospital/update-request-status" method="post">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <input type="hidden" name="requestId" value="${req.id}"/>
                                            <input type="hidden" name="status" value="FULFILLED"/>
                                            <button type="submit" class="btn btn-sm btn-success px-3 rounded-pill fw-bold">
                                                Mark Fulfilled <i class="fas fa-check ms-1"></i>
                                            </button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    </c:when>
                    <c:otherwise>
                    <div class="text-center py-4 bg-light bg-opacity-50 rounded-4">
                        <p class="text-muted mb-0 small">No donors currently en-route to your hospital.</p>
                    </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pending Blood Requests in the Area -->
            <div class="card-modern">
                <div class="card-title-modern">
                    <i class="fas fa-exclamation-circle text-warning"></i>Open Blood Requests
                </div>
                <c:choose>
                    <c:when test="${not empty pendingRequests}">
                    <div class="table-responsive">
                        <table class="table-modern">
                            <thead>
                            <tr>
                                <th>Patient Name</th>
                                <th>Blood Group</th>
                                <th>Hospital</th>
                                <th>City</th>
                                <th>Urgency</th>
                                <th>Posted At</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="req" items="${pendingRequests}">
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
                                <td class="text-muted small">${req.createdAt}</td>
                            </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    </c:when>
                    <c:otherwise>
                    <div class="text-center py-5" style="background: rgba(45, 198, 83, 0.05); border-radius: 12px; border: 1px dashed rgba(45, 198, 83, 0.3);">
                        <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                        <h6 class="text-muted m-0">No active emergency blood requests in your area.</h6>
                    </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

<!-- Participants Modal -->
<div class="modal fade" id="participantsModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header bg-light border-0 py-3">
                <h5 class="modal-title fw-bold text-dark" id="modalCampName">Camp Participants</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="bg-light-subtle">
                            <tr>
                                <th class="ps-4">Donor Name</th>
                                <th>Blood Group</th>
                                <th>Contact</th>
                                <th class="pe-4 text-end">City</th>
                            </tr>
                        </thead>
                        <tbody id="participantsList">
                            <!-- Populated by JS -->
                        </tbody>
                    </table>
                </div>
                <div id="noParticipantsMsg" class="text-center py-5 d-none">
                    <i class="fas fa-users-slash fa-3x text-muted mb-3"></i>
                    <p class="text-muted">No donors registered for this camp yet.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Participants logic
    document.querySelectorAll('.view-participants-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const campId = this.getAttribute('data-id');
            const campName = this.getAttribute('data-name');
            
            document.getElementById('modalCampName').textContent = campName + " - Registrants";
            const list = document.getElementById('participantsList');
            const emptyMsg = document.getElementById('noParticipantsMsg');
            
            list.innerHTML = '<tr><td colspan="4" class="text-center py-4"><div class="spinner-border spinner-border-sm text-primary"></div> Loading...</td></tr>';
            emptyMsg.classList.add('d-none');
            
            const modalEl = document.getElementById('participantsModal');
            let myModal = bootstrap.Modal.getInstance(modalEl);
            if (!myModal) myModal = new bootstrap.Modal(modalEl);
            myModal.show();

            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), 10000); // 10s timeout

            fetch(`${pageContext.request.contextPath}/hospital/camp-participants/\${campId}`, { signal: controller.signal })
                .then(async res => {
                    clearTimeout(timeoutId);
                    const contentType = res.headers.get("content-type");
                    if (!res.ok) {
                        const text = await res.text();
                        console.error('SERVER_ERROR_BODY:', text);
                        throw new Error(`STATUS_${res.status}: ${text.substring(0, 50)}...`);
                    }
                    if (!contentType || !contentType.includes("application/json")) {
                        const text = await res.text();
                        console.error('SERVER_CONTENT_TYPE_MISMATCH:', contentType, text);
                        throw new Error(`FORMAT_ERR: ${contentType}`);
                    }
                    return res.json();
                })
                .then(data => {
                    // Check for backend error message in JSON
                    if (data && data.error) throw new Error(data.error);
                    
                    if (!Array.isArray(data)) throw new Error('DATA_NOT_ARRAY');
                    
                    if (data.length === 0) {
                        list.innerHTML = '';
                        emptyMsg.classList.remove('d-none');
                    } else {
                        list.innerHTML = data.map(u => `
                            <tr>
                                <td class="ps-4"><strong>\${u.name || 'Anonymous'}</strong><br><small class="text-muted">\${u.email || ''}</small></td>
                                <td><span class="badge bg-danger-subtle text-danger px-2">\${u.bloodGroup || 'N/A'}</span></td>
                                <td><i class="fas fa-phone small me-1"></i>\${u.phone || 'N/A'}</td>
                                <td class="pe-4 text-end">\${u.city || 'N/A'}</td>
                            </tr>
                        `).join('');
                    }
                })
                .catch(err => {
                    clearTimeout(timeoutId);
                    const debugVal = document.getElementById('debug-check')?.textContent || 'MISSING_DEBUG_ID';
                    console.error('FETCH_EXCEPTION:', err);
                    list.innerHTML = `<tr><td colspan="4" class="text-center text-danger py-5">
                        <i class="fas fa-exclamation-triangle mb-3 d-block fs-3"></i>
                        <div class="fw-bold mb-1">\${err.name === 'AbortError' ? 'REQUEST_TIMEOUT' : 'FETCH_ERROR'}</div>
                        <div class="small mb-3">\${err.message}</div>
                        <div class="p-2 bg-light rounded text-muted tiny" style="font-size: 0.65rem;">
                            SYNC_ID: \${debugVal}<br>
                            TIME: \${new Date().toLocaleTimeString()}
                        </div>
                    </td></tr>`;
                });
        });
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
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
