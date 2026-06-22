<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - REDDROP Finder</title>
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
                        <h4 class="fw-800 mb-2">Create New Password</h4>
                        <p class="text-muted fw-500">OTP Verified! Your security is our priority. Set a strong, new password below.</p>
                    </div>

                    <!-- Messages -->
                    <c:if test="${not empty error}">
                    <div class="alert alert-danger d-flex align-items-center gap-2 alert-auto-dismiss mb-4">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${error}</span>
                    </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/reset-password" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="email" value="${email}"/>
                        <input type="hidden" name="otp" value="${otp}"/>

                        <div class="mb-3">
                            <label class="form-label-modern">New Password</label>
                            <div class="input-group-modern">
                                <i class="fas fa-lock"></i>
                                <input type="password" name="password" id="password"
                                       class="form-control-modern"
                                       placeholder="••••••••" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label-modern">Confirm Password</label>
                            <div class="input-group-modern">
                                <i class="fas fa-key"></i>
                                <input type="password" name="confirmPassword" id="confirmPassword"
                                       class="form-control-modern"
                                       placeholder="••••••••" required>
                            </div>
                        </div>

                        <button type="submit" class="btn-primary-custom w-100 justify-content-center"
                                style="padding:1rem;font-size:1.1rem;box-shadow: 0 10px 25px rgba(255, 30, 66, 0.3);">
                            <i class="fas fa-save me-2"></i>Update Password
                        </button>
                    </form>

                    <div class="text-center mt-4">
                        <a href="${pageContext.request.contextPath}/login" class="text-muted small fw-600 hover-primary" style="text-decoration: none;">
                            <i class="fas fa-times me-1"></i>Cancel Reset
                        </a>
                    </div>
                </div>
            </div>

            <!-- RIGHT: HERO SIDE -->
            <div class="auth-hero-side">
                <div class="auth-hero-content">
                    <div class="auth-hero-img-box">
                        <img src="${pageContext.request.contextPath}/images/login_hero_connection.png" alt="Security Symbol">
                    </div>
                    <h1 class="auth-hero-title">Shield Your <br>Account</h1>
                    <p class="auth-hero-subtitle">Update your credentials to maintain <br>a secure environment for lifesavers <br>and patients alike.</p>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
