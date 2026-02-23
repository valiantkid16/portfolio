<?php
// ============================================================
// VITACORE - Backend Configuration (PHP + MySQL)
// Student: Kiran Kumar K.R | D.NO: 23UCS553 | BSc CS "A"
// ============================================================

// db_config.php - Database Connection
define('DB_HOST', 'localhost');
define('DB_USER', 'root');           // Change to your MySQL username
define('DB_PASS', '');               // Change to your MySQL password
define('DB_NAME', 'vitacore_db');
define('JWT_SECRET', 'vitacore_secret_key_2025');

function getDBConnection() {
    $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
    if ($conn->connect_error) {
        http_response_code(500);
        die(json_encode(['error' => 'Database connection failed: ' . $conn->connect_error]));
    }
    $conn->set_charset('utf8mb4');
    return $conn;
}

function jsonResponse($data, $code = 200) {
    http_response_code($code);
    header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
    header('Access-Control-Allow-Headers: Content-Type, Authorization');
    echo json_encode($data);
    exit;
}

// ============================================================
// USER REGISTRATION: /api/register.php
// ============================================================
/*
POST /api/register.php
Body: { first_name, last_name, email, password, role, age, gender, height_cm, weight_kg }
*/
function registerUser($data) {
    $conn = getDBConnection();
    $email = $conn->real_escape_string($data['email']);
    $check = $conn->query("SELECT user_id FROM users WHERE email='$email'");
    if ($check->num_rows > 0) {
        jsonResponse(['error' => 'Email already registered'], 409);
    }
    $hash = password_hash($data['password'], PASSWORD_BCRYPT);
    $stmt = $conn->prepare("INSERT INTO users (first_name, last_name, email, password_hash, role, age, gender, height_cm, weight_kg) VALUES (?,?,?,?,?,?,?,?,?)");
    $stmt->bind_param('sssssisdd', $data['first_name'], $data['last_name'], $data['email'], $hash, $data['role'] ?? 'user', $data['age'] ?? null, $data['gender'] ?? null, $data['height_cm'] ?? null, $data['weight_kg'] ?? null);
    if ($stmt->execute()) {
        $userId = $conn->insert_id;
        $conn->close();
        jsonResponse(['success' => true, 'user_id' => $userId, 'message' => 'Account created successfully!']);
    }
    jsonResponse(['error' => 'Registration failed'], 500);
}

// ============================================================
// USER LOGIN: /api/login.php
// ============================================================
/*
POST /api/login.php
Body: { email, password }
*/
function loginUser($email, $password) {
    $conn = getDBConnection();
    $email = $conn->real_escape_string($email);
    $result = $conn->query("SELECT user_id, first_name, last_name, email, password_hash, role FROM users WHERE email='$email' AND is_active=1");
    if ($result->num_rows === 0) {
        jsonResponse(['error' => 'Invalid email or password'], 401);
    }
    $user = $result->fetch_assoc();
    if (!password_verify($password, $user['password_hash'])) {
        jsonResponse(['error' => 'Invalid email or password'], 401);
    }
    // Simple token (use JWT library in production)
    $token = base64_encode(json_encode(['user_id' => $user['user_id'], 'role' => $user['role'], 'exp' => time() + 86400]));
    unset($user['password_hash']);
    $conn->close();
    jsonResponse(['success' => true, 'token' => $token, 'user' => $user]);
}

// ============================================================
// LOG MEAL: /api/meal_log.php
// ============================================================
/*
POST /api/meal_log.php
Body: { user_id, food_id, meal_type, quantity_g, logged_date }
*/
function logMeal($data) {
    $conn = getDBConnection();
    $food = $conn->query("SELECT calories, protein_g, carbs_g, fat_g, serving_size_g FROM food_items WHERE food_id={$data['food_id']}")->fetch_assoc();
    if (!$food) { jsonResponse(['error' => 'Food not found'], 404); }
    $ratio = $data['quantity_g'] / $food['serving_size_g'];
    $cal = round($food['calories'] * $ratio, 2);
    $pro = round($food['protein_g'] * $ratio, 2);
    $carb = round($food['carbs_g'] * $ratio, 2);
    $fat = round($food['fat_g'] * $ratio, 2);
    $stmt = $conn->prepare("INSERT INTO meal_logs (user_id, food_id, meal_type, quantity_g, calories, protein_g, carbs_g, fat_g, logged_date) VALUES (?,?,?,?,?,?,?,?,?)");
    $stmt->bind_param('iiisdddds', $data['user_id'], $data['food_id'], $data['meal_type'], $data['quantity_g'], $cal, $pro, $carb, $fat, $data['logged_date']);
    $stmt->execute();
    jsonResponse(['success' => true, 'log_id' => $conn->insert_id, 'calories' => $cal, 'protein' => $pro, 'carbs' => $carb, 'fat' => $fat]);
}

// ============================================================
// GET DAILY SUMMARY: /api/daily_summary.php?user_id=X&date=YYYY-MM-DD
// ============================================================
function getDailySummary($userId, $date) {
    $conn = getDBConnection();
    $result = $conn->query("SELECT total_calories, total_protein, total_carbs, total_fat, meal_count FROM daily_calorie_summary WHERE user_id=$userId AND logged_date='$date'");
    $summary = $result->num_rows > 0 ? $result->fetch_assoc() : ['total_calories'=>0,'total_protein'=>0,'total_carbs'=>0,'total_fat'=>0,'meal_count'=>0];
    // Get water
    $water = $conn->query("SELECT SUM(amount_ml) AS total FROM water_intake WHERE user_id=$userId AND logged_date='$date'")->fetch_assoc();
    $summary['water_ml'] = $water['total'] ?? 0;
    // Get workout
    $workout = $conn->query("SELECT SUM(calories_burned) AS burned, SUM(duration_min) AS mins FROM workout_logs WHERE user_id=$userId AND logged_date='$date'")->fetch_assoc();
    $summary['calories_burned'] = $workout['burned'] ?? 0;
    $summary['workout_minutes'] = $workout['mins'] ?? 0;
    $conn->close();
    jsonResponse($summary);
}

// ============================================================
// SEARCH FOODS: /api/search_food.php?q=chicken
// ============================================================
function searchFoods($query) {
    $conn = getDBConnection();
    $q = $conn->real_escape_string($query);
    $result = $conn->query("SELECT food_id, food_name, category, calories, protein_g, carbs_g, fat_g, fiber_g, serving_size_g FROM food_items WHERE food_name LIKE '%$q%' LIMIT 20");
    $foods = [];
    while ($row = $result->fetch_assoc()) $foods[] = $row;
    $conn->close();
    jsonResponse(['results' => $foods, 'count' => count($foods)]);
}

// ============================================================
// GET USER PROFILE: /api/user_profile.php?user_id=X
// ============================================================
function getUserProfile($userId) {
    $conn = getDBConnection();
    $result = $conn->query("SELECT * FROM user_health_overview WHERE user_id=$userId");
    if ($result->num_rows === 0) jsonResponse(['error' => 'User not found'], 404);
    $user = $result->fetch_assoc();
    // Get recent metrics
    $metrics = $conn->query("SELECT * FROM health_metrics WHERE user_id=$userId ORDER BY recorded_at DESC LIMIT 1")->fetch_assoc();
    $user['latest_metrics'] = $metrics;
    $conn->close();
    jsonResponse($user);
}

// ============================================================
// LOG WORKOUT: /api/workout_log.php
// ============================================================
function logWorkout($data) {
    $conn = getDBConnection();
    $stmt = $conn->prepare("INSERT INTO workout_logs (user_id, workout_name, workout_type, duration_min, calories_burned, distance_km, logged_date, notes) VALUES (?,?,?,?,?,?,?,?)");
    $stmt->bind_param('issiidss', $data['user_id'], $data['workout_name'], $data['workout_type'], $data['duration_min'], $data['calories_burned'], $data['distance_km'] ?? 0, $data['logged_date'], $data['notes'] ?? '');
    $stmt->execute();
    jsonResponse(['success' => true, 'wlog_id' => $conn->insert_id]);
}

// ============================================================
// SEND NOTIFICATION: Internal use
// ============================================================
function sendNotification($userId, $title, $message, $type = 'info') {
    $conn = getDBConnection();
    $stmt = $conn->prepare("INSERT INTO notifications (user_id, title, message, type) VALUES (?,?,?,?)");
    $stmt->bind_param('isss', $userId, $title, $message, $type);
    $stmt->execute();
    $conn->close();
}

// ============================================================
// ROUTER (Entry Point)
// ============================================================
/*
To use: Create individual PHP files and include this config.

Example structure:
/api/
  register.php
  login.php
  meal_log.php
  search_food.php
  daily_summary.php
  user_profile.php
  workout_log.php
  water_log.php
  notifications.php

Each file calls the corresponding function above.
*/
?>
