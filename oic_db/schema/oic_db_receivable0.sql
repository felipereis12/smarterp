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
-- Table structure for table `receivable`
--

DROP TABLE IF EXISTS `receivable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receivable` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `order_to_cash_id` int(11) NOT NULL,
  `erp_receivable_id` int(11) DEFAULT NULL,
  `erp_receipt_id` int(11) DEFAULT NULL,
  `erp_receivable_customer_id` int(11) DEFAULT NULL,
  `erp_clustered_receivable_id` int(11) DEFAULT NULL,
  `erp_clustered_receivable_customer_id` int(11) DEFAULT NULL,
  `is_smartfin` enum('yes','no') DEFAULT NULL,
  `converted_smartfin` enum('yes','no') DEFAULT 'no',
  `type_smartfin` enum('own','franchise') DEFAULT NULL,
  `receivable_id_smartfin` int(11) DEFAULT NULL,
  `ecommerce_payment_terms` varchar(45) DEFAULT NULL,
  `erp_payment_terms` varchar(45) DEFAULT NULL,
  `conciliator_id` varchar(45) DEFAULT NULL,
  `transaction_type` enum('credit_card_recurring','debit_card_recurring','debit_account_recurring','credit_card_tef','debit_card_tef','credit_card_pos','debit_card_pos','cash','boleto','bank_transfer','online_credit_card','online_debit_card') DEFAULT NULL,
  `contract_number` varchar(45) DEFAULT NULL,
  `credit_card_brand` enum('MASTER','VISA','americanexpress','elo','diners','hipercard') DEFAULT NULL,
  `truncated_credit_card` varchar(45) DEFAULT NULL,
  `current_credit_card_installment` int(11) DEFAULT NULL,
  `total_credit_card_installment` int(11) DEFAULT NULL,
  `nsu` varchar(45) DEFAULT NULL,
  `authorization_code` varchar(45) DEFAULT NULL,
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
  `conciliator_filename` varchar(255) DEFAULT NULL,
  `acquirer_bank_filename` varchar(255) DEFAULT NULL,
  `registration_gym_student` varchar(255) DEFAULT NULL,
  `fullname_gym_student` varchar(255) DEFAULT NULL,
  `identification_gym_student` varchar(255) DEFAULT NULL,
  `erp_filename` varchar(265) DEFAULT NULL,
  `erp_line_in_file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_to_cash_id_UNIQUE` (`order_to_cash_id`),
  KEY `order_to_cash_id_idx1` (`order_to_cash_id`),
  KEY `order_to_cash_2_fk_idx` (`conciliator_id`),
  KEY `ptft_fk_rec_idx` (`ecommerce_payment_terms`),
  KEY `ptftv_fk_rec_idx` (`erp_payment_terms`),
  CONSTRAINT `order_to_cash_fk` FOREIGN KEY (`order_to_cash_id`) REFERENCES `order_to_cash` (`id`),
  CONSTRAINT `ptftv_fk_rec` FOREIGN KEY (`erp_payment_terms`) REFERENCES `payment_terms_from_to_version` (`erp_payment_terms`),
  CONSTRAINT `ptft_fk_rec` FOREIGN KEY (`ecommerce_payment_terms`) REFERENCES `payment_terms_from_to` (`ecommerce_payment_terms`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receivable`
--

LOCK TABLES `receivable` WRITE;
/*!40000 ALTER TABLE `receivable` DISABLE KEYS */;
INSERT INTO `receivable` VALUES (37,'2019-11-27 21:41:44',42,NULL,NULL,1452,NULL,1452,'yes','no',NULL,NULL,NULL,NULL,'abc123','credit_card_recurring','1288329736','MASTER','1232****8872',1,1,'883765246',NULL,290.9,109.8,109.8,1.5,3.1,3.4038,0,0,'2019-10-17','2019-11-17',NULL,NULL,'12321322','Felipe Volcov Nambara','39367233892',NULL,NULL),(38,'2019-11-27 21:41:46',43,NULL,NULL,1534,NULL,1534,'no','no',NULL,NULL,NULL,NULL,'xyz123','debit_account_recurring','1288329725',NULL,NULL,1,1,NULL,'3277618275',290.9,109.8,109.8,0,0,0,0,0,'2019-10-18','2019-11-18',NULL,NULL,'12321355','João da Silva','80873516060',NULL,NULL),(39,'2019-11-27 21:41:49',44,NULL,NULL,1452,NULL,1452,'no','no',NULL,NULL,NULL,NULL,'hdjuhs123','credit_card_recurring','1288329736','MASTER','2134****2993',1,1,'3276518275',NULL,290.8,109.8,109.8,0,3.1,3.4038,0,0,'2019-10-18','2019-11-18',NULL,NULL,'12321355','João da Silva','80873516060',NULL,NULL),(40,'2019-11-27 21:41:51',45,NULL,NULL,1534,NULL,1534,'no','no',NULL,NULL,NULL,NULL,'yytre123','debit_account_recurring','1288329725',NULL,NULL,1,1,NULL,'3277618273',299.9,109.8,109.8,0,0,0,0,0,'2019-10-18','2019-11-18',NULL,NULL,'12321355','João da Silva','80873516060',NULL,NULL),(41,'2019-11-27 21:41:53',46,NULL,NULL,1534,NULL,1534,'no','no',NULL,NULL,NULL,NULL,'yytre383','debit_account_recurring','1288329725',NULL,NULL,1,1,NULL,'3277623173',299.9,109.8,109.8,0,0,0,0,0,'2019-10-18','2019-11-18',NULL,NULL,'12321355','João da Silva','80873516060',NULL,NULL),(42,'2019-11-27 21:41:55',47,NULL,NULL,1452,NULL,1452,'no','no',NULL,NULL,NULL,NULL,'hdjude123','credit_card_recurring','1288329736','MASTER','2154****2992',1,1,'3278628275',NULL,329,109.8,109.8,0,3.1,3.4038,0,0,'2019-10-18','2019-11-18',NULL,NULL,'12321355','João da Silva','80873516060',NULL,NULL),(43,'2019-11-27 21:41:58',48,NULL,NULL,NULL,NULL,NULL,'no','no',NULL,NULL,'xpto1','abc1',NULL,'online_credit_card','123458','MASTER','4458',1,3,'11545','55484',100.15,100.15,100.15,0,0,0,0,0,'2019-11-22','2019-12-22',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(44,'2019-11-27 21:42:00',49,NULL,NULL,1452,NULL,1452,'yes','no','franchise',NULL,NULL,NULL,NULL,'credit_card_recurring',NULL,'MASTER',NULL,1,1,NULL,NULL,15545.5,15545.5,15545.5,0,0,0,0,0,'2019-11-26','2019-11-28',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `receivable` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-27 18:50:30
