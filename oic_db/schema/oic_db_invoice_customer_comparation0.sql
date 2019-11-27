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
-- Table structure for table `invoice_customer_comparation`
--

DROP TABLE IF EXISTS `invoice_customer_comparation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_customer_comparation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `order_to_cash_id` int(11) NOT NULL,
  `country` enum('Brazil','Mexico','Colombia','Chile','Peru','Paraguay','Argentina','CostaRica','Guatemala','Ecuador','DominicanRepublic','Panama','ElSalvador') DEFAULT NULL,
  `erp_customer_id` int(11) DEFAULT NULL,
  `full_name` varchar(255) NOT NULL,
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
  `erp_filename` varchar(255) DEFAULT NULL,
  `erp_line_in_file` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `invoice_customer_comparation_unique` (`country`,`identification_financial_responsible`),
  KEY `invoice_customer_idx1` (`identification_financial_responsible`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1 COMMENT='	';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_customer_comparation`
--

LOCK TABLES `invoice_customer_comparation` WRITE;
/*!40000 ALTER TABLE `invoice_customer_comparation` DISABLE KEYS */;
INSERT INTO `invoice_customer_comparation` VALUES (14,'2019-11-13 14:51:39',241,'Brazil',NULL,'Thiago Volcov Nambara','natural_person','39367233892','1058','SP','São Paulo','Rua Manifesto','2191',NULL,'Ipiranga','04209002','11','970718989','felipe.nambara@bioritmo.com.br',NULL,NULL,'yes','no',NULL,NULL),(20,'2019-11-21 17:18:16',729,NULL,NULL,'Felipe Volcov Nambara','natural_person','39367233892','BR','SP','São Paulo','Rua Manifesto','2191',NULL,'Ipiranga','04209002','11','970718989','felipe.nambara@bioritmo.com.br',NULL,NULL,'yes','no',NULL,NULL),(21,'2019-11-21 17:18:21',729,NULL,NULL,'Felipe Volcov Nambara','natural_person','39367233892','BR','SP','São Paulo','Rua Manifesto','2191',NULL,'Ipiranga','04209002','11','970718989','felipe.nambara@bioritmo.com.br',NULL,NULL,'yes','no',NULL,NULL);
/*!40000 ALTER TABLE `invoice_customer_comparation` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-27 18:50:45
