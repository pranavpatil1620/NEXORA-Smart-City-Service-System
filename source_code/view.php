
<?php

require_once "config.php";

$requests = [];

$sql = "
    SELECT
        sr.request_id,
        c.full_name AS citizen_name,
        a.area_name,
        sr.service_type,
        sr.description,
        sr.priority,
        sr.assigned_department,
        sr.status,
        sr.request_date
    FROM service_requests sr
    INNER JOIN citizens c
        ON sr.citizen_id = c.citizen_id
    INNER JOIN areas a
        ON sr.area_id = a.area_id
    ORDER BY sr.request_id DESC
";

$result = mysqli_query($conn, $sql);

if ($result) {
    while ($row = mysqli_fetch_assoc($result)) {
        $requests[] = $row;
    }
}

$total_requests = count($requests);

$pending_count = 0;
$resolved_count = 0;
$high_priority_count = 0;

foreach ($requests as $request) {

    if ($request["status"] === "Pending") {
        $pending_count++;
    }

    if ($request["status"] === "Resolved") {
        $resolved_count++;
    }

    if (
        $request["priority"] === "High" ||
        $request["priority"] === "Critical"
    ) {
        $high_priority_count++;
    }
}

?>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>NEXORA | Service Requests</title>

    <link rel="stylesheet" href="style.css">

    <style>

        .records-header {
            display: flex;
            justify-content: space-between;
            align-items: end;
            gap: 20px;
            margin-bottom: 22px;
        }

        .records-header h2 {
            font-size: 28px;
            margin-top: 7px;
        }

        .records-header p {
            color: #718ba5;
            font-size: 14px;
            margin-top: 7px;
        }

        .new-request-btn {
            text-decoration: none;
            background: #42b8ff;
            color: #06111d;
            padding: 12px 18px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 800;
            white-space: nowrap;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 22px;
        }

        .summary-card {
            background: #0b1728;
            border: 1px solid #1d3048;
            border-radius: 16px;
            padding: 20px;
        }

        .summary-card span {
            display: block;
            color: #718ba5;
            font-size: 11px;
            letter-spacing: 1px;
            margin-bottom: 9px;
        }

        .summary-card strong {
            font-size: 28px;
            color: #ffffff;
        }

        .table-card {
            background: #0b1728;
            border: 1px solid #1d3048;
            border-radius: 20px;
            overflow: hidden;
        }

        .table-top {
            padding: 20px 22px;
            border-bottom: 1px solid #1d3048;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-top h3 {
            font-size: 17px;
        }

        .record-count {
            color: #718ba5;
            font-size: 12px;
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1050px;
        }

        th {
            text-align: left;
            padding: 15px 18px;
            background: #0f2034;
            color: #83a0ba;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.7px;
            white-space: nowrap;
        }

        td {
            padding: 16px 18px;
            border-bottom: 1px solid #17283d;
            color: #c6d5e3;
            font-size: 12px;
            vertical-align: top;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tbody tr:hover {
            background: #0e1e31;
        }

        .request-id {
            color: #55c2ff;
            font-weight: 800;
        }

        .citizen-name {
            color: #ffffff;
            font-weight: 700;
        }

        .description-cell {
            max-width: 270px;
            line-height: 1.5;
            color: #8199b1;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: 700;
            white-space: nowrap;
        }

        .priority-low {
            background: #102c2a;
            color: #6fd5bb;
        }

        .priority-medium {
            background: #2d2b18;
            color: #d9ca73;
        }

        .priority-high {
            background: #34261a;
            color: #f0aa67;
        }

        .priority-critical {
            background: #381b20;
            color: #ff858d;
        }

        .status-pending {
            background: #302817;
            color: #e4c86d;
        }

        .status-resolved {
            background: #10352d;
            color: #70d8b2;
        }

        .status-progress {
            background: #132e45;
            color: #70c8f5;
        }

        .status-default {
            background: #1a2838;
            color: #91a9c1;
        }

        .empty-state {
            padding: 55px 25px;
            text-align: center;
        }

        .empty-state h3 {
            font-size: 20px;
            margin-bottom: 8px;
        }

        .empty-state p {
            color: #718ba5;
            font-size: 13px;
        }

        @media (max-width: 900px) {

            .summary-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .records-header {
                align-items: flex-start;
                flex-direction: column;
            }

        }

        @media (max-width: 550px) {

            .summary-grid {
                grid-template-columns: 1fr;
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

        <a href="index.php">
            Home
        </a>

        <a href="view.php" class="active">
            Service Requests
        </a>

        <a href="search.php">
            Search
        </a>

    </nav>

</header>

<main>

    <section class="records-header">

        <div>

            <span class="section-label">
                CITIZEN SERVICE DATABASE
            </span>

            <h2>
                Service Requests
            </h2>

            <p>
                Live records retrieved from the NEXORA MySQL database.
            </p>

        </div>

        <a
            href="index.php"
            class="new-request-btn"
        >
            + New Request
        </a>

    </section>

    <section class="summary-grid">

        <div class="summary-card">

            <span>
                TOTAL REQUESTS
            </span>

            <strong>
                <?= (int)$total_requests ?>
            </strong>

        </div>

        <div class="summary-card">

            <span>
                PENDING
            </span>

            <strong>
                <?= (int)$pending_count ?>
            </strong>

        </div>

        <div class="summary-card">

            <span>
                RESOLVED
            </span>

            <strong>
                <?= (int)$resolved_count ?>
            </strong>

        </div>

        <div class="summary-card">

            <span>
                HIGH PRIORITY
            </span>

            <strong>
                <?= (int)$high_priority_count ?>
            </strong>

        </div>

    </section>

    <section class="table-card">

        <div class="table-top">

            <h3>
                Request Records
            </h3>

            <span class="record-count">
                <?= (int)$total_requests ?> record(s)
            </span>

        </div>

        <?php if ($total_requests > 0): ?>

            <div class="table-wrapper">

                <table>

                    <thead>

                        <tr>

                            <th>
                                Request ID
                            </th>

                            <th>
                                Citizen
                            </th>

                            <th>
                                Area
                            </th>

                            <th>
                                Service
                            </th>

                            <th>
                                Description
                            </th>

                            <th>
                                Priority
                            </th>

                            <th>
                                Department
                            </th>

                            <th>
                                Status
                            </th>

                            <th>
                                Request Date
                            </th>

                        </tr>

                    </thead>

                    <tbody>

                        <?php foreach ($requests as $request): ?>

                            <?php

                            $priority_class = "priority-medium";

                            if ($request["priority"] === "Low") {
                                $priority_class = "priority-low";
                            }

                            if ($request["priority"] === "High") {
                                $priority_class = "priority-high";
                            }

                            if ($request["priority"] === "Critical") {
                                $priority_class = "priority-critical";
                            }

                            $status_class = "status-default";

                            if ($request["status"] === "Pending") {
                                $status_class = "status-pending";
                            }

                            if ($request["status"] === "Resolved") {
                                $status_class = "status-resolved";
                            }

                            if (
                                $request["status"] === "In Progress"
                            ) {
                                $status_class = "status-progress";
                            }

                            ?>

                            <tr>

                                <td>
                                    <span class="request-id">
                                        #<?= (int)$request["request_id"] ?>
                                    </span>
                                </td>

                                <td>
                                    <span class="citizen-name">
                                        <?= htmlspecialchars($request["citizen_name"]) ?>
                                    </span>
                                </td>

                                <td>
                                    <?= htmlspecialchars($request["area_name"]) ?>
                                </td>

                                <td>
                                    <?= htmlspecialchars($request["service_type"]) ?>
                                </td>

                                <td class="description-cell">
                                    <?= htmlspecialchars($request["description"] ?? "") ?>
                                </td>

                                <td>

                                    <span class="badge <?= $priority_class ?>">
                                        <?= htmlspecialchars($request["priority"]) ?>
                                    </span>

                                </td>

                                <td>
                                    <?= htmlspecialchars($request["assigned_department"] ?? "Not Assigned") ?>
                                </td>

                                <td>

                                    <span class="badge <?= $status_class ?>">
                                        <?= htmlspecialchars($request["status"]) ?>
                                    </span>

                                </td>

                                <td>
                                    <?= htmlspecialchars($request["request_date"]) ?>
                                </td>

                            </tr>

                        <?php endforeach; ?>

                    </tbody>

                </table>

            </div>

        <?php else: ?>

            <div class="empty-state">

                <h3>
                    No service requests found
                </h3>

                <p>
                    Submit your first citizen service request to create a record.
                </p>

            </div>

        <?php endif; ?>

    </section>

</main>

<footer>

    <div>

        <strong>
            NEXORA
        </strong>

        <span>
            Smart City Digital Twin
        </span>

    </div>

    <p>
        Citizen Service Management System
    </p>

</footer>

</body>

</html>

<?php

mysqli_close($conn);

?>

