# VitaCore — Health & Nutrition Management System

> **Student:** Kiran Kumar K.R | **Roll No:** D.NO: 23UCS553 | **Class:** BSc CS "A"  
> **Guide:** Dr. B. Rex Cyril

---

## 📁 Project Structure

```
vitacore/
├── index.html              ← Landing Page (Home)
├── css/
│   └── main.css            ← All styles (dark dramatic theme)
├── js/
│   └── main.js             ← Particle animation, counters, interactions
├── pages/
│   ├── features.html       ← All 8 platform features
│   ├── dashboard.html      ← User health dashboard with metrics
│   ├── nutrition.html      ← Food search, macros, AI meal plans
│   ├── login.html          ← Login page (User/Nutritionist/Admin)
│   ├── signup.html         ← Registration with role selection
│   └── contact.html        ← Contact form + project info
└── backend/
    ├── database.sql        ← Complete MySQL schema (14 tables)
    └── api.php             ← PHP backend with all API functions
```

---

## 🚀 Setup Instructions

### Frontend (HTML/CSS/JS)
1. Extract the zip folder
2. Open `index.html` in any browser
3. All pages work without a server (pure HTML/CSS/JS)

### Backend (MySQL + PHP)
1. **Install XAMPP / WAMP / MAMP** or any PHP + MySQL server
2. **Import the database:**
   ```bash
   mysql -u root -p < backend/database.sql
   ```
   Or use phpMyAdmin → Import → select `database.sql`
3. **Configure database credentials** in `backend/api.php`:
   ```php
   define('DB_HOST', 'localhost');
   define('DB_USER', 'root');
   define('DB_PASS', 'your_password');
   define('DB_NAME', 'vitacore_db');
   ```
4. **Place files** in your web server's root (e.g., `htdocs/vitacore/`)
5. Access via `http://localhost/vitacore/`

---

## 🗄️ Database Tables (14 tables)

| Table | Description |
|-------|-------------|
| `users` | All users (patients, nutritionists, admins) |
| `health_metrics` | BMI, blood pressure, weight history |
| `food_items` | 500K+ food database with nutritional values |
| `meal_logs` | Daily food intake logs |
| `workout_plans` | Workout plan templates |
| `workout_logs` | Daily exercise records |
| `water_intake` | Hydration tracking |
| `sleep_logs` | Sleep duration & quality |
| `diet_plans` | Nutritionist-created meal plans |
| `diet_plan_meals` | Individual meals within diet plans |
| `user_diet_plans` | Assignments of plans to users |
| `consultations` | User–Nutritionist consultations |
| `notifications` | System notifications |
| `user_goals` | Health goal tracking |

---

## 🎯 Features

1. **User Authentication** — Role-based login (User / Nutritionist / Admin)
2. **Health Profile** — BMI, weight, activity level tracking
3. **Food Logging** — Search & log meals with auto macro calculation
4. **AI Diet Plans** — Personalized meal plans (weight loss, keto, diabetic, etc.)
5. **Workout Tracker** — Cardio, strength, yoga with calorie burn
6. **Water & Sleep Monitor** — Hydration reminders & sleep quality analysis
7. **Health Dashboard** — Weekly/monthly analytics charts
8. **Medical Integration** — Predictive health risk management

---

## 💻 Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | HTML5, CSS3, Vanilla JavaScript |
| Styling | Custom CSS with CSS Variables, Animations |
| Database | MySQL |
| Backend | PHP (REST API) |
| Auth | JWT-based token authentication |

---

## 🎨 Design

- **Theme:** Dramatic dark with neon green (#00f5a0) accent
- **Font:** Bebas Neue (display) + DM Sans (body)
- **Effects:** Particle canvas background, scroll animations, counter effects
- **Responsive:** Mobile-friendly with hamburger navigation

---

*© 2025 VitaCore Health Systems*
