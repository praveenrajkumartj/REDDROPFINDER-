<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vehicle Information - REDDROP Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .vehicle-card {
            border-radius: 20px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            background: white;
            padding: 2.5rem;
        }
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
        
        <div class="sidebar-role">Transport Volunteer</div>
        
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
                <span class="status-dot ${volunteer.availabilityStatus == 'AVAILABLE' ? 'bg-success' : 'bg-danger'} me-2"></span>
                ${volunteer.availabilityStatus}
            </div>
        </div>

        <ul class="sidebar-nav sidebar-nav-main">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/volunteer/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/volunteer/history">
                    <i class="fas fa-route"></i> Transport History
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="${pageContext.request.contextPath}/volunteer/vehicle">
                    <i class="fas fa-id-card"></i> Vehicle Info
                </a>
            </li>
        </ul>

        <div class="mt-auto">
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
        <div class="dashboard-header d-flex justify-content-between align-items-center">
            <div>
                <h1 class="dashboard-title">
                    <i class="fas fa-car-side me-2" style="color:#e63946;"></i>Vehicle Information
                </h1>
                <p class="text-muted small">Manage your transport vehicle and license details.</p>
            </div>
            <div class="ms-auto d-flex align-items-center gap-3">
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

        <div class="dashboard-content-body py-4">
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show rounded-4 shadow-sm mb-4" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="row justify-content-center">
                <div class="col-lg-8 col-xl-7">
                    <div class="vehicle-card shadow-sm">
                        <h4 class="fw-800 mb-4" style="color:#1d3557;">Update Vehicle Details</h4>
                        <form action="${pageContext.request.contextPath}/volunteer/vehicle/update" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label-modern">Vehicle Type</label>
                                    <div class="input-group-modern">
                                        <i class="fas fa-truck-pickup"></i>
                                        <select name="vehicleType" class="form-control-modern form-select" required>
                                            <option value="Bike" ${volunteer.vehicleType == 'Bike' ? 'selected' : ''}>Bike</option>
                                            <option value="Car" ${volunteer.vehicleType == 'Car' ? 'selected' : ''}>Car</option>
                                            <option value="Auto" ${volunteer.vehicleType == 'Auto' ? 'selected' : ''}>Auto</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label-modern">Vehicle Number</label>
                                    <div class="input-group-modern">
                                        <i class="fas fa-hashtag"></i>
                                        <input type="text" name="vehicleNumber" class="form-control-modern" 
                                               value="${volunteer.vehicleNumber}" required placeholder="Ex: TN 01 AB 1234">
                                    </div>
                                </div>
                                <div class="col-12">
                                    <label class="form-label-modern">Driving License Number</label>
                                    <div class="input-group-modern">
                                        <i class="fas fa-id-card"></i>
                                        <input type="text" name="licenseNumber" class="form-control-modern" 
                                               value="${volunteer.licenseNumber}" required placeholder="Enter license number">
                                    </div>
                                </div>
                                <div class="col-12 pt-3">
                                    <button type="submit" class="btn btn-primary-custom w-100 py-3 rounded-pill fw-bold" style="background:#1d3557; border:none; box-shadow:0 10px 20px rgba(29, 53, 87, 0.2);">
                                        <i class="fas fa-save me-2"></i>Save Vehicle Information
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <div class="alert alert-info mt-4 rounded-4 border-0 shadow-sm p-4 d-flex gap-3">
                        <i class="fas fa-info-circle fa-2x text-info opacity-50"></i>
                        <div>
                            <h6 class="fw-bold text-info">Verification Note</h6>
                            <p class="small mb-0 opacity-75">Your vehicle details and license are verified by our admin team to ensuring standard safety protocols for blood transport.</p>
                        </div>
                    </div>
                </div>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
