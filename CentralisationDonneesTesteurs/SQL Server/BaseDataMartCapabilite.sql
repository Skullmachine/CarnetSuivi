USE master
GO

--Vérification que la database n'existe pas
IF EXISTS ( SELECT * FROM sys.databases WHERE name = 'DataMartCapabilite' )
    ALTER DATABASE DataMartCapabilite SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
IF EXISTS ( SELECT * FROM sys.databases WHERE name = 'DataMartCapabilite' )
    DROP DATABASE DataMartCapabilite 
GO
CREATE DATABASE DataMartCapabilite
GO

sp_configure 'contained database authentication', 1;
GO
RECONFIGURE;
GO

ALTER DATABASE DataMartCapabilite SET RECOVERY SIMPLE
GO

USE DataMartCapabilite
GO

SELECT * FROM sys.filegroups
SELECT * FROM sys.database_files 
GO

--Fonction de partitionnement de la table FACT_MEASURE
--Create date partition function with increment by month (START_DATE_TIME).
DECLARE @DatePartitionFunction nvarchar(max) = N'CREATE PARTITION FUNCTION DatePartitionFunction (datetime2) AS RANGE RIGHT FOR VALUES (';
DECLARE @i datetime2 = '20160101';
WHILE @i < '20250101'
BEGIN
SET @DatePartitionFunction += '''' + CAST(@i as nvarchar(10)) + '''' + N', ';
SET @i = DATEADD(MM, 1, @i);
END
SET @DatePartitionFunction += '''' + CAST(@i as nvarchar(10))+ '''' + N');';
PRINT @DatePartitionFunction
EXEC sp_executesql @DatePartitionFunction;
GO

--Fonction de partitionnement de la table DIM_MEASURE 
--Create integer partition function for 300 partitions (STEP_NAME).
DECLARE @IntegerPartitionFunction nvarchar(max) = N'CREATE PARTITION FUNCTION IntegerPartitionFunction (int) AS RANGE RIGHT FOR VALUES (';
DECLARE @i int = 1;
WHILE @i < 299
BEGIN
SET @IntegerPartitionFunction += CAST(@i as nvarchar(10)) + N', ';
SET @i += 1;
END
SET @IntegerPartitionFunction += CAST(@i as nvarchar(10)) + N');';
PRINT @IntegerPartitionFunction
EXEC sp_executesql @IntegerPartitionFunction;
GO

--Création du schéma de partitionnement correpondant à la fonction DatePartitionFunction
CREATE PARTITION SCHEME PSMonth
    AS PARTITION DatePartitionFunction
    ALL TO ([PRIMARY])
GO

--Création du schéma de partitionnement correpondant à la fonction IntegerPartitionFunction
CREATE PARTITION SCHEME PSStep
    AS PARTITION IntegerPartitionFunction
    ALL TO ([PRIMARY])
GO

IF OBJECT_ID('dbo.UUT_RESULT') IS NULL
CREATE TABLE UUT_RESULT (

 ID uniqueidentifier PRIMARY KEY,
 STATION_ID varchar(255),
 BATCH_SERIAL_NUMBER varchar(255),
 TEST_SOCKET_INDEX	int,
 UUT_SERIAL_NUMBER varchar(255),
 USER_LOGIN_NAME	varchar(255),
 START_DATE_TIME datetime,
 EXECUTION_TIME decimal(18,5),
 UUT_STATUS varchar(255),
 UUT_ERROR_CODE	int,
 UUT_ERROR_MESSAGE	varchar(255)
)
GO

IF OBJECT_ID('dbo.STEP_RESULT') IS NULL
CREATE TABLE STEP_RESULT (

 ID uniqueidentifier PRIMARY KEY,
 UUT_RESULT uniqueidentifier,
 ORDER_NUMBER int,
 STEP_NAME varchar(255),
 STEP_TYPE	varchar(255),
 STEP_GROUP	varchar(32),
 STEP_INDEX	int,
 STEP_ID	varchar(32),
 STATUS	varchar(255),
 REPORT_TEXT	varchar(255),
 ERROR_CODE	int,
 ERROR_MESSAGE	varchar(255),
 CAUSED_SEQFAIL	bit,
 MODULE_TIME	decimal(18,5),
 TOTAL_TIME	decimal(18,5),
 NUM_LOOPS	int,
 NUM_PASSED	int,
 NUM_FAILED	int,
 ENDING_LOOP_INDEX	int,
 LOOP_INDEX	int,
 INTERACTIVE_EXENUM	int,
 DATA decimal(18,2),
 HIGH_LIMIT decimal(18,1),
 LOW_LIMIT decimal(18,1),
 TOTAL_TIME decimal(18,5)
 CONSTRAINT STEP_RESULT_UUT_RESULT_FK FOREIGN KEY (UUT_RESULT) REFERENCES UUT_RESULT (ID)
)
GO

IF OBJECT_ID('dbo.UUT_RESULT_TEMP') IS NULL
CREATE TABLE UUT_RESULT_TEMP (

 SurogateKey uniqueidentifier PRIMARY KEY,
 ID bigint,
 STATION_ID varchar(255),
 BATCH_SERIAL_NUMBER varchar(255),
 TEST_SOCKET_INDEX	int,
 UUT_SERIAL_NUMBER varchar(255),
 USER_LOGIN_NAME	varchar(255),
 START_DATE_TIME datetime,
 EXECUTION_TIME decimal(18,5),
 UUT_STATUS varchar(255),
 UUT_ERROR_CODE	int,
 UUT_ERROR_MESSAGE	varchar(255)
)
GO

IF OBJECT_ID('dbo.STEP_RESULT_TEMP') IS NULL
CREATE TABLE STEP_RESULT_TEMP (

 ID uniqueidentifier PRIMARY KEY,
 UUT_RESULTSurogate uniqueidentifier,
 UUT_RESULT bigint,
 ORDER_NUMBER int,
 STEP_NAME varchar(255),
 STEP_TYPE	varchar(255),
 STEP_GROUP	varchar(32),
 STEP_INDEX	int,
 STEP_ID	varchar(32),
 STATUS	varchar(255),
 REPORT_TEXT	varchar(255),
 ERROR_CODE	int,
 ERROR_MESSAGE	varchar(255),
 CAUSED_SEQFAIL	bit,
 MODULE_TIME	decimal(18,5),
 TOTAL_TIME	decimal(18,5),
 NUM_LOOPS	int,
 NUM_PASSED	int,
 NUM_FAILED	int,
 ENDING_LOOP_INDEX	int,
 LOOP_INDEX	int,
 INTERACTIVE_EXENUM	int,
 DATA decimal(18,2),
 HIGH_LIMIT decimal(18,1),
 LOW_LIMIT decimal(18,1),
 TOTAL_TIME decimal(18,5)
)
GO

IF OBJECT_ID('dbo.SOURCE_LIST') IS NULL
CREATE TABLE [dbo].[SOURCE_LIST](
	[Numéro_Testeur] [nvarchar](50) NULL,
	[UO] [nvarchar](50) NULL,
	[Désignation] [nvarchar](50) NULL,
	[ID_réseaux] [nvarchar](50) NULL,
	[Adresse_IP] [nvarchar](50) NULL,
	[Login] [nvarchar](50) NULL,
	[Password] [nvarchar](50) NULL,
	[RDC] [bit] NULL,
	[Login_RDC] [nvarchar](50) NULL,
	[Password_RDC] [nvarchar](50) NULL
) ON [PRIMARY]
GO
