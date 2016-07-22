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

USE DMCapabiliteRetest
GO

SELECT * FROM sys.filegroups
SELECT * FROM sys.database_files 
GO

-- Create partition function and scheme
CREATE PARTITION FUNCTION myDateRangePF (datetime)
AS RANGE LEFT FOR VALUES ('20151201','20160101','20160201','20160301','20160401')
GO
CREATE PARTITION SCHEME myPartitionScheme AS PARTITION myDateRangePF ALL TO ([PRIMARY]) 
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
)ON myPartitionScheme(START_DATE_TIME)
GO
