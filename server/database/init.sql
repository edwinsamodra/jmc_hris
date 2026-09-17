/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.5-MariaDB, for debian-linux-gnu (aarch64)
--
-- Host: localhost    Database: jmc_hris
-- ------------------------------------------------------
-- Server version	11.8.5-MariaDB-ubu2404

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Current Database: `jmc_hris`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `jmc_hris` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;

USE `jmc_hris`;

--
-- Table structure for table `activity_logs`
--

DROP TABLE IF EXISTS `activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `module_code` varchar(50) NOT NULL,
  `action` enum('login','logout','create','read','update','delete') NOT NULL,
  `description` text DEFAULT NULL,
  `subject_type` varchar(150) DEFAULT NULL,
  `subject_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `old_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_values`)),
  `new_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_values`)),
  `url` varchar(2048) DEFAULT NULL,
  `method` varchar(10) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_activity_logs_user_id` (`user_id`),
  KEY `idx_activity_logs_module_action` (`module_code`,`action`),
  KEY `idx_activity_logs_subject` (`subject_type`,`subject_id`),
  KEY `idx_activity_logs_created_at` (`created_at`),
  CONSTRAINT `fk_activity_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=426 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_logs`
--

LOCK TABLES `activity_logs` WRITE;
/*!40000 ALTER TABLE `activity_logs` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `activity_logs` VALUES
(1,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','curl/8.7.1',NULL,NULL,'/api/auth/login','POST','2026-09-16 09:09:32','2026-09-16 09:09:32'),
(2,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 09:09:41','2026-09-16 09:09:41'),
(3,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 09:09:41','2026-09-16 09:09:41'),
(4,2,'auth','login','Request OTP login untuk user manager.hrd (Manager HRD)','users',2,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 09:09:41','2026-09-16 09:09:41'),
(5,2,'auth','login','User manager.hrd berhasil login dengan role manager_hrd (RememberMe: true)','users',2,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 09:09:41','2026-09-16 09:09:41'),
(6,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 09:09:41','2026-09-16 09:09:41'),
(7,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 09:09:41','2026-09-16 09:09:41'),
(8,1,'auth','logout','User superadmin telah logout','users',1,'::1','node',NULL,NULL,'/api/auth/logout','POST','2026-09-16 09:09:41','2026-09-16 09:09:41'),
(9,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','curl/8.7.1',NULL,NULL,'/api/auth/login','POST','2026-09-16 09:15:23','2026-09-16 09:15:23'),
(10,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','curl/8.7.1',NULL,NULL,'/api/auth/login','POST','2026-09-16 09:17:58','2026-09-16 09:17:58'),
(11,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','curl/8.7.1',NULL,NULL,'/api/auth/login','POST','2026-09-16 10:05:10','2026-09-16 10:05:10'),
(12,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 10:10:24','2026-09-16 10:10:24'),
(13,1,'auth','login','Kirim ulang OTP login untuk user superadmin','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/resend-otp','POST','2026-09-16 10:17:05','2026-09-16 10:17:05'),
(14,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 10:17:12','2026-09-16 10:17:12'),
(15,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 10:17:21','2026-09-16 10:17:21'),
(16,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 10:17:30','2026-09-16 10:17:30'),
(17,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','curl/8.7.1',NULL,NULL,'/api/auth/login','POST','2026-09-16 10:20:08','2026-09-16 10:20:08'),
(18,1,'auth','login','Kirim ulang OTP login untuk user superadmin','users',1,'::1','curl/8.7.1',NULL,NULL,'/api/auth/resend-otp','POST','2026-09-16 10:20:16','2026-09-16 10:20:16'),
(19,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','curl/8.7.1',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 10:20:41','2026-09-16 10:20:41'),
(20,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 10:26:24','2026-09-16 10:26:24'),
(21,1,'auth','login','Kirim ulang OTP login untuk user superadmin','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/resend-otp','POST','2026-09-16 10:31:46','2026-09-16 10:31:46'),
(22,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 10:31:50','2026-09-16 10:31:50'),
(23,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 10:34:52','2026-09-16 10:34:52'),
(24,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 10:34:56','2026-09-16 10:34:56'),
(25,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 10:36:38','2026-09-16 10:36:38'),
(26,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 10:36:44','2026-09-16 10:36:44'),
(27,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 10:39:00','2026-09-16 10:39:00'),
(28,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 10:39:04','2026-09-16 10:39:04'),
(29,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 10:43:14','2026-09-16 10:43:14'),
(30,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 10:43:19','2026-09-16 10:43:19'),
(31,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 10:44:17','2026-09-16 10:44:17'),
(32,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 10:44:19','2026-09-16 10:44:19'),
(33,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 10:46:04','2026-09-16 10:46:04'),
(34,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 10:46:08','2026-09-16 10:46:08'),
(35,1,'auth','login','User superadmin (Super Administrator) berhasil login via Google OAuth (edwinsamodra@gmail.com)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/callback/google?state=eyJ0aW1lc3RhbXAiOjE3ODk1NTU4OTY1Mjl9&iss=https%3A%2F%2Faccounts.google.com&code=4%2F0ATsMZqAD0El6exg9aLYSzcmtbdvBjeIH7lpzyptmxWd3hkwhdOjuMxl-rq6nc4urQDnFlg&scope=email+profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+openid&authuser=1&prompt=consent','GET','2026-09-16 10:51:44','2026-09-16 10:51:44'),
(36,1,'auth','login','User superadmin (Super Administrator) berhasil login via Google OAuth (edwinsamodra@gmail.com)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/callback/google?state=eyJ0aW1lc3RhbXAiOjE3ODk1NTYxMDQzMzR9&iss=https%3A%2F%2Faccounts.google.com&code=4%2F0ATsMZqAqky5WAj1MgH49ZepF8g29oX-D4IFiCH4v_wP8ezPti2zOp4qbzMtce8wVfXkiuA&scope=email+profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+openid&authuser=1&prompt=consent','GET','2026-09-16 10:55:10','2026-09-16 10:55:10'),
(37,1,'auth','logout','User superadmin telah logout','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/logout','POST','2026-09-16 10:55:31','2026-09-16 10:55:31'),
(38,1,'auth','login','User superadmin (Super Administrator) berhasil login via Google OAuth (edwinsamodra@gmail.com)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/callback/google?state=eyJ0aW1lc3RhbXAiOjE3ODk1NTYxMzY1Nzh9&iss=https%3A%2F%2Faccounts.google.com&code=4%2F0ATsMZqAGMHkUv8hpu0znpPuZcZeuVebmaDEV647QhzWftNSLJPmhfa9THf0AzVmP8CUfyQ&scope=email+profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+openid&authuser=1&prompt=consent','GET','2026-09-16 10:55:42','2026-09-16 10:55:42'),
(39,1,'auth','login','User superadmin (Super Administrator) berhasil login via Google OAuth (edwinsamodra@gmail.com)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/callback/google?state=eyJ0aW1lc3RhbXAiOjE3ODk1NTY1OTg0Nzl9&iss=https%3A%2F%2Faccounts.google.com&code=4%2F0ATsMZqD686BQr6YkR_sR38s1vzQfr_uK4q_JOzFM9jomn_tQ-sTF7dXHNlONDJbg-n3xDQ&scope=email+profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+openid&authuser=1&prompt=consent','GET','2026-09-16 11:03:24','2026-09-16 11:03:24'),
(40,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','curl/8.7.1',NULL,NULL,'/api/auth/login','POST','2026-09-16 11:10:46','2026-09-16 11:10:46'),
(41,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: true)','users',1,'::1','curl/8.7.1',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 11:10:53','2026-09-16 11:10:53'),
(42,1,'auth','login','User superadmin (Super Administrator) berhasil login via Google OAuth (edwinsamodra@gmail.com)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/callback/google?state=eyJ0aW1lc3RhbXAiOjE3ODk1NTcwNjc4NzB9&iss=https%3A%2F%2Faccounts.google.com&code=4%2F0ATsMZqB_0LnGgYYtq5ejo2U7Pm3kfUHM2C800JnVfVUCnilMz_kh833pFQztqKPppLFEuw&scope=email+profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+openid&authuser=1&prompt=consent','GET','2026-09-16 11:11:12','2026-09-16 11:11:12'),
(43,1,'auth','logout','User superadmin telah logout','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/logout','POST','2026-09-16 11:11:57','2026-09-16 11:11:57'),
(44,1,'auth','login','User superadmin (Super Administrator) berhasil login via Google OAuth (edwinsamodra@gmail.com)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/callback/google?state=eyJ0aW1lc3RhbXAiOjE3ODk1NTcxMTkwOTl9&iss=https%3A%2F%2Faccounts.google.com&code=4%2F0ATsMZqAglcvH15C1bEIOyhJrvdIfrO2gziQRDDV73Ku9IrMD878Sv2sibDTNGXFXPogV0w&scope=email+profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+openid&authuser=1&prompt=consent','GET','2026-09-16 11:12:05','2026-09-16 11:12:05'),
(45,1,'auth','login','User superadmin (Super Administrator) berhasil login via Google OAuth (edwinsamodra@gmail.com)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/callback/google?state=eyJ0aW1lc3RhbXAiOjE3ODk1NTc0NTIzMDB9&iss=https%3A%2F%2Faccounts.google.com&code=4%2F0ATsMZqCgDJDMI1x2ZJDJoG7y8epZ1eTQPFCB-wVugF5zj6PImtairOe7ZqfYtgYWrrsbTg&scope=email+profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+openid&authuser=1&prompt=consent','GET','2026-09-16 11:17:38','2026-09-16 11:17:38'),
(46,1,'auth','login','User superadmin (Super Administrator) berhasil login via Google OAuth (edwinsamodra@gmail.com)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/callback/google?state=eyJ0aW1lc3RhbXAiOjE3ODk1NTc2ODQ5NTd9&iss=https%3A%2F%2Faccounts.google.com&code=4%2F0ATsMZqC84XNgQ_Rtz6X3E4OsPqmzT_iY9bHPQ3W9eg1lV6uA_HfwgMbFTs9b8zrfIViuDw&scope=email+profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+openid&authuser=1&prompt=consent','GET','2026-09-16 11:21:31','2026-09-16 11:21:31'),
(47,2,'auth','login','Request OTP login untuk user manager.hrd (Manager HRD)','users',2,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/login','POST','2026-09-16 11:32:28','2026-09-16 11:32:28'),
(48,2,'auth','login','User manager.hrd berhasil login dengan role manager_hrd (RememberMe: false)','users',2,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 11:32:34','2026-09-16 11:32:34'),
(49,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/login','POST','2026-09-16 11:32:57','2026-09-16 11:32:57'),
(50,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 11:33:00','2026-09-16 11:33:00'),
(51,1,'auth','login','User superadmin (Super Administrator) berhasil login via Google OAuth (edwinsamodra@gmail.com)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/callback/google?state=eyJ0aW1lc3RhbXAiOjE3ODk1NTg5OTc0MjV9&iss=https%3A%2F%2Faccounts.google.com&code=4%2F0ATsMZqAQctpAdvapaHO7pZ4ddcVFtNotX-tQRXwSl6l4WlgMICViBhmGyS6ARTD6itV4QQ&scope=email+profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+openid&authuser=1&prompt=consent','GET','2026-09-16 11:43:23','2026-09-16 11:43:23'),
(52,1,'auth','login','User superadmin (Super Administrator) berhasil login via Google OAuth (edwinsamodra@gmail.com)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/callback/google?state=eyJ0aW1lc3RhbXAiOjE3ODk1NTkyMTQ2Mzd9&iss=https%3A%2F%2Faccounts.google.com&code=4%2F0ATsMZqDlYjPGcKLee0RsJkAitD8M2ne_5eQSJ7WU9W6jhERzYq6mGnNNEQK4FNFkC5QrdQ&scope=email+profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+openid&authuser=1&prompt=consent','GET','2026-09-16 11:47:00','2026-09-16 11:47:00'),
(53,1,'auth','logout','User superadmin telah logout','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/logout','POST','2026-09-16 11:47:09','2026-09-16 11:47:09'),
(54,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 11:47:52','2026-09-16 11:47:52'),
(55,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 11:47:57','2026-09-16 11:47:57'),
(56,3,'auth','logout','User admin.hrd telah logout','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/logout','POST','2026-09-16 11:52:19','2026-09-16 11:52:19'),
(57,1,'auth','login','User superadmin (Super Administrator) berhasil login via Google OAuth (edwinsamodra@gmail.com)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/callback/google?state=eyJ0aW1lc3RhbXAiOjE3ODk1NTk1NDA3MDV9&iss=https%3A%2F%2Faccounts.google.com&code=4%2F0ATsMZqB3vco-FNwkVwx0pFuusAbR0eeeKA1-8n9OiKCzLP3-DWdTvGJFZ4HxndOZAQCiVw&scope=email+profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+openid&authuser=1&prompt=consent','GET','2026-09-16 11:52:26','2026-09-16 11:52:26'),
(58,1,'auth','logout','User superadmin telah logout','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/logout','POST','2026-09-16 11:52:36','2026-09-16 11:52:36'),
(59,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 11:53:18','2026-09-16 11:53:18'),
(60,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 11:53:21','2026-09-16 11:53:21'),
(61,3,'auth','logout','User admin.hrd telah logout','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/logout','POST','2026-09-16 11:55:24','2026-09-16 11:55:24'),
(62,1,'auth','login','User superadmin (Super Administrator) berhasil login via Google OAuth (edwinsamodra@gmail.com)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/callback/google?state=eyJ0aW1lc3RhbXAiOjE3ODk1NTk3Mjc4MTZ9&iss=https%3A%2F%2Faccounts.google.com&code=4%2F0ATsMZqCMxG-LSkx9rGBNiSXykJAGF8ReNI-60QXVekF0JOvdYFt9QzgEydNE6a_-bk4Y0g&scope=email+profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+openid&authuser=1&prompt=consent','GET','2026-09-16 11:55:34','2026-09-16 11:55:34'),
(63,1,'auth','logout','User superadmin telah logout','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/logout','POST','2026-09-16 11:55:38','2026-09-16 11:55:38'),
(64,2,'auth','login','Request OTP login untuk user manager.hrd (Manager HRD)','users',2,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 11:56:26','2026-09-16 11:56:26'),
(65,2,'auth','login','User manager.hrd berhasil login dengan role manager_hrd (RememberMe: false)','users',2,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 11:56:31','2026-09-16 11:56:31'),
(66,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/login','POST','2026-09-16 11:56:57','2026-09-16 11:56:57'),
(67,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 11:57:10','2026-09-16 11:57:10'),
(68,3,'auth','logout','User admin.hrd telah logout','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/logout','POST','2026-09-16 11:57:14','2026-09-16 11:57:14'),
(69,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/login','POST','2026-09-16 11:57:33','2026-09-16 11:57:33'),
(70,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 11:57:39','2026-09-16 11:57:39'),
(71,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 12:17:09','2026-09-16 12:17:09'),
(72,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: true)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 12:17:12','2026-09-16 12:17:12'),
(73,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/login','POST','2026-09-16 12:18:04','2026-09-16 12:18:04'),
(74,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: true)','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 12:18:12','2026-09-16 12:18:12'),
(75,2,'auth','login','Request OTP login untuk user manager.hrd (Manager HRD)','users',2,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/login','POST','2026-09-16 12:18:30','2026-09-16 12:18:30'),
(76,2,'auth','login','User manager.hrd berhasil login dengan role manager_hrd (RememberMe: true)','users',2,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 12:18:34','2026-09-16 12:18:34'),
(77,1,'user','read','Melihat daftar pengguna aplikasi','users',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/users','GET','2026-09-16 12:45:30','2026-09-16 12:45:30'),
(78,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-16 12:45:30','2026-09-16 12:45:30'),
(79,1,'user','read','Melihat daftar pengguna aplikasi','users',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/users','GET','2026-09-16 12:46:18','2026-09-16 12:46:18'),
(80,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-16 12:46:18','2026-09-16 12:46:18'),
(81,1,'user','read','Melihat daftar pengguna aplikasi','users',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/users','GET','2026-09-16 14:12:09','2026-09-16 14:12:09'),
(82,1,'user','read','Melihat daftar pengguna aplikasi','users',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/users','GET','2026-09-16 14:12:09','2026-09-16 14:12:09'),
(83,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-16 14:12:09','2026-09-16 14:12:09'),
(84,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-16 14:12:09','2026-09-16 14:12:09'),
(85,1,'user','read','Melihat daftar pengguna aplikasi','users',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/users','GET','2026-09-16 14:12:12','2026-09-16 14:12:12'),
(86,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-16 14:12:12','2026-09-16 14:12:12'),
(87,1,'user','read','Melihat daftar pengguna aplikasi','users',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/users','GET','2026-09-16 14:12:16','2026-09-16 14:12:16'),
(88,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-16 14:12:16','2026-09-16 14:12:16'),
(89,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-16 14:12:19','2026-09-16 14:12:19'),
(90,1,'user','read','Melihat daftar pengguna aplikasi','users',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/users','GET','2026-09-16 14:12:19','2026-09-16 14:12:19'),
(91,1,'auth','logout','User superadmin telah logout','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/logout','POST','2026-09-16 14:12:22','2026-09-16 14:12:22'),
(92,1,'auth','login','User superadmin (Super Administrator) berhasil login via Google OAuth (edwinsamodra@gmail.com)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/callback/google?state=eyJ0aW1lc3RhbXAiOjE3ODk1Njc5NDQyNDJ9&iss=https%3A%2F%2Faccounts.google.com&code=4%2F0ATsMZqDUoey5F4Ai7H8eBx5BkGBqrsKnepTz9p3nVeq1N6QGT2u7LRn64sO5dxUyojntVQ&scope=email+profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+openid&authuser=1&prompt=consent','GET','2026-09-16 14:12:29','2026-09-16 14:12:29'),
(93,1,'profile','read','Melihat data profil pengguna (superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/profile','GET','2026-09-16 14:15:20','2026-09-16 14:15:20'),
(94,1,'profile','read','Melihat data profil pengguna (superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/profile','GET','2026-09-16 14:17:20','2026-09-16 14:17:20'),
(95,1,'profile','read','Melihat data profil pengguna (superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/profile','GET','2026-09-16 14:18:50','2026-09-16 14:18:50'),
(96,1,'profile','read','Melihat data profil pengguna (superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/profile','GET','2026-09-16 14:18:55','2026-09-16 14:18:55'),
(97,1,'auth','login','User superadmin (Super Administrator) berhasil login via Google OAuth (edwinsamodra@gmail.com)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/callback/google?state=eyJ0aW1lc3RhbXAiOjE3ODk1Njg2MjA2NDN9&iss=https%3A%2F%2Faccounts.google.com&code=4%2F0ATsMZqA6lg1S9HBaoOJgvcW5nwOZEoNQW8Y1tvklp7PDzUf4cYetCij2j9gIN6xnbXsWfA&scope=email+profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+openid&authuser=1&prompt=consent','GET','2026-09-16 14:23:45','2026-09-16 14:23:45'),
(98,1,'profile','update','Mengubah password akun (superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/profile/change-password','PUT','2026-09-16 14:24:56','2026-09-16 14:24:56'),
(99,1,'auth','logout','User superadmin telah logout','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/logout','POST','2026-09-16 14:25:02','2026-09-16 14:25:02'),
(100,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 14:25:13','2026-09-16 14:25:13'),
(101,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 14:25:17','2026-09-16 14:25:17'),
(102,1,'auth','logout','User superadmin telah logout','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/logout','POST','2026-09-16 14:25:26','2026-09-16 14:25:26'),
(103,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 14:26:02','2026-09-16 14:26:02'),
(104,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 14:26:12','2026-09-16 14:26:12'),
(105,3,'profile','update','Mengubah password akun (admin.hrd)','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/profile/change-password','PUT','2026-09-16 14:26:40','2026-09-16 14:26:40'),
(106,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 14:27:00','2026-09-16 14:27:00'),
(107,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 14:27:02','2026-09-16 14:27:02'),
(108,1,'auth','logout','User superadmin telah logout','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/logout','POST','2026-09-16 14:27:18','2026-09-16 14:27:18'),
(109,3,'auth','logout','User admin.hrd telah logout','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/logout','POST','2026-09-16 14:29:43','2026-09-16 14:29:43'),
(110,2,'auth','login','Request OTP login untuk user manager.hrd (Manager HRD)','users',2,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 14:30:40','2026-09-16 14:30:40'),
(111,2,'auth','login','User manager.hrd berhasil login dengan role manager_hrd (RememberMe: true)','users',2,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 14:30:43','2026-09-16 14:30:43'),
(112,2,'profile','update','Mengubah password akun (manager.hrd)','users',2,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/profile/change-password','PUT','2026-09-16 14:31:13','2026-09-16 14:31:13'),
(113,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:18:31','2026-09-16 15:18:31'),
(114,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:18:44','2026-09-16 15:18:44'),
(115,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 15:18:44','2026-09-16 15:18:44'),
(116,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:19:00','2026-09-16 15:19:00'),
(117,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 15:19:00','2026-09-16 15:19:00'),
(118,3,'employee','create','Menambahkan data pegawai \'Budi Santoso\' (NIP: 199001014831)','employees',22,'::1','node',NULL,'{\"id\":22,\"nip\":\"199001014831\",\"name\":\"Budi Santoso\",\"email\":\"budi.1789571940406@example.com\",\"phone\":\"+6281299887766\",\"position_id\":2,\"department_id\":2,\"status\":\"active\",\"employment_type\":\"pkwtt\"}','/api/employees','POST','2026-09-16 15:19:00','2026-09-16 15:19:00'),
(119,3,'employee','update','Mengubah data pegawai \'Budi Santoso Updated\' (NIP: 199001014831, ID: 22)','employees',22,'::1','node','{\"nip\":\"199001014831\",\"name\":\"Budi Santoso\",\"email\":\"budi.1789571940406@example.com\",\"phone\":\"+6281299887766\",\"position_id\":2,\"department_id\":2,\"status\":\"active\"}','{\"nip\":\"199001014831\",\"name\":\"Budi Santoso Updated\",\"email\":\"budi.1789571940406@example.com\",\"phone\":\"+6281299887766\",\"position_id\":2,\"department_id\":2,\"status\":\"active\"}','/api/employees/22','PUT','2026-09-16 15:19:00','2026-09-16 15:19:00'),
(120,3,'employee','delete','Menghapus data pegawai \'Budi Santoso Updated\' (NIP: 199001014831, ID: 22)','employees',22,'::1','node','{\"id\":22,\"nip\":\"199001014831\",\"name\":\"Budi Santoso Updated\",\"email\":\"budi.1789571940406@example.com\",\"phone\":\"+6281299887766\",\"position_id\":2,\"department_id\":2,\"status\":\"active\"}',NULL,'/api/employees/22','DELETE','2026-09-16 15:19:00','2026-09-16 15:19:00'),
(121,2,'auth','login','Request OTP login untuk user manager.hrd (Manager HRD)','users',2,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:19:00','2026-09-16 15:19:00'),
(122,2,'auth','login','User manager.hrd berhasil login dengan role manager_hrd (RememberMe: false)','users',2,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 15:19:00','2026-09-16 15:19:00'),
(123,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:22:29','2026-09-16 15:22:29'),
(124,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 15:22:29','2026-09-16 15:22:29'),
(125,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:23:18','2026-09-16 15:23:18'),
(126,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 15:23:18','2026-09-16 15:23:18'),
(127,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:24:07','2026-09-16 15:24:07'),
(128,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 15:24:07','2026-09-16 15:24:07'),
(129,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:24:55','2026-09-16 15:24:55'),
(130,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 15:24:55','2026-09-16 15:24:55'),
(131,2,'auth','logout','User manager.hrd telah logout','users',2,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/logout','POST','2026-09-16 15:27:56','2026-09-16 15:27:56'),
(132,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:28:46','2026-09-16 15:28:46'),
(133,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: true)','users',3,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 15:28:51','2026-09-16 15:28:51'),
(134,3,'employee','update','Mengubah status massal 2 pegawai menjadi \'active\' (IDs: 17, 16)','employees',17,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,'{\"affected_ids\":[17,16],\"status\":\"active\"}','/api/employees/bulk-status','POST','2026-09-16 15:29:06','2026-09-16 15:29:06'),
(135,3,'employee','update','Mengubah status massal 2 pegawai menjadi \'inactive\' (IDs: 17, 16)','employees',17,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,'{\"affected_ids\":[17,16],\"status\":\"inactive\"}','/api/employees/bulk-status','POST','2026-09-16 15:29:11','2026-09-16 15:29:11'),
(136,3,'employee','update','Mengubah status massal 2 pegawai menjadi \'active\' (IDs: 17, 16)','employees',17,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,'{\"affected_ids\":[17,16],\"status\":\"active\"}','/api/employees/bulk-status','POST','2026-09-16 15:29:26','2026-09-16 15:29:26'),
(137,3,'employee','create','Menambahkan data pegawai \'Edwin Samodra Pratama\' (NIP: 29182493)','employees',23,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,'{\"id\":23,\"nip\":\"29182493\",\"name\":\"Edwin Samodra Pratama\",\"email\":\"pegawai@gmai.com\",\"phone\":\"+6282225425660\",\"position_id\":1,\"department_id\":1,\"status\":\"active\",\"employment_type\":\"pkwt\"}','/api/employees','POST','2026-09-16 15:36:48','2026-09-16 15:36:48'),
(138,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:39:15','2026-09-16 15:39:15'),
(139,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 15:39:15','2026-09-16 15:39:15'),
(140,3,'employee','delete','Menghapus data pegawai \'Edwin Samodra Pratama\' (NIP: 29182493, ID: 23)','employees',23,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','{\"id\":23,\"nip\":\"29182493\",\"name\":\"Edwin Samodra Pratama\",\"email\":\"pegawai@gmai.com\",\"phone\":\"+6282225425660\",\"position_id\":1,\"department_id\":1,\"status\":\"active\"}',NULL,'/api/employees/23','DELETE','2026-09-16 15:42:44','2026-09-16 15:42:44'),
(141,3,'employee','delete','Menghapus massal 2 data pegawai (IDs: 14, 15)','employees',14,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','{\"deleted_ids\":[14,15]}',NULL,'/api/employees/bulk-delete','POST','2026-09-16 15:42:54','2026-09-16 15:42:54'),
(142,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:45:29','2026-09-16 15:45:29'),
(143,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 15:45:29','2026-09-16 15:45:29'),
(144,3,'employee','create','Menambahkan data pegawai \'ekwejk\' (NIP: 12983192)','employees',49,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,'{\"id\":49,\"nip\":\"12983192\",\"name\":\"ekwejk\",\"email\":\"ewqekjq@kjdas.com\",\"phone\":\"+62343121242\",\"position_id\":19,\"department_id\":2,\"status\":\"active\",\"employment_type\":\"pkwtt\"}','/api/employees','POST','2026-09-16 15:47:41','2026-09-16 15:47:41'),
(145,3,'employee','update','Mengubah data pegawai \'ekwejk\' (NIP: 12983192, ID: 49)','employees',49,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','{\"nip\":\"12983192\",\"name\":\"ekwejk\",\"email\":\"ewqekjq@kjdas.com\",\"phone\":\"+62343121242\",\"position_id\":19,\"department_id\":2,\"status\":\"active\"}','{\"nip\":\"12983192\",\"name\":\"ekwejk\",\"email\":\"ewqekjq@kjdas.com\",\"phone\":\"+62343121242\",\"position_id\":19,\"department_id\":2,\"status\":\"active\"}','/api/employees/49','PUT','2026-09-16 15:48:54','2026-09-16 15:48:54'),
(146,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:51:07','2026-09-16 15:51:07'),
(147,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 15:51:07','2026-09-16 15:51:07'),
(148,3,'employee','create','Menambahkan data pegawai \'Testing Pendidikan\' (NIP: 199505052885)','employees',50,'::1','node',NULL,'{\"id\":50,\"nip\":\"199505052885\",\"name\":\"Testing Pendidikan\",\"email\":\"test.edu.1789573867834@example.com\",\"phone\":\"+6281234567899\",\"position_id\":2,\"department_id\":2,\"status\":\"active\",\"employment_type\":\"pkwtt\"}','/api/employees','POST','2026-09-16 15:51:07','2026-09-16 15:51:07'),
(149,3,'employee','update','Mengubah data pegawai \'ekwejk\' (NIP: 12983192, ID: 49)','employees',49,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','{\"nip\":\"12983192\",\"name\":\"ekwejk\",\"email\":\"ewqekjq@kjdas.com\",\"phone\":\"+62343121242\",\"position_id\":19,\"department_id\":2,\"status\":\"active\"}','{\"nip\":\"12983192\",\"name\":\"ekwejk\",\"email\":\"ewqekjq@kjdas.com\",\"phone\":\"+62343121242\",\"position_id\":19,\"department_id\":2,\"status\":\"active\"}','/api/employees/49','PUT','2026-09-16 15:51:35','2026-09-16 15:51:35'),
(150,3,'employee','update','Mengubah data pegawai \'Testing Pendidikan\' (NIP: 199505052885, ID: 50)','employees',50,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','{\"nip\":\"199505052885\",\"name\":\"Testing Pendidikan\",\"email\":\"test.edu.1789573867834@example.com\",\"phone\":\"+6281234567899\",\"position_id\":2,\"department_id\":2,\"status\":\"active\"}','{\"nip\":\"199505052885\",\"name\":\"Testing Pendidikan\",\"email\":\"test.edu.1789573867834@example.com\",\"phone\":\"+6281234567899\",\"position_id\":2,\"department_id\":2,\"status\":\"active\"}','/api/employees/50','PUT','2026-09-16 15:52:14','2026-09-16 15:52:14'),
(151,3,'employee','update','Mengubah data pegawai \'Testing Pendidikan\' (NIP: 199505052885, ID: 50)','employees',50,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','{\"nip\":\"199505052885\",\"name\":\"Testing Pendidikan\",\"email\":\"test.edu.1789573867834@example.com\",\"phone\":\"+6281234567899\",\"position_id\":2,\"department_id\":2,\"status\":\"active\"}','{\"nip\":\"199505052885\",\"name\":\"Testing Pendidikan\",\"email\":\"test.edu.1789573867834@example.com\",\"phone\":\"+6281234567899\",\"position_id\":2,\"department_id\":2,\"status\":\"active\"}','/api/employees/50','PUT','2026-09-16 15:52:25','2026-09-16 15:52:25'),
(152,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:55:08','2026-09-16 15:55:08'),
(153,2,'auth','login','Request OTP login untuk user manager.hrd (Manager HRD)','users',2,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:55:08','2026-09-16 15:55:08'),
(154,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:55:08','2026-09-16 15:55:08'),
(155,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/login','POST','2026-09-16 15:59:44','2026-09-16 15:59:44'),
(156,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: true)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 15:59:53','2026-09-16 15:59:53'),
(157,1,'profile','read','Melihat data profil pengguna (superadmin)','users',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/profile','GET','2026-09-16 16:00:00','2026-09-16 16:00:00'),
(158,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-16 16:03:31','2026-09-16 16:03:31'),
(159,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-16 16:03:32','2026-09-16 16:03:32'),
(160,1,'user','read','Melihat daftar pengguna aplikasi','users',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/users','GET','2026-09-16 16:03:32','2026-09-16 16:03:32'),
(161,1,'user','read','Melihat daftar pengguna aplikasi','users',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/users','GET','2026-09-16 16:06:03','2026-09-16 16:06:03'),
(162,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-16 16:06:03','2026-09-16 16:06:03'),
(163,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 16:06:18','2026-09-16 16:06:18'),
(164,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 16:06:24','2026-09-16 16:06:24'),
(165,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 16:06:29','2026-09-16 16:06:29'),
(166,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 16:06:38','2026-09-16 16:06:38'),
(167,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 16:06:44','2026-09-16 16:06:44'),
(168,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 16:06:44','2026-09-16 16:06:44'),
(169,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 16:06:51','2026-09-16 16:06:51'),
(170,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 16:06:51','2026-09-16 16:06:51'),
(171,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 16:07:13','2026-09-16 16:07:13'),
(172,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 16:07:13','2026-09-16 16:07:13'),
(173,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-16 16:08:04','2026-09-16 16:08:04'),
(174,1,'user','read','Melihat daftar pengguna aplikasi','users',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/users','GET','2026-09-16 16:08:04','2026-09-16 16:08:04'),
(175,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-16 16:08:26','2026-09-16 16:08:26'),
(176,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-16 16:08:26','2026-09-16 16:08:26'),
(177,1,'user','read','Melihat daftar pengguna aplikasi','users',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/users','GET','2026-09-16 16:22:53','2026-09-16 16:22:53'),
(178,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-16 16:22:53','2026-09-16 16:22:53'),
(179,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','curl/8.7.1',NULL,NULL,'/api/auth/login','POST','2026-09-17 00:42:00','2026-09-17 00:42:00'),
(180,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','curl/8.7.1',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-17 00:42:31','2026-09-17 00:42:31'),
(181,3,'attendance','create','Menambahkan data presensi Ahmad Hermawan (NIP: EMP-001) tanggal 2026-08-03','attendances',19,'::1','curl/8.7.1',NULL,'{\"id\":19,\"employee_id\":1,\"attendance_date\":\"2026-08-03\",\"attendance_type\":\"hadir\",\"duration_hours\":8,\"status\":\"terpenuhi\",\"checkin_location\":\"Gedung Utama\",\"checkout_location\":\"Gedung Utama\"}','/api/attendances','POST','2026-09-17 00:42:51','2026-09-17 00:42:51'),
(182,3,'attendance','update','Mengubah data presensi Ahmad Hermawan tanggal 2026-08-03','attendances',19,'::1','curl/8.7.1','{\"attendance_date\":\"2026-08-02T17:00:00.000Z\",\"attendance_type\":\"hadir\",\"duration_hours\":\"8.00\",\"status\":\"terpenuhi\",\"checkin_location\":\"Gedung Utama\",\"checkout_location\":\"Gedung Utama\"}','{\"attendance_date\":\"2026-08-03\",\"attendance_type\":\"hadir\",\"duration_hours\":8,\"status\":\"terpenuhi\",\"checkin_location\":\"Gedung Utama\",\"checkout_location\":\"Gedung Utama\"}','/api/attendances/19','PUT','2026-09-17 00:44:43','2026-09-17 00:44:43'),
(183,3,'attendance','delete','Menghapus data presensi Ahmad Hermawan tanggal Mon Aug 03 2026 00:00:00 GMT+0700 (Western Indonesia Time)','attendances',19,'::1','curl/8.7.1','{\"id\":19,\"employee_id\":1,\"attendance_date\":\"2026-08-02T17:00:00.000Z\",\"attendance_type\":\"hadir\",\"duration_hours\":\"8.00\",\"status\":\"terpenuhi\"}',NULL,'/api/attendances/19','DELETE','2026-09-17 00:44:50','2026-09-17 00:44:50'),
(184,3,'attendance','create','Import data presensi (test-import-agustus.csv): 4 berhasil, 2 gagal','attendance_imports',1,'::1','curl/8.7.1',NULL,'{\"import_id\":1,\"filename\":\"test-import-agustus.csv\",\"total_rows\":6,\"processed_rows\":4,\"failed_rows\":2}','/api/attendances/import','POST','2026-09-17 00:46:18','2026-09-17 00:46:18'),
(185,2,'auth','login','Request OTP login untuk user manager.hrd (Manager HRD)','users',2,'::1','curl/8.7.1',NULL,NULL,'/api/auth/login','POST','2026-09-17 00:50:57','2026-09-17 00:50:57'),
(186,2,'auth','login','User manager.hrd berhasil login dengan role manager_hrd (RememberMe: false)','users',2,'::1','curl/8.7.1',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-17 00:51:07','2026-09-17 00:51:07'),
(187,1,'auth','login','Request OTP login untuk user superadmin (Superadmin)','users',1,'::1','curl/8.7.1',NULL,NULL,'/api/auth/login','POST','2026-09-17 00:51:27','2026-09-17 00:51:27'),
(188,1,'auth','login','User superadmin berhasil login dengan role superadmin (RememberMe: false)','users',1,'::1','curl/8.7.1',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-17 00:51:38','2026-09-17 00:51:38'),
(189,1,'user','read','Melihat daftar pengguna aplikasi','users',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/users','GET','2026-09-17 01:03:38','2026-09-17 01:03:38'),
(190,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-17 01:03:38','2026-09-17 01:03:38'),
(191,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','curl/8.7.1',NULL,NULL,'/api/auth/login','POST','2026-09-17 01:26:08','2026-09-17 01:26:08'),
(192,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','curl/8.7.1',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-17 01:26:20','2026-09-17 01:26:20'),
(193,1,'user','read','Melihat daftar pengguna aplikasi','users',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/users','GET','2026-09-17 01:32:45','2026-09-17 01:32:45'),
(194,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-17 01:32:45','2026-09-17 01:32:45'),
(195,3,'attendance','update','Mengubah data presensi Ahmad Hermawan tanggal 2026-08-31','attendances',43,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','{\"attendance_date\":\"2026-08-30T17:00:00.000Z\",\"attendance_type\":\"hadir\",\"duration_hours\":\"8.00\",\"status\":\"terpenuhi\",\"checkin_location\":\"Gedung Utama\",\"checkout_location\":\"Gedung Utama\"}','{\"attendance_date\":\"2026-08-31\",\"attendance_type\":\"hadir\",\"duration_hours\":8,\"status\":\"terpenuhi\",\"checkin_location\":\"Gedung Utama\",\"checkout_location\":\"Gedung Utama\"}','/api/attendances/43','PUT','2026-09-17 01:33:27','2026-09-17 01:33:27'),
(196,3,'attendance','update','Mengubah data presensi Ahmad Hermawan tanggal 2026-08-31','attendances',43,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','{\"attendance_date\":\"2026-08-30T17:00:00.000Z\",\"attendance_type\":\"hadir\",\"duration_hours\":\"8.00\",\"status\":\"terpenuhi\",\"checkin_location\":\"Gedung Utama\",\"checkout_location\":\"Gedung Utama\"}','{\"attendance_date\":\"2026-08-31\",\"attendance_type\":\"hadir\",\"duration_hours\":8,\"status\":\"terpenuhi\",\"checkin_location\":\"Gedung Utama\",\"checkout_location\":\"Gedung Utama\"}','/api/attendances/43','PUT','2026-09-17 01:33:29','2026-09-17 01:33:29'),
(197,3,'attendance','create','Menambahkan data presensi Andi Nugroho (NIP: EMP-016) tanggal 2026-09-01','attendances',90,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,'{\"id\":90,\"employee_id\":32,\"attendance_date\":\"2026-09-01\",\"attendance_type\":\"hadir\",\"duration_hours\":8,\"status\":\"terpenuhi\",\"checkin_location\":\"Gedung B\",\"checkout_location\":\"Gedung B\"}','/api/attendances','POST','2026-09-17 01:34:21','2026-09-17 01:34:21'),
(198,3,'attendance','create','Menambahkan data presensi Arif Wijaya (NIP: EMP-022) tanggal 2026-09-17','attendances',92,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,'{\"id\":92,\"employee_id\":38,\"attendance_date\":\"2026-09-17\",\"attendance_type\":\"hadir\",\"duration_hours\":8,\"status\":\"terpenuhi\",\"checkin_location\":\"Gedung Utama\",\"checkout_location\":\"Gedung Utama\"}','/api/attendances','POST','2026-09-17 01:35:10','2026-09-17 01:35:10'),
(199,3,'attendance','create','Menambahkan data presensi Arif Wijaya (NIP: EMP-022) tanggal 2026-09-15','attendances',93,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,'{\"id\":93,\"employee_id\":38,\"attendance_date\":\"2026-09-15\",\"attendance_type\":\"hadir\",\"duration_hours\":8,\"status\":\"terpenuhi\",\"checkin_location\":\"Gedung Utama\",\"checkout_location\":\"Gedung Utama\"}','/api/attendances','POST','2026-09-17 01:36:08','2026-09-17 01:36:08'),
(200,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','curl/8.7.1',NULL,NULL,'/api/auth/login','POST','2026-09-17 01:39:07','2026-09-17 01:39:07'),
(201,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','curl/8.7.1',NULL,NULL,'/api/auth/login','POST','2026-09-17 01:39:15','2026-09-17 01:39:15'),
(202,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-17 01:39:26','2026-09-17 01:39:26'),
(203,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-17 01:39:26','2026-09-17 01:39:26'),
(204,3,'attendance','create','Menambahkan data presensi Arif Wijaya (NIP: EMP-022) tanggal 2026-09-19','attendances',95,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,'{\"id\":95,\"employee_id\":38,\"attendance_date\":\"2026-09-19\",\"attendance_type\":\"hadir\",\"duration_hours\":8,\"status\":\"terpenuhi\",\"checkin_location\":\"Gedung Utama\",\"checkout_location\":\"Gedung Utama\"}','/api/attendances','POST','2026-09-17 01:39:38','2026-09-17 01:39:38'),
(205,3,'auth','login','Request OTP login untuk user admin.hrd (Admin HRD)','users',3,'::1','node',NULL,NULL,'/api/auth/login','POST','2026-09-17 01:43:13','2026-09-17 01:43:13'),
(206,3,'auth','login','User admin.hrd berhasil login dengan role admin_hrd (RememberMe: false)','users',3,'::1','node',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-17 01:43:14','2026-09-17 01:43:14'),
(207,3,'attendance','create','Menambahkan data presensi Andi Nugroho (NIP: EMP-016) tanggal 2026-08-01','attendances',96,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,'{\"id\":96,\"employee_id\":32,\"attendance_date\":\"2026-08-01\",\"attendance_type\":\"hadir\",\"duration_hours\":4,\"status\":\"tidak_terpenuhi\",\"checkin_location\":\"Gedung Utama\",\"checkout_location\":\"Gedung Utama\"}','/api/attendances','POST','2026-09-17 01:45:12','2026-09-17 01:45:12'),
(208,3,'attendance','delete','Menghapus data presensi Andi Nugroho tanggal 2026-08-01','attendances',96,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','{\"id\":96,\"employee_id\":32,\"attendance_date\":\"2026-08-01\",\"attendance_type\":\"hadir\",\"duration_hours\":\"4.00\",\"status\":\"tidak_terpenuhi\"}',NULL,'/api/attendances/96','DELETE','2026-09-17 01:45:31','2026-09-17 01:45:31'),
(209,3,'attendance','create','Import data presensi (attendance-import-simulation.csv): 76 berhasil, 0 gagal','attendance_imports',2,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,'{\"import_id\":2,\"filename\":\"attendance-import-simulation.csv\",\"total_rows\":76,\"processed_rows\":76,\"failed_rows\":0}','/api/attendances/import','POST','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(210,1,'user','read','Melihat daftar pengguna aplikasi','users',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/users','GET','2026-09-17 03:02:10','2026-09-17 03:02:10'),
(211,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-17 03:02:10','2026-09-17 03:02:10'),
(212,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 03:15:21','2026-09-17 03:15:21'),
(213,2,'transport_allowance','read','Melihat detail tunjangan transport periode September 2026 (ID: 9)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/9?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:15:23','2026-09-17 03:15:23'),
(214,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 03:15:24','2026-09-17 03:15:24'),
(215,2,'transport_allowance','read','Melihat detail tunjangan transport periode Juli 2026 (ID: 8)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/8?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:15:25','2026-09-17 03:15:25'),
(216,2,'transport_allowance','read','Melihat detail tunjangan transport periode Juli 2026 (ID: 8)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/8?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:15:31','2026-09-17 03:15:31'),
(217,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 03:21:19','2026-09-17 03:21:19'),
(218,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:35:50','2026-09-17 03:35:50'),
(219,3,'transport_setting','read','Melihat konfigurasi setting tunjangan transport aktif',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/settings','GET','2026-09-17 03:35:52','2026-09-17 03:35:52'),
(220,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 03:35:52','2026-09-17 03:35:52'),
(221,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 03:36:05','2026-09-17 03:36:05'),
(222,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 03:36:08','2026-09-17 03:36:08'),
(223,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 03:36:11','2026-09-17 03:36:11'),
(224,2,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:36:14','2026-09-17 03:36:14'),
(225,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 03:36:20','2026-09-17 03:36:20'),
(226,1,'user','read','Melihat daftar pengguna aplikasi','users',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/users','GET','2026-09-17 03:38:47','2026-09-17 03:38:47'),
(227,1,'role','read','Melihat daftar role pengguna','roles',NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/roles','GET','2026-09-17 03:38:47','2026-09-17 03:38:47'),
(228,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:39:49','2026-09-17 03:39:49'),
(229,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 03:39:50','2026-09-17 03:39:50'),
(230,3,'transport_allowance','read','Melihat detail tunjangan transport periode November 2025 (ID: 10)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/10?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:39:53','2026-09-17 03:39:53'),
(231,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 03:39:54','2026-09-17 03:39:54'),
(232,3,'transport_allowance','read','Melihat detail tunjangan transport periode September 2026 (ID: 9)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/9?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:39:55','2026-09-17 03:39:55'),
(233,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 03:40:01','2026-09-17 03:40:01'),
(234,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 03:40:03','2026-09-17 03:40:03'),
(235,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:40:04','2026-09-17 03:40:04'),
(236,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:44:12','2026-09-17 03:44:12'),
(237,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Agustus 2026: 8 penerima, total Rp 7.110.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1/calculate','POST','2026-09-17 03:44:14','2026-09-17 03:44:14'),
(238,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:44:14','2026-09-17 03:44:14'),
(239,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Agustus 2026: 8 penerima, total Rp 7.110.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1/calculate','POST','2026-09-17 03:44:14','2026-09-17 03:44:14'),
(240,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:44:15','2026-09-17 03:44:15'),
(241,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Agustus 2026: 8 penerima, total Rp 7.110.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1/calculate','POST','2026-09-17 03:44:15','2026-09-17 03:44:15'),
(242,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:44:15','2026-09-17 03:44:15'),
(243,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Agustus 2026: 8 penerima, total Rp 7.110.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1/calculate','POST','2026-09-17 03:44:15','2026-09-17 03:44:15'),
(244,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:44:15','2026-09-17 03:44:15'),
(245,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Agustus 2026: 8 penerima, total Rp 7.110.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1/calculate','POST','2026-09-17 03:44:16','2026-09-17 03:44:16'),
(246,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:44:16','2026-09-17 03:44:16'),
(247,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Agustus 2026: 8 penerima, total Rp 7.110.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1/calculate','POST','2026-09-17 03:44:16','2026-09-17 03:44:16'),
(248,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:44:16','2026-09-17 03:44:16'),
(249,3,'transport_setting','read','Melihat konfigurasi setting tunjangan transport aktif',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/settings','GET','2026-09-17 03:44:28','2026-09-17 03:44:28'),
(250,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 03:44:29','2026-09-17 03:44:29'),
(251,3,'transport_allowance','read','Melihat detail tunjangan transport periode September 2026 (ID: 9)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/9?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:44:32','2026-09-17 03:44:32'),
(252,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 03:44:43','2026-09-17 03:44:43'),
(253,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:52:02','2026-09-17 03:52:02'),
(254,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Agustus 2026: 8 penerima, total Rp 7.110.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1/calculate','POST','2026-09-17 03:52:06','2026-09-17 03:52:06'),
(255,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 03:52:06','2026-09-17 03:52:06'),
(256,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 06:57:21','2026-09-17 06:57:21'),
(257,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 06:57:48','2026-09-17 06:57:48'),
(258,3,'transport_setting','read','Melihat konfigurasi setting tunjangan transport aktif',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/settings','GET','2026-09-17 06:57:49','2026-09-17 06:57:49'),
(259,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 06:57:51','2026-09-17 06:57:51'),
(260,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 06:58:45','2026-09-17 06:58:45'),
(261,3,'transport_setting','read','Melihat konfigurasi setting tunjangan transport aktif',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/settings','GET','2026-09-17 06:58:47','2026-09-17 06:58:47'),
(262,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:02:38','2026-09-17 07:02:38'),
(263,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:02:40','2026-09-17 07:02:40'),
(264,3,'transport_setting','read','Melihat konfigurasi setting tunjangan transport aktif',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/settings','GET','2026-09-17 07:02:55','2026-09-17 07:02:55'),
(265,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:02:56','2026-09-17 07:02:56'),
(266,3,'transport_setting','read','Melihat konfigurasi setting tunjangan transport aktif',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/settings','GET','2026-09-17 07:02:58','2026-09-17 07:02:58'),
(267,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:03:00','2026-09-17 07:03:00'),
(268,3,'transport_setting','read','Melihat konfigurasi setting tunjangan transport aktif',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/settings','GET','2026-09-17 07:03:00','2026-09-17 07:03:00'),
(269,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:03:53','2026-09-17 07:03:53'),
(270,3,'transport_setting','read','Melihat konfigurasi setting tunjangan transport aktif',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/settings','GET','2026-09-17 07:03:54','2026-09-17 07:03:54'),
(271,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:03:54','2026-09-17 07:03:54'),
(272,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:04:02','2026-09-17 07:04:02'),
(273,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:04:19','2026-09-17 07:04:19'),
(274,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:05:30','2026-09-17 07:05:30'),
(275,2,'auth','logout','User manager.hrd telah logout','users',2,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/logout','POST','2026-09-17 07:05:56','2026-09-17 07:05:56'),
(276,2,'auth','login','Request OTP login untuk user manager.hrd (Manager HRD)','users',2,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/login','POST','2026-09-17 07:06:07','2026-09-17 07:06:07'),
(277,2,'auth','login','Request OTP login untuk user manager.hrd (Manager HRD)','users',2,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/login','POST','2026-09-17 07:06:16','2026-09-17 07:06:16'),
(278,2,'auth','login','User manager.hrd berhasil login dengan role manager_hrd (RememberMe: true)','users',2,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/auth/verify-otp','POST','2026-09-17 07:06:20','2026-09-17 07:06:20'),
(279,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:06:25','2026-09-17 07:06:25'),
(280,2,'transport_allowance','read','Melihat detail tunjangan transport periode September 2026 (ID: 9)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/9?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:06:30','2026-09-17 07:06:30'),
(281,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:06:31','2026-09-17 07:06:31'),
(282,2,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:06:32','2026-09-17 07:06:32'),
(283,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:06:35','2026-09-17 07:06:35'),
(284,2,'transport_allowance','read','Melihat detail tunjangan transport periode Juni 2026 (ID: 7)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/7?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:06:35','2026-09-17 07:06:35'),
(285,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:06:38','2026-09-17 07:06:38'),
(286,2,'transport_allowance','read','Melihat detail tunjangan transport periode Januari 2026 (ID: 2)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/2?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:06:40','2026-09-17 07:06:40'),
(287,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:06:40','2026-09-17 07:06:40'),
(288,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: 2026)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12&year=2026','GET','2026-09-17 07:07:09','2026-09-17 07:07:09'),
(289,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: 2025)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12&year=2025','GET','2026-09-17 07:07:11','2026-09-17 07:07:11'),
(290,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:07:14','2026-09-17 07:07:14'),
(291,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:08:27','2026-09-17 07:08:27'),
(292,3,'transport_setting','read','Melihat konfigurasi setting tunjangan transport aktif',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/settings','GET','2026-09-17 07:08:29','2026-09-17 07:08:29'),
(293,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:08:31','2026-09-17 07:08:31'),
(294,3,'transport_setting','read','Melihat konfigurasi setting tunjangan transport aktif',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/settings','GET','2026-09-17 07:08:34','2026-09-17 07:08:34'),
(295,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:08:37','2026-09-17 07:08:37'),
(296,3,'transport_setting','read','Melihat konfigurasi setting tunjangan transport aktif',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/settings','GET','2026-09-17 07:08:42','2026-09-17 07:08:42'),
(297,3,'transport_setting','update','Menyimpan setting tunjangan transport baru: Base Fare Rp 500.000, Berlaku Mulai: 2025-12-31, Min: 5km, Max: 25km, Min Hari: 19',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/settings','POST','2026-09-17 07:08:52','2026-09-17 07:08:52'),
(298,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:08:53','2026-09-17 07:08:53'),
(299,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:08:56','2026-09-17 07:08:56'),
(300,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Agustus 2026: 8 penerima, total Rp 711.000.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1/calculate','POST','2026-09-17 07:08:57','2026-09-17 07:08:57'),
(301,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:08:57','2026-09-17 07:08:57'),
(302,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:08:58','2026-09-17 07:08:58'),
(303,3,'transport_setting','read','Melihat konfigurasi setting tunjangan transport aktif',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/settings','GET','2026-09-17 07:09:03','2026-09-17 07:09:03'),
(304,3,'transport_setting','update','Menyimpan setting tunjangan transport baru: Base Fare Rp 5.000, Berlaku Mulai: 2025-12-30, Min: 5km, Max: 25km, Min Hari: 19',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/settings','POST','2026-09-17 07:09:07','2026-09-17 07:09:07'),
(305,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:09:09','2026-09-17 07:09:09'),
(306,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:09:11','2026-09-17 07:09:11'),
(307,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Agustus 2026: 8 penerima, total Rp 7.110.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1/calculate','POST','2026-09-17 07:09:12','2026-09-17 07:09:12'),
(308,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:09:12','2026-09-17 07:09:12'),
(309,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:10:23','2026-09-17 07:10:23'),
(310,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=desc','GET','2026-09-17 07:10:24','2026-09-17 07:10:24'),
(311,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:10:25','2026-09-17 07:10:25'),
(312,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=desc','GET','2026-09-17 07:10:25','2026-09-17 07:10:25'),
(313,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:10:26','2026-09-17 07:10:26'),
(314,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=desc','GET','2026-09-17 07:10:26','2026-09-17 07:10:26'),
(315,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=km&sort_dir=asc','GET','2026-09-17 07:10:27','2026-09-17 07:10:27'),
(316,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=km&sort_dir=desc','GET','2026-09-17 07:10:27','2026-09-17 07:10:27'),
(317,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=km&sort_dir=asc','GET','2026-09-17 07:10:29','2026-09-17 07:10:29'),
(318,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=km&sort_dir=desc','GET','2026-09-17 07:10:30','2026-09-17 07:10:30'),
(319,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=hari&sort_dir=asc','GET','2026-09-17 07:10:31','2026-09-17 07:10:31'),
(320,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=hari&sort_dir=desc','GET','2026-09-17 07:10:31','2026-09-17 07:10:31'),
(321,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=nominal&sort_dir=asc','GET','2026-09-17 07:10:32','2026-09-17 07:10:32'),
(322,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=nominal&sort_dir=desc','GET','2026-09-17 07:10:33','2026-09-17 07:10:33'),
(323,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:10:35','2026-09-17 07:10:35'),
(324,3,'transport_allowance','read','Melihat detail tunjangan transport periode Juli 2026 (ID: 8)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/8?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:10:37','2026-09-17 07:10:37'),
(325,3,'transport_allowance','read','Melihat detail tunjangan transport periode Juli 2026 (ID: 8)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/8?page=1&limit=20&sort_by=km&sort_dir=asc','GET','2026-09-17 07:10:38','2026-09-17 07:10:38'),
(326,3,'transport_allowance','read','Melihat detail tunjangan transport periode Juli 2026 (ID: 8)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/8?page=1&limit=20&sort_by=hari&sort_dir=asc','GET','2026-09-17 07:10:39','2026-09-17 07:10:39'),
(327,3,'transport_allowance','read','Melihat detail tunjangan transport periode Juli 2026 (ID: 8)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/8?page=1&limit=20&sort_by=hari&sort_dir=desc','GET','2026-09-17 07:10:40','2026-09-17 07:10:40'),
(328,3,'transport_allowance','read','Melihat detail tunjangan transport periode Juli 2026 (ID: 8)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/8?page=1&limit=20&sort_by=hari&sort_dir=asc','GET','2026-09-17 07:10:40','2026-09-17 07:10:40'),
(329,3,'transport_allowance','read','Melihat detail tunjangan transport periode Juli 2026 (ID: 8)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/8?page=1&limit=20&sort_by=hari&sort_dir=desc','GET','2026-09-17 07:10:40','2026-09-17 07:10:40'),
(330,3,'transport_allowance','read','Melihat detail tunjangan transport periode Juli 2026 (ID: 8)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/8?page=1&limit=20&sort_by=hari&sort_dir=asc','GET','2026-09-17 07:10:40','2026-09-17 07:10:40'),
(331,3,'transport_allowance','read','Melihat detail tunjangan transport periode Juli 2026 (ID: 8)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/8?page=1&limit=20&sort_by=nominal&sort_dir=asc','GET','2026-09-17 07:10:41','2026-09-17 07:10:41'),
(332,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:10:42','2026-09-17 07:10:42'),
(333,3,'transport_allowance','read','Melihat detail tunjangan transport periode Mei 2026 (ID: 6)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/6?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:10:44','2026-09-17 07:10:44'),
(334,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Mei 2026: 0 penerima, total Rp 0',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/6/calculate','POST','2026-09-17 07:10:47','2026-09-17 07:10:47'),
(335,3,'transport_allowance','read','Melihat detail tunjangan transport periode Mei 2026 (ID: 6)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/6?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:10:47','2026-09-17 07:10:47'),
(336,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:10:48','2026-09-17 07:10:48'),
(337,3,'transport_allowance','read','Melihat detail tunjangan transport periode Juni 2026 (ID: 7)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/7?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:10:50','2026-09-17 07:10:50'),
(338,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Juni 2026: 0 penerima, total Rp 0',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/7/calculate','POST','2026-09-17 07:10:51','2026-09-17 07:10:51'),
(339,3,'transport_allowance','read','Melihat detail tunjangan transport periode Juni 2026 (ID: 7)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/7?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:10:51','2026-09-17 07:10:51'),
(340,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:10:52','2026-09-17 07:10:52'),
(341,3,'transport_allowance','read','Melihat detail tunjangan transport periode April 2026 (ID: 5)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/5?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:10:54','2026-09-17 07:10:54'),
(342,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode April 2026: 0 penerima, total Rp 0',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/5/calculate','POST','2026-09-17 07:10:55','2026-09-17 07:10:55'),
(343,3,'transport_allowance','read','Melihat detail tunjangan transport periode April 2026 (ID: 5)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/5?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:10:55','2026-09-17 07:10:55'),
(344,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:10:55','2026-09-17 07:10:55'),
(345,3,'transport_allowance','read','Melihat detail tunjangan transport periode Maret 2026 (ID: 4)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/4?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:10:57','2026-09-17 07:10:57'),
(346,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Maret 2026: 0 penerima, total Rp 0',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/4/calculate','POST','2026-09-17 07:10:58','2026-09-17 07:10:58'),
(347,3,'transport_allowance','read','Melihat detail tunjangan transport periode Maret 2026 (ID: 4)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/4?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:10:58','2026-09-17 07:10:58'),
(348,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:10:58','2026-09-17 07:10:58'),
(349,3,'transport_allowance','read','Melihat detail tunjangan transport periode Februari 2026 (ID: 3)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/3?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:11:00','2026-09-17 07:11:00'),
(350,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Februari 2026: 0 penerima, total Rp 0',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/3/calculate','POST','2026-09-17 07:11:01','2026-09-17 07:11:01'),
(351,3,'transport_allowance','read','Melihat detail tunjangan transport periode Februari 2026 (ID: 3)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/3?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:11:01','2026-09-17 07:11:01'),
(352,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:11:02','2026-09-17 07:11:02'),
(353,3,'transport_allowance','read','Melihat detail tunjangan transport periode Januari 2026 (ID: 2)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/2?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:11:03','2026-09-17 07:11:03'),
(354,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Januari 2026: 0 penerima, total Rp 0',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/2/calculate','POST','2026-09-17 07:11:04','2026-09-17 07:11:04'),
(355,3,'transport_allowance','read','Melihat detail tunjangan transport periode Januari 2026 (ID: 2)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/2?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:11:04','2026-09-17 07:11:04'),
(356,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:11:05','2026-09-17 07:11:05'),
(357,3,'transport_allowance','read','Melihat detail tunjangan transport periode Desember 2025 (ID: 11)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/11?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:11:06','2026-09-17 07:11:06'),
(358,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Desember 2025: 0 penerima, total Rp 0',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/11/calculate','POST','2026-09-17 07:11:10','2026-09-17 07:11:10'),
(359,3,'transport_allowance','read','Melihat detail tunjangan transport periode Desember 2025 (ID: 11)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/11?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:11:10','2026-09-17 07:11:10'),
(360,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:11:11','2026-09-17 07:11:11'),
(361,3,'transport_allowance','read','Melihat detail tunjangan transport periode November 2025 (ID: 10)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/10?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:11:12','2026-09-17 07:11:12'),
(362,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode November 2025: 0 penerima, total Rp 0',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/10/calculate','POST','2026-09-17 07:11:13','2026-09-17 07:11:13'),
(363,3,'transport_allowance','read','Melihat detail tunjangan transport periode November 2025 (ID: 10)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/10?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:11:13','2026-09-17 07:11:13'),
(364,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:11:14','2026-09-17 07:11:14'),
(365,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:11:47','2026-09-17 07:11:47'),
(366,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:15:58','2026-09-17 07:15:58'),
(367,2,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:15:59','2026-09-17 07:15:59'),
(368,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:16:01','2026-09-17 07:16:01'),
(369,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:16:08','2026-09-17 07:16:08'),
(370,3,'transport_allowance','read','Melihat detail tunjangan transport periode September 2026 (ID: 9)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/9?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:09','2026-09-17 07:16:09'),
(371,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode September 2026: 0 penerima, total Rp 0',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/9/calculate','POST','2026-09-17 07:16:11','2026-09-17 07:16:11'),
(372,3,'transport_allowance','read','Melihat detail tunjangan transport periode September 2026 (ID: 9)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/9?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:11','2026-09-17 07:16:11'),
(373,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:16:12','2026-09-17 07:16:12'),
(374,3,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:13','2026-09-17 07:16:13'),
(375,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:16:14','2026-09-17 07:16:14'),
(376,3,'transport_allowance','read','Melihat detail tunjangan transport periode April 2026 (ID: 5)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/5?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:16','2026-09-17 07:16:16'),
(377,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode April 2026: 9 penerima, total Rp 8.210.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/5/calculate','POST','2026-09-17 07:16:18','2026-09-17 07:16:18'),
(378,3,'transport_allowance','read','Melihat detail tunjangan transport periode April 2026 (ID: 5)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/5?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:18','2026-09-17 07:16:18'),
(379,3,'transport_allowance','read','Melihat detail tunjangan transport periode April 2026 (ID: 5)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/5?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:19','2026-09-17 07:16:19'),
(380,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode April 2026: 9 penerima, total Rp 8.210.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/5/calculate','POST','2026-09-17 07:16:20','2026-09-17 07:16:20'),
(381,3,'transport_allowance','read','Melihat detail tunjangan transport periode April 2026 (ID: 5)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/5?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:20','2026-09-17 07:16:20'),
(382,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:16:21','2026-09-17 07:16:21'),
(383,3,'transport_allowance','read','Melihat detail tunjangan transport periode Mei 2026 (ID: 6)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/6?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:23','2026-09-17 07:16:23'),
(384,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Mei 2026: 9 penerima, total Rp 8.630.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/6/calculate','POST','2026-09-17 07:16:25','2026-09-17 07:16:25'),
(385,3,'transport_allowance','read','Melihat detail tunjangan transport periode Mei 2026 (ID: 6)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/6?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:25','2026-09-17 07:16:25'),
(386,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:16:28','2026-09-17 07:16:28'),
(387,3,'transport_allowance','read','Melihat detail tunjangan transport periode Juni 2026 (ID: 7)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/7?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:31','2026-09-17 07:16:31'),
(388,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Juni 2026: 9 penerima, total Rp 8.365.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/7/calculate','POST','2026-09-17 07:16:33','2026-09-17 07:16:33'),
(389,3,'transport_allowance','read','Melihat detail tunjangan transport periode Juni 2026 (ID: 7)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/7?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:33','2026-09-17 07:16:33'),
(390,2,'transport_allowance','read','Melihat detail tunjangan transport periode Agustus 2026 (ID: 1)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/1?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:41','2026-09-17 07:16:41'),
(391,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:16:42','2026-09-17 07:16:42'),
(392,2,'transport_allowance','read','Melihat detail tunjangan transport periode Juli 2026 (ID: 8)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/8?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:43','2026-09-17 07:16:43'),
(393,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:16:44','2026-09-17 07:16:44'),
(394,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Juni 2026: 9 penerima, total Rp 8.365.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/7/calculate','POST','2026-09-17 07:16:48','2026-09-17 07:16:48'),
(395,3,'transport_allowance','read','Melihat detail tunjangan transport periode Juni 2026 (ID: 7)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/7?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:48','2026-09-17 07:16:48'),
(396,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:16:49','2026-09-17 07:16:49'),
(397,3,'transport_allowance','read','Melihat detail tunjangan transport periode Juli 2026 (ID: 8)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/8?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:51','2026-09-17 07:16:51'),
(398,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode Juli 2026: 9 penerima, total Rp 8.560.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/8/calculate','POST','2026-09-17 07:16:54','2026-09-17 07:16:54'),
(399,3,'transport_allowance','read','Melihat detail tunjangan transport periode Juli 2026 (ID: 8)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/8?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:16:54','2026-09-17 07:16:54'),
(400,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:16:59','2026-09-17 07:16:59'),
(401,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:18:16','2026-09-17 07:18:16'),
(402,2,'transport_allowance','read','Melihat detail tunjangan transport periode November 2025 (ID: 10)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/10?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:18:16','2026-09-17 07:18:16'),
(403,3,'transport_allowance','read','Melihat detail tunjangan transport periode November 2025 (ID: 10)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/10?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:18:57','2026-09-17 07:18:57'),
(404,3,'transport_allowance','read','Melihat detail tunjangan transport periode November 2025 (ID: 10)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/10?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:18:58','2026-09-17 07:18:58'),
(405,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode November 2025: 9 penerima, total Rp 8.245.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/10/calculate','POST','2026-09-17 07:18:59','2026-09-17 07:18:59'),
(406,3,'transport_allowance','read','Melihat detail tunjangan transport periode November 2025 (ID: 10)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/10?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:18:59','2026-09-17 07:18:59'),
(407,2,'transport_allowance','read','Melihat detail tunjangan transport periode November 2025 (ID: 10)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/10?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:19:02','2026-09-17 07:19:02'),
(408,2,'transport_allowance','read','Melihat detail tunjangan transport periode November 2025 (ID: 10)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/10?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:21:02','2026-09-17 07:21:02'),
(409,3,'transport_allowance','read','Melihat detail tunjangan transport periode November 2025 (ID: 10)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/10?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:21:04','2026-09-17 07:21:04'),
(410,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode November 2025: 9 penerima, total Rp 9.540.000',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/10/calculate','POST','2026-09-17 07:21:06','2026-09-17 07:21:06'),
(411,3,'transport_allowance','read','Melihat detail tunjangan transport periode November 2025 (ID: 10)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/10?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:21:06','2026-09-17 07:21:06'),
(412,3,'transport_allowance','read','Melihat detail tunjangan transport periode November 2025 (ID: 10)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/10?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:21:07','2026-09-17 07:21:07'),
(413,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:21:08','2026-09-17 07:21:08'),
(414,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:21:10','2026-09-17 07:21:10'),
(415,3,'transport_allowance','read','Melihat detail tunjangan transport periode September 2026 (ID: 9)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/9?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:21:11','2026-09-17 07:21:11'),
(416,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode September 2026: 0 penerima, total Rp 0',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/9/calculate','POST','2026-09-17 07:21:12','2026-09-17 07:21:12'),
(417,3,'transport_allowance','read','Melihat detail tunjangan transport periode September 2026 (ID: 9)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/9?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:21:12','2026-09-17 07:21:12'),
(418,3,'transport_allowance','update','Melakukan perhitungan tunjangan transport periode September 2026: 0 penerima, total Rp 0',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/9/calculate','POST','2026-09-17 07:21:12','2026-09-17 07:21:12'),
(419,3,'transport_allowance','read','Melihat detail tunjangan transport periode September 2026 (ID: 9)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods/9?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:21:12','2026-09-17 07:21:12'),
(420,3,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:21:13','2026-09-17 07:21:13'),
(421,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:24:34','2026-09-17 07:24:34'),
(422,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:24:38','2026-09-17 07:24:38'),
(423,2,'transport_allowance','read','Melihat detail tunjangan transport periode September 2026 (ID: 9)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/9?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:24:41','2026-09-17 07:24:41'),
(424,2,'transport_allowance','read','Melihat detail tunjangan transport periode September 2026 (ID: 9)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods/9?page=1&limit=20&sort_by=name&sort_dir=asc','GET','2026-09-17 07:24:43','2026-09-17 07:24:43'),
(425,2,'transport_allowance','read','Melihat daftar periode tunjangan transport (tahun: semua)',NULL,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15',NULL,NULL,'/api/transport/periods?page=1&limit=12','GET','2026-09-17 07:24:43','2026-09-17 07:24:43');
/*!40000 ALTER TABLE `activity_logs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `attendance_imports`
--

DROP TABLE IF EXISTS `attendance_imports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_imports` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `original_filename` varchar(255) NOT NULL,
  `period_year` smallint(5) unsigned NOT NULL,
  `period_month` tinyint(3) unsigned NOT NULL,
  `status` enum('queued','processing','completed','failed') NOT NULL DEFAULT 'queued',
  `total_rows` int(10) unsigned NOT NULL DEFAULT 0,
  `processed_rows` int(10) unsigned NOT NULL DEFAULT 0,
  `error_message` text DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_attendance_imports_user_id` (`user_id`),
  KEY `idx_attendance_imports_period` (`period_year`,`period_month`),
  KEY `idx_attendance_imports_status` (`status`),
  CONSTRAINT `fk_attendance_imports_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `chk_attendance_imports_month` CHECK (`period_month` between 1 and 12),
  CONSTRAINT `chk_attendance_imports_rows` CHECK (`processed_rows` <= `total_rows`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_imports`
--

LOCK TABLES `attendance_imports` WRITE;
/*!40000 ALTER TABLE `attendance_imports` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `attendance_imports` VALUES
(1,3,'test-import-agustus.csv',2026,9,'completed',6,4,'[{\"row\":5,\"nip\":\"EMP-004\",\"message\":\"Pegawai dengan NIP \'EMP-004\' tidak terdaftar di sistem\"},{\"row\":6,\"nip\":\"EMP-005\",\"message\":\"Pegawai dengan NIP \'EMP-005\' tidak terdaftar di sistem\"}]','2026-09-17 00:46:18','2026-09-17 00:46:18','2026-09-17 00:46:18','2026-09-17 00:46:18'),
(2,3,'attendance-import-simulation.csv',2026,9,'completed',76,76,NULL,'2026-09-17 01:49:39','2026-09-17 01:49:39','2026-09-17 01:49:39','2026-09-17 01:49:39');
/*!40000 ALTER TABLE `attendance_imports` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `attendance_summaries`
--

DROP TABLE IF EXISTS `attendance_summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_summaries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `period_year` smallint(5) unsigned NOT NULL,
  `period_month` tinyint(3) unsigned NOT NULL,
  `hadir` smallint(5) unsigned NOT NULL DEFAULT 0,
  `cuti` smallint(5) unsigned NOT NULL DEFAULT 0,
  `kuota_cuti` smallint(5) unsigned NOT NULL DEFAULT 0,
  `izin` smallint(5) unsigned NOT NULL DEFAULT 0,
  `kuota_izin` smallint(5) unsigned NOT NULL DEFAULT 0,
  `unpaid_leave` smallint(5) unsigned NOT NULL DEFAULT 0,
  `kuota_unpaid_leave` smallint(5) unsigned NOT NULL DEFAULT 0,
  `status_hadir` varchar(30) DEFAULT NULL,
  `calculated_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_attendance_summaries_employee_period` (`employee_id`,`period_year`,`period_month`),
  KEY `idx_attendance_summaries_period` (`period_year`,`period_month`),
  CONSTRAINT `fk_attendance_summaries_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `chk_attendance_summaries_month` CHECK (`period_month` between 1 and 12)
) ENGINE=InnoDB AUTO_INCREMENT=769 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_summaries`
--

LOCK TABLES `attendance_summaries` WRITE;
/*!40000 ALTER TABLE `attendance_summaries` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `attendance_summaries` VALUES
(1,1,2026,8,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 00:42:51','2026-09-17 07:20:33'),
(6,2,2026,8,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 00:46:18','2026-09-17 07:20:33'),
(7,3,2026,8,18,1,12,0,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 00:46:18','2026-09-17 07:20:33'),
(8,16,2026,8,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 00:46:18','2026-09-17 07:20:33'),
(9,32,2026,8,12,1,12,2,3,1,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 01:25:50','2026-09-17 07:20:33'),
(15,32,2026,9,1,0,12,0,3,0,5,'Tidak terpenuhi','2026-09-17 01:34:21','2026-09-17 01:34:21','2026-09-17 01:34:21'),
(16,38,2026,9,3,0,12,0,3,0,5,'Tidak terpenuhi','2026-09-17 01:39:38','2026-09-17 01:35:10','2026-09-17 01:39:38'),
(21,17,2026,8,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 01:49:39','2026-09-17 07:20:33'),
(22,24,2026,8,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 01:49:39','2026-09-17 07:20:33'),
(23,25,2026,8,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 01:49:39','2026-09-17 07:20:33'),
(24,26,2026,8,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 01:49:39','2026-09-17 07:20:33'),
(29,27,2026,8,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 03:11:57','2026-09-17 07:20:33'),
(30,29,2026,8,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 03:11:57','2026-09-17 07:20:33'),
(31,30,2026,8,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 03:11:57','2026-09-17 07:20:33'),
(32,35,2026,8,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 03:11:57','2026-09-17 07:20:33'),
(33,36,2026,8,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 03:11:57','2026-09-17 07:20:33'),
(34,38,2026,8,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 03:11:57','2026-09-17 07:20:33'),
(35,1,2026,7,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 03:11:57','2026-09-17 07:20:33'),
(36,17,2026,7,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 03:11:57','2026-09-17 07:20:33'),
(37,24,2026,7,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 03:11:57','2026-09-17 07:20:33'),
(38,29,2026,7,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 03:11:57','2026-09-17 07:20:33'),
(39,30,2026,7,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 03:11:57','2026-09-17 07:20:33'),
(40,35,2026,7,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 03:11:57','2026-09-17 07:20:33'),
(41,36,2026,7,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 03:11:57','2026-09-17 07:20:33'),
(42,38,2026,7,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 03:11:57','2026-09-17 07:20:33'),
(49,1,2025,11,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(50,2,2025,11,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(51,3,2025,11,18,1,12,0,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(52,14,2025,11,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(53,15,2025,11,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(54,16,2025,11,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(55,17,2025,11,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(56,24,2025,11,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(57,25,2025,11,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(58,26,2025,11,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(59,27,2025,11,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(60,28,2025,11,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(61,29,2025,11,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(62,30,2025,11,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(63,31,2025,11,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(64,32,2025,11,16,1,12,2,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(65,33,2025,11,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(66,34,2025,11,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(67,35,2025,11,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(68,36,2025,11,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(69,37,2025,11,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(70,38,2025,11,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(71,39,2025,11,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(72,40,2025,11,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(73,1,2025,12,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(74,2,2025,12,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(75,3,2025,12,18,1,12,0,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(76,14,2025,12,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(77,15,2025,12,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(78,16,2025,12,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(79,17,2025,12,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(80,24,2025,12,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(81,25,2025,12,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(82,26,2025,12,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(83,27,2025,12,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(84,28,2025,12,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(85,29,2025,12,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(86,30,2025,12,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(87,31,2025,12,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(88,32,2025,12,15,1,12,2,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(89,33,2025,12,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(90,34,2025,12,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(91,35,2025,12,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(92,36,2025,12,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(93,37,2025,12,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(94,38,2025,12,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(95,39,2025,12,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(96,40,2025,12,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(97,1,2026,1,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(98,2,2026,1,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(99,3,2026,1,18,1,12,0,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(100,14,2026,1,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(101,15,2026,1,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(102,16,2026,1,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(103,17,2026,1,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(104,24,2026,1,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(105,25,2026,1,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(106,26,2026,1,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(107,27,2026,1,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(108,28,2026,1,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(109,29,2026,1,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(110,30,2026,1,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(111,31,2026,1,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(112,32,2026,1,16,1,12,2,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(113,33,2026,1,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(114,34,2026,1,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(115,35,2026,1,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(116,36,2026,1,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(117,37,2026,1,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(118,38,2026,1,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(119,39,2026,1,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(120,40,2026,1,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(121,1,2026,2,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(122,2,2026,2,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(123,3,2026,2,18,1,12,0,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(124,14,2026,2,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(125,15,2026,2,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(126,16,2026,2,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(127,17,2026,2,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(128,24,2026,2,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(129,25,2026,2,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(130,26,2026,2,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(131,27,2026,2,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(132,28,2026,2,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(133,29,2026,2,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(134,30,2026,2,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(135,31,2026,2,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(136,32,2026,2,14,1,12,2,3,1,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(137,33,2026,2,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(138,34,2026,2,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(139,35,2026,2,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(140,36,2026,2,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(141,37,2026,2,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(142,38,2026,2,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(143,39,2026,2,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(144,40,2026,2,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(145,1,2026,3,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(146,2,2026,3,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(147,3,2026,3,18,1,12,0,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(148,14,2026,3,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(149,15,2026,3,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(150,16,2026,3,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(151,17,2026,3,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(152,24,2026,3,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(153,25,2026,3,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(154,26,2026,3,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(155,27,2026,3,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(156,28,2026,3,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(157,29,2026,3,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(158,30,2026,3,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(159,31,2026,3,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(160,32,2026,3,16,1,12,2,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(161,33,2026,3,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(162,34,2026,3,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(163,35,2026,3,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(164,36,2026,3,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(165,37,2026,3,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(166,38,2026,3,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(167,39,2026,3,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(168,40,2026,3,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(169,1,2026,4,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(170,2,2026,4,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(171,3,2026,4,18,1,12,0,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(172,14,2026,4,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(173,15,2026,4,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(174,16,2026,4,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(175,17,2026,4,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(176,24,2026,4,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(177,25,2026,4,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(178,26,2026,4,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(179,27,2026,4,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(180,28,2026,4,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(181,29,2026,4,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(182,30,2026,4,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(183,31,2026,4,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(184,32,2026,4,15,1,12,2,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(185,33,2026,4,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(186,34,2026,4,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(187,35,2026,4,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(188,36,2026,4,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(189,37,2026,4,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(190,38,2026,4,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(191,39,2026,4,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(192,40,2026,4,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(193,1,2026,5,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(194,2,2026,5,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(195,3,2026,5,18,1,12,0,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(196,14,2026,5,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(197,15,2026,5,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(198,16,2026,5,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(199,17,2026,5,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(200,24,2026,5,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(201,25,2026,5,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(202,26,2026,5,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(203,27,2026,5,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(204,28,2026,5,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(205,29,2026,5,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(206,30,2026,5,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(207,31,2026,5,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(208,32,2026,5,16,1,12,2,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(209,33,2026,5,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(210,34,2026,5,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(211,35,2026,5,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(212,36,2026,5,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(213,37,2026,5,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(214,38,2026,5,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(215,39,2026,5,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(216,40,2026,5,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(217,1,2026,6,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(218,2,2026,6,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(219,3,2026,6,18,1,12,0,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(220,14,2026,6,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(221,15,2026,6,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(222,16,2026,6,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(223,17,2026,6,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(224,24,2026,6,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(225,25,2026,6,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(226,26,2026,6,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(227,27,2026,6,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(228,28,2026,6,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(229,29,2026,6,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(230,30,2026,6,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(231,31,2026,6,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(232,32,2026,6,16,1,12,2,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(233,33,2026,6,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(234,34,2026,6,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(235,35,2026,6,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(236,36,2026,6,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(237,37,2026,6,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(238,38,2026,6,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(239,39,2026,6,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(240,40,2026,6,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(241,2,2026,7,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(242,3,2026,7,18,1,12,0,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(243,14,2026,7,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(244,15,2026,7,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(245,16,2026,7,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(246,25,2026,7,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(247,26,2026,7,19,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(248,27,2026,7,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(249,28,2026,7,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(250,31,2026,7,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(251,32,2026,7,16,1,12,2,3,0,5,'Tidak terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(252,33,2026,7,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(253,34,2026,7,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(254,37,2026,7,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(255,39,2026,7,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(256,40,2026,7,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(257,14,2026,8,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(258,15,2026,8,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(259,28,2026,8,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(260,31,2026,8,22,0,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(261,33,2026,8,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(262,34,2026,8,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(263,37,2026,8,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(264,39,2026,8,21,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33'),
(265,40,2026,8,20,1,12,0,3,0,5,'Terpenuhi','2026-09-17 07:20:33','2026-09-17 07:15:15','2026-09-17 07:20:33');
/*!40000 ALTER TABLE `attendance_summaries` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `attendances`
--

DROP TABLE IF EXISTS `attendances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendances` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `attendance_import_id` bigint(20) unsigned DEFAULT NULL,
  `attendance_date` date NOT NULL,
  `checkin_at` datetime DEFAULT NULL,
  `checkout_at` datetime DEFAULT NULL,
  `checkin_location` varchar(255) DEFAULT NULL,
  `checkout_location` varchar(255) DEFAULT NULL,
  `attendance_type` enum('hadir','cuti','izin','unpaid_leave') NOT NULL,
  `duration_hours` decimal(5,2) DEFAULT NULL,
  `status` enum('terpenuhi','tidak_terpenuhi') NOT NULL,
  `verification_status` varchar(30) DEFAULT NULL,
  `verified_by_role` varchar(50) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_attendances_employee_date` (`employee_id`,`attendance_date`),
  KEY `idx_attendances_import_id` (`attendance_import_id`),
  KEY `idx_attendances_date_type` (`attendance_date`,`attendance_type`),
  CONSTRAINT `fk_attendances_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_attendances_import` FOREIGN KEY (`attendance_import_id`) REFERENCES `attendance_imports` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_attendances_duration` CHECK (`duration_hours` is null or `duration_hours` >= 0),
  CONSTRAINT `chk_attendances_time_order` CHECK (`checkout_at` is null or `checkin_at` is null or `checkout_at` >= `checkin_at`)
) ENGINE=InnoDB AUTO_INCREMENT=503 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendances`
--

LOCK TABLES `attendances` WRITE;
/*!40000 ALTER TABLE `attendances` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `attendances` VALUES
(1,1,NULL,'2026-09-16','2026-09-16 08:01:00','2026-09-16 17:03:00','Gedung Utama','Gedung Utama','hadir',8.03,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-16 07:26:27','2026-09-17 01:25:50'),
(2,2,NULL,'2026-09-16',NULL,NULL,NULL,NULL,'cuti',NULL,'terpenuhi','Disetujui','Manager','Cuti tahunan','2026-09-16 07:26:27','2026-09-17 01:25:50'),
(3,3,NULL,'2026-09-16','2026-09-16 08:10:00','2026-09-16 17:00:00','Gedung B','Gedung B','hadir',7.83,'tidak_terpenuhi','Disetujui','Lead','Kurang dari 8 jam','2026-09-16 07:26:27','2026-09-17 01:25:50'),
(20,1,1,'2026-08-03','2026-08-03 08:00:00','2026-08-03 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 00:46:18','2026-09-17 00:46:18'),
(21,2,1,'2026-08-03','2026-08-03 08:05:00','2026-08-03 17:05:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 00:46:18','2026-09-17 01:25:50'),
(22,3,1,'2026-08-03','2026-08-03 08:10:00','2026-08-03 17:15:00','Gedung B','Gedung B','hadir',8.08,'terpenuhi','Disetujui','Lead','Hadir','2026-09-17 00:46:18','2026-09-17 01:25:50'),
(23,16,1,'2026-08-04',NULL,NULL,NULL,NULL,'unpaid_leave',0.00,'terpenuhi','Disetujui','HRD','Izin cuti di luar tanggungan','2026-09-17 00:46:18','2026-09-17 00:46:18'),
(24,1,NULL,'2026-08-04','2026-08-04 08:02:00','2026-08-04 17:05:00','Gedung Utama','Gedung Utama','hadir',8.05,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(25,1,NULL,'2026-08-05','2026-08-05 07:58:00','2026-08-05 17:00:00','Gedung Utama','Gedung Utama','hadir',8.03,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(26,1,NULL,'2026-08-06','2026-08-06 08:05:00','2026-08-06 17:10:00','Gedung Utama','Gedung Utama','hadir',8.08,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(27,1,NULL,'2026-08-07','2026-08-07 08:00:00','2026-08-07 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(28,1,NULL,'2026-08-10','2026-08-10 08:01:00','2026-08-10 17:02:00','Gedung Utama','Gedung Utama','hadir',8.02,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(29,1,NULL,'2026-08-11','2026-08-11 08:03:00','2026-08-11 17:04:00','Gedung Utama','Gedung Utama','hadir',8.02,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(30,1,NULL,'2026-08-12','2026-08-12 08:00:00','2026-08-12 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(31,1,NULL,'2026-08-13','2026-08-13 08:06:00','2026-08-13 17:10:00','Gedung Utama','Gedung Utama','hadir',8.07,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(32,1,NULL,'2026-08-14','2026-08-14 08:00:00','2026-08-14 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(33,1,NULL,'2026-08-17','2026-08-17 08:00:00','2026-08-17 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Upacara & Presensi','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(34,1,NULL,'2026-08-18','2026-08-18 08:04:00','2026-08-18 17:05:00','Gedung Utama','Gedung Utama','hadir',8.02,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(35,1,NULL,'2026-08-19','2026-08-19 08:00:00','2026-08-19 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(36,1,NULL,'2026-08-20','2026-08-20 08:02:00','2026-08-20 17:03:00','Gedung Utama','Gedung Utama','hadir',8.02,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(37,1,NULL,'2026-08-21','2026-08-21 08:01:00','2026-08-21 17:05:00','Gedung Utama','Gedung Utama','hadir',8.07,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(38,1,NULL,'2026-08-24','2026-08-24 08:00:00','2026-08-24 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(39,1,NULL,'2026-08-25','2026-08-25 08:05:00','2026-08-25 17:10:00','Gedung Utama','Gedung Utama','hadir',8.08,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(40,1,NULL,'2026-08-26','2026-08-26 08:00:00','2026-08-26 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(41,1,NULL,'2026-08-27','2026-08-27 08:03:00','2026-08-27 17:05:00','Gedung Utama','Gedung Utama','hadir',8.03,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(42,1,NULL,'2026-08-28','2026-08-28 08:00:00','2026-08-28 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(43,1,NULL,'2026-08-31','2026-08-31 08:00:00','2026-08-31 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 02:25:11'),
(44,2,NULL,'2026-08-04','2026-08-04 08:10:00','2026-08-04 17:15:00','Gedung A','Gedung A','hadir',8.08,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(45,2,NULL,'2026-08-05','2026-08-05 08:02:00','2026-08-05 17:05:00','Gedung A','Gedung A','hadir',8.05,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(46,2,NULL,'2026-08-06','2026-08-06 08:00:00','2026-08-06 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(47,2,NULL,'2026-08-07','2026-08-07 08:12:00','2026-08-07 17:15:00','Gedung A','Gedung A','hadir',8.05,'terpenuhi','Disetujui','Manager','Toleransi 15 menit','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(48,2,NULL,'2026-08-10','2026-08-10 08:00:00','2026-08-10 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(49,2,NULL,'2026-08-11','2026-08-11 08:04:00','2026-08-11 17:05:00','Gedung A','Gedung A','hadir',8.02,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(50,2,NULL,'2026-08-12','2026-08-12 08:00:00','2026-08-12 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(51,2,NULL,'2026-08-13','2026-08-13 08:08:00','2026-08-13 17:10:00','Gedung A','Gedung A','hadir',8.03,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(52,2,NULL,'2026-08-14','2026-08-14 08:00:00','2026-08-14 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(53,2,NULL,'2026-08-17','2026-08-17 08:00:00','2026-08-17 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Manager','Upacara & Presensi','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(54,2,NULL,'2026-08-18','2026-08-18 08:05:00','2026-08-18 17:05:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(55,2,NULL,'2026-08-19','2026-08-19 08:00:00','2026-08-19 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(56,2,NULL,'2026-08-20','2026-08-20 08:01:00','2026-08-20 17:02:00','Gedung A','Gedung A','hadir',8.02,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(57,2,NULL,'2026-08-21','2026-08-21 08:00:00','2026-08-21 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(58,2,NULL,'2026-08-24','2026-08-24 08:00:00','2026-08-24 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(59,2,NULL,'2026-08-25','2026-08-25 08:07:00','2026-08-25 17:10:00','Gedung A','Gedung A','hadir',8.05,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(60,2,NULL,'2026-08-26','2026-08-26 08:00:00','2026-08-26 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(61,2,NULL,'2026-08-27','2026-08-27 08:05:00','2026-08-27 17:05:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(62,2,NULL,'2026-08-28',NULL,NULL,NULL,NULL,'cuti',NULL,'terpenuhi','Disetujui','Manager','Cuti Tahunan','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(63,2,NULL,'2026-08-31','2026-08-31 08:00:00','2026-08-31 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(64,3,NULL,'2026-08-04','2026-08-04 08:00:00','2026-08-04 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(65,3,NULL,'2026-08-05','2026-08-05 08:05:00','2026-08-05 17:05:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(66,3,NULL,'2026-08-06','2026-08-06 08:00:00','2026-08-06 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(67,3,NULL,'2026-08-07',NULL,NULL,NULL,NULL,'cuti',NULL,'terpenuhi','Disetujui','HRD','Cuti Keluarga','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(68,3,NULL,'2026-08-10',NULL,NULL,NULL,NULL,'cuti',NULL,'terpenuhi','Disetujui','HRD','Cuti Keluarga','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(69,3,NULL,'2026-08-11','2026-08-11 08:00:00','2026-08-11 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(70,3,NULL,'2026-08-12','2026-08-12 08:00:00','2026-08-12 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(71,3,NULL,'2026-08-13',NULL,NULL,NULL,NULL,'izin',NULL,'terpenuhi','Disetujui','HRD','Izin Sakit','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(72,3,NULL,'2026-08-14',NULL,NULL,NULL,NULL,'izin',NULL,'terpenuhi','Disetujui','HRD','Izin Sakit','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(73,3,NULL,'2026-08-17','2026-08-17 08:00:00','2026-08-17 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Lead','Upacara','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(74,3,NULL,'2026-08-18','2026-08-18 08:00:00','2026-08-18 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(75,3,NULL,'2026-08-19','2026-08-19 08:00:00','2026-08-19 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(76,3,NULL,'2026-08-20','2026-08-20 08:00:00','2026-08-20 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(77,3,NULL,'2026-08-21','2026-08-21 08:00:00','2026-08-21 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(78,3,NULL,'2026-08-24',NULL,NULL,NULL,NULL,'unpaid_leave',NULL,'terpenuhi','Disetujui','HRD','Cuti Tanpa Gaji','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(79,3,NULL,'2026-08-25','2026-08-25 08:00:00','2026-08-25 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(80,3,NULL,'2026-08-26','2026-08-26 08:00:00','2026-08-26 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(81,3,NULL,'2026-08-27','2026-08-27 08:00:00','2026-08-27 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(82,3,NULL,'2026-08-28','2026-08-28 08:00:00','2026-08-28 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(83,3,NULL,'2026-08-31','2026-08-31 08:00:00','2026-08-31 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir','2026-09-17 01:25:50','2026-09-17 01:25:50'),
(90,32,NULL,'2026-09-01','2026-09-01 08:00:00','2026-09-01 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','HRD','qwqwq','2026-09-17 01:34:21','2026-09-17 01:34:21'),
(92,38,NULL,'2026-09-17','2026-09-17 08:00:00','2026-09-17 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD',NULL,'2026-09-17 01:35:10','2026-09-17 01:35:10'),
(93,38,NULL,'2026-09-15','2026-09-15 08:00:00','2026-09-15 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','asasasa','2026-09-17 01:36:08','2026-09-17 01:36:08'),
(95,38,NULL,'2026-09-19','2026-09-19 08:00:00','2026-09-19 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD',NULL,'2026-09-17 01:39:38','2026-09-17 01:39:38'),
(97,17,2,'2026-08-03','2026-08-03 08:00:00','2026-08-03 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(98,17,2,'2026-08-04','2026-08-04 08:05:00','2026-08-04 17:05:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(99,17,2,'2026-08-05','2026-08-05 08:00:00','2026-08-05 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(100,17,2,'2026-08-06','2026-08-06 08:02:00','2026-08-06 17:03:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(101,17,2,'2026-08-07','2026-08-07 08:00:00','2026-08-07 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(102,17,2,'2026-08-10','2026-08-10 08:01:00','2026-08-10 17:02:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(103,17,2,'2026-08-11','2026-08-11 08:00:00','2026-08-11 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(104,17,2,'2026-08-12','2026-08-12 08:04:00','2026-08-12 17:05:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(105,17,2,'2026-08-13','2026-08-13 08:00:00','2026-08-13 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(106,17,2,'2026-08-14','2026-08-14 08:06:00','2026-08-14 17:10:00','Gedung Utama','Gedung Utama','hadir',8.10,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(107,17,2,'2026-08-17','2026-08-17 08:00:00','2026-08-17 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Upacara & Presensi','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(108,17,2,'2026-08-18','2026-08-18 08:00:00','2026-08-18 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(109,17,2,'2026-08-19','2026-08-19 08:03:00','2026-08-19 17:05:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(110,17,2,'2026-08-20','2026-08-20 08:00:00','2026-08-20 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(111,17,2,'2026-08-21','2026-08-21 08:02:00','2026-08-21 17:05:00','Gedung Utama','Gedung Utama','hadir',8.10,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(112,17,2,'2026-08-24','2026-08-24 08:00:00','2026-08-24 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(113,17,2,'2026-08-25','2026-08-25 08:05:00','2026-08-25 17:10:00','Gedung Utama','Gedung Utama','hadir',8.10,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(114,17,2,'2026-08-26','2026-08-26 08:00:00','2026-08-26 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(115,17,2,'2026-08-27','2026-08-27 08:01:00','2026-08-27 17:02:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(116,17,2,'2026-08-28','2026-08-28 08:00:00','2026-08-28 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(117,17,2,'2026-08-31','2026-08-31 08:00:00','2026-08-31 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','HRD','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(118,24,2,'2026-08-03','2026-08-03 08:05:00','2026-08-03 17:05:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(119,24,2,'2026-08-04','2026-08-04 08:10:00','2026-08-04 17:15:00','Gedung B','Gedung B','hadir',8.10,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(120,24,2,'2026-08-05','2026-08-05 08:00:00','2026-08-05 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(121,24,2,'2026-08-06','2026-08-06 08:02:00','2026-08-06 17:05:00','Gedung B','Gedung B','hadir',8.10,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(122,24,2,'2026-08-07','2026-08-07 08:08:00','2026-08-07 17:10:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(123,24,2,'2026-08-10','2026-08-10 08:00:00','2026-08-10 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(124,24,2,'2026-08-11','2026-08-11 08:05:00','2026-08-11 17:05:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(125,24,2,'2026-08-12','2026-08-12 08:00:00','2026-08-12 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(126,24,2,'2026-08-13','2026-08-13 08:03:00','2026-08-13 17:05:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(127,24,2,'2026-08-14','2026-08-14 08:00:00','2026-08-14 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(128,24,2,'2026-08-17','2026-08-17 08:00:00','2026-08-17 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Manager','Upacara & Presensi','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(129,24,2,'2026-08-18','2026-08-18 08:06:00','2026-08-18 17:10:00','Gedung B','Gedung B','hadir',8.10,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(130,24,2,'2026-08-19','2026-08-19 08:00:00','2026-08-19 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(131,24,2,'2026-08-20','2026-08-20 08:04:00','2026-08-20 17:05:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(132,24,2,'2026-08-21','2026-08-21 08:00:00','2026-08-21 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(133,24,2,'2026-08-24','2026-08-24 08:00:00','2026-08-24 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(134,24,2,'2026-08-25','2026-08-25 08:07:00','2026-08-25 17:10:00','Gedung B','Gedung B','hadir',8.10,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(135,24,2,'2026-08-26','2026-08-26 08:00:00','2026-08-26 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(136,24,2,'2026-08-27','2026-08-27 08:02:00','2026-08-27 17:05:00','Gedung B','Gedung B','hadir',8.10,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(137,24,2,'2026-08-28',NULL,NULL,NULL,NULL,'cuti',0.00,'terpenuhi','Disetujui','HRD','Cuti tahunan','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(138,24,2,'2026-08-31','2026-08-31 08:00:00','2026-08-31 17:00:00','Gedung B','Gedung B','hadir',8.00,'terpenuhi','Disetujui','Manager','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(139,25,2,'2026-08-03','2026-08-03 08:00:00','2026-08-03 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(140,25,2,'2026-08-04','2026-08-04 08:05:00','2026-08-04 17:05:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(141,25,2,'2026-08-05','2026-08-05 08:00:00','2026-08-05 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(142,25,2,'2026-08-06',NULL,NULL,NULL,NULL,'cuti',0.00,'terpenuhi','Disetujui','HRD','Cuti keluarga','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(143,25,2,'2026-08-07',NULL,NULL,NULL,NULL,'cuti',0.00,'terpenuhi','Disetujui','HRD','Cuti keluarga','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(144,25,2,'2026-08-10','2026-08-10 08:00:00','2026-08-10 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(145,25,2,'2026-08-11','2026-08-11 08:02:00','2026-08-11 17:05:00','Gedung A','Gedung A','hadir',8.10,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(146,25,2,'2026-08-12','2026-08-12 08:00:00','2026-08-12 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(147,25,2,'2026-08-13',NULL,NULL,NULL,NULL,'izin',0.00,'terpenuhi','Disetujui','HRD','Izin keperluan keluarga','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(148,25,2,'2026-08-14',NULL,NULL,NULL,NULL,'izin',0.00,'terpenuhi','Disetujui','HRD','Izin keperluan keluarga','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(149,25,2,'2026-08-17','2026-08-17 08:00:00','2026-08-17 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Lead','Upacara','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(150,25,2,'2026-08-18','2026-08-18 08:00:00','2026-08-18 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(151,25,2,'2026-08-19','2026-08-19 08:04:00','2026-08-19 17:05:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(152,25,2,'2026-08-20','2026-08-20 08:00:00','2026-08-20 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(153,25,2,'2026-08-21','2026-08-21 08:00:00','2026-08-21 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(154,25,2,'2026-08-24','2026-08-24 08:05:00','2026-08-24 17:10:00','Gedung A','Gedung A','hadir',8.10,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(155,25,2,'2026-08-25','2026-08-25 08:00:00','2026-08-25 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(156,25,2,'2026-08-26','2026-08-26 08:00:00','2026-08-26 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(157,25,2,'2026-08-27','2026-08-27 08:00:00','2026-08-27 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(158,25,2,'2026-08-28','2026-08-28 08:00:00','2026-08-28 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(159,25,2,'2026-08-31','2026-08-31 08:00:00','2026-08-31 17:00:00','Gedung A','Gedung A','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(160,26,2,'2026-08-03','2026-08-03 08:00:00','2026-08-03 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(161,26,2,'2026-08-04','2026-08-04 08:05:00','2026-08-04 17:05:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(162,26,2,'2026-08-05','2026-08-05 08:00:00','2026-08-05 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(163,26,2,'2026-08-06','2026-08-06 08:00:00','2026-08-06 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(164,26,2,'2026-08-07',NULL,NULL,NULL,NULL,'unpaid_leave',0.00,'terpenuhi','Disetujui','HRD','Izin di luar tanggungan','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(165,26,2,'2026-08-10','2026-08-10 08:00:00','2026-08-10 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(166,26,2,'2026-08-11','2026-08-11 08:02:00','2026-08-11 17:05:00','Gedung Utama','Gedung Utama','hadir',8.10,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(167,26,2,'2026-08-12','2026-08-12 08:00:00','2026-08-12 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(168,26,2,'2026-08-13','2026-08-13 08:00:00','2026-08-13 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(169,26,2,'2026-08-14','2026-08-14 08:00:00','2026-08-14 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(170,26,2,'2026-08-17','2026-08-17 08:00:00','2026-08-17 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','Lead','Upacara','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(171,26,2,'2026-08-18','2026-08-18 08:00:00','2026-08-18 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39'),
(172,26,2,'2026-08-19','2026-08-19 08:00:00','2026-08-19 17:00:00','Gedung Utama','Gedung Utama','hadir',8.00,'terpenuhi','Disetujui','Lead','Hadir tepat waktu','2026-09-17 01:49:39','2026-09-17 01:49:39');
/*!40000 ALTER TABLE `attendances` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_departments_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `departments` VALUES
(1,'HR','HRD','2026-09-16 07:26:27','2026-09-16 15:14:56'),
(2,'ENG','Engineering','2026-09-16 07:26:27','2026-09-16 07:26:27'),
(3,'FIN','Finance','2026-09-16 07:26:27','2026-09-16 07:26:27'),
(13,'MKT','Marketing','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(14,'PROD','Production','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(15,'EXEC','Executive','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(16,'COMM','Commissioner','2026-09-16 15:14:56','2026-09-16 15:14:56');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `districts`
--

DROP TABLE IF EXISTS `districts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `districts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `regency_id` bigint(20) unsigned NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_districts_code` (`code`),
  KEY `idx_districts_regency_id` (`regency_id`),
  CONSTRAINT `fk_districts_regency` FOREIGN KEY (`regency_id`) REFERENCES `regencies` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=581 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `districts`
--

LOCK TABLES `districts` WRITE;
/*!40000 ALTER TABLE `districts` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `districts` VALUES
(1,1,'3273010','Sukasari','2026-09-16 07:26:27','2026-09-16 07:26:27'),
(5,1,'3273020','Coblong','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(6,1,'3273030','Cicendo','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(7,1,'3273040','Sumur Bandung','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(8,1,'3273050','Lengkong','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(9,1,'3273060','Andir','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(10,1,'3273070','Regol','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(11,1,'3273080','Buahbatu','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(12,12,'3471010','Danurejan','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(13,12,'3471020','Gedongtengen','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(14,12,'3471030','Gondokusuman','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(15,12,'3471040','Jetis','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(16,12,'3471050','Kotagede','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(17,12,'3471060','Kraton','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(18,12,'3471070','Mantrijeron','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(19,12,'3471080','Mergangsan','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(20,12,'3471090','Ngampilan','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(21,12,'3471100','Pakualaman','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(22,12,'3471110','Tegalrejo','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(23,12,'3471120','Umbulharjo','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(24,12,'3471130','Wirobrajan','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(25,13,'3402010','Kasihan','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(26,13,'3402020','Sewon','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(27,13,'3402030','Banguntapan','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(28,13,'3402040','Bantul','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(29,13,'3402050','Bambanglipuro','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(30,13,'3402060','Imogiri','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(31,13,'3402070','Piyungan','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(32,13,'3402080','Pundong','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(33,13,'3402090','Sanden','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(34,13,'3402100','Sedayu','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(35,13,'3402110','Srandakan','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(36,14,'3404010','Depok','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(37,14,'3404020','Mlati','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(38,14,'3404030','Gamping','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(39,14,'3404040','Kalasan','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(40,14,'3404050','Ngaglik','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(41,14,'3404060','Seyegan','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(42,14,'3404070','Tempel','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(43,14,'3404080','Pakem','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(44,14,'3404090','Prambanan','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(45,15,'3403010','Wonosari','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(46,15,'3403020','Playen','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(47,15,'3403030','Semanu','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(48,16,'3401010','Wates','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(49,16,'3401020','Sentolo','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(50,16,'3401030','Pengasih','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(51,5,'3171010','Gambir','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(52,5,'3171020','Menteng','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(53,5,'3171030','Tanah Abang','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(54,5,'3171040','Senen','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(55,6,'3174010','Kebayoran Baru','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(56,6,'3174020','Kebayoran Lama','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(57,6,'3174030','Cilandak','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(58,6,'3174040','Setiabudi','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(59,6,'3174050','Tebet','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(60,6,'3174060','Pasar Minggu','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(61,17,'3578010','Gubeng','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(62,17,'3578020','Wonokromo','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(63,17,'3578030','Tegalsari','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(64,17,'3578040','Genteng','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(65,10,'3374010','Semarang Tengah','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(66,10,'3374020','Semarang Barat','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(67,10,'3374030','Semarang Selatan','2026-09-16 15:14:56','2026-09-16 15:14:56');
/*!40000 ALTER TABLE `districts` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `employee_educations`
--

DROP TABLE IF EXISTS `employee_educations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_educations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `education_level` varchar(50) NOT NULL,
  `school_name` varchar(255) NOT NULL,
  `graduation_year` smallint(5) unsigned DEFAULT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_employee_educations_employee_sort` (`employee_id`,`sort_order`),
  CONSTRAINT `fk_employee_educations_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_educations`
--

LOCK TABLES `employee_educations` WRITE;
/*!40000 ALTER TABLE `employee_educations` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `employee_educations` VALUES
(1,1,'S1','Universitas Padjadjaran',2015,1,'2026-09-16 15:14:56','2026-09-16 15:14:56'),
(2,1,'SMA','SMAN 3 Bandung',2011,2,'2026-09-16 15:14:56','2026-09-16 15:14:56'),
(3,2,'S1','Universitas Pendidikan Indonesia',2019,1,'2026-09-16 15:14:56','2026-09-16 15:14:56'),
(4,2,'SMA','SMAN 1 Bandung',2015,2,'2026-09-16 15:14:56','2026-09-16 15:14:56'),
(5,3,'SMK','SMKN 1 Cimahi',2020,1,'2026-09-16 15:14:56','2026-09-16 15:14:56'),
(8,22,'S1','Universitas Gadjah Mada',2012,1,'2026-09-16 15:19:00','2026-09-16 15:19:00'),
(9,22,'SMA','SMAN 1 Yogyakarta',2008,2,'2026-09-16 15:19:00','2026-09-16 15:19:00'),
(10,23,'S1','UB',2028,1,'2026-09-16 15:36:48','2026-09-16 15:36:48'),
(11,23,'SMA','VETERAN',2024,2,'2026-09-16 15:36:48','2026-09-16 15:36:48'),
(12,1,'S1','Universitas Padjadjaran',2015,1,'2026-09-16 15:44:55','2026-09-16 15:44:55'),
(13,1,'SMA','SMAN 3 Bandung',2011,2,'2026-09-16 15:44:55','2026-09-16 15:44:55'),
(14,2,'S1','Universitas Pendidikan Indonesia',2019,1,'2026-09-16 15:44:55','2026-09-16 15:44:55'),
(15,2,'SMA','SMAN 1 Bandung',2015,2,'2026-09-16 15:44:55','2026-09-16 15:44:55'),
(16,3,'SMK','SMKN 1 Cimahi',2020,1,'2026-09-16 15:44:55','2026-09-16 15:44:55'),
(17,14,'S1','Universitas Gadjah Mada',2012,1,'2026-09-16 15:44:55','2026-09-16 15:44:55'),
(18,15,'S1','Universitas Negeri Yogyakarta',2017,1,'2026-09-16 15:44:55','2026-09-16 15:44:55'),
(19,16,'S1','UPN Veteran Yogyakarta',2020,1,'2026-09-16 15:44:55','2026-09-16 15:44:55'),
(20,17,'S2','Institut Teknologi Bandung',2016,1,'2026-09-16 15:44:55','2026-09-16 15:44:55'),
(24,49,'S1','asdsa',2020,1,'2026-09-16 15:51:35','2026-09-16 15:51:35'),
(26,50,'S1','UGM',2018,1,'2026-09-16 15:52:25','2026-09-16 15:52:25'),
(27,1,'S1','Universitas Padjadjaran',2015,1,'2026-09-16 15:54:54','2026-09-16 15:54:54'),
(28,1,'SMA','SMAN 3 Bandung',2011,2,'2026-09-16 15:54:54','2026-09-16 15:54:54'),
(29,2,'S1','Universitas Pendidikan Indonesia',2019,1,'2026-09-16 15:54:54','2026-09-16 15:54:54'),
(30,2,'SMA','SMAN 1 Bandung',2015,2,'2026-09-16 15:54:54','2026-09-16 15:54:54'),
(31,3,'SMK','SMKN 1 Cimahi',2020,1,'2026-09-16 15:54:54','2026-09-16 15:54:54'),
(32,14,'S1','Universitas Gadjah Mada',2012,1,'2026-09-16 15:54:54','2026-09-16 15:54:54'),
(33,15,'S1','Universitas Negeri Yogyakarta',2017,1,'2026-09-16 15:54:54','2026-09-16 15:54:54'),
(34,16,'S1','UPN Veteran Yogyakarta',2020,1,'2026-09-16 15:54:54','2026-09-16 15:54:54'),
(35,17,'S2','Institut Teknologi Bandung',2016,1,'2026-09-16 15:54:54','2026-09-16 15:54:54'),
(36,1,'S1','Universitas Padjadjaran',2015,1,'2026-09-17 01:25:50','2026-09-17 01:25:50'),
(37,1,'SMA','SMAN 3 Bandung',2011,2,'2026-09-17 01:25:50','2026-09-17 01:25:50'),
(38,2,'S1','Universitas Pendidikan Indonesia',2019,1,'2026-09-17 01:25:50','2026-09-17 01:25:50'),
(39,2,'SMA','SMAN 1 Bandung',2015,2,'2026-09-17 01:25:50','2026-09-17 01:25:50'),
(40,3,'SMK','SMKN 1 Cimahi',2020,1,'2026-09-17 01:25:50','2026-09-17 01:25:50'),
(41,14,'S1','Universitas Gadjah Mada',2012,1,'2026-09-17 01:25:50','2026-09-17 01:25:50'),
(42,15,'S1','Universitas Negeri Yogyakarta',2017,1,'2026-09-17 01:25:50','2026-09-17 01:25:50'),
(43,16,'S1','UPN Veteran Yogyakarta',2020,1,'2026-09-17 01:25:50','2026-09-17 01:25:50'),
(44,17,'S2','Institut Teknologi Bandung',2016,1,'2026-09-17 01:25:50','2026-09-17 01:25:50'),
(45,1,'S1','Universitas Padjadjaran',2015,1,'2026-09-17 02:25:11','2026-09-17 02:25:11'),
(46,1,'SMA','SMAN 3 Bandung',2011,2,'2026-09-17 02:25:11','2026-09-17 02:25:11'),
(47,2,'S1','Universitas Pendidikan Indonesia',2019,1,'2026-09-17 02:25:11','2026-09-17 02:25:11'),
(48,2,'SMA','SMAN 1 Bandung',2015,2,'2026-09-17 02:25:11','2026-09-17 02:25:11'),
(49,3,'SMK','SMKN 1 Cimahi',2020,1,'2026-09-17 02:25:11','2026-09-17 02:25:11'),
(50,14,'S1','Universitas Gadjah Mada',2012,1,'2026-09-17 02:25:11','2026-09-17 02:25:11'),
(51,15,'S1','Universitas Negeri Yogyakarta',2017,1,'2026-09-17 02:25:11','2026-09-17 02:25:11'),
(52,16,'S1','UPN Veteran Yogyakarta',2020,1,'2026-09-17 02:25:11','2026-09-17 02:25:11'),
(53,17,'S2','Institut Teknologi Bandung',2016,1,'2026-09-17 02:25:11','2026-09-17 02:25:11'),
(54,1,'S1','Universitas Padjadjaran',2015,1,'2026-09-17 03:11:57','2026-09-17 03:11:57'),
(55,1,'SMA','SMAN 3 Bandung',2011,2,'2026-09-17 03:11:57','2026-09-17 03:11:57'),
(56,2,'S1','Universitas Pendidikan Indonesia',2019,1,'2026-09-17 03:11:57','2026-09-17 03:11:57'),
(57,2,'SMA','SMAN 1 Bandung',2015,2,'2026-09-17 03:11:57','2026-09-17 03:11:57'),
(58,3,'SMK','SMKN 1 Cimahi',2020,1,'2026-09-17 03:11:57','2026-09-17 03:11:57'),
(59,14,'S1','Universitas Gadjah Mada',2012,1,'2026-09-17 03:11:57','2026-09-17 03:11:57'),
(60,15,'S1','Universitas Negeri Yogyakarta',2017,1,'2026-09-17 03:11:57','2026-09-17 03:11:57'),
(61,16,'S1','UPN Veteran Yogyakarta',2020,1,'2026-09-17 03:11:57','2026-09-17 03:11:57'),
(62,17,'S2','Institut Teknologi Bandung',2016,1,'2026-09-17 03:11:57','2026-09-17 03:11:57'),
(63,1,'S1','Universitas Padjadjaran',2015,1,'2026-09-17 07:15:15','2026-09-17 07:15:15'),
(64,1,'SMA','SMAN 3 Bandung',2011,2,'2026-09-17 07:15:15','2026-09-17 07:15:15'),
(65,2,'S1','Universitas Pendidikan Indonesia',2019,1,'2026-09-17 07:15:15','2026-09-17 07:15:15'),
(66,2,'SMA','SMAN 1 Bandung',2015,2,'2026-09-17 07:15:15','2026-09-17 07:15:15'),
(67,3,'SMK','SMKN 1 Cimahi',2020,1,'2026-09-17 07:15:15','2026-09-17 07:15:15'),
(68,14,'S1','Universitas Gadjah Mada',2012,1,'2026-09-17 07:15:15','2026-09-17 07:15:15'),
(69,15,'S1','Universitas Negeri Yogyakarta',2017,1,'2026-09-17 07:15:15','2026-09-17 07:15:15'),
(70,16,'S1','UPN Veteran Yogyakarta',2020,1,'2026-09-17 07:15:15','2026-09-17 07:15:15'),
(71,17,'S2','Institut Teknologi Bandung',2016,1,'2026-09-17 07:15:15','2026-09-17 07:15:15'),
(72,1,'S1','Universitas Padjadjaran',2015,1,'2026-09-17 07:19:28','2026-09-17 07:19:28'),
(73,1,'SMA','SMAN 3 Bandung',2011,2,'2026-09-17 07:19:28','2026-09-17 07:19:28'),
(74,2,'S1','Universitas Pendidikan Indonesia',2019,1,'2026-09-17 07:19:28','2026-09-17 07:19:28'),
(75,2,'SMA','SMAN 1 Bandung',2015,2,'2026-09-17 07:19:28','2026-09-17 07:19:28'),
(76,3,'SMK','SMKN 1 Cimahi',2020,1,'2026-09-17 07:19:28','2026-09-17 07:19:28'),
(77,14,'S1','Universitas Gadjah Mada',2012,1,'2026-09-17 07:19:28','2026-09-17 07:19:28'),
(78,15,'S1','Universitas Negeri Yogyakarta',2017,1,'2026-09-17 07:19:28','2026-09-17 07:19:28'),
(79,16,'S1','UPN Veteran Yogyakarta',2020,1,'2026-09-17 07:19:28','2026-09-17 07:19:28'),
(80,17,'S2','Institut Teknologi Bandung',2016,1,'2026-09-17 07:19:28','2026-09-17 07:19:28'),
(81,1,'S1','Universitas Padjadjaran',2015,1,'2026-09-17 07:20:33','2026-09-17 07:20:33'),
(82,1,'SMA','SMAN 3 Bandung',2011,2,'2026-09-17 07:20:33','2026-09-17 07:20:33'),
(83,2,'S1','Universitas Pendidikan Indonesia',2019,1,'2026-09-17 07:20:33','2026-09-17 07:20:33'),
(84,2,'SMA','SMAN 1 Bandung',2015,2,'2026-09-17 07:20:33','2026-09-17 07:20:33'),
(85,3,'SMK','SMKN 1 Cimahi',2020,1,'2026-09-17 07:20:33','2026-09-17 07:20:33'),
(86,14,'S1','Universitas Gadjah Mada',2012,1,'2026-09-17 07:20:33','2026-09-17 07:20:33'),
(87,15,'S1','Universitas Negeri Yogyakarta',2017,1,'2026-09-17 07:20:33','2026-09-17 07:20:33'),
(88,16,'S1','UPN Veteran Yogyakarta',2020,1,'2026-09-17 07:20:33','2026-09-17 07:20:33'),
(89,17,'S2','Institut Teknologi Bandung',2016,1,'2026-09-17 07:20:33','2026-09-17 07:20:33');
/*!40000 ALTER TABLE `employee_educations` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nip` varchar(50) NOT NULL,
  `name` varchar(150) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `photo_path` varchar(500) DEFAULT NULL,
  `birth_place` varchar(100) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `marital_status` varchar(30) DEFAULT NULL,
  `children_count` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `joined_at` date NOT NULL,
  `position_id` bigint(20) unsigned NOT NULL,
  `department_id` bigint(20) unsigned NOT NULL,
  `employment_type` enum('pkwtt','pkwt','magang') NOT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `distance_km` decimal(8,2) DEFAULT NULL,
  `district_id` bigint(20) unsigned NOT NULL,
  `full_address` text DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `updated_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_employees_nip` (`nip`),
  UNIQUE KEY `uk_employees_email` (`email`),
  KEY `idx_employees_position_id` (`position_id`),
  KEY `idx_employees_department_id` (`department_id`),
  KEY `idx_employees_district_id` (`district_id`),
  KEY `idx_employees_status_deleted_at` (`status`,`deleted_at`),
  CONSTRAINT `fk_employees_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_employees_district` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_employees_position` FOREIGN KEY (`position_id`) REFERENCES `positions` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `chk_employees_distance_km` CHECK (`distance_km` is null or `distance_km` >= 0)
) ENGINE=InnoDB AUTO_INCREMENT=226 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `employees` VALUES
(1,'EMP-001','Ahmad Hermawan','ahmad@example.com','+6281234567801',NULL,'Bandung','1993-04-12','Menikah',1,'2022-05-14',13,1,'pkwtt','Laki-laki',8.50,1,'Jl. Sukasari No. 12, Bandung','active',NULL,NULL,'2026-09-16 07:26:27','2026-09-17 07:20:33',NULL),
(2,'EMP-002','Dhea Angela','dhea@example.com','+6281234567802',NULL,'Bandung','1997-08-20','Belum Menikah',0,'2024-01-08',1,1,'pkwt','Perempuan',5.25,1,'Jl. Dr. Setiabudi No. 45, Bandung','active',NULL,NULL,'2026-09-16 07:26:27','2026-09-17 07:20:33',NULL),
(3,'EMP-003','Riko Salim','riko@example.com','+6281234567803',NULL,'Cimahi','2002-11-05','Belum Menikah',0,'2026-07-01',2,2,'magang','Laki-laki',11.00,1,'Jl. Cihanjuang No. 88, Cimahi','active',NULL,NULL,'2026-09-16 07:26:27','2026-09-17 07:20:33',NULL),
(14,'EMP-004','Budi Santoso','budi.santoso@example.com','+6281234567804',NULL,'Yogyakarta','1990-03-15','Menikah',2,'2020-02-01',2,2,'pkwtt','Laki-laki',6.00,15,'Jl. Jetis Pasiraman No. 10, Yogyakarta','active',NULL,3,'2026-09-16 11:46:07','2026-09-17 07:20:33',NULL),
(15,'EMP-005','Siti Rahmawati','siti.rahma@example.com','+6281234567805',NULL,'Bantul','1995-09-22','Menikah',1,'2021-06-15',3,3,'pkwtt','Perempuan',4.50,25,'Jl. Kasihan Bantul No. 22','active',NULL,3,'2026-09-16 11:46:07','2026-09-17 07:20:33',NULL),
(16,'EMP-006','Fajar Pratama','fajar.pratama@example.com','+6281234567806',NULL,'Sleman','1998-12-10','Belum Menikah',0,'2023-03-01',17,13,'pkwt','Laki-laki',7.80,36,'Jl. Kaliurang Km 5, Depok, Sleman','active',NULL,3,'2026-09-16 11:46:07','2026-09-17 07:20:33',NULL),
(17,'EMP-007','Shani Ratnasari','shani.ratna@example.com','+6281234567807',NULL,'Surabaya','1992-05-18','Menikah',2,'2019-11-01',18,14,'pkwtt','Perempuan',28.00,12,'Jl. Danurejan No. 15, Yogyakarta','active',NULL,3,'2026-09-16 11:46:07','2026-09-17 07:20:33',NULL),
(22,'199001014831','Budi Santoso Updated','budi.1789571940406@example.com','+6281299887766',NULL,'Yogyakarta','1990-05-15','Menikah',3,'2023-01-10',2,2,'pkwtt','Laki-laki',7.00,1,'Jl. Sukasari No. 12','active',3,3,'2026-09-16 15:19:00','2026-09-16 15:19:00','2026-09-16 15:19:00'),
(23,'29182493','Edwin Samodra Pratama','pegawai@gmai.com','+6282225425660','/uploads/employees/emp_1789573008755_egjs1t.jpg','Klaten','2001-07-15','Belum Menikah',0,'2026-01-01',1,1,'pkwt','Laki-laki',0.00,51,'Gambir','active',3,NULL,'2026-09-16 15:36:48','2026-09-16 15:42:44','2026-09-16 15:42:44'),
(24,'EMP-008','Reza Dewanto','reza.dewanto@example.com','+6281234567808',NULL,'Jakarta','1994-01-25','Belum Menikah',0,'2022-09-10',2,2,'pkwtt','Laki-laki',9.20,37,'Jl. Magelang Km 7, Mlati, Sleman','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(25,'EMP-009','Gita Sekar Arum','gita.sekar@example.com','+6281234567809',NULL,'Semarang','1999-07-30','Belum Menikah',0,'2024-04-15',1,1,'pkwt','Perempuan',3.50,14,'Jl. Gondokusuman No. 8, Yogyakarta','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(26,'EMP-010','Dimas Anggara','dimas.anggara@example.com','+6281234567810',NULL,'Bandung','2001-02-14','Belum Menikah',0,'2025-08-01',19,1,'magang','Laki-laki',14.00,26,'Jl. Parangtritis Km 6, Sewon, Bantul','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(27,'EMP-011','Lestari Handayani','lestari.h@example.com','+6281234567811',NULL,'Yogyakarta','1991-10-05','Menikah',3,'2018-04-01',3,3,'pkwtt','Perempuan',5.00,16,'Jl. Kotagede No. 34, Yogyakarta','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(28,'EMP-012','Bagus Prasetyo','bagus.p@example.com','+6281234567812',NULL,'Surakarta','1996-04-19','Belum Menikah',0,'2023-08-20',17,13,'pkwt','Laki-laki',8.10,38,'Jl. Wates Km 4, Gamping, Sleman','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(29,'EMP-013','Maya Indah Sari','maya.indah@example.com','+6281234567813',NULL,'Malang','1995-11-28','Menikah',1,'2021-12-01',2,2,'pkwtt','Perempuan',6.70,17,'Jl. Patehan Kidul, Kraton, Yogyakarta','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(30,'EMP-014','Hendra Gunawan','hendra.g@example.com','+6281234567814',NULL,'Cirebon','1989-08-14','Menikah',2,'2017-05-15',18,14,'pkwtt','Laki-laki',10.50,27,'Jl. Gedongkuning No. 12, Banguntapan','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(31,'EMP-015','Nadia Safitri','nadia.safitri@example.com','+6281234567815',NULL,'Jakarta','2000-06-03','Belum Menikah',0,'2025-01-10',17,13,'pkwt','Perempuan',4.00,19,'Jl. Kolonel Sugiyono, Mergangsan','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(32,'EMP-016','Andi Nugroho','andi.nugroho@example.com','+6281234567816',NULL,'Purwokerto','1993-03-21','Menikah',1,'2020-10-01',2,2,'pkwtt','Laki-laki',13.00,40,'Jl. Palagan Tentara Pelajar Km 9, Ngaglik','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(33,'EMP-017','Putri Ayu Lestari','putri.ayu@example.com','+6281234567817',NULL,'Bogor','1998-01-17','Belum Menikah',0,'2024-07-01',1,1,'pkwt','Perempuan',6.30,22,'Jl. Kyai Mojo No. 50, Tegalrejo','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(34,'EMP-018','Wahyu Hidayat','wahyu.h@example.com','+6281234567818',NULL,'Magelang','2002-09-12','Belum Menikah',0,'2026-02-01',19,1,'magang','Laki-laki',15.50,44,'Jl. Raya Solo Km 14, Prambanan','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(35,'EMP-019','Rina Kartika','rina.kartika@example.com','+6281234567819',NULL,'Surabaya','1994-07-08','Menikah',1,'2022-01-15',3,3,'pkwtt','Perempuan',7.00,23,'Jl. Veteran No. 20, Umbulharjo','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(36,'EMP-020','Eko Saputra','eko.saputra@example.com','+6281234567820',NULL,'Solo','1991-12-25','Menikah',2,'2019-08-01',2,2,'pkwtt','Laki-laki',9.00,39,'Jl. Solo Km 10, Kalasan, Sleman','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(37,'EMP-021','Dewi Sartika','dewi.sartika@example.com','+6281234567821',NULL,'Bandung','1996-05-02','Belum Menikah',0,'2023-11-01',17,13,'pkwt','Perempuan',5.80,24,'Jl. RE Martadinata, Wirobrajan','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(38,'EMP-022','Arif Wijaya','arif.wijaya@example.com','+6281234567822',NULL,'Semarang','1990-02-18','Menikah',3,'2018-09-15',18,14,'pkwtt','Laki-laki',11.20,28,'Jl. Jenderal Sudirman No. 8, Bantul','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(39,'EMP-023','Tania Kusuma','tania.kusuma@example.com','+6281234567823',NULL,'Jakarta','1997-10-14','Belum Menikah',0,'2024-03-01',1,1,'pkwt','Perempuan',8.70,43,'Jl. Kaliurang Km 14, Pakem, Sleman','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(40,'EMP-024','Bayu Firmansyah','bayu.f@example.com','+6281234567824',NULL,'Yogyakarta','2003-04-20','Belum Menikah',0,'2026-05-01',19,1,'magang','Laki-laki',16.00,48,'Jl. Diponegoro, Wates, Kulon Progo','active',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(41,'EMP-025','Agus Triyono','agus.triyono@example.com','+6281234567825',NULL,'Klaten','1988-11-30','Menikah',2,'2016-01-10',2,2,'pkwtt','Laki-laki',6.50,18,'Jl. DI Panjaitan, Mantrijeron','inactive',NULL,NULL,'2026-09-16 15:44:55','2026-09-16 15:44:55',NULL),
(49,'12983192','ekwejk','ewqekjq@kjdas.com','+62343121242','','Klaten','2001-07-13','Belum Menikah',0,'2020-12-10',19,2,'pkwtt','Laki-laki',0.00,51,'Gambir 3003003 Jakarta Selatan','active',3,3,'2026-09-16 15:47:41','2026-09-16 15:51:35',NULL),
(50,'199505052885','Testing Pendidikan','test.edu.1789573867834@example.com','+6281234567899','','Yogyakarta','1995-05-03','Belum Menikah',20,'2023-12-30',2,2,'pkwtt','Laki-laki',20.00,1,'Jl. Kaliurang No. 1','active',3,3,'2026-09-16 15:51:07','2026-09-16 15:52:25',NULL);
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `login_otps`
--

DROP TABLE IF EXISTS `login_otps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_otps` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `otp_hash` varchar(255) NOT NULL,
  `channel` enum('email') NOT NULL DEFAULT 'email',
  `sent_to` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `verified_at` datetime DEFAULT NULL,
  `used_at` datetime DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_login_otps_user_id` (`user_id`),
  KEY `idx_login_otps_expires_at` (`expires_at`),
  CONSTRAINT `fk_login_otps_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_otps`
--

LOCK TABLES `login_otps` WRITE;
/*!40000 ALTER TABLE `login_otps` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `login_otps` VALUES
(1,1,'42f8dba2c87626c4ffb275b0427bb47e85b02dcca9a9103540d32ea88c695038','email','superadmin@example.com','2026-09-16 16:12:19',NULL,'2026-09-16 09:09:32','::1','curl/8.7.1','2026-09-16 09:09:19','2026-09-16 09:09:32'),
(2,1,'e36deec09aa73922d53279f29380a56ac3c593dd591855dd7aca1161aa501890','email','superadmin@example.com','2026-09-16 16:12:32',NULL,'2026-09-16 09:09:41','::1','curl/8.7.1','2026-09-16 09:09:32','2026-09-16 09:09:41'),
(3,1,'0bb1de272b46ce4f48e1434be989c5938776dd1237a7dd88f8867886105e28f5','email','superadmin@example.com','2026-09-16 16:12:41','2026-09-16 09:09:41','2026-09-16 09:09:41','::1','node','2026-09-16 09:09:41','2026-09-16 09:09:41'),
(4,2,'da28719dfd9c4da81f433d4788c3d0e10d97180018d0e32b65c967c45661597e','email','manager.hrd@example.com','2026-09-16 16:12:41','2026-09-16 09:09:41','2026-09-16 09:09:41','::1','node','2026-09-16 09:09:41','2026-09-16 09:09:41'),
(5,3,'30e2fdaa7748f8af49b4725199b69e939dc835bd2e4f37d40924da88132161f1','email','admin.hrd@example.com','2026-09-16 16:12:41','2026-09-16 09:09:41','2026-09-16 09:09:41','::1','node','2026-09-16 09:09:41','2026-09-16 09:09:41'),
(6,1,'690b51acbaa9c5edc85fe19ffa764a760eb91126f8c133b2b496243540450eaa','email','edwinsamodra@gmail.com','2026-09-16 16:18:23',NULL,'2026-09-16 09:17:58','::1','curl/8.7.1','2026-09-16 09:15:23','2026-09-16 09:17:58'),
(7,1,'954f95d35f507b3ad2f9263fedd7612d76fe099b5c06b440c45da24f8c92786f','email','edwinsamodra@gmail.com','2026-09-16 16:20:58',NULL,'2026-09-16 10:05:10','::1','curl/8.7.1','2026-09-16 09:17:58','2026-09-16 10:05:10'),
(8,1,'1f3b8e69941641383b83d90d3091f7e22d81fce357635f457ce47a98bde3bdb6','email','edwinsamodra@gmail.com','2026-09-16 17:08:10',NULL,'2026-09-16 10:10:24','::1','curl/8.7.1','2026-09-16 10:05:10','2026-09-16 10:10:24'),
(9,1,'d265908f76c0179e2929dbebdce8dd050bee4992d19cfedbd754c7dfd0003ee5','email','edwinsamodra@gmail.com','2026-09-16 17:13:24',NULL,'2026-09-16 10:17:05','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:10:24','2026-09-16 10:17:05'),
(10,1,'06b9fe7fa1464b84453b7b7969310a4022f3c94c9eafc17272849fc41ed2837d','email','edwinsamodra@gmail.com','2026-09-16 17:20:05','2026-09-16 10:17:12','2026-09-16 10:17:12','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:17:05','2026-09-16 10:17:12'),
(11,1,'663f73f8af157c158248e72eb2d6548f7219b4231609b732ccc6484522628c6d','email','edwinsamodra@gmail.com','2026-09-16 17:20:21','2026-09-16 10:17:30','2026-09-16 10:17:30','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:17:21','2026-09-16 10:17:30'),
(12,1,'c2946bf3f4a5749a102e80ef1ded8eac74e261b728021c949b72b24c0e3df248','email','edwinsamodra@gmail.com','2026-09-16 17:23:08',NULL,'2026-09-16 10:20:16','::1','curl/8.7.1','2026-09-16 10:20:08','2026-09-16 10:20:16'),
(13,1,'058b346de9b51add4eca9aec2ab0ed11aed227590421e2a05070ae1236954094','email','edwinsamodra@gmail.com','2026-09-16 17:23:16','2026-09-16 10:20:41','2026-09-16 10:20:41','::1','curl/8.7.1','2026-09-16 10:20:16','2026-09-16 10:20:41'),
(14,1,'2fe78f3a5504de1bbbd8b7607b48da277bd0c48e8043dde6114e6641edc50843','email','edwinsamodra@gmail.com','2026-09-16 17:29:24',NULL,'2026-09-16 10:31:46','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:26:24','2026-09-16 10:31:46'),
(15,1,'53bb6d3babc64ebb948a4d8f3c4eed9e057fc3166cbb7a389cd3cb8328a3cc5f','email','edwinsamodra@gmail.com','2026-09-16 17:34:46','2026-09-16 10:31:50','2026-09-16 10:31:50','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:31:46','2026-09-16 10:31:50'),
(16,1,'f37fea625faea731039368d8d130b11ba8afb39f7bedc5b29a7bfa6a3ae9e27e','email','edwinsamodra@gmail.com','2026-09-16 17:37:52','2026-09-16 10:34:56','2026-09-16 10:34:56','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:34:52','2026-09-16 10:34:56'),
(17,1,'a626f7bb500b77a8e7893c4456d57ced25e2bc32ac838ab9ea4ad6fa5090fe83','email','edwinsamodra@gmail.com','2026-09-16 17:39:38','2026-09-16 10:36:44','2026-09-16 10:36:44','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:36:38','2026-09-16 10:36:44'),
(18,1,'87b619c933bde01d816fc6667ce22db9dd0db73ab5a5a713a4d1c9e4f329b4e7','email','edwinsamodra@gmail.com','2026-09-16 17:42:00','2026-09-16 10:39:04','2026-09-16 10:39:04','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:39:00','2026-09-16 10:39:04'),
(19,1,'68a7ac41844525497a3a759e5b2dd3b42345819e2f5c737b9ca901fdf74b88f3','email','edwinsamodra@gmail.com','2026-09-16 17:46:14','2026-09-16 10:43:19','2026-09-16 10:43:19','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:43:14','2026-09-16 10:43:19'),
(20,1,'3921a7d7066d4666f3e7e9874ab7832eed2f4bcabdd2af8f081c0dedd953779b','email','edwinsamodra@gmail.com','2026-09-16 17:47:17','2026-09-16 10:44:19','2026-09-16 10:44:19','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:44:17','2026-09-16 10:44:19'),
(21,1,'1346eb73396d16d6d4783298e85a06d0b8df8e53e39cc7f661fa8c9f8a69d66a','email','edwinsamodra@gmail.com','2026-09-16 17:49:04','2026-09-16 10:46:08','2026-09-16 10:46:08','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:46:04','2026-09-16 10:46:08'),
(22,1,'52558cb584c322ce06bc71777ddf400d2585bec7e64a888334aca9c24b016287','email','edwinsamodra@gmail.com','2026-09-16 18:13:46','2026-09-16 11:10:53','2026-09-16 11:10:53','::1','curl/8.7.1','2026-09-16 11:10:46','2026-09-16 11:10:53'),
(23,2,'c9f5614c4fb86da8a8ba1c0fc8d69b50fbfbed5b72194af8ac1f76461c022ceb','email','manager.hrd@example.com','2026-09-16 18:35:28','2026-09-16 11:32:34','2026-09-16 11:32:34','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15','2026-09-16 11:32:28','2026-09-16 11:32:34'),
(24,3,'ed0478973a6c233d4cba8a20af7c6a156599c88e5f6dfdd8ea10cdbf2c8c4cfd','email','admin.hrd@example.com','2026-09-16 18:35:57','2026-09-16 11:33:00','2026-09-16 11:33:00','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15','2026-09-16 11:32:57','2026-09-16 11:33:00'),
(25,3,'b3773ecbf7494c6f8e965f6826e65cdfcc621a1c25f8b57866f60137b7a16da5','email','admin.hrd@example.com','2026-09-16 18:50:52','2026-09-16 11:47:57','2026-09-16 11:47:57','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 11:47:52','2026-09-16 11:47:57'),
(26,3,'b874ed7f13a09e5b8e0c6f1d33189f5ca701b3ecbd24a745dd8dba9b5d32504d','email','admin.hrd@example.com','2026-09-16 18:56:18','2026-09-16 11:53:21','2026-09-16 11:53:21','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 11:53:18','2026-09-16 11:53:21'),
(27,2,'fd11ed8d7fce4f272755d6608ac76532576b5c4a2308ff1da31c1a498f2db4f7','email','manager.hrd@example.com','2026-09-16 18:59:26','2026-09-16 11:56:31','2026-09-16 11:56:31','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 11:56:26','2026-09-16 11:56:31'),
(28,3,'c5883875beb9a0c9eec33ff6767c5b4c24fa9750095c14221ed888d4736649bb','email','admin.hrd@example.com','2026-09-16 18:59:57','2026-09-16 11:57:10','2026-09-16 11:57:10','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15','2026-09-16 11:56:57','2026-09-16 11:57:10'),
(29,1,'408ae596784e336f141c483f9bd28f3a7ab8ab5f79bebb07916b260a6bc339aa','email','edwinsamodra@gmail.com','2026-09-16 19:00:33','2026-09-16 11:57:39','2026-09-16 11:57:39','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15','2026-09-16 11:57:33','2026-09-16 11:57:39'),
(30,1,'aa13fda43018c393de7088225497fee24270d428a9de0d2f8d0cc899f6687e69','email','edwinsamodra@gmail.com','2026-09-16 19:20:09','2026-09-16 12:17:12','2026-09-16 12:17:12','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 12:17:09','2026-09-16 12:17:12'),
(31,3,'b630babcbdb1bc9eae05ad38caaf56e5b0f2e8f32e11d2a11c6c1576cb66309a','email','admin.hrd@example.com','2026-09-16 19:21:04','2026-09-16 12:18:12','2026-09-16 12:18:12','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15','2026-09-16 12:18:04','2026-09-16 12:18:12'),
(32,2,'4a81bf42d193fd4acbb683cbe880ee6f84b124f700be1b3c1452c694917be2de','email','manager.hrd@example.com','2026-09-16 19:21:30','2026-09-16 12:18:34','2026-09-16 12:18:34','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15','2026-09-16 12:18:30','2026-09-16 12:18:34'),
(33,1,'99e0483fe4acdbc71d270fb1c73c28687d8f87fd8a0f83147c9259fe9a7cdf39','email','edwinsamodra@gmail.com','2026-09-16 21:28:13','2026-09-16 14:25:17','2026-09-16 14:25:17','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 14:25:13','2026-09-16 14:25:17'),
(34,3,'2594fcb40fdfda369d05e69a7b24d91002da0573158bbb7dbe5893cab04bf964','email','admin.hrd@example.com','2026-09-16 21:29:02','2026-09-16 14:26:12','2026-09-16 14:26:12','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 14:26:02','2026-09-16 14:26:12'),
(35,1,'98c53df687f2e9b94da80eef5b9049f1fac456b4c41c808f1a6b0fe80adecedb','email','edwinsamodra@gmail.com','2026-09-16 21:30:00','2026-09-16 14:27:02','2026-09-16 14:27:02','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 14:27:00','2026-09-16 14:27:02'),
(36,2,'311a0ae57be934ee398b0f2848742f7739c5567d41f1ee1f08f24f4d65e371e6','email','manager.hrd@example.com','2026-09-16 21:33:40','2026-09-16 14:30:43','2026-09-16 14:30:43','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 14:30:40','2026-09-16 14:30:43'),
(37,3,'e560f3c5ee3df5df0e5786829c8ca92930f8c14f7f5e10a7fb2b9d4ec1f8196d','email','admin.hrd@example.com','2026-09-16 22:21:31',NULL,'2026-09-16 15:18:44','::1','node','2026-09-16 15:18:31','2026-09-16 15:18:44'),
(38,3,'ac2626141862f2667caf521af092b3c30b00c6053c2e03ef8bb900119528f1fa','email','admin.hrd@example.com','2026-09-16 22:21:44','2026-09-16 15:18:44','2026-09-16 15:18:44','::1','node','2026-09-16 15:18:44','2026-09-16 15:18:44'),
(39,3,'cad0152e4e3ec7e4c34146abe3b69d44f83145f1b871339d35ddf8842478face','email','admin.hrd@example.com','2026-09-16 22:22:00','2026-09-16 15:19:00','2026-09-16 15:19:00','::1','node','2026-09-16 15:19:00','2026-09-16 15:19:00'),
(40,2,'ef13ebc3a57a1b51c17b45fcfef8eef761deab8371cc9e4eca14962d5763123d','email','manager.hrd@example.com','2026-09-16 22:22:00','2026-09-16 15:19:00','2026-09-16 15:19:00','::1','node','2026-09-16 15:19:00','2026-09-16 15:19:00'),
(41,3,'8595f9e3f5f0a6e7df8fa2248d2373f6642fe66a0dc74301e486913a83c2e5c6','email','admin.hrd@example.com','2026-09-16 22:25:29','2026-09-16 15:22:29','2026-09-16 15:22:29','::1','node','2026-09-16 15:22:29','2026-09-16 15:22:29'),
(42,3,'6fef307f9c8a3fb0ad69aea55b3d9c74c652a858c61b235e70ce2e2d490eb34c','email','admin.hrd@example.com','2026-09-16 22:26:18','2026-09-16 15:23:18','2026-09-16 15:23:18','::1','node','2026-09-16 15:23:18','2026-09-16 15:23:18'),
(43,3,'dd3fac072357758b41aabe831c4abf01de1cd7cc16065c48c7525c0b43f80042','email','admin.hrd@example.com','2026-09-16 22:27:07','2026-09-16 15:24:07','2026-09-16 15:24:07','::1','node','2026-09-16 15:24:07','2026-09-16 15:24:07'),
(44,3,'24a63ec7c93bdbb5b5dea931017f958545ef99af8d6f09a8260115a2a1c976cf','email','admin.hrd@example.com','2026-09-16 22:27:55','2026-09-16 15:24:55','2026-09-16 15:24:55','::1','node','2026-09-16 15:24:55','2026-09-16 15:24:55'),
(45,3,'5805921783d4f48c7ddacf69382814a769b81b318735bc11ea309b2fa4e5a47b','email','admin.hrd@example.com','2026-09-16 22:31:46','2026-09-16 15:28:51','2026-09-16 15:28:51','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 15:28:46','2026-09-16 15:28:51'),
(46,3,'7c1c2745ec0ebb049fcc29e39d81909f3e5a55b88dcb43d491476fe6bb92b196','email','admin.hrd@example.com','2026-09-16 22:42:15','2026-09-16 15:39:15','2026-09-16 15:39:15','::1','node','2026-09-16 15:39:15','2026-09-16 15:39:15'),
(47,3,'3a892eea646c4e4fc44df3a264545ce2e51f4bdc752cbd996dae588e5c839602','email','admin.hrd@example.com','2026-09-16 22:48:29','2026-09-16 15:45:29','2026-09-16 15:45:29','::1','node','2026-09-16 15:45:29','2026-09-16 15:45:29'),
(48,3,'61f1658abb2793093fd8a1afabc600dad20001526baa94496f618226c27fb21a','email','admin.hrd@example.com','2026-09-16 22:54:07','2026-09-16 15:51:07','2026-09-16 15:51:07','::1','node','2026-09-16 15:51:07','2026-09-16 15:51:07'),
(49,1,'541eead0d9aecd91a4e591be604dbe311bdebdbf25c85821fabf878018f0504c','email','superadmin@example.com','2026-09-16 22:58:08',NULL,'2026-09-16 15:59:44','::1','node','2026-09-16 15:55:08','2026-09-16 15:59:44'),
(50,2,'4d24bf25aea82d0a9091410b3d11f87523d96d0633808ca71b08d8b0638f64ac','email','manager.hrd@example.com','2026-09-16 22:58:08',NULL,'2026-09-17 00:50:57','::1','node','2026-09-16 15:55:08','2026-09-17 00:50:57'),
(51,3,'285f8e7a01879313d77ac190b169982649e54303f4dcbff74f5d298f8f830aa2','email','admin.hrd@example.com','2026-09-16 22:58:08',NULL,'2026-09-17 00:42:00','::1','node','2026-09-16 15:55:08','2026-09-17 00:42:00'),
(52,1,'10e61d185ae6ecec1be3e9913500058b3bbc1e4e9639bde03c7a520e9c0fe2d3','email','superadmin@example.com','2026-09-16 23:02:44','2026-09-16 15:59:53','2026-09-16 15:59:53','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 15:59:44','2026-09-16 15:59:53'),
(53,1,'9f1e7d452a124938c72828e53f194c8ee1a683da3a47a157df82688c1a52bccd','email','superadmin@example.com','2026-09-16 23:09:18',NULL,'2026-09-16 16:06:24','::1','node','2026-09-16 16:06:18','2026-09-16 16:06:24'),
(54,1,'96c56127d5ff132709622ca8baa85cd3c5e7aac98c38a5652a12f6e979d78a6d','email','superadmin@example.com','2026-09-16 23:09:24',NULL,'2026-09-16 16:06:29','::1','node','2026-09-16 16:06:24','2026-09-16 16:06:29'),
(55,1,'eb982d2b777ad8d039420c3a7c6c342756093856e2eaf87b901ac089ba0b5414','email','superadmin@example.com','2026-09-16 23:09:29',NULL,'2026-09-16 16:06:38','::1','node','2026-09-16 16:06:29','2026-09-16 16:06:38'),
(56,1,'a73060afb61efe1b7c817645d00c342df02407f65435a64c88d251d56150ff42','email','superadmin@example.com','2026-09-16 23:09:38',NULL,'2026-09-16 16:06:44','::1','node','2026-09-16 16:06:38','2026-09-16 16:06:44'),
(57,1,'9da8780a381915da91ad2693249937745283266704661097a162c48c38976205','email','superadmin@example.com','2026-09-16 23:09:44','2026-09-16 16:06:44','2026-09-16 16:06:44','::1','node','2026-09-16 16:06:44','2026-09-16 16:06:44'),
(58,1,'6686fc4c74906865248b0f2fcf5c246709215eda68cab15f8a70bb2e63f5bf7d','email','superadmin@example.com','2026-09-16 23:09:51','2026-09-16 16:06:51','2026-09-16 16:06:51','::1','node','2026-09-16 16:06:51','2026-09-16 16:06:51'),
(59,1,'e22e9c22f92b827381bb3826905aca3a2d11db572514d2e842161d5b18396040','email','superadmin@example.com','2026-09-16 23:10:13','2026-09-16 16:07:13','2026-09-16 16:07:13','::1','node','2026-09-16 16:07:13','2026-09-16 16:07:13'),
(60,1,'4432cb276ffc79e796e2f86c4aabb5a223462ff45d089d30e5c78c38318c55cf','email','superadmin@example.com','2026-09-16 23:11:26','2026-09-16 16:08:26','2026-09-16 16:08:26','::1','node','2026-09-16 16:08:26','2026-09-16 16:08:26'),
(61,3,'0038d86077d63d1edd6c7da5563e206dbbbf56326ed21468300c7d9bc9b900db','email','admin.hrd@example.com','2026-09-17 07:45:00','2026-09-17 00:42:31','2026-09-17 00:42:31','::1','curl/8.7.1','2026-09-17 00:42:00','2026-09-17 00:42:31'),
(62,2,'583b08e38c98f4350a8906d25344ac80b099921a8a8929e64b2dc2b553521343','email','manager.hrd@example.com','2026-09-17 07:53:57','2026-09-17 00:51:07','2026-09-17 00:51:07','::1','curl/8.7.1','2026-09-17 00:50:57','2026-09-17 00:51:07'),
(63,1,'00150bc11aeeaa3cdbdc1e27085b0f6c584c27e05f255e303898dcd12426f110','email','superadmin@example.com','2026-09-17 07:54:27','2026-09-17 00:51:38','2026-09-17 00:51:38','::1','curl/8.7.1','2026-09-17 00:51:27','2026-09-17 00:51:38'),
(64,3,'df27cf751748bbf207fe896ef818bf86e3dbbdb2b336969c5f0d010f9f378803','email','admin.hrd@example.com','2026-09-17 08:29:08','2026-09-17 01:26:20','2026-09-17 01:26:20','::1','curl/8.7.1','2026-09-17 01:26:08','2026-09-17 01:26:20'),
(65,3,'c21c1a4d4f1e71a2f371d4431b92639129dedb0d4674c6c9ef97605bd321040c','email','admin.hrd@example.com','2026-09-17 08:42:07',NULL,'2026-09-17 01:39:15','::1','curl/8.7.1','2026-09-17 01:39:07','2026-09-17 01:39:15'),
(66,3,'11f4138f4d6ee3c5d5b803a8010f59d227a51fbb2c33f3f4c617f10d48db5bdc','email','admin.hrd@example.com','2026-09-17 08:42:15',NULL,'2026-09-17 01:39:26','::1','curl/8.7.1','2026-09-17 01:39:15','2026-09-17 01:39:26'),
(67,3,'cef142549ec7b7a05cc43a9f567e37abc3dbb19b496e656f66c3bffd4eb8cfea','email','admin.hrd@example.com','2026-09-17 08:42:26','2026-09-17 01:39:26','2026-09-17 01:39:26','::1','node','2026-09-17 01:39:26','2026-09-17 01:39:26'),
(68,3,'e9f6fab3f6a047e748c7d513dd6eaa48ec61b0ceccce6bb4d83bf601ebd633f9','email','admin.hrd@example.com','2026-09-17 08:46:13','2026-09-17 01:43:14','2026-09-17 01:43:14','::1','node','2026-09-17 01:43:13','2026-09-17 01:43:14'),
(69,2,'f10d342ce63e0d2d9cd929adda0c0c1d23bf126a2291491a124dcba638848988','email','manager.hrd@example.com','2026-09-17 14:09:07',NULL,'2026-09-17 07:06:16','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15','2026-09-17 07:06:07','2026-09-17 07:06:16'),
(70,2,'d9a643e38a0fa85414f439422d414f8a0f68df390c921cecda61ecc173bed939','email','manager.hrd@example.com','2026-09-17 14:09:16','2026-09-17 07:06:20','2026-09-17 07:06:20','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15','2026-09-17 07:06:16','2026-09-17 07:06:20');
/*!40000 ALTER TABLE `login_otps` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `modules`
--

DROP TABLE IF EXISTS `modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `modules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_modules_code` (`code`),
  KEY `idx_modules_sort_order` (`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modules`
--

LOCK TABLES `modules` WRITE;
/*!40000 ALTER TABLE `modules` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `modules` VALUES
(1,'auth','Login/Logout/Session','Modul autentikasi, OTP email, dan manajemen sesi pengguna',1,'2026-09-16 09:05:47','2026-09-16 09:05:47'),
(2,'role','Kelola Role','Melihat hak akses role berbasis RBAC',2,'2026-09-16 09:05:47','2026-09-16 09:05:47'),
(3,'user','Kelola User','Manajemen data user dan aktivasi akun',3,'2026-09-16 09:05:47','2026-09-16 09:05:47'),
(4,'profile','My Profile','Profil pengguna dan ganti password',4,'2026-09-16 09:05:47','2026-09-16 09:05:47'),
(5,'dashboard','Dashboard','Halaman dashboard utama sesuai role',5,'2026-09-16 09:05:47','2026-09-16 09:05:47'),
(6,'employee','Modul Data Pegawai','Pengelolaan data pegawai (biodata, riwayat, kontrak)',6,'2026-09-16 09:05:47','2026-09-16 09:05:47'),
(7,'attendance','Modul Presensi','Pengelolaan presensi harian, checkin/checkout, dan status',7,'2026-09-16 09:05:47','2026-09-16 09:05:47'),
(8,'transport_allowance','Modul Tunjangan Transport','Perhitungan dan monitoring tunjangan transport pegawai',8,'2026-09-16 09:05:47','2026-09-16 09:05:47'),
(9,'transport_setting','Setting Tunjangan Transport','Pengaturan besaran tarif dan aturan tunjangan transport',9,'2026-09-16 09:05:47','2026-09-16 09:05:47'),
(10,'activity_log','Modul Log','Pencatatan aktivitas audit log sistem',10,'2026-09-16 09:05:47','2026-09-16 09:05:47');
/*!40000 ALTER TABLE `modules` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `positions`
--

DROP TABLE IF EXISTS `positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `positions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `position_type` enum('manager','staf','magang') NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_positions_code` (`code`),
  KEY `idx_positions_position_type` (`position_type`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `positions`
--

LOCK TABLES `positions` WRITE;
/*!40000 ALTER TABLE `positions` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `positions` VALUES
(1,'HR-OFFICER','HR Officer','staf','2026-09-16 07:26:27','2026-09-16 07:26:27'),
(2,'SOFTWARE-ENGINEER','Software Engineer','staf','2026-09-16 07:26:27','2026-09-16 07:26:27'),
(3,'ACCOUNTANT','Akuntan','staf','2026-09-16 07:26:27','2026-09-16 15:14:56'),
(12,'SUPERADMIN-STAFF','System Administrator','staf','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(13,'HR-MANAGER','Manager HRD','manager','2026-09-16 09:05:47','2026-09-16 15:14:56'),
(17,'MARKETING-STAFF','Marketing Staff','staf','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(18,'PRODUCTION-MANAGER','Manager Produksi','manager','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(19,'INTERN-HR','Magang HRD','magang','2026-09-16 15:14:56','2026-09-16 15:14:56');
/*!40000 ALTER TABLE `positions` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `provinces`
--

DROP TABLE IF EXISTS `provinces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `provinces` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_provinces_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provinces`
--

LOCK TABLES `provinces` WRITE;
/*!40000 ALTER TABLE `provinces` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `provinces` VALUES
(1,'32','Jawa Barat','2026-09-16 07:26:27','2026-09-16 07:26:27'),
(5,'31','DKI Jakarta','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(6,'33','Jawa Tengah','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(7,'34','D.I. Yogyakarta','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(8,'35','Jawa Timur','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(9,'36','Banten','2026-09-16 15:14:56','2026-09-16 15:14:56');
/*!40000 ALTER TABLE `provinces` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `regencies`
--

DROP TABLE IF EXISTS `regencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `regencies` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `province_id` bigint(20) unsigned NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_regencies_code` (`code`),
  KEY `idx_regencies_province_id` (`province_id`),
  CONSTRAINT `fk_regencies_province` FOREIGN KEY (`province_id`) REFERENCES `provinces` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regencies`
--

LOCK TABLES `regencies` WRITE;
/*!40000 ALTER TABLE `regencies` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `regencies` VALUES
(1,1,'3273','Kota Bandung','2026-09-16 07:26:27','2026-09-16 07:26:27'),
(5,5,'3171','Kota Jakarta Pusat','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(6,5,'3174','Kota Jakarta Selatan','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(7,1,'3277','Kota Cimahi','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(8,1,'3204','Kabupaten Bandung','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(9,1,'3276','Kota Depok','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(10,6,'3374','Kota Semarang','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(11,6,'3372','Kota Surakarta','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(12,7,'3471','Kota Yogyakarta','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(13,7,'3402','Kabupaten Bantul','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(14,7,'3404','Kabupaten Sleman','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(15,7,'3403','Kabupaten Gunungkidul','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(16,7,'3401','Kabupaten Kulon Progo','2026-09-16 15:14:56','2026-09-16 15:14:56'),
(17,8,'3578','Kota Surabaya','2026-09-16 15:14:56','2026-09-16 15:14:56');
/*!40000 ALTER TABLE `regencies` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` bigint(20) unsigned NOT NULL,
  `module_id` bigint(20) unsigned NOT NULL,
  `can_access` tinyint(1) NOT NULL DEFAULT 0,
  `can_create` tinyint(1) NOT NULL DEFAULT 0,
  `read_scope` enum('no','all','own') NOT NULL DEFAULT 'no',
  `update_scope` enum('no','all','own') NOT NULL DEFAULT 'no',
  `delete_scope` enum('no','all','own') NOT NULL DEFAULT 'no',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_permissions_role_module` (`role_id`,`module_id`),
  KEY `idx_role_permissions_module_id` (`module_id`),
  CONSTRAINT `fk_role_permissions_module` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_role_permissions_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `role_permissions` VALUES
(1,1,10,1,0,'all','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(2,1,7,0,0,'no','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(3,1,1,1,0,'no','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(4,1,5,1,0,'all','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(5,1,6,0,0,'no','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(6,1,4,1,0,'own','own','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(7,1,2,1,0,'all','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(8,1,8,0,0,'no','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(9,1,9,0,0,'no','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(10,1,3,1,1,'all','all','all','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(16,2,10,0,0,'no','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(17,2,7,1,0,'all','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(18,2,1,1,0,'no','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(19,2,5,1,0,'all','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(20,2,6,1,0,'all','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(21,2,4,1,0,'own','own','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(22,2,2,0,0,'no','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(23,2,8,1,0,'own','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(24,2,9,0,0,'no','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(25,2,3,0,0,'no','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(31,3,10,0,0,'no','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(32,3,7,1,1,'all','all','all','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(33,3,1,1,0,'no','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(34,3,5,1,0,'all','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(35,3,6,1,1,'all','all','all','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(36,3,4,1,0,'own','own','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(37,3,2,0,0,'no','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(38,3,8,1,1,'all','all','all','2026-09-16 09:05:47','2026-09-17 03:43:56'),
(39,3,9,1,1,'all','all','all','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(40,3,3,0,0,'no','no','no','2026-09-16 09:05:47','2026-09-16 09:05:47');
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_roles_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `roles` VALUES
(1,'superadmin','Superadmin','Memiliki hak akses penuh untuk kelola user, role, profile, dashboard, dan modul log.','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(2,'manager_hrd','Manager HRD','Manajer HRD dengan akses monitoring dashboard, read data pegawai, read presensi, dan read-only tunjangan transport.','2026-09-16 09:05:47','2026-09-16 09:05:47'),
(3,'admin_hrd','Admin HRD','Administrator HRD operasional dengan akses CRUD data pegawai, presensi, dan setting tunjangan transport.','2026-09-16 09:05:47','2026-09-16 09:05:47');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `transport_allowance_details`
--

DROP TABLE IF EXISTS `transport_allowance_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `transport_allowance_details` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `transport_allowance_period_id` bigint(20) unsigned NOT NULL,
  `employee_id` bigint(20) unsigned NOT NULL,
  `base_fare` decimal(15,2) NOT NULL,
  `original_km` decimal(8,2) NOT NULL,
  `rounded_km` decimal(8,2) NOT NULL,
  `effective_km` decimal(8,2) NOT NULL DEFAULT 0.00,
  `attendance_days` smallint(5) unsigned NOT NULL DEFAULT 0,
  `nominal` decimal(18,2) NOT NULL DEFAULT 0.00,
  `eligibility_status` varchar(30) NOT NULL,
  `calculation_note` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_transport_details_period_employee` (`transport_allowance_period_id`,`employee_id`),
  KEY `idx_transport_details_employee_id` (`employee_id`),
  CONSTRAINT `fk_transport_details_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_transport_details_period` FOREIGN KEY (`transport_allowance_period_id`) REFERENCES `transport_allowance_periods` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_transport_details_values` CHECK (`base_fare` >= 0 and `original_km` >= 0 and `rounded_km` >= 0 and `nominal` >= 0)
) ENGINE=InnoDB AUTO_INCREMENT=441 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transport_allowance_details`
--

LOCK TABLES `transport_allowance_details` WRITE;
/*!40000 ALTER TABLE `transport_allowance_details` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `transport_allowance_details` VALUES
(82,1,1,5000.00,8.50,9.00,9.00,21,945000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 8.5km dibulatkan 9km, hadir 21 hari','2026-09-17 07:09:12','2026-09-17 07:19:28'),
(83,1,17,5000.00,28.00,28.00,25.00,22,2750000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 28.0km dibulatkan 28km (jarak riil 28km dicap maksimal 25km), hadir 22 hari','2026-09-17 07:09:12','2026-09-17 07:19:28'),
(84,1,24,5000.00,9.20,9.00,9.00,20,900000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.2km dibulatkan 9km, hadir 20 hari','2026-09-17 07:09:12','2026-09-17 07:15:15'),
(85,1,29,5000.00,6.70,7.00,7.00,21,735000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.7km dibulatkan 7km, hadir 21 hari','2026-09-17 07:09:12','2026-09-17 07:15:15'),
(86,1,30,5000.00,10.50,11.00,11.00,19,1045000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 10.5km dibulatkan 11km, hadir 19 hari','2026-09-17 07:09:12','2026-09-17 07:19:28'),
(87,1,35,5000.00,7.00,7.00,7.00,22,770000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 7.0km dibulatkan 7km, hadir 22 hari','2026-09-17 07:09:12','2026-09-17 07:15:15'),
(88,1,36,5000.00,9.00,9.00,9.00,20,900000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.0km dibulatkan 9km, hadir 20 hari','2026-09-17 07:09:12','2026-09-17 07:15:15'),
(89,1,38,5000.00,11.20,11.00,11.00,21,1155000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 11.2km dibulatkan 11km, hadir 21 hari','2026-09-17 07:09:12','2026-09-17 07:15:15'),
(100,11,1,5000.00,8.50,9.00,9.00,21,945000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 8.5km dibulatkan 9km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:19:28'),
(101,11,14,5000.00,6.00,6.00,6.00,21,630000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.0km dibulatkan 6km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(102,11,17,5000.00,28.00,28.00,25.00,22,2750000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 28.0km dibulatkan 28km (jarak riil 28km dicap maksimal 25km), hadir 22 hari','2026-09-17 07:15:15','2026-09-17 07:19:28'),
(103,11,24,5000.00,9.20,9.00,9.00,20,900000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.2km dibulatkan 9km, hadir 20 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(104,11,29,5000.00,6.70,7.00,7.00,20,700000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.7km dibulatkan 7km, hadir 20 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(105,11,30,5000.00,10.50,11.00,11.00,20,1100000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 10.5km dibulatkan 11km, hadir 20 hari','2026-09-17 07:15:15','2026-09-17 07:19:28'),
(106,11,32,5000.00,13.00,13.00,13.00,21,1365000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 13.0km dibulatkan 13km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(107,11,35,5000.00,7.00,7.00,7.00,22,770000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 7.0km dibulatkan 7km, hadir 22 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(108,11,36,5000.00,9.00,9.00,9.00,21,945000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.0km dibulatkan 9km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(109,11,38,5000.00,11.20,11.00,11.00,21,1155000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 11.2km dibulatkan 11km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(110,2,1,5000.00,8.50,9.00,9.00,21,945000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 8.5km dibulatkan 9km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:19:28'),
(111,2,14,5000.00,6.00,6.00,6.00,21,630000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.0km dibulatkan 6km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(112,2,17,5000.00,28.00,28.00,25.00,22,2750000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 28.0km dibulatkan 28km (jarak riil 28km dicap maksimal 25km), hadir 22 hari','2026-09-17 07:15:15','2026-09-17 07:19:28'),
(113,2,24,5000.00,9.20,9.00,9.00,20,900000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.2km dibulatkan 9km, hadir 20 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(114,2,29,5000.00,6.70,7.00,7.00,21,735000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.7km dibulatkan 7km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(115,2,30,5000.00,10.50,11.00,11.00,20,1100000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 10.5km dibulatkan 11km, hadir 20 hari','2026-09-17 07:15:15','2026-09-17 07:19:28'),
(116,2,32,5000.00,13.00,13.00,13.00,21,1365000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 13.0km dibulatkan 13km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(117,2,35,5000.00,7.00,7.00,7.00,22,770000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 7.0km dibulatkan 7km, hadir 22 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(118,2,36,5000.00,9.00,9.00,9.00,20,900000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.0km dibulatkan 9km, hadir 20 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(119,2,38,5000.00,11.20,11.00,11.00,21,1155000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 11.2km dibulatkan 11km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(120,3,1,5000.00,8.50,9.00,9.00,20,900000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 8.5km dibulatkan 9km, hadir 20 hari','2026-09-17 07:15:15','2026-09-17 07:19:28'),
(121,3,14,5000.00,6.00,6.00,6.00,19,570000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.0km dibulatkan 6km, hadir 19 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(122,3,17,5000.00,28.00,28.00,25.00,20,2500000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 28.0km dibulatkan 28km (jarak riil 28km dicap maksimal 25km), hadir 20 hari','2026-09-17 07:15:15','2026-09-17 07:19:28'),
(123,3,24,5000.00,9.20,9.00,9.00,19,855000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.2km dibulatkan 9km, hadir 19 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(124,3,29,5000.00,6.70,7.00,7.00,19,665000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.7km dibulatkan 7km, hadir 19 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(125,3,30,5000.00,10.50,11.00,11.00,19,1045000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 10.5km dibulatkan 11km, hadir 19 hari','2026-09-17 07:15:15','2026-09-17 07:19:28'),
(126,3,32,5000.00,13.00,13.00,13.00,19,1235000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 13.0km dibulatkan 13km, hadir 19 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(127,3,35,5000.00,7.00,7.00,7.00,20,700000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 7.0km dibulatkan 7km, hadir 20 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(128,3,36,5000.00,9.00,9.00,9.00,19,855000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.0km dibulatkan 9km, hadir 19 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(129,3,38,5000.00,11.20,11.00,11.00,19,1045000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 11.2km dibulatkan 11km, hadir 19 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(130,4,1,5000.00,8.50,9.00,9.00,22,990000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 8.5km dibulatkan 9km, hadir 22 hari','2026-09-17 07:15:15','2026-09-17 07:19:28'),
(131,4,14,5000.00,6.00,6.00,6.00,22,660000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.0km dibulatkan 6km, hadir 22 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(132,4,17,5000.00,28.00,28.00,25.00,22,2750000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 28.0km dibulatkan 28km (jarak riil 28km dicap maksimal 25km), hadir 22 hari','2026-09-17 07:15:15','2026-09-17 07:19:28'),
(133,4,24,5000.00,9.20,9.00,9.00,21,945000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.2km dibulatkan 9km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(134,4,29,5000.00,6.70,7.00,7.00,21,735000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.7km dibulatkan 7km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(135,4,30,5000.00,10.50,11.00,11.00,21,1155000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 10.5km dibulatkan 11km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:19:28'),
(136,4,32,5000.00,13.00,13.00,13.00,21,1365000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 13.0km dibulatkan 13km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(137,4,35,5000.00,7.00,7.00,7.00,22,770000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 7.0km dibulatkan 7km, hadir 22 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(138,4,36,5000.00,9.00,9.00,9.00,21,945000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.0km dibulatkan 9km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(139,4,38,5000.00,11.20,11.00,11.00,21,1155000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 11.2km dibulatkan 11km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(172,1,14,5000.00,6.00,6.00,6.00,21,630000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.0km dibulatkan 6km, hadir 21 hari','2026-09-17 07:15:15','2026-09-17 07:15:15'),
(198,5,1,5000.00,8.50,9.00,9.00,20,900000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 8.5km dibulatkan 9km, hadir 20 hari','2026-09-17 07:16:20','2026-09-17 07:19:28'),
(199,5,17,5000.00,28.00,28.00,25.00,21,2625000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 28.0km dibulatkan 28km (jarak riil 28km dicap maksimal 25km), hadir 21 hari','2026-09-17 07:16:20','2026-09-17 07:19:28'),
(200,5,24,5000.00,9.20,9.00,9.00,20,900000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.2km dibulatkan 9km, hadir 20 hari','2026-09-17 07:16:20','2026-09-17 07:19:28'),
(201,5,29,5000.00,6.70,7.00,7.00,20,700000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.7km dibulatkan 7km, hadir 20 hari','2026-09-17 07:16:20','2026-09-17 07:19:28'),
(202,5,30,5000.00,10.50,11.00,11.00,19,1045000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 10.5km dibulatkan 11km, hadir 19 hari','2026-09-17 07:16:20','2026-09-17 07:19:28'),
(203,5,32,5000.00,13.00,13.00,13.00,20,1300000.00,'eligible','Berhak: Pegawai Tetap (PKWTT), jarak efektif 13 km, kehadiran 20 hari kerja.','2026-09-17 07:16:20','2026-09-17 07:16:20'),
(204,5,35,5000.00,7.00,7.00,7.00,21,735000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 7.0km dibulatkan 7km, hadir 21 hari','2026-09-17 07:16:20','2026-09-17 07:19:28'),
(205,5,36,5000.00,9.00,9.00,9.00,20,900000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.0km dibulatkan 9km, hadir 20 hari','2026-09-17 07:16:20','2026-09-17 07:19:28'),
(206,5,38,5000.00,11.20,11.00,11.00,20,1100000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 11.2km dibulatkan 11km, hadir 20 hari','2026-09-17 07:16:20','2026-09-17 07:19:28'),
(207,6,1,5000.00,8.50,9.00,9.00,21,945000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 8.5km dibulatkan 9km, hadir 21 hari','2026-09-17 07:16:25','2026-09-17 07:19:28'),
(208,6,17,5000.00,28.00,28.00,25.00,22,2750000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 28.0km dibulatkan 28km (jarak riil 28km dicap maksimal 25km), hadir 22 hari','2026-09-17 07:16:25','2026-09-17 07:19:28'),
(209,6,24,5000.00,9.20,9.00,9.00,20,900000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.2km dibulatkan 9km, hadir 20 hari','2026-09-17 07:16:25','2026-09-17 07:19:28'),
(210,6,29,5000.00,6.70,7.00,7.00,21,735000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.7km dibulatkan 7km, hadir 21 hari','2026-09-17 07:16:25','2026-09-17 07:19:28'),
(211,6,30,5000.00,10.50,11.00,11.00,21,1155000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 10.5km dibulatkan 11km, hadir 21 hari','2026-09-17 07:16:25','2026-09-17 07:19:28'),
(212,6,32,5000.00,13.00,13.00,13.00,21,1365000.00,'eligible','Berhak: Pegawai Tetap (PKWTT), jarak efektif 13 km, kehadiran 21 hari kerja.','2026-09-17 07:16:25','2026-09-17 07:16:25'),
(213,6,35,5000.00,7.00,7.00,7.00,22,770000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 7.0km dibulatkan 7km, hadir 22 hari','2026-09-17 07:16:25','2026-09-17 07:19:28'),
(214,6,36,5000.00,9.00,9.00,9.00,21,945000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.0km dibulatkan 9km, hadir 21 hari','2026-09-17 07:16:25','2026-09-17 07:19:28'),
(215,6,38,5000.00,11.20,11.00,11.00,21,1155000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 11.2km dibulatkan 11km, hadir 21 hari','2026-09-17 07:16:25','2026-09-17 07:19:28'),
(225,7,1,5000.00,8.50,9.00,9.00,21,945000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 8.5km dibulatkan 9km, hadir 21 hari','2026-09-17 07:16:48','2026-09-17 07:19:28'),
(226,7,17,5000.00,28.00,28.00,25.00,21,2625000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 28.0km dibulatkan 28km (jarak riil 28km dicap maksimal 25km), hadir 21 hari','2026-09-17 07:16:48','2026-09-17 07:19:28'),
(227,7,24,5000.00,9.20,9.00,9.00,20,900000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.2km dibulatkan 9km, hadir 20 hari','2026-09-17 07:16:48','2026-09-17 07:19:28'),
(228,7,29,5000.00,6.70,7.00,7.00,20,700000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.7km dibulatkan 7km, hadir 20 hari','2026-09-17 07:16:48','2026-09-17 07:19:28'),
(229,7,30,5000.00,10.50,11.00,11.00,20,1100000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 10.5km dibulatkan 11km, hadir 20 hari','2026-09-17 07:16:48','2026-09-17 07:19:28'),
(230,7,32,5000.00,13.00,13.00,13.00,20,1300000.00,'eligible','Berhak: Pegawai Tetap (PKWTT), jarak efektif 13 km, kehadiran 20 hari kerja.','2026-09-17 07:16:48','2026-09-17 07:16:48'),
(231,7,35,5000.00,7.00,7.00,7.00,21,735000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 7.0km dibulatkan 7km, hadir 21 hari','2026-09-17 07:16:48','2026-09-17 07:19:28'),
(232,7,36,5000.00,9.00,9.00,9.00,20,900000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.0km dibulatkan 9km, hadir 20 hari','2026-09-17 07:16:48','2026-09-17 07:19:28'),
(233,7,38,5000.00,11.20,11.00,11.00,21,1155000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 11.2km dibulatkan 11km, hadir 21 hari','2026-09-17 07:16:48','2026-09-17 07:19:28'),
(234,8,1,5000.00,8.50,9.00,9.00,22,990000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 8.5km dibulatkan 9km, hadir 22 hari','2026-09-17 07:16:54','2026-09-17 07:19:28'),
(235,8,17,5000.00,28.00,28.00,25.00,21,2625000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 28.0km dibulatkan 28km (jarak riil 28km dicap maksimal 25km), hadir 21 hari','2026-09-17 07:16:54','2026-09-17 07:19:28'),
(236,8,24,5000.00,9.20,9.00,9.00,21,945000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.2km dibulatkan 9km, hadir 21 hari','2026-09-17 07:16:54','2026-09-17 07:19:28'),
(237,8,29,5000.00,6.70,7.00,7.00,22,770000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.7km dibulatkan 7km, hadir 22 hari','2026-09-17 07:16:54','2026-09-17 07:19:28'),
(238,8,30,5000.00,10.50,11.00,11.00,20,1100000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 10.5km dibulatkan 11km, hadir 20 hari','2026-09-17 07:16:54','2026-09-17 07:19:28'),
(239,8,32,5000.00,13.00,13.00,13.00,20,1300000.00,'eligible','Berhak: Pegawai Tetap (PKWTT), jarak efektif 13 km, kehadiran 20 hari kerja.','2026-09-17 07:16:54','2026-09-17 07:16:54'),
(240,8,35,5000.00,7.00,7.00,7.00,21,735000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 7.0km dibulatkan 7km, hadir 21 hari','2026-09-17 07:16:54','2026-09-17 07:19:28'),
(241,8,36,5000.00,9.00,9.00,9.00,22,990000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 9.0km dibulatkan 9km, hadir 22 hari','2026-09-17 07:16:54','2026-09-17 07:19:28'),
(242,8,38,5000.00,11.20,11.00,11.00,20,1100000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 11.2km dibulatkan 11km, hadir 20 hari','2026-09-17 07:16:54','2026-09-17 07:19:28'),
(253,5,14,5000.00,6.00,6.00,6.00,20,600000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.0km dibulatkan 6km, hadir 20 hari','2026-09-17 07:19:28','2026-09-17 07:19:28'),
(254,6,14,5000.00,6.00,6.00,6.00,21,630000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.0km dibulatkan 6km, hadir 21 hari','2026-09-17 07:19:28','2026-09-17 07:19:28'),
(255,7,14,5000.00,6.00,6.00,6.00,20,600000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.0km dibulatkan 6km, hadir 20 hari','2026-09-17 07:19:28','2026-09-17 07:19:28'),
(256,8,14,5000.00,6.00,6.00,6.00,21,630000.00,'eligible','Memenuhi syarat: Pegawai tetap (PKWTT), jarak 6.0km dibulatkan 6km, hadir 21 hari','2026-09-17 07:19:28','2026-09-17 07:19:28'),
(432,10,1,5000.00,8.50,9.00,9.00,20,900000.00,'eligible','Berhak: Pegawai Tetap (PKWTT), jarak efektif 9 km, kehadiran 20 hari kerja.','2026-09-17 07:21:06','2026-09-17 07:21:06'),
(433,10,14,5000.00,6.00,6.00,6.00,20,600000.00,'eligible','Berhak: Pegawai Tetap (PKWTT), jarak efektif 6 km, kehadiran 20 hari kerja.','2026-09-17 07:21:06','2026-09-17 07:21:06'),
(434,10,17,5000.00,28.00,28.00,25.00,21,2625000.00,'eligible','Berhak: Pegawai Tetap (PKWTT), jarak efektif 25 km (jarak riil 28 km dicap maksimal 25 km), kehadiran 21 hari kerja.','2026-09-17 07:21:06','2026-09-17 07:21:06'),
(435,10,24,5000.00,9.20,9.00,9.00,20,900000.00,'eligible','Berhak: Pegawai Tetap (PKWTT), jarak efektif 9 km, kehadiran 20 hari kerja.','2026-09-17 07:21:06','2026-09-17 07:21:06'),
(436,10,29,5000.00,6.70,7.00,7.00,21,735000.00,'eligible','Berhak: Pegawai Tetap (PKWTT), jarak efektif 7 km, kehadiran 21 hari kerja.','2026-09-17 07:21:06','2026-09-17 07:21:06'),
(437,10,30,5000.00,10.50,11.00,11.00,19,1045000.00,'eligible','Berhak: Pegawai Tetap (PKWTT), jarak efektif 11 km, kehadiran 19 hari kerja.','2026-09-17 07:21:06','2026-09-17 07:21:06'),
(438,10,35,5000.00,7.00,7.00,7.00,21,735000.00,'eligible','Berhak: Pegawai Tetap (PKWTT), jarak efektif 7 km, kehadiran 21 hari kerja.','2026-09-17 07:21:06','2026-09-17 07:21:06'),
(439,10,36,5000.00,9.00,9.00,9.00,20,900000.00,'eligible','Berhak: Pegawai Tetap (PKWTT), jarak efektif 9 km, kehadiran 20 hari kerja.','2026-09-17 07:21:06','2026-09-17 07:21:06'),
(440,10,38,5000.00,11.20,11.00,11.00,20,1100000.00,'eligible','Berhak: Pegawai Tetap (PKWTT), jarak efektif 11 km, kehadiran 20 hari kerja.','2026-09-17 07:21:06','2026-09-17 07:21:06');
/*!40000 ALTER TABLE `transport_allowance_details` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `transport_allowance_periods`
--

DROP TABLE IF EXISTS `transport_allowance_periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `transport_allowance_periods` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `period_year` smallint(5) unsigned NOT NULL,
  `period_month` tinyint(3) unsigned NOT NULL,
  `total_recipients` int(10) unsigned NOT NULL DEFAULT 0,
  `total_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `status` enum('draft','calculated','locked') NOT NULL DEFAULT 'draft',
  `calculated_by` bigint(20) unsigned DEFAULT NULL,
  `calculated_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_transport_periods_year_month` (`period_year`,`period_month`),
  KEY `idx_transport_periods_calculated_by` (`calculated_by`),
  CONSTRAINT `fk_transport_periods_calculator` FOREIGN KEY (`calculated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_transport_periods_month` CHECK (`period_month` between 1 and 12)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transport_allowance_periods`
--

LOCK TABLES `transport_allowance_periods` WRITE;
/*!40000 ALTER TABLE `transport_allowance_periods` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `transport_allowance_periods` VALUES
(1,2026,8,9,9830000.00,'calculated',NULL,'2026-09-01 08:30:00','2026-09-17 02:25:11','2026-09-17 07:19:28'),
(2,2026,1,9,9885000.00,'calculated',NULL,'2026-02-01 08:30:00','2026-09-17 03:11:57','2026-09-17 07:19:28'),
(3,2026,2,9,9135000.00,'calculated',NULL,'2026-03-01 08:30:00','2026-09-17 03:11:57','2026-09-17 07:19:28'),
(4,2026,3,9,10105000.00,'calculated',NULL,'2026-04-01 08:30:00','2026-09-17 03:11:57','2026-09-17 07:19:28'),
(5,2026,4,9,9505000.00,'calculated',NULL,'2026-05-01 08:30:00','2026-09-17 03:11:57','2026-09-17 07:19:28'),
(6,2026,5,9,9985000.00,'calculated',NULL,'2026-06-01 08:30:00','2026-09-17 03:11:57','2026-09-17 07:19:28'),
(7,2026,6,9,9660000.00,'calculated',NULL,'2026-07-01 08:30:00','2026-09-17 03:11:57','2026-09-17 07:19:28'),
(8,2026,7,9,9885000.00,'calculated',NULL,'2026-08-01 08:30:00','2026-09-17 03:11:57','2026-09-17 07:19:28'),
(9,2026,9,0,0.00,'calculated',3,'2026-09-17 07:21:12','2026-09-17 03:11:57','2026-09-17 07:21:12'),
(10,2025,11,9,9540000.00,'calculated',3,'2026-09-17 07:21:06','2026-09-17 03:11:57','2026-09-17 07:21:06'),
(11,2025,12,9,9895000.00,'calculated',NULL,'2026-01-02 08:30:00','2026-09-17 03:11:57','2026-09-17 07:19:28');
/*!40000 ALTER TABLE `transport_allowance_periods` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `transport_allowance_settings`
--

DROP TABLE IF EXISTS `transport_allowance_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `transport_allowance_settings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `base_fare` decimal(15,2) NOT NULL,
  `effective_start` date NOT NULL,
  `min_km` decimal(8,2) NOT NULL,
  `max_km` decimal(8,2) NOT NULL,
  `min_work_days` smallint(5) unsigned NOT NULL DEFAULT 19,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_transport_settings_active_start` (`is_active`,`effective_start`),
  KEY `idx_transport_settings_created_by` (`created_by`),
  CONSTRAINT `fk_transport_settings_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_transport_settings_fare` CHECK (`base_fare` >= 0),
  CONSTRAINT `chk_transport_settings_km` CHECK (`min_km` >= 0 and `max_km` >= `min_km`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transport_allowance_settings`
--

LOCK TABLES `transport_allowance_settings` WRITE;
/*!40000 ALTER TABLE `transport_allowance_settings` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `transport_allowance_settings` VALUES
(1,5000.00,'2026-01-01',5.00,25.00,19,0,NULL,'2026-09-17 02:25:11','2026-09-17 07:08:52'),
(2,5000.00,'2026-01-01',5.00,25.00,19,0,NULL,'2026-09-17 03:11:57','2026-09-17 07:08:52'),
(3,500000.00,'2025-12-31',5.00,25.00,19,0,3,'2026-09-17 07:08:52','2026-09-17 07:09:07'),
(4,5000.00,'2025-12-30',5.00,25.00,19,1,3,'2026-09-17 07:09:07','2026-09-17 07:09:07'),
(5,5000.00,'2026-01-01',5.00,25.00,19,1,NULL,'2026-09-17 07:15:15','2026-09-17 07:15:15'),
(6,5000.00,'2026-01-01',5.00,25.00,19,1,NULL,'2026-09-17 07:19:28','2026-09-17 07:19:28'),
(7,5000.00,'2026-01-01',5.00,25.00,19,1,NULL,'2026-09-17 07:20:33','2026-09-17 07:20:33');
/*!40000 ALTER TABLE `transport_allowance_settings` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `user_sessions`
--

DROP TABLE IF EXISTS `user_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_sessions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `session_token` varchar(255) NOT NULL,
  `remember_me` tinyint(1) NOT NULL DEFAULT 0,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `last_activity_at` datetime NOT NULL,
  `expires_at` datetime NOT NULL,
  `logged_out_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_sessions_token` (`session_token`),
  KEY `idx_user_sessions_user_id` (`user_id`),
  KEY `idx_user_sessions_expires_at` (`expires_at`),
  CONSTRAINT `fk_user_sessions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_sessions`
--

LOCK TABLES `user_sessions` WRITE;
/*!40000 ALTER TABLE `user_sessions` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `user_sessions` VALUES
(1,1,'0ba82a517932e2829c5a5b4c65d920119b09b92bf2fb043a0a2f4fc89023eaf0',0,'::1','node','2026-09-16 09:09:41','2026-09-16 16:12:41','2026-09-16 09:09:41','2026-09-16 09:09:41','2026-09-16 09:09:41'),
(2,2,'0d90a6870729d47b97169d3bb0efeadd085dc7fa65f44990fbc3881fcb7e3ef7',1,'::1','node','2026-09-16 09:09:41','2026-10-16 16:09:41',NULL,'2026-09-16 09:09:41','2026-09-16 09:09:41'),
(3,3,'79d4aeeb612b17063f51e7de6c1aae80babd28069c247768639995d0c8b8c81f',0,'::1','node','2026-09-16 09:09:41','2026-09-16 16:12:41',NULL,'2026-09-16 09:09:41','2026-09-16 09:09:41'),
(4,1,'d1b57b2682b18908c8db2624e319f9e25751263e1452c0ac789836bc2f16f161',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:17:12','2026-09-16 17:20:12',NULL,'2026-09-16 10:17:12','2026-09-16 10:17:12'),
(5,1,'18bb86264e7535a83f15cceea9babbf5b1b693a5d7e5b15f636c849ece8b7e84',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:17:30','2026-09-16 17:20:30',NULL,'2026-09-16 10:17:30','2026-09-16 10:17:30'),
(6,1,'e2066d254234e05d96cb5c9f73d16d643648c0610a553211707f6fa1ed29b40f',0,'::1','curl/8.7.1','2026-09-16 10:20:44','2026-09-16 17:23:44',NULL,'2026-09-16 10:20:41','2026-09-16 10:20:44'),
(7,1,'2a7f1244ecc73315c78ae392e1d375da9aaa1be54832325d0462a8dceda1045b',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:31:50','2026-09-16 17:34:50',NULL,'2026-09-16 10:31:50','2026-09-16 10:31:50'),
(8,1,'01dc707005ee09163c1efe25f75ed7bb3f17ee4102e287674effaf3020a08b26',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:34:56','2026-09-16 17:37:56',NULL,'2026-09-16 10:34:56','2026-09-16 10:34:56'),
(9,1,'7c4a41cf7cc26838f89b68dde095f749046ecffa4affd89ead574e1386681ec7',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:36:44','2026-09-16 17:39:44',NULL,'2026-09-16 10:36:44','2026-09-16 10:36:44'),
(10,1,'b41dba19ac0c36172bb921dcfdd6885ead97796081dd0495f8aaa3cbb90a9d7b',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:39:04','2026-09-16 17:42:04',NULL,'2026-09-16 10:39:04','2026-09-16 10:39:04'),
(11,1,'5f46ad295688fd579261e7350320724415e65a16e9d6994224dbec6bafe3c55b',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:43:19','2026-09-16 17:46:19',NULL,'2026-09-16 10:43:19','2026-09-16 10:43:19'),
(12,1,'5e59ef0156b748d69d1276c6dc9a26c9bce5d52c20f0a44de73f82e1c781c6b2',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:44:19','2026-09-16 17:47:19',NULL,'2026-09-16 10:44:19','2026-09-16 10:44:19'),
(13,1,'afb1d676300898ec81698f0656e58e6ae5f9fec03045b1b13a32d72a58942218',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:48:53','2026-09-16 17:51:53',NULL,'2026-09-16 10:46:08','2026-09-16 10:48:53'),
(14,1,'e9ac00aa1b82f9ab602b9f6041dd47afd01a5829cf7c2c3047c74d4eda339f0b',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:54:26','2026-09-16 17:57:26',NULL,'2026-09-16 10:51:44','2026-09-16 10:54:26'),
(15,1,'dde82261385dadffe60427a4fe91062fc2c159a14c290dc65022dd53cd70615a',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:55:31','2026-09-16 17:58:31','2026-09-16 10:55:31','2026-09-16 10:55:10','2026-09-16 10:55:31'),
(16,1,'91ab32df667f5eadb0ed8007633cd58c130fd916ade83b76dcbc85e0d61cb2a0',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 10:58:13','2026-09-16 18:01:13',NULL,'2026-09-16 10:55:42','2026-09-16 10:58:13'),
(17,1,'c564fc1a9c04d4811c859ef6490c83e43ac32c4191d96e550560f74e2aaa8c91',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 11:05:05','2026-09-16 18:08:05',NULL,'2026-09-16 11:03:24','2026-09-16 11:05:05'),
(18,1,'fabdb0314fb97526d0f7614507d12a920ff0b526c67814b4a86b012b63a21b60',1,'::1','curl/8.7.1','2026-09-16 11:10:56','2026-10-16 18:10:53',NULL,'2026-09-16 11:10:53','2026-09-16 11:10:56'),
(19,1,'afc4cfbecdffb7b90466237c9cccc1a61089378a1afe82caf0de442306a0822b',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 11:11:57','2026-09-16 18:14:57','2026-09-16 11:11:57','2026-09-16 11:11:12','2026-09-16 11:11:57'),
(20,1,'502290c31b45de389940352fdfc3456f7dc5f7c1d82b85e2cec4f267dad9ce92',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 11:16:52','2026-09-16 18:19:52',NULL,'2026-09-16 11:12:05','2026-09-16 11:16:52'),
(21,1,'ba29d5cf878ba3f48a71358c9c5dba55a8eef6eaf4b277203828fca488b70387',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 11:18:18','2026-09-16 18:21:18',NULL,'2026-09-16 11:17:38','2026-09-16 11:18:18'),
(22,1,'8727110312ff911ffe6e196ab25c75e39ac705e70042adbf043b9c7e4bed7594',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 11:23:47','2026-09-16 18:26:47',NULL,'2026-09-16 11:21:31','2026-09-16 11:23:47'),
(23,2,'1216c9b9e9e7dcc534e5e5f7593abcfbbf68662bb3b2956dd26128f5ae03dd37',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15','2026-09-16 11:32:34','2026-09-16 18:35:34',NULL,'2026-09-16 11:32:34','2026-09-16 11:32:34'),
(24,3,'65cd2fc3178d1e766ff8a0a4bb2ffbda22b412cd037881a810a45759f27cf089',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15','2026-09-16 11:33:00','2026-09-16 18:36:00',NULL,'2026-09-16 11:33:00','2026-09-16 11:33:00'),
(25,1,'86b6ee8a7923f7d93dfb36a2e7cf04fbd552ae888cc68ec69290606d616025eb',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 11:43:25','2026-09-16 18:46:25',NULL,'2026-09-16 11:43:23','2026-09-16 11:43:25'),
(26,1,'9cfeafaa310a245dc3103549677ce8be1be1d17b1241e1e6dffbcd472e5cc1b2',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 11:47:09','2026-09-16 18:50:09','2026-09-16 11:47:09','2026-09-16 11:47:00','2026-09-16 11:47:09'),
(27,3,'a274ebad84b742858e58c84924c91e259b975ee8f82596531de87169b75398f6',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 11:52:19','2026-09-16 18:55:19','2026-09-16 11:52:19','2026-09-16 11:47:57','2026-09-16 11:52:19'),
(28,1,'cc012873ee0fca674a3cdd051b5f0ce9b2151a912fe5e11b68140c3c2a5f3da4',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 11:52:36','2026-09-16 18:55:36','2026-09-16 11:52:36','2026-09-16 11:52:26','2026-09-16 11:52:36'),
(29,3,'aa1561eb3bc8eb4266e3989a45ba71afa1564b3344c3238812309721ad4ad142',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 11:55:24','2026-09-16 18:58:24','2026-09-16 11:55:24','2026-09-16 11:53:21','2026-09-16 11:55:24'),
(30,1,'eaf82ab07147e68fb1b4e8c53206c9b6a6554fdd5607016d0bbef1b4547a55ff',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 11:55:38','2026-09-16 18:58:38','2026-09-16 11:55:38','2026-09-16 11:55:34','2026-09-16 11:55:38'),
(31,2,'c45fa74f7573e3bc11a3e428c84e57ec2c09fd573441424edaef54bc7764f34f',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 11:57:34','2026-09-16 19:00:34',NULL,'2026-09-16 11:56:31','2026-09-16 11:57:34'),
(32,3,'8ec56aae0e3623443432ab1fe84d1596f4c12e4427267b3f0b2a9bcc1c90e07f',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15','2026-09-16 11:57:13','2026-09-16 19:00:13','2026-09-16 11:57:14','2026-09-16 11:57:10','2026-09-16 11:57:14'),
(33,1,'195c77be7f2e82922eca594766a0c22a58e1993bd5f6626b33d323f1de51366b',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15','2026-09-16 11:57:39','2026-09-16 19:00:39',NULL,'2026-09-16 11:57:39','2026-09-16 11:57:39'),
(34,1,'aaa8260a54841414f7de536c2ff2197c214220f006179d3256b9dbf0f4d690f5',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 14:12:22','2026-10-16 19:17:12','2026-09-16 14:12:22','2026-09-16 12:17:12','2026-09-16 14:12:22'),
(35,3,'d5e9eb2d6aa28e6f6c84f1cf0c24010c25e03628074fbf0ed039648f842c7cc2',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15','2026-09-16 14:25:48','2026-10-16 19:18:12',NULL,'2026-09-16 12:18:12','2026-09-16 14:25:48'),
(36,2,'38ada891cc96822d90e6109fb5033ff5400d7dcbf2abb6810731cc011bc282cc',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15','2026-09-17 07:05:56','2026-10-16 19:18:34','2026-09-17 07:05:56','2026-09-16 12:18:34','2026-09-17 07:05:56'),
(37,1,'fc64c8160cfaa68b240d8d5d9bd2a54134cb4fc692f418233e8a61d5af7e488e',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 14:18:55','2026-09-16 21:21:55',NULL,'2026-09-16 14:12:29','2026-09-16 14:18:55'),
(38,1,'a282e9edcdd9266effe053def985a27ab909600cfda88c0d49418fc4055c5dda',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 14:25:02','2026-09-16 21:28:02','2026-09-16 14:25:02','2026-09-16 14:23:45','2026-09-16 14:25:02'),
(39,1,'d2dec80b88c0e3bfbc475df9ca5ff778b322db46e4223e0589a7dd5bdc63a69a',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 14:25:26','2026-09-16 21:28:26','2026-09-16 14:25:26','2026-09-16 14:25:17','2026-09-16 14:25:26'),
(40,3,'4df0a40e365069d94da15afc8ec9b8def8103c4bf15f68706dc1d89883fd6670',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 14:29:43','2026-09-16 21:32:43','2026-09-16 14:29:43','2026-09-16 14:26:12','2026-09-16 14:29:43'),
(41,1,'71ad67ddb33a1ed9fb7446e1455659c1b8d60202b038c27f837f79cbae46285e',0,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 14:27:18','2026-09-16 21:30:18','2026-09-16 14:27:18','2026-09-16 14:27:02','2026-09-16 14:27:18'),
(42,2,'4cdb7a4f69fba811350a9faba5471168363d8763bdd8429ad637be61b18ef174',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-16 15:27:56','2026-10-16 21:30:43','2026-09-16 15:27:56','2026-09-16 14:30:43','2026-09-16 15:27:56'),
(43,3,'a8bdcb9035726d3de29bda2cacf8d4302d19adca05ccb32e5ec4946bd8233e67',0,'::1','node','2026-09-16 15:18:44','2026-09-16 22:21:44',NULL,'2026-09-16 15:18:44','2026-09-16 15:18:44'),
(44,3,'ac7704f1adf7b91731e2b3406045ff16d76d6636e85bbe5d355ef4d4d412d355',0,'::1','node','2026-09-16 15:19:00','2026-09-16 22:22:00',NULL,'2026-09-16 15:19:00','2026-09-16 15:19:00'),
(45,2,'9e6fcbca55f13610f6a0096247163b227f3aff5860a637544c6afa241064053b',0,'::1','node','2026-09-16 15:19:00','2026-09-16 22:22:00',NULL,'2026-09-16 15:19:00','2026-09-16 15:19:00'),
(46,3,'1f44dd068ddb206315ea8fcaea58a4f8a9ab79c2d8655c0674dd328200397fba',0,'::1','node','2026-09-16 15:22:29','2026-09-16 22:25:29',NULL,'2026-09-16 15:22:29','2026-09-16 15:22:29'),
(47,3,'5cb67e4280bb43bcd4e87236161e7ceba8d75946db27c664698f8f12f301e860',0,'::1','node','2026-09-16 15:23:18','2026-09-16 22:26:18',NULL,'2026-09-16 15:23:18','2026-09-16 15:23:18'),
(48,3,'aa9912d248345cc33254e9f833038077da890c6a6e3672f2f6ad3fb6d412c3aa',0,'::1','node','2026-09-16 15:24:07','2026-09-16 22:27:07',NULL,'2026-09-16 15:24:07','2026-09-16 15:24:07'),
(49,3,'45c91b48bc104168f264e2593ce451ecae3ccddd91ee58d5c8c281e85c6ce47d',0,'::1','node','2026-09-16 15:24:55','2026-09-16 22:27:55',NULL,'2026-09-16 15:24:55','2026-09-16 15:24:55'),
(50,3,'7803cd101df1f062c3e632935dc620334314ee92fcba4d5017f03b79e15ff579',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-17 07:21:13','2026-10-16 22:28:51',NULL,'2026-09-16 15:28:51','2026-09-17 07:21:13'),
(51,3,'3fc1ee1e17b4f36218ad275e797e766dbe9699faa53e3cbcfefdf0f13c663acd',0,'::1','node','2026-09-16 15:39:15','2026-09-16 22:42:15',NULL,'2026-09-16 15:39:15','2026-09-16 15:39:15'),
(52,3,'a29bf03b524a672171066bd529a7f3d98acae29f220c022fda1bc4f4be4c07cc',0,'::1','node','2026-09-16 15:45:29','2026-09-16 22:48:29',NULL,'2026-09-16 15:45:29','2026-09-16 15:45:29'),
(53,3,'d0fdfd9c20110b8b5f2c5623e10bc7be685567cd18605e3b8400c82e7178820e',0,'::1','node','2026-09-16 15:51:07','2026-09-16 22:54:07',NULL,'2026-09-16 15:51:07','2026-09-16 15:51:07'),
(54,1,'4f39b98b336fbd90ab437e0ab478aa81f996c2263c0a4fdcb6c1084488cf6bc1',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-17 03:38:47','2026-10-16 22:59:53',NULL,'2026-09-16 15:59:53','2026-09-17 03:38:47'),
(55,1,'743b637c20843ede3cc22b65745c6c0b2b323f078223ed9feeb64bdbeb1f4896',0,'::1','node','2026-09-16 16:06:44','2026-09-16 23:09:44',NULL,'2026-09-16 16:06:44','2026-09-16 16:06:44'),
(56,1,'171a85c8b0c65e43d7a7903a09205448e1f3c9714e55943885614a8cdc96121f',0,'::1','node','2026-09-16 16:06:51','2026-09-16 23:09:51',NULL,'2026-09-16 16:06:51','2026-09-16 16:06:51'),
(57,1,'7134c79cdb055af5e63c130364c7c39cb3a64974718f660c50ca37d06a08483e',0,'::1','node','2026-09-16 16:07:13','2026-09-16 23:10:13',NULL,'2026-09-16 16:07:13','2026-09-16 16:07:13'),
(58,1,'16efd756fcf4178ebad0603b386f96ed6155a24728b69f38e458ebcef957d885',0,'::1','node','2026-09-16 16:08:26','2026-09-16 23:11:26',NULL,'2026-09-16 16:08:26','2026-09-16 16:08:26'),
(59,3,'3b96987d4a64b051989de3be50a6917b6aab7b29ce29af16ef0960627162e5cb',0,'::1','curl/8.7.1','2026-09-17 00:47:15','2026-09-17 07:50:15',NULL,'2026-09-17 00:42:31','2026-09-17 00:47:15'),
(60,2,'d90162727ffc57261f6327dc78bd8fa8e340be505ae6d49260ac3369c11216ea',0,'::1','curl/8.7.1','2026-09-17 00:51:15','2026-09-17 07:54:15',NULL,'2026-09-17 00:51:07','2026-09-17 00:51:15'),
(61,1,'d20d64a51b12ea22dcec0162b328c2764dbbeccc48be8d0cf50477f36134f84d',0,'::1','curl/8.7.1','2026-09-17 00:51:45','2026-09-17 07:54:45',NULL,'2026-09-17 00:51:38','2026-09-17 00:51:45'),
(62,3,'8ca804597c32bc2ae0ce6c619593b3ac9280fc79367c9ee04449c82c476d729c',0,'::1','curl/8.7.1','2026-09-17 01:26:20','2026-09-17 08:29:20',NULL,'2026-09-17 01:26:20','2026-09-17 01:26:20'),
(63,3,'940046329a01422d2546e82f2795a78996a8e11a83bb928e7852ae46e5400536',0,'::1','node','2026-09-17 01:39:26','2026-09-17 08:42:26',NULL,'2026-09-17 01:39:26','2026-09-17 01:39:26'),
(64,3,'b4fb583b9a5100f9bbfb0c28690513efff9c18f04fc198649cbcb8a60c771e46',0,'::1','node','2026-09-17 01:43:14','2026-09-17 08:46:14',NULL,'2026-09-17 01:43:14','2026-09-17 01:43:14'),
(65,2,'b7f676908b1afb51d2976cda341312c528c8a6726d95c90a90167a91176d8e42',1,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Safari/605.1.15','2026-09-17 07:27:40','2026-10-17 14:06:20',NULL,'2026-09-17 07:06:20','2026-09-17 07:27:40');
/*!40000 ALTER TABLE `user_sessions` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned DEFAULT NULL,
  `role_id` bigint(20) unsigned NOT NULL,
  `name` varchar(150) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `cellphone` varchar(30) DEFAULT NULL,
  `password` varchar(255) NOT NULL COMMENT 'Stores password hash only',
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `password_changed_at` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `last_logout_at` datetime DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_users_username` (`username`),
  UNIQUE KEY `uk_users_email` (`email`),
  UNIQUE KEY `uk_users_cellphone` (`cellphone`),
  KEY `idx_users_employee_id` (`employee_id`),
  KEY `idx_users_role_id` (`role_id`),
  KEY `idx_users_status_deleted_at` (`status`,`deleted_at`),
  CONSTRAINT `fk_users_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `users` VALUES
(1,NULL,1,'Super Administrator','superadmin','superadmin@example.com','+6281234567800','ecf5e61937c287f1f767c09cf3023f6c:1f7946e8f3aeb7a13db46d916c4288475c307cfe6193b6199d4dcea9dc98df522b61ae532031f6839e24df8e8d10993aeb123bb225971372a6cb666ce025fcad','active',NULL,'2026-09-17 00:51:38','2026-09-16 14:27:18',NULL,'2026-09-16 09:05:47','2026-09-17 00:51:38',NULL),
(2,1,2,'Ahmad Hermawan (Manager HRD)','manager.hrd','manager.hrd@example.com','+6281234567801','ecf5e61937c287f1f767c09cf3023f6c:1f7946e8f3aeb7a13db46d916c4288475c307cfe6193b6199d4dcea9dc98df522b61ae532031f6839e24df8e8d10993aeb123bb225971372a6cb666ce025fcad','active',NULL,'2026-09-17 07:06:20','2026-09-17 07:05:56',NULL,'2026-09-16 09:05:47','2026-09-17 07:06:20',NULL),
(3,2,3,'Dhea Angela (Admin HRD)','admin.hrd','admin.hrd@example.com','+6281234567802','ecf5e61937c287f1f767c09cf3023f6c:1f7946e8f3aeb7a13db46d916c4288475c307cfe6193b6199d4dcea9dc98df522b61ae532031f6839e24df8e8d10993aeb123bb225971372a6cb666ce025fcad','active',NULL,'2026-09-17 01:43:14','2026-09-16 14:29:43',NULL,'2026-09-16 09:05:47','2026-09-17 01:43:14',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-09-17  7:37:09
