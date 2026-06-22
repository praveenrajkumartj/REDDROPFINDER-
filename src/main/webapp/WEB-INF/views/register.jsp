<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - REDDROP Finder</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <style>
        /* Force reset for standard styles */
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
            background: #000;
        }

        .register-page-wrapper {
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.7) 0%, rgba(234, 43, 51, 0.25) 100%), 
                        url('${pageContext.request.contextPath}/images/register_bg_custom.png');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
            width: 100vw;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 0;
        }

        /* Dark Glass Card - High Content Stability */
        .glass-card-fixed {
            background: rgba(15, 23, 42, 0.75) !important;
            backdrop-filter: blur(40px) saturate(200%) !important;
            -webkit-backdrop-filter: blur(40px) saturate(200%) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-radius: 40px !important;
            padding: 3rem !important;
            width: 900px !important;
            max-width: 95vw !important;
            box-shadow: 0 50px 100px rgba(0, 0, 0, 0.7) !important;
            color: white !important;
            animation: fadeIn 0.8s ease-out !important;
        }

        @keyframes fadeIn { from { opacity: 0; transform: scale(0.98); } to { opacity: 1; transform: scale(1); } }

        .welcome-msg { color: rgba(255, 255, 255, 0.7); font-size: 0.95rem; margin-bottom: 2rem; }

        .input-label { color: white; opacity: 0.8; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; margin-bottom: 8px; display: block; }
        
        .modern-input-group-fixed {
            background: rgba(255, 255, 255, 0.05) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-radius: 15px !important;
            padding: 10px 18px !important;
            display: flex;
            align-items: center;
            margin-bottom: 1.2rem !important;
            transition: none !important;
            width: 100% !important;
            box-sizing: border-box !important;
        }
        
        .modern-input-group-fixed:focus-within {
            border-color: var(--primary-red) !important;
            box-shadow: none !important;
        }

        .modern-input-group-fixed i { color: var(--primary-red); font-size: 1rem; margin-right: 12px; flex-shrink: 0; }
        
        .modern-input-group-fixed input, .modern-input-group-fixed select, .modern-input-group-fixed textarea {
            background: transparent !important;
            border: none !important;
            color: white !important;
            width: 100%;
            outline: none !important;
            font-size: 0.95rem;
            box-shadow: none !important;
        }

        .modern-input-group-fixed select { appearance: none; cursor: pointer; }
        .modern-input-group-fixed select option { background: #1e2433; color: white; }

        .modern-input-group-fixed input::placeholder { color: rgba(255, 255, 255, 0.3) !important; }

        /* Force Remove Autofill Background */
        input:-webkit-autofill {
            -webkit-box-shadow: 0 0 0 1000px #1e2433 inset !important;
            -webkit-text-fill-color: white !important;
        }

        .btn-register-fixed {
            background: var(--primary-red) !important;
            color: white !important;
            border: none !important;
            border-radius: 18px !important;
            padding: 18px !important;
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
        .btn-register-fixed:hover { background: #ff3a42 !important; }

        .hero-section-fixed { max-width: 550px; padding-left: 6rem; color: white; animation: slideRight 1s ease-out; }
        .hero-title { 
            font-weight: 800; 
            font-size: 4rem; 
            line-height: 1.1; 
            margin-bottom: 2rem; 
            color: #ffffff !important;
            text-shadow: 0 10px 40px rgba(0,0,0,0.7) !important; 
        }
        .hero-subtitle { 
            font-size: 1.4rem; 
            line-height: 1.8; 
            color: #ffffff !important;
            opacity: 1 !important; 
            font-weight: 500 !important;
            text-shadow: 0 5px 25px rgba(0,0,0,0.8) !important; 
        }

        #registerMap { 
            border: 2px solid rgba(255, 255, 255, 0.1) !important; 
            filter: grayscale(0.5) invert(0.9) hue-rotate(180deg) brightness(0.9); 
            transition: filter 0.3s ease;
        }
        #registerMap:hover { filter: grayscale(0) invert(0) hue-rotate(0) brightness(1); }

        .dynamic-fields-card {
            background: rgba(255, 255, 255, 0.03);
            border: 1px dashed rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 20px;
            margin-bottom: 1.5rem;
        }

        .pwd-toggle { background: none; border: none; color: rgba(255, 255, 255, 0.4); cursor: pointer; padding: 0 5px; }

        @media (max-width: 1200px) { .hero-section-fixed { display: none; } }
    </style>
</head>
<body>

<div class="register-page-wrapper">
    <div class="container d-flex justify-content-center align-items-center">
        <!-- FORM CARD -->
        <div class="glass-card-fixed">
            <a href="${pageContext.request.contextPath}/" style="text-decoration: none; display: flex; align-items: center; gap: 15px; margin-bottom: 2rem;">
                <img src="${pageContext.request.contextPath}/images/reddrop_pulse_logo.png" alt="REDDROP Logo" style="height: 48px; width: auto; border-radius: 12px; filter: drop-shadow(0 4px 12px rgba(255, 30, 66, 0.3));">
                <div style="display: flex; flex-direction: column; justify-content: center;">
                    <div style="font-family: 'Outfit', sans-serif; font-size: 1.8rem; font-weight: 900; line-height: 1; display: flex; align-items: baseline; text-transform: uppercase; letter-spacing: -0.8px;">
                        <span style="color: #ffffff;">REDDROP</span><span style="color: #FF1E42;">Finder</span>
                    </div>
                </div>
            </a>
            
            <p class="welcome-msg">Join our community of life-savers today.</p>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger border-0 rounded-4 py-3 small mb-4" style="background: rgba(234, 43, 51, 0.2); color: #ffbcbc; backdrop-filter: blur(10px);">
                    <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="row g-3">
                    <!-- PERSONAL INFO -->
                    <div class="col-md-12">
                        <label class="input-label" id="nameLabel">Full Name *</label>
                        <div class="modern-input-group-fixed">
                            <i class="fas fa-user"></i>
                            <input type="text" name="name" placeholder="John Doe" required value="${user.name}">
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="input-label">Email Address *</label>
                        <div class="modern-input-group-fixed">
                            <i class="fas fa-envelope"></i>
                            <input type="email" name="email" placeholder="john@example.com" required value="${user.email}">
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="input-label">Phone Number *</label>
                        <div class="modern-input-group-fixed">
                            <i class="fas fa-phone"></i>
                            <input type="tel" name="phone" placeholder="10 Digit Number" required pattern="[0-9]{10}" maxlength="10" value="${user.phone}">
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="input-label">Password *</label>
                        <div class="modern-input-group-fixed">
                            <i class="fas fa-lock"></i>
                            <input type="password" name="password" id="regPassword" placeholder="Min 6 characters" required minlength="6">
                            <button type="button" id="toggleRegPwd" class="pwd-toggle"><i class="fas fa-eye" id="eyeIconReg"></i></button>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="input-label">I am registering as *</label>
                        <div class="modern-input-group-fixed">
                            <i class="fas fa-id-badge"></i>
                            <select name="role" id="roleSelect" required>
                                <option value="" disabled selected>Select Your Role</option>
                                <option value="DONOR">🩸 Blood Donor</option>
                                <option value="PATIENT">🏥 Patient / Guardian</option>
                                <option value="HOSPITAL">🏨 Hospital / Organization</option>
                                <option value="VOLUNTEER">🚑 Transport Volunteer</option>
                            </select>
                        </div>
                    </div>

                    <!-- GEOLOCATION INFO -->
                    <div class="col-md-4">
                        <label class="input-label">City *</label>
                        <div class="modern-input-group-fixed">
                            <i class="fas fa-city"></i>
                            <input type="text" name="city" id="cityInput" class="geo-input" placeholder="City" required value="${user.city}">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label class="input-label">State *</label>
                        <div class="modern-input-group-fixed">
                            <i class="fas fa-map-marked-alt"></i>
                            <input type="text" name="state" id="stateInput" class="geo-input" placeholder="State" required value="${user.state}">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label class="input-label">Pincode *</label>
                        <div class="modern-input-group-fixed">
                            <i class="fas fa-location-arrow"></i>
                            <input type="text" name="pincode" id="pincodeInput" class="geo-input" placeholder="6-digit" required pattern="[0-9]{6}" maxlength="6" value="${user.pincode}">
                        </div>
                    </div>

                    <div class="col-12">
                        <label class="input-label">Full Address *</label>
                        <div class="modern-input-group-fixed">
                            <i class="fas fa-home"></i>
                            <textarea name="fullAddress" id="addressInput" class="geo-input" placeholder="Complete address..." required rows="1" style="resize: none;">${user.fullAddress}</textarea>
                        </div>
                    </div>

                    <!-- MAP PICKER -->
                    <div class="col-12 mb-3">
                        <label class="input-label">Set Exact Location on Map *</label>
                        <div id="registerMap" style="height: 200px; border-radius: 18px; margin-bottom: 0.5rem;"></div>
                        <input type="hidden" name="latitude" id="latInput" value="${user.latitude}">
                        <input type="hidden" name="longitude" id="lonInput" value="${user.longitude}">
                    </div>

                    <!-- DYNAMIC FIELDS -->
                    <div class="col-12" id="hospitalFields" style="display:none;">
                        <div class="dynamic-fields-card">
                            <label class="input-label">Hospital / Organization Name *</label>
                            <div class="modern-input-group-fixed">
                                <i class="fas fa-hospital"></i>
                                <input type="text" name="hospitalName" placeholder="e.g. City General Hospital" id="hospitalNameInput">
                            </div>
                        </div>
                    </div>

                    <div class="col-12" id="volunteerFields" style="display:none;">
                        <div class="dynamic-fields-card">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="input-label">Vehicle Type *</label>
                                    <div class="modern-input-group-fixed">
                                        <i class="fas fa-car"></i>
                                        <select name="vehicleType" id="vehicleTypeSelect">
                                            <option value="">Vehicle Type</option>
                                            <option value="BIKE">🏍️ Bike</option>
                                            <option value="CAR">🚗 Car</option>
                                            <option value="AUTO">🛺 Auto</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="input-label">Vehicle Number *</label>
                                    <div class="modern-input-group-fixed">
                                        <i class="fas fa-list-ol"></i>
                                        <input type="text" name="vehicleNumber" placeholder="e.g. ABC 1234" id="vehicleNumberInput">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12" id="donorFields" style="display:none;">
                        <div class="dynamic-fields-card">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="input-label">Blood Group *</label>
                                    <div class="modern-input-group-fixed">
                                        <i class="fas fa-tint"></i>
                                        <select name="bloodGroup" id="bloodGroupSelect">
                                            <option value="">Blood Group</option>
                                            <c:forEach var="bg" items="${bloodGroups}">
                                            <option value="${bg}">${bg}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="input-label">Last Donation</label>
                                    <div class="modern-input-group-fixed">
                                        <i class="fas fa-calendar-check"></i>
                                        <input type="date" name="lastDonationDate">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mt-2 mb-3 d-flex align-items-center gap-2">
                    <input class="form-check-input" type="checkbox" id="agreeTerms" required style="cursor: pointer;">
                    <label class="form-check-label small" for="agreeTerms" style="color: #ffffff !important; opacity: 1 !important;">
                        I agree to the <a href="#" style="color: var(--primary-red); text-decoration: none; font-weight: 700;">Terms & Privacy</a>
                    </label>
                </div>

                <button type="submit" class="btn-register-fixed">
                    <i class="fas fa-user-plus"></i> Create My Account
                </button>
            </form>

            <div class="text-center mt-4">
                <span style="color: rgba(255,255,255,0.6); font-size: 0.9rem;">Already have an account? </span>
                <a href="${pageContext.request.contextPath}/login" style="color: var(--primary-red); font-weight: 800; text-decoration: none;">Sign In</a>
            </div>
            
            <a href="${pageContext.request.contextPath}/" class="back-link" style="display: block; text-align: center; margin-top: 1.5rem; color: rgba(255,255,255,0.4); text-decoration: none; font-size: 0.85rem;">
                <i class="fas fa-arrow-left me-2"></i> Back to Homepage
            </a>
        </div>

        <!-- HERO TEXT -->
        <div class="hero-section-fixed d-none d-xl-block">
            <h1 class="hero-title">Be the Hero <br>In Someone's Story</h1>
            <p class="hero-subtitle">
                Every registration brings us one step closer to 
                a world where no life is lost for lack of blood.
                Join our mission today.
            </p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Map Initialization
    var map = L.map('registerMap').setView([20.5937, 78.9629], 5);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

    var marker;
    var exLat = document.getElementById('latInput').value;
    var exLon = document.getElementById('lonInput').value;
    
    if(exLat && exLon) {
        var latlng = L.latLng(exLat, exLon);
        marker = L.marker(latlng).addTo(map);
        map.setView(latlng, 15);
    } else if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(p) { map.setView([p.coords.latitude, p.coords.longitude], 13); });
    }

    map.on('click', function(e) {
        if (marker) marker.setLatLng(e.latlng);
        else marker = L.marker(e.latlng).addTo(map);
        document.getElementById('latInput').value = e.latlng.lat;
        document.getElementById('lonInput').value = e.latlng.lng;
    });

    document.getElementById('roleSelect').addEventListener('change', function() {
        const donor = document.getElementById('donorFields');
        const volunteer = document.getElementById('volunteerFields');
        const hospital = document.getElementById('hospitalFields');
        const nameLabel = document.getElementById('nameLabel');

        donor.style.display = 'none';
        volunteer.style.display = 'none';
        hospital.style.display = 'none';
        nameLabel.innerText = "Full Name *";

        if (this.value === 'DONOR') donor.style.display = 'block';
        else if (this.value === 'VOLUNTEER') volunteer.style.display = 'block';
        else if (this.value === 'HOSPITAL') {
            hospital.style.display = 'block';
            nameLabel.innerText = "Admin / Contact Person Name *";
        }
    });

    document.getElementById('toggleRegPwd').addEventListener('click', function() {
        const pwd = document.getElementById('regPassword');
        const eye = document.getElementById('eyeIconReg');
        pwd.type = pwd.type === 'password' ? 'text' : 'password';
        eye.className = pwd.type === 'password' ? 'fas fa-eye' : 'fas fa-eye-slash';
    });

    // Auto-Geocoding
    const geoInputs = document.querySelectorAll('.geo-input');
    let geoTimeout;
    function updateMap() {
        const city = document.getElementById('cityInput').value;
        const address = document.getElementById('addressInput').value;
        if (!city && !address) return;
        const query = (address + " " + city).trim();
        fetch("https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(query))
            .then(res => res.json())
            .then(data => {
                if (data && data.length > 0) {
                    const latlng = L.latLng(data[0].lat, data[0].lon);
                    if (marker) marker.setLatLng(latlng);
                    else marker = L.marker(latlng).addTo(map);
                    map.setView(latlng, 15);
                    document.getElementById('latInput').value = data[0].lat;
                    document.getElementById('lonInput').value = data[0].lon;
                }
            });
    }
    geoInputs.forEach(i => i.addEventListener('input', () => { clearTimeout(geoTimeout); geoTimeout = setTimeout(updateMap, 1500); }));
</script>
</body>
</html>
