CREATE TABLE dbo.DimCalendrier
[Data Conversion [24]] Error: Data conversion failed while converting column "HIGH_LIM" (18) to column "Copy of HIGH_LIM" (30).  The conversion returned status value 2 and status text "The value could not be converted because of a potential loss of data.".

ALTER TABLE dbo.FACT_MEASURE SWITCH PARTITION 1 TO dbo.FACT_MEASURE_SWITCH PARTITION 1
GO