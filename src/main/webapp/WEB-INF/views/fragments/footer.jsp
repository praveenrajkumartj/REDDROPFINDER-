<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- =========== FOOTER =========== -->
<footer class="footer-tech">
    <div class="container">
        <div class="row g-5">
            <!-- Brand Column -->
            <div class="col-lg-4" data-aos="fade-up" data-aos-offset="0">
                <a class="navbar-brand-custom mb-3 d-flex align-items-center gap-2 text-decoration-none" href="${pageContext.request.contextPath}/">
                    <img src="${pageContext.request.contextPath}/images/reddrop_pulse_logo.png" alt="REDDROP Logo" style="height: 50px; filter: brightness(1.2) drop-shadow(0 0 15px rgba(255, 30, 66, 0.4)); border-radius: 12px;">
                    <div class="brand-name-main">
                        <span class="brand-part-navy text-white" style="font-weight: 900; letter-spacing: -0.5px;">REDDROP</span><span class="brand-part-red" style="color: #ff1e42; font-weight: 900;">Finder</span>
                    </div>
                </a>
                <p class="mb-4 pe-lg-5" style="line-height: 1.6; color: rgba(255,255,255,0.7);">
                    Digitizing survival through compassionate code. We are the bridge between need and hope in the medical era, connecting life-savers with patients in real-time.
                </p>
                <div class="d-flex gap-3">
                    <a href="#" class="social-circle-tech"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="social-circle-tech"><i class="fab fa-linkedin-in"></i></a>
                    <a href="#" class="social-circle-tech"><i class="fab fa-instagram"></i></a>
                </div>
            </div>

            <!-- Network Links -->
            <div class="col-lg-2 col-md-6" data-aos="fade-up" data-aos-delay="100" data-aos-offset="0">
                <h5 class="text-white mb-4" style="font-weight: 800; font-family: var(--font-heading);">Network</h5>
                <div class="d-flex flex-column gap-3">
                    <a href="${pageContext.request.contextPath}/search-donor" class="footer-link-tech">Find Donors</a>
                    <a href="${pageContext.request.contextPath}/blood-camps" class="footer-link-tech">Blood Camps</a>
                    <a href="${pageContext.request.contextPath}/impact" class="footer-link-tech">Global Stats</a>
                    <a href="${pageContext.request.contextPath}/dashboard" class="footer-link-tech">User Dashboard</a>
                </div>
            </div>

            <!-- Support Links -->
            <div class="col-lg-2 col-md-6" data-aos="fade-up" data-aos-delay="200" data-aos-offset="0">
                <h5 class="text-white mb-4" style="font-weight: 800; font-family: var(--font-heading);">Support</h5>
                <div class="d-flex flex-column gap-3">
                    <a href="${pageContext.request.contextPath}/support/help" class="footer-link-tech">Help Center</a>
                    <a href="${pageContext.request.contextPath}/support/about" class="footer-link-tech">About Us</a>
                    <a href="${pageContext.request.contextPath}/support/security" class="footer-link-tech">Security Info</a>
                    <a href="${pageContext.request.contextPath}/support/api" class="footer-link-tech">API Access</a>
                    <a href="${pageContext.request.contextPath}/support/verify" class="footer-link-tech">Verification</a>
                </div>
            </div>

            <!-- Emergency Column -->
            <div class="col-lg-4" data-aos="fade-up" data-aos-delay="300" data-aos-offset="0">
                <div class="emergency-card-footer">
                    <h5 class="text-white mb-2" style="font-weight: 800;">Emergency Response</h5>
                    <p class="small mb-4" style="color: rgba(255,255,255,0.5); line-height: 1.5;">Instant dispatch for O- and Rare types. Clinical hotline available 24/7.</p>
                    <a href="tel:180025663" class="d-flex align-items-center gap-3 text-decoration-none group">
                        <div class="emergency-icon-box">
                            <i class="fas fa-phone-volume"></i>
                        </div>
                        <div>
                            <div class="emergency-label">Direct Hotline</div>
                            <h4 class="emergency-phone">1-800-BLOOD</h4>
                        </div>
                    </a>
                </div>
            </div>
        </div>

        <div class="footer-bottom-tech">
            <p class="mb-0 small" style="color: rgba(255,255,255,0.5);">© 2026 REDDROP Finder. Every drop counts.</p>
            <div class="d-flex gap-4 footer-legal">
                <a href="${pageContext.request.contextPath}/support/about">About</a>
                <a href="${pageContext.request.contextPath}/support/privacy">Privacy</a>
                <a href="${pageContext.request.contextPath}/support/terms">Terms</a>
                <a href="${pageContext.request.contextPath}/support/contact">Contact</a>
            </div>
        </div>
    </div>
</footer>

<style>
    .footer-tech {
        background: #0f172a !important; /* Force a dark background */
        padding: 4rem 0 2rem;
        margin-top: 0;
        position: relative;
        z-index: 10;
    }
    /* Fallback to ensure footer columns are visible if AOS fails to trigger on short pages */
    .footer-tech [data-aos] {
        visibility: visible !important;
        opacity: 1 !important;
        transform: none !important;
    }
    .aos-init .footer-tech [data-aos] {
        opacity: 0 !important; /* Let AOS hide them initially ONLY IF AOS is initialized */
    }
    .aos-animate .footer-tech [data-aos] {
        opacity: 1 !important;
    }
    .footer-link-tech {
        color: rgba(255,255,255,0.6) !important;
        text-decoration: none;
        font-weight: 500;
        font-size: 0.95rem;
        transition: all 0.3s ease;
    }
    .footer-link-tech:hover {
        color: #ff1e42 !important;
        transform: translateX(5px);
    }
    .social-circle-tech {
        width: 40px;
        height: 40px;
        background: rgba(255,255,255,0.05);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        text-decoration: none;
        transition: all 0.3s ease;
    }
    .social-circle-tech:hover {
        background: #ff1e42;
        color: white;
        transform: translateY(-3px);
    }
    .emergency-card-footer {
        background: rgba(255,255,255,0.02);
        border: 1px solid rgba(255,255,255,0.05);
        border-radius: 20px;
        padding: 2rem;
    }
    .emergency-icon-box {
        width: 50px;
        height: 50px;
        background: #ff1e42;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 1.2rem;
        box-shadow: 0 0 20px rgba(255, 30, 66, 0.3);
    }
    .emergency-label {
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.1em;
        color: rgba(255,255,255,0.5);
        margin-bottom: 2px;
    }
    .emergency-phone {
        color: white !important;
        font-weight: 900;
        margin: 0;
        font-size: 1.4rem;
    }
    .footer-bottom-tech {
        margin-top: 5rem;
        padding-top: 2rem;
        border-top: 1px solid rgba(255,255,255,0.05);
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 1.5rem;
    }
    .footer-legal a {
        color: rgba(255,255,255,0.4);
        text-decoration: none;
        font-size: 0.85rem;
        transition: color 0.3s ease;
    }
    .footer-legal a:hover {
        color: white;
    }
</style>
