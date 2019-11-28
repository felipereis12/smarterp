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
-- Table structure for table `order_to_cash`
--

DROP TABLE IF EXISTS `order_to_cash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_to_cash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `order_to_cash_id_smartfin` int(11) DEFAULT NULL,
  `country` enum('Brazil','Mexico','Colombia','Chile','Peru','Paraguay','Argentina','CostaRica','Guatemala','Ecuador','DominicanRepublic','Panama','ElSalvador') NOT NULL,
  `unity_identification` varchar(45) NOT NULL,
  `erp_business_unit` varchar(45) DEFAULT NULL,
  `erp_legal_entity` varchar(45) DEFAULT NULL,
  `erp_subsidiary` varchar(45) DEFAULT NULL,
  `acronym` varchar(45) DEFAULT NULL,
  `to_generate_customer` enum('yes','no') DEFAULT NULL,
  `to_generate_receivable` enum('yes','no') DEFAULT NULL,
  `to_generate_invoice` enum('yes','no') DEFAULT NULL,
  `origin_system` enum('smartsystem','biosystem','racesystem','nossystem','corporatepass','totalpass','magento','pdv','oic') NOT NULL,
  `operation` enum('person_plan','corporate_plan','royalties','franchise_conciliator','uniform_sale_personal','uniform_sale_franchise','uniform_sale_own','product_sale','revenue','distribution') NOT NULL,
  `minifactu_id` int(11) DEFAULT NULL,
  `conciliator_id` varchar(100) DEFAULT NULL,
  `fin_id` int(11) DEFAULT NULL,
  `front_id` int(11) NOT NULL,
  `erp_invoice_customer_send_to_erp_at` timestamp NULL DEFAULT NULL,
  `erp_invoice_customer_returned_from_erp_at` timestamp NULL DEFAULT NULL,
  `erp_invoice_customer_status_transaction` enum('waiting_to_be_process','doesnt_need_to_be_process','being_processed','created_at_erp','error_trying_to_create_at_erp') NOT NULL,
  `erp_invoice_customer_log` blob,
  `erp_receivable_sent_to_erp_at` timestamp NULL DEFAULT NULL,
  `erp_receivable_returned_from_erp_at` timestamp NULL DEFAULT NULL,
  `erp_receivable_customer_identification` varchar(45) DEFAULT NULL,
  `erp_receivable_status_transaction` enum('waiting_to_be_process','doesnt_need_to_be_process','clustered_receivable_being_created','being_processed','clustered_receivable_created','error_at_trying_to_process','created_at_erp','error_trying_to_create_at_erp','payable_created_at_oic_db') NOT NULL,
  `erp_receivable_log` blob,
  `erp_invoice_send_to_erp_at` timestamp NULL DEFAULT NULL,
  `erp_invoice_returned_from_erp_at` timestamp NULL DEFAULT NULL,
  `erp_invoice_status_transaction` enum('waiting_to_be_process','doesnt_need_to_be_process','being_processed','created_at_erp','error_trying_to_create_at_erp','fiscal_authorized') NOT NULL,
  `erp_invoice_log` blob,
  `erp_receipt_send_to_erp_at` timestamp NULL DEFAULT NULL,
  `erp_receipt_returned_from_erp_at` timestamp NULL DEFAULT NULL,
  `erp_receipt_status_transaction` enum('waiting_to_be_process','doesnt_need_to_be_process','clustered_receivable_being_created','being_processed','clustered_receivable_created','error_at_trying_to_process','created_at_erp','error_trying_to_create_at_erp') DEFAULT NULL,
  `erp_receipt_log` blob,
  PRIMARY KEY (`id`),
  UNIQUE KEY `created_at_UNIQUE` (`created_at`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `organization_from_to_idx1` (`unity_identification`),
  KEY `clustered_receivable_customer_idx1` (`erp_receivable_customer_identification`),
  KEY `concliated_payed_receivable_idx1` (`conciliator_id`),
  KEY `organization_from_to_version_fk_order_to_cash_idx` (`erp_business_unit`,`erp_legal_entity`,`erp_subsidiary`,`acronym`),
  KEY `receivable_fk_order_to_cash` (`conciliator_id`),
  KEY `refund_items_fk_order_to_cash_idx` (`front_id`),
  CONSTRAINT `clustered_receivable_customer_fk_order_to_cash` FOREIGN KEY (`erp_receivable_customer_identification`) REFERENCES `clustered_receivable_customer` (`identification_financial_responsible`),
  CONSTRAINT `organization_from_to_fk_order_to_cash` FOREIGN KEY (`unity_identification`) REFERENCES `organization_from_to` (`unity_identification`),
  CONSTRAINT `organization_from_to_version_fk_order_to_cash` FOREIGN KEY (`erp_business_unit`, `erp_legal_entity`, `erp_subsidiary`, `acronym`) REFERENCES `organization_from_to_version` (`erp_business_unit`, `erp_legal_entity`, `erp_subsidiary`, `acronym`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=latin1 COMMENT='	';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_to_cash`
--

LOCK TABLES `order_to_cash` WRITE;
/*!40000 ALTER TABLE `order_to_cash` DISABLE KEYS */;
INSERT INTO `order_to_cash` VALUES (42,'2019-11-27 21:41:44',NULL,'Brazil','1','BR01 - SMARTFIT','07594978000178','BR010001','SPCMOR3     ','yes','yes','yes','smartsystem','person_plan',1,'abc123',2,99877897,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'01027058000191','waiting_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL),(43,'2019-11-27 21:41:46',NULL,'Brazil','1','BR01 - SMARTFIT','07594978000178','BR010001','SPCMOR3     ','yes','yes','yes','smartsystem','person_plan',2,'xyz123',3,99872631,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'60701190000104','waiting_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL),(44,'2019-11-27 21:41:48',NULL,'Brazil','1','BR01 - SMARTFIT','07594978000178','BR010001','SPCMOR3     ','yes','yes','yes','smartsystem','person_plan',3,'hdjuhs123',4,99872644,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'01027058000191','waiting_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL),(45,'2019-11-27 21:41:50',NULL,'Brazil','1','BR01 - SMARTFIT','07594978000178','BR010001','SPCMOR3     ','yes','yes','yes','smartsystem','person_plan',4,'yytre123',5,93472631,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'60701190000104','waiting_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL),(46,'2019-11-27 21:41:52',NULL,'Brazil','1','BR01 - SMARTFIT','07594978000178','BR010001','SPCMOR3     ','yes','yes','yes','smartsystem','person_plan',5,'yytre383',6,93474331,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'60701190000104','waiting_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL),(47,'2019-11-27 21:41:54',NULL,'Brazil','1','BR01 - SMARTFIT','07594978000178','BR010001','SPCMOR3     ','yes','yes','yes','smartsystem','person_plan',7,'hdjude123',10,91334244,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'01027058000191','waiting_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL),(48,'2019-11-27 21:41:58',NULL,'Brazil','1','BR01 - SMARTFIT','07594978000178','BR010001','SPCMOR3     ','no','no','yes','magento','uniform_sale_own',NULL,NULL,NULL,11548,NULL,NULL,'doesnt_need_to_be_process',NULL,NULL,NULL,NULL,'doesnt_need_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,'doesnt_need_to_be_process',NULL),(49,'2019-11-27 21:41:59',NULL,'Brazil','307','BR02 - SMARTFIN','11050377000171','BR020001','SMARTFIN    ','no','yes','no','smartsystem','franchise_conciliator',NULL,NULL,NULL,115485,NULL,NULL,'doesnt_need_to_be_process',NULL,NULL,NULL,'01027058000191','waiting_to_be_process',NULL,NULL,NULL,'doesnt_need_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL),(50,'2019-11-27 21:42:01',NULL,'Brazil','1','BR01 - SMARTFIT','07594978000178','BR010001','SPCMOR3     ','no','no','yes','corporatepass','distribution',NULL,NULL,NULL,115458,NULL,NULL,'doesnt_need_to_be_process',NULL,NULL,NULL,'07594978014128','doesnt_need_to_be_process',NULL,NULL,NULL,'waiting_to_be_process',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `order_to_cash` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-27 18:52:25
