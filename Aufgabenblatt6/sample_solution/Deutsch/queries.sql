--- Query 1 -- Anzahl an grossen Heizanlagen pro Grundstueck (i.e. Groesse > 30m^2)
CREATE OR REPLACE VIEW NumberOfBigGreenhouses AS
	SELECT Adresse, count(*)
	FROM Gewaechshaus
	WHERE Groesse > 30
	GROUP BY Adresse;

--- Query 2 -- Transitiver Huelle von benachbarten Grundstuecken
CREATE OR REPLACE VIEW AllBlockNeighbours AS
WITH RECURSIVE tmp(Grundstuecks_Adresse, Nachbar_Adresse) as ( 
       SELECT Grundstuecks_Adresse, Nachbar_Adresse 
	   FROM grenzt_an
       UNION
       SELECT tmp.Grundstuecks_Adresse, g.Nachbar_Adresse 
	   FROM grenzt_an g, tmp 
	   WHERE tmp.Nachbar_Adresse = g.Grundstuecks_Adresse
       ) SELECT * FROM tmp;
SELECT * FROM AllBlockNeighbours;


--- Query 3 -- Anzahl an Nachbarn zwischen A und B + Gesamtgroesse der Grundstuecke zwischen A und B
CREATE OR REPLACE VIEW NeighbourhoodSize AS
WITH RECURSIVE tmp(Grundstuecks_Adresse, Nachbar_Adresse, Schritte, Gesamtgroesse) as ( 
       SELECT Grundstuecks_Adresse, Nachbar_Adresse, 1, gr1.Groesse + gr2.Groesse 
	   FROM grenzt_an ga, Grundstueck gr1, Grundstueck gr2
	   WHERE ga.Grundstuecks_Adresse = gr1.Adresse AND ga.Nachbar_Adresse = gr2.Adresse
       UNION
       SELECT tmp.Grundstuecks_Adresse, ga.Nachbar_Adresse, tmp.Schritte + 1, (tmp.Gesamtgroesse + gr.Groesse)::NUMERIC(10, 2)
	   FROM grenzt_an ga, tmp, Grundstueck gr 
	   WHERE tmp.Nachbar_Adresse = ga.Grundstuecks_Adresse AND ga.Nachbar_Adresse = gr.Adresse
       ) SELECT * FROM tmp;
SELECT * FROM NeighbourhoodSize;
