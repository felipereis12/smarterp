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
-- Table structure for table `clustered_receivable`
--

DROP TABLE IF EXISTS `clustered_receivable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clustered_receivable` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `country` enum('Brazil','Mexico','Colombia','Chile','Peru','Paraguay','Argentina','CostaRica','Guatemala','Ecuador','DominicanRepublic','Panama','ElSalvador') DEFAULT NULL,
  `unity_identification` varchar(45) NOT NULL,
  `erp_business_unit` varchar(45) NOT NULL,
  `erp_legal_entity` varchar(45) NOT NULL,
  `erp_subsidiary` varchar(45) NOT NULL,
  `erp_clustered_receivable_customer_id` int(11) NOT NULL,
  `contract_number` varchar(45) NOT NULL,
  `credit_card_brand` enum('mastercard','visa','americanexpress','elo','diners','hipercard') DEFAULT NULL,
  `billing_date` date NOT NULL,
  `credit_date` date NOT NULL,
  `price_list_value` float DEFAULT NULL,
  `gross_value` float NOT NULL,
  `net_value` float NOT NULL,
  `interest_value` float NOT NULL,
  `administration_tax_percentage` float NOT NULL,
  `administration_tax_value` float NOT NULL,
  `antecipation_tax_percentage` float NOT NULL,
  `antecipation_tax_value` float NOT NULL,
  `quantity_of_receivable` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=latin1 COMMENT='	';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clustered_receivable`
--

LOCK TABLES `clustered_receivable` WRITE;
/*!40000 ALTER TABLE `clustered_receivable` DISABLE KEYS */;
INSERT INTO `clustered_receivable` VALUES (197,'2019-11-21 20:23:05','Brazil','1','BR01 - SMARTFIT','07594978000178','BR010001',1452,'1288329736','mastercard','2019-10-18','2019-11-18',890.7,329.4,329.4,0,3.1,0,0,0,3),(198,'2019-11-21 20:23:05','Brazil','1','BR01 - SMARTFIT','07594978000178','BR010001',1534,'1288329725',NULL,'2019-10-18','2019-11-18',890.7,329.4,329.4,0,0,0,0,0,3),(199,'2019-11-21 20:24:12','Brazil','307','BR02 - SMARTFIN','11050377000171','BR020001',1452,'1288329736','mastercard','2019-10-17','2019-11-17',890.7,329.4,329.4,0,3.1,0,0,0,3),(200,'2019-11-21 20:24:12','Brazil','1','BR01 - SMARTFIT','07594978000178','BR010001',1684,'1288329736','mastercard','2019-10-17','2019-11-17',890.7,329.4,329.4,0,3.1,0,0,0,3);
/*!40000 ALTER TABLE `clustered_receivable` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-21 18:09:15
