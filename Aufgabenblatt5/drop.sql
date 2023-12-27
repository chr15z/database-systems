DROP TRIGGER trFixAddDate ON hinzugefuegt;
DROP TRIGGER trAnzahlChange ON hoert;
DROP TRIGGER trPlaylistAdd ON hinzugefuegt;

DROP FUNCTION fFixAddDate();
DROP FUNCTION fAnzahlChange();
DROP FUNCTION fPlaylistAdd();
DROP FUNCTION CreateCD(INTEGER, VARCHAR(255), VARCHAR(255), VARCHAR(255), VARCHAR(255));

DROP VIEW CDDauer;
DROP VIEW AllAlias;

ALTER TABLE Account DROP CONSTRAINT fk_lieblingsplaylist;
DROP TABLE alias_von;
DROP TABLE singt;
DROP TABLE hoert;
DROP TABLE teil_von;
DROP TABLE hinzugefuegt;
DROP TABLE hat_Rechte;

DROP TABLE Track;
DROP TABLE CD;
DROP TABLE Lied;
DROP TABLE Album;

DROP TABLE SaengerIn;
DROP TABLE KuenstlerIn;

DROP TABLE ProduzentIn;
DROP TABLE Person;

DROP TABLE Playlist;
DROP TABLE Account;

DROP TYPE CDTYPE;
DROP SEQUENCE seq_playlist;
DROP SEQUENCE seq_lied;
