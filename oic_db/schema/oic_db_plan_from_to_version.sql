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
-- Table structure for table `plan_from_to_version`
--

DROP TABLE IF EXISTS `plan_from_to_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plan_from_to_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `plan_from_to_origin_system` enum('smartsystem','biosystem','racesystem','nossystem','corporatepass','totalpass','magento','pdv','oic') DEFAULT NULL,
  `plan_from_to_front_plan_id` varchar(45) DEFAULT NULL,
  `erp_item_ar_id` varchar(45) DEFAULT NULL,
  `erp_item_ar_overdue_recovery_id` varchar(45) DEFAULT NULL,
  `erp_gl_segment_id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `plan_from_to_fk_plan_from_to_version_idx` (`plan_from_to_origin_system`,`plan_from_to_front_plan_id`),
  KEY `invoice_items_idx2` (`plan_from_to_front_plan_id`),
  CONSTRAINT `plan_from_to_fk_plan_from_to_version` FOREIGN KEY (`plan_from_to_origin_system`, `plan_from_to_front_plan_id`) REFERENCES `plan_from_to` (`origin_system`, `front_plan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plan_from_to_version`
--

LOCK TABLES `plan_from_to_version` WRITE;
/*!40000 ALTER TABLE `plan_from_to_version` DISABLE KEYS */;
INSERT INTO `plan_from_to_version` VALUES (1,'2019-11-13 18:17:38','smartsystem','1',NULL,NULL,'0001'),(2,'2019-11-13 18:17:38','smartsystem','2',NULL,NULL,'0012'),(3,'2019-11-13 18:17:38','smartsystem','3',NULL,NULL,'0010'),(4,'2019-11-13 18:17:38','smartsystem','4',NULL,NULL,'0010'),(5,'2019-11-13 18:17:38','smartsystem','5',NULL,NULL,'0010'),(6,'2019-11-13 18:17:38','smartsystem','6',NULL,NULL,'0010'),(7,'2019-11-13 18:17:38','smartsystem','10',NULL,NULL,'0010'),(8,'2019-11-13 18:17:38','smartsystem','12',NULL,NULL,'0020'),(9,'2019-11-13 18:17:38','smartsystem','20',NULL,NULL,'0010'),(10,'2019-11-13 18:17:38','smartsystem','25',NULL,NULL,'0021'),(11,'2019-11-13 18:17:38','smartsystem','26',NULL,NULL,'0021'),(12,'2019-11-13 18:17:38','smartsystem','27',NULL,NULL,'0010'),(13,'2019-11-13 18:17:38','smartsystem','28',NULL,NULL,'0010'),(14,'2019-11-13 18:17:38','smartsystem','36',NULL,NULL,'0015'),(15,'2019-11-13 18:17:38','smartsystem','41',NULL,NULL,'0024');
/*!40000 ALTER TABLE `plan_from_to_version` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-21 18:09:10
