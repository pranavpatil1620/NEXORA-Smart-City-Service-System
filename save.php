<?php

require_once "config.php";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    header("Location: index.php");
    exit;
}

$citizen_id = filter_input(INPUT_POST, "citizen_id", FILTER_VALIDATE_INT);
$area_id = filter_input(INPUT_POST, "area_id", FILTER_VALIDATE_INT);

$service_type = trim($_POST["service_type"] ?? "");
$description = trim($_POST["description"] ?? "");
$priority = trim($_POST["priority"] ?? "Medium");
$assigned_department = trim($_POST["assigned_department"] ?? "");

$allowed_services = [
    "Water Supply",
    "Waste Collection",
    "Road Maintenance",
    "Street Light",
    "Public Transport",
    "Drainage",
    "Electricity",
    "Other Civic Service"
];

$allowed_priorities = [
    "Low",
    "Medium",
    "High",
    "Critical"
];

$allowed_departments = [
    "Municipal Services",
    "Water Department",
    "Waste Management",
    "Road Maintenance",
    "Transport Department",
    "Electricity Department"
];

$errors = [];

if (!$citizen_id) {
    $errors[] = "Please select a valid citizen.";
}

if (!$area_id) {
    $errors[] = "Please select a valid service area.";
}

if ($service_type === "" || !in_array($service_type, $allowed_services, true)) {
    $errors[] = "Please select a valid service type.";
}

if (strlen($description) > 500) {
    $errors[] = "Description cannot exceed 500 characters.";
}

if (!in_array($priority, $allowed_priorities, true)) {
    $errors[] = "Please select a valid priority.";
}

if ($assigned_department !== "" && !in_array($assigned_department, $allowed_departments, true)) {
    $errors[] = "Please select a valid department.";
}

if (!empty($errors)) {
    ?>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>NEXORA | Validation Error</title>
        <link rel="stylesheet" href="style.css">
    </head>

    <body>

    <header class="topbar">
        <div class="brand">
            <div class="brand-icon">N</div>
            <div>
                <h1>NEXORA</h1>
                <span>Smart City Citizen Services</span>
            </div>
        </div>

        <nav>
            <a href="index.php">Home</a>
            <a href="view.php">Service Requests</a>
            <a href="search.php">Search</a>
        </nav>
    </header>

    <main>

        <section class="page-heading">
            <div>
                <span class="section-label">REQUEST VALIDATION</span>
                <h2>Unable to Submit Request</h2>
                <p>Please correct the following information and try again.</p>
            </div>
        </section>

        <section class="form-card">

            <div style="padding: 10px 0;">

                <?php foreach ($errors as $error): ?>

                    <div style="
                        background: #35191d;
                        border: 1px solid #7d3038;
                        color: #ffb3b8;
                        padding: 14px 16px;
                        border-radius: 10px;
                        margin-bottom: 10px;
                        font-size: 13px;
                    ">
                        <?= htmlspecialchars($error) ?>
                    </div>

                <?php endforeach; ?>

                <a
                    href="index.php"
                    style="
                        display: inline-block;
                        margin-top: 12px;
                        background: #42b8ff;
                        color: #06111d;
                        text-decoration: none;
                        padding: 13px 20px;
                        border-radius: 10px;
                        font-size: 13px;
                        font-weight: 700;
                    "
                >
                    ← Back to Form
                </a>

            </div>

        </section>

    </main>

    <footer>
        <div>
            <strong>NEXORA</strong>
            <span>Smart City Digital Twin</span>
        </div>

        <p>Citizen Service Management System</p>
    </footer>

    </body>
    </html>
    <?php
    exit;
}

$sql = "
    INSERT INTO service_requests
    (
        citizen_id,
        area_id,
        service_type,
        description,
        priority,
        assigned_department,
        status
    )
    VALUES (?, ?, ?, ?, ?, ?, 'Pending')
";

$stmt = mysqli_prepare($conn, $sql);

if (!$stmt) {
    die("Unable to process the request.");
}

mysqli_stmt_bind_param(
    $stmt,
    "iissss",
    $citizen_id,
    $area_id,
    $service_type,
    $description,
    $priority,
    $assigned_department
);

if (mysqli_stmt_execute($stmt)) {

    $request_id = mysqli_insert_id($conn);

    mysqli_stmt_close($stmt);
    mysqli_close($conn);

    ?>

    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>NEXORA | Request Submitted</title>

        <link rel="stylesheet" href="style.css">

        <style>
            .success-wrapper {
                min-height: 55vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .success-card {
                width: 100%;
                max-width: 650px;
                background: #0b1728;
                border: 1px solid #1d3048;
                border-radius: 22px;
                padding: 42px;
                text-align: center;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
            }

            .success-icon {
                width: 76px;
                height: 76px;
                margin: 0 auto 22px;
                border-radius: 50%;
                background: #10382f;
                border: 2px solid #37d69a;
                color: #37d69a;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 34px;
                font-weight: 800;
                box-shadow: 0 0 30px rgba(55, 214, 154, 0.15);
            }

            .success-card .section-label {
                display: block;
                margin-bottom: 8px;
            }

            .success-card h2 {
                font-size: 30px;
                margin-bottom: 12px;
            }

            .success-card p {
                color: #7f98b1;
                font-size: 14px;
                line-height: 1.7;
            }

            .request-number {
                margin: 25px auto;
                padding: 17px;
                background: #0f2034;
                border: 1px solid #1c4057;
                border-radius: 12px;
            }

            .request-number span {
                display: block;
                color: #718ba5;
                font-size: 11px;
                letter-spacing: 1.5px;
                margin-bottom: 7px;
            }

            .request-number strong {
                color: #55c2ff;
                font-size: 24px;
            }

            .success-actions {
                display: flex;
                justify-content: center;
                gap: 12px;
                margin-top: 25px;
            }

            .success-actions a {
                text-decoration: none;
                padding: 12px 18px;
                border-radius: 10px;
                font-size: 13px;
                font-weight: 700;
            }

            .primary-action {
                background: #42b8ff;
                color: #06111d;
            }

            .secondary-action {
                background: #142a43;
                border: 1px solid #254766;
                color: #b8cee2;
            }

            @media (max-width: 600px) {
                .success-card {
                    padding: 28px 20px;
                }

                .success-actions {
                    flex-direction: column;
                }

                .success-actions a {
                    width: 100%;
                }
            }
        </style>

    </head>

    <body>

    <header class="topbar">

        <div class="brand">

            <div class="brand-icon">N</div>

            <div>
                <h1>NEXORA</h1>
                <span>Smart City Citizen Services</span>
            </div>

        </div>

        <nav>
            <a href="index.php">Home</a>
            <a href="view.php">Service Requests</a>
            <a href="search.php">Search</a>
        </nav>

    </header>

    <main>

        <section class="success-wrapper">

            <div class="success-card">

                <div class="success-icon">✓</div>

                <span class="section-label">REQUEST REGISTERED</span>

                <h2>Service Request Submitted</h2>

                <p>
                    Your civic service request has been successfully
                    stored in the NEXORA database.
                </p>

                <div class="request-number">

                    <span>REQUEST ID</span>

                    <strong>#<?= (int)$request_id ?></strong>

                </div>

                <p>
                    Status:
                    <strong style="color: #70d8b2;">Pending</strong>
                </p>

                <div class="success-actions">

                    <a
                        href="index.php"
                        class="primary-action"
                    >
                        Submit Another
                    </a>

                    <a
                        href="view.php"
                        class="secondary-action"
                    >
                        View Requests
                    </a>

                </div>

            </div>

        </section>

    </main>

    <footer>

        <div>
            <strong>NEXORA</strong>
            <span>Smart City Digital Twin</span>
        </div>

        <p>Citizen Service Management System</p>

    </footer>

    </body>
    </html>

    <?php

} else {

    mysqli_stmt_close($stmt);
    mysqli_close($conn);

    ?>

    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>NEXORA | Request Error</title>

        <link rel="stylesheet" href="style.css">
    </head>

    <body>

    <header class="topbar">

        <div class="brand">
            <div class="brand-icon">N</div>

            <div>
                <h1>NEXORA</h1>
                <span>Smart City Citizen Services</span>
            </div>
        </div>

        <nav>
            <a href="index.php">Home</a>
            <a href="view.php">Service Requests</a>
            <a href="search.php">Search</a>
        </nav>

    </header>

    <main>

        <section class="page-heading">
            <div>
                <span class="section-label">SYSTEM RESPONSE</span>
                <h2>Request Could Not Be Saved</h2>
                <p>
                    The request could not be processed at this time.
                    Please try again.
                </p>
            </div>
        </section>

        <section class="form-card">

            <a
                href="index.php"
                style="
                    display: inline-block;
                    background: #42b8ff;
                    color: #06111d;
                    text-decoration: none;
                    padding: 13px 20px;
                    border-radius: 10px;
                    font-size: 13px;
                    font-weight: 700;
                "
            >
                ← Return to Form
            </a>

        </section>

    </main>

    <footer>

        <div>
            <strong>NEXORA</strong>
            <span>Smart City Digital Twin</span>
        </div>

        <p>Citizen Service Management System</p>

    </footer>

    </body>
    </html>

    <?php
}

?>