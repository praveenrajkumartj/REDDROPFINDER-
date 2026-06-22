<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="REDDROP Finder - Connect blood donors with patients in emergency. High-tech blood matching.">
    <title>REDDROP Finder | Next-Gen Life Saving</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <!-- AOS Animations -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/opening-animation.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;700;900&display=swap" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="landing-page">

<!-- 3D Interactive Design Elements -->
<div class="mouse-glow" id="mouseGlow"></div>
<div id="particle-container"></div>

<!-- Cinematic Opening Overlay -->
<div id="opening-animation-wrap">
    <div class="opening-content">
        <div class="opening-logo-icon">
            <i class="fas fa-drop"></i>
            <!-- Falling/Glowing Drop SVG for premium feel -->
            <svg width="60" height="80" viewBox="0 0 30 40" fill="none" xmlns="http://www.w3.org/2000/svg" style="margin-bottom: -15px;">
                <path d="M15 0C15 0 0 17.5 0 25C0 33.2843 6.71573 40 15 40C23.2843 40 30 33.2843 30 25C30 17.5 15 0 15 0Z" fill="#e63946">
                    <animate attributeName="fill" values="#e63946;#ff4d6d;#e63946" dur="2s" repeatCount="indefinite" />
                </path>
            </svg>
        </div>
        <h1 class="opening-title">REDDROPFINDER</h1>
        <p class="opening-tagline">Saving Lives, One Drop at a Time</p>
    </div>
    <div class="paper-overlay">
        <div class="tear-panel tear-panel-left"></div>
        <div class="tear-panel tear-panel-right"></div>
    </div>
</div>

<!-- =========== NAVIGATION =========== -->
<nav class="navbar navbar-expand-lg navbar-custom fixed-top">
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/search-donor">Donors</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/blood-camps">Camps</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/impact">Impact</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/support/about">About</a></li>
                <sec:authorize access="isAnonymous()">
                   <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login">Sign In</a></li>
                   <li class="nav-item"><a class="nav-link btn-nav-join" href="${pageContext.request.contextPath}/register">Join Now</a></li>
                </sec:authorize>
                <sec:authorize access="isAuthenticated()">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle"></i> <sec:authentication property="name"/>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg">
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
                            </li>
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

<!-- =========== VIDEO HERO SECTION =========== -->
<section class="hero-video-wrapper">
    <video class="hero-video-bg" autoplay muted loop playsinline poster="${pageContext.request.contextPath}/images/video_poster_reddrop.png">
        <source src="https://videos.pexels.com/video-files/3327157/3327157-uhd_2560_1440_24fps.mp4" type="video/mp4">
        Your browser does not support the video tag.
    </video>
    <div class="hero-overlay"></div>
    <div class="container hero-video-content">
        <div class="floating-drop-icon">
            <i class="fas fa-tint"></i>
        </div>
        <h1 class="hero-video-title">
            Be the Reason Someone Gets a <br>
            <span class="highlight-red">Second Chance</span> at Life
        </h1>
        <p class="hero-video-subtitle">
            Your one donation can save up to three lives. 
            Join our digital blood donor network and help patients find life-saving blood instantly.
        </p>
        <div class="hero-cta-group">
            <a href="${pageContext.request.contextPath}/search-donor" class="btn-video-primary">
                Find Blood Donors <i class="fas fa-search ms-2"></i>
            </a>
            <a href="${pageContext.request.contextPath}/register" class="btn-video-secondary">
                Become a Hero Donor <i class="fas fa-heart ms-2"></i>
            </a>
        </div>
    </div>
</section>

<!-- =========== HERO SECTION =========== -->
<section class="hero-section">
    <div class="tech-blob" style="top: -10%; left: -5%;"></div>
    <div class="container hero-content">
        <div class="row align-items-center">
            <div class="col-lg-7" data-aos="fade-right">
                <span class="badge-custom">Next-Gen Patient Matching</span>
                <h1 class="hero-title">
                    Every Drop is a <br>
                    <span class="text-gradient">Digital Miracle</span>
                </h1>
                <p class="hero-subtitle">
                    Our platform uses smart compatible matching to connect patients with local heroes in milliseconds. Precision healthcare for emergency needs.
                </p>
                <div class="search-widget-modern mt-4">
                    <form action="${pageContext.request.contextPath}/search-donor" method="get" class="row g-2 align-items-center">
                        <div class="col-md-5 col-12">
                            <div class="search-input-group">
                                 <i class="fas fa-tint text-primary ms-3"></i>
                                 <select name="bloodGroup" required class="search-select">
                                     <option value="" disabled selected>Blood Group</option>
                                     <option value="A+">A+</option>
                                     <option value="A-">A-</option>
                                     <option value="B+">B+</option>
                                     <option value="B-">B-</option>
                                     <option value="O+">O+</option>
                                     <option value="O-">O-</option>
                                     <option value="AB+">AB+</option>
                                     <option value="AB-">AB-</option>
                                 </select>
                            </div>
                        </div>
                        <div class="col-md-4 col-12">
                            <div class="search-input-group">
                                 <i class="fas fa-location-dot text-primary ms-3"></i>
                                 <input type="text" name="city" placeholder="Enter City" class="search-control">
                            </div>
                        </div>
                        <div class="col-md-3 col-12">
                            <button type="submit" class="btn-search-hero w-100 py-3">
                                <i class="fas fa-search me-2"></i> Find
                            </button>
                        </div>
                    </form>
                </div>
                
                <div class="mt-5 d-flex gap-4 align-items-center">
                    <div class="hero-brief-stat">
                        <h4 class="mb-0 fw-800">24/7</h4>
                        <small class="text-muted">Emergency Ops</small>
                    </div>
                    <div style="width: 1px; height: 30px; background: #E2E8F0;"></div>
                    <div class="hero-brief-stat">
                        <h4 class="mb-0 fw-800">
                            <c:choose>
                                <c:when test="${totalDonors >= 1000}">
                                    <fmt:formatNumber value="${totalDonors / 1000}" maxFractionDigits="1"/>k+
                                </c:when>
                                <c:otherwise>${totalDonors}</c:otherwise>
                            </c:choose>
                        </h4>
                        <small class="text-muted">Verified Heroes</small>
                    </div>
                </div>
            </div>
            
            <!-- NEW: Animated Tech Symbol -->
            <div class="col-lg-5 d-none d-lg-flex justify-content-center" data-aos="zoom-in" data-aos-delay="200">
                <div class="hero-visual">
                    <div class="blood-drop-container">
                        <div class="blood-drop-ring"></div>
                        <div class="blood-drop-ring"></div>
                        <div class="blood-drop-ring"></div>
                        <div class="blood-drop-icon">
                            <i class="fas fa-tint"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- =========== EMERGENCY SEARCH =========== -->
<section class="search-section-wrapper py-5">
    <div class="container">
        <div class="search-card-new" data-aos="fade-up">
            <div class="row g-4 align-items-center">
                <div class="col-lg-3">
                    <h3 class="mb-2"><i class="fas fa-bolt text-warning me-2"></i>Rapid Scan</h3>
                    <p class="text-muted small mb-0">Select blood type and location to scan for active donors nearby.</p>
                </div>
                <div class="col-lg-9">
                    <form action="${pageContext.request.contextPath}/search-donor" method="get" class="row g-3 align-items-center">
                        <div class="col-md-5">
                            <select class="form-select form-control-tech" name="bloodGroup" required>
                                <option value="">Select Blood Group</option>
                                <option value="A+">A+</option>
                                <option value="A-">A-</option>
                                <option value="B+">B+</option>
                                <option value="B-">B-</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB-</option>
                                <option value="O+">O+</option>
                                <option value="O-">O-</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <input type="text" class="form-control-tech" name="city" placeholder="Enter City (e.g. New York)">
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn-hero-primary w-100">Find Now</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- =========== FEATURES =========== -->
<section class="pb-5" style="background: var(--bg-soft);">
    <div class="container py-5">
        <div class="text-center section-header" data-aos="fade-up">
            <span class="badge-custom">Intelligence</span>
            <h2 class="section-title h1">Engineered to Save Lives</h2>
            <p class="text-muted">Our smart ecosystem ensures reliability when it matters most.</p>
        </div>
        <div class="row g-4 pt-4">
            <div class="col-md-3" data-aos="fade-up">
                <div class="glass-card tech-card-3d">
                    <div class="card-icon"><i class="fas fa-map-location-dot"></i></div>
                    <h3>Geo-Sync</h3>
                    <p class="text-muted">Automatically locates the nearest available donors to minimize transportation lag in critical moments.</p>
                </div>
            </div>
            <div class="col-md-3" data-aos="fade-up" data-aos-delay="100">
                <div class="glass-card tech-card-3d">
                    <div class="card-icon"><i class="fas fa-shield-virus"></i></div>
                    <h3>Verified Tech</h3>
                    <p class="text-muted">Every donor profile is medical-grade verified through our partnership with clinical laboratories.</p>
                </div>
            </div>
            <div class="col-md-3" data-aos="fade-up" data-aos-delay="200">
                <div class="glass-card tech-card-3d">
                    <div class="card-icon"><i class="fas fa-clock-rotate-left"></i></div>
                    <h3>Real-Time</h3>
                    <p class="text-muted">Our live ticker and push notifications system keeps hospitals updated on stock levels instantly.</p>
                </div>
            </div>
            <div class="col-md-3" data-aos="fade-up" data-aos-delay="300">
                <div class="glass-card tech-card-3d">
                    <div class="card-icon"><i class="fas fa-truck-pickup"></i></div>
                    <h3>Volunteer Shield</h3>
                    <p class="text-muted">Direct transport network for donors, ensuring blood arrives at the hospital in record time via our volunteer force.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- =========== IMPACT =========== -->
<section class="impact-section overflow-hidden">
    <div class="tech-blob" style="bottom: -15%; right: -10%; background: radial-gradient(circle, rgba(0, 163, 255, 0.15) 0%, transparent 70%);"></div>
    <div class="container">
        <div class="row align-items-center g-5">
            <div class="col-lg-6" data-aos="fade-right">
                <div class="impact-visual">
                    <img src="${pageContext.request.contextPath}/images/unity_impact_vibrant_1773154177925.png" alt="Community">
                </div>
            </div>
            <div class="col-lg-6" data-aos="fade-left">
                <span class="badge-custom" style="background: rgba(0, 163, 255, 0.1); color: var(--accent);">Real Impact</span>
                <h2 class="h1 fw-900 mb-4">Building a Global<br><span class="highlight-red">Safety Network</span></h2>
                <p class="text-muted mb-5">By bridging the gap between donors and patients through technology, we've increased clinical responses by 45%. Your contribution is quantifiable data of hope.</p>
                
                <div class="row g-4">
                    <div class="col-6">
                        <div class="stat-box border rounded-4 bg-white shadow-sm">
                            <div class="stat-number">
                                <c:choose>
                                    <c:when test="${totalDonors >= 1000}">
                                        <fmt:formatNumber value="${totalDonors / 1000}" maxFractionDigits="1"/>k+
                                    </c:when>
                                    <c:otherwise>${totalDonors}</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="stat-label">Active Heroes</div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="stat-box border rounded-4 bg-white shadow-sm">
                            <div class="stat-number">
                                <c:choose>
                                    <c:when test="${totalDonations >= 1000}">
                                        <fmt:formatNumber value="${totalDonations / 1000}" maxFractionDigits="1"/>k
                                    </c:when>
                                    <c:otherwise>${totalDonations}</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="stat-label">Success Swaps</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- =========== EDUCATION SECTIONS =========== -->
<section class="py-5 overflow-hidden">
    <div class="container py-5">
        <!-- Section 1: Mobile Clinics -->
        <div class="row align-items-center g-5 mb-5 pb-5">
            <div class="col-lg-6 order-lg-2" data-aos="fade-left">
                <div class="education-image-wrapper p-3 bg-white rounded-5 shadow-lg">
                    <img src="${pageContext.request.contextPath}/images/high_tech_blood_mobile_1773306933488.png" alt="High-Tech Mobile Clinic" class="img-fluid rounded-4 shadow-sm" style="width: 100%; object-fit: cover; height: 400px;">
                </div>
            </div>
            <div class="col-lg-6 order-lg-1" data-aos="fade-right">
                <span class="badge-custom mb-3">Community Bridge</span>
                <h2 class="display-6 fw-900 mb-4">Advanced <span class="highlight-red">Mobile Clinics</span></h2>
                <p class="lead text-muted mb-4">Rather than going to the hospital, we bring the clinical infrastructure directly to your doorstep.</p>
                <p class="text-secondary opacity-75 mb-4">REDDROP dispatches next-gen mobile units to campuses and communities. We partner with certified blood banks and expert medical staff to ensure a seamless, high-tech experience in a clean, professional environment. Just 20 minutes to save three lives.</p>
                <ul class="list-unstyled d-flex flex-column gap-3">
                    <li class="d-flex align-items-center gap-3"><i class="fas fa-check-circle text-success fs-5"></i> <span class="fw-bold opacity-75">Certified Medical Staff</span></li>
                    <li class="d-flex align-items-center gap-3"><i class="fas fa-check-circle text-success fs-5"></i> <span class="fw-bold opacity-75">Zero Travel Logistics</span></li>
                    <li class="d-flex align-items-center gap-3"><i class="fas fa-check-circle text-success fs-5"></i> <span class="fw-bold opacity-75">High-Precision Safety Lab</span></li>
                </ul>
            </div>
        </div>

        <!-- Section 2: Experience -->
        <div class="row align-items-center g-5 pt-lg-5 mt-lg-5">
            <div class="col-lg-6" data-aos="fade-right">
                <div class="education-image-wrapper p-3 bg-white rounded-5 shadow-lg">
                    <img src="${pageContext.request.contextPath}/images/welcoming_donation_center_1773306948562.png" alt="Modern Donation Center" class="img-fluid rounded-4 shadow-sm" style="width: 100%; object-fit: cover; height: 400px;">
                </div>
            </div>
            <div class="col-lg-6" data-aos="fade-left">
                <span class="badge-custom mb-3" style="background: rgba(0, 163, 255, 0.1); color: var(--accent);">Premium Care</span>
                <h2 class="display-6 fw-900 mb-4">The <span class="highlight-red">Hero Experience</span></h2>
                <p class="lead text-muted mb-4">We believe life-saving should feel as rewarding as the impact it creates.</p>
                <p class="text-secondary opacity-75 mb-4">Our camps aren't just clinical events—they are thematic celebrations. We ensure every donor feels special through curated environments, focus music, and real-time digital impact tracking. We handle every detail, from pre-camp motivation to blissful recovery, ensuring you feel a sense of pride with every pulse.</p>
                <div class="d-flex flex-wrap gap-4 mt-4">
                    <div class="text-center p-3 rounded-4 bg-white border shadow-sm" style="min-width: 120px;">
                        <i class="fas fa-music text-primary mb-2 fs-3"></i>
                        <p class="small fw-800 mb-0 opacity-75">Curated Music</p>
                    </div>
                    <div class="text-center p-3 rounded-4 bg-white border shadow-sm" style="min-width: 120px;">
                        <i class="fas fa-magic text-accent mb-2 fs-3"></i>
                        <p class="small fw-800 mb-0 opacity-75">Thematic Moods</p>
                    </div>
                    <div class="text-center p-3 rounded-4 bg-white border shadow-sm" style="min-width: 120px;">
                        <i class="fas fa- ट्रॉफी text-warning mb-2 fs-3"></i>
                        <p class="small fw-800 mb-0 opacity-75">Instant Awards</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- =========== SUCCESS STORIES =========== -->
<section class="py-5 overflow-hidden">
    <div class="container py-5" data-aos="fade-up">
        <div class="row g-0 rounded-5 overflow-hidden shadow-lg border">
            <!-- Story Info (Left) -->
            <div class="col-lg-5 bg-story-red text-white p-5 d-flex flex-column justify-content-center">
                <div class="ps-lg-5">
                    <span class="text-uppercase fw-800 tracking-wider mb-4 d-block" style="font-size: 0.9rem; letter-spacing: 4px;">Stories</span>
                    <div class="h-line-white mb-4"></div>
                    
                    <div id="storyContentCarousel" class="carousel slide">
                        <div class="carousel-inner">
                            <!-- Story 1: Officer Sarah -->
                            <div class="carousel-item active">
                                <h2 class="display-4 fw-900 mb-3">Officer Sarah</h2>
                                <p class="lead opacity-90 mb-5">"Blood donation is the ultimate way to serve the community beyond the badge. REDDROP makes it feel seamless."</p>
                            </div>
                            <!-- Story 2: The Millers -->
                            <div class="carousel-item">
                                <h2 class="display-4 fw-900 mb-3">The Miller Family</h2>
                                <p class="lead opacity-90 mb-5">"When our daughter needed a rare type, REDDROP matched us with a donor in minutes. They saved our family."</p>
                            </div>
                            <!-- Story 3: Dr. James -->
                            <div class="carousel-item">
                                <h2 class="display-4 fw-900 mb-3">Medical Director James</h2>
                                <p class="lead opacity-90 mb-5">"The integration of engineering and clinical needs has revolutionized how my hospital handles emergencies."</p>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex align-items-center gap-4 mt-5">
                        <a href="${pageContext.request.contextPath}/support/help" class="btn btn-story-all">See all Stories</a>
                        <div class="d-flex gap-3">
                            <button class="btn btn-outline-light rounded-circle p-0 d-flex align-items-center justify-content-center" style="width: 45px; height: 45px;" onclick="syncStoryCarousel('prev')">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <button class="btn btn-outline-light rounded-circle p-0 d-flex align-items-center justify-content-center" style="width: 45px; height: 45px;" onclick="syncStoryCarousel('next')">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Story Visual (Right) -->
            <div class="col-lg-7">
                <div id="storyVisualCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="8000" data-bs-pause="hover">
                    <div class="carousel-inner">
                        <div class="carousel-item active">
                            <div class="story-img-wrapper">
                                <img src="${pageContext.request.contextPath}/images/officer_sarah_story_1773308251281.png" class="d-block w-100 story-img" alt="Officer Sarah">
                                <div class="play-button-overlay" onclick="playStoryVideo('https://www.youtube.com/embed/ZHPiLGRFoLs')">
                                    <i class="fas fa-play"></i>
                                </div>
                            </div>
                        </div>
                        <div class="carousel-item">
                            <div class="story-img-wrapper">
                                <img src="${pageContext.request.contextPath}/images/life_saved_family_story_1773308269990.png" class="d-block w-100 story-img" alt="The Miller Family">
                                <div class="play-button-overlay" onclick="playStoryVideo('https://www.youtube.com/embed/7zrR2mCWWno')">
                                    <i class="fas fa-play"></i>
                                </div>
                            </div>
                        </div>
                        <div class="carousel-item">
                            <div class="story-img-wrapper">
                                <img src="${pageContext.request.contextPath}/images/medical_officer_james_story_1773308286607.png" class="d-block w-100 story-img" alt="Dr James">
                                <div class="play-button-overlay" onclick="playStoryVideo('https://www.youtube.com/embed/_s3c1saahFM')">
                                    <i class="fas fa-play"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Video Modal -->
<div class="modal fade" id="videoModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content border-0 bg-transparent">
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            <div class="modal-body p-0">
                <div class="ratio ratio-16x9 shadow-lg rounded-5 overflow-hidden">
                    <iframe id="storyVideoFrame" src="" allowfullscreen allow="autoplay"></iframe>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- =========== CAMPS CTA =========== -->
<section class="py-5">
    <div class="container py-5">
        <div class="p-5 p-lg-5 rounded-5 shadow-lg position-relative overflow-hidden" 
             style="background: linear-gradient(rgba(15, 23, 42, 0.8), rgba(15, 23, 42, 0.9)), url('${pageContext.request.contextPath}/images/blood_camps_modern_1773154197307.png'); background-size: cover; background-position: center;">
            <div class="row align-items-center py-lg-4 text-white position-relative" style="z-index:10;">
                <div class="col-lg-8">
                    <h2 class="display-5 fw-800 mb-3">Join Local Blood Drives</h2>
                    <p class="lead opacity-75 mb-0">Our next-gen mobile clinics are visiting cities this week. Stay updated and participate near you.</p>
                </div>
                <div class="col-lg-4 text-lg-end mt-4 mt-lg-0">
                    <a href="${pageContext.request.contextPath}/blood-camps" class="btn btn-light btn-lg px-5 py-3 rounded-4 fw-bold shadow-lg">
                        View Schedule
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

<!-- JS Script -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
<script>
    AOS.init({ duration: 800, once: true });
    
    window.addEventListener('scroll', () => {
        const nav = document.querySelector('.navbar-custom');
        if (window.scrollY > 50) nav.classList.add('navbar-scrolled');
        else nav.classList.remove('navbar-scrolled');
    });

    // Story Carousel Sync
    document.addEventListener('DOMContentLoaded', function () {
        const visualCarouselEl = document.getElementById('storyVisualCarousel');
        if (visualCarouselEl) {
            visualCarouselEl.addEventListener('slide.bs.carousel', function (e) {
                const contentCarousel = bootstrap.Carousel.getOrCreateInstance('#storyContentCarousel');
                contentCarousel.to(e.to);
            });
        }
    });

    function syncStoryCarousel(dir) {
        const visual = bootstrap.Carousel.getOrCreateInstance('#storyVisualCarousel');
        if (dir === 'next') { visual.next(); }
        else { visual.prev(); }
    }

    // Video Player Logic
    function playStoryVideo(url) {
        const frame = document.getElementById('storyVideoFrame');
        const modal = new bootstrap.Modal(document.getElementById('videoModal'));
        frame.src = url + "?autoplay=1";
        modal.show();
        
        document.getElementById('videoModal').addEventListener('hidden.bs.modal', function () {
            frame.src = "";
        });
    }

    // 3D Motion & Particle Logic
    const glow = document.getElementById('mouseGlow');
    const heroContent = document.querySelector('.hero-video-content');
    const particleContainer = document.getElementById('particle-container');

    // Create Nano Particles for 3D Depth
    for (let i = 0; i < 20; i++) {
        const p = document.createElement('div');
        p.className = 'nano-particle';
        const size = Math.random() * 8 + 4;
        p.style.width = `${size}px`;
        p.style.height = `${size}px`;
        p.style.left = `${Math.random() * 100}vw`;
        p.style.top = `${Math.random() * 100}vh`;
        p.style.animationDelay = `${Math.random() * 5}s`;
        p.style.opacity = Math.random() * 0.4 + 0.1;
        particleContainer.appendChild(p);
    }

    document.addEventListener('mousemove', (e) => {
        // Update Mouse Glow
        if (glow) {
            glow.style.left = `${e.clientX}px`;
            glow.style.top = `${e.clientY}px`;
        }

        // Update Hero 3D Motion
        if (heroContent) {
            const xAxis = (window.innerWidth / 2 - e.pageX) / 20;
            const yAxis = (window.innerHeight / 2 - e.pageY) / 20;
            heroContent.style.transform = `rotateY(${xAxis}deg) rotateX(${-yAxis}deg)`;
        }
    });

    if (heroContent) {
        document.addEventListener('mouseleave', () => {
            heroContent.style.transition = "all 0.8s cubic-bezier(0.23, 1, 0.32, 1)";
            heroContent.style.transform = `rotateY(0deg) rotateX(0deg)`;
        });
        document.addEventListener('mouseenter', () => {
            heroContent.style.transition = "none";
        });
    }

    // Opening Animation Controller
    window.addEventListener('DOMContentLoaded', () => {
        const wrap = document.getElementById('opening-animation-wrap');
        
        // Phase 1: Show for 1 second
        setTimeout(() => {
            // Phase 2: Trigger Tear
            wrap.classList.add('active');
            
            // Phase 3: Remove from DOM after animation finishes (2s + buffer)
            setTimeout(() => {
                wrap.classList.add('finished');
            }, 2500);
        }, 1000);
    });
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/vanilla-tilt/1.8.0/vanilla-tilt.min.js"></script>
<script>
    VanillaTilt.init(document.querySelectorAll(".tech-card-3d"), {
        max: 15,
        speed: 400,
        glare: true,
        "max-glare": 0.5,
    });
</script>
</body>
</html>









