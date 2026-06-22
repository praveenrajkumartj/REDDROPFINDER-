<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Blood Donors - REDDROP Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Leaflet -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <style>
        .map-results { height: 400px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); margin-bottom: 2rem; border: 1px solid rgba(0,0,0,0.05); }
        .distance-badge { background: #e63946; color: white; padding: 2px 8px; border-radius: 6px; font-weight: 700; font-size: 0.75rem; }
        .donor-marker { background: #2dc653; border: 2px solid white; border-radius: 50%; }
        .notif-icon-circle { width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.9rem; flex-shrink: 0; }
        .notification-item { transition: background 0.2s; cursor: pointer; border-left: 3px solid transparent; }
        .notification-item:hover { background: #f8f9fa !important; border-left-color: var(--primary); }
    </style>
</head>
<body style="background:#F8FAFC;">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-custom sticky-top">
    <div class="container-fluid px-lg-5">
        <a class="navbar-brand-custom" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/images/reddrop_pulse_logo.png" alt="REDDROP Logo" class="brand-logo-main">
            <div class="brand-name-main">
                <span class="brand-part-navy">REDDROP</span><span class="brand-part-red">Finder</span>
            </div>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navMain">
            <i class="fas fa-bars-staggered"></i>
        </button>
        <div class="collapse navbar-collapse" id="navMain">
            <ul class="navbar-nav ms-auto align-items-center gap-5">
                <li class="nav-item"><a href="${pageContext.request.contextPath}/" class="nav-link">Home</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/search-donor" class="nav-link">Donors</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/blood-camps" class="nav-link">Camps</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/impact" class="nav-link">Impact</a></li>
                <sec:authorize access="isAnonymous()">
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/login" class="nav-link">Login</a></li>
                </sec:authorize>
                <sec:authorize access="isAuthenticated()">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle"></i> <sec:authentication property="name"/>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <form action="${pageContext.request.contextPath}/logout" method="post">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="dropdown-item text-danger">Logout</button>
                                </form>
                            </li>
                        </ul>
                    </li>
                </sec:authorize>
            </ul>
        </div>
    </div>
</nav>

<!-- Page Header -->
<div style="background: linear-gradient(135deg, #1d3557 0%, #0d1b2a 100%); padding: 3.5rem 0;">
    <div class="container text-center text-white">
        <span class="badge bg-danger mb-3 px-3 py-2 rounded-pill" style="font-size:0.8rem; letter-spacing:1px;">
            <i class="fas fa-location-dot me-2"></i>ADVANCED LOCATION SEARCH
        </span>
        <h1 style="font-size:3rem; font-weight:900;">Find Blood Donors <span style="color:#ff6b7a;">Near You</span></h1>
        <p class="opacity-75 lead">Get connected with life-saving heroes within minutes.</p>
    </div>
</div>

<!-- Search Form -->
<section class="py-4 shadow-sm" style="background:white; border-bottom:1px solid #eee;">
    <div class="container">
        <form action="${pageContext.request.contextPath}/search-donor" method="get" id="donorSearchForm">
            <input type="hidden" name="lat" id="searchLat" value="${searchLat}">
            <input type="hidden" name="lon" id="searchLon" value="${searchLon}">
            
            <div class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label fw-bold small text-uppercase" style="color:#1d3557;">Blood Group *</label>
                    <select class="form-select form-control-modern" name="bloodGroup" required>
                        <option value="">Select Group</option>
                        <c:forEach var="bg" items="${bloodGroups}">
                        <option value="${bg}" ${searchBloodGroup == bg ? 'selected' : ''}>${bg}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold small text-uppercase" style="color:#1d3557;">City (Optional)</label>
                    <input type="text" class="form-control-modern" name="city" placeholder="City name" value="${searchCity}">
                </div>
                <div class="col-md-3">
                    <button type="button" id="btnDetectLocation" class="btn btn-outline-danger w-100 py-2 border-2 fw-bold" style="border-radius:12px;">
                        <i class="fas fa-crosshairs me-2"></i>Find Near Me
                    </button>
                    <small id="locationStatus" class="text-muted d-block mt-1 text-center" style="font-size:0.7rem;"></small>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-danger w-100 py-2 fw-bold" style="border-radius:12px; background:#e63946;">
                        <i class="fas fa-search me-2"></i>Search Donors
                    </button>
                </div>
            </div>
        </form>
    </div>
</section>

<!-- Main Content -->
<section class="py-5">
    <div class="container">
        
        <c:if test="${not empty searchBloodGroup}">
            <!-- Map Results -->
            <div id="resultsMap" class="map-results mb-5"></div>
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 style="font-weight:800; color:#1d3557;">
                    ${resultCount} Match(es) for <span class="text-danger">${searchBloodGroup}</span>
                </h3>
            </div>

            <div class="row g-4">
                <c:choose>
                    <c:when test="${not empty donors}">
                        <c:forEach var="donor" items="${donors}">
                            <div class="col-md-6 col-lg-4">
                                <div class="card border-0 shadow-sm p-4" style="border-radius:20px; transition:all 0.3s ease-in-out;">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div class="d-flex align-items-center gap-3">
                                            <div style="width:50px; height:50px; background:#f1f5f9; border-radius:15px; display:flex; align-items:center; justify-content:center; font-weight:800; color:#1d3557; font-size:1.2rem;">
                                                ${donor.user.name.charAt(0)}
                                            </div>
                                            <div>
                                                <h5 class="mb-0" style="font-weight:700;">${donor.user.name}</h5>
                                                <span class="text-muted small"><i class="fas fa-map-marker-alt me-1"></i>${donor.user.city}</span>
                                            </div>
                                        </div>
                                        <div class="text-end">
                                            <div class="badge bg-danger-subtle text-danger mb-1">${donor.bloodGroup}</div>
                                            <c:if test="${not empty donor.distance}">
                                                <c:choose>
                                                    <c:when test="${donor.distance >= 9999}">
                                                        <div class="distance-badge bg-secondary p-1 px-2" style="font-size:0.65rem;"><i class="fas fa-map-marker-slash me-1"></i>Dist. Hidden</div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="distance-badge"><i class="fas fa-road me-1"></i><fmt:formatNumber value="${donor.distance}" maxFractionDigits="1"/> km</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <div class="d-flex justify-content-between small mb-1">
                                            <span class="text-muted">Eligibility</span>
                                            <span class="${donor.eligibleToDonate ? 'text-success fw-bold' : 'text-warning fw-bold'}">
                                                ${donor.eligibleToDonate ? 'Eligible' : 'On Break'}
                                            </span>
                                        </div>
                                        <div class="d-flex justify-content-between small">
                                            <span class="text-muted">Success Gifts</span>
                                            <span class="fw-bold">${donor.totalDonations} Donations</span>
                                        </div>
                                    </div>

                                    <div class="d-flex gap-2">
                                        <a href="tel:${donor.user.phone}" class="btn btn-outline-danger flex-grow-1 fw-bold rounded-3">
                                            <i class="fas fa-phone me-1"></i>Call
                                        </a>
                                        <a href="${pageContext.request.contextPath}/patient/request-blood?donorId=${donor.id}" class="btn btn-danger flex-grow-1 fw-bold rounded-3">
                                            Request
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center py-5">
                            <i class="fas fa-user-slash fa-4x opacity-25 mb-3"></i>
                            <h4>No donors found in this area.</h4>
                            <p class="text-muted">Try expanding your search or selecting "All Cities".</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <c:if test="${empty searchBloodGroup}">
            <div class="text-center py-5 mb-5 overflow-hidden">
                <div class="mb-5 position-relative">
                    <div class="tech-blob-small" style="top:-30px; left:50%; transform:translateX(-50%); background: radial-gradient(circle, rgba(230, 57, 70, 0.1) 0%, transparent 60%);"></div>
                    <img src="${pageContext.request.contextPath}/images/blood_drop_search.png" alt="Search" style="width:140px; border-radius:30px; box-shadow:0 15px 40px rgba(0,0,0,0.1); border:4px solid white;">
                </div>
                <h3 style="font-weight:900; color:#1d3557; letter-spacing:-0.5px;">Ready to Scan for Heroes?</h3>
                <p class="text-muted mx-auto mb-5" style="max-width:550px; font-size:1.1rem;">Connect with hundreds of verified donors across our digital network. Fast, reliable, and completely free in emergencies.</p>

                <!-- Section: Local Reliable Heroes -->
                <c:if test="${not empty recentDonors}">
                <div class="pt-5 border-top">
                    <div class="d-flex align-items-center justify-content-center gap-3 mb-4">
                        <div style="height:2px; width:40px; background:rgba(0,0,0,0.1);"></div>
                        <h5 class="text-uppercase small fw-800 text-muted" style="letter-spacing:2px;">Recently Joined Life Savers</h5>
                        <div style="height:2px; width:40px; background:rgba(0,0,0,0.1);"></div>
                    </div>
                    <div class="row g-3">
                        <c:forEach var="donor" items="${recentDonors}">
                        <div class="col-md-4 col-lg-2">
                           <div class="p-3 bg-white rounded-4 shadow-sm border border-opacity-10 h-100 d-flex flex-column align-items-center">
                               <div style="width:50px; height:50px; background:linear-gradient(135deg, #f1f5f9, #e2e8f0); border-radius:50%; display:flex; align-items:center; justify-content:center; font-weight:800; color:#1d3557; font-size:1.1rem; margin-bottom:0.75rem;">
                                   ${donor.user.name.charAt(0)}
                               </div>
                               <h6 class="mb-1 fw-bold text-truncate w-100 text-center">${donor.user.name}</h6>
                               <div class="badge bg-danger-subtle text-danger mb-0">${donor.bloodGroup}</div>
                               <div class="small text-muted mt-1"><i class="fas fa-location-dot me-1"></i>${donor.user.city}</div>
                           </div>
                        </div>
                        </c:forEach>
                    </div>
                </div>
                </c:if>
            </div>
        </c:if>
    </div>
</section>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var map;
        var markers = [];
        
        // Dynamic search parameters from server
        var searchBloodGroup = <c:choose><c:when test="${not empty searchBloodGroup}">true</c:when><c:otherwise>false</c:otherwise></c:choose>;
        var searchLat = <c:choose><c:when test="${not empty searchLat}">${searchLat}</c:when><c:otherwise>20.5937</c:otherwise></c:choose>;
        var searchLon = <c:choose><c:when test="${not empty searchLon}">${searchLon}</c:when><c:otherwise>78.9629</c:otherwise></c:choose>;
        var searchZoom = <c:choose><c:when test="${not empty searchLat}">12</c:when><c:otherwise>5</c:otherwise></c:choose>;

        if (searchBloodGroup) {
            // Initialize Map
            map = L.map('resultsMap').setView([searchLat, searchLon], searchZoom);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; OpenStreetMap'
            }).addTo(map);

            var bounds = [];

            // Add Search Center Marker
            <c:if test="${not empty searchLat}">
                var userPos = [searchLat, searchLon];
                L.marker(userPos, {
                    icon: L.divIcon({
                        className: 'patient-marker',
                        html: '<div style="background:#e63946;width:24px;height:24px;border-radius:50%;border:4px solid white;box-shadow:0 0 15px rgba(230,57,70,0.5);display:flex;align-items:center;justify-content:center;color:white;font-size:10px;"><i class="fas fa-user-large"></i></div>'
                    })
                }).addTo(map).bindPopup("<div class='text-center'><b>You are here</b><br><small class='text-muted'>Search Center</small></div>");
                bounds.push(userPos);
            </c:if>

            // Add Donor Markers
            <c:forEach var="donor" items="${donors}">
                <c:if test="${not empty donor.user.latitude and not empty donor.user.longitude}">
                    var donorPos = [${donor.user.latitude}, ${donor.user.longitude}];
                    var dMarker = L.marker(donorPos, {
                        icon: L.divIcon({
                            className: 'donor-marker-div',
                            html: '<div style="background:#2dc653;width:20px;height:20px;border-radius:50%;border:3px solid white;box-shadow:0 0 12px rgba(45,198,83,0.5);display:flex;align-items:center;justify-content:center;color:white;font-size:8px;"><i class="fas fa-droplet"></i></div>'
                        })
                    }).addTo(map);
                    
                    var distHtml = "";
                    <c:if test="${not empty donor.distance and donor.distance < 9999}">
                        distHtml = "<br><span class='badge bg-danger'>${donor.distance} km away</span>";
                    </c:if>

                    dMarker.bindPopup("<div class='text-center'><div class='mb-2 fw-bold text-navy'><i class='fas fa-drop me-1 text-danger'></i>REDDROP</div>" + 
                        "<b>" + "${donor.user.name.replaceAll('"', '\"')}" + "</b><br>" +
                        "<span class='badge bg-success-subtle text-success mb-2'>${donor.bloodGroup} Donor</span>" + 
                        distHtml + 
                        "<br><div class='mt-2 d-flex gap-1'><a href='tel:${donor.user.phone}' class='btn btn-outline-danger btn-sm rounded-pill flex-grow-1'><i class='fas fa-phone'></i></a>" +
                        "<a href='${pageContext.request.contextPath}/patient/request-blood?donorId=${donor.id}' class='btn btn-danger btn-sm rounded-pill text-white flex-grow-1 px-3' style='font-size:10px;'>Request</a></div></div>");
                    bounds.push(donorPos);
                </c:if>
            </c:forEach>

            // Auto-zoom to fit all results
            if (bounds.length > 1) {
                map.fitBounds(bounds, { padding: [50, 50] });
            } else if (bounds.length === 1) {
                map.setView(bounds[0], 14);
            }
        }

        // Detect Location Logic
        document.getElementById('btnDetectLocation').addEventListener('click', function() {
            var status = document.getElementById('locationStatus');
            status.innerText = "Locating...";
            
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    document.getElementById('searchLat').value = position.coords.latitude;
                    document.getElementById('searchLon').value = position.coords.longitude;
                    status.innerText = "Location detected ✅";
                }, function(error) {
                    status.innerText = "Error: " + error.message;
                });
            } else {
                status.innerText = "Geolocation not supported";
            }
        });
    });
</script>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
<script>AOS.init({ duration: 800, once: true });</script>
</body>
</html>
