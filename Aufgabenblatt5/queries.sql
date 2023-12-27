--- Query 1 -- Laenge CD
CREATE OR REPLACE VIEW CDDauer AS
       SELECT c.name, SUM(dauer) FROM CD c
       NATURAL JOIN Track t
       JOIN Lied l ON t.liedtitel = l.titel AND t.sid = l.sid
       GROUP BY name;
   
SELECT * FROM CDDauer;


--- Query 2 -- Transitiver Abschluss aller Aliase
CREATE OR REPLACE VIEW AllAlias AS
WITH RECURSIVE tmp(AliasVName, AliasNName, vname, nname) AS (
       SELECT AliasVName, AliasNName, vname, nname FROM alias_von
   UNION ALL
	SELECT t.aliasvname, t.aliasnname, a.vname, a.nname FROM alias_von a JOIN tmp t ON
	a.aliasvname = t.vname AND a.aliasnname = t.nname
) SELECT * FROM tmp ORDER BY tmp.vname, tmp.nname;

SELECT * FROM AllAlias;
