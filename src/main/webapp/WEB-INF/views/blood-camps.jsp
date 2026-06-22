<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blood Camps - REDDROP Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

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

<!-- Page Hero -->
<div style="background:linear-gradient(135deg,#1d3557 0%,#0d1b2a 100%);padding:4rem 0;">
    <div class="container text-center">
        <span class="section-badge" style="background:rgba(230,57,70,0.2);color:#ff6b7a;">
            <i class="fas fa-calendar-alt me-1"></i>Community Events
        </span>
        <h1 style="font-size:2.8rem;font-weight:900;color:white;margin-bottom:1rem;">
            Blood Donation Camps
        </h1>
        <p style="color:rgba(255,255,255,0.7);font-size:1.1rem;">
            Join organized blood donation drives and earn recognition badges
        </p>
    </div>
</div>

<section class="py-5" style="background:var(--bg);">
    <div class="container">

        <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-auto-dismiss d-flex align-items-center gap-2 mb-4">
            <i class="fas fa-check-circle"></i>${successMessage}
        </div>
        </c:if>

        <!-- Upcoming Camps -->
        <div class="mb-5">
            <div class="d-flex align-items-center gap-3 mb-4">
                <h2 style="font-weight:800;color:#1d3557;margin:0;">Upcoming Camps</h2>
                <span class="status-badge status-available">Live</span>
            </div>

            <c:choose>
                <c:when test="${not empty upcomingCamps}">
                <div class="row g-4">
                    <c:forEach var="camp" items="${upcomingCamps}" varStatus="status">
                    <div class="col-md-6 col-xl-4">
                        <div class="camp-card">
                            <div class="camp-card-header">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="camp-date-badge">
                                        <i class="fas fa-calendar me-1"></i>${camp.date}
                                    </span>
                                    <span class="status-badge" style="background:rgba(255,255,255,0.2);color:white;">
                                        ${camp.status}
                                    </span>
                                </div>
                                <h5 class="mb-0">${camp.campName}</h5>
                                <small style="opacity:0.8;">by ${camp.organizer}</small>
                            </div>
                            <div class="camp-card-body">
                                <div class="d-flex flex-column gap-2 mb-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="fas fa-map-marker-alt text-danger" style="width:16px;"></i>
                                        <span class="text-muted small">${camp.location}</span>
                                    </div>
                                    <c:if test="${not empty camp.contactPhone}">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="fas fa-phone text-muted" style="width:16px;"></i>
                                        <span class="text-muted small">${camp.contactPhone}</span>
                                    </div>
                                    </c:if>
                                    <c:if test="${not empty camp.description}">
                                    <div class="d-flex align-items-start gap-2">
                                        <i class="fas fa-info-circle text-muted mt-1" style="width:16px;"></i>
                                        <span class="text-muted small">${camp.description}</span>
                                    </div>
                                    </c:if>
                                </div>

                                <!-- Capacity Bar -->
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span class="text-muted small">Registrations</span>
                                        <span class="text-muted small">${camp.registeredCount}/${camp.maxParticipants}</span>
                                    </div>
                                    <c:set var="regPercent" value="${camp.maxParticipants > 0 ? (camp.registeredCount * 100) / camp.maxParticipants : 0}"/>
                                     <div style="background:#e9ecef;border-radius:10px;height:8px;">
                                         <div style="background:linear-gradient(90deg,#e63946,#c1121f);border-radius:10px;height:8px;width:${regPercent}%;"></div>
                                     </div>
                                </div>

                                <!-- Register Button -->
                                <sec:authorize access="isAuthenticated()">
                                    <form action="${pageContext.request.contextPath}/hospital/register-camp/${camp.id}" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <c:choose>
                                            <c:when test="${registeredCampIds.contains(camp.id)}">
                                                <button disabled class="btn-outline-custom w-100 justify-content-center"
                                                        style="background-color: var(--success); color: white; border-color: var(--success); opacity: 0.8; cursor: default;">
                                                    <i class="fas fa-check-double me-1"></i>Already Registered
                                                </button>
                                            </c:when>
                                            <c:when test="${camp.registeredCount >= camp.maxParticipants}">
                                                <button disabled class="btn-outline-custom w-100 justify-content-center"
                                                        style="opacity:0.5;cursor:not-allowed;">
                                                    <i class="fas fa-times me-1"></i>Fully Booked
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="submit" class="btn-primary-custom w-100 justify-content-center">
                                                    <i class="fas fa-check me-1"></i>Register for Camp
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </form>
                                </sec:authorize>
                                <sec:authorize access="isAnonymous()">
                                    <a href="${pageContext.request.contextPath}/login"
                                       class="btn-outline-custom w-100 justify-content-center">
                                        <i class="fas fa-sign-in-alt me-1"></i>Login to Register
                                    </a>
                                </sec:authorize>
                            </div>
                        </div>
                    </div>
                    </c:forEach>
                </div>
                </c:when>
                <c:otherwise>
                <div class="text-center py-5">
                    <i class="fas fa-calendar-times fa-4x text-muted mb-3"></i>
                    <h5 class="text-muted">No upcoming blood camps scheduled</h5>
                    <p class="text-muted">Check back soon or search for donors directly.</p>
                    <sec:authorize access="hasRole('HOSPITAL')">
                        <a href="${pageContext.request.contextPath}/hospital/add-camp"
                           class="btn-primary-custom mt-2">
                            <i class="fas fa-plus me-2"></i>Create a Blood Camp
                        </a>
                    </sec:authorize>
                </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- All Camps (including past) -->
        <c:if test="${camps.size() != upcomingCamps.size()}">
        <div>
            <h3 class="mb-4" style="font-weight:700;color:#1d3557;">All Camps</h3>
            <div class="card-modern">
                <div class="table-responsive">
                    <table class="table-modern">
                        <thead>
                        <tr>
                            <th>Camp Name</th>
                            <th>Organizer</th>
                            <th>Location</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Registrations</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="camp" items="${camps}">
                        <tr>
                            <td><strong>${camp.campName}</strong></td>
                            <td>${camp.organizer}</td>
                            <td><i class="fas fa-map-marker-alt me-1 text-muted"></i>${camp.location}</td>
                            <td>${camp.date}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${camp.status == 'UPCOMING'}">
                                        <span class="status-badge status-available">${camp.status}</span>
                                    </c:when>
                                    <c:when test="${camp.status == 'ONGOING'}">
                                        <span class="status-badge" style="background:rgba(69,123,157,0.1);color:#457b9d;">${camp.status}</span>
                                    </c:when>
                                    <c:when test="${camp.status == 'COMPLETED'}">
                                        <span class="status-badge" style="background:#e9ecef;color:#6c757d;">${camp.status}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-unavailable">${camp.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${camp.registeredCount}/${camp.maxParticipants}</td>
                        </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        </c:if>
    </div>
</section>
<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>AOS.init({ duration: 800, once: true });</script>
</body>
</html>
