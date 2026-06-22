<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donation History - Blood Donor Emergency Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
        
        <div class="sidebar-role">Life Saver</div>
        
        <div class="text-center mb-5">
            <a href="${pageContext.request.contextPath}/profile" class="text-decoration-none">
                <div class="avatar-dashboard mx-auto shadow-sm position-relative overflow-hidden" style="background:var(--primary);">
                    <c:choose>
                        <c:when test="${not empty user.profileImage}">
                            <img src="${pageContext.request.contextPath}/uploads/profiles/${user.profileImage}" alt="${user.name}" style="width:100%; height:100%; object-fit:cover;">
                        </c:when>
                        <c:otherwise>
                            <span class="text-white fw-800" style="font-size:2rem;">
                                <c:choose>
                                    <c:when test="${not empty user.name}">${user.name.charAt(0)}</c:when>
                                    <c:otherwise>D</c:otherwise>
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
                <a class="nav-link" href="${pageContext.request.contextPath}/donor/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="${pageContext.request.contextPath}/donor/donation-history">
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

    <main class="dashboard-content">
        <div class="dashboard-header">
            <h1 class="dashboard-title">
                <i class="fas fa-history me-2" style="color:#e63946;"></i>Donation History
            </h1>
            <div class="ms-auto d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/donor/dashboard"
                   class="btn-outline-custom" style="padding:0.5rem 1rem;font-size:0.85rem;">
                    <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
                </a>
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
                                                <div class="notif-icon-circle bg-primary-subtle text-primary" style="width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.9rem; flex-shrink: 0;">
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
            </div>
        </div>

        <!-- Stats -->
        <div class="row g-4 mb-4">
            <div class="col-sm-4">
                <div class="stat-card">
                    <div class="stat-icon stat-icon-red">
                        <i class="fas fa-tint"></i>
                    </div>
                    <div class="stat-number counter-animate" data-target="${donor.totalDonations}">${donor.totalDonations}</div>
                    <div class="stat-label">Total Donations</div>
                </div>
            </div>
            <div class="col-sm-4">
                <div class="stat-card">
                    <div class="stat-icon stat-icon-green">
                        <i class="fas fa-heart" style="color:#2dc653;font-size:1.5rem;"></i>
                    </div>
                    <div class="stat-number counter-animate" data-target="${donor.totalDonations * 3}">${donor.totalDonations * 3}</div>
                    <div class="stat-label">Potential Lives Affected</div>
                </div>
            </div>
            <div class="col-sm-4">
                <div class="stat-card">
                    <div class="stat-icon stat-icon-blue">
                        <i class="fas fa-award" style="color:#1d3557;font-size:1.5rem;"></i>
                    </div>
                    <div class="stat-number">
                        <c:choose>
                            <c:when test="${donor.badge != null}">${donor.badge.toString().replace('_',' ')}</c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-label">My Badge</div>
                </div>
            </div>
        </div>

        <!-- Timeline / History Table -->
        <div class="card-modern">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="mb-0" style="color:#1d3557;">
                    <i class="fas fa-list-alt me-2" style="color:#e63946;"></i>All Donations
                </h5>
                <c:if test="${not empty donor.totalDonations and donor.totalDonations > donations.size()}">
                    <span class="badge bg-light text-muted fw-normal" style="font-size: 0.75rem; border: 1px dashed #ccc;">
                        * Includes ${donor.totalDonations - donations.size()} unverified/external donations
                    </span>
                </c:if>
            </div>

            <c:choose>
                <c:when test="${not empty donations}">
                <div class="table-responsive">
                    <table class="table-modern">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Date</th>
                            <th>Hospital</th>
                            <th>Patient</th>
                            <th>Blood Group</th>
                            <th>Units</th>
                            <th>Certificate</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="d" items="${donations}" varStatus="status">
                        <tr>
                            <td>
                                <div style="width:30px;height:30px;border-radius:50%;background:linear-gradient(135deg,#e63946,#c1121f);
                                     display:flex;align-items:center;justify-content:center;color:white;font-weight:700;font-size:0.8rem;">
                                    ${status.count}
                                </div>
                            </td>
                            <td>
                                <strong style="color:#1d3557;">${d.donationDate}</strong>
                            </td>
                            <td>
                                <i class="fas fa-hospital me-1 text-muted"></i>${d.hospitalName}
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty d.patientName}">${d.patientName}</c:when>
                                    <c:otherwise><span class="text-muted">Anonymous</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty d.bloodGroup}">
                                        <span class="blood-group-badge">${d.bloodGroup}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="blood-group-badge">${donor.bloodGroup}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><span style="font-weight:600;color:#1d3557;">${d.unitsDonated} Unit(s)</span></td>
                            <td>
                                <code style="background:#f8f9fa;padding:0.2rem 0.5rem;border-radius:6px;font-size:0.78rem;">
                                    ${d.certificateNumber}
                                </code>
                            </td>
                        </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                </c:when>
                <c:otherwise>
                <div class="text-center py-5">
                    <c:choose>
                        <c:when test="${not empty donor.totalDonations and donor.totalDonations > 0}">
                             <div class="mb-4">
                                <div class="tech-blob-small mx-auto mb-3" style="width:100px; height:100px; background: radial-gradient(circle, rgba(230, 57, 70, 0.1) 0%, transparent 70%); align-items:center; display:flex; justify-content:center;">
                                    <i class="fas fa-check-circle fa-3x text-success"></i>
                                </div>
                                <h4 class="fw-bold" style="color:#1d3557;">Historical Data Verified</h4>
                                <p class="text-muted mx-auto" style="max-width:500px;">
                                    While you have <strong>${donor.totalDonations}</strong> successful donations recorded in your profile, 
                                    those were performed before joining our digital platform or at external centers.
                                </p>
                             </div>
                             <div class="p-4 rounded-4 border border-dashed bg-light mx-auto" style="max-width:600px;">
                                 <h6 class="text-muted text-uppercase small fw-bold mb-3" style="letter-spacing:1px;">Legacy Summary</h6>
                                 <div class="row">
                                     <div class="col-6 border-end">
                                         <div class="h4 mb-0 fw-bold text-danger">${donor.totalDonations}</div>
                                         <div class="small text-muted">Sessions</div>
                                     </div>
                                     <div class="col-6">
                                         <div class="h4 mb-0 fw-bold text-success">${donor.totalDonations * 3}</div>
                                         <div class="small text-muted">Lives Saved</div>
                                     </div>
                                 </div>
                             </div>
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-history fa-4x text-muted mb-3"></i>
                            <h5 class="text-muted">No Donation History Found</h5>
                            <p class="text-muted">Your blood donation records will appear here after each donation.</p>
                            <div class="mt-3 p-3" style="background:rgba(230,57,70,0.05);border-radius:12px;max-width:400px;margin:0 auto;">
                                <p class="text-muted small mb-0">
                                    <i class="fas fa-info-circle me-1 text-danger"></i>
                                    Every 1 unit of blood can save up to 3 lives. 
                                    Start your journey as a blood hero today!
                                </p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                </c:otherwise>
            </c:choose>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
