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
-- Table structure for table `clustered_receivable_customer`
--

DROP TABLE IF EXISTS `clustered_receivable_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clustered_receivable_customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `erp_customer_id` int(11) NOT NULL,
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
  `chargeback_acquirer_label` varchar(45) DEFAULT NULL,
  `is_smartfin` enum('yes','no') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `erp_customer_id_UNIQUE` (`erp_customer_id`),
  UNIQUE KEY `identification_financial_responsible_UNIQUE` (`identification_financial_responsible`),
  UNIQUE KEY `chargeback_acquirer_label_UNIQUE` (`chargeback_acquirer_label`),
  UNIQUE KEY `is_smartfin_UNIQUE` (`is_smartfin`),
  KEY `order_to_cash_idx1` (`identification_financial_responsible`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COMMENT='		';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clustered_receivable_customer`
--

LOCK TABLES `clustered_receivable_customer` WRITE;
/*!40000 ALTER TABLE `clustered_receivable_customer` DISABLE KEYS */;
INSERT INTO `clustered_receivable_customer` VALUES (1,'2019-10-17 19:40:38',1452,'CIELO S.A.','legal_person','01027058000191','1058','SP','São Paulo','AV JUSCELINO KUBITSCHEK','1830',' TORRE I 9AN','Itaim Bibi','04543900','11','34571352','felipe.nambara@bioritmo.com.br','','','no','yes','CIELO',NULL),(2,'2019-10-18 16:29:49',1534,'BANCO ITAU SA','legal_person','60701190000104','1058','SP','São Paulo','PC ALFREDO EGYDIO DE SOUZA ARANHA','100',NULL,'Pq Jabaquara','04344030','11','970718989','felipe.nambara@bioritmo.com.br',NULL,NULL,'no','yes','ITAU',NULL),(3,'2019-11-14 21:37:42',1684,'SMARTFIN COBRANCAS LTDA','legal_person','11050377000171','1058','SP','São Paulo','AV PAULISTA','1294',NULL,'Bela Vista','01310100','11',NULL,'felipe.nambara@bioritmo.com.br',NULL,NULL,'no','yes','SMARTFIN','yes');
/*!40000 ALTER TABLE `clustered_receivable_customer` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-21 18:09:47
