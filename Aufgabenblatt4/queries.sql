create view AllRecruits as
with recursive res as (
	select neuling, werberin from angeworben
	union
	select b.neuling, res.werberin from angeworben b join res on res.neuling = b.werberin
) select * from res order by werberin;

select * from AllRecruits order by werberin;
-------------------------------------------
create view AllRecruitionSteps as
with recursive res(neuling, werberin, d) as (
	select neuling, werberin, 1 from angeworben
	union
	select b.neuling, res.werberin, d + 1 from angeworben b join res on res.neuling = b.werberin
) select * from res where d > 2; --2 ist die Variable

select * from AllRecruitionSteps;
-------------------------------------------
CREATE VIEW AnnualSalesVolume AS
SELECT R.Jahr AS Jahr, SUM(E.Anzahl * W.Preis * (1 - R.Rabatt)) AS Gesamtumsatz --/100 ist schon enthalten
FROM Rechnung R
	NATURAL JOIN enthaelt E 
	NATURAL JOIN Ware W 
GROUP BY R.Jahr;

select 1 from AnnualSalesVolume where jahr = 2024;
