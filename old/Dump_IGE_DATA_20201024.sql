create table SyncClientConfiguration
(
    RowId    int auto_increment
        primary key,
    UserName varchar(50) not null,
    DeviceId varchar(50) not null
);

create definer = root@`%` trigger SyncClientConfiguration_after_delete
    after delete
    on SyncClientConfiguration
    for each row
BEGIN
    delete from SyncClientState where DeviceId = OLD.DeviceId;
END;

create definer = root@`%` trigger SyncClientConfiguration_after_insert
    after insert
    on SyncClientConfiguration
    for each row
BEGIN
    call SyncCreateClientState(NEW.DeviceId);
END;

create table SyncClientState
(
    DeviceId                 varchar(50)   not null,
    TableName                varchar(50)   not null,
    State                    int default 0 not null,
    SyncedFrom               timestamp     null,
    SyncedTo                 timestamp     null,
    SyncedTableChangesRowId  char(36)      null,
    CurrentSyncFrom          timestamp     null,
    CurrentSyncTo            timestamp     null,
    CurrentTableChangesRowId char(36)      null,
    CurrentSyncId            char(36)      null,
    primary key (DeviceId, TableName)
);

create table SyncConfiguration
(
    RowId           int auto_increment
        primary key,
    TableName       varchar(128)                            not null,
    SyncDirection   varchar(16)                             not null,
    SelectStatement varchar(1024)                           not null,
    SyncFromLimit   timestamp default '1970-01-01 00:00:01' not null,
    SyncOrder       int       default 1                     not null,
    SyncMode        int       default 0                     not null
);

create definer = root@`%` trigger SyncConfiguration_after_delete
    after delete
    on SyncConfiguration
    for each row
BEGIN
    delete from SyncDeletedRows where TableName = OLD.TableName;
    delete from SyncClientState where TableName = OLD.TableName;
    delete from SyncLastTableChanges where TableName = OLD.TableName;
END;

create definer = root@`%` trigger SyncConfiguration_after_insert
    after insert
    on SyncConfiguration
    for each row
BEGIN

    if not (NEW.SyncMode = '2') then
        insert into SyncLastTableChanges (TableName, LastChange)
        values (NEW.TableName, UTC_TIMESTAMP());

        call SyncCreateClientStateOnNewTable(NEW.TableName);
    end if;

END;

create table SyncDeletedRows
(
    RowId         int auto_increment
        primary key,
    TableName     varchar(128)             not null,
    DeviceId      varchar(50) default ''   not null,
    SyncLock      bit         default b'0' not null,
    InsertedIds   json                     null,
    UpdatedIds    json                     null,
    DeletedIds    json                     null,
    SyncTimestamp timestamp                null,
    RowVersion    char(36)                 null
);

create definer = root@`%` trigger SyncDeletedRows_before_insert
    before insert
    on SyncDeletedRows
    for each row
BEGIN
    set @sync = UTC_TIMESTAMP();
    set NEW.syncTimestamp = @sync;
    set NEW.RowVersion = UUID();
    update SyncLastTableChanges set LastChange = @sync where TableName = "DeletedRows";
END;

create definer = root@`%` trigger SyncDeletedRows_before_update
    before update
    on SyncDeletedRows
    for each row
BEGIN
    set @sync = UTC_TIMESTAMP();
    set NEW.syncTimestamp = @sync;
    set NEW.RowVersion = UUID();
    update SyncLastTableChanges set LastChange = @sync where TableName = "DeletedRows";
END;

create table SyncLastTableChanges
(
    RowId      int auto_increment
        primary key,
    TableName  varchar(128) not null,
    LastChange timestamp    not null,
    RowVersion char(36)     null,
    constraint TableName
        unique (TableName)
);

create definer = root@`%` trigger SyncLastTableChanges_before_insert
    before insert
    on SyncLastTableChanges
    for each row
BEGIN
    set NEW.RowVersion = UUID();
END;

create definer = root@`%` trigger SyncLastTableChanges_before_update
    before update
    on SyncLastTableChanges
    for each row
BEGIN
    set NEW.RowVersion = UUID();
END;

create table SyncProtocolClients
(
    RowId        int auto_increment
        primary key,
    DeviceId     varchar(50)   null,
    TableName    varchar(50)   null,
    State        varchar(50)   null,
    Error        varchar(1024) null,
    SyncFrom     timestamp     null,
    SyncTo       timestamp     null,
    SyncId       char(36)      null,
    SyncResponse json          null,
    InsertedOn   timestamp     null
);

create definer = root@`%` trigger SyncProtocolClients_before_insert
    before insert
    on SyncProtocolClients
    for each row
BEGIN
    SET NEW.InsertedOn = UTC_TIMESTAMP();
END;

create table SyncSystemLog
(
    RowId      int auto_increment
        primary key,
    Context    varchar(50) not null,
    Message    text        null,
    Code       char(5)     null,
    SqlCommand text        null
);

create
    definer = root@`%` procedure SyncCreateClientStateOnNewTable(IN table_name varchar(50))
BEGIN

    DECLARE done INT DEFAULT FALSE;
    declare deviceId varchar(50) DEFAULT null;
    DECLARE deviceCursor CURSOR FOR SELECT sc.DeviceId FROM SyncClientConfiguration sc;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN deviceCursor;

    read_loop:
    LOOP
        FETCH deviceCursor INTO deviceId;

        IF done THEN
            LEAVE read_loop;
        END IF;

        if not exists(
                SELECT * FROM SyncClientState scs WHERE scs.TableName = table_name and scs.DeviceId = deviceId) then
            insert into SyncClientState (DeviceId, TableName, State) values (deviceId, table_name, 0);
        END IF;

    END LOOP;

    CLOSE deviceCursor;

END;

create
    definer = root@`%` procedure SyncCreateDeletedRowForDevices(IN table_name varchar(50), IN row_id int)
BEGIN

    DECLARE done INT DEFAULT FALSE;
    DECLARE device VARCHAR(50);
    DECLARE rowVersion CHAR(36);
    DECLARE deviceCursor CURSOR FOR SELECT cs.DeviceId FROM SyncClientState cs where TableName = table_name;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN deviceCursor;

    read_loop:
    LOOP
        FETCH deviceCursor INTO device;

        IF done THEN
            LEAVE read_loop;
        END IF;

        if exists(SELECT *
                  FROM SyncDeletedRows dr
                  WHERE dr.TableName = table_name and dr.DeviceId = device and dr.SyncLock = false) then
            update SyncDeletedRows
            set DeletedIds = JSON_ARRAY_INSERT(DeletedIds, '$[0]', row_id)
            where TableName = table_name
              and DeviceId = device
              and SyncLock = false;
        else
            insert into SyncDeletedRows (TableName, DeviceId, InsertedIds, UpdatedIds, DeletedIds)
            values (table_name, device, '[]', '[]', JSON_ARRAY(row_id));
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

END;

create
    definer = root@`%` procedure SyncCreateInsertedRowForDevices(IN table_name varchar(128), IN row_id int)
BEGIN

    DECLARE done INT DEFAULT FALSE;
    DECLARE device VARCHAR(50);
    DECLARE rowVersion CHAR(36);
    DECLARE deviceCursor CURSOR FOR SELECT cs.DeviceId FROM SyncClientState cs where TableName = table_name;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN deviceCursor;

    read_loop:
    LOOP
        FETCH deviceCursor INTO device;

        IF done THEN
            LEAVE read_loop;
        END IF;

        if exists(SELECT *
                  FROM SyncDeletedRows dr
                  WHERE dr.TableName = table_name and dr.DeviceId = device and dr.SyncLock = false) then
            update SyncDeletedRows
            set InsertedIds = JSON_ARRAY_INSERT(InsertedIds, '$[0]', row_id)
            where TableName = table_name
              and DeviceId = device
              and SyncLock = false;
        else
            insert into SyncDeletedRows (TableName, DeviceId, InsertedIds, UpdatedIds, DeletedIds)
            values (table_name, device, JSON_ARRAY(row_id), '[]', '[]');
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

END;

create
    definer = root@`%` procedure SyncCreateUpdatedRowForDevices(IN table_name varchar(128), IN row_id int)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE device VARCHAR(50);
    DECLARE rowVersion CHAR(36);
    DECLARE deviceCursor CURSOR FOR SELECT cs.DeviceId FROM SyncClientState cs where TableName = table_name;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN deviceCursor;

    read_loop:
    LOOP
        FETCH deviceCursor INTO device;

        IF done THEN
            LEAVE read_loop;
        END IF;

        if exists(SELECT *
                  FROM SyncDeletedRows dr
                  WHERE dr.TableName = table_name and dr.DeviceId = device and dr.SyncLock = false) then
            update SyncDeletedRows
            set UpdatedIds = JSON_ARRAY_INSERT(UpdatedIds, '$[0]', row_id)
            where TableName = table_name
              and DeviceId = device
              and SyncLock = false;
        else
            insert into SyncDeletedRows (TableName, DeviceId, InsertedIds, UpdatedIds, DeletedIds)
            values (table_name, device, '[]', JSON_ARRAY(row_id), '[]');
        end if;

    END LOOP;

    CLOSE deviceCursor;

    update SyncLastTableChanges set LastChange = UTC_TIMESTAMP() where TableName = "DeletedRows";

END;

create
    definer = root@`%` procedure SyncGetTablesToSync(IN device_id varchar(50))
BEGIN

    IF (NULLIF(device_id, '') IS NULL) THEN
        call device_id_missing();
    end if;

    SELECT t.*,
           sc.SyncMode,
           sc.SyncOrder
    FROM SyncLastTableChanges t
             inner join SyncConfiguration sc
                        on t.TableName = sc.TableName
             left join SyncClientState c
                       on t.TableName = c.TableName and c.deviceId = device_id
    WHERE c.DeviceId = device_id
--    (t.LastChange>= c.SyncedTo or 
--    c.SyncedTo is null)
--  and
--    (c.DeviceId = device_id or
--    c.DeviceId is null)
      and (not c.SyncedTableChangesRowId = t.RowVersion or
           c.SyncedTableChangesRowId is null)
    order by sc.SyncOrder, sc.SyncMode, sc.TableName;

END;

create
    definer = root@`%` procedure SyncInsertOrUpdateClientState(IN device_id varchar(50), IN table_name varchar(128),
                                                               IN sync_from timestamp, IN sync_to timestamp,
                                                               IN new_state int, IN sync_id char(36))
BEGIN

    -- das sollte nicht bei jedem sync gecheckt werden.
-- ein initializer kann die datensaetze fur den client anlegen
    declare tableChangesRowId char(36);

    select RowVersion into tableChangesRowId from SyncLastTableChanges t where t.TableName = table_name;

    if not isnull(tableChangesRowId) then
        if (new_state = 1) THEN


            -- sync request
            IF EXISTS(select * from SyncClientState where DeviceId = device_id and TableName = table_name) THEN

                update SyncClientState
                set State                    = new_state,
                    CurrentSyncFrom          = sync_from,
                    CurrentSyncTo            = sync_to,
                    CurrentSyncId            = sync_id,
                    CurrentTableChangesRowId = tableChangesRowId
                where DeviceId = device_id
                  and TableName = table_name;

            ELSE

                insert into SyncClientState
                (DeviceId, TableName, CurrentSyncFrom, CurrentSyncTo, State, CurrentSyncId, CurrentTableChangesRowId)
                values (device_id, table_name, sync_from, sync_to, new_state, sync_id, tableChangesRowId);

            end if;

        elseif (new_state = 3) then

            -- do not update timestamp within errors
            IF EXISTS(select * from SyncClientState where DeviceId = device_id and TableName = table_name) THEN

                update SyncClientState
                set State = new_state
                where DeviceId = device_id
                  and TableName = table_name;

            ELSE

                insert into SyncClientState
                    (DeviceId, TableName, State)
                values (device_id, table_name, new_state);

            end if;

        end if;

    end if;

END;

create
    definer = root@`%` procedure SyncPullRequest(IN device_id varchar(50), IN table_name varchar(128), IN log_level int)
BEGIN

    /* Sync state
    1 = start sync
    2 = done ( Must be set by client )
    3 = error
  */

    DECLARE exit handler for sqlexception
        BEGIN

            GET DIAGNOSTICS @num = NUMBER;
            GET DIAGNOSTICS CONDITION @num @message = MESSAGE_TEXT, @errNo = RETURNED_SQLSTATE;

            ROLLBACK;

            insert into SyncSystemLog (Context, Message, Code, SqlCommand)
            values ('SyncRegisterSyncTable', @message, @errNo, @sql_text);

            if (log_level <= 3) THEN
                -- Protocol
                insert into SyncProtocolClients (DeviceId, TableName, State, Error, SyncFrom, SyncTo, SyncId)
                values (device_id, table_name, 'failed', @message, @lastClientSync, @currentUtc, @guid);
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

    if exists(select * from SyncClientState where DeviceId = device_id and TableName = table_name) THEN
        set @lastClientSync =
                (select SyncedTo from SyncClientState where DeviceId = device_id and TableName = table_name);
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
        insert into SyncProtocolClients (DeviceId, TableName, State, SyncFrom, SyncTo, SyncId)
        values (device_id, table_name, 'sync request', @lastClientSync, @currentUtc, @guid);
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

END;

create
    definer = root@`%` procedure SyncPullResponse(IN device_id varchar(50), IN table_name varchar(128),
                                                  IN new_state int, IN current_sync_id char(36), IN sync_response json)
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
    IF EXISTS(select *
              from SyncClientState
              where CurrentSyncId = current_sync_id
                and DeviceId = device_id
                and TableName = table_name
                and State = 1) THEN

        -- get from an to sync timestamp from client state table  
        select cs.CurrentSyncFrom, cs.CurrentSyncTo
        into @syncFrom, @syncTo
        from SyncClientState cs
        where CurrentSyncId = current_sync_id
          and DeviceId = device_id
          and TableName = table_name;

        if (new_state = 3) then
            -- update client state with error
            update
                SyncClientState
            set State = new_state
            where CurrentSyncId = current_sync_id
              and DeviceId = device_id
              and TableName = table_name;
        else
            -- update client state
            update
                SyncClientState
            set State                    = new_state,
                SyncedFrom               = CurrentSyncFrom,
                SyncedTo                 = CurrentSyncTo,
                SyncedTableChangesRowId  = CurrentTableChangesRowId,
                CurrentSyncId            = null,
                CurrentSyncFrom          = null,
                CurrentSyncTo            = null,
                CurrentTableChangesRowId = null
            where CurrentSyncId = current_sync_id
              and DeviceId = device_id
              and TableName = table_name;
        end if;

        -- Protocol 
        insert into SyncProtocolClients (DeviceId, TableName, State, SyncFrom, SyncTo, SyncId, SyncResponse)
        values (device_id, table_name, 'success', @syncFrom, @syncTo, current_sync_id, sync_response);

        SELECT 'success' as SpResult;

    ELSE
        -- no response without request. Therefore only log this bad request

        -- Protocol 
        insert into SyncProtocolClients (DeviceId, TableName, State, SyncFrom, SyncTo, SyncId, SyncResponse)
        values (device_id, table_name, 'wrong response', @syncFrom, @syncTo, current_sync_id, sync_response);

        SELECT 'wrong response' as SpResult;
        -- call error('wrong response');

    end if;

END;

create
    definer = root@`%` procedure SyncResetClientState(IN device_id varchar(50), IN table_name varchar(128))
BEGIN

    if NULLIF(table_name, '') is null then

        update SyncClientState
        set SyncedFrom               = null,
            SyncedTo                 = null,
            SyncedTableChangesRowId  = null,
            CurrentSyncFrom          = null,
            CurrentSyncTo            = null,
            CurrentTableChangesRowId = null,
            CurrentSyncId            = null
        where DeviceId = device_id;

    else
        --    select cc.UserName into @tmpUserName from SyncClientConfiguration cc where DeviceId = device_id;  
--    delete from SyncClientConfiguration where DeviceId = device_id;
--    insert into SyncClientConfiguration (UserName, DeviceId) values (@tmpUserName, device_id);
        update SyncClientState
        set SyncedFrom               = null,
            SyncedTo                 = null,
            SyncedTableChangesRowId  = null,
            CurrentSyncFrom          = null,
            CurrentSyncTo            = null,
            CurrentTableChangesRowId = null,
            CurrentSyncId            = null
        where DeviceId = device_id
          and TableName = table_name;


    end if;

    insert into SyncProtocolClients (DeviceId, TableName, State, SyncFrom, SyncTo, SyncId, SyncResponse)
    values (device_id, table_name, 'Client state reset', null, null, null, null);

END;

create
    definer = root@`%` procedure Sync_Test()
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
    call SyncPullRequest(@device_id, @table_name, 1);


-- response
    select CurrentSyncId
    into @current_sync_id
    from SyncClientState
    where deviceId = @device_id and TableName = @table_name;
    call SyncPullResponse(@device_id, @table_name, 2, @current_sync_id, @json);

END;


