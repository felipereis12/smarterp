CREATE DATABASE  IF NOT EXISTS `oic_db` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `oic_db`;
-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: oic-db.cluster-cgzshounia8v.us-east-1.rds.amazonaws.com    Database: oic_db
-- ------------------------------------------------------
-- Server version	5.6.10

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
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `order_to_cash_id` int(11) NOT NULL,
  `erp_invoice_id` int(11) DEFAULT NULL,
  `erp_invoice_customer_id` int(11) DEFAULT NULL,
  `transaction_type` enum('invoice_to_financial_responsible','invoice_to_other_company','invoice_intercompany') NOT NULL,
  `is_overdue_recovery` enum('yes','no') DEFAULT NULL,
  `fiscal_id` varchar(255) DEFAULT NULL,
  `fiscal_series` varchar(10) DEFAULT NULL,
  `fiscal_authentication_code` varchar(255) DEFAULT NULL,
  `fiscal_model` enum('nfe','nfse','nfce') DEFAULT NULL,
  `fiscal_authorization_datetime` varchar(20) DEFAULT NULL,
  `erp_filename` varchar(255) DEFAULT NULL,
  `erp_line_in_file` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `order_to_cash_id_UNIQUE` (`order_to_cash_id`),
  KEY `order_to_cash_id_idx1` (`order_to_cash_id`),
  CONSTRAINT `order_to_cash_fk_invoice` FOREIGN KEY (`order_to_cash_id`) REFERENCES `order_to_cash` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=679 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
INSERT INTO `invoice` VALUES (673,'2019-11-21 20:21:46',776,NULL,NULL,'invoice_to_financial_responsible','no',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(674,'2019-11-21 20:21:48',777,NULL,NULL,'invoice_to_financial_responsible','no',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(675,'2019-11-21 20:21:50',778,NULL,NULL,'invoice_to_financial_responsible','no',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(676,'2019-11-21 20:21:53',779,NULL,NULL,'invoice_to_financial_responsible','no',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(677,'2019-11-21 20:21:55',780,NULL,NULL,'invoice_to_financial_responsible','no',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(678,'2019-11-21 20:21:57',781,NULL,NULL,'invoice_to_financial_responsible','no',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `invoice` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-21 18:08:07
