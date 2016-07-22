-- Generate partition function with ~3 years worth of daily partitions from 2015 06 15.
DECLARE @bigString NVARCHAR(MAX) = ''

;WITH cte AS (
SELECT CAST( '20150617' AS DATE ) testDate
UNION ALL
SELECT DATEADD( day, 1, testDate )
FROM cte
WHERE testDate < '20160621'
)
SELECT @bigString += ',' + QUOTENAME( CONVERT ( VARCHAR, testDate, 106 ), '''' )
FROM cte
OPTION ( MAXRECURSION 1100 )

SELECT @bigString = 'CREATE PARTITION FUNCTION pfFactMeasure (DATETIME) AS RANGE RIGHT FOR VALUES ( ' + STUFF( @bigString, 1, 1, '' ) + ' )'
SELECT @bigString bs

-- Create the partition function
PRINT @bigString
EXEC ( @bigString )
GO

------------------------------------------------------------------------------------------------

DECLARE @bigString NVARCHAR(MAX) = ''

;WITH cte AS (
SELECT ROW_NUMBER() OVER( ORDER BY boundary_id ) rn
FROM sys.partition_range_values
WHERE function_id = ( SELECT function_id FROM sys.partition_functions WHERE name = 'pfFactMeasure' )
UNION ALL 
SELECT 1    -- additional row required for fg
)
SELECT @bigString += ',' + '[DMCapabiliteRetestFg' + CAST( ( rn % 7 ) + 1 AS VARCHAR(5) ) + ']'
FROM cte
OPTION ( MAXRECURSION 1100 )

SELECT @bigString = 'CREATE PARTITION SCHEME psFactMeasure AS PARTITION pfFactMeasure TO ( ' + STUFF( @bigString, 1, 1, '' ) + ' )'
PRINT @bigString
EXEC ( @bigString )
GO

------------------------------------------------------------------------------------------------
-- Maintenance START
------------------------------------------------------------------------------------------------

-- Oh man, we're behind with our switching and truncation.
-- Create a job that sweeps up.  Do we get blocking?

-- ALTER TABLE dbo.yourLog SWITCH PARTITION 1 TO dbo.yourLogSwitch PARTITION 1
-- TRUNCATE TABLE dbo.yourLogSwitch

-- Let's pretend we only want to maintain up to 365 days ago
DECLARE @testDate DATE
SET @testDate = DATEADD( day, -365, GETDATE() )

-- Create local fast_forward ( forward-only, read-only ) cursor 
DECLARE partitions_cursor CURSOR FAST_FORWARD LOCAL FOR 
SELECT boundary_id, CAST( value AS DATE )
FROM sys.partition_range_values
WHERE function_id = ( SELECT function_id FROM sys.partition_functions WHERE name = 'pfFactMeasure' )
  AND value < @testDate

-- Cursor variables
DECLARE @boundary_id INT, @value DATE, @sql NVARCHAR(MAX)

OPEN partitions_cursor

FETCH NEXT FROM partitions_cursor INTO @boundary_id, @value
WHILE @@fetch_status = 0
BEGIN

    -- Switch out and truncate old partition
    SET @sql = 'ALTER TABLE dbo.FACT_MEASURE_APF SWITCH PARTITION ' + CAST( @boundary_id AS VARCHAR(5) ) + ' TO dbo.FACT_MEASURE_SWITCH_APF PARTITION ' + CAST( @boundary_id AS VARCHAR(5) )

    PRINT @sql
    EXEC(@sql)

    -- You could move the data elsewhere from here or just empty it out
    TRUNCATE TABLE dbo.FACT_MEASURE_SWITCH_APF

    --!!TODO yourAcks table

    FETCH NEXT FROM partitions_cursor INTO @boundary_id, @value
END

CLOSE partitions_cursor
DEALLOCATE partitions_cursor
GO

-- Maintenance END
------------------------------------------------------------------------------------------------