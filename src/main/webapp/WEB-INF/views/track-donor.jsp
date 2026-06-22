<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Blood Donor - REDDROP Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Leaflet -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <style>
        .tracking-header { background: #1d3557; color: white; padding: 2rem 0; border-radius: 0 0 30px 30px; }
        .map-container { height: 500px; border-radius: 24px; box-shadow: 0 15px 40px rgba(0,0,0,0.12); border: 4px solid white; position: relative; }
        .tracking-card { position: absolute; bottom: 20px; left: 20px; right: 20px; background: white; border-radius: 18px; padding: 1.5rem; z-index: 1000; display: flex; align-items: center; justify-content: space-between; border: 1px solid #eee; }
        .pulse-red { width: 10px; height: 10px; background: #e63946; border-radius: 50%; display: inline-block; margin-right: 8px; animation: pulse 1.5s infinite; }
        @keyframes pulse { 0% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(230, 57, 70, 0.7); } 70% { transform: scale(1); box-shadow: 0 0 0 10px rgba(230, 57, 70, 0); } 100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(230, 57, 70, 0); } }
    </style>
</head>
<body style="background:#F8FAFC;">

<nav class="navbar navbar-expand-lg navbar-custom mb-0">
    <div class="container-fluid px-lg-5">
        <a class="navbar-brand-custom" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/images/reddrop_pulse_logo.png" alt="REDDROP Logo" class="brand-logo-main">
            <div class="brand-name-main">
                <span class="brand-part-navy">REDDROP</span><span class="brand-part-red">Finder</span>
            </div>
        </a>
        <div class="ms-auto">
            <div class="d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-outline-danger btn-sm px-4 rounded-pill fw-bold">
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

<div class="tracking-header mb-4">
    <div class="container text-center">
        <h2 class="fw-bold mb-1">Live Donor Tracking</h2>
        <p class="opacity-75 mb-0">Hero <span class="text-danger fw-bold">${req.acceptedBy.name}</span> is on the way!</p>
    </div>
</div>

<div class="container pb-5">
    <div class="row g-4 d-flex justify-content-center">
        <div class="col-lg-8">
            <div class="map-container overflow-hidden">
                <div id="liveMap" style="height: 100%;"></div>
                
                <div class="tracking-card shadow-lg">
                    <div class="d-flex align-items-center gap-3">
                        <div style="width:55px;height:55px;background:#f1f5f9;border-radius:15px;display:flex;align-items:center;justify-content:center;font-size:1.5rem;">
                            🚗
                        </div>
                        <div>
                            <div class="small text-muted text-uppercase fw-bold letter-spacing-1">Estimated Arrival</div>
                            <div class="h4 mb-0 fw-bold text-navy" id="liveEtaDisplay">${not empty req.eta ? req.eta : 'Calculating...'}</div>
                        </div>
                    </div>
                    <div class="text-end">
                        <div class="d-flex align-items-center justify-content-end mb-1">
                            <span class="pulse-red"></span>
                            <span class="small fw-bold">Live Updates</span>
                        </div>
                        <a href="tel:${req.acceptedBy.phone}" class="btn btn-navy btn-sm px-4 rounded-pill">
                            <i class="fas fa-phone me-2"></i>Contact Donor
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm p-4 h-100" style="border-radius:24px;">
                <h5 class="fw-bold mb-4" style="color:#1d3557;">Mission Details</h5>
                
                <div class="mb-4">
                    <label class="small text-muted text-uppercase d-block mb-1">Donor Information</label>
                    <div class="d-flex align-items-center gap-2">
                        <div>
                            <div class="fw-bold">${req.acceptedBy.name}</div>
                            <div class="small text-muted">Verified Life Saver</div>
                        </div>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="small text-muted text-uppercase d-block mb-1">Blood Request</label>
                    <div class="fw-bold fs-5 text-danger">${req.bloodGroup} Needed</div>
                    <div class="small text-muted"><i class="fas fa-hospital me-1"></i> ${req.hospitalName}</div>
                </div>

                <div class="mt-auto">
                    <div class="p-3 bg-light rounded-3">
                        <div class="small text-muted mb-2">Current Status:</div>
                        <div class="badge bg-success w-100 py-2 fs-6">
                            <i class="fas fa-check-circle me-1"></i> Donor Accepted
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var map = L.map('liveMap').setView([${not empty req.liveLatitude ? req.liveLatitude : 20.5937}, ${not empty req.liveLongitude ? req.liveLongitude : 78.9629}], 15);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

        var donorMarker = L.marker([${not empty req.liveLatitude ? req.liveLatitude : 20.5937}, ${not empty req.liveLongitude ? req.liveLongitude : 78.9629}], {
            icon: L.divIcon({
                className: 'donor-icon',
                html: '<div style="background:#2dc653;width:20px;height:20px;border-radius:50%;border:3px solid white;box-shadow:0 0 15px rgba(0,0,0,0.2);"></div>'
            })
        }).addTo(map);

        // Polling for updates every 5 seconds
        setInterval(function() {
            fetch(window.location.origin + '/api/request-status/${req.id}')
                .then(response => response.json())
                .then(data => {
                    if (data.latitude && data.longitude) {
                        var newPos = [data.latitude, data.longitude];
                        donorMarker.setLatLng(newPos);
                        map.panTo(newPos);
                    }
                    if (data.eta) {
                        document.getElementById('liveEtaDisplay').innerText = data.eta;
                    }
                });
        }, 5000);
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
