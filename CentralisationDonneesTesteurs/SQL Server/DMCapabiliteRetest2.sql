USE master
GO

--Vérification que la database n'existe pas
IF EXISTS ( SELECT * FROM sys.databases WHERE name = 'DMCapabiliteRetest' )
    ALTER DATABASE DMCapabiliteRetest SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
IF EXISTS ( SELECT * FROM sys.databases WHERE name = 'DMCapabiliteRetest' )
    DROP DATABASE DMCapabiliteRetest 
GO
CREATE DATABASE DMCapabiliteRetest
GO

sp_configure 'contained database authentication', 1;
GO
RECONFIGURE;
GO

ALTER DATABASE DMCapabiliteRetest SET RECOVERY SIMPLE
GO

-- Add 7 filegroups with 4 files each
-- Add 365 files and filegroup
DECLARE @fg INT = 0, @f INT = 0, @sql NVARCHAR(MAX)

WHILE @fg < 7
BEGIN

    SET @fg += 1
    SET @sql = 'ALTER DATABASE DMCapabiliteRetest ADD FILEGROUP DMCapabiliteRetestFg' + CAST( @fg AS VARCHAR(5) )

    -- Add the filegroup
    PRINT @sql
    EXEC(@sql)


    -- Initialise
    SET @f = 0

    WHILE @f < 4
    BEGIN

        SET @f += 1
        --!!WARNING!! DON'T USE THESE SETTINGS IN PRODUCTION.  3MB starting size and 1MB filegrowth are just for demo - would be extremely painful for live data
        SET @sql = 'ALTER DATABASE DMCapabiliteRetest ADD FILE ( NAME = N''DMCapabiliteRetestFile@f_@fg'', FILENAME = N''d:\DATABASES\DMCapabiliteRetestFile@f_@fg.ndf'', SIZE = 10MB, FILEGROWTH = 15% ) TO FILEGROUP [DMCapabiliteRetestFg@fg]'
        SET @sql = REPLACE ( @sql, '@fg', @fg )
        SET @sql = REPLACE ( @sql, '@f', @f )

        -- Add the file
        PRINT @sql
        EXEC(@sql)

    END

END
GO

USE DMCapabiliteRetest
GO

SELECT * FROM sys.filegroups
SELECT * FROM sys.database_files 
GO

-- You'll see how pre-May data is initially clumped together
SELECT 'after $partition' s, $PARTITION.pf_test( START_DATE_TIME ) p, MIN(START_DATE_TIME) xMinDate, MAX(START_DATE_TIME) xMaxDate, COUNT(*) AS records
FROM dbo.FACT_MEASURE WITH(NOLOCK) 
GROUP BY $PARTITION.pf_test( START_DATE_TIME ) 
ORDER BY xMinDate


-- Generate partition function with ~3 years worth of daily partitions from 1 Jan 2014.
DECLARE @bigString NVARCHAR(MAX) = ''

;WITH cte AS (
SELECT CAST( '20160101' AS DATETIME ) testDate
UNION ALL
SELECT DATEADD( day, 1, testDate )
FROM cte
WHERE testDate < '20181231'
)
SELECT @bigString += ',' + QUOTENAME( CONVERT ( VARCHAR, testDate, 106 ), '''' )
FROM cte
OPTION ( MAXRECURSION 1100 )

SELECT @bigString = 'CREATE PARTITION FUNCTION pf_test (DATETIME) AS RANGE RIGHT FOR VALUES ( ' + STUFF( @bigString, 1, 1, '' ) + ' )'
SELECT @bigString bs

-- Create the partition function
PRINT @bigString
EXEC ( @bigString )
GO

DECLARE @bigString NVARCHAR(MAX) = ''

;WITH cte AS (
SELECT ROW_NUMBER() OVER( ORDER BY boundary_id ) rn
FROM sys.partition_range_values
WHERE function_id = ( SELECT function_id FROM sys.partition_functions WHERE name = 'pf_test' )
UNION ALL 
SELECT 1    -- additional row required for fg
)
SELECT @bigString += ',' + '[DMCapabiliteRetestFg' + CAST( ( rn % 7 ) + 1 AS VARCHAR(5) ) + ']'
FROM cte
OPTION ( MAXRECURSION 1100 )

SELECT @bigString = 'CREATE PARTITION SCHEME ps_test AS PARTITION pf_test TO ( ' + STUFF( @bigString, 1, 1, '' ) + ' )'
PRINT @bigString
EXEC ( @bigString )
GO

IF OBJECT_ID('dbo.FACT_MEASURE') IS NULL
CREATE TABLE FACT_MEASURE (

	 ID_UUT_RESULT BIGINT IDENTITY(1,1) NOT NULL,	 
	 START_DATE_TIME datetime NOT NULL,
	 STATION_ID nvarchar(255),
	 BATCH_SERIAL_NUMBER nvarchar(255),
	 TEST_SOCKET_INDEX	int,
	 UUT_SERIAL_NUMBER nvarchar(255),
	 USER_LOGIN_NAME	nvarchar(255),
	 EXECUTION_TIME float,
	 UUT_STATUS nvarchar(255),
	 UUT_ERROR_CODE	int,
	 UUT_ERROR_MESSAGE	nvarchar(255),
	 INTERFACE_JIG nvarchar(50),
	 PRODUCT nvarchar(50),
	 STEP_PARENT	int,
	 ORDER_NUMBER int,
	 STEP_NAME nvarchar(255),
	 STEP_TYPE	nvarchar(255),
	 STEP_GROUP	nvarchar(32),
	 STEP_INDEX	int,
	 STEP_ID	nvarchar(32),
	 STATUS	nvarchar(255),
	 REPORT_TEXT	nvarchar(255),
	 ERROR_CODE	int,
	 ERROR_MESSAGE	nvarchar(255),
	 CAUSED_SEQFAIL	bit,
	 MODULE_TIME	float,
	 TOTAL_TIME	float,
	 NUM_LOOPS	int,
	 NUM_PASSED	int,
	 NUM_FAILED	int,
	 ENDING_LOOP_INDEX	int,
	 LOOP_INDEX	int,
	 INTERACTIVE_EXENUM	int,
	 RESULT_TYPE nvarchar(255),
	 SEQUENCE_NAME	nvarchar(255),
	 SEQUENCE_FILE_PATH	nvarchar(1024),
	 ORDER_NUMBER_PROP_RESULT	int,
	 NAME	nvarchar(255),
	 PATH	nvarchar(1024),
	 CATEGORY	int,
	 TYPE_VALUE	int,
	 TYPE_NAME	nvarchar(255),
	 DISPLAY_FORMAT	nvarchar(32),
	 DATA	nvarchar(255),
	 COMP_OPERATOR nvarchar(32),
	 HIGH_LIMIT float,
	 LOW_LIMIT float,
	 UNITS nvarchar(255),
	 STATUS_PROP_NUMERICLIMIT nvarchar(255)
)ON [ps_test](START_DATE_TIME)
GO

IF OBJECT_ID('dbo.FACT_MEASURE_SWITCH') IS NULL
CREATE TABLE FACT_MEASURE_SWITCH (

	 ID_UUT_RESULT BIGINT IDENTITY(1,1) NOT NULL,	 
	 START_DATE_TIME datetime NOT NULL,
	 STATION_ID nvarchar(255),
	 BATCH_SERIAL_NUMBER nvarchar(255),
	 TEST_SOCKET_INDEX	int,
	 UUT_SERIAL_NUMBER nvarchar(255),
	 USER_LOGIN_NAME	nvarchar(255),
	 EXECUTION_TIME float,
	 UUT_STATUS nvarchar(255),
	 UUT_ERROR_CODE	int,
	 UUT_ERROR_MESSAGE	nvarchar(255),
	 INTERFACE_JIG nvarchar(50),
	 PRODUCT nvarchar(50),
	 STEP_PARENT	int,
	 ORDER_NUMBER int,
	 STEP_NAME nvarchar(255),
	 STEP_TYPE	nvarchar(255),
	 STEP_GROUP	nvarchar(32),
	 STEP_INDEX	int,
	 STEP_ID	nvarchar(32),
	 STATUS	nvarchar(255),
	 REPORT_TEXT	nvarchar(255),
	 ERROR_CODE	int,
	 ERROR_MESSAGE	nvarchar(255),
	 CAUSED_SEQFAIL	bit,
	 MODULE_TIME	float,
	 TOTAL_TIME	float,
	 NUM_LOOPS	int,
	 NUM_PASSED	int,
	 NUM_FAILED	int,
	 ENDING_LOOP_INDEX	int,
	 LOOP_INDEX	int,
	 INTERACTIVE_EXENUM	int,
	 RESULT_TYPE nvarchar(255),
	 SEQUENCE_NAME	nvarchar(255),
	 SEQUENCE_FILE_PATH	nvarchar(1024),
	 ORDER_NUMBER_PROP_RESULT	int,
	 NAME	nvarchar(255),
	 PATH	nvarchar(1024),
	 CATEGORY	int,
	 TYPE_VALUE	int,
	 TYPE_NAME	nvarchar(255),
	 DISPLAY_FORMAT	nvarchar(32),
	 DATA	nvarchar(255),
	 COMP_OPERATOR nvarchar(32),
	 HIGH_LIMIT float,
	 LOW_LIMIT float,
	 UNITS nvarchar(255),
	 STATUS_PROP_NUMERICLIMIT nvarchar(255)
)ON [ps_test](START_DATE_TIME)
GO

IF OBJECT_ID('dbo.FACT_MEASURE_ERRORS_HANDLING') IS NULL
CREATE TABLE dbo.FACT_MEASURE_ERRORS_HANDLING (

	 ID_UUT_RESULT BIGINT,	 
	 START_DATE_TIME datetime,
	 STATION_ID nvarchar(255),
	 BATCH_SERIAL_NUMBER nvarchar(255),
	 TEST_SOCKET_INDEX	int,
	 UUT_SERIAL_NUMBER nvarchar(255),
	 USER_LOGIN_NAME	nvarchar(255),
	 EXECUTION_TIME float,
	 UUT_STATUS nvarchar(255),
	 UUT_ERROR_CODE	int,
	 UUT_ERROR_MESSAGE	nvarchar(255),
	 INTERFACE_JIG nvarchar(50),
	 PRODUCT nvarchar(50),
	 STEP_PARENT	int,
	 ORDER_NUMBER int,
	 STEP_NAME nvarchar(255),
	 STEP_TYPE	nvarchar(255),
	 STEP_GROUP	nvarchar(32),
	 STEP_INDEX	int,
	 STEP_ID	nvarchar(32),
	 STATUS	nvarchar(255),
	 REPORT_TEXT	nvarchar(255),
	 ERROR_CODE	int,
	 ERROR_MESSAGE	nvarchar(255),
	 CAUSED_SEQFAIL	bit,
	 MODULE_TIME	float,
	 TOTAL_TIME	float,
	 NUM_LOOPS	int,
	 NUM_PASSED	int,
	 NUM_FAILED	int,
	 ENDING_LOOP_INDEX	int,
	 LOOP_INDEX	int,
	 INTERACTIVE_EXENUM	int,
	 RESULT_TYPE nvarchar(255),
	 SEQUENCE_NAME	nvarchar(255),
	 SEQUENCE_FILE_PATH	nvarchar(1024),
	 ORDER_NUMBER_PROP_RESULT	int,
	 NAME	nvarchar(255),
	 PATH	nvarchar(1024),
	 CATEGORY	int,
	 TYPE_VALUE	int,
	 TYPE_NAME	nvarchar(255),
	 DISPLAY_FORMAT	nvarchar(32),
	 DATA	nvarchar(255),
	 COMP_OPERATOR nvarchar(32),
	 HIGH_LIMIT float,
	 LOW_LIMIT float,
	 UNITS nvarchar(255),
	 STATUS_PROP_NUMERICLIMIT nvarchar(255)
)
GO

IF OBJECT_ID('dbo.FACT_MEASURE_SINGLE_ROW') IS NULL
CREATE TABLE dbo.FACT_MEASURE_SINGLE_ROW (

	 ID_UUT_RESULT BIGINT,	 
	 START_DATE_TIME datetime,
	 STATION_ID nvarchar(255),
	 BATCH_SERIAL_NUMBER nvarchar(255),
	 TEST_SOCKET_INDEX	int,
	 UUT_SERIAL_NUMBER nvarchar(255),
	 USER_LOGIN_NAME	nvarchar(255),
	 EXECUTION_TIME float,
	 UUT_STATUS nvarchar(255),
	 UUT_ERROR_CODE	int,
	 UUT_ERROR_MESSAGE	nvarchar(255),
	 INTERFACE_JIG nvarchar(50),
	 PRODUCT nvarchar(50),
	 STEP_PARENT	int,
	 ORDER_NUMBER int,
	 STEP_NAME nvarchar(255),
	 STEP_TYPE	nvarchar(255),
	 STEP_GROUP	nvarchar(32),
	 STEP_INDEX	int,
	 STEP_ID	nvarchar(32),
	 STATUS	nvarchar(255),
	 REPORT_TEXT	nvarchar(255),
	 ERROR_CODE	int,
	 ERROR_MESSAGE	nvarchar(255),
	 CAUSED_SEQFAIL	bit,
	 MODULE_TIME	float,
	 TOTAL_TIME	float,
	 NUM_LOOPS	int,
	 NUM_PASSED	int,
	 NUM_FAILED	int,
	 ENDING_LOOP_INDEX	int,
	 LOOP_INDEX	int,
	 INTERACTIVE_EXENUM	int,
	 RESULT_TYPE nvarchar(255),
	 SEQUENCE_NAME	nvarchar(255),
	 SEQUENCE_FILE_PATH	nvarchar(1024),
	 ORDER_NUMBER_PROP_RESULT	int,
	 NAME	nvarchar(255),
	 PATH	nvarchar(1024),
	 CATEGORY	int,
	 TYPE_VALUE	int,
	 TYPE_NAME	nvarchar(255),
	 DISPLAY_FORMAT	nvarchar(32),
	 DATA	nvarchar(255),
	 COMP_OPERATOR nvarchar(32),
	 HIGH_LIMIT float,
	 LOW_LIMIT float,
	 UNITS nvarchar(255),
	 STATUS_PROP_NUMERICLIMIT nvarchar(255)
)
GO

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
    SET @sql = 'ALTER TABLE dbo.FACT_MEASURE SWITCH PARTITION ' + CAST( @boundary_id AS VARCHAR(5) ) + ' TO dbo.FACT_MEASURE_SWITCH PARTITION ' + CAST( @boundary_id AS VARCHAR(5) )

    PRINT @sql
    EXEC(@sql)

    -- You could move the data elsewhere from here or just empty it out
    TRUNCATE TABLE dbo.FACT_MEASURE_SWITCH

    --!!TODO yourAcks table

    FETCH NEXT FROM partitions_cursor INTO @boundary_id, @value
END

CLOSE partitions_cursor
DEALLOCATE partitions_cursor
GO