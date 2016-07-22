-- Supprime les données de la table PROP_NUMERICLIMIT
DELETE FROM t1
FROM DataMart.dbo.PROP_NUMERICLIMIT t1
	JOIN DataMart.dbo.PROP_RESULT t2
		ON t2.ID = t1.PROP_RESULT
	JOIN DataMart.dbo.STEP_RESULT t3
		ON t3.ID = t2.STEP_RESULT
	JOIN DataMart.dbo.UUT_RESULT t4
		ON t4.ID = t3.UUT_RESULT
WHERE t4.STATION_ID like 'ACTE2-52';

-- Supprime les données de la table STEP_SEQCALL
DELETE FROM t5
FROM DataMart.dbo.STEP_SEQCALL t5
	JOIN DataMart.dbo.STEP_RESULT t3
		ON t3.ID = t5.STEP_RESULT
	JOIN DataMart.dbo.UUT_RESULT t4
		ON t4.ID = t3.UUT_RESULT
WHERE t4.STATION_ID like 'ACTE2-52';

--Supprime les données de la table PROP_RESULT
DELETE FROM t2
FROM DataMart.dbo.PROP_RESULT t2
	JOIN DataMart.dbo.STEP_RESULT t3
		ON t3.ID = t2.STEP_RESULT
	JOIN DataMart.dbo.UUT_RESULT t4
		ON t4.ID = t3.UUT_RESULT
WHERE t4.STATION_ID like 'ACTE2-52';

--Supprime les données de la table STEP_RESULT
DELETE FROM t2
FROM DataMart.dbo.STEP_RESULT t2
	JOIN DataMart.dbo.UUT_RESULT t3
		ON t3.ID = t2.UUT_RESULT
WHERE t3.STATION_ID like 'ACTE2-52';

--Supprime les données de la table UUT_RESULT
DELETE FROM t3
FROM DataMart.dbo.UUT_RESULT t3
WHERE t3.STATION_ID like 'ACTE2-52';