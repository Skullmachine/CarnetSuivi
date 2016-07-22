------------------------------------------------------------------------------------------------
-- Setup START
-- Demo runs on my laptop in < 1 minute (ok on SSD)
-- You'll need 200MB space
------------------------------------------------------------------------------------------------

USE master
GO

IF EXISTS ( SELECT * FROM sys.databases WHERE name = 'tooManyPartitionsTest' )
    ALTER DATABASE tooManyPartitionsTest SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
IF EXISTS ( SELECT * FROM sys.databases WHERE name = 'tooManyPartitionsTest' )
    DROP DATABASE tooManyPartitionsTest 
GO
CREATE DATABASE tooManyPartitionsTest
GO

ALTER DATABASE tooManyPartitionsTest SET RECOVERY SIMPLE
GO

-- Add 7 filegroups with 4 files each
-- Add 365 files and filegroup
DECLARE @fg INT = 0, @f INT = 0, @sql NVARCHAR(MAX)

WHILE @fg < 7
BEGIN

    SET @fg += 1
    SET @sql = 'ALTER DATABASE tooManyPartitionsTest ADD FILEGROUP tooManyPartitionsTestFg' + CAST( @fg AS VARCHAR(5) )

    -- Add the filegroup
    PRINT @sql
    EXEC(@sql)


    -- Initialise
    SET @f = 0

    WHILE @f < 4
    BEGIN

        SET @f += 1
        --!!WARNING!! DON'T USE THESE SETTINGS IN PRODUCTION.  3MB starting size and 1MB filegrowth are just for demo - would be extremely painful for live data
        SET @sql = 'ALTER DATABASE tooManyPartitionsTest ADD FILE ( NAME = N''tooManyPartitionsTestFile@f_@fg'', FILENAME = N''s:\temp\tooManyPartitionsTestFile@f_@fg.ndf'', SIZE = 3MB, FILEGROWTH = 1MB ) TO FILEGROUP [tooManyPartitionsTestFg@fg]'
        SET @sql = REPLACE ( @sql, '@fg', @fg )
        SET @sql = REPLACE ( @sql, '@f', @f )

        -- Add the file
        PRINT @sql
        EXEC(@sql)

    END

END
GO


USE tooManyPartitionsTest
GO

SELECT * FROM sys.filegroups
SELECT * FROM sys.database_files 
GO

-- Generate partition function with ~3 years worth of daily partitions from 1 Jan 2014.
DECLARE @bigString NVARCHAR(MAX) = ''

;WITH cte AS (
SELECT CAST( '30 Apr 2014' AS DATE ) testDate
UNION ALL
SELECT DATEADD( day, 1, testDate )
FROM cte
WHERE testDate < '31 Dec 2016'
)
SELECT @bigString += ',' + QUOTENAME( CONVERT ( VARCHAR, testDate, 106 ), '''' )
FROM cte
OPTION ( MAXRECURSION 1100 )

SELECT @bigString = 'CREATE PARTITION FUNCTION pf_test (DATE) AS RANGE RIGHT FOR VALUES ( ' + STUFF( @bigString, 1, 1, '' ) + ' )'
SELECT @bigString bs

-- Create the partition function
PRINT @bigString
EXEC ( @bigString )
GO

/*
-- Look at the boundaries
SELECT *
FROM sys.partition_range_values
WHERE function_id = ( SELECT function_id FROM sys.partition_functions WHERE name = 'pf_test' )
GO
*/

DECLARE @bigString NVARCHAR(MAX) = ''

;WITH cte AS (
SELECT ROW_NUMBER() OVER( ORDER BY boundary_id ) rn
FROM sys.partition_range_values
WHERE function_id = ( SELECT function_id FROM sys.partition_functions WHERE name = 'pf_test' )
UNION ALL 
SELECT 1    -- additional row required for fg
)
SELECT @bigString += ',' + '[tooManyPartitionsTestFg' + CAST( ( rn % 7 ) + 1 AS VARCHAR(5) ) + ']'
FROM cte
OPTION ( MAXRECURSION 1100 )

SELECT @bigString = 'CREATE PARTITION SCHEME ps_test AS PARTITION pf_test TO ( ' + STUFF( @bigString, 1, 1, '' ) + ' )'
PRINT @bigString
EXEC ( @bigString )
GO




IF OBJECT_ID('dbo.yourLog') IS NULL
CREATE TABLE dbo.yourLog ( 
    logId       INT IDENTITY,
    someDate    DATETIME2 NOT NULL,
    someData    UNIQUEIDENTIFIER DEFAULT NEWID(),
    dateAdded   DATETIME DEFAULT GETDATE(), 
    addedBy     VARCHAR(30) DEFAULT SUSER_NAME(), 

    -- Computed column for partitioning?
    partitionDate AS CAST( someDate AS DATE ) PERSISTED,

    CONSTRAINT pk_yourLog PRIMARY KEY ( logId, partitionDate )  -- << !!TODO try other way round

    ) ON [ps_test]( partitionDate )
GO


IF OBJECT_ID('dbo.yourAcks') IS NULL
CREATE TABLE dbo.yourAcks ( 
    ackId           INT IDENTITY(100000,1),
    logId           INT NOT NULL,
    partitionDate   DATE NOT NULL

    CONSTRAINT pk_yourAcks PRIMARY KEY ( ackId, logId, partitionDate )  

    ) ON [ps_test]( partitionDate )
GO



IF OBJECT_ID('dbo.yourLogSwitch') IS NULL
CREATE TABLE dbo.yourLogSwitch ( 
    logId       INT IDENTITY,
    someDate    DATETIME2 NOT NULL,
    someData    UNIQUEIDENTIFIER DEFAULT NEWID(),
    dateAdded   DATETIME DEFAULT GETDATE(), 
    addedBy     VARCHAR(30) DEFAULT SUSER_NAME(), 

    -- Computed column for partitioning?
    partitionDate AS CAST( someDate AS DATE ) PERSISTED,

    CONSTRAINT pk_yourLogSwitch PRIMARY KEY ( logId, partitionDate )

    ) ON [ps_test]( partitionDate )
GO
-- Setup END
------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------
-- Data START
------------------------------------------------------------------------------------------------

-- OK load up data for Jan 2014 to today.
DECLARE @startDate DATETIME = '1 Jan 2014', @rand INT 

WHILE @startDate < GETDATE()
BEGIN

    -- Add between 1 and 10,000 rows to dbo.yourLog for today
    SET @rand = RAND() * 10000

    ;WITH cte AS (
    SELECT TOP 10000 ROW_NUMBER() OVER ( ORDER BY ( SELECT 1 ) ) rn
    FROM master.sys.columns c1
        CROSS JOIN master.sys.columns c2
        CROSS JOIN master.sys.columns c3
    )
    INSERT INTO dbo.yourLog (someDate)
    SELECT TOP(@rand) DATEADD( second, rn % 30000, @startDate )
    FROM cte

    -- Add most of the Acks
    INSERT INTO dbo.yourAcks ( logId, partitionDate )
    SELECT TOP 70 PERCENT logId, partitionDate
    FROM dbo.yourLog
    WHERE partitionDate = @startDate

    SET @startDate = DATEADD( day, 1, @startDate )

    CHECKPOINT

END
GO

-- Have a look at the data we've loaded
SELECT 'before yourLog' s, COUNT(*) records, MIN(someDate) minDate, MAX(someDate) maxDate FROM dbo.yourLog 
SELECT 'before yourAcks' s, COUNT(*) records, MIN(partitionDate) minDate, MAX(partitionDate) maxDate FROM dbo.yourAcks

-- You'll see how pre-May data is initially clumped together
SELECT 'before $partition' s, $PARTITION.pf_test( partitionDate ) p, MIN(partitionDate) xMinDate, MAX(partitionDate) xMaxDate, COUNT(*) AS records
FROM dbo.yourLog WITH(NOLOCK) 
GROUP BY $PARTITION.pf_test( partitionDate ) 
ORDER BY xMinDate
GO

-- Data END
------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------
-- Maintenance START
------------------------------------------------------------------------------------------------

-- Oh man, we're behind with our switching and truncation.
-- Create a job that sweeps up.  Do we get blocking?

-- ALTER TABLE dbo.yourLog SWITCH PARTITION 1 TO dbo.yourLogSwitch PARTITION 1
-- TRUNCATE TABLE dbo.yourLogSwitch

-- Let's pretend we only want to maintain up to 30 days ago
DECLARE @testDate DATE
SET @testDate = DATEADD( day, -30, GETDATE() )

-- Create local fast_forward ( forward-only, read-only ) cursor 
DECLARE partitions_cursor CURSOR FAST_FORWARD LOCAL FOR 
SELECT boundary_id, CAST( value AS DATE )
FROM sys.partition_range_values
WHERE function_id = ( SELECT function_id FROM sys.partition_functions WHERE name = 'pf_test' )
  AND value < @testDate

-- Cursor variables
DECLARE @boundary_id INT, @value DATE, @sql NVARCHAR(MAX)

OPEN partitions_cursor

FETCH NEXT FROM partitions_cursor INTO @boundary_id, @value
WHILE @@fetch_status = 0
BEGIN

    -- Switch out and truncate old partition
    SET @sql = 'ALTER TABLE dbo.yourLog SWITCH PARTITION ' + CAST( @boundary_id AS VARCHAR(5) ) + ' TO dbo.yourLogSwitch PARTITION ' + CAST( @boundary_id AS VARCHAR(5) )

    PRINT @sql
    EXEC(@sql)

    -- You could move the data elsewhere from here or just empty it out
    TRUNCATE TABLE dbo.yourLogSwitch

    --!!TODO yourAcks table

    FETCH NEXT FROM partitions_cursor INTO @boundary_id, @value
END

CLOSE partitions_cursor
DEALLOCATE partitions_cursor
GO

-- Maintenance END
------------------------------------------------------------------------------------------------



-- Have a look at the data we've maintained
SELECT 'after yourLog' s, COUNT(*) records, MIN(someDate) minDate, MAX(someDate) maxDate FROM dbo.yourLog 
SELECT 'after yourAcks' s, COUNT(*) records, MIN(partitionDate) minDate, MAX(partitionDate) maxDate FROM dbo.yourAcks

-- You'll see how pre-May data is initially clumped together
SELECT 'after $partition' s, $PARTITION.pf_test( partitionDate ) p, MIN(partitionDate) xMinDate, MAX(partitionDate) xMaxDate, COUNT(*) AS records
FROM dbo.yourLog WITH(NOLOCK) 
GROUP BY $PARTITION.pf_test( partitionDate ) 
ORDER BY xMinDate



-- Remember, date must always be part of query now to get partition elimination
SELECT *
FROM dbo.yourLog
WHERE partitionDate = '1 August 2014'
GO


-- Cleanup
USE master
GO

IF EXISTS ( SELECT * FROM sys.databases WHERE name = 'tooManyPartitionsTest' )
    ALTER DATABASE tooManyPartitionsTest SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
IF EXISTS ( SELECT * FROM sys.databases WHERE name = 'tooManyPartitionsTest' )
    DROP DATABASE tooManyPartitionsTest 
GO