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
-- Table structure for table `receivable_erp_configurations`
--

DROP TABLE IF EXISTS `receivable_erp_configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receivable_erp_configurations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `country` enum('Brazil','Mexico','Colombia','Chile','Peru','Paraguay','Argentina','CostaRica','Guatemala','Ecuador','DominicanRepublic','Panama','ElSalvador') DEFAULT NULL,
  `origin_system` enum('smartsystem','biosystem','racesystem','nossystem','corporatepass','totalpass','magento','pdv') DEFAULT NULL,
  `operation` enum('person_plan','corporate_plan','royalties','franchise_conciliator','uniform_sale_personal','uniform_sale_franchise','uniform_sale_own','product_sale','renevue','distribution') DEFAULT NULL,
  `transaction_type` enum('credit_card_recurring','debit_card_recurring','debit_account_recurring','credit_card_tef','debit_card_tef','credit_card_pos','debit_card_pos','cash','boleto','bank_transfer') DEFAULT NULL,
  `converted_smartfin` enum('yes','no') DEFAULT 'no',
  `memoline_setting` enum('gross_value','interest','administration_tax') DEFAULT NULL,
  `erp_source_name` varchar(100) DEFAULT NULL,
  `erp_type_transaction` varchar(100) DEFAULT NULL,
  `erp_payments_terms` varchar(100) DEFAULT NULL,
  `erp_currency_code` varchar(100) DEFAULT NULL,
  `erp_currency_conversion_type` varchar(100) DEFAULT NULL,
  `erp_interface_line_context` varchar(100) DEFAULT NULL,
  `erp_memo_line` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rec_unique` (`country`,`origin_system`,`operation`,`transaction_type`,`converted_smartfin`,`memoline_setting`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receivable_erp_configurations`
--

LOCK TABLES `receivable_erp_configurations` WRITE;
/*!40000 ALTER TABLE `receivable_erp_configurations` DISABLE KEYS */;
INSERT INTO `receivable_erp_configurations` VALUES (1,'2019-11-19 20:30:28','Brazil','smartsystem','person_plan','credit_card_recurring','no','gross_value','BR01_INTEGRACAO','AD_VENDA_DE_PLANO','A vista','BRL','Corporate','INTEGRACAO_AGLUTINADO','Venda de Plano'),(3,'2019-11-25 14:09:54','Brazil','smartsystem','person_plan','credit_card_recurring','yes','gross_value','BR01_INTEGRACAO','AD_REPASSE_SMARTFIN','A vista','BRL','Corporate','INTEGRACAO_AGLUTINADO','Repasse Smartfin'),(8,'2019-11-25 14:55:33','Brazil','smartsystem','person_plan','credit_card_recurring','no','administration_tax','BR01_INTEGRACAO','AD_VENDA_DE_PLANO','A vista','BRL','Corporate','INTEGRACAO_AGLUTINADO','Taxa Administracao'),(9,'2019-11-25 14:55:34','Brazil','smartsystem','person_plan','credit_card_recurring','yes','administration_tax','BR01_INTEGRACAO','AD_REPASSE_SMARTFIN','A vista','BRL','Corporate','INTEGRACAO_AGLUTINADO','Taxa Administracao'),(10,'2019-11-25 14:55:34','Brazil','smartsystem','person_plan','credit_card_recurring','no','interest','BR01_INTEGRACAO','AD_VENDA_DE_PLANO','A vista','BRL','Corporate','INTEGRACAO_AGLUTINADO','Juros/Mora'),(11,'2019-11-25 14:55:34','Brazil','smartsystem','person_plan','credit_card_recurring','yes','interest','BR01_INTEGRACAO','AD_REPASSE_SMARTFIN','A vista','BRL','Corporate','INTEGRACAO_AGLUTINADO','Juros/Mora'),(12,'2019-11-26 16:17:41','Brazil','smartsystem','franchise_conciliator','credit_card_recurring','no','gross_value','BR01_INTEGRACAO','AD_VENDA_DE_PLANO','A vista','BRL','Corporate','INTEGRACAO_CONC_FRANQUIAS','Venda de Plano'),(13,'2019-11-27 13:59:37','Brazil','smartsystem','franchise_conciliator','credit_card_recurring','no','administration_tax','BR01_INTEGRACAO','AD_VENDA_DE_PLANO','A vista','BRL','Corporate','INTEGRACAO_CONC_FRANQUIAS','Taxa Administracao'),(14,'2019-11-27 13:59:38','Brazil','smartsystem','franchise_conciliator','credit_card_recurring','no','interest','BR01_INTEGRACAO','AD_VENDA_DE_PLANO','A vista','BRL','Corporate','INTEGRACAO_CONC_FRANQUIAS','Juros/Mora');
/*!40000 ALTER TABLE `receivable_erp_configurations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-27 18:51:11
