-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server Version:               8.0.12 - MySQL Community Server - GPL
-- Server Betriebssystem:        Linux
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Exportiere Struktur von Tabelle IGE_DATA.SyncClientConfiguration
DROP TABLE IF EXISTS `SyncClientConfiguration`;
CREATE TABLE IF NOT EXISTS `SyncClientConfiguration` (
  `RowId` int(11) NOT NULL AUTO_INCREMENT,
  `UserName` varchar(50) NOT NULL,
  `DeviceId` varchar(50) NOT NULL,
  PRIMARY KEY (`RowId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Daten Export vom Benutzer nicht ausgewählt
-- Exportiere Struktur von Tabelle IGE_DATA.SyncClientState
DROP TABLE IF EXISTS `SyncClientState`;
CREATE TABLE IF NOT EXISTS `SyncClientState` (
  `DeviceId` varchar(50) NOT NULL,
  `TableName` varchar(50) NOT NULL,
  `State` int(11) NOT NULL DEFAULT '0',
  `SyncedFrom` timestamp NULL DEFAULT NULL,
  `SyncedTo` timestamp NULL DEFAULT NULL,
  `SyncedTableChangesRowId` char(36) DEFAULT NULL,
  `CurrentSyncFrom` timestamp NULL DEFAULT NULL,
  `CurrentSyncTo` timestamp NULL DEFAULT NULL,
  `CurrentTableChangesRowId` char(36) DEFAULT NULL,
  `CurrentSyncId` char(36) DEFAULT NULL,
  PRIMARY KEY (`DeviceId`,`TableName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Daten Export vom Benutzer nicht ausgewählt
-- Exportiere Struktur von Tabelle IGE_DATA.SyncConfiguration
DROP TABLE IF EXISTS `SyncConfiguration`;
CREATE TABLE IF NOT EXISTS `SyncConfiguration` (
  `RowId` int(11) NOT NULL AUTO_INCREMENT,
  `TableName` varchar(128) NOT NULL,
  `SyncDirection` varchar(16) NOT NULL,
  `SelectStatement` varchar(1024) NOT NULL,
  `SyncFromLimit` timestamp NOT NULL DEFAULT '1970-01-01 00:00:01',
  `SyncOrder` int(11) NOT NULL DEFAULT '1',
  `SyncMode` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`RowId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Daten Export vom Benutzer nicht ausgewählt
-- Exportiere Struktur von Prozedur IGE_DATA.SyncCreateClientState
DROP PROCEDURE IF EXISTS `SyncCreateClientState`;
DELIMITER //
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

    if not exists (SELECT * FROM SyncClientState scs WHERE scs.TableName = tableName and scs.DeviceId = device_id) then
      insert into SyncClientState (DeviceId, TableName, State) values (device_id, tableName, 0);
    END IF;
      
  END LOOP;

  CLOSE tableCursor;
    
END//
DELIMITER ;

-- Exportiere Struktur von Prozedur IGE_DATA.SyncCreateClientStateOnNewTable
DROP PROCEDURE IF EXISTS `SyncCreateClientStateOnNewTable`;
DELIMITER //
CREATE DEFINER=`root`@`%` PROCEDURE `SyncCreateClientStateOnNewTable`(
	IN `table_name` VARCHAR(50)

)
BEGIN

  DECLARE done INT DEFAULT FALSE;
  declare deviceId varchar(50) DEFAULT null;
  DECLARE deviceCursor CURSOR FOR SELECT sc.DeviceId FROM SyncClientConfiguration sc;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN deviceCursor;

  read_loop: LOOP
    FETCH deviceCursor INTO deviceId;

    IF done THEN
      LEAVE read_loop;
    END IF;

    if not exists (SELECT * FROM SyncClientState scs WHERE scs.TableName = table_name and scs.DeviceId = deviceId) then
      insert into SyncClientState (DeviceId, TableName, State) values (deviceId, table_name, 0);
    END IF;
      
  END LOOP;

  CLOSE deviceCursor;
    
END//
DELIMITER ;

-- Exportiere Struktur von Prozedur IGE_DATA.SyncCreateDeletedRowForDevices
DROP PROCEDURE IF EXISTS `SyncCreateDeletedRowForDevices`;
DELIMITER //
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
    
END//
DELIMITER ;

-- Exportiere Struktur von Prozedur IGE_DATA.SyncCreateInsertedRowForDevices
DROP PROCEDURE IF EXISTS `SyncCreateInsertedRowForDevices`;
DELIMITER //
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
    
END//
DELIMITER ;

-- Exportiere Struktur von Prozedur IGE_DATA.SyncCreateUpdatedRowForDevices
DROP PROCEDURE IF EXISTS `SyncCreateUpdatedRowForDevices`;
DELIMITER //
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

END//
DELIMITER ;

-- Exportiere Struktur von Tabelle IGE_DATA.SyncDeletedRows
DROP TABLE IF EXISTS `SyncDeletedRows`;
CREATE TABLE IF NOT EXISTS `SyncDeletedRows` (
  `RowId` int(11) NOT NULL AUTO_INCREMENT,
  `TableName` varchar(128) NOT NULL,
  `DeviceId` varchar(50) NOT NULL DEFAULT '',
  `SyncLock` bit(1) NOT NULL DEFAULT b'0',
  `InsertedIds` json DEFAULT NULL,
  `UpdatedIds` json DEFAULT NULL,
  `DeletedIds` json DEFAULT NULL,
  `SyncTimestamp` timestamp NULL DEFAULT NULL,
  `RowVersion` char(36) DEFAULT NULL,
  PRIMARY KEY (`RowId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Daten Export vom Benutzer nicht ausgewählt
-- Exportiere Struktur von Prozedur IGE_DATA.SyncGetTablesToSync
DROP PROCEDURE IF EXISTS `SyncGetTablesToSync`;
DELIMITER //
CREATE DEFINER=`root`@`%` PROCEDURE `SyncGetTablesToSync`(
	IN `device_id` VARCHAR(50)

















)
BEGIN

  IF (NULLIF(device_id, '') IS NULL) THEN
    call device_id_missing();
  end if;
  
  SELECT
    t.*, sc.SyncMode, sc.SyncOrder
  FROM 
    SyncLastTableChanges t inner join SyncConfiguration sc
      on t.TableName = sc.TableName
    left join SyncClientState c
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
  order by sc.SyncOrder, sc.SyncMode, sc.TableName;
  
END//
DELIMITER ;

-- Exportiere Struktur von Prozedur IGE_DATA.SyncInsertOrUpdateClientState
DROP PROCEDURE IF EXISTS `SyncInsertOrUpdateClientState`;
DELIMITER //
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
  
END//
DELIMITER ;

-- Exportiere Struktur von Tabelle IGE_DATA.SyncLastTableChanges
DROP TABLE IF EXISTS `SyncLastTableChanges`;
CREATE TABLE IF NOT EXISTS `SyncLastTableChanges` (
  `RowId` int(11) NOT NULL AUTO_INCREMENT,
  `TableName` varchar(128) NOT NULL,
  `LastChange` timestamp NOT NULL,
  `RowVersion` char(36) DEFAULT NULL,
  PRIMARY KEY (`RowId`),
  UNIQUE KEY `TableName` (`TableName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Daten Export vom Benutzer nicht ausgewählt
-- Exportiere Struktur von Tabelle IGE_DATA.SyncProtocolClients
DROP TABLE IF EXISTS `SyncProtocolClients`;
CREATE TABLE IF NOT EXISTS `SyncProtocolClients` (
  `RowId` int(11) NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Daten Export vom Benutzer nicht ausgewählt
-- Exportiere Struktur von Prozedur IGE_DATA.SyncPullRequest
DROP PROCEDURE IF EXISTS `SyncPullRequest`;
DELIMITER //
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

END//
DELIMITER ;

-- Exportiere Struktur von Prozedur IGE_DATA.SyncPullResponse
DROP PROCEDURE IF EXISTS `SyncPullResponse`;
DELIMITER //
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
    
    if (new_state = 3) then
      -- update client state with error
      update 
        SyncClientState 
      set 
        State = new_state
      where
        CurrentSyncId = current_sync_id and DeviceId = device_id and TableName = table_name;    
    else
      -- update client state
      update 
        SyncClientState 
      set 
        State = new_state, SyncedFrom = CurrentSyncFrom, SyncedTo = CurrentSyncTo, SyncedTableChangesRowId = CurrentTableChangesRowId,
        CurrentSyncId = null, CurrentSyncFrom = null, CurrentSyncTo = null, CurrentTableChangesRowId = null
      where
        CurrentSyncId = current_sync_id and DeviceId = device_id and TableName = table_name;
    end if;
      
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
     
END//
DELIMITER ;

-- Exportiere Struktur von Prozedur IGE_DATA.SyncResetClientState
DROP PROCEDURE IF EXISTS `SyncResetClientState`;
DELIMITER //
CREATE DEFINER=`root`@`%` PROCEDURE `SyncResetClientState`(
	IN `device_id` VARCHAR(50),
	IN `table_name` VARCHAR(128)



)
BEGIN

  if NULLIF(table_name,'') is null then

    update SyncClientState set 
      SyncedFrom = null, SyncedTo = null,
      SyncedTableChangesRowId = null, CurrentSyncFrom = null, CurrentSyncTo = null,
      CurrentTableChangesRowId = null, CurrentSyncId = null
    where 
      DeviceId = device_id;

  else    
--    select cc.UserName into @tmpUserName from SyncClientConfiguration cc where DeviceId = device_id;  
--    delete from SyncClientConfiguration where DeviceId = device_id;
--    insert into SyncClientConfiguration (UserName, DeviceId) values (@tmpUserName, device_id);
    update SyncClientState set 
      SyncedFrom = null, SyncedTo = null,
      SyncedTableChangesRowId = null, CurrentSyncFrom = null, CurrentSyncTo = null,
      CurrentTableChangesRowId = null, CurrentSyncId = null
    where 
      DeviceId = device_id and TableName = table_name;
    

  end if;

  insert into 
    SyncProtocolClients (DeviceId, TableName, State, SyncFrom, SyncTo, SyncId, SyncResponse)
  values
    (device_id, table_name, 'Client state reset', null, null, null, null);

END//
DELIMITER ;

-- Exportiere Struktur von Tabelle IGE_DATA.SyncSystemLog
DROP TABLE IF EXISTS `SyncSystemLog`;
CREATE TABLE IF NOT EXISTS `SyncSystemLog` (
  `RowId` int(11) NOT NULL AUTO_INCREMENT,
  `Context` varchar(50) NOT NULL,
  `Message` text,
  `Code` char(5) DEFAULT NULL,
  `SqlCommand` text,
  PRIMARY KEY (`RowId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Daten Export vom Benutzer nicht ausgewählt
-- Exportiere Struktur von Trigger IGE_DATA.SyncClientConfiguration_after_delete
DROP TRIGGER IF EXISTS `SyncClientConfiguration_after_delete`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `SyncClientConfiguration_after_delete` AFTER DELETE ON `SyncClientConfiguration` FOR EACH ROW BEGIN
  delete from SyncClientState where DeviceId = OLD.DeviceId;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Exportiere Struktur von Trigger IGE_DATA.SyncClientConfiguration_after_insert
DROP TRIGGER IF EXISTS `SyncClientConfiguration_after_insert`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `SyncClientConfiguration_after_insert` AFTER INSERT ON `SyncClientConfiguration` FOR EACH ROW BEGIN
  call SyncCreateClientState(NEW.DeviceId);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Exportiere Struktur von Trigger IGE_DATA.SyncConfiguration_after_delete
DROP TRIGGER IF EXISTS `SyncConfiguration_after_delete`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `SyncConfiguration_after_delete` AFTER DELETE ON `SyncConfiguration` FOR EACH ROW BEGIN
  delete from SyncDeletedRows where TableName = OLD.TableName; 
  delete from SyncClientState where TableName = OLD.TableName; 
  delete from SyncLastTableChanges where TableName = OLD.TableName;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Exportiere Struktur von Trigger IGE_DATA.SyncConfiguration_after_insert
DROP TRIGGER IF EXISTS `SyncConfiguration_after_insert`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `SyncConfiguration_after_insert` AFTER INSERT ON `SyncConfiguration` FOR EACH ROW BEGIN

  if not (NEW.SyncMode = '2') then
    insert into 
      SyncLastTableChanges ( TableName, LastChange )
    values 
      (NEW.TableName, UTC_TIMESTAMP() );
      
    call SyncCreateClientStateOnNewTable(NEW.TableName);
  end if;
  
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Exportiere Struktur von Trigger IGE_DATA.SyncDeletedRows_before_insert
DROP TRIGGER IF EXISTS `SyncDeletedRows_before_insert`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `SyncDeletedRows_before_insert` BEFORE INSERT ON `SyncDeletedRows` FOR EACH ROW BEGIN
    set @sync = UTC_TIMESTAMP();
    set NEW.syncTimestamp = @sync;
    set NEW.RowVersion = UUID();
    update SyncLastTableChanges set LastChange = @sync where TableName = "DeletedRows";
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Exportiere Struktur von Trigger IGE_DATA.SyncDeletedRows_before_update
DROP TRIGGER IF EXISTS `SyncDeletedRows_before_update`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `SyncDeletedRows_before_update` BEFORE UPDATE ON `SyncDeletedRows` FOR EACH ROW BEGIN
    set @sync = UTC_TIMESTAMP();
    set NEW.syncTimestamp = @sync;
    set NEW.RowVersion = UUID();
    update SyncLastTableChanges set LastChange = @sync where TableName = "DeletedRows";
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Exportiere Struktur von Trigger IGE_DATA.SyncLastTableChanges_before_insert
DROP TRIGGER IF EXISTS `SyncLastTableChanges_before_insert`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `SyncLastTableChanges_before_insert` BEFORE INSERT ON `SyncLastTableChanges` FOR EACH ROW BEGIN
set NEW.RowVersion = UUID();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Exportiere Struktur von Trigger IGE_DATA.SyncLastTableChanges_before_update
DROP TRIGGER IF EXISTS `SyncLastTableChanges_before_update`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `SyncLastTableChanges_before_update` BEFORE UPDATE ON `SyncLastTableChanges` FOR EACH ROW BEGIN
set NEW.RowVersion = UUID();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Exportiere Struktur von Trigger IGE_DATA.SyncProtocolClients_before_insert
DROP TRIGGER IF EXISTS `SyncProtocolClients_before_insert`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `SyncProtocolClients_before_insert` BEFORE INSERT ON `SyncProtocolClients` FOR EACH ROW BEGIN
  SET NEW.InsertedOn = UTC_TIMESTAMP();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
