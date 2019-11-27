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
-- Table structure for table `conciliated_payed_receivable`
--

DROP TABLE IF EXISTS `conciliated_payed_receivable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conciliated_payed_receivable` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `country` enum('Brazil','Mexico','Colombia','Chile','Peru','Paraguay','Argentina','CostaRica','Guatemala','Ecuador','DominicanRepublic','Panama','ElSalvador') DEFAULT NULL,
  `erp_receipt_id` int(11) DEFAULT NULL,
  `erp_receipt_status_transaction` enum('waiting_to_be_process','error_at_trying_to_process','created_at_erp','error_trying_to_create_at_erp') DEFAULT NULL,
  `erp_receipt_sent_to_erp_at` timestamp NULL DEFAULT NULL,
  `erp_receipt_returned_from_erp_at` timestamp NULL DEFAULT NULL,
  `erp_receipt_log` blob,
  `erp_receivable_customer_id` int(11) DEFAULT NULL,
  `conciliator_id` varchar(255) NOT NULL,
  `concitiation_type` varchar(45) NOT NULL,
  `conciliation_description` varchar(255) NOT NULL,
  `transaction_type` enum('credit_card','debit_card') NOT NULL,
  `contract_number` varchar(50) NOT NULL,
  `credit_card_brand` set('mastercard','visa','americanexpress','elo','diners','hipercard') NOT NULL,
  `truncated_credit_card` varchar(45) DEFAULT NULL,
  `current_credit_card_installment` int(11) DEFAULT NULL,
  `total_credit_card_installment` int(11) DEFAULT NULL,
  `nsu` varchar(45) DEFAULT NULL,
  `authorization_code` varchar(45) DEFAULT NULL,
  `payment_lot` varchar(45) DEFAULT NULL,
  `price_list_value` float DEFAULT NULL,
  `gross_value` float DEFAULT NULL,
  `net_value` float DEFAULT NULL,
  `interest_value` float DEFAULT NULL,
  `administration_tax_percentage` float DEFAULT NULL,
  `administration_tax_value` float DEFAULT NULL,
  `antecipation_tax_percentage` float DEFAULT NULL,
  `antecipation_tax_value` float DEFAULT NULL,
  `billing_date` date NOT NULL,
  `credit_date` date NOT NULL,
  `bank_number` varchar(20) DEFAULT NULL,
  `bank_branch` varchar(20) DEFAULT NULL,
  `bank_account` varchar(20) DEFAULT NULL,
  `conciliator_filename` varchar(255) DEFAULT NULL,
  `acquirer_bank_filename` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`,`conciliator_id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `conciliator_id_UNIQUE` (`conciliator_id`),
  KEY `conciliated_payed_receivable_fk_order_to_cash_idx` (`conciliator_id`),
  CONSTRAINT `conciliated_payed_receivable_fk_order_to_cash` FOREIGN KEY (`conciliator_id`) REFERENCES `order_to_cash` (`conciliator_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conciliated_payed_receivable`
--

LOCK TABLES `conciliated_payed_receivable` WRITE;
/*!40000 ALTER TABLE `conciliated_payed_receivable` DISABLE KEYS */;
INSERT INTO `conciliated_payed_receivable` VALUES (13,'2019-11-27 21:41:57','Brazil',NULL,'waiting_to_be_process',NULL,NULL,NULL,NULL,'abc123','PCV','COMPROVANTE','credit_card','1288329736','mastercard','1232****8872',1,1,'883765246',NULL,'332412',290.9,109.8,109.8,0,3.1,34.038,0,0,'2019-10-17','2019-11-17','341','1123','77662537',NULL,NULL),(14,'2019-11-27 21:41:57','Brazil',NULL,'waiting_to_be_process',NULL,NULL,NULL,NULL,'hdjuhs123','PCV','COMPROVANTE','credit_card','1288329736','mastercard','2134****2993',1,1,'3276518275',NULL,'332412',290.8,109.8,109.8,0,3.1,34.038,0,0,'2019-10-18','2019-11-18','341','1123','77662537',NULL,NULL),(15,'2019-11-27 21:41:57','Brazil',NULL,'waiting_to_be_process',NULL,NULL,NULL,NULL,'hdjude123','PCV','COMPROVANTE','credit_card','1288329736','mastercard','2154****2992',1,1,'3278628275',NULL,'332412',329,109.8,109.8,0,3.1,34.038,0,0,'2019-10-18','2019-11-18','341','1123','77662537',NULL,NULL);
/*!40000 ALTER TABLE `conciliated_payed_receivable` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-27 18:50:40
