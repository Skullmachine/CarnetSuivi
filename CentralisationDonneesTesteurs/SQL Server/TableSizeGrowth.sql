
-- Création de la table du suivi de l'évolution de la taille des BDD

USE DataMart

CREATE TABLE [dbo].[TABLE_SIZE_GROWTH](
[id] [int] IDENTITY(1,1) NOT NULL,
[table_schema] [nvarchar](256) NULL,
[table_name] [nvarchar](256) NULL,
[table_rows] [int] NULL,
[reserved_space] [int] NULL,
[data_space] [int] NULL,
[index_space] [int] NULL,
[unused_space] [int] NULL,
[date] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TABLE_SIZE_GROWTH] ADD CONSTRAINT [DF__TABLE_SIZE_GROWTH__DATE]  
DEFAULT (dateadd(day,(0),datediff(day,(0),getdate()))) FOR [date]
GO

---------------------------------------------------------------------------------------------

-- Script de la procédure stockée

USE [DataMart]
GO
/****** Object:  StoredProcedure [dbo].[sp_TableSizeGrowth]    Script Date: 11/04/2016 09:29:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TableSizeGrowth] 
AS
BEGIN
 SET NOCOUNT ON
 
 --DECLARE VARIABLES
 DECLARE
 @max INT,
 @min INT,
 @table_name NVARCHAR(256),
 @table_schema NVARCHAR(256),
 @sql NVARCHAR(4000)
 
 --DECLARE TABLE VARIABLE
 DECLARE @table TABLE(
 id INT IDENTITY(1,1) PRIMARY KEY,
 table_name NVARCHAR(256),
 table_schema NVARCHAR(256))
 
 --CREATE TEMP TABLE THAT STORES INFORMATION FROM SP_SPACEUSED
 IF (SELECT OBJECT_ID('tempdb..#results')) IS NOT NULL
 BEGIN
  DROP TABLE #results
 END
 
 CREATE TABLE #results
 (
  [table_schema] [nvarchar](256) NULL,
  [table_name] [nvarchar](256) NULL,
  [table_rows] [int] NULL,
  [reserved_space] [nvarchar](55) NULL,
  [data_space] [nvarchar](55) NULL,
  [index_space] [nvarchar](55) NULL,
  [unused_space] [nvarchar](55) NULL
 )
 
 
 --LOOP THROUGH STATISTICS FOR EACH TABLE
 INSERT @table(table_schema, table_name)
 SELECT  
  table_schema, table_name
 FROM
  information_schema.tables 
 WHERE table_schema + '.' + table_name IN ('dbo.STEP_RESULT','dbo.UUT_RESULT','dbo.PROP_RESULT', 'PROP_NUMERIC_LIMIT', 'STEP_SEQCALL') --INSERT TABLE NAMES TO MONITOR
 
 SELECT
  @min = 1,
  @max = (SELECT MAX(id) FROM @table)
 
 WHILE @min < @max + 1
 BEGIN
  SELECT 
   @table_name = table_name,
   @table_schema = table_schema
  FROM
   @table
  WHERE
   id = @min
   
  --DYNAMIC SQL
  SELECT @sql = 'EXEC sp_spaceused ''[' + @table_schema + '].[' + @table_name + ']'''
  
  --INSERT RESULTS FROM SP_SPACEUSED TO TEMP TABLE
  INSERT #results(table_name, table_rows, reserved_space, data_space, index_space, unused_space)
  EXEC (@sql)
  
  --UPDATE SCHEMA NAME
  UPDATE #results
  SET table_schema = @table_schema
  WHERE table_name = @table_name
  SELECT @min = @min + 1
 END
 
 --REMOVE "KB" FROM RESULTS FOR REPORTING (GRAPH) PURPOSES
 UPDATE #results SET data_space = SUBSTRING(data_space, 1, (LEN(data_space)-3))
 UPDATE #results SET reserved_space = SUBSTRING(reserved_space, 1, (LEN(reserved_space)-3))
 UPDATE #results SET index_space = SUBSTRING(index_space, 1, (LEN(index_space)-3))
 UPDATE #results SET unused_space = SUBSTRING(unused_space, 1, (LEN(unused_space)-3))
 
 --INSERT RESULTS INTO TABLESIZEGROWTH
 INSERT INTO Maintenance.dbo.TABLE_SIZE_GROWTH (table_schema, table_name, table_rows, reserved_space, data_space, index_space, unused_space)
 SELECT * FROM #results
 
 DROP TABLE #results
END