-- Erstellen der Sequence "seq_fnr" (Aufgabe 1b)
CREATE SEQUENCE seq_fnr INCREMENT BY 5 MINVALUE 2 NOCYCLE;

-- Erstellen der Sequence "seq_knr" (Aufgabe 1c)
CREATE SEQUENCE seq_knr INCREMENT BY 5 MINVALUE 2 NOCYCLE;

-- Erstellen eines ENUM-Type (Aufgabe 1d)
CREATE TYPE ModellEnum AS ENUM ('OLYMPIA', 'QUIO', 'STAR');

-- Ändern der Tabelle "Kassa" um die Sequence zu verwenden
ALTER TABLE Kassa
  MODIFY KNR DEFAULT seq_knr.NEXTVAL;

-- Erstellen der Tabelle "Filiale"
CREATE TABLE Filiale (
  Filialnr INT NOT NULL DEFAULT NEXTVAL('seq_fnr'),	
  Land VARCHAR(255) NOT NULL,
  Adresse VARCHAR(255) NOT NULL,
  SVNR INT NOT NULL,
  Hauptkassa_KNR INT NOT NULL,
  FOREIGN KEY (SVNR) REFERENCES Mitarbeiterin (SVNR),
  FOREIGN KEY (Hauptkassa_KNR, Filialnr) REFERENCES Kassa (KNR, Filialnr),
  PRIMARY KEY (Filialnr)
);

-- Erstellen der Tabelle "Kassa"
CREATE TABLE Kassa (
  Filialnr INT NOT NULL,
  KNR INT NOT NULL,
  Modell ModellEnum NOT NULL,
  FOREIGN KEY (Filialnr) REFERENCES Filiale (Filialnr),
  PRIMARY KEY(KNR, Filialnr)
);

-- Erstellen der Tabelle "Rechnung"
CREATE TABLE Rechnung (
  Filialnr INT NOT NULL,
  KNR INT NOT NULL,
  Jahr INT NOT NULL,
  RNR INT NOT NULL,
  Rabatt NUMERIC(2,2) NOT NULL CHECK(Rabatt >= 0),   --  Aufgabe 1e)
  FOREIGN KEY (Filialnr, KNR) REFERENCES Kassa (Filialnr, KNR),
  PRIMARY KEY (Filialnr, KNR, Jahr, RNR)
);

-- Erstellen der Tabelle "FK"             //??
CREATE TABLE FK (
  Filialnr INT NOT NULL,
  KNR INT NOT NULL,
  FOREIGN KEY (Filialnr, KNR) REFERENCES Kassa (Filialnr, KNR)
);

-- Erstellen der Tabelle "Versandlager"
CREATE TABLE Versandlager (
  Filialnr INT NOT NULL,
  m2 INT NOT NULL,
  FOREIGN KEY (Filialnr) REFERENCES Filiale (Filialnr),
  PRIMARY KEY (Filialnr)
);

-- Erstellen der Tabelle "Produktion"
CREATE TABLE Produktion (
  Filialnr INT NOT NULL,
  SecLvl INT NOT NULL,
  FOREIGN KEY (Filialnr) REFERENCES Versandlager (Filialnr),
  PRIMARY KEY (Filialnr)
);

-- Erstellen der Tabelle "Mitarbeiterin"  // Filialnummer muss mit ??
CREATE TABLE Mitarbeiterin (
  SVNR INT NOT NULL,
  Name VARCHAR(255) NOT NULL,
  Filialnr INT NOT NULL,
  FOREIGN KEY (Filialnr) REFERENCES Filiale (Filialnr),
  PRIMARY KEY (SVNR)
);

-- Erstellen der Tabelle "Ware"
CREATE TABLE Ware (
  VNr INT NOT NULL,
  Herstellerin VARCHAR(255) NOT NULL,
  SerNr INT NOT NULL,
  Bezeichnung VARCHAR(255) NOT NULL CHECK(Bezeichnung ~ '^[A-Z]{4}#[A-Za-z0-9]{5}$'),
  Preis NUMERIC(10,2) NOT NULL CHECK(Preis > 0),  --  Aufgabe 1e)
  PRIMARY KEY (VNr, Herstellerin, SerNr)
);

-- Erstellen der Tabelle "enthaelt"    //Warum steht das in der Angabe doppelt?
CREATE TABLE enthaelt (
  Filialnr INT NOT NULL,
  KNR INT NOT NULL,
  Jahr INT NOT NULL,
  RNR INT NOT NULL,
  VNr INT NOT NULL,
  Herstellerin VARCHAR(255) NOT NULL,
  SerNr INT NOT NULL,
  Anzahl INT NOT NULL,
  PRIMARY KEY (Filialnr, KNR, Jahr, RNR),
  FOREIGN KEY (Filialnr, KNR, Jahr, RNR) REFERENCES Rechnung (Filialnr, KNR, Jahr, RNR),
  FOREIGN KEY (VNr, Herstellerin, SerNr) REFERENCES Ware (VNr, Herstellerin, SerNr)
);

-- Erstellen der Tabelle "hergestellt"
CREATE TABLE hergestellt (
  VNr INT NOT NULL,
  Herstellerin VARCHAR(255) NOT NULL,
  SerNr INT NOT NULL,
  Filialnr INT NOT NULL,
  Datum DATE NOT NULL CHECK(Datum > DATE '2020-04-10'),
  PRIMARY KEY (VNr, Herstellerin, SerNr),
  FOREIGN KEY (VNr, Herstellerin, SerNr) REFERENCES Ware (VNr, Herstellerin, SerNr),
  FOREIGN KEY (Filialnr) REFERENCES Produktion (Filialnr)
);

-- Erstellen der Tabelle "angeworben"
CREATE TABLE angeworben (
  Neuling INT NOT NULL,
  Werberin INT NOT NULL,
  Datum DATE NOT NULL,
  PRIMARY KEY (Neuling),
  FOREIGN KEY (Neuling) REFERENCES Mitarbeiterin (SVNR),
  FOREIGN KEY (Werberin) REFERENCES Mitarbeiterin (SVNR)
);

-- Erstellen der Tabelle "schult"
CREATE TABLE schult (
  Azubi INT NOT NULL,
  Trainerin INT NOT NULL,
  Filialnr INT NOT NULL,
  KNR INT NOT NULL,
  Bewertung INT NOT NULL,
  PRIMARY KEY (Azubi, Trainerin, Filialnr, KNR),
  FOREIGN KEY (Azubi) REFERENCES Mitarbeiterin (SVNR),
  FOREIGN KEY (Trainerin) REFERENCES Mitarbeiterin (SVNR),
  FOREIGN KEY (Filialnr, KNR) REFERENCES Kassa (Filialnr, KNR)
);

-- Hinzufügen der Unique Constraint auf die Spalten Azubi und Filialnr in der Tabelle "schult"
ALTER TABLE schult
  ADD CONSTRAINT UQ_schult_Azubi_Filialnr UNIQUE (Azubi, Filialnr);

-- Hinzufügen einer Unique Constraint auf der Tabelle "angeworben"
ALTER TABLE angeworben
  ADD CONSTRAINT unique_neuling_werberin UNIQUE (Neuling, Werberin);

