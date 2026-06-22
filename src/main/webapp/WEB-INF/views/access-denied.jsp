<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Access Denied - Blood Donor Emergency Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body style="background:linear-gradient(135deg,#1d3557,#0d1b2a);min-height:100vh;display:flex;align-items:center;">
<div class="container text-center">
    <div style="font-size:8rem;line-height:1;"><i class="fas fa-ban text-danger"></i></div>
    <h1 style="font-size:4rem;font-weight:900;color:white;font-family:'Poppins',sans-serif;">403</h1>
    <h2 style="color:rgba(255,255,255,0.8);margin-bottom:1rem;">Access Denied</h2>
    <p style="color:rgba(255,255,255,0.6);max-width:400px;margin:0 auto 2rem;">
        You don't have permission to access this page. Please login with the appropriate account.
    </p>
    <div class="d-flex gap-3 justify-content-center">
        <a href="${pageContext.request.contextPath}/" class="btn-hero-secondary">
            <i class="fas fa-home me-2"></i>Go Home
        </a>
        <a href="${pageContext.request.contextPath}/login" class="btn-hero-primary"
           style="background:linear-gradient(135deg,#e63946,#c1121f);">
            <i class="fas fa-sign-in-alt me-2"></i>Login
        </a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>









