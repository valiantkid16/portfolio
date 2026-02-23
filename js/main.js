// VitaCore - Main JavaScript

// ===== Particle Background =====
(function () {
  const canvas = document.getElementById('bg-canvas');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  let W, H, particles = [];

  function resize() {
    W = canvas.width = window.innerWidth;
    H = canvas.height = window.innerHeight;
  }

  class Particle {
    constructor() { this.reset(); }
    reset() {
      this.x = Math.random() * W;
      this.y = Math.random() * H;
      this.r = Math.random() * 1.5 + 0.3;
      this.vx = (Math.random() - 0.5) * 0.3;
      this.vy = (Math.random() - 0.5) * 0.3;
      this.alpha = Math.random() * 0.5 + 0.1;
      this.color = Math.random() > 0.7 ? '#00f5a0' : '#00d4e0';
    }
    update() {
      this.x += this.vx; this.y += this.vy;
      if (this.x < 0 || this.x > W || this.y < 0 || this.y > H) this.reset();
    }
    draw() {
      ctx.beginPath();
      ctx.arc(this.x, this.y, this.r, 0, Math.PI * 2);
      ctx.fillStyle = this.color;
      ctx.globalAlpha = this.alpha;
      ctx.fill();
    }
  }

  function init() {
    resize();
    particles = Array.from({ length: 120 }, () => new Particle());
    window.addEventListener('resize', resize);
    animate();
  }

  function drawConnections() {
    for (let i = 0; i < particles.length; i++) {
      for (let j = i + 1; j < particles.length; j++) {
        const dx = particles[i].x - particles[j].x;
        const dy = particles[i].y - particles[j].y;
        const dist = Math.sqrt(dx * dx + dy * dy);
        if (dist < 100) {
          ctx.beginPath();
          ctx.moveTo(particles[i].x, particles[i].y);
          ctx.lineTo(particles[j].x, particles[j].y);
          ctx.strokeStyle = '#00f5a0';
          ctx.globalAlpha = (1 - dist / 100) * 0.06;
          ctx.lineWidth = 0.5;
          ctx.stroke();
        }
      }
    }
  }

  function animate() {
    ctx.clearRect(0, 0, W, H);
    drawConnections();
    particles.forEach(p => { p.update(); p.draw(); });
    ctx.globalAlpha = 1;
    requestAnimationFrame(animate);
  }

  init();
})();

// ===== Navbar scroll =====
const navbar = document.getElementById('navbar');
if (navbar) {
  window.addEventListener('scroll', () => {
    navbar.classList.toggle('scrolled', window.scrollY > 60);
  });
}

// ===== Mobile nav =====
const navToggle = document.getElementById('navToggle');
if (navToggle) {
  navToggle.addEventListener('click', () => {
    const navLinks = document.querySelector('.nav-links');
    const navActions = document.querySelector('.nav-actions');
    if (navLinks) {
      const open = navLinks.style.display === 'flex';
      navLinks.style.display = open ? 'none' : 'flex';
      navLinks.style.flexDirection = 'column';
      navLinks.style.position = 'absolute';
      navLinks.style.top = '70px';
      navLinks.style.left = '0';
      navLinks.style.right = '0';
      navLinks.style.background = 'rgba(5,8,16,0.98)';
      navLinks.style.padding = '20px';
      navLinks.style.borderBottom = '1px solid rgba(255,255,255,0.07)';
      if (navActions) navActions.style.display = open ? 'none' : 'flex';
    }
  });
}

// ===== Counter animation =====
function animateCounter(el) {
  const target = parseInt(el.dataset.target);
  const duration = 2000;
  const step = target / (duration / 16);
  let current = 0;
  const timer = setInterval(() => {
    current = Math.min(current + step, target);
    el.textContent = Math.floor(current).toLocaleString();
    if (current >= target) clearInterval(timer);
  }, 16);
}

const statNums = document.querySelectorAll('.stat-num');
if (statNums.length) {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        animateCounter(entry.target);
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.5 });
  statNums.forEach(el => observer.observe(el));
}

// ===== Scroll animate =====
const animEls = document.querySelectorAll('.animate-in, .feat-card, .role-card, .testi-card, .step, .nutrition-card');
if (animEls.length) {
  const obs = new IntersectionObserver((entries) => {
    entries.forEach((entry, i) => {
      if (entry.isIntersecting) {
        const delay = entry.target.dataset.delay || 0;
        setTimeout(() => {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
        }, parseInt(delay));
        obs.unobserve(entry.target);
      }
    });
  }, { threshold: 0.15 });

  animEls.forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(30px)';
    el.style.transition = 'opacity 0.7s ease, transform 0.7s ease';
    obs.observe(el);
  });
}

// ===== Progress bars =====
const progressFills = document.querySelectorAll('.progress-fill');
if (progressFills.length) {
  const progressObs = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const fill = entry.target;
        const width = fill.style.width;
        fill.style.width = '0';
        setTimeout(() => { fill.style.width = width; }, 100);
        progressObs.unobserve(entry.target);
      }
    });
  }, { threshold: 0.5 });
  progressFills.forEach(el => progressObs.observe(el));
}

// ===== Form validation =====
document.querySelectorAll('.form-submit').forEach(btn => {
  btn.addEventListener('click', function (e) {
    const form = this.closest('form') || this.parentElement;
    const inputs = form ? form.querySelectorAll('input[required]') : [];
    let valid = true;
    inputs.forEach(input => {
      if (!input.value.trim()) {
        input.style.borderColor = '#ff6b35';
        valid = false;
        setTimeout(() => { input.style.borderColor = ''; }, 2000);
      }
    });
    if (!valid) { e.preventDefault(); return; }
    this.textContent = '✓ Success!';
    this.style.background = 'linear-gradient(135deg, #00f5a0, #00d4e0)';
    setTimeout(() => {
      this.textContent = this.dataset.label || 'Submit';
      this.style.background = '';
    }, 2000);
  });
});
