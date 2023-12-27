INSERT INTO Mitarbeiterin (SVNR, Name) VALUES 
	(1, 'Name 1'),
	(2, 'Name 2'),
	(3, 'Name 3'),
	(4, 'Name 4');

INSERT INTO Filiale (Land, Adresse, SVNR) VALUES 
	('Land 1', 'Adresse 1', 1), 
	('Land 2', 'Adresse 2', 2),
	('Land 3', 'Adresse 3', 3);
	
update mitarbeiterin set filialnr = 100 where svnr = 1;
update mitarbeiterin set filialnr = 110 where svnr = 2;
update mitarbeiterin set filialnr = 120 where svnr = 3;

INSERT INTO Kassa (Filialnr,  Modell)VALUES 
	(100, 'OLYMPIA'),
	(100,  'QUIO'),
	(110, 'OLYMPIA'),
	(120,  'STAR');
 
update Filiale set Hauptkassa_KNR = 2 where Filialnr = 100;
update Filiale set Hauptkassa_KNR = 12 where Filialnr = 110;
update Filiale set Hauptkassa_KNR = 17 where Filialnr = 120;

INSERT INTO Rechnung (Filialnr, KNR, Jahr, RNR, Rabatt) VALUES 
	(100, 2, 2023, 1, 0.1),
	(100, 7, 2023, 2, 0.2),
	(110, 12, 2023, 3, 0.3);

INSERT INTO Versandlager (Filialnr, m2) VALUES 
	(100, 500),
	(110, 800),
	(120, 300);

INSERT INTO Produktion (Filialnr, SecLvl) VALUES 
	(100, 1),
	(110, 2),
	(120, 3);

INSERT INTO Ware (VNr, Herstellerin, SerNr, Bezeichnung, Preis) VALUES 
	(1, 'Herstellerin 1', 1, 'AAAA#11111', 10.00),
	(2, 'Herstellerin 2', 2, 'BBBB#11111', 20.00),
	(3, 'Herstellerin 3', 3, 'CCCC#11111', 30.00);

INSERT INTO enthaelt (Filialnr, KNR, Jahr, RNR, VNr, Herstellerin, SerNr, Anzahl) VALUES 
	(100, 2, 2023, 1, 1, 'Herstellerin 1', 1, 10),
	(100, 7, 2023, 2, 2, 'Herstellerin 2', 2, 20),
	(110, 12, 2023, 3, 3, 'Herstellerin 3', 3, 30);

INSERT INTO hergestellt (VNr, Herstellerin, SerNr, Filialnr, Datum) VALUES 
	(1, 'Herstellerin 1', 1, 100, '2023-01-01'),
	(2, 'Herstellerin 2', 2, 110, '2023-02-02'),
	(3, 'Herstellerin 3', 3, 120, '2023-03-03');

INSERT INTO angeworben (Neuling, Werberin, Datum) VALUES 
	(1, 2, '2023-01-01'),
	(2, 3, '2023-02-02'),
	(3, 4, '2023-03-03');

INSERT INTO schult (Azubi, Trainerin, Filialnr, KNR, Bewertung) VALUES 
	(1, 2, 100, 2, 5),
	(2, 3, 100, 7, 4),
	(3, 1, 110, 12, 3);

