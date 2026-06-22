<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - REDDROP Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <style>
        /* Force reset for standard styles that might conflict */
        .auth-container, .auth-split-wrapper, .auth-form-side, .auth-card { 
            background: transparent !important; 
            border: none !important;
            padding: 0 !important;
            margin: 0 !important;
            width: auto !important;
            box-shadow: none !important;
        }

        :root {
            --primary-red: #ea2b33;
            --tech-navy: #0f172a;
        }

        body, html {
            height: 100%;
            margin: 0;
            padding: 0;
            font-family: 'Outfit', sans-serif;
            overflow: hidden !important;
            background: #000;
        }

        .login-page-wrapper {
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.85) 0%, rgba(234, 43, 51, 0.35) 100%), 
                        url('${pageContext.request.contextPath}/images/login_bg_lifeline.png');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            height: 100vh;
            width: 100vw;
            display: flex;
            align-items: center;
            justify-content: center;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
        }

        /* Dark Glass Card - High Content Stability */
        .glass-card-fixed {
            background: rgba(15, 23, 42, 0.7) !important;
            backdrop-filter: blur(40px) saturate(200%) !important;
            -webkit-backdrop-filter: blur(40px) saturate(200%) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-radius: 40px !important;
            padding: 3.5rem !important;
            width: 480px !important;
            box-shadow: 0 50px 100px rgba(0, 0, 0, 0.7) !important;
            color: white !important;
            animation: fadeIn 0.8s ease-out !important;
        }

        @keyframes fadeIn { from { opacity: 0; transform: scale(0.98); } to { opacity: 1; transform: scale(1); } }

        .auth-logo-box { display: flex; align-items: center; gap: 15px; margin-bottom: 1rem; }
        .auth-logo-box img { height: 50px; background: white; padding: 6px; border-radius: 12px; }
        .auth-logo-text { font-weight: 800; font-size: 2rem; color: white !important; letter-spacing: -1px; margin: 0; }
        .auth-logo-text span { color: var(--primary-red) !important; }
        .welcome-msg { color: rgba(255, 255, 255, 0.7); font-size: 0.95rem; margin-bottom: 2.5rem; }

        .input-label { color: white; opacity: 0.9; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1.5px; margin-bottom: 12px; display: block; }
        
        .modern-input-group-fixed {
            background: rgba(255, 255, 255, 0.05) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-radius: 18px !important;
            padding: 12px 20px !important;
            display: flex; align-items: center;
            margin-bottom: 1.8rem !important;
            position: relative !important;
            width: 100% !important;
            box-sizing: border-box !important;
        }
        
        /* NO CHANGE ON FOCUS */
        .modern-input-group-fixed:focus-within {
            border-color: var(--primary-red) !important;
            box-shadow: none !important;
        }

        .modern-input-group-fixed i.fa-lock, .modern-input-group-fixed i.fa-envelope { 
            color: var(--primary-red); 
            font-size: 1.2rem; 
            margin-right: 15px;
            flex-shrink: 0;
        }
        
        .modern-input-group-fixed input {
            background: transparent !important;
            border: none !important;
            color: white !important;
            flex: 1 1 auto !important; /* Allow growing and shrinking */
            min-width: 0 !important;
            outline: none !important;
            font-size: 1rem;
            box-shadow: none !important;
        }

        .pwd-toggle {
            background: none !important;
            border: none !important;
            color: rgba(255, 255, 255, 0.4) !important;
            cursor: pointer !important;
            padding: 0 5px !important;
            margin-left: 10px !important;
            flex-shrink: 0 !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            transition: color 0.3s ease !important;
        }

        .pwd-toggle:hover { color: white !important; }

        .modern-input-group-fixed input::placeholder { color: rgba(255, 255, 255, 0.3) !important; }

        /* Force Remove Autofill Background */
        input:-webkit-autofill,
        input:-webkit-autofill:hover, 
        input:-webkit-autofill:focus, 
        input:-webkit-autofill:active {
            -webkit-box-shadow: 0 0 0 1000px #1e2433 inset !important;
            -webkit-text-fill-color: white !important;
            transition: background-color 5000s ease-in-out 0s;
        }

        .btn-signin-fixed {
            background: var(--primary-red) !important;
            color: white !important;
            border: none !important;
            border-radius: 18px !important;
            padding: 20px !important;
            width: 100% !important;
            font-weight: 800 !important;
            font-size: 1.1rem !important;
            margin-top: 1rem !important;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            box-shadow: 0 10px 30px rgba(234, 43, 51, 0.3) !important;
            transition: background 0.3s ease !important;
        }
        .btn-signin-fixed:hover { background: #ff3a42 !important; transform: none !important; }

        .btn-join-fixed {
            background: white !important;
            color: var(--tech-navy) !important;
            border: none !important;
            border-radius: 18px !important;
            padding: 18px !important;
            width: 100% !important;
            font-weight: 800 !important;
            text-decoration: none !important;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            transition: background 0.3s ease !important;
        }
        .btn-join-fixed:hover { background: #f1f5f9 !important; transform: none !important; }

        .or-divider { display: flex; align-items: center; margin: 2rem 0; color: rgba(255, 255, 255, 0.4); font-size: 0.85rem; font-weight: 800; width: 100%; }
        .or-divider::before, .or-divider::after { content: ""; flex-grow: 1; height: 1px; background: rgba(255, 255, 255, 0.1); }
        .or-divider span { padding: 0 15px; }

        .back-link { display: block; text-align: center; margin-top: 2rem; color: rgba(255, 255, 255, 0.6); text-decoration: none; font-size: 0.9rem; font-weight: 600; }
        .back-link:hover { color: white !important; transform: none !important; }

        .hero-section-fixed { max-width: 550px; padding-left: 6rem; color: white; animation: slideRight 1s ease-out; }
        @keyframes slideRight { from { opacity: 0; transform: translateX(50px); } to { opacity: 1; transform: translateX(0); } }
        .hero-title { 
            font-weight: 800; 
            font-size: 4rem; 
            line-height: 1.1; 
            margin-bottom: 2rem; 
            color: #ffffff !important;
            text-shadow: 0 10px 40px rgba(0,0,0,0.7) !important; 
        }
        .hero-subtitle { 
            font-size: 1.3rem; 
            line-height: 1.8; 
            color: #ffffff !important;
            opacity: 1 !important; 
            font-weight: 500 !important;
            text-shadow: 0 5px 20px rgba(0,0,0,0.8) !important; 
        }

        @media (max-width: 991px) { .hero-section-fixed { display: none; } .glass-card-fixed { margin: 20px; width: auto !important; } }
    </style>
</head>
<body>

<div class="login-page-wrapper">
    <div class="container d-flex justify-content-start align-items-center h-100">
        <!-- FORM CARD -->
        <div class="glass-card-fixed">
            <a href="${pageContext.request.contextPath}/" style="text-decoration: none; display: flex; align-items: center; gap: 15px; margin-bottom: 2.5rem;">
                <img src="${pageContext.request.contextPath}/images/reddrop_pulse_logo.png" alt="REDDROP Logo" style="height: 48px; width: auto; border-radius: 12px; filter: drop-shadow(0 4px 12px rgba(255, 30, 66, 0.3));">
                <div style="display: flex; flex-direction: column; justify-content: center;">
                    <div style="font-family: 'Outfit', sans-serif; font-size: 1.8rem; font-weight: 900; line-height: 1; display: flex; align-items: baseline; text-transform: uppercase; letter-spacing: -0.8px;">
                        <span style="color: #ffffff;">REDDROP</span><span style="color: #FF1E42;">Finder</span>
                    </div>
                </div>
            </a>
            <p class="welcome-msg">Welcome back! Sign in to continue saving lives.</p>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger border-0 rounded-4 py-3 small mb-4" style="background: rgba(234, 43, 51, 0.2); color: #ffbcbc; backdrop-filter: blur(10px);">
                    <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <label class="input-label">Email Address</label>
                <div class="modern-input-group-fixed">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="username" placeholder="a_in@blooddonor.com" required>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-0">
                    <label class="input-label mb-0">Password</label>
                    <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-link" style="color: rgba(255,255,255,0.6); font-size: 0.8rem; text-decoration: none;">Forgot?</a>
                </div>
                <div class="modern-input-group-fixed mt-3">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" id="password" placeholder="••••••••" required>
                    <button type="button" id="togglePwd" class="pwd-toggle" style="background:none; border:none; color:rgba(255,255,255,0.4); cursor:pointer;"><i class="fas fa-eye" id="eyeIcon"></i></button>
                </div>

                <button type="submit" class="btn-signin-fixed">
                    <i class="fas fa-sign-in-alt"></i> Sign In
                </button>
            </form>

            <div class="or-divider"><span>OR</span></div>

            <a href="${pageContext.request.contextPath}/register" class="btn-join-fixed">
                <i class="fas fa-user-plus"></i> Join the Community
            </a>

            <a href="${pageContext.request.contextPath}/" class="back-link">
                <i class="fas fa-arrow-left me-2"></i> Back to Homepage
            </a>
        </div>

        <!-- HERO TEXT -->
        <div class="hero-section-fixed d-none d-lg-block">
            <h1 class="hero-title">A Lifeline <br>From Your Heart</h1>
            <p class="hero-subtitle">
                Your blood donation is a direct connection between a hero's heart and a life in need. 
                Sign in to continue this vital mission.
            </p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('togglePwd').addEventListener('click', function() {
        const pwd = document.getElementById('password');
        const eye = document.getElementById('eyeIcon');
        if (pwd.type === 'password') {
            pwd.type = 'text';
            eye.className = 'fas fa-eye-slash';
        } else {
            pwd.type = 'password';
            eye.className = 'fas fa-eye';
        }
    });

    // Auto-dismiss alerts
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert');
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
