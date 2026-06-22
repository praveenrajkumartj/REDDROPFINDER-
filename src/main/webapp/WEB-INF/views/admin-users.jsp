<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin Panel</title>
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
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">
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

    <!-- Main Content -->
    <main class="dashboard-content">
        <div class="dashboard-header d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
            <div>
                <h1 class="dashboard-title mb-1">
                    <i class="fas fa-users me-2" style="color:#e63946;"></i>User Management
                </h1>
                <p class="text-muted small mb-0">Monitor and control all registered users in the network.</p>
            </div>
            <div class="d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-outline-custom">
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

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-auto-dismiss mb-4">${successMessage}</div>
        </c:if>

        <!-- Role Filters -->
        <div class="user-filters mb-4">
            <div class="nav nav-pills gap-2 p-2 bg-white rounded-4 shadow-sm d-inline-flex border">
                <button class="filter-btn active" data-filter="ALL">
                    <i class="fas fa-list me-2"></i>All Users
                </button>
                <button class="filter-btn" data-filter="DONOR">
                    <i class="fas fa-tint me-2 text-danger"></i>Donors
                </button>
                <button class="filter-btn" data-filter="PATIENT">
                    <i class="fas fa-user-injured me-2 text-primary"></i>Patients
                </button>
                <button class="filter-btn" data-filter="VOLUNTEER">
                    <i class="fas fa-motorcycle me-2 text-success"></i>Volunteers
                </button>
                <button class="filter-btn" data-filter="HOSPITAL">
                    <i class="fas fa-hospital me-2 text-info"></i>Hospitals
                </button>
            </div>
        </div>

        <div class="card-modern">
            <div class="table-responsive">
                <table class="table-modern">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>City</th>
                        <th>Eligibility</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="u" items="${allUsers}">
                        <tr class="user-row" data-role="${u.role}">
                            <td>${u.id}</td>
                            <td><strong>${u.name}</strong></td>
                            <td>${u.email}</td>
                            <td>
                                <span class="status-badge" style="background:rgba(0,0,0,0.05); color:#1d3557;">
                                    ${u.role}
                                </span>
                            </td>
                            <td>${u.city}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.role == 'DONOR'}">
                                        <c:choose>
                                            <c:when test="${u.donor.eligibleToDonate}">
                                                <span class="badge bg-success-subtle text-success border border-success p-2 rounded-pill">
                                                    <i class="fas fa-check-circle me-1"></i>Eligible
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning-subtle text-warning border border-warning p-2 rounded-pill" 
                                                      title="Last Donation: ${u.donor.lastDonationDate}">
                                                    <i class="fas fa-clock me-1"></i>Ineligible
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted small">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.active}">
                                        <span class="status-badge status-available">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-unavailable">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${u.role != 'ADMIN'}">
                                    <form action="${pageContext.request.contextPath}/admin/toggle-user/${u.id}" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <button type="submit" class="btn btn-sm ${u.active ? 'btn-outline-danger' : 'btn-outline-success'}">
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
    </main>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const filterBtns = document.querySelectorAll('.filter-btn');
        const userRows = document.querySelectorAll('.user-row');

        filterBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                // Update active state
                filterBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');

                const filter = this.dataset.filter;

                userRows.forEach(row => {
                    if (filter === 'ALL' || row.dataset.role === filter) {
                        row.style.display = '';
                        row.style.animation = 'fadeIn 0.4s ease forwards';
                    } else {
                        row.style.display = 'none';
                    }
                });
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
</body>
</html>
