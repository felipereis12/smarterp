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
-- Table structure for table `payable`
--

DROP TABLE IF EXISTS `payable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payable` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `unity_identification` varchar(45) NOT NULL,
  `erp_business_unit` varchar(45) DEFAULT NULL,
  `erp_legal_entity` varchar(45) DEFAULT NULL,
  `erp_subsidiary` varchar(45) DEFAULT NULL,
  `acronym` varchar(45) DEFAULT NULL,
  `erp_payable_id` int(11) DEFAULT NULL,
  `receivable_id` int(11) DEFAULT NULL,
  `erp_receivable_id` int(11) DEFAULT NULL,
  `erp_clustered_receivable_id` int(11) DEFAULT NULL,
  `erp_payable_receipt_id` int(11) DEFAULT NULL,
  `erp_supplier_id` int(11) DEFAULT NULL,
  `supplier_identification` varchar(45) DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `erp_payable_send_to_erp_at` timestamp NULL DEFAULT NULL,
  `erp_payable_returned_from_erp_at` timestamp NULL DEFAULT NULL,
  `erp_payable_status_transaction` enum('waiting_to_be_process','doesnt_need_to_be_process','clustered_receivable_being_created','being_processed','clustered_receivable_created','error_at_trying_to_process','created_at_erp','error_trying_to_create_at_erp') DEFAULT NULL,
  `erp_payable_log` blob,
  `erp_receipt_send_to_erp_at` timestamp NULL DEFAULT NULL,
  `erp_receipt_returned_from_erp_at` timestamp NULL DEFAULT NULL,
  `erp_receipt_status_transaction` enum('waiting_to_be_process','doesnt_need_to_be_process','clustered_receivable_being_created','being_processed','clustered_receivable_created','error_at_trying_to_process','created_at_erp','error_trying_to_create_at_erp') DEFAULT NULL,
  `erp_receipt_log` blob,
  `erp_filename` varchar(265) DEFAULT NULL,
  `erp_line_in_file` varchar(265) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rec_fk_pay_idx` (`receivable_id`),
  KEY `oftv_fk_pay_idx` (`erp_business_unit`,`erp_legal_entity`,`erp_subsidiary`,`acronym`),
  KEY `sup_fk_pay_idx` (`erp_supplier_id`),
  CONSTRAINT `oftv_fk_pay` FOREIGN KEY (`erp_business_unit`, `erp_legal_entity`, `erp_subsidiary`, `acronym`) REFERENCES `organization_from_to_version` (`erp_business_unit`, `erp_legal_entity`, `erp_subsidiary`, `acronym`),
  CONSTRAINT `rec_fk_pay` FOREIGN KEY (`receivable_id`) REFERENCES `receivable` (`id`),
  CONSTRAINT `sup_fk_pay` FOREIGN KEY (`erp_supplier_id`) REFERENCES `supplier` (`erp_supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payable`
--

LOCK TABLES `payable` WRITE;
/*!40000 ALTER TABLE `payable` DISABLE KEYS */;
INSERT INTO `payable` VALUES (6,'2019-11-27 21:42:00','307','BR02 - SMARTFIN','11050377000171','BR020001','SMARTFIN    ',NULL,NULL,44,NULL,NULL,NULL,'23383105000172','2019-11-26','2019-11-28',NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL);
/*!40000 ALTER TABLE `payable` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-27 18:51:46
