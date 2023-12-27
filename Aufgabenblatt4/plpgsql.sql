CREATE OR REPLACE FUNCTION check_angeworben_date() RETURNS TRIGGER AS $$
DECLARE
    werberin_date DATE;
BEGIN	
    -- Überprüfen, ob die Werberin selbst als Neuling angeworben wurde
    SELECT angeworben.Datum INTO werberin_date --reinkopieren
    FROM angeworben
    WHERE angeworben.Neuling = NEW.Werberin;
    
    -- Überprüfen, ob das Tupel (W, N, D1) angelegt werden soll
    IF werberin_date IS NOT NULL AND NEW.Datum <= werberin_date THEN
        RAISE EXCEPTION 'Das Datum muss größer sein als das Datum, an dem die Werberin selbst angeworben wurde.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql; --Erlaubt auch IF WHILE etc zu benutzen

CREATE TRIGGER check_angeworben_date_trigger BEFORE INSERT ON angeworben
FOR EACH ROW
EXECUTE FUNCTION check_angeworben_date();
----------------------------------------------------
CREATE OR REPLACE FUNCTION update_ware_price() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.Preis <> OLD.Preis THEN
    IF EXISTS ( -- Ware bereits in einer Rechnung?
      SELECT 1
      FROM Rechnung
      WHERE Rechnung.VNr = OLD.VNr
        AND Rechnung.Herstellerin = OLD.Herstellerin
        AND Rechnung.SerNr = OLD.SerNr
      ) THEN
      NEW.VNr := ( -- Neue VNr generieren
        SELECT MAX(VNr) + 1
        FROM Ware
      );
      
      INSERT INTO Ware (VNr, Herstellerin, SerNr, Bezeichnung, Preis)       -- Neues Tupel einfügen
      VALUES (NEW.VNr, OLD.Herstellerin, OLD.SerNr, OLD.Bezeichnung, NEW.Preis);

      RAISE WARNING 'Die Ware wurde bereits in einer Rechnung verwendet. Neue VNr: %', NEW.VNr;
      
      NEW.Preis := OLD.Preis; -- Den alten Preis wiederherstellen
    END IF;
  ELSE -- NEW.Preis == OLD.Preis
    RAISE NOTICE 'Der Preis der Ware bleibt unverändert.';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql; --Erlaubt auch IF WHILE etc zu benutzen

CREATE TRIGGER ware_price_trigger BEFORE UPDATE ON Ware
FOR EACH ROW
EXECUTE FUNCTION update_ware_price();
