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
-- Table structure for table `invoice_items`
--

DROP TABLE IF EXISTS `invoice_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_invoice` int(11) NOT NULL,
  `front_product_id` varchar(45) NOT NULL,
  `front_plan_id` varchar(45) NOT NULL,
  `front_addon_id` varchar(45) DEFAULT NULL,
  `erp_item_ar_id` varchar(45) DEFAULT NULL,
  `erp_gl_segment_product` varchar(45) DEFAULT NULL,
  `quantity` float DEFAULT NULL,
  `sale_price` float DEFAULT NULL,
  `list_price` float DEFAULT NULL,
  `erp_filename` varchar(255) DEFAULT NULL,
  `erp_line_in_file` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `invoice_fk_invoice_items` (`id_invoice`),
  KEY `product_from_to_version_fk_invoice_items_idx` (`front_product_id`),
  KEY `plan_from_to_version_fk_invoice_items_idx` (`front_plan_id`),
  KEY `addon_from_to_version_fk_invoice_items_idx` (`front_addon_id`),
  CONSTRAINT `addon_from_to_version_fk_invoice_items` FOREIGN KEY (`front_addon_id`) REFERENCES `addon_from_to_version` (`addon_from_to_front_addon_id`),
  CONSTRAINT `invoice_fk_invoice_items` FOREIGN KEY (`id_invoice`) REFERENCES `invoice` (`id`),
  CONSTRAINT `plan_from_to_version_fk_invoice_items` FOREIGN KEY (`front_plan_id`) REFERENCES `plan_from_to_version` (`plan_from_to_front_plan_id`),
  CONSTRAINT `product_from_to_version_fk_invoice_items` FOREIGN KEY (`front_product_id`) REFERENCES `product_from_to_version` (`product_from_to_front_product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1023 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_items`
--

LOCK TABLES `invoice_items` WRITE;
/*!40000 ALTER TABLE `invoice_items` DISABLE KEYS */;
INSERT INTO `invoice_items` VALUES (1011,'2019-11-21 20:21:46',673,'120366453','1',NULL,'1','0001',1,49.9,89.9,NULL,NULL),(1012,'2019-11-21 20:21:46',673,'120366453','1',NULL,'1','0001',1,59.9,89.9,NULL,NULL),(1013,'2019-11-21 20:21:48',674,'120366453','1',NULL,'1','0001',1,49.9,89.9,NULL,NULL),(1014,'2019-11-21 20:21:49',674,'120366453','1',NULL,'1','0001',1,59.9,89.9,NULL,NULL),(1015,'2019-11-21 20:21:51',675,'120366453','1',NULL,'1','0001',1,49.9,89.9,NULL,NULL),(1016,'2019-11-21 20:21:51',675,'120366453','1',NULL,'1','0001',1,59.9,89.9,NULL,NULL),(1017,'2019-11-21 20:21:53',676,'120366453','1',NULL,'1','0001',1,49.9,89.9,NULL,NULL),(1018,'2019-11-21 20:21:53',676,'120366453','1',NULL,'1','0001',1,59.9,89.9,NULL,NULL),(1019,'2019-11-21 20:21:55',677,'120366453','1',NULL,'1','0001',1,49.9,89.9,NULL,NULL),(1020,'2019-11-21 20:21:56',677,'120366453','1',NULL,'1','0001',1,59.9,89.9,NULL,NULL),(1021,'2019-11-21 20:21:58',678,'120366453','1',NULL,'1','0001',1,49.9,89.9,NULL,NULL),(1022,'2019-11-21 20:21:58',678,'120366453','1',NULL,'1','0001',1,59.9,89.9,NULL,NULL);
/*!40000 ALTER TABLE `invoice_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-21 18:10:03
