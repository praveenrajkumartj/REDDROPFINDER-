<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Global Network View - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Leaflet -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <style>
        .map-full { height: calc(100vh - 100px); width: 100%; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .map-legend { position: absolute; top: 20px; right: 20px; background: white; padding: 15px; border-radius: 12px; z-index: 1000; box-shadow: 0 5px 15px rgba(0,0,0,0.1); border: 1px solid #eee; }
        .legend-item { display:flex; align-items:center; gap:10px; margin-bottom: 8px; font-size: 0.85rem; font-weight: 600; }
        .dot { width: 12px; height: 12px; border-radius: 50%; display: inline-block; }
    </style>
</head>
<body style="background:#F1F5F9;">

<nav class="navbar navbar-expand-lg navbar-custom mb-0">
    <div class="container-fluid px-5">
        <a class="navbar-brand-custom" href="${pageContext.request.contextPath}/admin/dashboard">
            <div class="brand-name-main"><span class="brand-part-navy">ADMIN</span><span class="brand-part-red">PULSE</span></div>
        </a>
        <div class="ms-auto">
            <div class="d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-danger btn-sm rounded-pill px-4">
                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
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
    </div>
</nav>

<div class="container-fluid p-4">
    <div class="position-relative">
        <div id="adminGlobalMap" class="map-full"></div>
        
        <div class="map-legend">
            <h6 class="fw-bold mb-3">Live Network Legend</h6>
            <div class="legend-item"><span class="dot" style="background:#e63946;"></span> Donors</div>
            <div class="legend-item"><span class="dot" style="background:#457b9d;"></span> Patients</div>
            <div class="legend-item"><span class="dot" style="background:#2a9d8f;"></span> Hospitals</div>
            <div class="legend-item"><span class="dot" style="background:#f4a261;"></span> Blood Camps</div>
            <hr>
            <div class="small text-muted">Showing ${allUsers.size()} entities</div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var map = L.map('adminGlobalMap').setView([20.5937, 78.9629], 5);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

        var markers = [];

        <c:forEach var="u" items="${allUsers}">
            <c:if test="${not empty u.latitude}">
                var color = '#457b9d'; // Default Patient
                if ('${u.role}' === 'DONOR') color = '#e63946';
                if ('${u.role}' === 'HOSPITAL') color = '#2a9d8f';

                var m = L.circleMarker([${u.latitude}, ${u.longitude}], {
                    radius: 8,
                    fillColor: color,
                    color: "#fff",
                    weight: 2,
                    opacity: 1,
                    fillOpacity: 0.8
                }).addTo(map);
                
                m.bindPopup("<b>${u.name}</b><br>Role: ${u.role}<br>City: ${u.city}");
                markers.push(m);
            </c:if>
        </c:forEach>

        <c:forEach var="c" items="${allCamps}">
            <c:if test="${not empty c.latitude}">
                var m = L.marker([${c.latitude}, ${c.longitude}], {
                    icon: L.divIcon({
                        className: 'camp-icon',
                        html: '<div style="background:#f4a261;width:12px;height:12px;border-radius:2px;border:2px solid white;"></div>'
                    })
                }).addTo(map);
                m.bindPopup("<b>Camp: ${c.campName}</b><br>Date: ${c.date}");
                markers.push(m);
            </c:if>
        </c:forEach>

        if (markers.length > 0) {
            var group = new L.featureGroup(markers);
            map.fitBounds(group.getBounds());
        }
    });
</script>
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
