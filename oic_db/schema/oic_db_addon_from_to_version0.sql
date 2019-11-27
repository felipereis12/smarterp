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
-- Table structure for table `addon_from_to_version`
--

DROP TABLE IF EXISTS `addon_from_to_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addon_from_to_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `country` enum('Brazil','Mexico','Colombia','Chile','Peru','Paraguay','Argentina','CostaRica','Guatemala','Ecuador','DominicanRepublic','Panama','ElSalvador') DEFAULT NULL,
  `addon_from_to_origin_system` enum('smartsystem','biosystem','racesystem','nossystem','corporatepass','totalpass','magento','pdv','oic') DEFAULT NULL,
  `addon_from_to_operation` enum('person_plan','corporate_plan','royalties','franchise_conciliator','uniform_sale_personal','uniform_sale_franchise','uniform_sale_own','product_sale','renevue','distribution') DEFAULT NULL,
  `addon_from_to_front_addon_id` varchar(45) DEFAULT NULL,
  `erp_item_ar_id` varchar(45) DEFAULT NULL,
  `erp_item_ar_overdue_recovery_id` varchar(45) DEFAULT NULL,
  `erp_gl_segment_id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `addon_fromt_to_fk_addon_from_to_version_idx` (`addon_from_to_origin_system`,`addon_from_to_front_addon_id`),
  KEY `invoice_items_idx3` (`addon_from_to_front_addon_id`),
  CONSTRAINT `addon_fromt_to_fk_addon_from_to_version` FOREIGN KEY (`addon_from_to_origin_system`, `addon_from_to_front_addon_id`) REFERENCES `addon_from_to` (`origin_system`, `front_addon_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addon_from_to_version`
--

LOCK TABLES `addon_from_to_version` WRITE;
/*!40000 ALTER TABLE `addon_from_to_version` DISABLE KEYS */;
INSERT INTO `addon_from_to_version` VALUES (1,'2019-11-13 18:16:03','Brazil','smartsystem','person_plan','1','100','500','0021'),(2,'2019-11-13 18:16:03','Brazil','smartsystem','person_plan','2','100','500','0023'),(3,'2019-11-13 18:16:03','Brazil','smartsystem','person_plan','3','100','500','0022'),(4,'2019-11-13 18:16:03','Brazil','smartsystem','person_plan','4','100','500','0010'),(5,'2019-11-13 18:16:03','Brazil','smartsystem','person_plan','5','100','500','0010');
/*!40000 ALTER TABLE `addon_from_to_version` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-27 18:50:10
