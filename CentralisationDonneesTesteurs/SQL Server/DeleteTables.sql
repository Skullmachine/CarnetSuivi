-- Supprime les données de la table PROP_MULTINUMERICLIMIT1
DELETE FROM t1
FROM Production.dbo.PROP_MULTINUMERICLIMIT1 t1
	JOIN Production.dbo.STEP_RESULT t2
		ON t2.ID = t1.STEP_RESULT
	JOIN Production.dbo.UUT_RESULT t3
		ON t3.ID = t2.UUT_RESULT
WHERE t3.STATION_ID like 'ACTE2-52';

-- Supprime les données de la table STEP_SEQCALL
DELETE FROM t4
FROM Production.dbo.STEP_SEQCALL t4
	JOIN Production.dbo.STEP_RESULT t2
		ON t2.ID = t4.STEP_RESULT
	JOIN Production.dbo.UUT_RESULT t3
		ON t3.ID = t2.UUT_RESULT
WHERE t3.STATION_ID like 'ACTE2-52';

--Supprime les données de la table STEP_NUMERICLIMIT2
DELETE FROM t5
FROM Production.dbo.STEP_NUMERICLIMIT2 t5
	JOIN Production.dbo.STEP_NUMERICLIMIT1 t6
		ON t6.ID = t5.PROP_RESULT
	JOIN Production.dbo.STEP_RESULT t2
		ON t2.ID = t6.STEP_RESULT
	JOIN Production.dbo.UUT_RESULT t3
		ON t3.ID = t2.UUT_RESULT
WHERE t3.STATION_ID like 'ACTE2-52';

--Supprime les données de la table STEP_NUMERICLIMIT1
DELETE FROM t6
FROM Production.dbo.STEP_NUMERICLIMIT1 t6
	JOIN Production.dbo.STEP_RESULT t2
		ON t2.ID = t6.STEP_RESULT
	JOIN Production.dbo.UUT_RESULT t3
		ON t3.ID = t2.UUT_RESULT
WHERE t3.STATION_ID like 'ACTE2-52';

--Supprime les données de la table STEP_RESULT
DELETE FROM t2
FROM Production.dbo.STEP_RESULT t2
	JOIN Production.dbo.UUT_RESULT t3
		ON t3.ID = t2.UUT_RESULT
WHERE t3.STATION_ID like 'ACTE2-52';

--Supprime les données de la table UUT_RESULT
DELETE FROM t3
FROM Production.dbo.UUT_RESULT t3
WHERE t3.STATION_ID like 'ACTE2-52';