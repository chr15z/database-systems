--- Trigger for 4.a --- 
CREATE OR REPLACE FUNCTION fAddGreenhouse() RETURNS TRIGGER AS $$
DECLARE
	Estate_Size NUMERIC(10, 2);
BEGIN
	SELECT Size INTO Estate_Size FROM Estate WHERE Address = NEW.Address;
	
	IF NEW.Size = 0 THEN 
		NEW.Size := Estate_Size;
	END IF;
	
	IF NEW.Size < Estate_Size THEN 
		RETURN NEW;
	END IF;
	
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trAddGreenhouse BEFORE INSERT
    ON Greenhouse FOR EACH ROW EXECUTE PROCEDURE fAddGreenhouse();


--- Trigger for 4.b ---
CREATE OR REPLACE FUNCTION fUpdatePlant() RETURNS TRIGGER AS $$
DECLARE
	rec RECORD;
BEGIN
	--- Update any dung that is used for dunging the plant ---
	IF NEW.Count != OLD.Count THEN
		FOR rec in (SELECT d.Type, d.Stock FROM Dung d, dungs dd WHERE d.Type = dd.Type AND dd.GId = NEW.GId AND 
					dd.Address = NEW.Address AND dd.Name = NEW.Name) LOOP
			UPDATE Dung SET Stock = Stock + (NEW.Count - OLD.Count) WHERE Type = rec.Type;
			RAISE NOTICE 'Stock was set to %.', (rec.Stock + (NEW.Count - OLD.Count));
		END LOOP;
	ELSE
		RAISE WARNING 'Number of plants did not change!';        
	END IF;					    

    RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trUpdatePlant BEFORE UPDATE OF Count ON Plants
       FOR EACH ROW EXECUTE PROCEDURE fUpdatePlant();

--- Trigger for 4.c ---
CREATE OR REPLACE FUNCTION fSizeUpdate() RETURNS TRIGGER AS $$
BEGIN
	IF NEW.Size != OLD.Size THEN
		UPDATE Estate SET Size = Size + (NEW.Size - OLD.Size)
       	    WHERE (Address) in (SELECT e.Estate_Address FROM contains e 
				WHERE OLD.Address = e.Address_Of_Estate_PType);
	END IF;
		RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trSizeUpdate AFTER UPDATE OF Size ON Estate
       FOR EACH ROW EXECUTE PROCEDURE fSizeUpdate();


--- Prozedure for 4.d ---
CREATE OR REPLACE FUNCTION CreateHeating_Systems(IN HkW NUMERIC, IN CountHeating_Systemn INTEGER, IN GrundtsuecksSize NUMERIC) RETURNS VOID AS
$$
DECLARE
    maxAdressNr Integer;
	maxAdress VARCHAR(2);
BEGIN

    IF CountHeating_Systemn < 1 THEN
        RAISE EXCEPTION 'Number of heating systems must at least be 1';
    END IF;

	SELECT MAX(CAST(SUBSTRING(Address, 2, 100) AS INT)) INTO maxAdressNr FROM Estate WHERE Address ~* '^A\d+$';
	
	-- Compute a free address string
	IF maxAdressNr IS NULL THEN 
		maxAdress = 'A1';
	ELSE
		SELECT CONCAT('A', maxAdressNr + 1) INTO maxAdress;
	END IF;

	FOR counter IN 0 .. CountHeating_Systemn - 1
    LOOP
		PERFORM NEXTVAL('seq_heatingsys');
		
		IF counter = 0 THEN
			-- Create the estate
			-- Use the first heating system as the primary heating system of the estate
			INSERT INTO Estate(Address, Size, Primary_Heating_System_HId, Primary_Heating_System_Address) VALUES 
				(maxAdress, GrundtsuecksSize, CURRVAL('seq_heatingsys'), maxAdress);
		END IF;
		
		-- Create a heating system
		INSERT INTO Heating_System(Address, HId, kW) VALUES 
				(maxAdress, CURRVAL('seq_heatingsys'), HkW);	
        
		-- Create the specific kind of heating systems
		CASE counter % 2	
			WHEN 0 THEN			
				INSERT INTO Heat_Pump(Address, HId) VALUES 
				(maxAdress, CURRVAL('seq_heatingsys'));
            WHEN 1 THEN
				INSERT INTO Gas_Heating(Address, HId) VALUES 
				(maxAdress, CURRVAL('seq_heatingsys'));
        END CASE;		
   END LOOP;
END;
$$ LANGUAGE plpgsql;