<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Notifications - REDDROP Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .notif-page-card {
            border-radius: 20px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            overflow: hidden;
            background: white;
        }
        .notif-icon-circle { width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.9rem; flex-shrink: 0; }
        .notification-item { transition: background 0.2s; cursor: pointer; border-left: 3px solid transparent; }
        .notification-item:hover { background: #f8f9fa !important; border-left-color: var(--primary); }
        .notif-row {
            padding: 1.5rem;
            border-bottom: 1px solid #f0f0f0;
            transition: all 0.2s;
            display: flex;
            gap: 1.25rem;
            align-items: flex-start;
        }
        .notif-row:hover {
            background: #fdfdfd;
        }
        .notif-row.unread {
            background: #fff8f8;
            border-left: 4px solid var(--primary);
        }
        .notif-icon-box {
            width: 45px;
            height: 45px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            flex-shrink: 0;
        }
        .type-alert { background: #fee2e2; color: #ef4444; }
        .type-info { background: #e0e7ff; color: #4338ca; }
        .type-success { background: #dcfce7; color: #16a34a; }
        
        .notif-time {
            font-size: 0.8rem;
            color: #94a3b8;
            font-weight: 500;
        }
    </style>
</head>
<body style="background-color: #f8fafc;">

<nav class="navbar navbar-expand-lg navbar-custom mb-4">
    <div class="container px-lg-5">
        <a class="navbar-brand-custom" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/images/reddrop_pulse_logo.png" alt="REDDROP Logo" class="brand-logo-main">
            <div class="brand-name-main">
                <span class="brand-part-navy">REDDROP</span><span class="brand-part-red">Finder</span>
            </div>
        </a>
        <div class="ms-auto d-flex align-items-center gap-3">
            <!-- Notification Bell removed from this page as it's redundant -->
            
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-dark btn-sm rounded-pill px-4 fw-bold">
                <i class="fas fa-arrow-left me-1"></i> Back
            </a>
        </div>
    </div>
</nav>

<div class="container py-4" style="max-width: 900px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-800 mb-1" style="color: #1e293b;">Notification Center</h2>
            <p class="text-muted small mb-0">Manage and view all your account alerts</p>
        </div>
        <button onclick="markHistoryRead()" class="btn btn-primary-custom btn-sm rounded-pill px-4">
            Mark all read
        </button>
    </div>

    <div class="notif-page-card">
        <c:choose>
            <c:when test="${not empty notifications}">
                <c:forEach var="n" items="${notifications}">
                    <div class="notif-row ${n.readStatus ? '' : 'unread'}">
                        <div class="notif-icon-box 
                             ${n.notificationType == 'BLOOD_REQUEST' ? 'type-alert' : 
                               n.notificationType == 'DONATION_COMPLETED' ? 'type-success' : 'type-info'}">
                            <i class="fas 
                               ${n.notificationType == 'BLOOD_REQUEST' ? 'fa-heartbeat' : 
                                 n.notificationType == 'DONATION_COMPLETED' ? 'fa-award' : 'fa-bell'}"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="d-flex justify-content-between mb-1">
                                <h6 class="mb-0 fw-bold" style="color: #334155;">${n.title}</h6>
                                <span class="notif-time">
                                    <fmt:parseDate value="${n.createdTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDT" />
                                    <fmt:formatDate value="${parsedDT}" pattern="MMM dd, hh:mm a" />
                                </span>
                            </div>
                            <p class="mb-0" style="color: #64748b; font-size: 0.95rem; line-height: 1.5;">${n.message}</p>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <img src="${pageContext.request.contextPath}/images/no_notifications.png" alt="No Notif" style="height: 120px; opacity: 0.5; margin-bottom: 1.5rem;">
                    <h5 class="text-muted">No notifications yet</h5>
                    <p class="text-muted small">Stay tuned for updates and alerts!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function markHistoryRead() {
        fetch('${pageContext.request.contextPath}/notifications/mark-read', {
            method: 'POST',
            headers: { 'X-CSRF-TOKEN': '${_csrf.token}' }
        }).then(() => {
            // UI updates
            document.querySelectorAll('.unread').forEach(row => {
                row.classList.remove('unread');
            });
            const badge = document.getElementById('notifBadge');
            if(badge) badge.remove();
        });
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
