<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Impact Dashboard - REDDROP Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .impact-hero {
            background: linear-gradient(135deg, #1d3557 0%, #0d1b2a 100%);
            padding: 5rem 0;
            position: relative;
            overflow: hidden;
        }
        .impact-hero::after {
            content: '';
            position: absolute;
            top: 0; right: 0;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(230,57,70,0.1) 0%, transparent 70%);
        }
        .nav-link-custom {
            color: #1d3557 !important;
            font-weight: 600;
            text-decoration: none !important;
            transition: all 0.3s ease;
        }
        .nav-link-custom:hover {
            color: #e63946 !important;
        }
        .stat-card-new {
            background: white;
            padding: 2rem;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            border: 1px solid rgba(0,0,0,0.02);
            text-align: center;
            height: 100%;
            transition: transform 0.3s ease;
        }
        .stat-card-new:hover {
            transform: translateY(-5px);
        }
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

<!-- Hero Section -->
<div class="impact-hero">
    <div class="container text-center">
        <div class="mb-3">
            <span style="background:rgba(230,57,70,0.15); color:#ff6b7a; padding:0.5rem 1.2rem; border-radius:100px; font-weight:800; font-size:0.8rem; text-transform:uppercase; letter-spacing:1px;">
                <i class="fas fa-heart-pulse me-2"></i>Live Platform Statistics
            </span>
        </div>
        <h1 style="font-size:3.5rem; font-weight:900; color:white; margin-bottom:1.5rem;">
            Our Impact on <span style="color:#e63946;">Saving Lives</span>
        </h1>
        <p style="color:rgba(255,255,255,0.7); font-size:1.2rem; max-width:700px; margin:0 auto;">
            Monitoring our network's heartbeat. Every donation, every request, and every donor contributes to a safer world.
        </p>
    </div>
</div>

<!-- Main Stats Counter -->
<section class="py-5">
    <div class="container">
        <div class="row g-4">
            <div class="col-md-3">
                <div class="stat-card-new">
                    <div style="width:60px; height:60px; background:rgba(230,57,70,0.1); color:#e63946; border-radius:15px; display:flex; align-items:center; justify-content:center; margin:0 auto 1.5rem; font-size:1.5rem;">
                        <i class="fas fa-users"></i>
                    </div>
                    <h2 class="counter-animate" style="font-weight:900; color:#1d3557;" data-target="${totalDonors}">${totalDonors}</h2>
                    <p class="text-secondary fw-bold text-uppercase small">Total Donors</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card-new">
                    <div style="width:60px; height:60px; background:rgba(45, 198, 83, 0.1); color:#2dc653; border-radius:15px; display:flex; align-items:center; justify-content:center; margin:0 auto 1.5rem; font-size:1.5rem;">
                        <i class="fas fa-hand-holding-heart"></i>
                    </div>
                    <h2 class="counter-animate" style="font-weight:900; color:#1d3557;" data-target="${totalDonations * 3}">${totalDonations * 3}</h2>
                    <p class="text-secondary fw-bold text-uppercase small">Lives Saved</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card-new">
                    <div style="width:60px; height:60px; background:rgba(0, 163, 255, 0.1); color:#00A3FF; border-radius:15px; display:flex; align-items:center; justify-content:center; margin:0 auto 1.5rem; font-size:1.5rem;">
                        <i class="fas fa-tint"></i>
                    </div>
                    <h2 class="counter-animate" style="font-weight:900; color:#1d3557;" data-target="${totalDonations}">${totalDonations}</h2>
                    <p class="text-secondary fw-bold text-uppercase small">Total Donations</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card-new">
                    <div style="width:60px; height:60px; background:rgba(244, 162, 97, 0.1); color:#f4a261; border-radius:15px; display:flex; align-items:center; justify-content:center; margin:0 auto 1.5rem; font-size:1.5rem;">
                        <i class="fas fa-hospital"></i>
                    </div>
                    <h2 class="counter-animate" style="font-weight:900; color:#1d3557;" data-target="${totalCamps}">${totalCamps}</h2>
                    <p class="text-secondary fw-bold text-uppercase small">Blood Camps</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Detailed Data Section -->
<section class="py-5" style="background:white;">
    <div class="container">
        <div class="row g-5">
            <!-- Recent Donations Table -->
            <div class="col-lg-8">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 style="font-weight:800; color:#1d3557;">
                        <i class="fas fa-history me-2 text-danger"></i>Recent Successful Donations
                    </h3>
                </div>
                <div class="card shadow-sm border-0" style="border-radius:20px; overflow:hidden;">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0" style="vertical-align: middle;">
                            <thead style="background:#F8FAFC;">
                                <tr>
                                    <th class="ps-4 py-3">Donor</th>
                                    <th class="py-3">Hospital</th>
                                    <th class="py-3 text-center">Group</th>
                                    <th class="py-3">Date</th>
                                    <th class="pe-4 py-3 text-end">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty recentDonations}">
                                        <c:forEach var="donation" items="${recentDonations}">
                                            <tr>
                                                <td class="ps-4 py-3 fw-bold">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <div style="width:32px; height:32px; border-radius:50%; background:#f1f5f9; display:flex; align-items:center; justify-content:center; font-size:0.8rem;">
                                                            <i class="fas fa-user text-muted"></i>
                                                        </div>
                                                        ${donation.donor.user.name}
                                                    </div>
                                                </td>
                                                <td class="py-3 text-muted">${donation.hospitalName}</td>
                                                <td class="py-3 text-center">
                                                    <span class="badge bg-danger-subtle text-danger" style="font-size:0.8rem; padding:0.4rem 0.8rem;">
                                                        <c:choose>
                                                            <c:when test="${not empty donation.bloodGroup}">${donation.bloodGroup}</c:when>
                                                            <c:otherwise>${donation.donor.bloodGroup}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td class="py-3 small text-muted">${donation.donationDate}</td>
                                                <td class="pe-4 py-3 text-end">
                                                    <span class="badge bg-success-subtle text-success rounded-pill px-3">
                                                        <i class="fas fa-check-circle me-1"></i>Verified
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="py-5 text-center text-muted">
                                                <div class="mb-2"><i class="fas fa-database fa-3x opacity-25"></i></div>
                                                No donation records found yet.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Side Cards -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm mb-4" style="border-radius:20px; background:linear-gradient(135deg, #e63946, #c1121f); color:white;">
                    <div class="card-body p-4">
                        <h4 style="font-weight:800;">Urgent Need</h4>
                        <p class="small opacity-75">Current pending requests needing immediate attention.</p>
                        <div class="display-4 fw-bold mb-2">${pendingRequests}</div>
                        <a href="${pageContext.request.contextPath}/search-donor" class="btn btn-light w-100 fw-bold" style="color:#e63946; border-radius:12px;">
                            Help Now
                        </a>
                    </div>
                </div>

                <div class="card border-0 shadow-sm" style="border-radius:20px;">
                    <div class="card-body p-4">
                        <h5 style="font-weight:800; color:#1d3557;" class="mb-4">Engagement</h5>
                        <div class="mb-3">
                            <label class="d-flex justify-content-between small fw-bold mb-1">
                                <span>Donation Target</span>
                                <span>85%</span>
                            </label>
                            <div class="progress" style="height:8px; border-radius:10px;">
                                <div class="progress-bar bg-danger" style="width: 85%"></div>
                            </div>
                        </div>
                        <div class="mb-0">
                            <label class="d-flex justify-content-between small fw-bold mb-1">
                                <span>Volunteer Response</span>
                                <span>92%</span>
                            </label>
                            <div class="progress" style="height:8px; border-radius:10px;">
                                <div class="progress-bar bg-success" style="width: 92%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Call to Action -->
<section class="py-5" style="background:#F8FAFC;">
    <div class="container text-center py-4">
        <h2 style="font-weight:900; color:#1d3557; margin-bottom:1rem;">Be Part of the Impact</h2>
        <p class="text-muted mb-4 mx-auto" style="max-width:600px;">Every single donation has the potential to save up to three lives. Join our mission as a donor today.</p>
        <div class="d-flex gap-3 justify-content-center">
            <a href="${pageContext.request.contextPath}/register" class="btn btn-danger btn-lg px-5 fw-bold" style="border-radius:12px; background:#e63946; border:none; padding:1rem 2.5rem;">
                Register to Donate
            </a>
            <a href="${pageContext.request.contextPath}/patient/request-blood" class="btn btn-outline-dark btn-lg px-5 fw-bold" style="border-radius:12px; padding:1rem 2.5rem;">
                Request Blood
            </a>
        </div>
    </div>
</section>
<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>AOS.init({ duration: 800, once: true });</script>
</body>
</html>
