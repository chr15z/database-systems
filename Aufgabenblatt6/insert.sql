BEGIN;

/* Die Reihenfolge der DELETE Answeisungen ist wichtig */

DELETE FROM duengt;
DELETE FROM Duenger;
DELETE FROM Sukkulenten;
DELETE FROM OrchIdeen;
DELETE FROM Palmen;
DELETE FROM Pflanzen;
DELETE FROM Kontrolle;
DELETE FROM Angestellter;
DELETE FROM beheizt;
DELETE FROM Gewaechshaus;
DELETE FROM Gasheizung;
DELETE FROM Waermepumpe;
DELETE FROM Heizanlage;
DELETE FROM enthaelt;
DELETE FROM grenzt_an;
DELETE FROM Grundstueck;


SELECT setval('seq_greenhouse', 1, false);
SELECT setval('seq_heatingsys', 1000, false);

COMMIT;


BEGIN;

INSERT INTO Grundstueck(Adresse, Groesse, Primaerheizanlage_HId, Primaerheizanlage_Adresse) VALUES
		('A1', '100', 1000, 'A3'),
		('A2', '200', 1010, 'A3'),
		('A3', '300', 1020, 'A3'),
		('A4', '100', 1030, 'A4'),
		('A5', '300', 1040, 'A4');


INSERT INTO Heizanlage(Adresse, kW) VALUES
		('A3', 30),
		('A3', 20),
		('A3', 50),
		('A4', 100),
		('A4', 150),
		('A5', 40);		
COMMIT;


SELECT CreateHeatingSystems(10, 5, 20);
SELECT CreateHeatingSystems(30, 4, 40);

INSERT INTO grenzt_an(Grundstuecks_Adresse, Nachbar_Adresse) VALUES
		('A1', 'A2'),
		('A2', 'A3'),
		('A3', 'A4'),
		('A4', 'A5');

INSERT INTO enthaelt(Grundstuecks_Adresse, Adresse_Des_Teilgrundstuecks) VALUES
		('A3', 'A2'),
		('A2', 'A1'),
		('A5', 'A4'),
		('A5', 'A6');

INSERT INTO Gewaechshaus(Adresse, Groesse) VALUES
		('A1', 10),
		('A2', 20),
		('A3', 30),
		('A4', 40),
		('A5', 50),
		('A5', 60);


INSERT INTO beheizt(Heizanlage_Adresse, HId, Gewaechshaus_Adresse, GId) VALUES
		('A3', 1020, 'A1', 1),
		('A3', 1020, 'A2', 4),
		('A3', 1020, 'A4', 10),
		('A4', 1030, 'A2', 4),
		('A4', 1030, 'A5', 13);


INSERT INTO Angestellter(SVNR, Name, Adresse) VALUES
	(1, 'Hans', 'Adresse 1'),
	(2, 'Noah', 'Adresse 2'),
	(3, 'Elina', 'Adresse 3'),
	(4, 'Livia', 'Adresse 4');
	

INSERT INTO Kontrolle(Adresse, GId, SVNR, Hauptangestellter_SVNR, Datum, Beobachtung) VALUES
	('A1', 1, 1, 4, '1990-02-02', 'Trockene Blaetter: Zu wenig oder zu viel Wasser?'),
	('A2', 4, 4, 2, '2020-04-10', 'Warnung: Einige Blaetter sind klebrig geworden + Es scheinen sich einige Spinnweben auf den Blaettern zu befinden.'),
	('A2', 4, 4, 2, '2020-04-15', 'Warnung: Wir koennten einen Schaedlingsbefall haben, da einige schwarze Punkte auf den Blaettern aufgetaucht sind.'),
	('A2', 4, 4, 3, '2020-04-24', 'Achtung: Spinnmilbe haben sich ueber die gesamte Plantage ausgebreitet.'),
	('A2', 4, 1, 1, '2020-04-24', 'Aktion: Waschen der Blaetter aller Pflanten wird hoffentlich die Spinnmilben für immer entfernen.');


INSERT INTO Pflanzen(Adresse, GId, Name, Anzahl) VALUES
	('A2', 4, 'Mazari palm', 35),
	('A2', 4, 'Cat palm', 22),
	('A2', 4, 'Triangle palm', 19),
	('A3', 7, 'Lipstick palm', 13),
	('A3', 7, 'Cymbidium orchid', 53),
	('A4', 10, 'Miltonia orchid', 48),
	('A4', 10, 'Paphiopedilum orchid', 58),
	('A1', 1, 'Panda plant', 19),
	('A1', 1, 'Aloe Vera', 19),
	('A1', 1, 'Flaming Katy', 19);


INSERT INTO Palmen(Adresse, GId, Name, Winterhart) VALUES
	('A2', 4, 'Mazari palm', 'Nein'),
	('A2', 4, 'Cat palm', 'Nein'),
	('A2', 4, 'Triangle palm', 'Nein'),
	('A3', 7, 'Lipstick palm', 'Nein');


INSERT INTO Orchideen(Adresse, GId, Name, Farbe) VALUES
	('A3', 7, 'Cymbidium orchid', 'Weiss'),
	('A4', 10, 'Miltonia orchid', 'Rosa'),
	('A4', 10, 'Paphiopedilum orchid', 'Gelb');

INSERT INTO Sukkulenten(Adresse, GId, Name) VALUES
	('A1', 1, 'Panda plant'),
	('A1', 1, 'Aloe Vera'),
	('A1', 1, 'Flaming Katy');


INSERT INTO Duenger(Lagerbestand, Art) VALUES
	(140, 'DGE-a64g56'),
	(130, 'PsT-b6hhh6'),
	(100, 'pes-XS6000');


INSERT INTO duengt(SVNR, Art, Adresse, GId, Name) VALUES
	(1, 'DGE-a64g56', 'A2', 4, 'Mazari palm'),
	(2, 'DGE-a64g56', 'A2', 4, 'Cat palm'),
	(3, 'DGE-a64g56', 'A4', 10, 'Miltonia orchid');