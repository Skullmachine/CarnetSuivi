Use DMCapabiliteRetest

------------------------------------------------------------------------------------------------
-- Maintenance START
------------------------------------------------------------------------------------------------

-- Oh man, we're behind with our switching and truncation.
-- Create a job that sweeps up.  Do we get blocking?

-- ALTER TABLE dbo.yourLog SWITCH PARTITION 1 TO dbo.yourLogSwitch PARTITION 1
-- TRUNCATE TABLE dbo.yourLogSwitch

-- Let's pretend we only want to maintain up to 30 days ago
DECLARE @testDate DATE
SET @testDate = DATEADD( day, -365, GETDATE() )

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

------------------------------------------------------------------------------------------------

bcp "select * from DMCapabiliteRetest.dbo.FACT_MEASURE_SWITCH" queryout "E:\FTP\archive.txt" -T  -c -t

------------------------------------------------------------------------------------------------

DELETE FROM DMCapabiliteRetest.dbo.FACT_MEASURE_SWITCH