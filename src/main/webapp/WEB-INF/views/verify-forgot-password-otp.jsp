<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify OTP - REDDROP Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-container">
    <div class="container d-flex justify-content-center">
        <div class="auth-split-wrapper">
            
            <!-- LEFT: FORM SIDE -->
            <div class="auth-form-side">
                <div class="auth-card">
                    <div class="mb-4">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <img src="${pageContext.request.contextPath}/images/reddrop_pulse_logo.png" alt="Logo" style="height: 50px; border-radius: 10px;">
                            <h2 class="auth-logo-text mb-0">REDDROP<span>Finder</span></h2>
                        </div>
                        <h4 class="fw-800 mb-2">Verify OTP</h4>
                        <p class="text-muted fw-500">We've sent a 6-digit code to <strong>${email}</strong>. Please enter it below.</p>
                    </div>

                    <!-- Messages -->
                    <c:if test="${not empty error}">
                    <div class="alert alert-danger d-flex align-items-center gap-2 alert-auto-dismiss mb-4">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${error}</span>
                    </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/verify-forgot-password-otp" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="email" value="${email}"/>

                        <div class="mb-4">
                            <label class="form-label-modern">Enter 6-Digit OTP</label>
                            <div class="position-relative">
                                <input type="text" name="otp" id="otp"
                                       class="form-control-modern text-center fw-bold"
                                       placeholder="000000" maxlength="6" pattern="\d{6}" required
                                       style="letter-spacing: 0.5rem; font-size: 1.5rem;">
                            </div>
                        </div>

                        <button type="submit" class="btn-primary-custom w-100 justify-content-center"
                                style="padding:1rem;font-size:1.1rem;box-shadow: 0 10px 25px rgba(255, 30, 66, 0.3);">
                            <i class="fas fa-check-circle me-2"></i>Verify & Continue
                        </button>
                    </form>

                    <div class="text-center mt-5">
                        <form action="${pageContext.request.contextPath}/forgot-password" method="post" style="display:inline;">
                             <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                             <input type="hidden" name="email" value="${email}"/>
                             <button type="submit" class="btn btn-link text-muted small fw-600 p-0" style="text-decoration:none;">
                                 Didn't receive code? Resend
                             </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- RIGHT: HERO SIDE -->
            <div class="auth-hero-side">
                <div class="auth-hero-content">
                    <div class="auth-hero-img-box">
                        <img src="${pageContext.request.contextPath}/images/login_hero_connection.png" alt="OTP Verification Symbol">
                    </div>
                    <h1 class="auth-hero-title">Identity <br>Verification</h1>
                    <p class="auth-hero-subtitle">Confirm your request with the secret code <br>delivered to your inbox. <br>Security first, always.</p>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
