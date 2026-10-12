# NEXORA — Smart City Citizen Service Request Management System

A web-based application for managing citizen service requests through a centralized PHP and MySQL system.

## Overview

NEXORA is designed to organize citizen service information and make service records easier to create, view, search, and manage. The project demonstrates how a web interface can connect to a relational database to support a structured citizen-service workflow.

**Live demo:** https://nexora-city.infinityfreeapp.com/

## Problem Statement

Citizen-service information can become difficult to organize when requests and related records are maintained in separate or manual processes. NEXORA provides a centralized web application and database structure to help organize this information.

## Objectives

* Provide a web interface for citizen-service record management.
* Store application records in a MySQL database.
* Support viewing, searching, and filtering records where implemented.
* Demonstrate PHP-to-MySQL connectivity.
* Apply relational database concepts through structured tables and relationships.

## Features

* Web-based user interface.
* Create and view service records.
* Search and filter records, where available in the implemented pages.
* Centralized MySQL data storage.
* PHP backend for database operations.
* Hosted demonstration website.

> The available features depend on the modules included in the current source code. Update this list if a feature is not implemented in your version.

## Technology Stack

|Layer|Technology|
|-|-|
|Frontend|HTML, CSS, JavaScript|
|Backend|PHP|
|Database|MySQL|
|Local development|XAMPP|
|Database administration|phpMyAdmin|
|Hosting|InfinityFree|

## Repository Structure

```text
NEXORA-Smart-City-Service-System/
├── source\_code/                  # Application source files
├── database/
│   └── nexora\_database.sql   # Schema-only database script
├── report/
│   └── NEXORA\_Report.pdf
└── README.md
```

This is a suggested structure. Keep the repository structure consistent with the folders you actually upload.

## Requirements

* XAMPP (Apache, PHP, and MySQL/MariaDB)
* A modern web browser
* The project source code
* The schema-only SQL file

## Run Locally

1. Install and open XAMPP.
2. Start **Apache** and **MySQL**.
3. Copy the project folder into XAMPP's `htdocs` directory.
4. Open phpMyAdmin at `http://localhost/phpmyadmin/`.
5. Create the database expected by the project configuration.
6. Import `database/nexora\_database.sql`.
7. Configure the application's database connection using your own local credentials. Do not copy production credentials into the repository.
8. Open the project in your browser. For a folder named `NEXORA`, use `http://localhost/NEXORA/`.

> Database name, table structure, and configuration file names must match the actual SQL and source code. If your local setup uses different values, adjust these steps accordingly.

## Database

The project uses MySQL for storing application data. The `database/` folder is intended to contain a **schema-only** SQL script for creating the tables and relationships without publishing real personal records.

## Project Report and Screenshots

The detailed project report is provided as a PDF in the `report/` folder. It contains the project's documentation and screenshots. You can open the PDF directly from the repository.

## Security and Privacy

* Never commit real database passwords, API keys, or hosting credentials.
* Do not upload production configuration files containing secrets.
* Use a schema-only SQL file for a public repository; exclude real citizen or test records that contain personal information.
* Review screenshots and reports for passwords, private details, or personal data before publishing.
* If you need to show the expected database settings, create a `config.php` file with placeholder values only.

## License

No open-source license has been assigned to this repository. Unless a license is added, others should not assume they have permission to reuse, modify, or redistribute the code.

## Author

Developed as a student project.

