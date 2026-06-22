<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Blood Camp - Blood Donor Emergency Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body style="background:var(--bg);">

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
        
        <div class="sidebar-role">Hospital Panel</div>
        
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
            <div class="text-white mt-3 fw-bold" style="font-size:1.15rem; letter-spacing: 0.3px;">${user.name}</div>
            <div class="d-flex align-items-center justify-content-center mt-1" style="color:rgba(255,255,255,0.45); font-size:0.85rem; font-weight: 500;">
                <i class="fas fa-location-dot me-2" style="font-size: 0.75rem;"></i>${user.city}
            </div>
        </div>

        <ul class="sidebar-nav sidebar-nav-main">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/hospital/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="${pageContext.request.contextPath}/hospital/add-camp">
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

    <main class="dashboard-content">
        <div class="dashboard-header d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="dashboard-title">
                    <i class="fas fa-calendar-plus me-2" style="color:#e63946;"></i>Create Blood Camp
                </h1>
                <p class="text-muted small">Organize a blood donation drive in your city.</p>
            </div>
            <div class="ms-auto d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/hospital/dashboard"
                   class="btn-outline-custom" style="padding:0.4rem 1.2rem;">
                    <i class="fas fa-arrow-left me-1"></i>Back
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

        <div class="dashboard-content-body">
            <div class="row justify-content-center">
                <div class="col-xl-9">
                    <div class="card-modern shadow-sm border-0">
                        <form action="${pageContext.request.contextPath}/hospital/add-camp" method="post" class="p-2">
                             <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                             
                             <div class="row g-4 mb-4">
                                <div class="col-12">
                                    <label class="form-label-modern">Camp Name *</label>
                                    <input type="text" name="campName" class="form-control-modern border-0 bg-light py-3 px-4 rounded-4"
                                           placeholder="e.g. Annual Blood Donation Drive 2025" required>
                                </div>
                             </div>

                             <div class="row g-4 mb-4">
                                <div class="col-md-6">
                                    <label class="form-label-modern">Organizer *</label>
                                    <input type="text" name="organizer" class="form-control-modern border-0 bg-light py-3 px-4 rounded-4"
                                           placeholder="Hospital/Organization name" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label-modern">Date *</label>
                                    <input type="date" name="date" class="form-control-modern border-0 bg-light py-3 px-4 rounded-4" required>
                                </div>
                             </div>

                             <div class="mb-4">
                                <label class="form-label-modern">Location *</label>
                                <input type="text" name="location" class="form-control-modern border-0 bg-light py-3 px-4 rounded-4"
                                       placeholder="Full address / venue" required>
                             </div>

                             <div class="row g-4 mb-4">
                                <div class="col-md-6">
                                    <label class="form-label-modern">Max Participants</label>
                                    <input type="number" name="maxParticipants" class="form-control-modern border-0 bg-light py-3 px-4 rounded-4"
                                           value="100" min="10" max="1000">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label-modern">Contact Phone</label>
                                    <input type="tel" name="contactPhone" class="form-control-modern border-0 bg-light py-3 px-4 rounded-4"
                                           placeholder="Camp contact number">
                                </div>
                             </div>

                             <div class="mb-5">
                                <label class="form-label-modern">Description</label>
                                <textarea name="description" class="form-control-modern border-0 bg-light py-3 px-4 rounded-4" rows="4"
                                          placeholder="Details about the camp, what to bring, etc."></textarea>
                             </div>

                             <div class="text-center pt-2">
                                <button type="submit" class="btn btn-primary w-100 py-3 rounded-4 shadow-lg fw-bold" 
                                        style="background:linear-gradient(135deg,#1d3557,#457b9d); border:none; font-size:1.1rem; letter-spacing:0.5px;">
                                    <i class="fas fa-check me-2"></i>Create Blood Camp
                                </button>
                             </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
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
</body>
</html>
