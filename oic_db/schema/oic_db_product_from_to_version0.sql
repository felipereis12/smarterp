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
-- Table structure for table `product_from_to_version`
--

DROP TABLE IF EXISTS `product_from_to_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_from_to_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `country` enum('Brazil','Mexico','Colombia','Chile','Peru','Paraguay','Argentina','CostaRica','Guatemala','Ecuador','DominicanRepublic','Panama','ElSalvador') DEFAULT NULL,
  `product_from_to_origin_system` enum('smartsystem','biosystem','racesystem','nossystem','corporatepass','totalpass','magento','pdv','oic') DEFAULT NULL,
  `product_from_to_operation` enum('person_plan','corporate_plan','royalties','franchise_conciliator','uniform_sale_personal','uniform_sale_franchise','uniform_sale_own','product_sale','revenue','distribution') DEFAULT NULL,
  `product_from_to_front_product_id` varchar(45) NOT NULL,
  `erp_item_ar_id` varchar(45) NOT NULL,
  `erp_item_ar_overdue_recovery_id` varchar(45) DEFAULT NULL,
  `erp_item_ar_discount_id` varchar(45) DEFAULT NULL,
  `erp_gl_segment_id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `invoice_items_idx` (`product_from_to_front_product_id`),
  KEY `product_from_to_fk_product_from_to_version_idx1` (`product_from_to_origin_system`,`product_from_to_front_product_id`),
  CONSTRAINT `product_from_to_fk_product_from_to_version` FOREIGN KEY (`product_from_to_origin_system`, `product_from_to_front_product_id`) REFERENCES `product_from_to` (`origin_system`, `front_product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_from_to_version`
--

LOCK TABLES `product_from_to_version` WRITE;
/*!40000 ALTER TABLE `product_from_to_version` DISABLE KEYS */;
INSERT INTO `product_from_to_version` VALUES (5,'2019-11-04 22:43:29','Brazil','smartsystem','person_plan','120366453','1','100','500',NULL),(6,'2019-11-04 22:43:29','Brazil','smartsystem','person_plan','676890257','2','101','501',NULL),(7,'2019-11-04 22:43:29','Brazil','smartsystem','person_plan','1002991765','3','102','502',NULL),(8,'2019-11-04 22:43:29','Brazil','smartsystem','person_plan','1002991766','4','103','503',NULL),(9,'2019-11-04 22:43:29','Brazil','smartsystem','person_plan','1002991767','5','104','504',NULL),(10,'2019-11-04 22:43:29','Brazil','smartsystem','person_plan','1002991768','6','105','505',NULL),(11,'2019-11-04 22:43:29','Brazil','smartsystem','person_plan','1002991770','7','106','506',NULL),(12,'2019-11-04 22:43:30','Brazil','smartsystem','person_plan','1002991771','8','107','507',NULL),(13,'2019-11-04 22:43:30','Brazil','smartsystem','person_plan','1002991772','9','108','508',NULL),(14,'2019-11-04 22:43:30','Brazil','smartsystem','person_plan','1002991773','10','109','509',NULL),(15,'2019-11-04 22:43:30','Brazil','smartsystem','person_plan','1002991774','11','110','510',NULL),(16,'2019-11-04 22:43:30','Brazil','smartsystem','person_plan','1002991775','12','111','511',NULL),(17,'2019-11-04 22:43:30','Brazil','smartsystem','person_plan','1002991776','13','112','512',NULL),(18,'2019-11-04 22:43:31','Brazil','smartsystem','person_plan','1002991769','14','113','513',NULL),(19,'2019-11-04 22:43:31','Brazil','smartsystem','person_plan','1002991777','15','114','514',NULL),(20,'2019-11-04 22:43:31','Brazil','smartsystem','person_plan','1002991778','16','115','515',NULL),(21,'2019-11-04 22:43:31','Brazil','smartsystem','person_plan','1002991779','17','116','516',NULL),(22,'2019-11-04 22:43:31','Brazil','smartsystem','person_plan','1002991780','18','117','517',NULL),(23,'2019-11-04 22:43:31','Brazil','smartsystem','person_plan','1002991783','19','118','518',NULL),(24,'2019-11-04 22:43:31','Brazil','smartsystem','person_plan','1002991784','20','119','519',NULL),(25,'2019-11-04 22:43:32','Brazil','smartsystem','person_plan','1002991785','21','120','520',NULL),(26,'2019-11-04 22:43:32','Brazil','smartsystem','person_plan','1002991786','22','121','521',NULL),(27,'2019-11-04 22:43:32','Brazil','smartsystem','person_plan','1002991787','23','122','522',NULL),(28,'2019-11-22 18:50:57','Brazil','magento','uniform_sale_own','120366453','28','150','200','0001'),(29,'2019-11-27 20:23:10','Brazil','corporatepass','distribution','5554845','55','155','500','0010');
/*!40000 ALTER TABLE `product_from_to_version` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-27 18:52:21
