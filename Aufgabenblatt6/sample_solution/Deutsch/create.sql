CREATE SEQUENCE seq_greenhouse INCREMENT BY 3 MINVALUE 1 NO CYCLE;
CREATE SEQUENCE seq_heatingsys INCREMENT BY 10 MINVALUE 1000 NO CYCLE;
CREATE TYPE ColorEnum AS ENUM ('Weiss', 'Rosa', 'Gelb');

CREATE TABLE Grundstueck (
	Adresse VARCHAR(255) NOT NULL,
	Groesse NUMERIC(10, 2) CHECK(Groesse > 0),
	Primaerheizanlage_HId INTEGER NOT NULL, 
	Primaerheizanlage_Adresse VARCHAR(255) NOT NULL,
	PRIMARY KEY(Adresse)
);

CREATE TABLE grenzt_an (
	Grundstuecks_Adresse VARCHAR(255) NOT NULL,
	Nachbar_Adresse VARCHAR(255) NOT NULL,
	FOREIGN KEY(Grundstuecks_Adresse) REFERENCES Grundstueck(Adresse),
	FOREIGN KEY(Nachbar_Adresse) REFERENCES Grundstueck(Adresse),
	PRIMARY KEY(Grundstuecks_Adresse, Nachbar_Adresse)
);

CREATE TABLE enthaelt (
	Grundstuecks_Adresse VARCHAR(255) NOT NULL,
	Adresse_Des_Teilgrundstuecks VARCHAR(255) NOT NULL,
	FOREIGN KEY(Grundstuecks_Adresse) REFERENCES Grundstueck(Adresse),
	FOREIGN KEY(Adresse_Des_Teilgrundstuecks) REFERENCES Grundstueck(Adresse),
	PRIMARY KEY(Grundstuecks_Adresse, Adresse_Des_Teilgrundstuecks)
);

CREATE TABLE Heizanlage (
	Adresse VARCHAR(255) NOT NULL,
	HId INTEGER NOT NULL DEFAULT NEXTVAL('seq_heatingsys'),
	kW NUMERIC(10,2) NOT NULL,	
	FOREIGN KEY(Adresse) REFERENCES Grundstueck(Adresse),
	PRIMARY KEY(HId, Adresse)
);

ALTER TABLE Grundstueck ADD CONSTRAINT fk_PrimaryHeatingSystem
      FOREIGN KEY (Primaerheizanlage_HId, Primaerheizanlage_Adresse) REFERENCES Heizanlage(HId, Adresse)
      DEFERRABLE INITIALLY DEFERRED;	  

CREATE TABLE Waermepumpe (
	Adresse VARCHAR(255) NOT NULL,
	HId INTEGER NOT NULL,
	FOREIGN KEY(Adresse, HId) REFERENCES Heizanlage(Adresse, HId),
	PRIMARY KEY(HId, Adresse)
);

CREATE TABLE Gasheizung (
	Adresse VARCHAR(255) NOT NULL,
	HId INTEGER NOT NULL,
	FOREIGN KEY(Adresse, HId) REFERENCES Heizanlage(Adresse, HId),
	PRIMARY KEY(HId, Adresse)
);

CREATE TABLE Gewaechshaus (
	Adresse VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL DEFAULT NEXTVAL('seq_greenhouse'),	
	Groesse NUMERIC(10,2) NOT NULL CHECK(Groesse > 0),	
	FOREIGN KEY(Adresse) REFERENCES Grundstueck(Adresse),
	PRIMARY KEY(GId, Adresse)
);

CREATE TABLE beheizt (
	Heizanlage_Adresse VARCHAR(255) NOT NULL,
	HId INTEGER NOT NULL,
	Gewaechshaus_Adresse VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL,
	FOREIGN KEY(Heizanlage_Adresse, HId) REFERENCES Heizanlage(Adresse, HId),
	FOREIGN KEY(Gewaechshaus_Adresse, GId) REFERENCES Gewaechshaus(Adresse, GId),
	PRIMARY KEY(Heizanlage_Adresse, HId, Gewaechshaus_Adresse, GId)
);

CREATE TABLE Angestellter (
	SVNR VARCHAR(255) NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Adresse VARCHAR(255) NOT NULL,
	PRIMARY KEY(SVNR)
);

CREATE TABLE Kontrolle (
	Adresse VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL,
	SVNR VARCHAR(255) NOT NULL,
	Hauptangestellter_SVNR VARCHAR(255) NOT NULL,
	Datum DATE NOT NULL CHECK(Datum > '1990-02-01'::DATE),
	Beobachtung VARCHAR(255) NOT NULL,
	FOREIGN KEY(Adresse, GId) REFERENCES Gewaechshaus(Adresse, GId),
	FOREIGN KEY(SVNR) REFERENCES Angestellter(SVNR),
	FOREIGN KEY(Hauptangestellter_SVNR) REFERENCES Angestellter(SVNR),
	PRIMARY KEY(Adresse, GId, SVNR, Datum)
);

CREATE TABLE Pflanzen (
	Adresse VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Anzahl INTEGER NOT NULL,
	FOREIGN KEY(Adresse, GId) REFERENCES Gewaechshaus(Adresse, GId),
	PRIMARY KEY(Adresse, GId, Name)
);

CREATE TABLE Palmen (
	Adresse VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Winterhart VARCHAR(255) NOT NULL,
	FOREIGN KEY(Adresse, GId, Name) REFERENCES Pflanzen(Adresse, GId, Name),
	PRIMARY KEY(Adresse, GId, Name)
);

CREATE TABLE Orchideen (
	Adresse VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Farbe ColorEnum NOT NULL,
	FOREIGN KEY(Adresse, GId, Name) REFERENCES Pflanzen(Adresse, GId, Name),
	PRIMARY KEY(Adresse, GId, Name)
);

CREATE TABLE Sukkulenten (
	Adresse VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL,
	Name VARCHAR(255) NOT NULL,
	FOREIGN KEY(Adresse, GId, Name) REFERENCES Pflanzen(Adresse, GId, Name),
	PRIMARY KEY(Adresse, GId, Name)
);

CREATE TABLE Duenger (
	Art VARCHAR(255) NOT NULL CHECK(Art ~* $$^([a-zA-Z]){3}-\w{6}$$),
	Lagerbestand INTEGER NOT NULL,
	PRIMARY KEY(Art)
);

CREATE TABLE duengt (
	SVNR VARCHAR(255) NOT NULL,
	Art VARCHAR(255) NOT NULL,
	Adresse VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL,
	Name VARCHAR(255) NOT NULL,
	UNIQUE(Adresse, GId, Name),
	UNIQUE(SVNR, Art),
	FOREIGN KEY(SVNR) REFERENCES Angestellter(SVNR),
	FOREIGN KEY(Art) REFERENCES Duenger(Art),
	FOREIGN KEY(Adresse, GId, Name) REFERENCES Pflanzen(Adresse, GId, Name),
	PRIMARY KEY(SVNR, Art, Adresse, GId, Name)
);