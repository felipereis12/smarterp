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
-- Table structure for table `refund`
--

DROP TABLE IF EXISTS `refund`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refund` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `country` varchar(45) DEFAULT NULL,
  `unity_identification` varchar(45) DEFAULT NULL,
  `erp_business_unit` varchar(45) DEFAULT NULL,
  `erp_legal_entity` varchar(45) DEFAULT NULL,
  `erp_subsidiary` varchar(45) DEFAULT NULL,
  `acronym` varchar(45) DEFAULT NULL,
  `erp_refund_status_transaction` enum('waiting_to_be_process','error_at_trying_to_process','created_at_erp','error_trying_to_create_at_erp') DEFAULT NULL,
  `erp_refund_sent_to_erp_at` timestamp NULL DEFAULT NULL,
  `erp_refund_returned_from_erp_at` timestamp NULL DEFAULT NULL,
  `erp_refund_log` blob,
  `refund_requester_name` varchar(255) DEFAULT NULL,
  `refund_requester_identification` varchar(45) DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `erp_refund_id` int(11) DEFAULT NULL,
  `front_refund_id` int(11) DEFAULT NULL,
  `refund_value` float DEFAULT NULL,
  `bank_number` varchar(45) DEFAULT NULL,
  `bank_branch` varchar(45) DEFAULT NULL,
  `bank_branch_digit` varchar(45) DEFAULT NULL,
  `bank_account_number` varchar(45) DEFAULT NULL,
  `bank_account_number_digit` varchar(45) DEFAULT NULL,
  `bank_account_owner_name` varchar(255) DEFAULT NULL,
  `bank_account_owner_identification` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `organization_from_to_fk_refund_idx` (`unity_identification`),
  KEY `organization_from_to_version_fk_refund_idx` (`erp_business_unit`,`erp_legal_entity`,`erp_subsidiary`,`acronym`),
  KEY `invoice_customer_fk_refund_idx` (`refund_requester_identification`),
  KEY `refund_item_fk_refund_idx` (`front_refund_id`),
  KEY `refund_fk_refund_item_idx` (`erp_refund_id`),
  CONSTRAINT `invoice_customer_fk_refund` FOREIGN KEY (`refund_requester_identification`) REFERENCES `invoice_customer` (`identification_financial_responsible`),
  CONSTRAINT `organization_from_to_fk_refund` FOREIGN KEY (`unity_identification`) REFERENCES `organization_from_to` (`unity_identification`),
  CONSTRAINT `organization_from_to_version_fk_refund` FOREIGN KEY (`erp_business_unit`, `erp_legal_entity`, `erp_subsidiary`, `acronym`) REFERENCES `organization_from_to_version` (`erp_business_unit`, `erp_legal_entity`, `erp_subsidiary`, `acronym`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `refund_fk_refund_item` FOREIGN KEY (`erp_refund_id`) REFERENCES `refund` (`front_refund_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refund`
--

LOCK TABLES `refund` WRITE;
/*!40000 ALTER TABLE `refund` DISABLE KEYS */;
INSERT INTO `refund` VALUES (5,'2019-11-27 21:41:56','Brazil','1','BR01 - SMARTFIT','07594978000178','BR010001','SPCMOR3','waiting_to_be_process',NULL,NULL,NULL,'Felipe Volcov Nambara','39367233892','2019-11-19','2019-11-20',NULL,1546,150.85,'341','3150','1','11542','0','Felipe Volcov Nambara','39367233892');
/*!40000 ALTER TABLE `refund` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-27 18:49:49
