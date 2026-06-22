<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - REDDROP Finder</title>
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
                        <a href="${pageContext.request.contextPath}/" class="d-flex align-items-center gap-3 mb-2 text-decoration-none">
                            <img src="${pageContext.request.contextPath}/images/reddrop_pulse_logo.png" alt="Logo" style="height: 50px; border-radius: 10px;">
                            <h2 class="auth-logo-text mb-0">REDDROP<span>Finder</span></h2>
                        </a>
                        <h4 class="fw-800 mb-2">Forgot Password?</h4>
                        <p class="text-muted fw-500">Enter your email and we'll send you a link to reset your password.</p>
                    </div>

                    <!-- Messages -->
                    <c:if test="${not empty error}">
                    <div class="alert alert-danger d-flex align-items-center gap-2 alert-auto-dismiss mb-4">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${error}</span>
                    </div>
                    </c:if>
                    <c:if test="${not empty success}">
                    <div class="alert alert-success d-flex align-items-center gap-2 alert-auto-dismiss mb-4">
                        <i class="fas fa-check-circle"></i>
                        <span>${success}</span>
                    </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                        <div class="mb-4">
                            <label class="form-label-modern">Email Address</label>
                            <div class="input-group-modern">
                                <i class="fas fa-envelope"></i>
                                <input type="email" name="email" id="email"
                                       class="form-control-modern"
                                       placeholder="your@email.com" required>
                            </div>
                        </div>

                        <button type="submit" class="btn-primary-custom w-100 justify-content-center"
                                style="padding:1rem;font-size:1.1rem;box-shadow: 0 10px 25px rgba(255, 30, 66, 0.3);">
                            <i class="fas fa-paper-plane me-2"></i>Send Reset Link
                        </button>
                    </form>

                    <div class="text-center mt-5">
                        <a href="${pageContext.request.contextPath}/login" class="text-muted small fw-600 hover-primary" style="text-decoration: none;">
                            <i class="fas fa-arrow-left me-1"></i>Back to Login
                        </a>
                    </div>
                </div>
            </div>

            <!-- RIGHT: HERO SIDE -->
            <div class="auth-hero-side">
                <div class="auth-hero-content">
                    <div class="auth-hero-img-box">
                        <img src="${pageContext.request.contextPath}/images/login_hero_connection.png" alt="Reset Password Symbol">
                    </div>
                    <h1 class="auth-hero-title">Recover Your <br>Access</h1>
                    <p class="auth-hero-subtitle">Don't worry, even heroes forget sometimes. <br>Follow the secure steps to get back <br>to saving lives.</p>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Auto-dismiss alerts
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert-auto-dismiss');
        alerts.forEach(alert => {
            setTimeout(() => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }, 5000);
        });
    });
</script>
</body>
</html>
