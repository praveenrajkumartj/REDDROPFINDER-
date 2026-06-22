<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title} - REDDROP Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .info-hero { background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); padding: 6rem 0; color: white; margin-bottom: 4rem; position: relative; overflow: hidden; }
        .info-hero::after { content: ''; position: absolute; top: -50%; right: -20%; width: 500px; height: 500px; background: radial-gradient(circle, rgba(230,57,70,0.1) 0%, transparent 70%); }
        .content-card { background: white; border-radius: 24px; padding: 3rem; box-shadow: 0 10px 30px rgba(0,0,0,0.02); border: 1px solid #f1f5f9; min-height: 400px; line-height: 1.8; }
        .info-section h3 { font-weight: 800; color: #1d3557; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 12px; }
        .info-section p { color: #64748b; margin-bottom: 1.5rem; }
        .info-sidebar { position: sticky; top: 120px; }
        .side-link { display: flex; align-items: center; gap: 12px; padding: 1rem 1.5rem; border-radius: 12px; color: #64748b; text-decoration: none; font-weight: 600; transition: all 0.3s ease; border: 1px solid transparent; }
        .side-link:hover { background: #f8fafc; color: var(--primary); }
        .side-link.active { background: rgba(230,57,70,0.05); color: var(--primary); border-color: rgba(230,57,70,0.1); }
        @keyframes pulse-badge {
            0% { transform: scale(1); filter: drop-shadow(0 0 0 rgba(255, 193, 7, 0)); }
            50% { transform: scale(1.1); filter: drop-shadow(0 0 20px rgba(255, 193, 7, 0.5)); }
            100% { transform: scale(1); filter: drop-shadow(0 0 0 rgba(255, 193, 7, 0)); }
        }
        .pulse-badge { animation: pulse-badge 2s infinite ease-in-out; }
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
        <div class="ms-auto d-flex gap-3 align-items-center">
            <a href="${pageContext.request.contextPath}/" class="nav-link-custom text-decoration-none" style="font-weight:600; color:#1d3557;"><i class="fas fa-home me-1"></i>Home</a>
            <sec:authorize access="isAuthenticated()">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-danger btn-sm px-4 rounded-pill fw-bold">Dashboard</a>
            </sec:authorize>
            <sec:authorize access="isAnonymous()">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-danger btn-sm px-4 rounded-pill fw-bold">Sign In</a>
            </sec:authorize>
        </div>
    </div>
</nav>

<div class="info-hero">
    <div class="container text-center" data-aos="fade-up">
        <span class="badge-custom">Support Registry</span>
        <h1 style="font-size: 3.5rem; font-weight: 900;">${title}</h1>
        <p class="opacity-75 lead mx-auto" style="max-width: 600px;">Providing clarity and guidance within the REDDROP high-tech safety network.</p>
    </div>
</div>

<div class="container pb-5">
    <div class="row g-5">
        <div class="col-lg-3 d-none d-lg-block">
            <div class="info-sidebar">
                <a href="${pageContext.request.contextPath}/support/help" class="side-link ${type == 'help' ? 'active' : ''}"><i class="fas fa-question-circle"></i> Help Center</a>
                <a href="${pageContext.request.contextPath}/support/about" class="side-link ${type == 'about' ? 'active' : ''}"><i class="fas fa-info-circle"></i> About Us</a>
                <a href="${pageContext.request.contextPath}/support/security" class="side-link ${type == 'security' ? 'active' : ''}"><i class="fas fa-shield-virus"></i> Security Info</a>
                <a href="${pageContext.request.contextPath}/support/api" class="side-link ${type == 'api' ? 'active' : ''}"><i class="fas fa-code"></i> API Access</a>
                <a href="${pageContext.request.contextPath}/support/verify" class="side-link ${type == 'verify' ? 'active' : ''}"><i class="fas fa-award"></i> Badges & Verification</a>
                <a href="${pageContext.request.contextPath}/support/privacy" class="side-link ${type == 'privacy' ? 'active' : ''}"><i class="fas fa-user-shield"></i> Privacy Policy</a>
                <a href="${pageContext.request.contextPath}/support/terms" class="side-link ${type == 'terms' ? 'active' : ''}"><i class="fas fa-file-contract"></i> Terms of Service</a>
                <a href="${pageContext.request.contextPath}/support/contact" class="side-link ${type == 'contact' ? 'active' : ''}"><i class="fas fa-envelope"></i> Contact Us</a>
            </div>
        </div>
        <div class="col-lg-9">
            <div class="content-card" data-aos="fade-up">
                <c:choose>
                    <c:when test="${type == 'about'}">
                        <section class="info-section">
                            <h2 class="fw-black mb-4"><i class="fas fa-info-circle text-danger me-2"></i>Mission Control: Our Vision</h2>
                            <p class="lead text-muted">REDDROP Finder is more than just a blood donation platform; it is a high-speed biological logistics network dedicated to bridging the gap between life and loss. Founded on the principle of "Instant Altruism," we leverage cutting-edge technology to ensure that no patient ever has to wait for a matching blood group.</p>
                            
                            <hr class="my-5 opacity-10">

                            <div class="row g-4 mb-5">
                                <div class="col-md-6">
                                    <div class="card border-0 bg-light p-4 rounded-4 h-100">
                                        <h5 class="fw-bold text-danger"><i class="fas fa-heartbeat me-2"></i>Our Purpose</h5>
                                        <p class="small text-muted">To digitize the emergency blood supply chain, making it transparent, reliable, and accessible to every hospital and individual in real-time. We believe that technology should serve humanity's most basic need—the breath of life.</p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card border-0 bg-light p-4 rounded-4 h-100">
                                        <h5 class="fw-bold text-primary"><i class="fas fa-microchip me-2"></i>Our Engine</h5>
                                        <p class="small text-muted">Powered by our proprietary RTGD (Real-Time Geographic Dispatch) algorithm, we connect donors with patients based on precise biological compatibility and millisecond-accurate proximity data.</p>
                                    </div>
                                </div>
                            </div>

                            <h4 class="fw-bold mb-4">Core Principles of REDDROP</h4>
                            <div class="mb-5">
                                <div class="d-flex gap-4 mb-4" data-aos="fade-left">
                                    <div class="flex-shrink-0 bg-danger text-white rounded-circle d-flex align-items-center justify-content-center shadow-lg" style="width:40px; height:40px; font-weight:900;"><i class="fas fa-bolt"></i></div>
                                    <div>
                                        <h6 class="fw-bold mb-1">Zero-Latency Dispatch</h6>
                                        <p class="small text-muted mb-0">When seconds count, spreadsheets fail. Our automated pulse system broadcasts emergency needs to verified donors instantly, bypassing traditional bureaucratic delays.</p>
                                    </div>
                                </div>
                                <div class="d-flex gap-4 mb-4" data-aos="fade-left" data-aos-delay="100">
                                    <div class="flex-shrink-0 bg-danger text-white rounded-circle d-flex align-items-center justify-content-center shadow-lg" style="width:40px; height:40px; font-weight:900;"><i class="fas fa-user-shield"></i></div>
                                    <div>
                                        <h6 class="fw-bold mb-1">Sovereign Data Security</h6>
                                        <p class="small text-muted mb-0">Your biological profile is your most private asset. We protect it with banking-grade encryption and a strict zero-knowledge disclosure protocol.</p>
                                    </div>
                                </div>
                                <div class="d-flex gap-4 mb-4" data-aos="fade-left" data-aos-delay="200">
                                    <div class="flex-shrink-0 bg-danger text-white rounded-circle d-flex align-items-center justify-content-center shadow-lg" style="width:40px; height:40px; font-weight:900;"><i class="fas fa-hand-holding-heart"></i></div>
                                    <div>
                                        <h6 class="fw-bold mb-1">Pure Altruism</h6>
                                        <p class="small text-muted mb-0">We are a non-profit foundation. Our platform is free for donors and hospitals, ensuring that the gift of life remains untainted by commercial interests.</p>
                                    </div>
                                </div>
                            </div>

                            <div class="p-5 bg-dark text-white rounded-5 shadow-lg text-center">
                                <h4 class="fw-bold mb-3">Join the Global Pulse</h4>
                                <p class="opacity-75 mb-4">Over 50,000 donors have already joined our mission. Become a node in the world's most advanced emergency safety net today.</p>
                                <div class="d-flex justify-content-center gap-3">
                                    <a href="${pageContext.request.contextPath}/register" class="btn btn-danger px-4 py-2 rounded-pill fw-bold">Register as Donor</a>
                                    <a href="${pageContext.request.contextPath}/impact" class="btn btn-outline-light px-4 py-2 rounded-pill fw-bold">View Our Impact</a>
                                </div>
                            </div>
                        </section>
                    </c:when>

                    <c:when test="${type == 'help'}">
                        <section class="info-section">
                            <h2 class="fw-black mb-4"><i class="fas fa-life-ring text-danger me-2"></i>Global Help & Operations Center</h2>
                            <p class="lead text-muted">Welcome to the REDDROP Operations Command. This repository contains the complete procedural documentation for our distributed emergency network. Our platform is designed to minimize the "Chaos-to-Collection" window via automated logistics and real-time biological matching.</p>
                            
                            <hr class="my-5 opacity-10">

                            <!-- Operational Tiers -->
                            <h4 class="fw-bold mb-4">1. Emergency Response Tiers</h4>
                            <div class="row g-4 mb-5">
                                <div class="col-md-6">
                                    <div class="card border-0 bg-light p-4 rounded-4 h-100">
                                        <h5 class="fw-bold text-danger"><i class="fas fa-bolt me-2"></i>Tier 1: Critical Pulse</h5>
                                        <p class="small text-muted">Reserved for active surgeries, trauma cases, or rare blood group shortages where the window of survival is less than 4 hours. Requests in this tier are broadcasted with a "High Urgency" bypass to all donors within a 10km radius.</p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card border-0 bg-light p-4 rounded-4 h-100">
                                        <h5 class="fw-bold text-primary"><i class="fas fa-clock me-2"></i>Tier 2: Scheduled Recovery</h5>
                                        <p class="small text-muted">Standard replenishment requests for upcoming procedures or stable patients. These requests are visible on the public dashboard and dispatched to matching donors within 25km via standard notification channels.</p>
                                    </div>
                                </div>
                            </div>

                            <h4 class="fw-bold mb-4">2. The Donor Lifecycle: Step-by-Step</h4>
                            <div class="mb-5">
                                <div class="d-flex gap-4 mb-4" data-aos="fade-left">
                                    <div class="flex-shrink-0 bg-danger text-white rounded-circle d-flex align-items-center justify-content-center shadow-lg" style="width:40px; height:40px; font-weight:900;">1</div>
                                    <div>
                                        <h6 class="fw-bold mb-1">Registration & Bio-Verification</h6>
                                        <p class="small text-muted mb-0">Donors register with verified credentials. Our system checks your blood group history and previous donation timestamps to ensure biological safety compliance (15-day intervals).</p>
                                    </div>
                                </div>
                                <div class="d-flex gap-4 mb-4" data-aos="fade-left" data-aos-delay="100">
                                    <div class="flex-shrink-0 bg-danger text-white rounded-circle d-flex align-items-center justify-content-center shadow-lg" style="width:40px; height:40px; font-weight:900;">2</div>
                                    <div>
                                        <h6 class="fw-bold mb-1">Active Monitoring (Availability)</h6>
                                        <p class="small text-muted mb-0">By setting your status to "Available," you join the live RTGD (Real-Time Geographic Dispatch) pool. Our algorithms monitor your proximity to potential emergency nodes.</p>
                                    </div>
                                </div>
                                <div class="d-flex gap-4 mb-4" data-aos="fade-left" data-aos-delay="200">
                                    <div class="flex-shrink-0 bg-danger text-white rounded-circle d-flex align-items-center justify-content-center shadow-lg" style="width:40px; height:40px; font-weight:900;">3</div>
                                    <div>
                                        <h6 class="fw-bold mb-1">Pulse Acceptance & Handshake</h6>
                                        <p class="small text-muted mb-0">When you accept a request, a secure communication tunnel opens. You receive the hospital coordinates and the patient representative receives your ETA.</p>
                                    </div>
                                </div>
                                <div class="d-flex gap-4 mb-4" data-aos="fade-left" data-aos-delay="300">
                                    <div class="flex-shrink-0 bg-danger text-white rounded-circle d-flex align-items-center justify-content-center shadow-lg" style="width:40px; height:40px; font-weight:900;">4</div>
                                    <div>
                                        <h6 class="fw-bold mb-1">Donation & Ledger Update</h6>
                                        <p class="small text-muted mb-0">After successful collection, the hospital scans your ID to close the loop. Your dashboard updates with "Lives Saved" metrics and an authenticity certificate is issued.</p>
                                    </div>
                                </div>
                            </div>

                            <h4 class="fw-bold mb-4">3. Comprehensive FAQ (Operational Intel)</h4>
                            <div class="accordion border-0 mt-4" id="faqArc">
                                <div class="accordion-item border-0 mb-3 shadow-sm rounded-4 overflow-hidden">
                                    <h2 class="accordion-header"><button class="accordion-button fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#q1">How is the donation location determined?</button></h2>
                                    <div id="q1" class="accordion-collapse collapse show" data-bs-parent="#faqArc">
                                        <div class="accordion-body text-muted">Location is determined based on the <b>Point of Collection (POC)</b> specified in the request. This is usually an accredited hospital, local blood bank, or a mobile REDDROP collection camp. We recommend donors never agree to donate in private environments; always ensure the site is a verified medical facility.</div>
                                    </div>
                                </div>
                                <div class="accordion-item border-0 mb-3 shadow-sm rounded-4 overflow-hidden">
                                    <h2 class="accordion-header"><button class="accordion-button collapsed fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#q2">What if I accept a request but can no longer attend?</button></h2>
                                    <div id="q2" class="accordion-collapse collapse" data-bs-parent="#faqArc">
                                        <div class="accordion-body text-muted">Time is life. If you cannot attend, you must use the <b>"Retract Acceptance"</b> button immediately. Our system will instantly re-broadcast the emergency pulse to the next available donors. Frequent "No-Shows" without early retraction may lead to a temporary suspension of your biological verification status.</div>
                                    </div>
                                </div>
                                <div class="accordion-item border-0 mb-3 shadow-sm rounded-4 overflow-hidden">
                                    <h2 class="accordion-header"><button class="accordion-button collapsed fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#q3">Is blood grouping verification mandatory?</button></h2>
                                    <div id="q3" class="accordion-collapse collapse" data-bs-parent="#faqArc">
                                        <div class="accordion-body text-muted">Yes. While you can register with your stated blood group, your first successful donation at a REDDROP-partnered facility will trigger a <b>"Gold Verification"</b> flag. This confirms your blood group via lab results and increases your visibility in Tier 1 Emergency pulses.</div>
                                    </div>
                                </div>
                                <div class="accordion-item border-0 mb-3 shadow-sm rounded-4 overflow-hidden">
                                    <h2 class="accordion-header"><button class="accordion-button collapsed fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#q4">How do I register my vehicle for volunteer transport?</button></h2>
                                    <div id="q4" class="accordion-collapse collapse" data-bs-parent="#faqArc">
                                        <div class="accordion-body text-muted">Navigate to the <b>Volunteer Dashboard</b>. Under the "Logistics" tab, enter your vehicle type, registration number, and availability radius. Volunteers are critical for transporting rare phenotypes between regional hubs.</div>
                                    </div>
                                </div>
                            </div>
                        </section>
                    </c:when>

                    <c:when test="${type == 'api'}">
                        <section class="info-section">
                            <h2 class="fw-black mb-4"><i class="fas fa-code text-primary me-2"></i>Developer Portal & API Gateway</h2>
                            <p class="lead text-muted">The REDDROP API enables seamless integration for Hospital Information Systems (HIS) and Emergency Management Platforms. We provide high-throughput, low-latency endpoints for real-time biological matching.</p>
                            
                            <hr class="my-5 opacity-10">

                            <h5 class="fw-bold mb-3">API Environment Matrix</h5>
                            <div class="row g-4 mb-5">
                                <div class="col-md-4">
                                    <div class="p-3 bg-light rounded-4 border">
                                        <h6 class="fw-bold mb-1">Sandbox</h6>
                                        <code>sandbox-api.reddrop.org</code>
                                        <p class="small text-muted mt-2">Unlimited testing with mock data. No authentication required for GET requests.</p>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="p-3 bg-light rounded-4 border">
                                        <h6 class="fw-bold mb-1">Production</h6>
                                        <code>api.reddropfinder.org</code>
                                        <p class="small text-muted mt-2">Requires institutional verification and valid API Pulse Keys.</p>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="p-3 bg-light rounded-4 border">
                                        <h6 class="fw-bold mb-1">Webhooks</h6>
                                        <code>/hooks/v1/alert</code>
                                        <p class="small text-muted mt-2">Receive real-time callbacks when an emergency pulse matches your stock needs.</p>
                                    </div>
                                </div>
                            </div>

                            <h5 class="fw-bold mb-3">Header Specifications</h5>
                            <div class="bg-dark text-warning p-4 rounded-4 mb-5 shadow-lg">
                                <pre class="mb-0 small">
Content-Type: application/json
X-REDDROP-AGENT-ID: {Your_Institutional_ID}
X-REDDROP-PULSE-KEY: {Secure_API_Token}
Accept-Version: v1.4</pre>
                            </div>

                            <h5 class="fw-bold mb-3">Standard Error Codes (Biological Protocol)</h5>
                            <div class="table-responsive mb-5">
                                <table class="table table-hover align-middle border">
                                    <thead class="bg-light">
                                        <tr>
                                            <th>Error Code</th>
                                            <th>Description</th>
                                            <th>Resolution Strategy</th>
                                        </tr>
                                    </thead>
                                    <tbody class="small">
                                        <tr>
                                            <td><code>RD-4032</code></td>
                                            <td>Pulse Frequency Exceeded</td>
                                            <td>Wait for the 60s rate-limit cooldown.</td>
                                        </tr>
                                        <tr>
                                            <td><code>RD-4041</code></td>
                                            <td>Incompatible Phenotype</td>
                                            <td>Verify blood group parameters (Rh factor syntax).</td>
                                        </tr>
                                        <tr>
                                            <td><code>RD-5001</code></td>
                                            <td>Dispatch Engine Offline</td>
                                            <td>Switch to secondary regional gateway.</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <h5 class="fw-bold mb-3">Example Request (cURL)</h5>
                            <div class="bg-dark text-light p-4 rounded-4 mb-0 font-monospace small shadow-lg">
                                <span class="text-info">curl</span> -X POST <span class="text-warning">"https://api.reddropfinder.org/v1/emergency/dispatch"</span> \<br>
                                &nbsp;&nbsp;-H <span class="text-warning">"X-REDDROP-PULSE-KEY: RD_SECURE_TOKEN_XYZ"</span> \<br>
                                &nbsp;&nbsp;-d '{<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;<span class="text-danger">"bloodGroup"</span>: "O-",<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;<span class="text-danger">"urgency"</span>: "CRITICAL",<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;<span class="text-danger">"unitsRequired"</span>: 2,<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;<span class="text-danger">"location"</span>: {"lat": 23.5, "lng": 88.3}<br>
                                &nbsp;&nbsp;}'
                            </div>
                        </section>
                    </c:when>

                    <c:when test="${type == 'verify'}">
                        <section class="info-section">
                            <h2 class="fw-black mb-4"><i class="fas fa-certificate text-success me-2"></i>Pulse Verification & Integrity</h2>
                            <p class="lead text-muted">The integrity of our donation database is the foundation of patient safety. Every physical donation event is stamped onto our decentralized ledger via an encrypted "Pulse Hash".</p>
                            
                            <hr class="my-5 opacity-10">

                            <div class="p-5 border rounded-5 bg-white shadow-lg mb-5 text-center">
                                <h4 class="fw-bold mb-3">Instant Certificate Validation</h4>
                                <p class="small text-muted mb-4">Enter the 16-character Alpha-Numeric Hash found on the donor's digital or physical certificate.</p>
                                <div class="input-group mx-auto shadow-sm" style="max-width: 600px; border-radius: 16px; overflow: hidden;">
                                    <input type="text" id="certCode" class="form-control py-3 px-4 border-0 fs-5 text-center font-monospace" placeholder="RD-2024-XXXX-XXXX">
                                    <button onclick="verifyCert()" class="btn btn-danger px-5 fw-bold" id="verifyBtn">
                                        <span id="btnText">SEARCH LEDGER</span>
                                        <span id="btnLoading" class="spinner-border spinner-border-sm d-none"></span>
                                    </button>
                                </div>
                                <div id="certResult" class="mt-4"></div>
                            </div>

                            <div class="row g-5">
                                <div class="col-md-7">
                                    <h5 class="fw-bold mb-3">Understanding the Verification Tiers</h5>
                                    <ul class="list-unstyled">
                                        <li class="mb-4">
                                            <div class="d-flex gap-3">
                                                <i class="fas fa-check-circle text-muted fs-4"></i>
                                                <div>
                                                    <h6 class="fw-bold mb-1">Tier 1: Declared (Yellow Icon)</h6>
                                                    <p class="small text-muted">User has provided blood group information during signup but has not yet completed a donation through the REDDROP platform.</p>
                                                </div>
                                            </div>
                                        </li>
                                        <li class="mb-4">
                                            <div class="d-flex gap-3">
                                                <i class="fas fa-check-circle text-primary fs-4"></i>
                                                <div>
                                                    <h6 class="fw-bold mb-1">Tier 2: Verified (Blue Icon)</h6>
                                                    <p class="small text-muted">Blood group has been confirmed by a partnered medical officer during a recorded donation pulse.</p>
                                                </div>
                                            </div>
                                        </li>
                                        <li class="mb-4">
                                            <div class="d-flex gap-3">
                                                <i class="fas fa-check-circle text-warning fs-4"></i>
                                                <div>
                                                    <h6 class="fw-bold mb-1">Tier 3: Elite Guardian (Gold Icon)</h6>
                                                    <p class="small text-muted">Awarded to donors with 5+ successful verifications and zero "No-Show" incidents in a 24-month period.</p>
                                                </div>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                                <div class="col-md-5">
                                    <div class="stat-card badge-earned-card mb-4 text-center p-5 shadow-lg border-0" style="background: white; border-radius: 30px;">
                                        <div class="stat-icon-mini-badge" style="background: #fff5f0; width: 45px; height: 45px; font-size: 1.2rem;">
                                            <i class="fas fa-award"></i>
                                        </div>
                                        <div class="badge-medal-main mb-3" style="font-size: 5rem;">
                                            <i class="fas fa-star text-warning pulse-badge"></i>
                                        </div>
                                        <h4 class="fw-900 text-uppercase mb-1" style="color: #1d3557; letter-spacing: 2px;">Badge Earned</h4>
                                        <p class="small text-muted mb-0">Elite Guardian Status</p>
                                    </div>
                                    <div class="p-4 bg-white rounded-5 shadow-sm border-0">
                                        <h6 class="fw-bold mb-3" style="color: #1d3557;"><i class="fas fa-microscope text-danger me-2"></i>Institutional Standards</h6>
                                        <p class="small text-muted mb-4" style="line-height: 1.6;">All partner hospitals must use our "Collection Scanners" which automatically timestamp the donation and issue the digital certificate to the donor's dashboard via the <b>Handshake Protocol v2</b>.</p>
                                        <div class="mt-4 pt-3 border-top">
                                            <a href="javascript:void(0)" onclick="openGuide()" class="text-danger fw-bold text-decoration-none small d-flex align-items-center justify-content-between">
                                                <span>Download Hospital Integration Guide</span> <i class="fas fa-file-pdf ms-2"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </section>
                    </c:when>

                    <c:when test="${type == 'security'}">
                        <section class="info-section">
                            <h2 class="fw-black mb-4"><i class="fas fa-shield-alt text-danger me-2"></i>Sovereign Security Framework</h2>
                            <p class="lead text-muted">In the digital age, biological data is the ultimate asset. REDDROP protects this asset with a multi-layered, compartmentalized security architecture designed to withstand state-level threats.</p>
                            
                            <hr class="my-5 opacity-10">

                            <div class="row g-4 mb-5">
                                <div class="col-lg-4">
                                    <div class="p-4 border shadow-sm rounded-4 h-100 bg-white">
                                        <div class="mb-3 text-danger"><i class="fas fa-fingerprint fs-1"></i></div>
                                        <h5 class="fw-bold">Zero-Trust Identity</h5>
                                        <p class="small text-muted">Identity is verified via government-grade document parsing and biometric liveness checks. Every session is re-validated before sensitive donor contact data is decrypted.</p>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="p-4 border shadow-sm rounded-4 h-100 bg-white">
                                        <div class="mb-3 text-danger"><i class="fas fa-network-wired fs-1"></i></div>
                                        <h5 class="fw-bold">Edge Protection</h5>
                                        <p class="small text-muted">Our global infrastructure is shielded by an intelligent WAF (Web Application Firewall) that mitigates Layer 7 DDoS attacks and SQL injection attempts in real-time.</p>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="p-4 border shadow-sm rounded-4 h-100 bg-white">
                                        <div class="mb-3 text-danger"><i class="fas fa-atom fs-1"></i></div>
                                        <h5 class="fw-bold">Quantum Hardening</h5>
                                        <p class="small text-muted">We have started transitioning our primary database ledger to post-quantum cryptographic standards to ensure data remains secure for the next 50 years.</p>
                                    </div>
                                </div>
                            </div>

                            <div class="p-4 bg-dark text-white rounded-5 mb-5 overflow-hidden position-relative shadow-lg">
                                <div class="row align-items-center">
                                    <div class="col-lg-8">
                                        <h4 class="fw-bold">Global Compliance Registry</h4>
                                        <p class="small opacity-75">REDDROP maintains active certifications for the following international data standards:</p>
                                        <div class="d-flex flex-wrap gap-2 mt-3">
                                            <span class="badge bg-danger p-2 px-3">HIPAA COMPLIANT</span>
                                            <span class="badge bg-danger p-2 px-3">GDPR ACCREDITED</span>
                                            <span class="badge bg-danger p-2 px-3">ISO 27001</span>
                                            <span class="badge bg-danger p-2 px-3">PCI-DSS LEV 1</span>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 text-end d-none d-lg-block">
                                        <i class="fas fa-shield-virus opacity-25" style="font-size: 150px; position: absolute; right: -20px; top: -30px;"></i>
                                    </div>
                                </div>
                            </div>

                            <h5 class="fw-bold mb-4">Infrastructure Resilience</h5>
                            <ul class="list-group list-group-flush small">
                                <li class="list-group-item bg-transparent border-bottom px-0 d-flex justify-content-between py-3">
                                    <span class="text-muted"><i class="fas fa-server me-2"></i>Data Center Redundancy</span>
                                    <span class="fw-bold">Active-Active Tri-Region</span>
                                </li>
                                <li class="list-group-item bg-transparent border-bottom px-0 d-flex justify-content-between py-3">
                                    <span class="text-muted"><i class="fas fa-history me-2"></i>Automated Backups</span>
                                    <span class="fw-bold">Every 15 Minutes (Encrypted)</span>
                                </li>
                                <li class="list-group-item bg-transparent border-0 px-0 d-flex justify-content-between py-3">
                                    <span class="text-muted"><i class="fas fa-user-shield me-2"></i>Internal Access Control</span>
                                    <span class="fw-bold">Strict Principle of Least Privilege</span>
                                </li>
                            </ul>
                        </section>
                    </c:when>

                    <c:when test="${type == 'privacy'}">
                        <section class="info-section">
                            <h2 class="fw-black mb-4"><i class="fas fa-user-secret text-warning me-2"></i>Tactical Privacy Charter</h2>
                            <p class="lead text-muted">REDDROP is a non-profit sovereign medical network. Unlike commercial health platforms, our primary loyalty is to the donor's privacy and the patient's transparency. We never sell, rent, or lease your biological footprint to third-party advertisers.</p>
                            
                            <hr class="my-5 opacity-10">

                            <div class="mb-5">
                                <h5 class="fw-bold"><i class="fas fa-database text-danger me-2"></i>1. The Data We Collect & Why</h5>
                                <p class="text-muted small">We collect data only to facilitate the life-saving match. This includes:</p>
                                <div class="row g-4 mt-1">
                                    <div class="col-md-6">
                                        <div class="p-4 bg-light rounded-4 border-start border-4 border-danger h-100">
                                            <h6 class="fw-bold mb-1">Biological Identity</h6>
                                            <p class="extra-small text-muted mb-0">Blood group, Rh factor, and donation history. This is vital for the biological matching algorithm.</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="p-4 bg-light rounded-4 border-start border-4 border-danger h-100">
                                            <h6 class="fw-bold mb-1">Geo-Location Intel</h6>
                                            <p class="extra-small text-muted mb-0">Your approximate location (200m accuracy) is tracked only when your "Emergency Availability" toggle is ON.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-5">
                                <h5 class="fw-bold"><i class="fas fa-user-check text-danger me-2"></i>2. The Two-Stage Disclosure Protocol</h5>
                                <p class="text-muted small">We protect your identity via a unique disclosure workflow:</p>
                                <ul class="small text-muted">
                                    <li class="mb-2"><b>Stage 1 (Search Phase):</b> Hospitals only see "12 Donors Available in this Zone." No names, no numbers.</li>
                                    <li class="mb-2"><b>Stage 2 (Acceptance Phase):</b> Only after YOU click "ACCEPT", your contact details are shared via a one-time-access link for exactly 24 hours.</li>
                                </ul>
                            </div>

                            <div class="p-4 bg-light rounded-5 mb-5">
                                <h5 class="fw-bold border-bottom pb-3 mb-3">Your Sovereign Rights</h5>
                                <div class="accordion accordion-flush" id="rightsArc">
                                    <div class="accordion-item bg-transparent">
                                        <h2 class="accordion-header"><button class="accordion-button collapsed bg-transparent fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#r1">Right to Electronic Portability</button></h2>
                                        <div id="r1" class="accordion-collapse collapse" data-bs-parent="#rightsArc">
                                            <div class="accordion-body small text-muted">You can request an encrypted XML/JSON export of your entire donation ledger at any time for transfer to other clinical systems.</div>
                                        </div>
                                    </div>
                                    <div class="accordion-item bg-transparent">
                                        <h2 class="accordion-header"><button class="accordion-button collapsed bg-transparent fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#r2">Right to Immediate Deletion (Right to be Forgotten)</button></h2>
                                        <div id="r2" class="accordion-collapse collapse" data-bs-parent="#rightsArc">
                                            <div class="accordion-body small text-muted">Deleting your account triggers an automated "Shred-Protocol" that wipes your identity from all active databases within 72 hours.</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="alert alert-secondary border-0 p-4 rounded-4 small">
                                <i class="fas fa-cookie-bite me-2"></i> <b>Cookie Policy:</b> We only use Essential Session Cookies. We do not use pixel trackers, fingerprinting, or third-party behavioral analytics.
                            </div>
                        </section>
                    </c:when>

                    <c:when test="${type == 'terms'}">
                        <section class="info-section">
                            <h2 class="fw-black mb-4"><i class="fas fa-file-contract text-danger me-2"></i>Universal Service Protocol (Terms)</h2>
                            <p class="lead text-muted">By accessing the REDDROP network, you agree to the following ethical and legal protocols. These terms are designed to ensure the platform remains a safe, non-commercial space for altruistic donation.</p>
                            
                            <hr class="my-5 opacity-10">

                            <div class="mb-5">
                                <h4 class="fw-bold mb-3">Article 1: The Altruism Mandate</h4>
                                <p class="text-muted small">REDDROP assumes a strict non-commercial stance. No user—patient, hospital, or donor—may offer or receive financial compensation for blood or biological components. Violation of this mandate results in an <b>Immediate Lifecycle Ban</b> and reporting to the relevant criminal investigation bureaus. Human blood is a gift of life, not a commodity of trade.</p>
                            </div>

                            <div class="mb-5">
                                <h4 class="fw-bold mb-3">Article 2: User Conduct & Pulse Ethics</h4>
                                <ul class="list-group list-group-flush small">
                                    <li class="list-group-item bg-transparent px-0 py-3"><b>Accuracy:</b> You must provide accurate health disclosures. Intentional falsification of medical records is a risk to public health.</li>
                                    <li class="list-group-item bg-transparent px-0 py-3"><b>Responsibility:</b> Once a pulse is accepted, you are expected to fulfill the commitment or retract it within 15 minutes.</li>
                                    <li class="list-group-item bg-transparent px-0 py-3"><b>Facility Use:</b> All procedures facilitated by REDDROP must occur at accredited hospitals. REDDROP is not responsible for procedures occurring in unverified locations.</li>
                                </ul>
                            </div>

                            <div class="mb-5">
                                <h4 class="fw-bold mb-3">Article 3: Intellectual Property & Scraping</h4>
                                <p class="text-muted small">The RTGD algorithm, matching engine architecture, and REDDROP branding are the intellectual property of REDDROP Global Foundation. Automated data harvesting (scraping) of donor locations or stock levels is strictly prohibited and protected by active anti-bot countermeasures.</p>
                            </div>

                            <div class="mb-5">
                                <h4 class="fw-bold mb-3">Article 4: Limitation of Clinical Liability</h4>
                                <p class="text-muted small">REDDROP is a logistics and matching facilitator. We do not provide clinical services, medical advice, or biological screening of blood samples. All clinical safety responsibility rests with the medical professionals at the Point of Collection (POC).</p>
                            </div>

                            <div class="card border-0 bg-dark text-white p-4 rounded-4 shadow-lg">
                                <h5 class="fw-bold mb-2 small"><i class="fas fa-gavel me-2 text-danger"></i>Protocol Update Frequency</h5>
                                <p class="extra-small opacity-75 mb-0">These protocols are reviewed quarterly. Last Revision: March 13, 2024 (v4.0.1). Continued session activity constitutes binding acceptance of the latest revision.</p>
                            </div>
                        </section>
                    </c:when>

                    <c:when test="${type == 'contact'}">
                        <section class="info-section">
                            <h2 class="fw-black mb-4"><i class="fas fa-broadcast-tower text-danger me-2"></i>Global Command Center</h2>
                            <p class="lead text-muted">The REDDROP Operations team is stationed worldwide to ensure zero downtime for emergency dispatching. Use the channels below for critical inquiries.</p>
                            
                            <hr class="my-5 opacity-10">

                            <div class="row g-4 mb-5">
                                <div class="col-md-4">
                                    <div class="p-4 border rounded-4 text-center bg-white shadow-sm h-100">
                                        <i class="fas fa-ambulance fs-1 text-danger mb-3"></i>
                                        <h6 class="fw-bold mb-1">Emergency Dispatch</h6>
                                        <p class="extra-small text-muted mb-3">For hospitals unable to log a critical request pulse.</p>
                                        <span class="badge bg-danger p-2 px-3 fw-bold">SOS: +1 (800) RED-999</span>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="p-4 border rounded-4 text-center bg-white shadow-sm h-100">
                                        <i class="fas fa-user-shield fs-1 text-primary mb-3"></i>
                                        <h6 class="fw-bold mb-1">Privacy Officer</h6>
                                        <p class="extra-small text-muted mb-3">For data export or GDPR deletion requests.</p>
                                        <code class="small fw-bold">privacy@reddrop.org</code>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="p-4 border rounded-4 text-center bg-white shadow-sm h-100">
                                        <i class="fas fa-handshake fs-1 text-success mb-3"></i>
                                        <h6 class="fw-bold mb-1">Partnerships</h6>
                                        <p class="extra-small text-muted mb-3">For institutional API keys and new hospital onboarding.</p>
                                        <code class="small fw-bold">network@reddrop.org</code>
                                    </div>
                                </div>
                            </div>

                            <h4 class="fw-bold mb-4">Secure Transmission Portal</h4>
                            <div class="bg-white p-5 border rounded-5 shadow-sm">
                                <form class="row g-4">
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold text-uppercase opacity-75">Your Identity hash</label>
                                        <input type="text" class="form-control form-control-tech py-3" placeholder="Full Name or Institution ID">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold text-uppercase opacity-75">Return Signal (Email)</label>
                                        <input type="email" class="form-control form-control-tech py-3" placeholder="verified@email.com">
                                    </div>
                                    <div class="col-md-12">
                                        <label class="form-label small fw-bold text-uppercase opacity-75">Communication Frequency</label>
                                        <select class="form-select form-control-tech py-3">
                                            <option>Urgent Technical Failure</option>
                                            <option>Institutional Partnership Lead</option>
                                            <option>Media & Public Relations</option>
                                            <option>General Infrastructure Inquiry</option>
                                        </select>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label small fw-bold text-uppercase opacity-75">Encrypted Message Payload</label>
                                        <textarea class="form-control form-control-tech" rows="6" placeholder="Transmission details..."></textarea>
                                    </div>
                                    <div class="col-12">
                                        <button type="button" class="btn btn-danger btn-lg px-5 py-3 rounded-pill fw-bold shadow-lg w-100">
                                            <i class="fas fa-paper-plane me-2"></i> TRANSMIT SECURE PAYLOAD
                                        </button>
                                        <p class="text-center mt-3 extra-small text-muted"><i class="fas fa-lock me-1"></i> All transmissions are AES-256 encrypted at the client-side before dispatch.</p>
                                    </div>
                                </form>
                            </div>
                        </section>
                    </c:when>

                    <c:otherwise>
                        <section class="info-section text-center py-5">
                            <div class="display-1 text-muted mb-4"><i class="fas fa-satellite-dish"></i></div>
                            <h3>Protocol Not Found</h3>
                            <p>The requested support sector is currently offline or undergoing maintenance.</p>
                            <a href="${pageContext.request.contextPath}/support/help" class="btn btn-outline-danger px-4 rounded-pill">Return to Help Center</a>
                        </section>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- Hospital Integration Guide Modal -->
<div class="modal fade" id="guideModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content border-0 rounded-5 shadow-lg overflow-hidden">
            <div class="modal-header bg-dark text-white p-4 border-0">
                <div class="d-flex align-items-center">
                    <img src="${pageContext.request.contextPath}/images/reddrop_pulse_logo.png" height="30" class="me-3">
                    <div>
                        <h5 class="modal-title fw-black mb-0">HOSPITAL INTEGRATION PROTOCOL</h5>
                        <small class="opacity-50 text-uppercase">Technical Whitepaper v4.0.1</small>
                    </div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-0" style="max-height: 70vh; overflow-y: auto; background: #fdfdfd;">
                <div class="p-5" id="printableGuide">
                    <div class="mb-5 border-bottom pb-4">
                        <h2 class="fw-900 mb-2">Institutional Onboarding Guide</h2>
                        <p class="text-muted small">Standardized procedures for blood banks and hospital collection facilities.</p>
                    </div>

                    <div class="row g-5">
                        <div class="col-lg-8">
                            <h5 class="fw-bold mb-3">1. Hardware Requirements</h5>
                            <p class="small text-muted mb-4">Partner facilities must be equipped with Bluetooth 5.0 compatible handheld scanners or tablet devices running the REDDROP Hospital App. This hardware is used to scan the donor's ID and verify the handshake code at the Point of donated collection.</p>
                            
                            <h5 class="fw-bold mb-3">2. API Gateway Integration</h5>
                            <ul class="small text-muted mb-4">
                                <li class="mb-2"><b>Restful Protocol:</b> All data exchanges use HTTPS/TLS 1.3 encryption.</li>
                                <li class="mb-2"><b>Pulse Webhooks:</b> Hospitals receive real-time POST alerts when matching donors are within a 5km radius of the facility ID.</li>
                                <li class="mb-2"><b>Identity Ledger:</b> Every donation is assigned a unique 64-bit SHA-256 Pulse Hash for permanent record in our decentralized database.</li>
                            </ul>

                            <h5 class="fw-bold mb-3">3. Clinical Safety Standards</h5>
                            <p class="small text-muted mb-4">Hospitals are solely responsible for biological testing and specimen verification. REDDROP provides the logistical bridge, but clinical validation (e.g., cross-matching, donor vitality Checks) must follow national WHO guidelines.</p>
                        </div>
                        <div class="col-lg-4">
                            <div class="card bg-light border-0 p-4 rounded-4 shadow-sm h-100">
                                <h6 class="fw-bold mb-3"><i class="fas fa-microchip me-2 text-danger"></i>Compliance Registry</h6>
                                <div class="mb-3">
                                    <div class="extra-small text-muted text-uppercase fw-bold">Data Privacy</div>
                                    <div class="small fw-bold">HIPAA/GDPR Compliant</div>
                                </div>
                                <div class="mb-3">
                                    <div class="extra-small text-muted text-uppercase fw-bold">Integration Type</div>
                                    <div class="small fw-bold">RESTful JSON API</div>
                                </div>
                                <div class="mb-3">
                                    <div class="extra-small text-muted text-uppercase fw-bold">Update Frequency</div>
                                    <div class="small fw-bold">Real-time RTGD Match</div>
                                </div>
                                <hr>
                                <div class="alert alert-warning p-2 extra-small border-0 shadow-sm mb-0">
                                    <i class="fas fa-exclamation-triangle me-1"></i> Requires Institutional Tier 3 Verification Key.
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mt-5 pt-4 border-top">
                        <h5 class="fw-bold mb-3">Operational Support</h5>
                        <p class="small text-muted">To receive your official institutional API key, contact our Command Center at <code>network@reddrop.org</code> with your hospital registration credentials and facility ID.</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0 p-4 pt-0 gap-3">
                <button type="button" class="btn btn-outline-dark btn-lg px-4 fs-6 py-3 rounded-4 fw-bold" onclick="window.print()">
                    <i class="fas fa-print me-2"></i> Print Guide
                </button>
                <button type="button" class="btn btn-danger btn-lg px-4 fs-6 py-3 rounded-4 fw-bold flex-grow-1 shadow-lg" data-bs-dismiss="modal">
                    Acknowledge & Close
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Certificate Result Modal -->
<div class="modal fade" id="certModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-5 shadow-lg overflow-hidden">
            <div class="modal-header bg-success text-white p-4 border-0">
                <h5 class="modal-title fw-900"><i class="fas fa-check-double me-2"></i>CERTIFICATE VERIFIED</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-5">
                <div class="text-center mb-4">
                    <div class="badge-medal-main text-success mb-3" style="font-size: 4rem;">
                        <i class="fas fa-certificate pulse-badge"></i>
                    </div>
                    <div class="h4 fw-bold mb-0" id="resDonor"></div>
                    <p class="text-muted small">Verified Blood Donor</p>
                </div>
                
                <div class="row g-3">
                    <div class="col-6">
                        <div class="p-3 bg-light rounded-4">
                            <div class="extra-small text-muted text-uppercase fw-bold mb-1">Blood Group</div>
                            <div class="h5 fw-bold mb-0 text-danger" id="resBlood"></div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="p-3 bg-light rounded-4">
                            <div class="extra-small text-muted text-uppercase fw-bold mb-1">Units Donated</div>
                            <div class="h5 fw-bold mb-0" id="resUnits"></div>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="p-3 bg-light rounded-4">
                            <div class="extra-small text-muted text-uppercase fw-bold mb-1">Facility</div>
                            <div class="h6 fw-bold mb-0 text-truncate" id="resHospital"></div>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="p-3 bg-light rounded-4">
                            <div class="extra-small text-muted text-uppercase fw-bold mb-1">Donation Date</div>
                            <div class="h6 fw-bold mb-0" id="resDate"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0 p-4 pt-0">
                <button type="button" class="btn btn-dark w-100 py-3 rounded-4 fw-bold" data-bs-dismiss="modal">Close Ledger View</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    AOS.init({ duration: 800, once: true });

    let certModal;
    let guideModal;
    document.addEventListener('DOMContentLoaded', function() {
        const modalEl = document.getElementById('certModal');
        if (modalEl) certModal = new bootstrap.Modal(modalEl);
        
        const guideEl = document.getElementById('guideModal');
        if (guideEl) guideModal = new bootstrap.Modal(guideEl);
    });

    window.openGuide = function() {
        if (guideModal) guideModal.show();
    };

    window.verifyCert = function() {
        const code = document.getElementById('certCode').value;
        const btn = document.getElementById('verifyBtn');
        const btnText = document.getElementById('btnText');
        const btnLoading = document.getElementById('btnLoading');

        if (!code || code.trim().length < 5) {
            Swal.fire({ 
                icon: 'warning', 
                title: 'Invalid Hash', 
                text: 'Please enter a valid certificate hash number.', 
                confirmButtonColor: '#e63946' 
            });
            return;
        }

        btn.disabled = true;
        btnText.classList.add('d-none');
        btnLoading.classList.remove('d-none');

        fetch(`${pageContext.request.contextPath}/api/verify-certificate?code=` + encodeURIComponent(code.trim()))
            .then(res => {
                if (!res.ok) return res.json().then(err => { throw err; });
                return res.json();
            })
            .then(data => {
                btn.disabled = false;
                btnText.classList.remove('d-none');
                btnLoading.classList.add('d-none');

                if (data.valid) {
                    document.getElementById('resDonor').innerText = data.donorName;
                    document.getElementById('resBlood').innerText = data.bloodGroup;
                    document.getElementById('resUnits').innerText = data.units + " Unit(s)";
                    document.getElementById('resHospital').innerText = data.hospital;
                    document.getElementById('resDate').innerText = data.date;
                    if (certModal) certModal.show();
                }
            })
            .catch(err => {
                btn.disabled = false;
                btnText.classList.remove('d-none');
                btnLoading.classList.add('d-none');
                
                Swal.fire({
                    icon: 'error',
                    title: 'Verification Failed',
                    text: err.message || 'This hash does not exist in our decentralized ledger.',
                    confirmButtonColor: '#1d3557'
                });
            });
    };
</script>
</body>
</html>
