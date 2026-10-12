
<?php

require_once "config.php";

$search = trim($_GET["search"] ?? "");
$priority = trim($_GET["priority"] ?? "");
$status = trim($_GET["status"] ?? "");

$results = [];

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
    WHERE
        (
            c.full_name LIKE ?
            OR a.area_name LIKE ?
            OR sr.service_type LIKE ?
            OR sr.description LIKE ?
        )
        AND sr.priority LIKE ?
        AND sr.status LIKE ?
    ORDER BY sr.request_id DESC
";

$stmt = mysqli_prepare($conn, $sql);

if ($stmt) {

    $search_value = "%" . $search . "%";
    $priority_value = $priority === "" ? "%" : $priority;
    $status_value = $status === "" ? "%" : $status;

    mysqli_stmt_bind_param(
        $stmt,
        "ssssss",
        $search_value,
        $search_value,
        $search_value,
        $search_value,
        $priority_value,
        $status_value
    );

    mysqli_stmt_execute($stmt);

    $result = mysqli_stmt_get_result($stmt);

    if ($result) {

        while ($row = mysqli_fetch_assoc($result)) {
            $results[] = $row;
        }

    }

    mysqli_stmt_close($stmt);
}

$result_count = count($results);

?>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>NEXORA | Search Requests</title>

    <link rel="stylesheet" href="style.css">

    <style>

        .search-header {
            margin-bottom: 22px;
        }

        .search-header h2 {
            font-size: 29px;
            margin-top: 7px;
        }

        .search-header p {
            color: #718ba5;
            font-size: 14px;
            margin-top: 7px;
        }

        .search-card {
            background: #0b1728;
            border: 1px solid #1d3048;
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 22px;
        }

        .search-form {
            display: grid;
            grid-template-columns: 1.6fr 1fr 1fr auto;
            gap: 14px;
            align-items: end;
        }

        .search-group label {
            display: block;
            color: #b7c9da;
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .search-group input,
        .search-group select {
            width: 100%;
            background: #081522;
            border: 1px solid #213952;
            border-radius: 10px;
            color: #eaf2ff;
            padding: 13px 14px;
            font-family: inherit;
            font-size: 13px;
            outline: none;
        }

        .search-group input:focus,
        .search-group select:focus {
            border-color: #42b8ff;
            box-shadow: 0 0 0 3px rgba(66, 184, 255, 0.08);
        }

        .search-button {
            border: none;
            background: #42b8ff;
            color: #06111d;
            padding: 13px 20px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 800;
            cursor: pointer;
            white-space: nowrap;
        }

        .reset-button {
            display: inline-block;
            margin-left: 7px;
            padding: 12px 16px;
            border-radius: 10px;
            border: 1px solid #294560;
            background: #142a43;
            color: #a8bfd4;
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
        }

        .result-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .result-info h3 {
            font-size: 17px;
        }

        .result-info span {
            color: #718ba5;
            font-size: 12px;
        }

        .results-card {
            background: #0b1728;
            border: 1px solid #1d3048;
            border-radius: 20px;
            overflow: hidden;
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

        tbody tr:last-child td {
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

        .empty-state-icon {
            width: 58px;
            height: 58px;
            margin: 0 auto 15px;
            border-radius: 16px;
            background: #142a43;
            border: 1px solid #254766;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #55c2ff;
            font-size: 24px;
        }

        .empty-state h3 {
            font-size: 19px;
            margin-bottom: 7px;
        }

        .empty-state p {
            color: #718ba5;
            font-size: 13px;
        }

        @media (max-width: 1000px) {

            .search-form {
                grid-template-columns: 1fr 1fr;
            }

        }

        @media (max-width: 600px) {

            .search-form {
                grid-template-columns: 1fr;
            }

            .result-info {
                align-items: flex-start;
                flex-direction: column;
                gap: 6px;
            }

        }

    </style>

</head>

<body>

<header class="topbar">

    <div class="brand">

        <div class="brand-icon">
            N
        </div>

        <div>

            <h1>
                NEXORA
            </h1>

            <span>
                Smart City Citizen Services
            </span>

        </div>

    </div>

    <nav>

        <a href="index.php">
            Home
        </a>

        <a href="view.php">
            Service Requests
        </a>

        <a href="search.php" class="active">
            Search
        </a>

    </nav>

</header>

<main>

    <section class="search-header">

        <span class="section-label">
            SERVICE REQUEST INTELLIGENCE
        </span>

        <h2>
            Search & Filter Requests
        </h2>

        <p>
            Find citizen service records using secure database filtering.
        </p>

    </section>

    <section class="search-card">

        <form
            method="GET"
            action="search.php"
            class="search-form"
        >

            <div class="search-group">

                <label for="search">
                    Search
                </label>

                <input
                    type="text"
                    id="search"
                    name="search"
                    value="<?= htmlspecialchars($search) ?>"
                    maxlength="100"
                    placeholder="Citizen, area, service or keyword"
                >

            </div>

            <div class="search-group">

                <label for="priority">
                    Priority
                </label>

                <select
                    id="priority"
                    name="priority"
                >

                    <option value="">
                        All Priorities
                    </option>

                    <option
                        value="Low"
                        <?= $priority === "Low" ? "selected" : "" ?>
                    >
                        Low
                    </option>

                    <option
                        value="Medium"
                        <?= $priority === "Medium" ? "selected" : "" ?>
                    >
                        Medium
                    </option>

                    <option
                        value="High"
                        <?= $priority === "High" ? "selected" : "" ?>
                    >
                        High
                    </option>

                    <option
                        value="Critical"
                        <?= $priority === "Critical" ? "selected" : "" ?>
                    >
                        Critical
                    </option>

                </select>

            </div>

            <div class="search-group">

                <label for="status">
                    Status
                </label>

                <select
                    id="status"
                    name="status"
                >

                    <option value="">
                        All Statuses
                    </option>

                    <option
                        value="Pending"
                        <?= $status === "Pending" ? "selected" : "" ?>
                    >
                        Pending
                    </option>

                    <option
                        value="In Progress"
                        <?= $status === "In Progress" ? "selected" : "" ?>
                    >
                        In Progress
                    </option>

                    <option
                        value="Resolved"
                        <?= $status === "Resolved" ? "selected" : "" ?>
                    >
                        Resolved
                    </option>

                </select>

            </div>

            <div>

                <button
                    type="submit"
                    class="search-button"
                >
                    Search →
                </button>

                <a
                    href="search.php"
                    class="reset-button"
                >
                    Reset
                </a>

            </div>

        </form>

    </section>

    <div class="result-info">

        <h3>
            Search Results
        </h3>

        <span>
            <?= (int)$result_count ?> matching record(s)
        </span>

    </div>

    <section class="results-card">

        <?php if ($result_count > 0): ?>

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

                        <?php foreach ($results as $request): ?>

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

                            if ($request["status"] === "In Progress") {
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
                                    <?= htmlspecialchars(
                                        $request["assigned_department"] ?? "Not Assigned"
                                    ) ?>
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

                <div class="empty-state-icon">
                    ?
                </div>

                <h3>
                    No matching requests
                </h3>

                <p>
                    Try another keyword or change the filters.
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

