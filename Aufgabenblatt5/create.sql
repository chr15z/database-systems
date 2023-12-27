CREATE SEQUENCE seq_lied;
CREATE SEQUENCE seq_playlist INCREMENT BY 100 MINVALUE 10000 NO CYCLE;
CREATE TYPE CDTYPE AS ENUM ('Single', 'EP', 'Album');

CREATE TABLE Person (
       vname VARCHAR(255) NOT NULL,
       nname VARCHAR(255) NOT NULL,
       PRIMARY KEY(vname, nname)
);

CREATE TABLE alias_von (
       AliasVName VARCHAR(255),
       AliasNName VARCHAR(255),
       vname VARCHAR(255),
       nname VARCHAR(255),
       FOREIGN KEY (AliasVName, AliasNName) REFERENCES Person(vname, nname),
       FOREIGN KEY (vname, nname) REFERENCES Person(vname, nname),
       PRIMARY KEY (AliasVName, AliasNName)
);

CREATE TABLE KuenstlerIn (
       vname VARCHAR(255),
       nname VARCHAR(255),
       foto BYTEA NOT NULL,
       FOREIGN KEY (vname, nname) REFERENCES Person(vname, nname),
       PRIMARY KEY (vname, nname)
);


CREATE TABLE ProduzentIn (
       vname VARCHAR(255),
       nname VARCHAR(255),
       url TEXT NOT NULL,
       FOREIGN KEY (vname, nname) REFERENCES Person(vname, nname),
       PRIMARY KEY (vname, nname)
);


CREATE TABLE SaengerIn (
       vname VARCHAR(255),
       nname VARCHAR(255),
       FOREIGN KEY (vname, nname) REFERENCES KuenstlerIn(vname, nname),
       PRIMARY KEY (vname, nname)
);

CREATE TABLE Album (
       name VARCHAR(255) PRIMARY KEY ,
       jahr INTEGER NOT NULL CHECK(jahr >= 1800 AND jahr <= 3030),
       ProdVName VARCHAR(255),
       ProdNName VARCHAR(255),
       SaengVName VARCHAR(255),
       SaengNName VARCHAR(255),
       FOREIGN KEY (ProdVName, ProdNName) REFERENCES ProduzentIn(vname, nname),
       FOREIGN KEY (SaengVName, SaengNName) REFERENCES SaengerIn(vname, nname)
);

CREATE TABLE hat_Rechte (
       name VARCHAR(255) PRIMARY KEY REFERENCES Album(name),
       vname VARCHAR(255),
       nname VARCHAR(255),
       FOREIGN KEY (vname, nname) REFERENCES ProduzentIn(vname, nname)
);

CREATE TABLE CD (
       name VARCHAR(255) REFERENCES Album(name),
       nr INTEGER,
       type CDTYPE,
       label VARCHAR(255) NOT NULL,
       PRIMARY KEY(name, nr, type)
);

CREATE TABLE Lied (
       titel VARCHAR(255),
       sid INTEGER DEFAULT nextval('seq_lied'),
       dauer NUMERIC(6,1) NOT NULL CHECK(dauer >= 1),
       PRIMARY KEY(titel, sid)
);

CREATE TABLE Track (
       name VARCHAR(255),
       nr INTEGER,
       type CDTYPE,
       LiedTitel VARCHAR(255),
       sid INTEGER,
       tid INTEGER,
       titel VARCHAR(255) NOT NULL,
       FOREIGN KEY (name, nr, type) REFERENCES CD(name, nr, type),
       PRIMARY KEY (name, nr, type, LiedTitel, sid, tid)
);

CREATE TABLE singt (
       vname VARCHAR(255),
       nname VARCHAR(255),
       titel VARCHAR(255),
       sid INTEGER,
       FOREIGN KEY (vname, nname) REFERENCES SaengerIn(vname, nname),
       FOREIGN KEY (sid, titel) REFERENCES Lied(sid, titel),
       PRIMARY KEY (vname, nname, titel, sid)
);

CREATE TABLE Account (
       email VARCHAR(255) PRIMARY KEY,
       pw VARCHAR(255) NOT NULL,
       name VARCHAR(255) NOT NULL CHECK(char_length(name) > 2),
       favoritePid INTEGER NOT NULL,
       favoriteName VARCHAR(255) NOT NULL
);


CREATE TABLE hoert (
       sid INTEGER,
       titel VARCHAR(255),
       email VARCHAR(255) REFERENCES Account(email),
       anzahl INTEGER NOT NULL,
       zuletzt TIMESTAMP NOT NULL,
       FOREIGN KEY (sid, titel) REFERENCES Lied(sid, titel),
       PRIMARY KEY (sid, titel, email)
);

CREATE TABLE Playlist (
       pid INTEGER DEFAULT nextval('seq_playlist'),
       name VARCHAR(255),
       info TEXT NOT NULL,
       email VARCHAR(255) REFERENCES Account(email),
       datum DATE,
       PRIMARY KEY (pid, name)
);

ALTER TABLE Account ADD CONSTRAINT fk_lieblingsplaylist
      FOREIGN KEY (favoritePid, favoriteName) REFERENCES Playlist(pid, name)
      DEFERRABLE INITIALLY DEFERRED;


CREATE TABLE teil_von (
       ElternPid INTEGER,
       ElternName VARCHAR(255),
       KindPid INTEGER,
       KindName VARCHAR(255),
       FOREIGN KEY (ElternPid, ElternName) REFERENCES Playlist(pid, name),
       FOREIGN KEY (KindPid, KindName) REFERENCES Playlist(pid, name),
       PRIMARY KEY (ElternPid, ElternName, KindPid, KindName)
);
       
CREATE TABLE hinzugefuegt (
       sid INTEGER,
       titel VARCHAR(255),
       email VARCHAR(255) REFERENCES Account(email),
       pid INTEGER,
       name VARCHAR(255),
       datum DATE NOT NULL,
       FOREIGN KEY (sid, titel) REFERENCES Lied(sid, titel),
       FOREIGN KEY (pid, name) REFERENCES Playlist(pid, name),
       PRIMARY KEY (sid, titel, email, pid, name)
);
