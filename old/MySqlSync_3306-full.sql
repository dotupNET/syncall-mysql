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

--
-- Dumping data for table `SyncClientConfiguration`
--

LOCK TABLES `SyncClientConfiguration` WRITE;
/*!40000 ALTER TABLE `SyncClientConfiguration` DISABLE KEYS */;
INSERT INTO `SyncClientConfiguration` VALUES (2,'Peter','100');
/*!40000 ALTER TABLE `SyncClientConfiguration` ENABLE KEYS */;
UNLOCK TABLES;
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
-- Dumping data for table `SyncClientState`
--

LOCK TABLES `SyncClientState` WRITE;
/*!40000 ALTER TABLE `SyncClientState` DISABLE KEYS */;
INSERT INTO `SyncClientState` VALUES ('1','SyncDeletedRows',1,NULL,NULL,NULL,'1970-01-01 00:00:01','2018-10-09 08:58:04','16fabb58-cb9f-11e8-bda4-0242ac110002','6f386940-cba1-11e8-bda4-0242ac110002'),('1','TableByDate2',2,'2018-10-09 06:54:34','2018-10-09 06:54:34','04927cc8-cb90-11e8-bda4-0242ac110002',NULL,NULL,NULL,NULL),('1','TableByIds',1,NULL,NULL,NULL,'1970-01-01 00:00:01','2018-10-08 10:12:16',NULL,'a2f2d32f-cae2-11e8-ad75-0242ac110002'),('100','SyncDeletedRows',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('100','TableByDate',1,NULL,NULL,NULL,'1970-01-01 00:00:01','2018-10-10 08:32:13','c43587c9-cb88-11e8-bda4-0242ac110002','fd23122d-cc66-11e8-b504-0242ac110002'),('100','TableByDate2',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('100','TableByDate3',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('100','TableByIds',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('100','TableByIds2',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `SyncClientState` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Dumping data for table `SyncConfiguration`
--

LOCK TABLES `SyncConfiguration` WRITE;
/*!40000 ALTER TABLE `SyncConfiguration` DISABLE KEYS */;
INSERT INTO `SyncConfiguration` VALUES (1,'SyncDeletedRows','2','select * from SyncDeletedRows where DeviceId = \'device_id\' and SyncLock = 1;','2018-10-08 16:11:33',10000,4),(12,'TableByDate','3','select * from `table_name` where syncTimestamp >= \'sync_from\' and syncTimestamp <= \'sync_to\';','1970-01-01 00:00:01',1,1),(13,'TableByIds','3','select * from `table_name` where RowId in (row_ids);','1970-01-01 00:00:01',1,2),(14,'TableByDate2','3','select * from `table_name` where syncTimestamp >= \'sync_from\' and syncTimestamp <= \'sync_to\';','1970-01-01 00:00:01',1,1),(15,'TableByDate3','3','select * from `table_name` where syncTimestamp >= \'sync_from\' and syncTimestamp <= \'sync_to\';','1970-01-01 00:00:01',1,1),(16,'TableByIds2','3','select * from `table_name` where RowId in (row_ids);','1970-01-01 00:00:01',1,2);
/*!40000 ALTER TABLE `SyncConfiguration` ENABLE KEYS */;
UNLOCK TABLES;
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

--
-- Dumping data for table `SyncDeletedRows`
--

LOCK TABLES `SyncDeletedRows` WRITE;
/*!40000 ALTER TABLE `SyncDeletedRows` DISABLE KEYS */;
INSERT INTO `SyncDeletedRows` VALUES (4,'TableByIds','1',_binary '','[35, 34, 33, 32]',NULL,'[32, 34]','2018-10-08 21:12:45','e70109ff-cb3e-11e8-b761-0242ac110002'),(8,'TableByIds','1',_binary '','[8]','[]','[]','2018-10-08 21:12:48','e891e520-cb3e-11e8-b761-0242ac110002'),(9,'TableByIds','1',_binary '','[]','[]','[5]','2018-10-09 08:43:57','762fba7d-cb9f-11e8-bda4-0242ac110002'),(10,'TableByIds','1',_binary '','[9]','[]','[6]','2018-10-09 08:58:05','6f3878a8-cba1-11e8-bda4-0242ac110002');
/*!40000 ALTER TABLE `SyncDeletedRows` ENABLE KEYS */;
UNLOCK TABLES;
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

--
-- Dumping data for table `SyncLastTableChanges`
--

LOCK TABLES `SyncLastTableChanges` WRITE;
/*!40000 ALTER TABLE `SyncLastTableChanges` DISABLE KEYS */;
INSERT INTO `SyncLastTableChanges` VALUES (41,'TableToSync','2018-10-08 12:26:34',1,'134193e4-cb8f-11e8-bda4-0242ac110002'),(42,'TableToSync2','2018-10-06 09:23:30',2,'17ab37c5-cb8f-11e8-bda4-0242ac110002'),(43,'SyncDeletedRows','2018-10-08 21:12:48',3,'16fabb58-cb9f-11e8-bda4-0242ac110002'),(61,'TableByDate','2018-10-09 06:01:30',1,'c43587c9-cb88-11e8-bda4-0242ac110002'),(77,'TableByDate2','2018-10-09 06:26:02',1,'04927cc8-cb90-11e8-bda4-0242ac110002'),(78,'TableByDate3','2018-10-09 10:15:11',1,'34c0ec69-cbac-11e8-bc39-0242ac110002');
/*!40000 ALTER TABLE `SyncLastTableChanges` ENABLE KEYS */;
UNLOCK TABLES;
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

--
-- Dumping data for table `SyncProtocolClients`
--

LOCK TABLES `SyncProtocolClients` WRITE;
/*!40000 ALTER TABLE `SyncProtocolClients` DISABLE KEYS */;
INSERT INTO `SyncProtocolClients` VALUES (253,'2','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-06 06:12:26','cd763457-c92e-11e8-8f74-0242ac110002',NULL,'2018-10-06 06:12:28'),(254,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-06 06:13:34','f62324b1-c92e-11e8-8f74-0242ac110002',NULL,'2018-10-06 06:13:36'),(255,'3','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-06 06:20:59','ff5b1d20-c92f-11e8-8f74-0242ac110002',NULL,'2018-10-06 06:21:01'),(256,'3','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-06 06:25:51','ad29422e-c930-11e8-8f74-0242ac110002',NULL,'2018-10-06 06:25:53'),(276,'1','events','wrong response',NULL,NULL,NULL,'77c7a792-c934-11e8-8f74-0242ac110002','{\"State\": \"2\", \"DeviceId\": \"1\", \"RowCount\": 36, \"SyncedTo\": null, \"TableName\": \"events\", \"SyncedFrom\": null, \"CurrentSyncId\": \"77c7a792-c934-11e8-8f74-0242ac110002\", \"CurrentSyncTo\": \"2018-10-06 04:34:36\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}','2018-10-06 06:53:37'),(277,'20','events','success',NULL,'1970-01-01 00:00:01','2018-10-06 06:52:59','77c7a792-c934-11e8-8f74-0242ac110002','{\"State\": \"2\", \"DeviceId\": \"20\", \"RowCount\": 36, \"SyncedTo\": null, \"TableName\": \"events\", \"SyncedFrom\": null, \"CurrentSyncId\": \"77c7a792-c934-11e8-8f74-0242ac110002\", \"CurrentSyncTo\": \"2018-10-06 04:34:36\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}','2018-10-06 06:54:18'),(278,'20','events','wrong response',NULL,NULL,NULL,'77c7a792-c934-11e8-8f74-0242ac110002','{\"State\": \"2\", \"DeviceId\": \"20\", \"RowCount\": 36, \"SyncedTo\": null, \"TableName\": \"events\", \"SyncedFrom\": null, \"CurrentSyncId\": \"77c7a792-c934-11e8-8f74-0242ac110002\", \"CurrentSyncTo\": \"2018-10-06 04:34:36\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}','2018-10-06 06:58:12'),(284,'20','events','wrong response',NULL,NULL,NULL,'77c7a792-c934-11e8-8f74-0242ac110002','{\"State\": \"2\", \"DeviceId\": \"20\", \"RowCount\": 36, \"SyncedTo\": null, \"TableName\": \"events\", \"SyncedFrom\": null, \"CurrentSyncId\": \"77c7a792-c934-11e8-8f74-0242ac110002\", \"CurrentSyncTo\": \"2018-10-06 04:34:36\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}','2018-10-06 07:26:11'),(285,'20','events','wrong response',NULL,NULL,NULL,'77c7a792-c934-11e8-8f74-0242ac110002','{\"State\": \"2\", \"DeviceId\": \"20\", \"RowCount\": 36, \"SyncedTo\": null, \"TableName\": \"events\", \"SyncedFrom\": null, \"CurrentSyncId\": \"77c7a792-c934-11e8-8f74-0242ac110002\", \"CurrentSyncTo\": \"2018-10-06 04:34:36\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}','2018-10-06 07:27:17'),(286,'20','events','wrong response',NULL,NULL,NULL,'77c7a792-c934-11e8-8f74-0242ac110002','{\"State\": \"2\", \"DeviceId\": \"20\", \"RowCount\": 36, \"SyncedTo\": null, \"TableName\": \"events\", \"SyncedFrom\": null, \"CurrentSyncId\": \"77c7a792-c934-11e8-8f74-0242ac110002\", \"CurrentSyncTo\": \"2018-10-06 04:34:36\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}','2018-10-06 07:28:58'),(287,'20','events','wrong response',NULL,NULL,NULL,'77c7a792-c934-11e8-8f74-0242ac110002','{\"State\": \"2\", \"DeviceId\": \"20\", \"RowCount\": 36, \"SyncedTo\": null, \"TableName\": \"events\", \"SyncedFrom\": null, \"CurrentSyncId\": \"77c7a792-c934-11e8-8f74-0242ac110002\", \"CurrentSyncTo\": \"2018-10-06 04:34:36\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}','2018-10-06 07:32:37'),(288,'200','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-06 07:33:02','0fbe478d-c93a-11e8-8f74-0242ac110002',NULL,'2018-10-06 07:33:04'),(289,'20','events','wrong response',NULL,NULL,NULL,'0fbe478d-c93a-11e8-8f74-0242ac110002','{\"State\": \"2\", \"DeviceId\": \"20\", \"RowCount\": 36, \"SyncedTo\": null, \"TableName\": \"events\", \"SyncedFrom\": null, \"CurrentSyncId\": \"0fbe478d-c93a-11e8-8f74-0242ac110002\", \"CurrentSyncTo\": \"2018-10-06 04:34:36\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}','2018-10-06 07:33:51'),(304,'20','events','wrong response',NULL,NULL,NULL,'0fbe478d-c93a-11e8-8f74-0242ac110002','{\"State\": \"2\", \"DeviceId\": \"20\", \"RowCount\": 36, \"SyncedTo\": null, \"TableName\": \"events\", \"SyncedFrom\": null, \"CurrentSyncId\": \"0fbe478d-c93a-11e8-8f74-0242ac110002\", \"CurrentSyncTo\": \"2018-10-06 04:34:36\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}','2018-10-06 08:42:18'),(305,'20','events','wrong response',NULL,NULL,NULL,'0fbe478d-c93a-11e8-8f74-0242ac110002','{\"State\": \"2\", \"DeviceId\": \"20\", \"RowCount\": 36, \"SyncedTo\": null, \"TableName\": \"events\", \"SyncedFrom\": null, \"CurrentSyncId\": \"0fbe478d-c93a-11e8-8f74-0242ac110002\", \"CurrentSyncTo\": \"2018-10-06 04:34:36\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}','2018-10-06 08:42:58'),(306,'222','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-06 08:43:29','e6ffcd76-c943-11e8-8f74-0242ac110002',NULL,'2018-10-06 08:43:31'),(307,'222','events','success',NULL,'1970-01-01 00:00:01','2018-10-06 08:43:29','e6ffcd76-c943-11e8-8f74-0242ac110002','{\"State\": \"2\", \"DeviceId\": \"222\", \"RowCount\": 36, \"SyncedTo\": null, \"TableName\": \"events\", \"SyncedFrom\": null, \"CurrentSyncId\": \"e6ffcd76-c943-11e8-8f74-0242ac110002\", \"CurrentSyncTo\": \"2018-10-06 04:34:36\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}','2018-10-06 08:43:54'),(308,'1','TableToSync','sync request',NULL,'1970-01-01 00:00:01','2018-10-06 19:18:38','a2048d89-c99c-11e8-8b3e-0242ac110002',NULL,'2018-10-06 19:18:40'),(309,'2','TableToSync','sync request',NULL,'1970-01-01 00:00:01','2018-10-06 19:18:58','ae39f04c-c99c-11e8-8b3e-0242ac110002',NULL,'2018-10-06 19:19:00'),(310,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:02','7710edad-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:04'),(311,'1','events','failed',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:02','7710edad-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:04'),(312,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:03','77c585dc-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:05'),(313,'1','events','failed',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:03','77c585dc-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:05'),(314,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:09','7b90c72f-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:11'),(315,'1','events','failed',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:09','7b90c72f-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:11'),(316,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:10','7becbb81-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:12'),(317,'1','events','failed',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:10','7becbb81-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:12'),(318,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:10','7c243186-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:12'),(319,'1','events','failed',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:10','7c243186-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:12'),(320,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:11','7c50cc4c-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:13'),(321,'1','events','failed',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:11','7c50cc4c-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:13'),(322,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:11','7c72ffda-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:13'),(323,'1','events','failed',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:11','7c72ffda-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:13'),(324,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:11','7c952ed1-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:13'),(325,'1','events','failed',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:11','7c952ed1-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:13'),(326,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:11','7cb536bd-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:13'),(327,'1','events','failed',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:11','7cb536bd-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:13'),(328,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:12','7cd160c9-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:14'),(329,'1','events','failed',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:12','7cd160c9-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:14'),(330,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:12','7cefaf11-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:14'),(331,'1','events','failed',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:12','7cefaf11-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:14'),(332,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:12','7d084bd5-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:14'),(333,'1','events','failed',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:12','7d084bd5-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:14'),(334,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:12','7d25b85a-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:14'),(335,'1','events','failed',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:12','7d25b85a-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:14'),(336,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:12','7d41cbd4-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:14'),(337,'1','events','failed',NULL,'1970-01-01 00:00:01','2018-10-08 10:11:12','7d41cbd4-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:11:14'),(338,'1','TableToSync','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:12:13','a16f9d70-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:12:15'),(339,'1','TableToSync','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:12:15','a2768c88-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:12:17'),(340,'1','TableToSync','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:12:15','a2909c83-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:12:17'),(341,'1','TableToSync','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:12:15','a2a9cd14-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:12:17'),(342,'1','TableToSync','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:12:15','a2c2a089-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:12:17'),(343,'1','TableToSync','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:12:15','a2daafdc-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:12:17'),(344,'1','TableToSync','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:12:16','a2f2d32f-cae2-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:12:18'),(345,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:20:14','c01b6bf3-cae3-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:20:16'),(346,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:20:21','c473a250-cae3-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:20:23'),(347,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:22:37','152a2aec-cae4-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:22:39'),(348,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:22:41','17fc4b60-cae4-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:22:43'),(349,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:22:42','188bea28-cae4-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:22:44'),(350,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:23:17','2d7c43ca-cae4-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:23:19'),(351,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:23:25','31b4d2b9-cae4-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:23:27'),(352,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:23:25','32103d3c-cae4-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:23:27'),(353,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:24:31','597112f6-cae4-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:24:33'),(354,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:27:34','c6533adb-cae4-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:27:36'),(355,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 10:33:13','904e0937-cae5-11e8-ad75-0242ac110002',NULL,'2018-10-08 10:33:15'),(356,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 11:01:47','8de9e851-cae9-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:01:49'),(357,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 11:01:48','8e9e501e-cae9-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:01:50'),(358,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:03:41','d24fbb60-cae9-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:03:43'),(359,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:04:44','f7a66fd4-cae9-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:04:46'),(360,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:04:45','f7f1630f-cae9-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:04:47'),(361,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:04:45','f8151468-cae9-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:04:47'),(362,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:04:45','f82de504-cae9-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:04:47'),(363,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:04:45','f847f896-cae9-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:04:47'),(364,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:04:45','f8622666-cae9-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:04:47'),(365,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:04:45','f87b7451-cae9-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:04:48'),(366,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:04:46','f8949f6f-cae9-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:04:48'),(367,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:06:48','4166b171-caea-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:06:50'),(368,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:06:48','41b7a1e8-caea-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:06:50'),(369,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:06:49','41e1dee2-caea-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:06:51'),(370,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:11:11','de65cabb-caea-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:11:13'),(371,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:11:57','f993175f-caea-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:11:59'),(372,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:13:55','40002b36-caeb-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:13:57'),(373,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:14:19','4e99ef52-caeb-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:14:21'),(374,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 11:15:15','6f9c84f8-caeb-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:15:17'),(375,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:15:44','80c91884-caeb-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:15:46'),(376,'1','DeletedRows','failed',NULL,'1970-01-01 00:00:01','2018-10-08 11:15:45','818f3f66-caeb-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:15:47'),(377,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 11:17:38','c4d8ae23-caeb-11e8-ad75-0242ac110002',NULL,'2018-10-08 11:17:40'),(379,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 20:14:01','b3ad83f1-cb36-11e8-b761-0242ac110002',NULL,'2018-10-08 20:14:03'),(380,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 20:14:43','cc8cf059-cb36-11e8-b761-0242ac110002',NULL,'2018-10-08 20:14:45'),(381,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 20:14:44','cd2573fb-cb36-11e8-b761-0242ac110002',NULL,'2018-10-08 20:14:46'),(382,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 20:14:44','cd4cb36c-cb36-11e8-b761-0242ac110002',NULL,'2018-10-08 20:14:46'),(383,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 20:14:44','cd6282bc-cb36-11e8-b761-0242ac110002',NULL,'2018-10-08 20:14:46'),(384,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 20:14:45','cd7c5185-cb36-11e8-b761-0242ac110002',NULL,'2018-10-08 20:14:47'),(385,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 20:14:45','cd95ba83-cb36-11e8-b761-0242ac110002',NULL,'2018-10-08 20:14:47'),(386,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 20:14:45','cdacf630-cb36-11e8-b761-0242ac110002',NULL,'2018-10-08 20:14:47'),(387,'1','DeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 20:14:45','cdc9baca-cb36-11e8-b761-0242ac110002',NULL,'2018-10-08 20:14:47'),(388,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 20:46:12','32c0482c-cb3b-11e8-b761-0242ac110002',NULL,'2018-10-08 20:46:14'),(389,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 20:52:19','0d529374-cb3c-11e8-b761-0242ac110002',NULL,'2018-10-08 20:52:21'),(390,'1','TableByIds','failed',NULL,'1970-01-01 00:00:01','2018-10-08 20:52:19','0d529374-cb3c-11e8-b761-0242ac110002',NULL,'2018-10-08 20:52:21'),(391,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 20:55:18','77ebc2b7-cb3c-11e8-b761-0242ac110002',NULL,'2018-10-08 20:55:20'),(392,'1','TableByIds','failed',NULL,'1970-01-01 00:00:01','2018-10-08 20:55:18','77ebc2b7-cb3c-11e8-b761-0242ac110002',NULL,'2018-10-08 20:55:20'),(393,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 21:12:59','f03a5c64-cb3e-11e8-b761-0242ac110002',NULL,'2018-10-08 21:13:01'),(394,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 21:13:42','09e86acb-cb3f-11e8-b761-0242ac110002',NULL,'2018-10-08 21:13:44'),(395,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 21:15:18','4373eea4-cb3f-11e8-b761-0242ac110002',NULL,'2018-10-08 21:15:20'),(396,'1','TableByIds','failed',NULL,'1970-01-01 00:00:01','2018-10-08 21:15:18','4373eea4-cb3f-11e8-b761-0242ac110002',NULL,'2018-10-08 21:15:21'),(397,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 21:18:00','a3ed9d74-cb3f-11e8-b761-0242ac110002',NULL,'2018-10-08 21:18:02'),(398,'1','TableByIds','failed',NULL,'1970-01-01 00:00:01','2018-10-08 21:18:00','a3ed9d74-cb3f-11e8-b761-0242ac110002',NULL,'2018-10-08 21:18:02'),(399,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 21:19:39','de6f9596-cb3f-11e8-b761-0242ac110002',NULL,'2018-10-08 21:19:41'),(400,'1','TableByIds','failed',NULL,'1970-01-01 00:00:01','2018-10-08 21:19:39','de6f9596-cb3f-11e8-b761-0242ac110002',NULL,'2018-10-08 21:19:41'),(401,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 21:21:18','19cdd695-cb40-11e8-b761-0242ac110002',NULL,'2018-10-08 21:21:20'),(402,'1','TableByIds','failed',NULL,'1970-01-01 00:00:01','2018-10-08 21:21:18','19cdd695-cb40-11e8-b761-0242ac110002',NULL,'2018-10-08 21:21:20'),(403,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 21:22:31','454616a1-cb40-11e8-b761-0242ac110002',NULL,'2018-10-08 21:22:33'),(404,'1','TableByIds','failed',NULL,'1970-01-01 00:00:01','2018-10-08 21:22:31','454616a1-cb40-11e8-b761-0242ac110002',NULL,'2018-10-08 21:22:33'),(405,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 21:23:03','5857c175-cb40-11e8-b761-0242ac110002',NULL,'2018-10-08 21:23:05'),(406,'1','TableByIds','failed',NULL,'1970-01-01 00:00:01','2018-10-08 21:23:03','5857c175-cb40-11e8-b761-0242ac110002',NULL,'2018-10-08 21:23:05'),(407,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-08 21:24:09','7fabc3d0-cb40-11e8-b761-0242ac110002',NULL,'2018-10-08 21:24:11'),(408,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 05:43:18','3ab23248-cb86-11e8-bda4-0242ac110002',NULL,'2018-10-09 05:43:20'),(409,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 05:43:37','45e350d0-cb86-11e8-bda4-0242ac110002',NULL,'2018-10-09 05:43:39'),(410,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 05:43:37','46470090-cb86-11e8-bda4-0242ac110002',NULL,'2018-10-09 05:43:39'),(411,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 05:43:38','46776ac4-cb86-11e8-bda4-0242ac110002',NULL,'2018-10-09 05:43:40'),(412,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 05:43:38','46975981-cb86-11e8-bda4-0242ac110002',NULL,'2018-10-09 05:43:40'),(413,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 05:43:38','46aff8a0-cb86-11e8-bda4-0242ac110002',NULL,'2018-10-09 05:43:40'),(414,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 05:43:38','46c6f957-cb86-11e8-bda4-0242ac110002',NULL,'2018-10-09 05:43:40'),(415,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 05:43:38','46df13e4-cb86-11e8-bda4-0242ac110002',NULL,'2018-10-09 05:43:40'),(416,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 05:43:39','46f58735-cb86-11e8-bda4-0242ac110002',NULL,'2018-10-09 05:43:41'),(417,'1','TableByIds','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:21:33','92c9d64e-cb8b-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:21:35'),(418,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:27:02','5681694c-cb8c-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:27:04'),(419,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:31:06','e8399b1f-cb8c-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:31:08'),(420,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:32:12','0f5c4b95-cb8d-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:32:14'),(421,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:40:01','27040e86-cb8e-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:40:03'),(422,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:44:50','d3139c03-cb8e-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:44:52'),(423,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:44:50','d35da0a3-cb8e-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:44:52'),(424,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:44:51','d3930c0a-cb8e-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:44:53'),(425,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:46:52','1c2c4715-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:46:54'),(426,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:50','6252927c-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:52'),(427,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:51','632fafaa-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:53'),(428,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:52','636e0e96-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:54'),(429,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:52','639d5c25-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:54'),(430,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:52','63c969eb-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:54'),(431,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:53','63ed90f0-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:55'),(432,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:53','640d42d2-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:55'),(433,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:53','642970ed-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:55'),(434,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:53','6445b34d-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:55'),(435,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:53','6462294b-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:55'),(436,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:54','6484bd19-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:56'),(437,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:54','649dc7df-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:56'),(438,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:54','64b78efc-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:56'),(439,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:54','64d37d52-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:56'),(440,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:54','64ee9a9a-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:56'),(441,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:55','65094189-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:57'),(442,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:55','6522bd73-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:57'),(443,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:55','653d2414-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:57'),(444,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:55','6557f0e0-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:57'),(445,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:55','656f2166-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:57'),(446,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:55','658ae333-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:57'),(447,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:56','65a6eb3b-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:58'),(448,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:56','65c2474d-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:58'),(449,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:56','65dcbc3f-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:58'),(450,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:48:56','65f674b5-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:48:58'),(451,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:50:18','96ac3aa3-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:50:20'),(452,'1','TableByDate2','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 06:51:19','bb3e84c1-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:51:21'),(453,'1','TableByDate2','success',NULL,'1970-01-01 00:00:01','2018-10-09 06:51:19','bb3e84c1-cb8f-11e8-bda4-0242ac110002','{\"state\": {\"state\": \"1\", \"context\": \"events\", \"SyncedTo\": null, \"deviceId\": \"13\", \"SyncResult\": null, \"SyncedFrom\": null, \"CurrentSyncId\": \"4440b062-c8b0-11e8-a08b-0242ac110002\", \"CurrentSyncTo\": \"2018-10-05 15:06:41\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}}','2018-10-09 06:51:21'),(454,'1','TableByDate2','sync request',NULL,'2018-10-09 06:51:19','2018-10-09 06:51:38','c654a1e3-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:51:40'),(455,'1','TableByDate2','sync request',NULL,'2018-10-09 06:51:19','2018-10-09 06:51:40','c7c004cc-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:51:42'),(456,'1','TableByDate2','sync request',NULL,'2018-10-09 06:51:19','2018-10-09 06:51:41','c82b4806-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:51:43'),(457,'1','TableByDate2','sync request',NULL,'2018-10-09 06:51:19','2018-10-09 06:51:41','c876e527-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:51:43'),(458,'1','TableByDate2','sync request',NULL,'2018-10-09 06:51:19','2018-10-09 06:51:42','c8cd3525-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:51:44'),(459,'1','TableByDate2','sync request',NULL,'2018-10-09 06:51:19','2018-10-09 06:51:42','c91c3e03-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:51:44'),(460,'1','TableByDate2','sync request',NULL,'2018-10-09 06:51:19','2018-10-09 06:51:43','c96acacc-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:51:45'),(461,'1','TableByDate2','sync request',NULL,'2018-10-09 06:51:19','2018-10-09 06:52:43','ed47167f-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:52:45'),(462,'1','TableByDate2','sync request',NULL,'2018-10-09 06:51:19','2018-10-09 06:52:44','ed8dd808-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:52:46'),(463,'1','TableByDate2','sync request',NULL,'2018-10-09 06:51:19','2018-10-09 06:52:44','edc5dae1-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:52:46'),(464,'1','TableByDate2','sync request',NULL,'2018-10-09 06:51:19','2018-10-09 06:52:44','ede774a2-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:52:46'),(465,'1','TableByDate2','sync request',NULL,'2018-10-09 06:51:19','2018-10-09 06:52:44','ee00d0e5-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:52:46'),(466,'1','TableByDate2','sync request',NULL,'2018-10-09 06:51:19','2018-10-09 06:52:45','ee17bc47-cb8f-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:52:47'),(467,'1','TableByDate2','sync request',NULL,'2018-10-09 06:51:19','2018-10-09 06:54:03','1c947bf4-cb90-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:54:05'),(468,'1','TableByDate2','sync request',NULL,'2018-10-09 06:51:19','2018-10-09 06:54:32','2e249752-cb90-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:54:34'),(469,'1','TableByDate2','success',NULL,'2018-10-09 06:51:19','2018-10-09 06:54:32','2e249752-cb90-11e8-bda4-0242ac110002','{\"state\": {\"state\": \"1\", \"context\": \"events\", \"SyncedTo\": null, \"deviceId\": \"13\", \"SyncResult\": null, \"SyncedFrom\": null, \"CurrentSyncId\": \"4440b062-c8b0-11e8-a08b-0242ac110002\", \"CurrentSyncTo\": \"2018-10-05 15:06:41\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}}','2018-10-09 06:54:34'),(470,'1','TableByDate2','sync request',NULL,'2018-10-09 06:54:32','2018-10-09 06:54:32','2e6dff85-cb90-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:54:34'),(471,'1','TableByDate2','success',NULL,'2018-10-09 06:54:32','2018-10-09 06:54:32','2e6dff85-cb90-11e8-bda4-0242ac110002','{\"state\": {\"state\": \"1\", \"context\": \"events\", \"SyncedTo\": null, \"deviceId\": \"13\", \"SyncResult\": null, \"SyncedFrom\": null, \"CurrentSyncId\": \"4440b062-c8b0-11e8-a08b-0242ac110002\", \"CurrentSyncTo\": \"2018-10-05 15:06:41\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}}','2018-10-09 06:54:35'),(472,'1','TableByDate2','sync request',NULL,'2018-10-09 06:54:32','2018-10-09 06:54:33','2ec1df93-cb90-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:54:35'),(473,'1','TableByDate2','success',NULL,'2018-10-09 06:54:32','2018-10-09 06:54:33','2ec1df93-cb90-11e8-bda4-0242ac110002','{\"state\": {\"state\": \"1\", \"context\": \"events\", \"SyncedTo\": null, \"deviceId\": \"13\", \"SyncResult\": null, \"SyncedFrom\": null, \"CurrentSyncId\": \"4440b062-c8b0-11e8-a08b-0242ac110002\", \"CurrentSyncTo\": \"2018-10-05 15:06:41\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}}','2018-10-09 06:54:35'),(474,'1','TableByDate2','sync request',NULL,'2018-10-09 06:54:33','2018-10-09 06:54:33','2f01b14a-cb90-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:54:35'),(475,'1','TableByDate2','success',NULL,'2018-10-09 06:54:33','2018-10-09 06:54:33','2f01b14a-cb90-11e8-bda4-0242ac110002','{\"state\": {\"state\": \"1\", \"context\": \"events\", \"SyncedTo\": null, \"deviceId\": \"13\", \"SyncResult\": null, \"SyncedFrom\": null, \"CurrentSyncId\": \"4440b062-c8b0-11e8-a08b-0242ac110002\", \"CurrentSyncTo\": \"2018-10-05 15:06:41\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}}','2018-10-09 06:54:36'),(476,'1','TableByDate2','sync request',NULL,'2018-10-09 06:54:33','2018-10-09 06:54:34','2f3b99d9-cb90-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:54:36'),(477,'1','TableByDate2','success',NULL,'2018-10-09 06:54:33','2018-10-09 06:54:34','2f3b99d9-cb90-11e8-bda4-0242ac110002','{\"state\": {\"state\": \"1\", \"context\": \"events\", \"SyncedTo\": null, \"deviceId\": \"13\", \"SyncResult\": null, \"SyncedFrom\": null, \"CurrentSyncId\": \"4440b062-c8b0-11e8-a08b-0242ac110002\", \"CurrentSyncTo\": \"2018-10-05 15:06:41\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}}','2018-10-09 06:54:36'),(478,'1','TableByDate2','sync request',NULL,'2018-10-09 06:54:34','2018-10-09 06:54:34','2f6e869e-cb90-11e8-bda4-0242ac110002',NULL,'2018-10-09 06:54:36'),(479,'1','TableByDate2','success',NULL,'2018-10-09 06:54:34','2018-10-09 06:54:34','2f6e869e-cb90-11e8-bda4-0242ac110002','{\"state\": {\"state\": \"1\", \"context\": \"events\", \"SyncedTo\": null, \"deviceId\": \"13\", \"SyncResult\": null, \"SyncedFrom\": null, \"CurrentSyncId\": \"4440b062-c8b0-11e8-a08b-0242ac110002\", \"CurrentSyncTo\": \"2018-10-05 15:06:41\", \"CurrentSyncFrom\": \"1970-01-01 00:00:01\"}}','2018-10-09 06:54:36'),(480,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 08:41:53','2cc3d6a5-cb9f-11e8-bda4-0242ac110002',NULL,'2018-10-09 08:41:54'),(481,'1','SyncDeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 08:42:08','35d27ad4-cb9f-11e8-bda4-0242ac110002',NULL,'2018-10-09 08:42:09'),(482,'1','SyncDeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 08:42:09','366599e7-cb9f-11e8-bda4-0242ac110002',NULL,'2018-10-09 08:42:10'),(483,'1','SyncDeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 08:43:56','762faf54-cb9f-11e8-bda4-0242ac110002',NULL,'2018-10-09 08:43:57'),(484,'1','SyncDeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 08:43:57','767e0e43-cb9f-11e8-bda4-0242ac110002',NULL,'2018-10-09 08:43:58'),(485,'1','SyncDeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 08:46:53','dfc6cec6-cb9f-11e8-bda4-0242ac110002',NULL,'2018-10-09 08:46:54'),(486,'1','SyncDeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 08:48:56','28a41038-cba0-11e8-bda4-0242ac110002',NULL,'2018-10-09 08:48:57'),(487,'1','SyncDeletedRows','failed','Table \'MySqlSync.DeletedRows\' doesn\'t exist','1970-01-01 00:00:01','2018-10-09 08:48:56','28a41038-cba0-11e8-bda4-0242ac110002',NULL,'2018-10-09 08:48:57'),(488,'1','SyncDeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 08:49:29','3c7c508f-cba0-11e8-bda4-0242ac110002',NULL,'2018-10-09 08:49:30'),(489,'1','SyncDeletedRows','failed','Table \'MySqlSync.DeletedRows\' doesn\'t exist','1970-01-01 00:00:01','2018-10-09 08:49:29','3c7c508f-cba0-11e8-bda4-0242ac110002',NULL,'2018-10-09 08:49:30'),(490,'1','SyncDeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 08:49:55','4bb7d5a1-cba0-11e8-bda4-0242ac110002',NULL,'2018-10-09 08:49:56'),(491,'1','SyncDeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 08:52:39','adc5d14e-cba0-11e8-bda4-0242ac110002',NULL,'2018-10-09 08:52:40'),(492,'1','SyncDeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 08:57:03','4b07c199-cba1-11e8-bda4-0242ac110002',NULL,'2018-10-09 08:57:04'),(493,'1','SyncDeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 08:57:30','5b401fa9-cba1-11e8-bda4-0242ac110002',NULL,'2018-10-09 08:57:31'),(494,'1','SyncDeletedRows','sync request',NULL,'1970-01-01 00:00:01','2018-10-09 08:58:04','6f386940-cba1-11e8-bda4-0242ac110002',NULL,'2018-10-09 08:58:05'),(495,'1','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-10 08:31:38','e8c5c140-cc66-11e8-b504-0242ac110002',NULL,'2018-10-10 08:31:39'),(496,'100','events','sync request',NULL,'1970-01-01 00:00:01','2018-10-10 08:31:59','f4f097dc-cc66-11e8-b504-0242ac110002',NULL,'2018-10-10 08:32:00'),(497,'100','TableByDate','sync request',NULL,'1970-01-01 00:00:01','2018-10-10 08:32:13','fd23122d-cc66-11e8-b504-0242ac110002',NULL,'2018-10-10 08:32:14');
/*!40000 ALTER TABLE `SyncProtocolClients` ENABLE KEYS */;
UNLOCK TABLES;
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
-- Dumping data for table `SyncSystemLog`
--

LOCK TABLES `SyncSystemLog` WRITE;
/*!40000 ALTER TABLE `SyncSystemLog` DISABLE KEYS */;
INSERT INTO `SyncSystemLog` VALUES (1,'SyncRegisterSyncTable','00000',NULL,NULL),(2,'SyncRegisterSyncTable',NULL,'00000',NULL),(3,'SyncRegisterSyncTable',NULL,'00000',NULL),(4,'SyncRegisterSyncTable',NULL,'00000',NULL),(5,'SyncRegisterSyncTable',NULL,NULL,NULL),(6,'SyncRegisterSyncTable',NULL,'00000',NULL),(7,'SyncRegisterSyncTable',NULL,'00000',NULL),(8,'SyncRegisterSyncTable',NULL,NULL,NULL),(9,'SyncRegisterSyncTable','Duplicate entry \'holy\' for key \'TableName\'','23000',NULL),(10,'SyncRegisterSyncTable','Duplicate entry \'holy\' for key \'TableName\'','23000',NULL),(11,'SyncRegisterSyncTable','This command is not supported in the prepared statement protocol yet','HY000',NULL),(12,'SyncRegisterSyncTable','Table \'MySqlSync.DeletedRows\' doesn\'t exist','42S02','select * from DeletedRows where DeviceId = \'device_id\' and SyncLock = 1;'),(13,'SyncRegisterSyncTable','Table \'MySqlSync.DeletedRows\' doesn\'t exist','42S02','select * from DeletedRows where DeviceId = \'device_id\' and SyncLock = 1;');
/*!40000 ALTER TABLE `SyncSystemLog` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Dumping data for table `TableByDate`
--

LOCK TABLES `TableByDate` WRITE;
/*!40000 ALTER TABLE `TableByDate` DISABLE KEYS */;
INSERT INTO `TableByDate` VALUES (1,'egon','0','2018-10-08 19:17:10'),(2,'banane','sd','2018-10-09 06:01:30');
/*!40000 ALTER TABLE `TableByDate` ENABLE KEYS */;
UNLOCK TABLES;
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

--
-- Dumping data for table `TableByDate2`
--

LOCK TABLES `TableByDate2` WRITE;
/*!40000 ALTER TABLE `TableByDate2` DISABLE KEYS */;
INSERT INTO `TableByDate2` VALUES (1,'Pi','Pa','2018-10-09 06:26:02');
/*!40000 ALTER TABLE `TableByDate2` ENABLE KEYS */;
UNLOCK TABLES;
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

--
-- Dumping data for table `TableByDate3`
--

LOCK TABLES `TableByDate3` WRITE;
/*!40000 ALTER TABLE `TableByDate3` DISABLE KEYS */;
/*!40000 ALTER TABLE `TableByDate3` ENABLE KEYS */;
UNLOCK TABLES;
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

--
-- Dumping data for table `TableByIds`
--

LOCK TABLES `TableByIds` WRITE;
/*!40000 ALTER TABLE `TableByIds` DISABLE KEYS */;
INSERT INTO `TableByIds` VALUES (1,'P1',NULL),(2,'P2',NULL),(3,'3',NULL),(4,'4',NULL),(7,'NOCH NEUER',NULL),(8,'NAGELNEU',NULL),(9,'oha',NULL);
/*!40000 ALTER TABLE `TableByIds` ENABLE KEYS */;
UNLOCK TABLES;
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

--
-- Dumping data for table `TableByIds2`
--

LOCK TABLES `TableByIds2` WRITE;
/*!40000 ALTER TABLE `TableByIds2` DISABLE KEYS */;
/*!40000 ALTER TABLE `TableByIds2` ENABLE KEYS */;
UNLOCK TABLES;
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

-- Dump completed on 2020-10-25  9:11:35
