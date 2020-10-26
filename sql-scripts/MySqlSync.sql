CREATE DATABASE  IF NOT EXISTS `MySqlSync` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `MySqlSync`;
-- MySQL dump 10.13  Distrib 8.0.22, for Linux (x86_64)
--
-- Host: localhost    Database: MySqlSync
-- ------------------------------------------------------
-- Server version	8.0.21

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
-- Table structure for table `SyncClientConfiguration`
--

DROP TABLE IF EXISTS `SyncClientConfiguration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SyncClientConfiguration` (
  `RowId` int NOT NULL AUTO_INCREMENT,
  `UserName` varchar(50) NOT NULL,
  `DeviceId` varchar(50) NOT NULL,
  PRIMARY KEY (`RowId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `SyncClientConfiguration_after_insert` AFTER INSERT ON `SyncClientConfiguration` FOR EACH ROW BEGIN
  call SyncCreateClientState(NEW.DeviceId);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `SyncClientConfiguration_after_delete` AFTER DELETE ON `SyncClientConfiguration` FOR EACH ROW BEGIN
  delete from SyncClientState where DeviceId = OLD.DeviceId;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `SyncClientState`
--

DROP TABLE IF EXISTS `SyncClientState`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SyncClientState` (
  `DeviceId` varchar(50) NOT NULL,
  `TableName` varchar(50) NOT NULL,
  `State` int NOT NULL DEFAULT '0',
  `SyncedFrom` timestamp NULL DEFAULT NULL,
  `SyncedTo` timestamp NULL DEFAULT NULL,
  `SyncedTableChangesRowId` char(36) DEFAULT NULL,
  `CurrentSyncFrom` timestamp NULL DEFAULT NULL,
  `CurrentSyncTo` timestamp NULL DEFAULT NULL,
  `CurrentTableChangesRowId` char(36) DEFAULT NULL,
  `CurrentSyncId` char(36) DEFAULT NULL,
  PRIMARY KEY (`DeviceId`,`TableName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SyncConfiguration`
--

DROP TABLE IF EXISTS `SyncConfiguration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SyncConfiguration` (
  `RowId` int NOT NULL AUTO_INCREMENT,
  `TableName` varchar(128) NOT NULL,
  `SyncDirection` varchar(16) NOT NULL,
  `SelectStatement` varchar(1024) NOT NULL,
  `SyncFromLimit` timestamp NOT NULL DEFAULT '1970-01-01 00:00:01',
  `SyncOrder` int NOT NULL DEFAULT '1',
  `SyncMode` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`RowId`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `SyncConfiguration_after_insert` AFTER INSERT ON `SyncConfiguration` FOR EACH ROW BEGIN

  if not (NEW.SyncMode = '2') then
    insert into 
      SyncLastTableChanges ( TableName, LastChange, SyncOrder )
    values 
      (NEW.TableName, UTC_TIMESTAMP(), NEW.SyncOrder );
  end if;
  
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `SyncConfiguration_after_delete` AFTER DELETE ON `SyncConfiguration` FOR EACH ROW BEGIN
  delete from SyncDeletedRows where TableName = OLD.TableName; 
  delete from SyncClientState where TableName = OLD.TableName; 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `SyncDeletedRows`
--

DROP TABLE IF EXISTS `SyncDeletedRows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SyncDeletedRows` (
  `RowId` int NOT NULL AUTO_INCREMENT,
  `TableName` varchar(128) NOT NULL,
  `DeviceId` varchar(50) NOT NULL DEFAULT '',
  `SyncLock` bit(1) NOT NULL DEFAULT b'0',
  `InsertedIds` json DEFAULT NULL,
  `UpdatedIds` json DEFAULT NULL,
  `DeletedIds` json DEFAULT NULL,
  `SyncTimestamp` timestamp NULL DEFAULT NULL,
  `RowVersion` char(36) DEFAULT NULL,
  PRIMARY KEY (`RowId`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `SyncDeletedRows_before_insert` BEFORE INSERT ON `SyncDeletedRows` FOR EACH ROW BEGIN
    set @sync = UTC_TIMESTAMP();
    set NEW.syncTimestamp = @sync;
    set NEW.RowVersion = UUID();
    update SyncLastTableChanges set LastChange = @sync where TableName = "DeletedRows";
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `SyncDeletedRows_before_update` BEFORE UPDATE ON `SyncDeletedRows` FOR EACH ROW BEGIN
    set @sync = UTC_TIMESTAMP();
    set NEW.syncTimestamp = @sync;
    set NEW.RowVersion = UUID();
    update SyncLastTableChanges set LastChange = @sync where TableName = "DeletedRows";
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `SyncLastTableChanges`
--

DROP TABLE IF EXISTS `SyncLastTableChanges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SyncLastTableChanges` (
  `RowId` int NOT NULL AUTO_INCREMENT,
  `TableName` varchar(128) NOT NULL,
  `LastChange` timestamp NOT NULL,
  `SyncOrder` int NOT NULL DEFAULT '0',
  `RowVersion` char(36) DEFAULT NULL,
  PRIMARY KEY (`RowId`),
  UNIQUE KEY `TableName` (`TableName`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `SyncLastTableChanges_before_insert` BEFORE INSERT ON `SyncLastTableChanges` FOR EACH ROW BEGIN
set NEW.RowVersion = UUID();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `SyncLastTableChanges_before_update` BEFORE UPDATE ON `SyncLastTableChanges` FOR EACH ROW BEGIN
set NEW.RowVersion = UUID();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `SyncProtocolClients`
--

DROP TABLE IF EXISTS `SyncProtocolClients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SyncProtocolClients` (
  `RowId` int NOT NULL AUTO_INCREMENT,
  `DeviceId` varchar(50) DEFAULT NULL,
  `TableName` varchar(50) DEFAULT NULL,
  `State` varchar(50) DEFAULT NULL,
  `Error` varchar(1024) DEFAULT NULL,
  `SyncFrom` timestamp NULL DEFAULT NULL,
  `SyncTo` timestamp NULL DEFAULT NULL,
  `SyncId` char(36) DEFAULT NULL,
  `SyncResponse` json DEFAULT NULL,
  `InsertedOn` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`RowId`)
) ENGINE=InnoDB AUTO_INCREMENT=498 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `SyncProtocolClients_before_insert` BEFORE INSERT ON `SyncProtocolClients` FOR EACH ROW BEGIN
  SET NEW.InsertedOn = UTC_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `SyncSystemLog`
--

DROP TABLE IF EXISTS `SyncSystemLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SyncSystemLog` (
  `RowId` int NOT NULL AUTO_INCREMENT,
  `Context` varchar(50) NOT NULL,
  `Message` text,
  `Code` char(5) DEFAULT NULL,
  `SqlCommand` text,
  PRIMARY KEY (`RowId`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TableByDate`
--

DROP TABLE IF EXISTS `TableByDate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TableByDate` (
  `RowId` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Ort` varchar(50) NOT NULL,
  `syncTimestamp` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`RowId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `TableByDate_before_insert` BEFORE INSERT ON `TableByDate` FOR EACH ROW BEGIN
    set @sync = UTC_TIMESTAMP();
    set NEW.syncTimestamp = @sync;	
    update SyncLastTableChanges set LastChange = @sync where TableName = "TableByDate";
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `TableByDate_before_update` BEFORE UPDATE ON `TableByDate` FOR EACH ROW BEGIN
    set @sync = UTC_TIMESTAMP();
    set NEW.syncTimestamp = @sync;	
    update SyncLastTableChanges set LastChange = @sync where TableName = "TableByDate";
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `TableByDate_after_delete` AFTER DELETE ON `TableByDate` FOR EACH ROW BEGIN
    CALL CreateDeletedRowForDevices("TableByDate", OLD.RowId);
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `TableByDate2`
--

DROP TABLE IF EXISTS `TableByDate2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TableByDate2` (
  `RowId` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Ort` varchar(50) NOT NULL,
  `syncTimestamp` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`RowId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `TableByDate2_before_insert` BEFORE INSERT ON `TableByDate2` FOR EACH ROW BEGIN
    set @sync = UTC_TIMESTAMP();
    set NEW.syncTimestamp = @sync;	
    update SyncLastTableChanges set LastChange = @sync where TableName = "TableByDate2";
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `TableByDate2_before_update` BEFORE UPDATE ON `TableByDate2` FOR EACH ROW BEGIN
    set @sync = UTC_TIMESTAMP();
    set NEW.syncTimestamp = @sync;	
    update SyncLastTableChanges set LastChange = @sync where TableName = "TableByDate2";
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `TableByDate2_after_delete` AFTER DELETE ON `TableByDate2` FOR EACH ROW BEGIN
    CALL SyncCreateDeletedRowForDevices("TableByDate2", OLD.RowId);
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `TableByDate3`
--

DROP TABLE IF EXISTS `TableByDate3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TableByDate3` (
  `RowId` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Ort` varchar(50) DEFAULT NULL,
  `syncTimestamp` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`RowId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `TableByDate3_before_insert` BEFORE INSERT ON `TableByDate3` FOR EACH ROW BEGIN
    set @sync = UTC_TIMESTAMP();
    set NEW.syncTimestamp = @sync;	
    update SyncLastTableChanges set LastChange = @sync where TableName = "TableByDate3";
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `TableByDate3_before_update` BEFORE UPDATE ON `TableByDate3` FOR EACH ROW BEGIN
    set @sync = UTC_TIMESTAMP();
    set NEW.syncTimestamp = @sync;	
    update SyncLastTableChanges set LastChange = @sync where TableName = "TableByDate3";
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `TableByDate3_after_delete` AFTER DELETE ON `TableByDate3` FOR EACH ROW BEGIN
    CALL SyncCreateDeletedRowForDevices("TableByDate3", OLD.RowId);
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `TableByIds`
--

DROP TABLE IF EXISTS `TableByIds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TableByIds` (
  `RowId` int NOT NULL AUTO_INCREMENT,
  `Produkt` varchar(50) NOT NULL,
  `Beschreibung` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`RowId`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `TableByIds_after_insert` AFTER INSERT ON `TableByIds` FOR EACH ROW BEGIN
    CALL SyncCreateInsertedRowForDevices("TableByIds", NEW.RowId); 
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `TableByIds_after_update` AFTER UPDATE ON `TableByIds` FOR EACH ROW BEGIN
    CALL SyncCreateUpdatedRowForDevices("TableByIds", NEW.RowId); 
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `TableByIds_after_delete` AFTER DELETE ON `TableByIds` FOR EACH ROW BEGIN
    CALL SyncCreateDeletedRowForDevices("TableByIds", OLD.RowId);
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `TableByIds2`
--

DROP TABLE IF EXISTS `TableByIds2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TableByIds2` (
  `RowId` int NOT NULL AUTO_INCREMENT,
  `Produkt` varchar(50) NOT NULL,
  `Beschreibung` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`RowId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `TableByIds2_after_insert` AFTER INSERT ON `TableByIds2` FOR EACH ROW BEGIN
    CALL SyncCreateInsertedRowForDevices("TableByIds2", NEW.RowId); 
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `TableByIds2_after_update` AFTER UPDATE ON `TableByIds2` FOR EACH ROW BEGIN
    CALL SyncCreateUpdatedRowForDevices("TableByIds2", NEW.RowId); 
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `TableByIds2_after_delete` AFTER DELETE ON `TableByIds2` FOR EACH ROW BEGIN
    CALL SyncCreateDeletedRowForDevices("TableByIds2", OLD.RowId);
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping routines for database 'MySqlSync'
--
/*!50003 DROP PROCEDURE IF EXISTS `SyncCreateClientState` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SyncCreateClientState`(
	IN `device_id` VARCHAR(50)

)
BEGIN

  DECLARE done INT DEFAULT FALSE;
  declare tableName varchar(50) DEFAULT null;
  DECLARE tableCursor CURSOR FOR SELECT sc.TableName FROM SyncConfiguration sc;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN tableCursor;

  read_loop: LOOP
    FETCH tableCursor INTO tableName;

    IF done THEN
      LEAVE read_loop;
    END IF;

    insert into SyncClientState (DeviceId, TableName, State) values (device_id, tableName, 0);
    
  END LOOP;

  CLOSE tableCursor;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SyncCreateDeletedRowForDevices` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SyncCreateDeletedRowForDevices`(
	IN `table_name` VARCHAR(50)
,
	IN `row_id` INT






)
BEGIN

  DECLARE done INT DEFAULT FALSE;
  DECLARE device VARCHAR(50);
  DECLARE rowVersion CHAR(36);
  DECLARE deviceCursor CURSOR FOR SELECT cs.DeviceId FROM SyncClientState cs where TableName = table_name;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN deviceCursor;

  read_loop: LOOP
    FETCH deviceCursor INTO device;

    IF done THEN
      LEAVE read_loop;
    END IF;

    if exists (SELECT * FROM SyncDeletedRows dr WHERE dr.TableName = table_name and dr.DeviceId = device and dr.SyncLock = false) then
      update SyncDeletedRows set DeletedIds = JSON_ARRAY_INSERT(DeletedIds, '$[0]', row_id) where TableName = table_name and DeviceId = device and SyncLock = false;
    else
      insert into SyncDeletedRows (TableName,DeviceId,InsertedIds, UpdatedIds, DeletedIds) values (table_name,device,'[]','[]',JSON_ARRAY(row_id));
    end if;

/*
  if not exists (SELECT * FROM DeletedRows dr WHERE dr.TableName = table_name and dr.DeviceId = device) then
    insert into DeletedRows (TableName,DeviceId,DeletedIds) values ("TableToSync",device, deleted_ids);
  else
    SELECT dr.RowVersion into rowVersion FROM DeletedRows dr WHERE dr.TableName = table_name and dr.DeviceId = device FOR UPDATE;
    update DeletedRows set DeletedIds = JSON_ARRAY_MERGE(DeletedIds, '$[0]', deleted_ids) where TableName = "TableToSync" and DeviceId = device;
  end if;
*/
    
  END LOOP;

  CLOSE deviceCursor;

  update SyncLastTableChanges set LastChange = UTC_TIMESTAMP() where TableName = "DeletedRows";
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SyncCreateInsertedRowForDevices` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SyncCreateInsertedRowForDevices`(
	IN `table_name` VARCHAR(128),
	IN `row_id` INT



)
BEGIN

  DECLARE done INT DEFAULT FALSE;
  DECLARE device VARCHAR(50);
  DECLARE rowVersion CHAR(36);
  DECLARE deviceCursor CURSOR FOR SELECT cs.DeviceId FROM SyncClientState cs where TableName = table_name;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN deviceCursor;

  read_loop: LOOP
    FETCH deviceCursor INTO device;

    IF done THEN
      LEAVE read_loop;
    END IF;

    if exists (SELECT * FROM SyncDeletedRows dr WHERE dr.TableName = table_name and dr.DeviceId = device and dr.SyncLock = false) then
      update SyncDeletedRows set InsertedIds = JSON_ARRAY_INSERT(InsertedIds, '$[0]', row_id) where TableName = table_name and DeviceId = device and SyncLock = false;
    else
      insert into SyncDeletedRows (TableName,DeviceId,InsertedIds, UpdatedIds, DeletedIds) values (table_name,device,JSON_ARRAY(row_id),'[]','[]');
    end if;

/*
  if not exists (SELECT * FROM DeletedRows dr WHERE dr.TableName = table_name and dr.DeviceId = device) then
    insert into DeletedRows (TableName,DeviceId,DeletedIds) values ("TableToSync",device, deleted_ids);
  else
    SELECT dr.RowVersion into rowVersion FROM DeletedRows dr WHERE dr.TableName = table_name and dr.DeviceId = device FOR UPDATE;
    update DeletedRows set DeletedIds = JSON_ARRAY_MERGE(DeletedIds, '$[0]', deleted_ids) where TableName = "TableToSync" and DeviceId = device;
  end if;
*/
    
  END LOOP;

  CLOSE deviceCursor;

  update SyncLastTableChanges set LastChange = UTC_TIMESTAMP() where TableName = "DeletedRows";
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SyncCreateUpdatedRowForDevices` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SyncCreateUpdatedRowForDevices`(
	IN `table_name` VARCHAR(128),
	IN `row_id` INT


)
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE device VARCHAR(50);
  DECLARE rowVersion CHAR(36);
  DECLARE deviceCursor CURSOR FOR SELECT cs.DeviceId FROM SyncClientState cs where TableName = table_name;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN deviceCursor;

  read_loop: LOOP
    FETCH deviceCursor INTO device;

    IF done THEN
      LEAVE read_loop;
    END IF;

    if exists (SELECT * FROM SyncDeletedRows dr WHERE dr.TableName = table_name and dr.DeviceId = device and dr.SyncLock = false) then
      update SyncDeletedRows set UpdatedIds = JSON_ARRAY_INSERT(UpdatedIds, '$[0]', row_id) where TableName = table_name and DeviceId = device and SyncLock = false;
    else
      insert into SyncDeletedRows (TableName,DeviceId,InsertedIds, UpdatedIds, DeletedIds) values (table_name,device,'[]',JSON_ARRAY(row_id),'[]');
    end if;
    
  END LOOP;

  CLOSE deviceCursor;

  update SyncLastTableChanges set LastChange = UTC_TIMESTAMP() where TableName = "DeletedRows";

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SyncGetTablesToSync` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SyncGetTablesToSync`(
	IN `device_id` VARCHAR(50)












)
BEGIN

  IF (NULLIF(device_id, '') IS NULL) THEN
    call error('device_id');
  end if;
  
  SELECT
    t.*
  FROM 
    SyncLastTableChanges t left join SyncClientState c
      on t.TableName = c.TableName and c.deviceId = device_id
  WHERE  
    c.DeviceId = device_id 
--    (t.LastChange>= c.SyncedTo or 
--    c.SyncedTo is null)
--  and
--    (c.DeviceId = device_id or
--    c.DeviceId is null)
  and 
    (not c.SyncedTableChangesRowId = t.RowVersion or
    c.SyncedTableChangesRowId is null)
  order by t.SyncOrder;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SyncInsertOrUpdateClientState` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SyncInsertOrUpdateClientState`(
	IN `device_id` VARCHAR(50),
	IN `table_name` VARCHAR(128),
	IN `sync_from` TIMESTAMP,
	IN `sync_to` TIMESTAMP,
	IN `new_state` INT


















,
	IN `sync_id` CHAR(36)





)
BEGIN

-- das sollte nicht bei jedem sync gecheckt werden.
-- ein initializer kann die datensaetze fur den client anlegen
  declare tableChangesRowId char(36);
  
  select RowVersion into tableChangesRowId from SyncLastTableChanges t where t.TableName = table_name;

  if not isnull(tableChangesRowId) then
    if (new_state = 1) THEN


      -- sync request
      IF EXISTS (select * from SyncClientState where DeviceId = device_id and TableName = table_name) THEN
        
        update SyncClientState 
          set 
            State = new_state, 
            CurrentSyncFrom = sync_from, 
            CurrentSyncTo = sync_to, 
            CurrentSyncId = sync_id,
            CurrentTableChangesRowId  = tableChangesRowId
        where 
          DeviceId = device_id and TableName = table_name;
      
      ELSE
      
        insert into SyncClientState
          (DeviceId, TableName, CurrentSyncFrom, CurrentSyncTo, State, CurrentSyncId, CurrentTableChangesRowId)
        values
          (device_id, table_name, sync_from, sync_to, new_state, sync_id, tableChangesRowId);
      
      end if;

    elseif (new_state = 3) then

      -- do not update timestamp within errors
      IF EXISTS (select * from SyncClientState where DeviceId = device_id and TableName = table_name) THEN
      
        update SyncClientState 
          set State = new_state
        where 
          DeviceId = device_id and TableName = table_name;
        
      ELSE 

        insert into SyncClientState
          (DeviceId, TableName, State)
        values
          (device_id, table_name, new_state);

      end if;
                
    end if;

  end if;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SyncPullRequest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SyncPullRequest`(
	IN `device_id` VARCHAR(50),
	IN `table_name` VARCHAR(128)







































,
	IN `log_level` INT








































)
BEGIN

  /* Sync state
    1 = start sync
    2 = done ( Must be set by client )
    3 = error
  */
  
  DECLARE exit handler for sqlexception
  BEGIN
  
    GET DIAGNOSTICS @num = NUMBER;
    GET DIAGNOSTICS CONDITION @num @message = MESSAGE_TEXT, @errNo = RETURNED_SQLSTATE ;
  
    ROLLBACK;
       
    insert into SyncSystemLog (Context, Message, Code, SqlCommand) values ('SyncRegisterSyncTable', @message, @errNo, @sql_text);  
   
    if (log_level <= 3) THEN
      -- Protocol
      insert into 
        SyncProtocolClients (DeviceId, TableName, State, Error, SyncFrom, SyncTo, SyncId)
      values
        (device_id, table_name, 'failed', @message,@lastClientSync, @currentUtc, @guid);
    end if;
        
    -- Client state 
    -- update SyncClientState cs set cs.ts = @syncTs, cs.state = 3;
    call SyncInsertOrUpdateClientState(device_id, table_name, @lastClientSync, @syncTo, 3, @guid);
    
--    SET result = 1003;
    
     
  END;

  IF (NULLIF(device_id, '') IS NULL) THEN
    call error('device_id');
  end if;
  
  set @guid = (SELECT UUID());
  
  -- subtract 1 second to avoid multi user access problems
  set @currentUtc = UTC_TIMESTAMP() - INTERVAL 1 SECOND;
  
  set @lastClientSync = '1970-01-01 00:00:01'; -- (select ts from SyncClientState where deviceId = DeviceId and context = TableName);
      
  if exists (select * from SyncClientState where DeviceId = device_id and TableName = table_name) THEN
    set @lastClientSync = (select SyncedTo from SyncClientState where DeviceId = device_id and TableName = table_name);
  end if;

  IF (@lastClientSync IS NULL) THEN
    set @lastClientSync = '1970-01-01 00:00:01'; 
  end if;

  IF (table_name = "SyncDeletedRows") THEN
    update SyncDeletedRows set SyncLock = true where DeviceId = device_id and SyncLock = false;
  end if;
  
/*  
  -- rows to sync
  SELECT
    *
  FROM
    TableToSync
  WHERE
    -- row timestamp > client sync timestamp
    ts > @lastClientSync
  and
    -- row timestamp < new client sync timestamp
    ts <= @syncTs;
*/

  START TRANSACTION;

  if (log_level <= 1) THEN
    -- Protocol 
    insert into 
      SyncProtocolClients (DeviceId, TableName, State, SyncFrom, SyncTo, SyncId)
    values
      (device_id, table_name, 'sync request', @lastClientSync, @currentUtc, @guid);
  end if;
  
	-- Client state 
  call SyncInsertOrUpdateClientState(device_id, table_name, @lastClientSync, @currentUtc, 1, @guid);

-- SET result = 1000;


-- TODO: if SyncByIds else
-- if a client requests a table first time, all ids must be delivered
--      select JSON_ARRAYAGG(RowId) from TableByIds


  COMMIT;
   
--  SET @sql_text = concat("select * from `",table_name,"` where syncTimestamp > '",@lastClientSync,"' and syncTimestamp <= '",@currentUtc,"'");
    select SelectStatement, SyncMode into @sql_text, @syncMode from SyncConfiguration where TableName = table_name;
    
    if (@syncMode = 1) then
      set @sql_text = REPLACE(@sql_text, 'table_name', table_name);
      set @sql_text = REPLACE(@sql_text, 'sync_from', @lastClientSync);
      set @sql_text = REPLACE(@sql_text, 'sync_to', @currentUtc);
      
      PREPARE stmt FROM @sql_text;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;

    elseif (@syncMode = 2) then
      -- Tables synced by Ids
      select * from SyncDeletedRows where TableName = @table_name and DeviceId = @device_id and SyncLock = 1; 
    elseif (@syncMode = 4) then
      -- Table SyncDeletedRows itself
      select * from SyncDeletedRows where DeviceId = @device_id and SyncLock = 1; 
    
    /*
      select GROUP_CONCAT(InsertedIds,',') into @row_ids from DeletedRows where TableName = table_name and DeviceId = @device_id and SyncLock = 1; 
 --     select InsertedIds into @row_ids from DeletedRows where TableName = @table_name and DeviceId = @device_id and SyncLock = 0; 
      set @row_ids = REPLACE(@row_ids, ']', '');
      set @row_ids = REPLACE(@row_ids, '[', '');
      set @row_ids = REPLACE(@row_ids, ',,', ',');
         
      set @sql_text = REPLACE(@sql_text, 'table_name', table_name);
      set @sql_text = REPLACE(@sql_text, 'row_ids', @row_ids);
      set @sql_text = REPLACE(@sql_text, ',)', ')');
    */      
    end if;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SyncPullResponse` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SyncPullResponse`(
	IN `device_id` VARCHAR(50),
	IN `table_name` VARCHAR(128),
	IN `new_state` INT,
	IN `current_sync_id` CHAR(36)
,
	IN `sync_response` JSON








)
BEGIN

/*
"deviceId": "13",
"context": "events",
"state": "1",
"SyncedFrom": null,
"SyncedTo": null,
"CurrentSyncFrom": "1970-01-01 00:00:01",
"CurrentSyncTo": "2018-10-05 14:39:01",
"CurrentSyncId": "6654d01e-c8ac-11e8-a08b-0242ac110002"
*/

  -- other state than 1 or 3 - update all
  IF EXISTS (select * from SyncClientState where CurrentSyncId = current_sync_id and DeviceId = device_id and TableName = table_name and State = 1) THEN

    -- get from an to sync timestamp from client state table  
    select cs.CurrentSyncFrom, cs.CurrentSyncTo into @syncFrom, @syncTo from SyncClientState cs where CurrentSyncId = current_sync_id and DeviceId = device_id and TableName = table_name;
    
    -- update client state
    update 
      SyncClientState 
    set 
      State = new_state, SyncedFrom = CurrentSyncFrom, SyncedTo = CurrentSyncTo, SyncedTableChangesRowId = CurrentTableChangesRowId,
      CurrentSyncId = null, CurrentSyncFrom = null, CurrentSyncTo = null, CurrentTableChangesRowId = null
    where
      CurrentSyncId = current_sync_id and DeviceId = device_id and TableName = table_name;
      
    -- Protocol 
    insert into 
      SyncProtocolClients (DeviceId, TableName, State, SyncFrom, SyncTo, SyncId, SyncResponse)
    values
      (device_id, table_name, 'success', @syncFrom, @syncTo, current_sync_id, sync_response);

    SELECT 'success' as SpResult;
      
  ELSE
    -- no response without request. Therefore only log this bad request

    -- Protocol 
    insert into 
      SyncProtocolClients (DeviceId, TableName, State, SyncFrom, SyncTo, SyncId, SyncResponse)
    values
      (device_id, table_name, 'wrong response', @syncFrom, @syncTo, current_sync_id, sync_response);
    
    SELECT 'wrong response' as SpResult;
    -- call error('wrong response');
    
  end if;
     
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Sync_Test` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `Sync_Test`()
BEGIN

  /* Sync state ( log level for SyncBeginClientTableSync )
    1 = start sync
    2 = done ( Must be set by client )
    3 = error
  */

set @json = 
  '{ "state": {
    "deviceId": "13",
    "context": "events",
    "state": "1",
    "SyncedFrom": null,
    "SyncedTo": null,
    "CurrentSyncFrom": "1970-01-01 00:00:01",
    "CurrentSyncTo": "2018-10-05 15:06:41",
    "CurrentSyncId": "4440b062-c8b0-11e8-a08b-0242ac110002",
    "SyncResult": null
  }}';

set @table_name = "events";
set @device_id = "1";

-- request 
  CALL SyncGetTablesToSync(@device_id);
 call SyncPullRequest(@device_id,@table_name,1);


-- response
select CurrentSyncId into @current_sync_id from SyncClientState where deviceId = @device_id and TableName = @table_name;
call SyncPullResponse(@device_id, @table_name, 2, @current_sync_id, @json);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-10-26  9:16:57