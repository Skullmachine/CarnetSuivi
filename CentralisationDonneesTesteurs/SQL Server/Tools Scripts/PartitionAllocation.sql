-- You'll see how pre-May data is initially clumped together
SELECT '$partition' s, $PARTITION.pfFactMeasure( START_DATE_TIME ) p, MIN(START_DATE_TIME) xMinDate, MAX(START_DATE_TIME) xMaxDate, COUNT(*) AS records
FROM dbo.FACT_MEASURE_EOL WITH(NOLOCK) 
GROUP BY $PARTITION.pfFactMeasure( START_DATE_TIME ) 
ORDER BY xMinDate
GO

-----------------------------------------------------------------------------------------------

-- You'll see how pre-May data is initially clumped together
SELECT '$partition' s, $PARTITION.pfFactMeasure( DateTime_ ) p, MIN(DateTime_) xMinDate, MAX(DateTime_) xMaxDate, COUNT(*) AS records
FROM dbo.FACT_MEASURE_ICT WITH(NOLOCK) 
GROUP BY $PARTITION.pfFactMeasure( DateTime_ ) 
ORDER BY xMinDate
GO
