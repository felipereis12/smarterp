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
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `erp_supplier_id` int(11) DEFAULT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `type_person` enum('natural_person','legal_person','foreign') DEFAULT NULL,
  `identification_financial_responsible` varchar(45) DEFAULT NULL,
  `nationality_code` varchar(45) NOT NULL,
  `state` varchar(45) NOT NULL,
  `city` varchar(45) NOT NULL,
  `adress` varchar(45) DEFAULT NULL,
  `adress_number` varchar(45) DEFAULT NULL,
  `adress_complement` varchar(45) DEFAULT NULL,
  `district` varchar(45) DEFAULT NULL,
  `postal_code` varchar(45) DEFAULT NULL,
  `area_code` varchar(45) DEFAULT NULL,
  `cellphone` varchar(45) DEFAULT NULL,
  `email` varchar(45) NOT NULL,
  `state_registration` varchar(45) DEFAULT NULL,
  `federal_registration` varchar(45) DEFAULT NULL,
  `final_consumer` enum('yes','no') NOT NULL,
  `icms_contributor` enum('yes','no') NOT NULL,
  `erp_supplier_send_to_erp_at` timestamp NULL DEFAULT NULL,
  `erp_supplier_returned_from_erp_at` timestamp NULL DEFAULT NULL,
  `erp_supplier_status_transaction` enum('waiting_to_be_process','doesnt_need_to_be_process','clustered_receivable_being_created','being_processed','clustered_receivable_created','error_at_trying_to_process','created_at_erp','error_trying_to_create_at_erp') DEFAULT NULL,
  `erp_supplier_log` blob,
  `erp_filename` varchar(265) DEFAULT NULL,
  `erp_line_in_file` varchar(265) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sup_unique` (`erp_supplier_id`,`identification_financial_responsible`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
INSERT INTO `supplier` VALUES (1,'2019-11-21 18:52:01',44584,'SPCMOR3     ','legal_person','07594978000178','BR','SP','São Paulo',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'felipe.nambara@bioritmo.com.br',NULL,NULL,'yes','yes',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-21 18:08:44
