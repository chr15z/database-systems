--- Trigger fuer 4.a --- 
CREATE OR REPLACE FUNCTION fAddGreenhouse() RETURNS TRIGGER AS $$
DECLARE
	grundstuecks_groesse NUMERIC(10, 2);
BEGIN
	SELECT Groesse INTO grundstuecks_groesse FROM Grundstueck WHERE Adresse = NEW.Adresse;
	
	IF NEW.Groesse = 0 THEN 
		NEW.Groesse := grundstuecks_groesse;
	END IF;
	
	IF NEW.Groesse < grundstuecks_groesse THEN 
		RETURN NEW;
	END IF;
	
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trAddGreenhouse BEFORE INSERT
    ON Gewaechshaus FOR EACH ROW EXECUTE PROCEDURE fAddGreenhouse();


--- Trigger fuer 4.b ---
CREATE OR REPLACE FUNCTION fUpdatePlant() RETURNS TRIGGER AS $$
DECLARE
	rec RECORD;
BEGIN
	--- Aktualisiere die Daten jedes Duengers der fuers Duengen der Pflanze verwendet wird ---
	IF NEW.Anzahl != OLD.Anzahl THEN
		FOR rec in (SELECT d.Art, d.Lagerbestand FROM Duenger d, duengt dd WHERE d.Art = dd.Art AND dd.GId = NEW.GId AND 
					dd.Adresse = NEW.Adresse AND dd.Name = NEW.Name) LOOP
			UPDATE Duenger SET Lagerbestand = Lagerbestand + (NEW.Anzahl - OLD.Anzahl) WHERE Art = rec.Art;
			RAISE NOTICE 'Lagerbestand wurde auf % gesetzt.', (rec.Lagerbestand + (NEW.Anzahl - OLD.Anzahl));
		END LOOP;
	ELSE
		RAISE WARNING 'Die Anzahl der Pflanzen hat sich nicht geandert.';        
	END IF;					    

    RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trUpdatePlant BEFORE UPDATE OF Anzahl ON Pflanzen
       FOR EACH ROW EXECUTE PROCEDURE fUpdatePlant();

--- Trigger fuer 4.c ---
CREATE OR REPLACE FUNCTION fSizeUpdate() RETURNS TRIGGER AS $$
BEGIN
	IF NEW.Groesse != OLD.Groesse THEN
		UPDATE Grundstueck SET Groesse = Groesse + (NEW.Groesse - OLD.Groesse)
       	    WHERE (Adresse) in (SELECT e.Grundstuecks_Adresse FROM enthaelt e 
				WHERE OLD.Adresse = e.Adresse_Des_Teilgrundstuecks);
	END IF;
		RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trSizeUpdate AFTER UPDATE OF Groesse ON Grundstueck
       FOR EACH ROW EXECUTE PROCEDURE fSizeUpdate();


--- Prozedure fuer 4.d ---
CREATE OR REPLACE FUNCTION CreateHeatingSystems(IN HkW NUMERIC, IN AnzahlHeizanlagen INTEGER, IN Grundtsuecksgroesse NUMERIC) RETURNS VOID AS
$$
DECLARE
    maxAdressNr Integer;
	maxAdress VARCHAR(2);
BEGIN

    IF AnzahlHeizanlagen < 1 THEN
        RAISE EXCEPTION 'Die Anzahl an Heizanlagen muss zumindest 1 sein.';
    END IF;

	SELECT MAX(CAST(SUBSTRING(Adresse, 2, 100) AS INT)) INTO maxAdressNr FROM Grundstueck WHERE Adresse ~* '^A\d+$';
	
	-- Berechne eine freie Adresse
	IF maxAdressNr IS NULL THEN 
		maxAdress = 'A1';
	ELSE
		SELECT CONCAT('A', maxAdressNr + 1) INTO maxAdress;
	END IF;

	FOR counter IN 0 .. AnzahlHeizanlagen - 1
    LOOP
		PERFORM NEXTVAL('seq_heatingsys');
		
		IF counter = 0 THEN
			-- Erzeuge das Grundstueck
			-- Verwende die erste Heizanlage als Primaerheizanlage des Grundstuecks
			INSERT INTO Grundstueck(Adresse, Groesse, Primaerheizanlage_HId, Primaerheizanlage_Adresse) VALUES 
				(maxAdress, Grundtsuecksgroesse, CURRVAL('seq_heatingsys'), maxAdress);
		END IF;
		
		-- Erzeuge eine Heizanlage
		INSERT INTO Heizanlage(Adresse, HId, kW) VALUES 
				(maxAdress, CURRVAL('seq_heatingsys'), HkW);	
        
		-- Erzeuge die spezifische Art der Heizanlage
		CASE counter % 2	
			WHEN 0 THEN			
				INSERT INTO Waermepumpe(Adresse, HId) VALUES 
				(maxAdress, CURRVAL('seq_heatingsys'));
            WHEN 1 THEN
				INSERT INTO Gasheizung(Adresse, HId) VALUES 
				(maxAdress, CURRVAL('seq_heatingsys'));
        END CASE;		
   END LOOP;
END;
$$ LANGUAGE plpgsql;