CREATE SEQUENCE seq_greenhouse INCREMENT BY 3 MINVALUE 1 NO CYCLE;
CREATE SEQUENCE seq_heatingsys INCREMENT BY 10 MINVALUE 1000 NO CYCLE;
CREATE TYPE ColorEnum AS ENUM ('White', 'Pink', 'Yellow');

CREATE TABLE Estate (
	Address VARCHAR(255) NOT NULL,
	Size NUMERIC(10, 2) CHECK(Size > 0),
	Primary_Heating_System_HId INTEGER NOT NULL, 
	Primary_Heating_System_Address VARCHAR(255) NOT NULL,
	PRIMARY KEY(Address)
);

CREATE TABLE neighbouring (
	Estate_Address VARCHAR(255) NOT NULL,
	Neighbour_Address VARCHAR(255) NOT NULL,
	FOREIGN KEY(Estate_Address) REFERENCES Estate(Address),
	FOREIGN KEY(Neighbour_Address) REFERENCES Estate(Address),
	PRIMARY KEY(Estate_Address, Neighbour_Address)
);

CREATE TABLE contains (
	Estate_Address VARCHAR(255) NOT NULL,
	Address_Of_Estate_PType VARCHAR(255) NOT NULL,
	FOREIGN KEY(Estate_Address) REFERENCES Estate(Address),
	FOREIGN KEY(Address_Of_Estate_PType) REFERENCES Estate(Address),
	PRIMARY KEY(Estate_Address, Address_Of_Estate_PType)
);

CREATE TABLE Heating_System (
	Address VARCHAR(255) NOT NULL,
	HId INTEGER NOT NULL DEFAULT NEXTVAL('seq_heatingsys'),
	kW NUMERIC(10,2) NOT NULL,	
	FOREIGN KEY(Address) REFERENCES Estate(Address),
	PRIMARY KEY(HId, Address)
);

ALTER TABLE Estate ADD CONSTRAINT fk_PrimaryHeatingSystem
      FOREIGN KEY (Primary_Heating_System_HId, Primary_Heating_System_Address) REFERENCES Heating_System(HId, Address)
      DEFERRABLE INITIALLY DEFERRED;	  

CREATE TABLE Heat_Pump (
	Address VARCHAR(255) NOT NULL,
	HId INTEGER NOT NULL,
	FOREIGN KEY(Address, HId) REFERENCES Heating_System(Address, HId),
	PRIMARY KEY(HId, Address)
);

CREATE TABLE Gas_Heating (
	Address VARCHAR(255) NOT NULL,
	HId INTEGER NOT NULL,
	FOREIGN KEY(Address, HId) REFERENCES Heating_System(Address, HId),
	PRIMARY KEY(HId, Address)
);

CREATE TABLE Greenhouse (
	Address VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL DEFAULT NEXTVAL('seq_greenhouse'),	
	Size NUMERIC(10,2) NOT NULL CHECK(Size > 0),	
	FOREIGN KEY(Address) REFERENCES Estate(Address),
	PRIMARY KEY(GId, Address)
);

CREATE TABLE heats (
	Heating_System_Address VARCHAR(255) NOT NULL,
	HId INTEGER NOT NULL,
	Greenhouse_Address VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL,
	FOREIGN KEY(Heating_System_Address, HId) REFERENCES Heating_System(Address, HId),
	FOREIGN KEY(Greenhouse_Address, GId) REFERENCES Greenhouse(Address, GId),
	PRIMARY KEY(Heating_System_Address, HId, Greenhouse_Address, GId)
);

CREATE TABLE Employee (
	SVNR VARCHAR(255) NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Address VARCHAR(255) NOT NULL,
	PRIMARY KEY(SVNR)
);

CREATE TABLE Checkup (
	Address VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL,
	SVNR VARCHAR(255) NOT NULL,
	main_SVNR VARCHAR(255) NOT NULL,
	Date DATE NOT NULL CHECK(Date > '1990-02-01'::DATE),
	Observation VARCHAR(255) NOT NULL,
	FOREIGN KEY(Address, GId) REFERENCES Greenhouse(Address, GId),
	FOREIGN KEY(SVNR) REFERENCES Employee(SVNR),
	FOREIGN KEY(main_SVNR) REFERENCES Employee(SVNR),
	PRIMARY KEY(Address, GId, SVNR, Date)
);

CREATE TABLE Plants (
	Address VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Count INTEGER NOT NULL,
	FOREIGN KEY(Address, GId) REFERENCES Greenhouse(Address, GId),
	PRIMARY KEY(Address, GId, Name)
);

CREATE TABLE Palmtrees (
	Address VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Frost_Resistant VARCHAR(255) NOT NULL,
	FOREIGN KEY(Address, GId, Name) REFERENCES Plants(Address, GId, Name),
	PRIMARY KEY(Address, GId, Name)
);

CREATE TABLE Orchids (
	Address VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Color ColorEnum NOT NULL,
	FOREIGN KEY(Address, GId, Name) REFERENCES Plants(Address, GId, Name),
	PRIMARY KEY(Address, GId, Name)
);

CREATE TABLE Succulents (
	Address VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL,
	Name VARCHAR(255) NOT NULL,
	FOREIGN KEY(Address, GId, Name) REFERENCES Plants(Address, GId, Name),
	PRIMARY KEY(Address, GId, Name)
);

CREATE TABLE Dung (
	Type VARCHAR(255) NOT NULL CHECK(Type ~* $$^([a-zA-Z]){3}-\w{6}$$),
	Stock INTEGER NOT NULL,
	PRIMARY KEY(Type)
);

CREATE TABLE dungs (
	SVNR VARCHAR(255) NOT NULL,
	Type VARCHAR(255) NOT NULL,
	Address VARCHAR(255) NOT NULL,
	GId INTEGER NOT NULL,
	Name VARCHAR(255) NOT NULL,
	UNIQUE(Address, GId, Name),
	UNIQUE(SVNR, Type),
	FOREIGN KEY(SVNR) REFERENCES Employee(SVNR),
	FOREIGN KEY(Type) REFERENCES Dung(Type),
	FOREIGN KEY(Address, GId, Name) REFERENCES Plants(Address, GId, Name),
	PRIMARY KEY(SVNR, Type, Address, GId, Name)
);