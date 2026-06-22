/**
 * Blood Donor Emergency Finder - Main JavaScript
 * Handles animations, counters, and interactive elements
 */

document.addEventListener('DOMContentLoaded', function () {

    // ==========================================
    // Animated Counter for Impact Stats
    // ==========================================
    function animateCounter(el) {
        const target = parseInt(el.getAttribute('data-target') || el.textContent);
        if (isNaN(target)) return;
        const duration = 2000;
        const step = target / (duration / 16);
        let current = 0;

        const timer = setInterval(() => {
            current += step;
            if (current >= target) {
                current = target;
                clearInterval(timer);
            }
            el.textContent = Math.floor(current).toLocaleString();
        }, 16);
    }

    // Trigger counters when in viewport
    const counterElements = document.querySelectorAll('.counter-animate');
    if (counterElements.length > 0) {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting && !entry.target.classList.contains('counted')) {
                    entry.target.classList.add('counted');
                    animateCounter(entry.target);
                }
            });
        }, { threshold: 0.5 });

        counterElements.forEach(el => observer.observe(el));
    }

    // ==========================================
    // Scroll Animations (fade-in on scroll)
    // ==========================================
    const scrollElements = document.querySelectorAll('.scroll-animate');
    if (scrollElements.length > 0) {
        const scrollObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    scrollObserver.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });

        scrollElements.forEach(el => scrollObserver.observe(el));
    }

    // ==========================================
    // Auto-dismiss Alerts
    // ==========================================
    const alerts = document.querySelectorAll('.alert-auto-dismiss');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            alert.style.transition = 'all 0.4s ease';
            setTimeout(() => alert.remove(), 400);
        }, 4000);
    });

    // ==========================================
    // Role-based Registration Toggle
    // ==========================================
    const roleSelect = document.getElementById('roleSelect');
    const donorFields = document.getElementById('donorFields');

    if (roleSelect && donorFields) {
        function toggleDonorFields() {
            if (roleSelect.value === 'DONOR') {
                donorFields.style.display = 'block';
                donorFields.style.animation = 'fadeInUp 0.4s ease';
            } else {
                donorFields.style.display = 'none';
            }
        }
        roleSelect.addEventListener('change', toggleDonorFields);
        toggleDonorFields();
    }

    // ==========================================
    // Search Form Blood Group Filter
    // ==========================================
    const searchForm = document.getElementById('donorSearchForm');
    if (searchForm) {
        searchForm.addEventListener('submit', function (e) {
            const bloodGroup = document.getElementById('bloodGroup');
            if (bloodGroup && !bloodGroup.value) {
                e.preventDefault();
                bloodGroup.style.border = '2px solid #e63946';
                bloodGroup.focus();
                showToast('Please select a blood group!', 'error');
            }
        });
    }

    // ==========================================
    // Toast Notifications
    // ==========================================
    function showToast(message, type = 'info') {
        const toast = document.createElement('div');
        toast.className = `custom-toast toast-${type}`;
        toast.innerHTML = `<i class="fas fa-${type === 'error' ? 'exclamation-circle' : 'check-circle'}"></i> ${message}`;
        toast.style.cssText = `
            position: fixed; bottom: 2rem; right: 2rem; z-index: 9999;
            background: ${type === 'error' ? '#e63946' : '#2dc653'};
            color: white; padding: 1rem 1.5rem; border-radius: 12px;
            font-weight: 600; box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            animation: slideInUp 0.4s ease; display: flex; align-items: center; gap: 0.5rem;
        `;
        document.body.appendChild(toast);
        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateY(20px)';
            toast.style.transition = 'all 0.3s ease';
            setTimeout(() => toast.remove(), 300);
        }, 3500);
    }

    // Expose globally
    window.showToast = showToast;

    // ==========================================
    // Emergency Request Urgency Color Change
    // ==========================================
    const urgencySelect = document.getElementById('urgencyLevel');
    if (urgencySelect) {
        urgencySelect.addEventListener('change', function () {
            this.className = 'form-control-modern';
            const colors = {
                'CRITICAL': 'border: 2px solid #e63946; color: #e63946',
                'HIGH': 'border: 2px solid #e65c00; color: #e65c00',
                'MEDIUM': 'border: 2px solid #e6a800; color: #e6a800',
                'LOW': 'border: 2px solid #2dc653; color: #2dc653'
            };
            if (colors[this.value]) {
                this.style.cssText = colors[this.value];
            }
        });
    }

    // ==========================================
    // Chart.js Impact Dashboard
    // ==========================================
    const impactChart = document.getElementById('impactChart');
    if (impactChart && typeof Chart !== 'undefined') {
        const ctx = impactChart.getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Donors', 'Requests', 'Donations', 'Camps'],
                datasets: [{
                    data: [
                        parseInt(impactChart.dataset.donors || 0),
                        parseInt(impactChart.dataset.requests || 0),
                        parseInt(impactChart.dataset.donations || 0),
                        parseInt(impactChart.dataset.camps || 0)
                    ],
                    backgroundColor: ['#e63946', '#1d3557', '#2dc653', '#f4a261'],
                    borderWidth: 0,
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'bottom' }
                },
                animation: { animateScale: true }
            }
        });
    }

    // Bar chart for monthly donations
    const monthlyChart = document.getElementById('monthlyChart');
    if (monthlyChart && typeof Chart !== 'undefined') {
        const ctx2 = monthlyChart.getContext('2d');
        new Chart(ctx2, {
            type: 'bar',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                         'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                datasets: [{
                    label: 'Blood Donations',
                    data: [12, 19, 25, 18, 32, 28, 35, 22, 40, 29, 45, 38],
                    backgroundColor: 'rgba(230, 57, 70, 0.8)',
                    borderRadius: 8,
                    borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.05)' } },
                    x: { grid: { display: false } }
                },
                plugins: { legend: { display: false } },
                animation: { duration: 1500, easing: 'easeInOutQuart' }
            }
        });
    }

    // ==========================================
    // Navbar active link highlight
    // ==========================================
    const currentPath = window.location.pathname;
    document.querySelectorAll('.navbar-nav .nav-link').forEach(link => {
        if (link.getAttribute('href') === currentPath) {
            link.classList.add('active');
        }
    });

    // ==========================================
    // Smooth scroll for anchor links
    // ==========================================
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                e.preventDefault();
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });

    // ==========================================
    // Navbar scroll effect
    // ==========================================
    const navbar = document.querySelector('.navbar-custom');
    if (navbar) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 50) {
                navbar.classList.add('navbar-scrolled');
            } else {
                navbar.classList.remove('navbar-scrolled');
            }
        });
    }

    // ==========================================
    // Back to Top Button
    // ==========================================
    const backToTop = document.getElementById('backToTop');
    if (backToTop) {
        window.addEventListener('scroll', () => {
            backToTop.style.opacity = window.scrollY > 300 ? '1' : '0';
            backToTop.style.pointerEvents = window.scrollY > 300 ? 'all' : 'none';
        });
        backToTop.addEventListener('click', () => window.scrollTo({ top: 0, behavior: 'smooth' }));
    }
});
