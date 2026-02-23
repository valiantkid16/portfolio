-- ============================================================
-- VITACORE - Health & Nutrition Management System
-- MySQL Database Schema
-- Student: Kiran Kumar K.R | D.NO: 23UCS553 | BSc CS "A"
-- Guide: Dr. B. Rex Cyril
-- ============================================================

CREATE DATABASE IF NOT EXISTS vitacore_db;
USE vitacore_db;

-- ============================================================
-- TABLE 1: USERS
-- ============================================================
CREATE TABLE users (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role          ENUM('user', 'nutritionist', 'admin') DEFAULT 'user',
    age           INT,
    gender        ENUM('male', 'female', 'other'),
    height_cm     DECIMAL(5,2),
    weight_kg     DECIMAL(5,2),
    activity_level ENUM('sedentary', 'light', 'moderate', 'active', 'very_active') DEFAULT 'moderate',
    health_goal   ENUM('lose_weight', 'gain_muscle', 'maintain', 'improve_fitness', 'manage_condition') DEFAULT 'maintain',
    profile_pic   VARCHAR(255),
    is_active     BOOLEAN DEFAULT TRUE,
    email_verified BOOLEAN DEFAULT FALSE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE 2: HEALTH METRICS
-- ============================================================
CREATE TABLE health_metrics (
    metric_id     INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT NOT NULL,
    bmi           DECIMAL(5,2),
    body_fat_pct  DECIMAL(5,2),
    weight_kg     DECIMAL(5,2),
    height_cm     DECIMAL(5,2),
    blood_pressure_sys  INT,
    blood_pressure_dia  INT,
    heart_rate    INT,
    blood_glucose DECIMAL(6,2),
    recorded_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes         TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 3: FOOD ITEMS (Database)
-- ============================================================
CREATE TABLE food_items (
    food_id       INT AUTO_INCREMENT PRIMARY KEY,
    food_name     VARCHAR(150) NOT NULL,
    brand_name    VARCHAR(100),
    category      ENUM('fruit','vegetable','grain','protein','dairy','fat','beverage','snack','other') DEFAULT 'other',
    serving_size_g DECIMAL(7,2) DEFAULT 100,
    calories      DECIMAL(7,2) NOT NULL,
    protein_g     DECIMAL(6,2),
    carbs_g       DECIMAL(6,2),
    fat_g         DECIMAL(6,2),
    fiber_g       DECIMAL(6,2),
    sugar_g       DECIMAL(6,2),
    sodium_mg     DECIMAL(7,2),
    potassium_mg  DECIMAL(7,2),
    calcium_mg    DECIMAL(7,2),
    iron_mg       DECIMAL(6,2),
    vitamin_c_mg  DECIMAL(6,2),
    is_verified   BOOLEAN DEFAULT FALSE,
    added_by      INT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (added_by) REFERENCES users(user_id) ON DELETE SET NULL
);

-- ============================================================
-- TABLE 4: MEAL LOGS
-- ============================================================
CREATE TABLE meal_logs (
    log_id        INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT NOT NULL,
    food_id       INT NOT NULL,
    meal_type     ENUM('breakfast','lunch','dinner','snack','pre_workout','post_workout') NOT NULL,
    quantity_g    DECIMAL(7,2) NOT NULL,
    calories      DECIMAL(7,2),
    protein_g     DECIMAL(6,2),
    carbs_g       DECIMAL(6,2),
    fat_g         DECIMAL(6,2),
    logged_date   DATE NOT NULL,
    logged_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes         VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (food_id) REFERENCES food_items(food_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 5: WORKOUT PLANS
-- ============================================================
CREATE TABLE workout_plans (
    plan_id       INT AUTO_INCREMENT PRIMARY KEY,
    created_by    INT NOT NULL,
    plan_name     VARCHAR(150) NOT NULL,
    plan_type     ENUM('cardio','strength','yoga','hiit','flexibility','sports','custom') DEFAULT 'custom',
    difficulty    ENUM('beginner','intermediate','advanced') DEFAULT 'beginner',
    duration_weeks INT DEFAULT 4,
    description   TEXT,
    goal          ENUM('weight_loss','muscle_gain','endurance','flexibility','general'),
    is_public     BOOLEAN DEFAULT FALSE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 6: WORKOUT LOGS
-- ============================================================
CREATE TABLE workout_logs (
    wlog_id       INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT NOT NULL,
    plan_id       INT,
    workout_name  VARCHAR(150),
    workout_type  ENUM('cardio','strength','yoga','hiit','flexibility','sports','custom') DEFAULT 'custom',
    duration_min  INT,
    calories_burned DECIMAL(7,2),
    distance_km   DECIMAL(6,2),
    sets          INT,
    reps          INT,
    weight_kg     DECIMAL(6,2),
    heart_rate_avg INT,
    logged_date   DATE NOT NULL,
    logged_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes         TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES workout_plans(plan_id) ON DELETE SET NULL
);

-- ============================================================
-- TABLE 7: WATER INTAKE
-- ============================================================
CREATE TABLE water_intake (
    intake_id     INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT NOT NULL,
    amount_ml     INT NOT NULL,
    logged_date   DATE NOT NULL,
    logged_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 8: SLEEP LOGS
-- ============================================================
CREATE TABLE sleep_logs (
    sleep_id      INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT NOT NULL,
    sleep_start   DATETIME NOT NULL,
    sleep_end     DATETIME NOT NULL,
    duration_hrs  DECIMAL(4,2),
    quality_score INT CHECK (quality_score BETWEEN 1 AND 10),
    deep_sleep_pct DECIMAL(5,2),
    rem_sleep_pct  DECIMAL(5,2),
    interruptions  INT DEFAULT 0,
    notes         TEXT,
    logged_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 9: DIET PLANS (from Nutritionists)
-- ============================================================
CREATE TABLE diet_plans (
    plan_id       INT AUTO_INCREMENT PRIMARY KEY,
    nutritionist_id INT NOT NULL,
    plan_name     VARCHAR(150) NOT NULL,
    plan_type     ENUM('weight_loss','weight_gain','maintenance','diabetic','keto','vegan','custom'),
    description   TEXT,
    total_calories INT,
    protein_pct   INT,
    carbs_pct     INT,
    fat_pct       INT,
    duration_days INT DEFAULT 30,
    is_active     BOOLEAN DEFAULT TRUE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (nutritionist_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 10: DIET PLAN MEALS
-- ============================================================
CREATE TABLE diet_plan_meals (
    meal_id       INT AUTO_INCREMENT PRIMARY KEY,
    plan_id       INT NOT NULL,
    day_number    INT NOT NULL,
    meal_type     ENUM('breakfast','lunch','dinner','snack','pre_workout','post_workout'),
    food_id       INT NOT NULL,
    quantity_g    DECIMAL(7,2),
    notes         VARCHAR(255),
    FOREIGN KEY (plan_id) REFERENCES diet_plans(plan_id) ON DELETE CASCADE,
    FOREIGN KEY (food_id) REFERENCES food_items(food_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 11: USER-DIET PLAN ASSIGNMENTS
-- ============================================================
CREATE TABLE user_diet_plans (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT NOT NULL,
    plan_id       INT NOT NULL,
    start_date    DATE NOT NULL,
    end_date      DATE,
    is_active     BOOLEAN DEFAULT TRUE,
    assigned_by   INT,
    assigned_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES diet_plans(plan_id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_by) REFERENCES users(user_id) ON DELETE SET NULL
);

-- ============================================================
-- TABLE 12: CONSULTATIONS
-- ============================================================
CREATE TABLE consultations (
    consult_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT NOT NULL,
    nutritionist_id INT NOT NULL,
    status        ENUM('pending','confirmed','completed','cancelled') DEFAULT 'pending',
    scheduled_at  DATETIME,
    duration_min  INT DEFAULT 30,
    meeting_type  ENUM('video','chat','in_person') DEFAULT 'video',
    notes         TEXT,
    report        TEXT,
    fee           DECIMAL(8,2),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (nutritionist_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 13: NOTIFICATIONS
-- ============================================================
CREATE TABLE notifications (
    notif_id      INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT NOT NULL,
    title         VARCHAR(150) NOT NULL,
    message       TEXT NOT NULL,
    type          ENUM('reminder','achievement','alert','info','consultation') DEFAULT 'info',
    is_read       BOOLEAN DEFAULT FALSE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 14: GOALS
-- ============================================================
CREATE TABLE user_goals (
    goal_id       INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT NOT NULL,
    goal_type     ENUM('weight','calories','steps','water','sleep','workout','custom'),
    target_value  DECIMAL(10,2),
    current_value DECIMAL(10,2),
    unit          VARCHAR(20),
    start_date    DATE,
    end_date      DATE,
    is_achieved   BOOLEAN DEFAULT FALSE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- SAMPLE DATA: Food Items
-- ============================================================
INSERT INTO food_items (food_name, category, calories, protein_g, carbs_g, fat_g, fiber_g, is_verified) VALUES
('Rolled Oats', 'grain', 389, 17, 66, 7, 10, TRUE),
('Banana', 'fruit', 89, 1.1, 23, 0.3, 2.6, TRUE),
('Grilled Chicken Breast', 'protein', 165, 31, 0, 3.6, 0, TRUE),
('Brown Rice (cooked)', 'grain', 123, 2.7, 26, 0.9, 1.8, TRUE),
('Avocado', 'fruit', 160, 2, 9, 15, 7, TRUE),
('Greek Yogurt (low fat)', 'dairy', 59, 10, 3.6, 0.4, 0, TRUE),
('Almonds', 'fat', 579, 21, 22, 50, 12.5, TRUE),
('Sweet Potato', 'vegetable', 86, 1.6, 20, 0.1, 3, TRUE),
('Salmon Fillet', 'protein', 208, 20, 0, 13, 0, TRUE),
('Broccoli', 'vegetable', 34, 2.8, 7, 0.4, 2.6, TRUE),
('Whole Eggs', 'protein', 155, 13, 1.1, 11, 0, TRUE),
('Quinoa (cooked)', 'grain', 120, 4.4, 22, 1.9, 2.8, TRUE),
('Almond Milk (unsweetened)', 'beverage', 17, 0.6, 0.6, 1.4, 0.2, TRUE),
('Apple', 'fruit', 52, 0.3, 14, 0.2, 2.4, TRUE),
('Spinach', 'vegetable', 23, 2.9, 3.6, 0.4, 2.2, TRUE),
('Cottage Cheese', 'dairy', 98, 11, 3.4, 4.3, 0, TRUE),
('Lentils (cooked)', 'protein', 116, 9, 20, 0.4, 7.9, TRUE),
('Olive Oil', 'fat', 884, 0, 0, 100, 0, TRUE),
('Blueberries', 'fruit', 57, 0.7, 14, 0.3, 2.4, TRUE),
('Whey Protein Powder', 'protein', 400, 80, 7, 7, 1, TRUE);

-- ============================================================
-- SAMPLE DATA: Admin User
-- ============================================================
INSERT INTO users (first_name, last_name, email, password_hash, role, age, gender, height_cm, weight_kg, activity_level, health_goal) VALUES
('Admin', 'VitaCore', 'admin@vitacore.health', '$2b$12$hashed_password_here', 'admin', 30, 'other', 170, 65, 'moderate', 'maintain'),
('Kiran', 'Kumar', 'kiran@vitacore.health', '$2b$12$hashed_password_here', 'user', 21, 'male', 175, 68.5, 'active', 'lose_weight'),
('Dr. Rajesh', 'Nair', 'rajesh@vitacore.health', '$2b$12$hashed_password_here', 'nutritionist', 38, 'male', 178, 75, 'moderate', 'maintain');

-- ============================================================
-- USEFUL VIEWS
-- ============================================================

-- Daily Calorie Summary View
CREATE VIEW daily_calorie_summary AS
SELECT 
    ml.user_id,
    ml.logged_date,
    SUM(ml.calories) AS total_calories,
    SUM(ml.protein_g) AS total_protein,
    SUM(ml.carbs_g) AS total_carbs,
    SUM(ml.fat_g) AS total_fat,
    COUNT(*) AS meal_count
FROM meal_logs ml
GROUP BY ml.user_id, ml.logged_date;

-- User Health Overview View
CREATE VIEW user_health_overview AS
SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    u.email,
    u.age,
    u.height_cm,
    u.weight_kg,
    ROUND(u.weight_kg / ((u.height_cm/100) * (u.height_cm/100)), 2) AS bmi,
    u.activity_level,
    u.health_goal,
    u.role,
    u.created_at
FROM users u
WHERE u.is_active = TRUE;

-- Weekly Progress View
CREATE VIEW weekly_progress AS
SELECT 
    user_id,
    YEARWEEK(logged_date, 1) AS year_week,
    SUM(calories) AS weekly_calories,
    SUM(protein_g) AS weekly_protein,
    AVG(calories) AS avg_daily_calories,
    COUNT(DISTINCT logged_date) AS days_logged
FROM meal_logs
GROUP BY user_id, YEARWEEK(logged_date, 1);

-- ============================================================
-- STORED PROCEDURES
-- ============================================================

DELIMITER //

-- Calculate BMI
CREATE PROCEDURE calculate_bmi(IN p_user_id INT)
BEGIN
    DECLARE v_weight DECIMAL(5,2);
    DECLARE v_height DECIMAL(5,2);
    DECLARE v_bmi DECIMAL(5,2);
    
    SELECT weight_kg, height_cm INTO v_weight, v_height
    FROM users WHERE user_id = p_user_id;
    
    IF v_height > 0 THEN
        SET v_bmi = v_weight / ((v_height/100) * (v_height/100));
        
        INSERT INTO health_metrics (user_id, bmi, weight_kg, height_cm)
        VALUES (p_user_id, v_bmi, v_weight, v_height);
        
        SELECT v_bmi AS bmi,
            CASE 
                WHEN v_bmi < 18.5 THEN 'Underweight'
                WHEN v_bmi < 25 THEN 'Normal'
                WHEN v_bmi < 30 THEN 'Overweight'
                ELSE 'Obese'
            END AS bmi_category;
    END IF;
END //

-- Log water intake and check daily goal
CREATE PROCEDURE log_water(IN p_user_id INT, IN p_amount_ml INT, IN p_date DATE)
BEGIN
    DECLARE v_total INT;
    
    INSERT INTO water_intake (user_id, amount_ml, logged_date)
    VALUES (p_user_id, p_amount_ml, p_date);
    
    SELECT SUM(amount_ml) INTO v_total
    FROM water_intake
    WHERE user_id = p_user_id AND logged_date = p_date;
    
    SELECT v_total AS total_ml,
           ROUND(v_total/1000, 2) AS total_liters,
           IF(v_total >= 3000, 'GOAL REACHED! 🎉', CONCAT(3000-v_total, 'ml remaining')) AS status;
END //

DELIMITER ;

-- ============================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================
CREATE INDEX idx_meal_logs_user_date ON meal_logs(user_id, logged_date);
CREATE INDEX idx_workout_logs_user_date ON workout_logs(user_id, logged_date);
CREATE INDEX idx_water_intake_user_date ON water_intake(user_id, logged_date);
CREATE INDEX idx_sleep_logs_user ON sleep_logs(user_id);
CREATE INDEX idx_notifications_user ON notifications(user_id, is_read);
CREATE INDEX idx_health_metrics_user ON health_metrics(user_id, recorded_at);

-- ============================================================
-- END OF SCHEMA
-- ============================================================
