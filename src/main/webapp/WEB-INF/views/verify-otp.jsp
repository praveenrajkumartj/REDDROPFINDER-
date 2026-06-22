<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify OTP - REDDROPFINDER</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f8f9fa; display: flex; align-items: center; justify-content: center; min-height: 100vh; font-family: 'Inter', sans-serif; }
        .otp-container { width: 100%; max-width: 450px; background: #fff; padding: 40px; border-radius: 20px; box-shadow: 0 15px 35px rgba(230, 57, 70, 0.1); border-top: 5px solid #e63946; }
        .otp-icon { width: 70px; height: 70px; background: rgba(230, 57, 70, 0.1); color: #e63946; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 30px; margin: 0 auto 25px; }
        .otp-title { font-weight: 800; color: #1d3557; text-align: center; margin-bottom: 10px; font-size: 24px; }
        .otp-subtitle { color: #6c757d; text-align: center; font-size: 15px; margin-bottom: 30px; }
        .otp-input { text-align: center; font-size: 24px; font-weight: 800; letter-spacing: 10px; border: 2px solid #eee; border-radius: 12px; padding: 12px; transition: all 0.3s; }
        .otp-input:focus { border-color: #e63946; box-shadow: 0 0 0 4px rgba(230, 57, 70, 0.1); }
        .timer-container { text-align: center; margin-top: 20px; font-weight: 600; color: #e63946; }
        .btn-verify { background: #e63946; border: none; padding: 12px; border-radius: 12px; font-weight: 700; font-size: 16px; margin-top: 10px; transition: all 0.3s; width: 100%; color: white; }
        .btn-verify:hover { background: #d62828; transform: translateY(-2px); box-shadow: 0 8px 15px rgba(230, 57, 70, 0.3); }
        .resend-container { text-align: center; margin-top: 25px; font-size: 14px; }
        .resend-link { color: #e63946; text-decoration: none; font-weight: 700; cursor: pointer; opacity: 0.5; pointer-events: none; transition: 0.3s; }
        .resend-link.active { opacity: 1; pointer-events: auto; }
    </style>
</head>
<body>

<div class="otp-container">
    <div class="otp-icon">
        <i class="fas fa-envelope-open-text"></i>
    </div>
    <h2 class="otp-title">Email Verification</h2>
    <p class="otp-subtitle">We have sent a 6-digit verification code to<br><strong class="text-dark">${email}</strong></p>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger py-2 small mb-4 text-center border-0 shadow-sm rounded-3">
            <i class="fas fa-exclamation-circle me-1"></i> ${errorMessage}
        </div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success py-2 small mb-4 text-center border-0 shadow-sm rounded-3">
            <i class="fas fa-check-circle me-1"></i> ${successMessage}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/verify-otp" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="hidden" name="email" value="${email}">
        
        <div class="mb-4">
            <input type="text" name="otp" class="form-control otp-input" maxlength="6" placeholder="000000" required autocomplete="off">
        </div>

        <button type="submit" class="btn btn-verify">Verify Account</button>
    </form>

    <div class="timer-container">
        OTP expires in: <span id="timer">05:00</span>
    </div>

    <div class="resend-container">
        Didn't receive the code? 
        <form action="${pageContext.request.contextPath}/resend-otp" method="post" id="resendForm" class="d-inline">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="email" value="${email}">
            <a onclick="document.getElementById('resendForm').submit();" class="resend-link" id="resendLink">Resend OTP</a>
        </form>
    </div>

    <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/register" class="text-muted small text-decoration-none">
            <i class="fas fa-arrow-left me-1"></i> Back to Register
        </a>
    </div>
</div>

<script>
    let timeLeft = 300; // 5 minutes in seconds
    const timerDisplay = document.getElementById('timer');
    const resendLink = document.getElementById('resendLink');
    
    // Resend cool-down (30 seconds)
    let resendTimer = 30;

    const countdown = setInterval(() => {
        if(timeLeft <= 0) {
            clearInterval(countdown);
            timerDisplay.innerText = "00:00";
        } else {
            timeLeft--;
            let mins = Math.floor(timeLeft / 60);
            let secs = timeLeft % 60;
            timerDisplay.innerText = 
                (mins < 10 ? "0" + mins : mins) + ":" + (secs < 10 ? "0" + secs : secs);
        }

        if(resendTimer > 0) {
            resendTimer--;
        } else {
            resendLink.classList.add('active');
            resendLink.innerText = "Resend OTP";
        }
    }, 1000);

    // Auto-focus input
    document.querySelector('.otp-input').focus();
</script>

</body>
</html>
