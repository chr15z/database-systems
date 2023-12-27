BEGIN;

/* The order of the DELETE statements is important */

DELETE FROM dungs;
DELETE FROM Dung;
DELETE FROM Succulents;
DELETE FROM Orchids;
DELETE FROM Palmtrees;
DELETE FROM Plants;
DELETE FROM Checkup;
DELETE FROM Employee;
DELETE FROM heats;
DELETE FROM Greenhouse;
DELETE FROM Gas_Heating;
DELETE FROM Heat_Pump;
DELETE FROM Heating_System;
DELETE FROM contains;
DELETE FROM neighbouring;
DELETE FROM Estate;


SELECT setval('seq_greenhouse', 1, false);
SELECT setval('seq_heatingsys', 1000, false);

COMMIT;


BEGIN;

INSERT INTO Estate(Address, Size, Primary_Heating_System_HId, Primary_Heating_System_Address) VALUES
		('A1', '100', 1000, 'A3'),
		('A2', '200', 1010, 'A3'),
		('A3', '300', 1020, 'A3'),
		('A4', '100', 1030, 'A4'),
		('A5', '300', 1040, 'A4');


INSERT INTO Heating_System(Address, kW) VALUES
		('A3', 30),
		('A3', 20),
		('A3', 50),
		('A4', 100),
		('A4', 150),
		('A5', 40);		
COMMIT;


SELECT CreateHeating_Systems(10, 5, 20);
SELECT CreateHeating_Systems(30, 4, 40);

INSERT INTO neighbouring(Estate_Address, Neighbour_Address) VALUES
		('A1', 'A2'),
		('A2', 'A3'),
		('A3', 'A4'),
		('A4', 'A5');

INSERT INTO contains(Estate_Address, Address_Of_Estate_PType) VALUES
		('A3', 'A2'),
		('A2', 'A1'),
		('A5', 'A4'),
		('A5', 'A6');

INSERT INTO Greenhouse(Address, Size) VALUES
		('A1', 10),
		('A2', 20),
		('A3', 30),
		('A4', 40),
		('A5', 50),
		('A5', 60);


INSERT INTO heats(Heating_System_Address, HId, Greenhouse_Address, GId) VALUES
		('A3', 1020, 'A1', 1),
		('A3', 1020, 'A2', 4),
		('A3', 1020, 'A4', 10),
		('A4', 1030, 'A2', 4),
		('A4', 1030, 'A5', 13);


INSERT INTO Employee(SVNR, Name, Address) VALUES
	(1, 'Hans', 'Address 1'),
	(2, 'Noah', 'Address 2'),
	(3, 'Elina', 'Address 3'),
	(4, 'Livia', 'Address 4');
	

INSERT INTO Checkup(Address, GId, SVNR, main_SVNR, Date, Observation) VALUES
	('A1', 1, 1, 4, '1990-02-02', 'Dry leaves: Too little or too much water?'),
	('A2', 4, 4, 2, '2020-04-10', 'Warning: Some leaves have turned sticky + There seem to be webs on some leaves.'),
	('A2', 4, 4, 2, '2020-04-15', 'Warning: We might have pests, as some small black dots have appeared on some plants.'),
	('A2', 4, 4, 3, '2020-04-24', 'ALERT: spider mites have spreaded through the entire plantation.'),
	('A2', 4, 1, 1, '2020-04-24', 'Action: Washing the plant foliage of all plants will hopefully remove the spider mites for good.');


INSERT INTO Plants(Address, GId, Name, Count) VALUES
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


INSERT INTO Palmtrees(Address, GId, Name, Frost_Resistant) VALUES
	('A2', 4, 'Mazari palm', 'No'),
	('A2', 4, 'Cat palm', 'No'),
	('A2', 4, 'Triangle palm', 'No'),
	('A3', 7, 'Lipstick palm', 'No');


INSERT INTO Orchids(Address, GId, Name, Color) VALUES
	('A3', 7, 'Cymbidium orchid', 'White'),
	('A4', 10, 'Miltonia orchid', 'Pink'),
	('A4', 10, 'Paphiopedilum orchid', 'Yellow');

INSERT INTO Succulents(Address, GId, Name) VALUES
	('A1', 1, 'Panda plant'),
	('A1', 1, 'Aloe Vera'),
	('A1', 1, 'Flaming Katy');


INSERT INTO Dung(Stock, Type) VALUES
	(140, 'DGE-a64g56'),
	(130, 'PsT-b6hhh6'),
	(100, 'pes-XS6000');


INSERT INTO dungs(SVNR, Type, Address, GId, Name) VALUES
	(1, 'DGE-a64g56', 'A2', 4, 'Mazari palm'),
	(2, 'DGE-a64g56', 'A2', 4, 'Cat palm'),
	(3, 'DGE-a64g56', 'A4', 10, 'Miltonia orchid');