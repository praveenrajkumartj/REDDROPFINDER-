<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Blood - REDDROP Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        #map { height: 350px; border-radius: 15px; margin-bottom: 20px; border: 2px solid #eee; background: #f8f9fa; }
        .leaflet-tile { opacity: 1 !important; visibility: visible !important; }
        .leaflet-container { background: #f8f9fa !important; }
        .urgency-selector .btn {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border-width: 2px !important;
            border-radius: 12px !important;
            padding: 0.8rem !important;
            font-weight: 700 !important;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        label[for="urgCritical"] { border-color: #e63946 !important; color: #e63946 !important; }
        label[for="urgHigh"] { border-color: #e65c00 !important; color: #e65c00 !important; }
        label[for="urgMedium"] { border-color: #e6a800 !important; color: #e6a800 !important; }
        label[for="urgLow"] { border-color: #2dc653 !important; color: #2dc653 !important; }
        .btn-check:checked + label[for="urgCritical"] { background-color: #e63946 !important; color: white !important; }
        .btn-check:checked + label[for="urgHigh"] { background-color: #e65c00 !important; color: white !important; }
        .btn-check:checked + label[for="urgMedium"] { background-color: #e6a800 !important; color: white !important; }
        .btn-check:checked + label[for="urgLow"] { background-color: #2dc653 !important; color: white !important; }
    </style>
</head>
<body>
<div class="dashboard-layout">
    <aside class="sidebar">
        <a href="${pageContext.request.contextPath}/" class="sidebar-brand-new pt-1 text-decoration-none">
            <img src="${pageContext.request.contextPath}/images/reddrop_pulse_logo.png" alt="Logo" class="sidebar-logo-clean" 
                 style="height: 48px; filter: brightness(1.1) drop-shadow(0 0 12px rgba(255, 30, 66, 0.3));">
            <div class="sidebar-brand-text">
                <span class="brand-part-white">REDDROP</span><span class="brand-part-red">FINDER</span>
            </div>
        </a>
        <div class="sidebar-role">Care Receiver</div>
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
            <div class="text-white mt-3 fw-bold">${user.name}</div>
            <div class="d-flex align-items-center justify-content-center mt-1" style="color:rgba(255,255,255,0.45); font-size:0.85rem;">
                <i class="fas fa-location-dot me-2"></i>${user.city}
            </div>
        </div>
        <ul class="sidebar-nav sidebar-nav-main">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/patient/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="${pageContext.request.contextPath}/patient/request-blood"><i class="fas fa-heartbeat"></i> Request Blood</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/search-donor"><i class="fas fa-search"></i> Find Donors</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/blood-camps"><i class="fas fa-hospital"></i> Blood Camps</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/impact"><i class="fas fa-chart-line"></i> Impact Stats</a>
            </li>
        </ul>
        <div class="mt-auto">
            <form action="${pageContext.request.contextPath}/logout" method="post" class="p-0 m-0">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="btn-logout-sidebar"><i class="fas fa-sign-out-alt"></i> Logout</button>
            </form>
        </div>
    </aside>

    <main class="dashboard-content">
        <div class="dashboard-header d-flex justify-content-between">
            <div>
                <h1 class="dashboard-title"><i class="fas fa-heartbeat me-2" style="color:#e63946;"></i>Emergency Blood Request</h1>
                <p class="text-muted small">Select the hospital location on the map to alert nearby donors.</p>
            </div>
            <div class="ms-auto d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn-outline-custom">
                    <i class="fas fa-arrow-left me-1"></i>Back
                </a>
                <div class="dropdown">
                    <button class="btn btn-light position-relative rounded-circle p-2 border shadow-sm" type="button" data-bs-toggle="dropdown" aria-expanded="false" id="notifBell">
                        <i class="fas fa-bell fs-5" style="color: #00A3FF;"></i>
                        <c:if test="${unreadCount > 0}">
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" id="notifBadge">${unreadCount}</span>
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
                                        <div class="p-3 border-bottom notification-item">
                                            <div class="d-flex gap-3">
                                                <div class="notif-icon-circle bg-primary-subtle text-primary" style="width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                                    <i class="fas fa-info-circle"></i>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <h6 class="mb-1 small fw-bold text-dark"><c:out value="${n.title}"/></h6>
                                                    <p class="mb-0 text-muted small" style="font-size: 0.8rem;"><c:out value="${n.message}"/></p>
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
            <div class="row justify-content-center">
                <div class="col-xl-9">
                    <div class="card-modern shadow-sm border-0">
                        <form action="${pageContext.request.contextPath}/patient/request-blood" method="post" class="p-2">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" id="latitude" name="latitude">
                            <input type="hidden" id="longitude" name="longitude">

                            <div class="mb-4">
                                <label class="form-label-modern mb-3">Hospital Location <span class="text-danger">*</span></label>
                                <div id="map"></div>
                                <p class="small text-muted"><i class="fas fa-info-circle me-1"></i> Click on the map to set the exact hospital location.</p>
                            </div>

                            <div class="mb-5">
                                <label class="form-label-modern mb-3">Urgency Level <span class="text-danger">*</span></label>
                                <div class="row g-3 urgency-selector">
                                    <div class="col-sm-3">
                                        <input type="radio" class="btn-check" name="urgencyLevel" id="urgCritical" value="CRITICAL" required>
                                        <label class="btn w-100" for="urgCritical">🔴 Critical</label>
                                    </div>
                                    <div class="col-sm-3">
                                        <input type="radio" class="btn-check" name="urgencyLevel" id="urgHigh" value="HIGH">
                                        <label class="btn w-100" for="urgHigh">🟠 High</label>
                                    </div>
                                    <div class="col-sm-3">
                                        <input type="radio" class="btn-check" name="urgencyLevel" id="urgMedium" value="MEDIUM">
                                        <label class="btn w-100" for="urgMedium">🟡 Medium</label>
                                    </div>
                                    <div class="col-sm-3">
                                        <input type="radio" class="btn-check" name="urgencyLevel" id="urgLow" value="LOW">
                                        <label class="btn w-100" for="urgLow">🟢 Low</label>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-4 mb-4">
                                <div class="col-md-6">
                                    <label for="bloodGroup" class="form-label-modern">Blood Group Needed *</label>
                                    <select class="form-select border-0 bg-light py-3 px-4 rounded-4" id="bloodGroup" name="bloodGroup" required>
                                        <c:forEach var="bg" items="${bloodGroups}">
                                            <option value="${bg}">${bg}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="city" class="form-label-modern">City *</label>
                                    <input type="text" class="form-control border-0 bg-light py-3 px-4 rounded-4" id="city" name="city" value="${user.city}" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="hospitalName" class="form-label-modern">Hospital Name *</label>
                                <input type="text" class="form-control border-0 bg-light py-3 px-4 rounded-4" id="hospitalName" name="hospitalName" required>
                            </div>

                            <div class="row g-4 mb-4">
                                <div class="col-md-6">
                                    <label for="patientName" class="form-label-modern">Patient Name *</label>
                                    <input type="text" class="form-control border-0 bg-light py-3 px-4 rounded-4" id="patientName" name="patientName" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="contactPhone" class="form-label-modern">Contact Phone *</label>
                                    <input type="text" class="form-control border-0 bg-light py-3 px-4 rounded-4" id="contactPhone" name="contactPhone" placeholder="Mobile number" required>
                                </div>
                            </div>

                            <div class="text-center pt-2">
                                <button type="submit" class="btn btn-primary w-100 py-3 rounded-4 shadow-lg fw-bold" style="background:linear-gradient(135deg,#e63946,#c1121f); border:none;">
                                    <i class="fas fa-paper-plane me-2"></i>Send Emergency Alert
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>



<script>
    (function() {
        // Immediate Execution Map Logic
        function startMap() {
            const mapDiv = document.getElementById('map');
            if (!mapDiv || mapDiv._leaflet_id) return;

            let lat = parseFloat("${user.latitude}") || 20.5937;
            let lon = parseFloat("${user.longitude}") || 78.9629;

            const map = L.map('map').setView([lat, lon], 13);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '© OpenStreetMap'
            }).addTo(map);

            const marker = L.marker([lat, lon], {draggable: true}).addTo(map);

            function update(lt, ln) {
                document.getElementById('latitude').value = lt.toFixed(6);
                document.getElementById('longitude').value = ln.toFixed(6);
                marker.setLatLng([lt, ln]);
            }

            map.on('click', e => update(e.latlng.lat, e.latlng.lng));
            marker.on('dragend', e => {
                const p = e.target.getLatLng();
                update(p.lat, p.lng);
            });

            // Geocoding logic
            const cityEl = document.getElementById('city');
            const hospEl = document.getElementById('hospitalName');
            let t;
            function search() {
                const q = ((hospEl?.value || "") + " " + (cityEl?.value || "")).trim();
                if(!q) return;
                fetch(`https://nominatim.openstreetmap.org/search?format=json&q=\${encodeURIComponent(q)}&limit=1`)
                    .then(r => r.json())
                    .then(d => {
                        if(d?.length) {
                            const la = parseFloat(d[0].lat);
                            const lo = parseFloat(d[0].lon);
                            map.setView([la, lo], 15);
                            update(la, lo);
                        }
                    });
            }
            [cityEl, hospEl].forEach(el => el && el.addEventListener('input', () => {
                clearTimeout(t);
                t = setTimeout(search, 1000);
            }));

            update(lat, lon);
            setTimeout(() => map.invalidateSize(), 500);
            setTimeout(() => map.invalidateSize(), 2000);
        }

        // Try to start every 300ms until successful
        const mapInterval = setInterval(() => {
            if (window.L && document.getElementById('map')) {
                startMap();
                clearInterval(mapInterval);
            }
        }, 300);
    })();

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
