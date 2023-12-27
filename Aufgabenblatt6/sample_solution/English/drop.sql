DROP FUNCTION CreateHeating_Systems(NUMERIC, INTEGER, NUMERIC);

DROP TRIGGER trAddGreenhouse ON Greenhouse;
DROP FUNCTION fAddGreenhouse();

DROP TRIGGER trUpdatePlant ON Plants;
DROP FUNCTION fUpdatePlant();

DROP TRIGGER trSizeUpdate ON Estate;
DROP FUNCTION fSizeUpdate();

DROP VIEW NeighbourhoodSize;
DROP VIEW AllBlockNeighbours;
DROP VIEW NumberOfBigGreenhouses;

ALTER TABLE Estate DROP CONSTRAINT fk_PrimaryHeatingSystem;

DROP TABLE dungs;
DROP TABLE Dung;
DROP TABLE Succulents;
DROP TABLE Orchids;
DROP TABLE Palmtrees;
DROP TABLE Plants;
DROP TABLE Checkup;
DROP TABLE Employee;
DROP TABLE heats;
DROP TABLE Greenhouse;
DROP TABLE Gas_Heating;
DROP TABLE Heat_Pump;
DROP TABLE Heating_System;
DROP TABLE contains;
DROP TABLE neighbouring;
DROP TABLE Estate;
DROP TYPE ColorEnum;

DROP SEQUENCE seq_greenhouse;
DROP SEQUENCE seq_heatingsys;