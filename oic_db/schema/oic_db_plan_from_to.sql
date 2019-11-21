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
-- Table structure for table `plan_from_to`
--

DROP TABLE IF EXISTS `plan_from_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plan_from_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `origin_system` enum('smartsystem','biosystem','racesystem','nossystem','corporatepass','totalpass','magento','pdv','oic') DEFAULT NULL,
  `front_plan_id` varchar(45) DEFAULT NULL,
  `front_plan_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plan_from_to_unique` (`origin_system`,`front_plan_id`),
  KEY `plan_from_to_version_idx1` (`origin_system`,`front_plan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plan_from_to`
--

LOCK TABLES `plan_from_to` WRITE;
/*!40000 ALTER TABLE `plan_from_to` DISABLE KEYS */;
INSERT INTO `plan_from_to` VALUES (1,'2019-11-13 18:11:05','smartsystem','1','Smart'),(2,'2019-11-13 18:11:05','smartsystem','2','Black'),(3,'2019-11-13 18:11:05','smartsystem','3','Personal 1'),(4,'2019-11-13 18:11:05','smartsystem','4','Personal 2'),(5,'2019-11-13 18:11:05','smartsystem','5','Personal 3'),(6,'2019-11-13 18:11:05','smartsystem','6','Personal Interno'),(7,'2019-11-13 18:11:05','smartsystem','10','Personal Externo'),(8,'2019-11-13 18:11:05','smartsystem','12','Simple'),(9,'2019-11-13 18:11:05','smartsystem','20','Personal Externo 2'),(10,'2019-11-13 18:11:05','smartsystem','25','Smart Drinks'),(11,'2019-11-13 18:11:05','smartsystem','26','Black Drinks'),(12,'2019-11-13 18:11:05','smartsystem','27','Personal Interno Black'),(13,'2019-11-13 18:11:05','smartsystem','28','Personal Externo Black'),(14,'2019-11-13 18:11:05','smartsystem','36','Passe Diário'),(15,'2019-11-13 18:11:05','smartsystem','41','Studio');
/*!40000 ALTER TABLE `plan_from_to` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-21 18:08:23
