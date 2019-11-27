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
-- Table structure for table `product_from_to`
--

DROP TABLE IF EXISTS `product_from_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_from_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `country` enum('Brazil','Mexico','Colombia','Chile','Peru','Paraguay','Argentina','CostaRica','Guatemala','Ecuador','DominicanRepublic','Panama','ElSalvador') DEFAULT NULL,
  `origin_system` enum('smartsystem','biosystem','racesystem','nossystem','corporatepass','totalpass','magento','pdv','oic') DEFAULT NULL,
  `operation` enum('person_plan','corporate_plan','royalties','franchise_conciliator','uniform_sale_personal','uniform_sale_franchise','uniform_sale_own','product_sale','renevue','distribution') DEFAULT NULL,
  `front_product_id` varchar(45) NOT NULL,
  `front_product_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `product_from_to_unique` (`origin_system`,`front_product_id`),
  KEY `prodcut_from_to_version_idx1` (`origin_system`,`front_product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_from_to`
--

LOCK TABLES `product_from_to` WRITE;
/*!40000 ALTER TABLE `product_from_to` DISABLE KEYS */;
INSERT INTO `product_from_to` VALUES (130,'2019-11-04 22:20:39','Brazil','smartsystem','person_plan','120366453','Manutenção Anual'),(131,'2019-11-04 22:20:39','Brazil','smartsystem','person_plan','676890257','Taxa de adesão'),(132,'2019-11-04 22:20:39','Brazil','smartsystem','person_plan','1002991765','Multa'),(133,'2019-11-04 22:20:39','Brazil','smartsystem','person_plan','1002991766','Manutenção Anual'),(134,'2019-11-04 22:20:39','Brazil','smartsystem','person_plan','1002991767','Segunda via blackcard'),(135,'2019-11-04 22:20:39','Brazil','smartsystem','person_plan','1002991768','Cobrança atrasada'),(136,'2019-11-04 22:20:40','Brazil','smartsystem','person_plan','1002991770','Pagamento em Boleto'),(137,'2019-11-04 22:20:40','Brazil','smartsystem','person_plan','1002991771','Mensalidade Black'),(138,'2019-11-04 22:20:40','Brazil','smartsystem','person_plan','1002991772','Mensalidade Smart'),(139,'2019-11-04 22:20:40','Brazil','smartsystem','person_plan','1002991773','Avaliação Médica'),(140,'2019-11-04 22:20:40','Brazil','smartsystem','person_plan','1002991774','Mensalidade simple'),(141,'2019-11-04 22:20:40','Brazil','smartsystem','person_plan','1002991775','Contestacao'),(142,'2019-11-04 22:20:40','Brazil','smartsystem','person_plan','1002991776','Acerto de pendência via TEF'),(143,'2019-11-04 22:20:41','Brazil','smartsystem','person_plan','1002991769','Convite Festa'),(144,'2019-11-04 22:20:41','Brazil','smartsystem','person_plan','1002991777','Plano Anual'),(145,'2019-11-04 22:20:41','Brazil','smartsystem','person_plan','1002991778','Ponerse al día - Datáfono'),(146,'2019-11-04 22:20:41','Brazil','smartsystem','person_plan','1002991779','Pagamento de dívida através de POS'),(147,'2019-11-04 22:20:41','Brazil','smartsystem','person_plan','1002991780','Pagamento de dívida através do TOTEM'),(148,'2019-11-04 22:20:41','Brazil','smartsystem','person_plan','1002991783','Pagamento de divida atráves do espaço do aluno'),(149,'2019-11-04 22:20:41','Brazil','smartsystem','person_plan','1002991784','Smart Fit Body'),(150,'2019-11-04 22:20:42','Brazil','smartsystem','person_plan','1002991785','Mensalidade Studio'),(151,'2019-11-04 22:20:42','Brazil','smartsystem','person_plan','1002991786','Manutenção Anual (Studio)'),(152,'2019-11-04 22:20:42','Brazil','smartsystem','person_plan','1002991787','Pagamento via Carteira Digital'),(153,'2019-11-22 18:50:12','Brazil','magento','uniform_sale_own','120366453','Uniforme Calça Preta Personal'),(154,'2019-11-27 20:15:08','Brazil','corporatepass','distribution','5554845','Repasse CorporatePass');
/*!40000 ALTER TABLE `product_from_to` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-27 18:49:59
