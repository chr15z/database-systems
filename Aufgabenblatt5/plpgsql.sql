--- Trigger 1 --- Datum Korrektur hinzufuegen
CREATE OR REPLACE FUNCTION fFixAddDate() RETURNS TRIGGER AS $$
DECLARE
    pl_date DATE;
BEGIN
    SELECT datum INTO pl_date FROM Playlist pl WHERE pl.pid = NEW.pid AND pl.name = NEW.name;
    NEW.datum := GREATEST(pl_date, NEW.datum);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trFixAddDate BEFORE INSERT
    ON hinzugefuegt FOR EACH ROW EXECUTE PROCEDURE fFixAddDate();

--- Trigger 2 ---
CREATE OR REPLACE FUNCTION fPlaylistAdd() RETURNS TRIGGER AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec in (SELECT elternpid, elternname FROM teil_von WHERE
    	        NEW.name = kindname AND NEW.pid = kindpid) LOOP
	IF NOT EXISTS(SELECT * FROM hinzugefuegt WHERE
	       	      pid = rec.elternpid AND name = rec.elternname AND
		      NEW.sid = sid AND NEW.titel = titel) THEN
	    INSERT INTO hinzugefuegt VALUES (NEW.sid, NEW.titel, NEW.email,
	    	   		     	     rec.elternpid, rec.elternname, NEW.datum);
        END IF;					    
    END LOOP;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trPlaylistAdd AFTER INSERT ON hinzugefuegt
       FOR EACH ROW EXECUTE PROCEDURE fPlaylistAdd();
   
--- Trigger 3 --- UPDATE zuletzt
CREATE OR REPLACE FUNCTION fAnzahlChange() RETURNS TRIGGER AS $$
DECLARE
    new_time TIMESTAMP := NOW();
BEGIN
    IF NEW.anzahl > OLD.anzahl THEN
       UPDATE hoert SET zuletzt = new_time
       	      WHERE sid = NEW.sid AND titel = NEW.titel
	      	    AND email = NEW.email;
		    
	RAISE NOTICE 'Zuletzte gehoert auf % aktualisiert', new_time;
    ELSIF NEW.anzahl = OLD.anzahl THEN
        RAISE WARNING 'Anzahl blieb gleich!';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trAnzahlChange AFTER UPDATE OF anzahl ON hoert
       FOR EACH ROW EXECUTE PROCEDURE fAnzahlChange();


--- Procedure 1 --- Erstellen einer Remastered CD

CREATE OR REPLACE FUNCTION CreateCD(p_songs INTEGER, p_SaengVName VARCHAR(255), p_SaengNName VARCHAR(255), p_ProdVName VARCHAR(255), p_ProdNName VARCHAR(255)) RETURNS void AS $$
DECLARE
   v_type CDTYPE;
   v_cdnr INTEGER;
   v_tnr INTEGER := 0;
   v_cdname VARCHAR(255);
   rec RECORD;
BEGIN
    IF p_songs < 2 THEN
       RAISE EXCEPTION 'Mindestens 2 Songs auf CD!';
    END IF;

    v_cdname := CONCAT('Best of ', p_SaengVName, ' ', p_SaengNName);
    IF EXISTS(SELECT * FROM Album WHERE name = v_cdname) THEN
       RAISE EXCEPTION 'Was already created!';
    END IF;

    CASE
	WHEN p_songs < 5 THEN v_type = 'EP';
	ELSE v_type = 'Album';
    END CASE;

    INSERT INTO Album VALUES(v_cdname, date_part('year', NOW()),
    			     p_ProdVName, p_ProdNName,
    	   	             p_SaengVName, p_SaengNName);

    SELECT COALESCE(MAX(nr), 0)+1 INTO v_cdnr FROM CD WHERE type=v_type;
    INSERT INTO CD VALUES (v_cdname, v_cdnr, v_type, 'DBAI');

    FOR rec in SELECT titel, sid FROM Lied l NATURAL JOIN singt s
    	       WHERE s.vname = p_SaengVName AND s.nname = p_SaengNName
	       ORDER BY RANDOM() LIMIT p_songs LOOP
	       v_tnr := v_tnr + 1;
	       INSERT INTO Track VALUES (v_cdname, v_cdnr, v_type,
	       	      	   	 	 rec.titel, rec.sid, v_tnr,
					 rec.titel || ' Remastered');
    END LOOP;

    IF v_tnr <= p_songs THEN
       RAISE EXCEPTION 'Not enough songs by SaengerIn for Album';
    END IF;
END;
$$ LANGUAGE plpgsql;

