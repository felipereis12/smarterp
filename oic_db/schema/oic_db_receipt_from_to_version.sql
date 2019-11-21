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
-- Table structure for table `receipt_from_to_version`
--

DROP TABLE IF EXISTS `receipt_from_to_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receipt_from_to_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `erp_business_unit` varchar(45) DEFAULT NULL,
  `receivable_transaction_type` enum('credit_card_recurring','debit_card_recurring','debit_account_recurring','credit_card_tef','debit_card_tef','credit_card_pos','debit_card_pos','cash','boleto','bank_transfer') DEFAULT NULL,
  `erp_receivable_customer_identification` varchar(45) DEFAULT NULL,
  `bank_number` varchar(20) DEFAULT NULL,
  `bank_branch` varchar(20) DEFAULT NULL,
  `bank_account` varchar(20) DEFAULT NULL,
  `quantity_of_days_to_due_date` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rft_fk_rftv_idx` (`erp_business_unit`,`receivable_transaction_type`,`erp_receivable_customer_identification`),
  CONSTRAINT `rft_fk_rftv` FOREIGN KEY (`erp_business_unit`, `receivable_transaction_type`, `erp_receivable_customer_identification`) REFERENCES `receipt_from_to` (`erp_business_unit`, `receivable_transaction_type`, `erp_receivable_customer_identification`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipt_from_to_version`
--

LOCK TABLES `receipt_from_to_version` WRITE;
/*!40000 ALTER TABLE `receipt_from_to_version` DISABLE KEYS */;
INSERT INTO `receipt_from_to_version` VALUES (1,'2019-11-20 20:13:06','BR01 - SMARTFIT','debit_account_recurring','60701190000104','341','5290','294601',2);
/*!40000 ALTER TABLE `receipt_from_to_version` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-21 18:09:05
