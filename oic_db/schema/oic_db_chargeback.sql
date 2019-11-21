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
-- Table structure for table `chargeback`
--

DROP TABLE IF EXISTS `chargeback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chargeback` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `country` enum('Brazil','Mexico','Colombia','Chile','Peru','Paraguay','Argentina','CostaRica','Guatemala','Ecuador','DominicanRepublic','Panama','ElSalvador') DEFAULT NULL,
  `erp_clustered_chargeback_id` int(11) DEFAULT NULL,
  `erp_receipt_id` int(11) DEFAULT NULL,
  `erp_receipt_status_transaction` enum('waiting_to_be_process','clustered_chargeback_being_created','being_processed','clustered_chargeback_created','error_at_trying_to_process','created_at_erp','error_trying_to_create_at_erp') DEFAULT NULL,
  `erp_receipt_sent_to_erp_at` timestamp NULL DEFAULT NULL,
  `erp_receipt_returned_from_erp_at` timestamp NULL DEFAULT NULL,
  `erp_receivable_log` blob,
  `front_status_transaction` enum('waiting_to_be_process','error_at_trying_to_process','sent_to_front','error_trying_to_send_to_front') DEFAULT NULL,
  `front_sent_to_front_at` timestamp NULL DEFAULT NULL,
  `front_returned_from_front_at` timestamp NULL DEFAULT NULL,
  `front_log` blob,
  `chargeback_acquirer_label` varchar(45) DEFAULT NULL,
  `conciliator_id` varchar(45) NOT NULL,
  `concitiation_type` varchar(45) DEFAULT NULL,
  `conciliation_description` varchar(255) DEFAULT NULL,
  `transaction_type` enum('credit_card','debit_card') DEFAULT NULL,
  `contract_number` varchar(45) DEFAULT NULL,
  `credit_card_brand` set('mastercard','visa','americanexpress','elo','diners','hipercard') DEFAULT NULL,
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
  `billing_date` date DEFAULT NULL,
  `credit_date` date DEFAULT NULL,
  `bank_number` varchar(45) DEFAULT NULL,
  `bank_branch` varchar(45) DEFAULT NULL,
  `bank_account` varchar(45) DEFAULT NULL,
  `conciliator_filename` varchar(255) DEFAULT NULL,
  `acquirer_bank_filename` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`,`conciliator_id`),
  UNIQUE KEY `conciliator_id_UNIQUE` (`conciliator_id`),
  KEY `receivable_fk_chargeback_idx` (`conciliator_id`),
  KEY `clustered_receivable_customer_fk_chargeback_idx` (`chargeback_acquirer_label`),
  KEY `clustered_chargeback_fk_chargeback_idx` (`erp_clustered_chargeback_id`),
  CONSTRAINT `clustered_chargeback_fk_chargeback` FOREIGN KEY (`erp_clustered_chargeback_id`) REFERENCES `clustered_chargeback` (`id`),
  CONSTRAINT `clustered_receivable_customer_fk_chargeback` FOREIGN KEY (`chargeback_acquirer_label`) REFERENCES `clustered_receivable_customer` (`chargeback_acquirer_label`),
  CONSTRAINT `receivable_fk_chargeback` FOREIGN KEY (`conciliator_id`) REFERENCES `receivable` (`conciliator_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chargeback`
--

LOCK TABLES `chargeback` WRITE;
/*!40000 ALTER TABLE `chargeback` DISABLE KEYS */;
INSERT INTO `chargeback` VALUES (48,'2019-11-21 20:36:40','Brazil',10,NULL,'clustered_chargeback_created',NULL,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'CIELO','abc123','CHBK','CANCELAMENTO EFETUADO PELO PORTADOR','credit_card','1288329736','mastercard','1232****8872',1,1,'883765246',NULL,'332412',290.9,109.8,109.8,0,3.1,34.038,0,0,'2019-11-17','2019-11-29','341','1123','77662537',NULL,NULL),(49,'2019-11-21 20:36:40','Brazil',9,NULL,'clustered_chargeback_created',NULL,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'CIELO','hdjuhs123','CHBK','CANCELAMENTO EFETUADO PELO PORTADOR','credit_card','1288329736','mastercard','2134****2993',1,1,'3276518275',NULL,'332412',290.9,109.8,109.8,0,3.1,34.038,0,0,'2019-11-17','2019-11-29','341','1123','77662537',NULL,NULL),(50,'2019-11-21 20:36:40','Brazil',9,NULL,'clustered_chargeback_created',NULL,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'CIELO','hdjude123','CHBK','CANCELAMENTO EFETUADO PELO PORTADOR','credit_card','1288329736','mastercard','2154****2992',1,1,'3278628275',NULL,'332412',329,109.8,109.8,0,3.1,34.038,0,0,'2019-11-17','2019-11-29','341','1123','77662537',NULL,NULL);
/*!40000 ALTER TABLE `chargeback` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-21 18:08:38
