<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - REDDROP Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Leaflet -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <style>
        .profile-container {
            max-width: 800px;
            margin: 110px auto 40px;
        }
        .profile-header {
            background: linear-gradient(135deg, #FF1E42 0%, #0F172A 100%);
            color: white;
            padding: 40px;
            border-radius: 24px 24px 0 0;
            text-align: center;
            position: relative;
        }
        .profile-avatar-wrapper {
            position: relative;
            width: 150px;
            height: 150px;
            margin: -75px auto 20px;
            z-index: 10;
        }
        .profile-avatar-edit {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 5px solid white;
            background: #f1f5f9;
            object-fit: cover;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .avatar-placeholder {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 5px solid white;
            background: #FF1E42;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            font-weight: 800;
            box-shadow: 0 10px 25px rgba(255, 30, 66, 0.3);
        }
        .image-upload-btn {
            position: absolute;
            bottom: 5px;
            right: 5px;
            background: #00A3FF;
            color: white;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border: 2px solid white;
            transition: all 0.3s ease;
        }
        .image-upload-btn:hover {
            transform: scale(1.1);
            background: #0081cc;
        }
        .card-profile {
            background: white;
            border-radius: 0 0 24px 24px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.05);
        }
        .form-tech {
            border-radius: 12px;
            padding: 0.8rem 1rem;
            border: 1px solid #e2e8f0;
            transition: all 0.3s ease;
        }
        .form-tech:focus {
            border-color: #FF1E42;
            box-shadow: 0 0 0 4px rgba(255, 30, 66, 0.1);
        }
        .notif-icon-circle { width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.9rem; flex-shrink: 0; }
        .notification-item { transition: background 0.2s; cursor: pointer; border-left: 3px solid transparent; }
        .notification-item:hover { background: #f8f9fa !important; border-left-color: var(--primary); }
    </style>
</head>
<body style="background:#F8FAFC;">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container px-lg-5">
        <a class="navbar-brand-custom" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/images/reddrop_pulse_logo.png" alt="REDDROP Logo" class="brand-logo-main">
            <div class="brand-name-main">
                <span class="brand-part-navy">REDDROP</span><span class="brand-part-red">Finder</span>
            </div>
        </a>
        <div class="ms-auto d-flex align-items-center gap-3">
            <a href="${pageContext.request.contextPath}/" class="nav-link" style="color:#1d3557; font-weight:600;">
                <i class="fas fa-home me-1"></i>Home
            </a>
            <!-- Notification Bell -->
            <div class="dropdown">
                <button class="btn btn-light position-relative rounded-circle p-0 border shadow-sm" type="button" data-bs-toggle="dropdown" aria-expanded="false" id="notifBell" style="width:40px; height:40px; display: flex; align-items: center; justify-content: center;">
                    <i class="fas fa-bell fs-5" style="color: var(--primary);"></i>
                    <c:if test="${unreadCount > 0}">
                        <span class="position-absolute badge rounded-pill bg-danger shadow-sm" id="notifBadge" 
                              style="font-size: 0.65rem; padding: 0.35em 0.6em; top: -5px; right: -5px; border: 2px solid white;">
                            ${unreadCount}
                        </span>
                    </c:if>
                </button>
                <div class="dropdown-menu dropdown-menu-end shadow-lg border-0 p-0 rounded-4 mt-2" style="width: 380px; overflow: hidden;">
                    <div class="p-3 d-flex justify-content-between align-items-center" style="background: var(--secondary); color: white;">
                        <h6 class="mb-0 fw-bold">Notifications</h6>
                        <button onclick="markAllRead()" class="btn btn-link text-white btn-sm p-0 text-decoration-none small" style="font-size: 0.75rem;">Mark all as read</button>
                    </div>
                    <div class="notification-list" style="max-height: 400px; overflow-y: auto; padding-right: 4px;">
                        <c:choose>
                            <c:when test="${not empty notifications}">
                                <c:forEach var="n" items="${notifications}">
                                    <div class="px-3 py-3 border-bottom notification-item ${n.readStatus ? '' : 'bg-light'}" style="margin: 0 8px; border-radius: 12px; border: none !important; margin-bottom: 4px;">
                                        <div class="d-flex gap-3">
                                            <div class="notif-icon-circle" style="background: var(--primary); color: white; width: 32px; height: 32px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 0.75rem; flex-shrink: 0; box-shadow: 0 4px 10px rgba(255, 30, 66, 0.2);">
                                                <i class="fas fa-bolt"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="d-flex justify-content-between align-items-center mb-1">
                                                    <h6 class="mb-0 small fw-bold text-dark" style="letter-spacing: -0.01em;">${n.title}</h6>
                                                    <small class="text-muted" style="font-size: 0.65rem; font-weight: 500;">
                                                        <c:out value="${n.createdTime.toString().substring(11, 16)}" />
                                                    </small>
                                                </div>
                                                <p class="mb-0 text-muted" style="font-size: 0.78rem; line-height: 1.5; font-weight: 400;">${n.message}</p>
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
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-danger btn-sm px-4 rounded-pill fw-bold">Dashboard</a>
        </div>
    </div>
</nav>

<div class="container py-5">
    <div class="profile-container" id="profileFormContainer">
        <div class="profile-header">
            <h2 class="mb-0 fw-800">Account Settings</h2>
            <p class="opacity-75">Update your personal information and profile picture</p>
        </div>
        
        <div class="card-profile">
            <form action="${pageContext.request.contextPath}/profile/update" method="post" enctype="multipart/form-data">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                
                <div class="profile-avatar-wrapper">
                    <c:choose>
                        <c:when test="${not empty user.profileImage}">
                            <img src="${pageContext.request.contextPath}/uploads/profiles/${user.profileImage}" id="previewImg" class="profile-avatar-edit" alt="Avatar">
                        </c:when>
                        <c:otherwise>
                            <div id="avatarPlaceholder" class="avatar-placeholder">
                                ${user.name.charAt(0)}
                            </div>
                            <img id="previewImg" class="profile-avatar-edit d-none" alt="Avatar">
                        </c:otherwise>
                    </c:choose>
                    <label for="profileImgInput" class="image-upload-btn">
                        <i class="fas fa-camera"></i>
                    </label>
                    <input type="file" name="image" id="profileImgInput" class="d-none" accept="image/*" onchange="previewImage(this)">
                </div>

                <c:if test="${not empty success}">
                    <div class="alert alert-success rounded-4 border-0 shadow-sm mb-4">
                        <i class="fas fa-check-circle me-2"></i>${success}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger rounded-4 border-0 shadow-sm mb-4">
                        <i class="fas fa-exclamation-circle me-2"></i>${error}
                    </div>
                </c:if>

                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Full Name</label>
                        <input type="text" name="name" class="form-control form-tech" value="${user.name}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Email Address</label>
                        <input type="email" class="form-control form-tech bg-light" value="${user.email}" readonly>
                        <small class="text-muted">Email cannot be changed</small>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Phone Number</label>
                        <input type="text" name="phone" class="form-control form-tech" value="${user.phone}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">City</label>
                        <input type="text" name="city" class="form-control form-tech" value="${user.city}" required>
                    </div>
                    
                    <div class="col-12">
                        <label class="form-label fw-bold"><i class="fas fa-map-location-dot me-2 text-danger"></i>Update Precise Location</label>
                        <div id="profileMap" style="height: 300px; border-radius: 16px; border: 2px solid #e2e8f0; margin-bottom: 1rem;"></div>
                        <p class="small text-muted"><i class="fas fa-info-circle me-1"></i> Tap on the map to update your exact coordinates for better search results.</p>
                        <input type="hidden" name="latitude" id="profileLat" value="${user.latitude}">
                        <input type="hidden" name="longitude" id="profileLon" value="${user.longitude}">
                    </div>
                    <div class="col-12 mt-5">
                        <div class="d-flex gap-3">
                            <button type="submit" class="btn btn-hero-primary px-5" style="border-radius:12px; height: 55px; background:var(--primary); border:none; color:white; font-weight:700;">
                                Save Changes
                            </button>
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-secondary px-5 d-flex align-items-center" style="border-radius:12px; height: 55px; font-weight:700;">
                                Back to Dashboard
                            </a>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var initialLat = ${not empty user.latitude ? user.latitude : 20.5937};
        var initialLon = ${not empty user.longitude ? user.longitude : 78.9629};
        var initialZoom = ${not empty user.latitude ? 15 : 5};

        var map = L.map('profileMap').setView([initialLat, initialLon], initialZoom);
        
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(map);

        var marker;
        if (${not empty user.latitude ? 'true' : 'false'}) {
            marker = L.marker([initialLat, initialLon]).addTo(map);
        }

        map.on('click', function(e) {
            if (marker) {
                marker.setLatLng(e.latlng);
            } else {
                marker = L.marker(e.latlng).addTo(map);
            }
            document.getElementById('profileLat').value = e.latlng.lat;
            document.getElementById('profileLon').value = e.latlng.lng;
        });

        // Try to geolocate if no location set
        if (!${not empty user.latitude ? 'true' : 'false'} && navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var lat = position.coords.latitude;
                var lon = position.coords.longitude;
                map.setView([lat, lon], 13);
            });
        }
    });

    function previewImage(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                var preview = document.getElementById('previewImg');
                var placeholder = document.getElementById('avatarPlaceholder');
                
                preview.src = e.target.result;
                preview.classList.remove('d-none');
                if (placeholder) placeholder.classList.add('d-none');
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
