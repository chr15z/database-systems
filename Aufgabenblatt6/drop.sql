DROP FUNCTION CreateHeatingSystems(NUMERIC, INTEGER, NUMERIC);

DROP TRIGGER trAddGreenhouse ON Gewaechshaus;
DROP FUNCTION fAddGreenhouse();

DROP TRIGGER trUpdatePlant ON Pflanzen;
DROP FUNCTION fUpdatePlant();

DROP TRIGGER trSizeUpdate ON Grundstueck;
DROP FUNCTION fSizeUpdate();

DROP VIEW NeighbourhoodSize;
DROP VIEW AllBlockNeighbours;
DROP VIEW NumberOfBigGreenhouses;

ALTER TABLE Grundstueck DROP CONSTRAINT fk_PrimaryHeatingSystem;

DROP TABLE duengt;
DROP TABLE Duenger;
DROP TABLE Sukkulenten;
DROP TABLE OrchIdeen;
DROP TABLE Palmen;
DROP TABLE Pflanzen;
DROP TABLE Kontrolle;
DROP TABLE Angestellter;
DROP TABLE beheizt;
DROP TABLE Gewaechshaus;
DROP TABLE Gasheizung;
DROP TABLE Waermepumpe;
DROP TABLE Heizanlage;
DROP TABLE enthaelt;
DROP TABLE grenzt_an;
DROP TABLE Grundstueck;
DROP TYPE ColorEnum;

DROP SEQUENCE seq_greenhouse;
DROP SEQUENCE seq_heatingsys;