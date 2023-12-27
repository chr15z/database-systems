BEGIN;

/* Die Reihenfolge der DELETE Answeisungen ist wichtig */

DELETE FROM schult;
DELETE FROM angeworben;
DELETE FROM hergestellt;
DELETE FROM enthaelt;
DELETE FROM Ware;
DELETE FROM Mitarbeiterin;
DELETE FROM Produktion;
DELETE FROM Versandlager;
DELETE FROM FK;
DELETE FROM Rechnung;
DELETE FROM Kassa;
DELETE FROM Filiale;

SELECT setval('seq_fnr', 2, false);
SELECT setval('seq_knr', 2, false);

COMMIT;

BEGIN;

-- Einfügen von Testdaten in die Tabelle "Filiale"
INSERT INTO Filiale (Land, Adresse, SVNR)
VALUES ('Land 1', 'Adresse 1', 1),
VALUES ('Land 2', 'Adresse 2', 2),
VALUES ('Land 3', 'Adresse 3', 3);

-- Einfügen von Testdaten in die Tabelle "Kassa"
INSERT INTO Kassa (Filialnr, KNR, Modell)
VALUES (100, 2, 'OLYMPIA'),
VALUES (100, 7, 'QUIO'),
VALUES (110, 12, 'OLYMPIA'),
VALUES (120, 6, 'STAR');

COMMIT;

-- Einfügen von Testdaten in die Tabelle "Rechnung"
INSERT INTO Rechnung (Filialnr, KNR, Jahr, RNR, Rabatt)
VALUES (100, 2, 2023, 1, 0.1),
VALUES (100, 7, 2023, 2, 0.2),
VALUES (110, 12, 2023, 3, 0.3),
VALUES (120, 6, 2023, 2, 0.8),;

-- Einfügen von Testdaten in die Tabelle "FK"
INSERT INTO FK (Filialnr, KNR)
VALUES (100, 2),
VALUES (100, 7),
VALUES (110, 12), 
VALUES (120, 6);

-- Einfügen von Testdaten in die Tabelle "Versandlager"
INSERT INTO Versandlager (Filialnr, m2)
VALUES (100, 500),
VALUES (110, 800),
VALUES (120, 300);

-- Einfügen von Testdaten in die Tabelle "Produktion"
INSERT INTO Produktion (Filialnr, SecLvl)
VALUES (100, 1),
VALUES (110, 2),
VALUES (120, 3);

-- Einfügen von Testdaten in die Tabelle "Mitarbeiterin"
INSERT INTO Mitarbeiterin (SVNR, Name, Filialnr)
VALUES (1, 'Name 1', 100),
VALUES (2, 'Name 2', 110),
VALUES (3, 'Name 3', 120);

-- Einfügen von Testdaten in die Tabelle "Ware"
INSERT INTO Ware (VNr, Herstellerin, SerNr, Bezeichnung, Preis)
VALUES (1, 'Herstellerin 1', 'SerNr 1', 'Bezeichnung 1', 10.99),
VALUES (2, 'Herstellerin 2', 'SerNr 2', 'Bezeichnung 2', 19.99),
VALUES (3, 'Herstellerin 3', 'SerNr 3', 'Bezeichnung 3', 25.99);

-- Einfügen von Testdaten in die Tabelle "enthält"
INSERT INTO enthält (Filialnr, KNR, Jahr, RNR, VNr, Herstellerin, SerNr, Anzahl)
VALUES (100, 2, 2023, 1, 1, 'Herstellerin 1', 'SerNr 1', 5),
VALUES (100, 7, 2023, 2, 2, 'Herstellerin 2', 'SerNr 2', 10),
VALUES (110, 12, 2023, 3, 3, 'Herstellerin 3', 'SerNr 3', 3);

-- Einfügen von Testdaten in die Tabelle "hergestellt"
INSERT INTO hergestellt (VNr, Herstellerin, SerNr, Filialnr, Datum)
VALUES (1, 'Herstellerin 1', 'SerNr 1', 100, '2023-01-01'),
VALUES (2, 'Herstellerin 2', 'SerNr 2', 110, '2023-02-02'),
VALUES (3, 'Herstellerin 3', 'SerNr 3', 120, '2023-03-03');

-- Einfügen von Testdaten in die Tabelle "angeworben"
INSERT INTO angeworben (Neuling, Werberin, Datum)
VALUES (1, 2, '2023-01-01'),
VALUES (2, 3, '2023-02-02'),
VALUES (3, 1, '2023-03-03');

-- Einfügen von Testdaten in die Tabelle "schult"
INSERT INTO schult (Azubi, Trainerin, Filialnr, KNR, Bewertung)
VALUES (1, 2, 100, 2, 5),
VALUES (2, 3, 100, 7, 4),
VALUES (3, 1, 110, 12, 3);
