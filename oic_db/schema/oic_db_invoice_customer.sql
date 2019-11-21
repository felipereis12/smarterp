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
-- Table structure for table `invoice_customer`
--

DROP TABLE IF EXISTS `invoice_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `order_to_cash_id` int(11) NOT NULL,
  `country` enum('Brazil','Mexico','Colombia','Chile','Peru','Paraguay','Argentina','CostaRica','Guatemala','Ecuador','DominicanRepublic','Panama','ElSalvador') DEFAULT NULL,
  `erp_customer_id` int(11) DEFAULT NULL,
  `full_name` varchar(255) NOT NULL,
  `type_person` enum('natural_person','legal_person','foreign') DEFAULT NULL,
  `identification_financial_responsible` varchar(45) NOT NULL,
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
  UNIQUE KEY `order_to_cash_id_UNIQUE` (`order_to_cash_id`),
  KEY `order_to_cash_id_idx1` (`order_to_cash_id`),
  KEY `invoice_customer_comparation_idx1` (`erp_customer_id`,`identification_financial_responsible`),
  KEY `refund_idx` (`identification_financial_responsible`),
  CONSTRAINT `order_to_cash_fk_invoice_customer` FOREIGN KEY (`order_to_cash_id`) REFERENCES `order_to_cash` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=685 DEFAULT CHARSET=latin1 COMMENT='	';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_customer`
--

LOCK TABLES `invoice_customer` WRITE;
/*!40000 ALTER TABLE `invoice_customer` DISABLE KEYS */;
INSERT INTO `invoice_customer` VALUES (679,'2019-11-21 20:21:45',776,NULL,NULL,'Felipe Volcov Nambara','natural_person','39367233892','BR','SP','São Paulo','Rua Manifesto','2191',NULL,'Ipiranga','04209002','11','970718989','felipe.nambara@bioritmo.com.br',NULL,NULL,'yes','no',NULL,NULL),(680,'2019-11-21 20:21:47',777,NULL,NULL,'João da Silva','natural_person','80873516060','BR','SP','São Paulo','Av Ipiranga','1000',NULL,'Centro','04209002','11','970718989','felipe.nambara@bioritmo.com.br',NULL,NULL,'yes','no',NULL,NULL),(681,'2019-11-21 20:21:50',778,NULL,NULL,'Maria da Silva','natural_person','42159466034','BR','SP','São Paulo','Xpto','9876',NULL,'Itaim Bibi','04209002','11','970718989','felipe.nambara@bioritmo.com.br',NULL,NULL,'yes','no',NULL,NULL),(682,'2019-11-21 20:21:52',779,NULL,NULL,'Carol da Silva','natural_person','59061781043','BR','SP','São Paulo','Av Ipiranga','1000',NULL,'Centro','04209002','11','970718989','felipe.nambara@bioritmo.com.br',NULL,NULL,'yes','no',NULL,NULL),(683,'2019-11-21 20:21:54',780,NULL,NULL,'José da Silva','natural_person','41474280021','BR','SP','São Paulo','Av Ipiranga','1000',NULL,'Centro','04209002','11','970718989','felipe.nambara@bioritmo.com.br',NULL,NULL,'yes','no',NULL,NULL),(684,'2019-11-21 20:21:57',781,NULL,NULL,'Jesus da Silva','natural_person','14648540093','BR','SP','São Paulo','Xpto','9876',NULL,'Itaim Bibi','04209002','11','970718989','felipe.nambara@bioritmo.com.br',NULL,NULL,'yes','no',NULL,NULL);
/*!40000 ALTER TABLE `invoice_customer` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-21 18:09:52
