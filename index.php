<?php
require_once "config.php";

$citizens = [];
$areas = [];

$citizen_result = mysqli_query(
    $conn,
    "SELECT citizen_id, full_name FROM citizens ORDER BY full_name"
);

if ($citizen_result) {
    while ($row = mysqli_fetch_assoc($citizen_result)) {
        $citizens[] = $row;
    }
}

$area_result = mysqli_query(
    $conn,
    "SELECT area_id, area_name FROM areas WHERE status = 'Active' ORDER BY area_name"
);

if ($area_result) {
    while ($row = mysqli_fetch_assoc($area_result)) {
        $areas[] = $row;
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NEXORA | Citizen Services</title>

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
        <a href="index.php" class="active">Home</a>
        <a href="view.php">Service Requests</a>
        <a href="search.php">Search</a>
    </nav>
</header>

<main>

    <section class="hero">
        <div class="hero-content">
            <span class="eyebrow">SMART CITY DIGITAL SERVICES</span>

            <h2>Citizen Service<br><strong>Request Portal</strong></h2>

            <p>
                Submit and track civic service requests through the
                NEXORA Smart City platform.
            </p>

            <div class="hero-stats">
                <div>
                    <strong>24×7</strong>
                    <span>Service Access</span>
                </div>

                <div>
                    <strong>Live</strong>
                    <span>Request Tracking</span>
                </div>

                <div>
                    <strong>Secure</strong>
                    <span>Database System</span>
                </div>
            </div>
        </div>

        <div class="hero-orbit">
            <div class="orbit-circle">
                <div class="city-core">N</div>
            </div>
        </div>
    </section>

    <section class="page-heading">
        <div>
            <span class="section-label">CITIZEN SERVICES</span>
            <h2>Submit a Service Request</h2>
            <p>
                Provide the required details and our city service team
                will process your request.
            </p>
        </div>

        <div class="secure-badge">
            <span class="status-dot"></span>
            Secure Submission
        </div>
    </section>

    <section class="content-grid">

        <div class="info-panel">

            <div class="info-card">
                <div class="info-icon">01</div>
                <div>
                    <h3>Submit</h3>
                    <p>Enter your service requirement using the form.</p>
                </div>
            </div>

            <div class="info-card">
                <div class="info-icon">02</div>
                <div>
                    <h3>Process</h3>
                    <p>Your request is stored securely in MySQL.</p>
                </div>
            </div>

            <div class="info-card">
                <div class="info-icon">03</div>
                <div>
                    <h3>Track</h3>
                    <p>Search your request and monitor its status.</p>
                </div>
            </div>

            <div class="quick-links">
                <h3>Quick Access</h3>

                <a href="view.php">
                    <span>View Requests</span>
                    <span>→</span>
                </a>

                <a href="search.php">
                    <span>Search Requests</span>
                    <span>→</span>
                </a>
            </div>

        </div>

        <div class="form-card">

            <div class="form-header">
                <div>
                    <span class="section-label">NEW REQUEST</span>
                    <h3>Service Details</h3>
                </div>

                <span class="required-note">* Required</span>
            </div>

            <form action="save.php" method="POST">

                <div class="form-row">

                    <div class="form-group">
                        <label for="citizen_id">
                            Citizen <span>*</span>
                        </label>

                        <select
                            id="citizen_id"
                            name="citizen_id"
                            required
                        >
                            <option value="">Select citizen</option>

                            <?php foreach ($citizens as $citizen): ?>
                                <option value="<?= (int)$citizen['citizen_id'] ?>">
                                    <?= htmlspecialchars($citizen['full_name']) ?>
                                </option>
                            <?php endforeach; ?>

                        </select>
                    </div>

                    <div class="form-group">
                        <label for="area_id">
                            Service Area <span>*</span>
                        </label>

                        <select
                            id="area_id"
                            name="area_id"
                            required
                        >
                            <option value="">Select area</option>

                            <?php foreach ($areas as $area): ?>
                                <option value="<?= (int)$area['area_id'] ?>">
                                    <?= htmlspecialchars($area['area_name']) ?>
                                </option>
                            <?php endforeach; ?>

                        </select>
                    </div>

                </div>

                <div class="form-group">
                    <label for="service_type">
                        Service Type <span>*</span>
                    </label>

                    <select
                        id="service_type"
                        name="service_type"
                        required
                    >
                        <option value="">Select service type</option>
                        <option value="Water Supply">Water Supply</option>
                        <option value="Waste Collection">Waste Collection</option>
                        <option value="Road Maintenance">Road Maintenance</option>
                        <option value="Street Light">Street Light</option>
                        <option value="Public Transport">Public Transport</option>
                        <option value="Drainage">Drainage</option>
                        <option value="Electricity">Electricity</option>
                        <option value="Other Civic Service">Other Civic Service</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="description">
                        Description
                    </label>

                    <textarea
                        id="description"
                        name="description"
                        maxlength="500"
                        rows="5"
                        placeholder="Describe the issue or service you require..."
                    ></textarea>

                    <small>Maximum 500 characters.</small>
                </div>

                <div class="form-row">

                    <div class="form-group">
                        <label for="priority">
                            Priority
                        </label>

                        <select id="priority" name="priority">
                            <option value="Low">Low</option>
                            <option value="Medium" selected>Medium</option>
                            <option value="High">High</option>
                            <option value="Critical">Critical</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="assigned_department">
                            Department
                        </label>

                        <select
                            id="assigned_department"
                            name="assigned_department"
                        >
                            <option value="">Select department</option>
                            <option value="Municipal Services">Municipal Services</option>
                            <option value="Water Department">Water Department</option>
                            <option value="Waste Management">Waste Management</option>
                            <option value="Road Maintenance">Road Maintenance</option>
                            <option value="Transport Department">Transport Department</option>
                            <option value="Electricity Department">Electricity Department</option>
                        </select>
                    </div>

                </div>

                <div class="form-footer">
                    <p>
                        Your information will be securely processed by
                        the NEXORA service system.
                    </p>

                    <button type="submit">
                        Submit Request
                        <span>→</span>
                    </button>
                </div>

            </form>

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