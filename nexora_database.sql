-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: nexora
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ambulances`
--

DROP TABLE IF EXISTS `ambulances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ambulances` (
  `ambulance_id` int NOT NULL AUTO_INCREMENT,
  `ambulance_number` varchar(30) NOT NULL,
  `area_id` int NOT NULL,
  `driver_name` varchar(100) NOT NULL,
  `driver_phone` varchar(15) DEFAULT NULL,
  `ambulance_type` varchar(50) DEFAULT 'Basic',
  `status` varchar(30) DEFAULT 'Available',
  `current_location` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`ambulance_id`),
  UNIQUE KEY `ambulance_number` (`ambulance_number`),
  KEY `fk_ambulance_area` (`area_id`),
  KEY `idx_ambulances_status` (`status`),
  CONSTRAINT `fk_ambulance_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`area_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `areas`
--

DROP TABLE IF EXISTS `areas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `areas` (
  `area_id` int NOT NULL AUTO_INCREMENT,
  `area_name` varchar(100) NOT NULL,
  `city_zone` varchar(50) NOT NULL,
  `population` int DEFAULT '0',
  `area_type` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Active',
  PRIMARY KEY (`area_id`),
  UNIQUE KEY `area_name` (`area_name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_log` (
  `audit_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `action_type` varchar(50) NOT NULL,
  `table_name` varchar(100) NOT NULL,
  `record_id` int DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `action_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`audit_id`),
  KEY `fk_audit_user` (`user_id`),
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `chk_audit_action` CHECK ((`action_type` in (_utf8mb4'INSERT',_utf8mb4'UPDATE',_utf8mb4'DELETE',_utf8mb4'LOGIN',_utf8mb4'LOGOUT',_utf8mb4'VIEW')))
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `beds`
--

DROP TABLE IF EXISTS `beds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `beds` (
  `bed_id` int NOT NULL AUTO_INCREMENT,
  `hospital_id` int NOT NULL,
  `bed_number` varchar(20) NOT NULL,
  `bed_type` varchar(50) DEFAULT 'General',
  `status` varchar(30) DEFAULT 'Available',
  PRIMARY KEY (`bed_id`),
  UNIQUE KEY `uq_hospital_bed` (`hospital_id`,`bed_number`),
  CONSTRAINT `fk_bed_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`hospital_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `citizens`
--

DROP TABLE IF EXISTS `citizens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `citizens` (
  `citizen_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `area` varchar(100) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `registration_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`citizen_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `doctors`
--

DROP TABLE IF EXISTS `doctors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctors` (
  `doctor_id` int NOT NULL AUTO_INCREMENT,
  `hospital_id` int NOT NULL,
  `doctor_name` varchar(100) NOT NULL,
  `specialization` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `experience_years` int DEFAULT '0',
  `availability_status` varchar(30) DEFAULT 'Available',
  PRIMARY KEY (`doctor_id`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_doctor_hospital` (`hospital_id`),
  CONSTRAINT `fk_doctor_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`hospital_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `drivers`
--

DROP TABLE IF EXISTS `drivers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drivers` (
  `driver_id` int NOT NULL AUTO_INCREMENT,
  `transport_id` int NOT NULL,
  `driver_name` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `license_number` varchar(50) NOT NULL,
  `experience_years` int DEFAULT '0',
  `shift` varchar(30) DEFAULT NULL,
  `status` varchar(30) DEFAULT 'Available',
  PRIMARY KEY (`driver_id`),
  UNIQUE KEY `license_number` (`license_number`),
  KEY `fk_driver_transport` (`transport_id`),
  CONSTRAINT `fk_driver_transport` FOREIGN KEY (`transport_id`) REFERENCES `transport` (`transport_id`),
  CONSTRAINT `chk_driver_status` CHECK ((`status` in (_utf8mb4'Available',_utf8mb4'On Duty',_utf8mb4'Off Duty',_utf8mb4'Inactive')))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `emergency_teams`
--

DROP TABLE IF EXISTS `emergency_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emergency_teams` (
  `team_id` int NOT NULL AUTO_INCREMENT,
  `team_name` varchar(100) NOT NULL,
  `area_id` int NOT NULL,
  `team_type` varchar(50) NOT NULL,
  `contact_number` varchar(15) DEFAULT NULL,
  `members_count` int DEFAULT '1',
  `status` varchar(30) DEFAULT 'Available',
  PRIMARY KEY (`team_id`),
  KEY `fk_team_area` (`area_id`),
  KEY `idx_emergency_teams_status` (`status`),
  CONSTRAINT `fk_team_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`area_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `feedback_id` int NOT NULL AUTO_INCREMENT,
  `citizen_id` int NOT NULL,
  `service_type` varchar(80) NOT NULL,
  `reference_id` int DEFAULT NULL,
  `rating` int NOT NULL,
  `comments` varchar(500) DEFAULT NULL,
  `feedback_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) DEFAULT 'Active',
  PRIMARY KEY (`feedback_id`),
  KEY `fk_feedback_citizen` (`citizen_id`),
  CONSTRAINT `fk_feedback_citizen` FOREIGN KEY (`citizen_id`) REFERENCES `citizens` (`citizen_id`),
  CONSTRAINT `chk_feedback_rating` CHECK ((`rating` between 1 and 5)),
  CONSTRAINT `chk_feedback_status` CHECK ((`status` in (_utf8mb4'Active',_utf8mb4'Reviewed',_utf8mb4'Archived')))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `hospitals`
--

DROP TABLE IF EXISTS `hospitals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hospitals` (
  `hospital_id` int NOT NULL AUTO_INCREMENT,
  `hospital_name` varchar(150) NOT NULL,
  `area_id` int NOT NULL,
  `address` varchar(255) NOT NULL,
  `contact_number` varchar(15) DEFAULT NULL,
  `total_beds` int NOT NULL DEFAULT '0',
  `emergency_available` tinyint(1) DEFAULT '1',
  `hospital_type` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Active',
  PRIMARY KEY (`hospital_id`),
  KEY `fk_hospital_area` (`area_id`),
  CONSTRAINT `fk_hospital_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`area_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `incident_assignments`
--

DROP TABLE IF EXISTS `incident_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incident_assignments` (
  `assignment_id` int NOT NULL AUTO_INCREMENT,
  `incident_id` int NOT NULL,
  `ambulance_id` int DEFAULT NULL,
  `team_id` int DEFAULT NULL,
  `assigned_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `arrived_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `assignment_status` varchar(30) DEFAULT 'Assigned',
  PRIMARY KEY (`assignment_id`),
  KEY `fk_assignment_incident` (`incident_id`),
  KEY `fk_assignment_ambulance` (`ambulance_id`),
  KEY `fk_assignment_team` (`team_id`),
  CONSTRAINT `fk_assignment_ambulance` FOREIGN KEY (`ambulance_id`) REFERENCES `ambulances` (`ambulance_id`),
  CONSTRAINT `fk_assignment_incident` FOREIGN KEY (`incident_id`) REFERENCES `incidents` (`incident_id`),
  CONSTRAINT `fk_assignment_team` FOREIGN KEY (`team_id`) REFERENCES `emergency_teams` (`team_id`),
  CONSTRAINT `chk_assignment_status` CHECK ((`assignment_status` in (_utf8mb4'Assigned',_utf8mb4'Dispatched',_utf8mb4'Arrived',_utf8mb4'Completed',_utf8mb4'Cancelled')))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `incidents`
--

DROP TABLE IF EXISTS `incidents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incidents` (
  `incident_id` int NOT NULL AUTO_INCREMENT,
  `citizen_id` int DEFAULT NULL,
  `area_id` int NOT NULL,
  `incident_type` varchar(50) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `severity` varchar(20) DEFAULT 'Medium',
  `incident_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `location` varchar(255) NOT NULL,
  `status` varchar(30) DEFAULT 'Reported',
  PRIMARY KEY (`incident_id`),
  KEY `fk_incident_citizen` (`citizen_id`),
  KEY `fk_incident_area` (`area_id`),
  KEY `idx_incidents_status` (`status`),
  CONSTRAINT `fk_incident_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`area_id`),
  CONSTRAINT `fk_incident_citizen` FOREIGN KEY (`citizen_id`) REFERENCES `citizens` (`citizen_id`),
  CONSTRAINT `chk_incident_severity` CHECK ((`severity` in (_utf8mb4'Low',_utf8mb4'Medium',_utf8mb4'High',_utf8mb4'Critical'))),
  CONSTRAINT `chk_incident_status` CHECK ((`status` in (_utf8mb4'Reported',_utf8mb4'Assigned',_utf8mb4'In Progress',_utf8mb4'Resolved',_utf8mb4'Cancelled')))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `citizen_id` int DEFAULT NULL,
  `title` varchar(150) NOT NULL,
  `message` varchar(500) NOT NULL,
  `notification_type` varchar(50) DEFAULT 'General',
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `fk_notification_user` (`user_id`),
  KEY `fk_notification_citizen` (`citizen_id`),
  CONSTRAINT `fk_notification_citizen` FOREIGN KEY (`citizen_id`) REFERENCES `citizens` (`citizen_id`),
  CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `chk_notification_type` CHECK ((`notification_type` in (_utf8mb4'General',_utf8mb4'Emergency',_utf8mb4'Parking',_utf8mb4'Healthcare',_utf8mb4'Traffic',_utf8mb4'Service',_utf8mb4'Payment')))
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `parking_areas`
--

DROP TABLE IF EXISTS `parking_areas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parking_areas` (
  `parking_area_id` int NOT NULL AUTO_INCREMENT,
  `area_id` int NOT NULL,
  `parking_name` varchar(120) NOT NULL,
  `address` varchar(255) NOT NULL,
  `total_slots` int NOT NULL DEFAULT '0',
  `available_slots` int NOT NULL DEFAULT '0',
  `parking_type` varchar(50) DEFAULT 'Public',
  `hourly_rate` decimal(8,2) DEFAULT '0.00',
  `status` varchar(20) DEFAULT 'Open',
  PRIMARY KEY (`parking_area_id`),
  KEY `fk_parking_area` (`area_id`),
  CONSTRAINT `fk_parking_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`area_id`),
  CONSTRAINT `chk_parking_slots` CHECK (((`available_slots` >= 0) and (`available_slots` <= `total_slots`)))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `parking_bookings`
--

DROP TABLE IF EXISTS `parking_bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parking_bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `citizen_id` int NOT NULL,
  `slot_id` int NOT NULL,
  `vehicle_id` int DEFAULT NULL,
  `booking_start` datetime NOT NULL,
  `booking_end` datetime NOT NULL,
  `amount` decimal(10,2) DEFAULT '0.00',
  `payment_status` varchar(20) DEFAULT 'Pending',
  `booking_status` varchar(20) DEFAULT 'Active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_id`),
  KEY `fk_booking_citizen` (`citizen_id`),
  KEY `fk_booking_slot` (`slot_id`),
  KEY `fk_booking_vehicle` (`vehicle_id`),
  CONSTRAINT `fk_booking_citizen` FOREIGN KEY (`citizen_id`) REFERENCES `citizens` (`citizen_id`),
  CONSTRAINT `fk_booking_slot` FOREIGN KEY (`slot_id`) REFERENCES `parking_slots` (`slot_id`),
  CONSTRAINT `fk_booking_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`),
  CONSTRAINT `chk_booking_status` CHECK ((`booking_status` in (_utf8mb4'Active',_utf8mb4'Completed',_utf8mb4'Cancelled'))),
  CONSTRAINT `chk_booking_time` CHECK ((`booking_end` > `booking_start`)),
  CONSTRAINT `chk_payment_status` CHECK ((`payment_status` in (_utf8mb4'Pending',_utf8mb4'Paid',_utf8mb4'Failed',_utf8mb4'Refunded')))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `parking_slots`
--

DROP TABLE IF EXISTS `parking_slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parking_slots` (
  `slot_id` int NOT NULL AUTO_INCREMENT,
  `parking_area_id` int NOT NULL,
  `slot_number` varchar(20) NOT NULL,
  `slot_type` varchar(30) DEFAULT 'Regular',
  `status` varchar(20) DEFAULT 'Available',
  PRIMARY KEY (`slot_id`),
  UNIQUE KEY `uq_parking_slot` (`parking_area_id`,`slot_number`),
  KEY `idx_parking_slots_status` (`status`),
  CONSTRAINT `fk_slot_parking_area` FOREIGN KEY (`parking_area_id`) REFERENCES `parking_areas` (`parking_area_id`),
  CONSTRAINT `chk_slot_status` CHECK ((`status` in (_utf8mb4'Available',_utf8mb4'Occupied',_utf8mb4'Reserved',_utf8mb4'Maintenance')))
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients` (
  `patient_id` int NOT NULL AUTO_INCREMENT,
  `citizen_id` int DEFAULT NULL,
  `hospital_id` int NOT NULL,
  `patient_name` varchar(100) NOT NULL,
  `age` int DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `blood_group` varchar(5) DEFAULT NULL,
  `admission_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `discharge_date` datetime DEFAULT NULL,
  `condition_status` varchar(50) DEFAULT 'Stable',
  PRIMARY KEY (`patient_id`),
  KEY `fk_patient_citizen` (`citizen_id`),
  KEY `fk_patient_hospital` (`hospital_id`),
  CONSTRAINT `fk_patient_citizen` FOREIGN KEY (`citizen_id`) REFERENCES `citizens` (`citizen_id`),
  CONSTRAINT `fk_patient_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`hospital_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `citizen_id` int NOT NULL,
  `booking_id` int DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(30) DEFAULT 'UPI',
  `transaction_reference` varchar(100) DEFAULT NULL,
  `payment_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `payment_status` varchar(30) DEFAULT 'Pending',
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `transaction_reference` (`transaction_reference`),
  KEY `fk_payment_citizen` (`citizen_id`),
  KEY `fk_payment_booking` (`booking_id`),
  CONSTRAINT `fk_payment_booking` FOREIGN KEY (`booking_id`) REFERENCES `parking_bookings` (`booking_id`),
  CONSTRAINT `fk_payment_citizen` FOREIGN KEY (`citizen_id`) REFERENCES `citizens` (`citizen_id`),
  CONSTRAINT `chk_payment_amount` CHECK ((`amount` >= 0)),
  CONSTRAINT `chk_payment_method` CHECK ((`payment_method` in (_utf8mb4'UPI',_utf8mb4'Card',_utf8mb4'Cash',_utf8mb4'Net Banking'))),
  CONSTRAINT `chk_payments_status` CHECK ((`payment_status` in (_utf8mb4'Pending',_utf8mb4'Successful',_utf8mb4'Failed',_utf8mb4'Refunded')))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `resource_allocation`
--

DROP TABLE IF EXISTS `resource_allocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resource_allocation` (
  `allocation_id` int NOT NULL AUTO_INCREMENT,
  `resource_id` int NOT NULL,
  `incident_id` int DEFAULT NULL,
  `request_id` int DEFAULT NULL,
  `allocated_quantity` int NOT NULL,
  `allocated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `returned_quantity` int DEFAULT '0',
  `allocation_status` varchar(30) DEFAULT 'Allocated',
  PRIMARY KEY (`allocation_id`),
  KEY `fk_allocation_resource` (`resource_id`),
  KEY `fk_allocation_incident` (`incident_id`),
  KEY `fk_allocation_request` (`request_id`),
  CONSTRAINT `fk_allocation_incident` FOREIGN KEY (`incident_id`) REFERENCES `incidents` (`incident_id`),
  CONSTRAINT `fk_allocation_request` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`request_id`),
  CONSTRAINT `fk_allocation_resource` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`resource_id`),
  CONSTRAINT `chk_allocated_quantity` CHECK ((`allocated_quantity` > 0)),
  CONSTRAINT `chk_allocation_status` CHECK ((`allocation_status` in (_utf8mb4'Allocated',_utf8mb4'In Use',_utf8mb4'Returned',_utf8mb4'Cancelled'))),
  CONSTRAINT `chk_returned_quantity` CHECK (((`returned_quantity` >= 0) and (`returned_quantity` <= `allocated_quantity`)))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `resources`
--

DROP TABLE IF EXISTS `resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resources` (
  `resource_id` int NOT NULL AUTO_INCREMENT,
  `area_id` int NOT NULL,
  `resource_name` varchar(120) NOT NULL,
  `resource_type` varchar(80) NOT NULL,
  `quantity` int NOT NULL DEFAULT '0',
  `available_quantity` int NOT NULL DEFAULT '0',
  `unit` varchar(30) DEFAULT 'Units',
  `status` varchar(30) DEFAULT 'Available',
  PRIMARY KEY (`resource_id`),
  KEY `fk_resource_area` (`area_id`),
  CONSTRAINT `fk_resource_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`area_id`),
  CONSTRAINT `chk_resource_quantity` CHECK (((`quantity` >= 0) and (`available_quantity` >= 0) and (`available_quantity` <= `quantity`))),
  CONSTRAINT `chk_resource_status` CHECK ((`status` in (_utf8mb4'Available',_utf8mb4'Low Stock',_utf8mb4'Out of Stock',_utf8mb4'Maintenance')))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `routes`
--

DROP TABLE IF EXISTS `routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `routes` (
  `route_id` int NOT NULL AUTO_INCREMENT,
  `route_name` varchar(100) NOT NULL,
  `start_point` varchar(100) NOT NULL,
  `end_point` varchar(100) NOT NULL,
  `distance_km` decimal(6,2) DEFAULT NULL,
  `speed_limit` int DEFAULT NULL,
  `road_type` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Open',
  PRIMARY KEY (`route_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `service_requests`
--

DROP TABLE IF EXISTS `service_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_requests` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `citizen_id` int NOT NULL,
  `area_id` int NOT NULL,
  `service_type` varchar(80) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `priority` varchar(20) DEFAULT 'Medium',
  `request_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `assigned_department` varchar(100) DEFAULT NULL,
  `status` varchar(30) DEFAULT 'Pending',
  `resolved_date` datetime DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `fk_service_citizen` (`citizen_id`),
  KEY `fk_service_area` (`area_id`),
  KEY `idx_service_requests_status` (`status`),
  CONSTRAINT `fk_service_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`area_id`),
  CONSTRAINT `fk_service_citizen` FOREIGN KEY (`citizen_id`) REFERENCES `citizens` (`citizen_id`),
  CONSTRAINT `chk_service_priority` CHECK ((`priority` in (_utf8mb4'Low',_utf8mb4'Medium',_utf8mb4'High',_utf8mb4'Critical'))),
  CONSTRAINT `chk_service_status` CHECK ((`status` in (_utf8mb4'Pending',_utf8mb4'Assigned',_utf8mb4'In Progress',_utf8mb4'Resolved',_utf8mb4'Rejected')))
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `system_settings`
--

DROP TABLE IF EXISTS `system_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_settings` (
  `setting_id` int NOT NULL AUTO_INCREMENT,
  `setting_name` varchar(100) NOT NULL,
  `setting_value` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`setting_id`),
  UNIQUE KEY `setting_name` (`setting_name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `traffic_events`
--

DROP TABLE IF EXISTS `traffic_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `traffic_events` (
  `traffic_event_id` int NOT NULL AUTO_INCREMENT,
  `route_id` int NOT NULL,
  `area_id` int NOT NULL,
  `event_type` varchar(50) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `severity` varchar(20) DEFAULT 'Medium',
  `reported_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `estimated_delay_minutes` int DEFAULT '0',
  `status` varchar(30) DEFAULT 'Active',
  PRIMARY KEY (`traffic_event_id`),
  KEY `fk_traffic_route` (`route_id`),
  KEY `fk_traffic_area` (`area_id`),
  KEY `idx_traffic_events_status` (`status`),
  CONSTRAINT `fk_traffic_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`area_id`),
  CONSTRAINT `fk_traffic_route` FOREIGN KEY (`route_id`) REFERENCES `routes` (`route_id`),
  CONSTRAINT `chk_traffic_severity` CHECK ((`severity` in (_utf8mb4'Low',_utf8mb4'Medium',_utf8mb4'High',_utf8mb4'Critical'))),
  CONSTRAINT `chk_traffic_status` CHECK ((`status` in (_utf8mb4'Active',_utf8mb4'Cleared',_utf8mb4'Monitoring')))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `transport`
--

DROP TABLE IF EXISTS `transport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transport` (
  `transport_id` int NOT NULL AUTO_INCREMENT,
  `area_id` int NOT NULL,
  `transport_number` varchar(30) NOT NULL,
  `transport_type` varchar(50) NOT NULL,
  `route_name` varchar(100) DEFAULT NULL,
  `capacity` int DEFAULT '0',
  `current_location` varchar(150) DEFAULT NULL,
  `status` varchar(30) DEFAULT 'Active',
  PRIMARY KEY (`transport_id`),
  UNIQUE KEY `transport_number` (`transport_number`),
  KEY `fk_transport_area` (`area_id`),
  CONSTRAINT `fk_transport_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`area_id`),
  CONSTRAINT `chk_transport_status` CHECK ((`status` in (_utf8mb4'Active',_utf8mb4'Inactive',_utf8mb4'Maintenance'))),
  CONSTRAINT `chk_transport_type` CHECK ((`transport_type` in (_utf8mb4'Bus',_utf8mb4'Metro',_utf8mb4'Train',_utf8mb4'Shuttle',_utf8mb4'Cab')))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `role_id` int NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Active',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_users_role` (`role_id`),
  CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicles` (
  `vehicle_id` int NOT NULL AUTO_INCREMENT,
  `citizen_id` int DEFAULT NULL,
  `vehicle_number` varchar(30) NOT NULL,
  `vehicle_type` varchar(50) NOT NULL,
  `fuel_type` varchar(30) DEFAULT NULL,
  `registration_date` date DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Active',
  PRIMARY KEY (`vehicle_id`),
  UNIQUE KEY `vehicle_number` (`vehicle_number`),
  KEY `fk_vehicle_citizen` (`citizen_id`),
  CONSTRAINT `fk_vehicle_citizen` FOREIGN KEY (`citizen_id`) REFERENCES `citizens` (`citizen_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Temporary view structure for view `vw_emergency_overview`
--

DROP TABLE IF EXISTS `vw_emergency_overview`;
/*!50001 DROP VIEW IF EXISTS `vw_emergency_overview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_emergency_overview` AS SELECT 
 1 AS `incident_id`,
 1 AS `incident_type`,
 1 AS `description`,
 1 AS `severity`,
 1 AS `incident_status`,
 1 AS `area_id`,
 1 AS `assignment_id`,
 1 AS `ambulance_id`,
 1 AS `team_id`,
 1 AS `assigned_at`,
 1 AS `assignment_status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_hospital_bed_availability`
--

DROP TABLE IF EXISTS `vw_hospital_bed_availability`;
/*!50001 DROP VIEW IF EXISTS `vw_hospital_bed_availability`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_hospital_bed_availability` AS SELECT 
 1 AS `hospital_id`,
 1 AS `hospital_name`,
 1 AS `area_id`,
 1 AS `total_beds`,
 1 AS `available_beds`,
 1 AS `occupied_beds`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_parking_status`
--

DROP TABLE IF EXISTS `vw_parking_status`;
/*!50001 DROP VIEW IF EXISTS `vw_parking_status`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_parking_status` AS SELECT 
 1 AS `parking_area_id`,
 1 AS `parking_name`,
 1 AS `address`,
 1 AS `total_slots`,
 1 AS `available_slots`,
 1 AS `occupied_slots`,
 1 AS `parking_type`,
 1 AS `hourly_rate`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `waste_requests`
--

DROP TABLE IF EXISTS `waste_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `waste_requests` (
  `waste_request_id` int NOT NULL AUTO_INCREMENT,
  `citizen_id` int NOT NULL,
  `area_id` int NOT NULL,
  `waste_type` varchar(50) NOT NULL,
  `quantity_kg` decimal(8,2) DEFAULT '0.00',
  `pickup_date` date DEFAULT NULL,
  `pickup_time` time DEFAULT NULL,
  `priority` varchar(20) DEFAULT 'Medium',
  `status` varchar(30) DEFAULT 'Pending',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`waste_request_id`),
  KEY `fk_waste_citizen` (`citizen_id`),
  KEY `fk_waste_area` (`area_id`),
  KEY `idx_waste_requests_status` (`status`),
  CONSTRAINT `fk_waste_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`area_id`),
  CONSTRAINT `fk_waste_citizen` FOREIGN KEY (`citizen_id`) REFERENCES `citizens` (`citizen_id`),
  CONSTRAINT `chk_waste_priority` CHECK ((`priority` in (_utf8mb4'Low',_utf8mb4'Medium',_utf8mb4'High',_utf8mb4'Critical'))),
  CONSTRAINT `chk_waste_quantity` CHECK ((`quantity_kg` >= 0)),
  CONSTRAINT `chk_waste_status` CHECK ((`status` in (_utf8mb4'Pending',_utf8mb4'Assigned',_utf8mb4'Collected',_utf8mb4'Cancelled')))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Table structure for table `water_requests`
--

DROP TABLE IF EXISTS `water_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `water_requests` (
  `water_request_id` int NOT NULL AUTO_INCREMENT,
  `citizen_id` int NOT NULL,
  `area_id` int NOT NULL,
  `request_type` varchar(50) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `urgency` varchar(20) DEFAULT 'Medium',
  `request_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `scheduled_date` date DEFAULT NULL,
  `status` varchar(30) DEFAULT 'Pending',
  PRIMARY KEY (`water_request_id`),
  KEY `fk_water_citizen` (`citizen_id`),
  KEY `fk_water_area` (`area_id`),
  KEY `idx_water_requests_status` (`status`),
  CONSTRAINT `fk_water_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`area_id`),
  CONSTRAINT `fk_water_citizen` FOREIGN KEY (`citizen_id`) REFERENCES `citizens` (`citizen_id`),
  CONSTRAINT `chk_water_status` CHECK ((`status` in (_utf8mb4'Pending',_utf8mb4'Assigned',_utf8mb4'In Progress',_utf8mb4'Completed',_utf8mb4'Cancelled'))),
  CONSTRAINT `chk_water_urgency` CHECK ((`urgency` in (_utf8mb4'Low',_utf8mb4'Medium',_utf8mb4'High',_utf8mb4'Critical')))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

--
-- Final view structure for view `vw_emergency_overview`
--

/*!50001 DROP VIEW IF EXISTS `vw_emergency_overview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `vw_emergency_overview` AS select `i`.`incident_id` AS `incident_id`,`i`.`incident_type` AS `incident_type`,`i`.`description` AS `description`,`i`.`severity` AS `severity`,`i`.`status` AS `incident_status`,`i`.`area_id` AS `area_id`,`ia`.`assignment_id` AS `assignment_id`,`ia`.`ambulance_id` AS `ambulance_id`,`ia`.`team_id` AS `team_id`,`ia`.`assigned_at` AS `assigned_at`,`ia`.`assignment_status` AS `assignment_status` from (`incidents` `i` left join `incident_assignments` `ia` on((`i`.`incident_id` = `ia`.`incident_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_hospital_bed_availability`
--

/*!50001 DROP VIEW IF EXISTS `vw_hospital_bed_availability`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `vw_hospital_bed_availability` AS select `h`.`hospital_id` AS `hospital_id`,`h`.`hospital_name` AS `hospital_name`,`h`.`area_id` AS `area_id`,count(`b`.`bed_id`) AS `total_beds`,sum((case when (`b`.`status` = 'Available') then 1 else 0 end)) AS `available_beds`,sum((case when (`b`.`status` = 'Occupied') then 1 else 0 end)) AS `occupied_beds` from (`hospitals` `h` left join `beds` `b` on((`h`.`hospital_id` = `b`.`hospital_id`))) group by `h`.`hospital_id`,`h`.`hospital_name`,`h`.`area_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_parking_status`
--

/*!50001 DROP VIEW IF EXISTS `vw_parking_status`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `vw_parking_status` AS select `pa`.`parking_area_id` AS `parking_area_id`,`pa`.`parking_name` AS `parking_name`,`pa`.`address` AS `address`,`pa`.`total_slots` AS `total_slots`,`pa`.`available_slots` AS `available_slots`,(`pa`.`total_slots` - `pa`.`available_slots`) AS `occupied_slots`,`pa`.`parking_type` AS `parking_type`,`pa`.`hourly_rate` AS `hourly_rate`,`pa`.`status` AS `status` from `parking_areas` `pa` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-14 21:06:33
