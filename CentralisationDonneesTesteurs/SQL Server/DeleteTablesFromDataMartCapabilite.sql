--Supprime les données de la table STEP_RESULT
DELETE FROM t2
FROM DataMartCapabilite.dbo.STEP_RESULT t2
	JOIN DataMartCapabilite.dbo.UUT_RESULT t3
		ON t3.ID = t2.UUT_RESULT
WHERE t3.STATION_ID like 'SMEG01@MMCHT';

--Supprime les données de la table UUT_RESULT
DELETE FROM t3
FROM DataMartCapabilite.dbo.UUT_RESULT t3
WHERE t3.STATION_ID like 'SMEG01@MMCHT';