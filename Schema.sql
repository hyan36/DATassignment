DROP TABLE IF EXISTS Performing;
DROP TABLE IF EXISTS Event;
DROP TABLE IF EXISTS SONG;
DROP TABLE IF EXISTS ARTIST;
DROP TABLE IF EXISTS LABEL;

Create Table Label (
	URL varchar(255) PRIMARY KEY,
	Name varchar(255)
);

Create Table Event (
	EventID integer PRIMARY KEY,
	EventName varchar(255),
	StartDate date,
	EndDate date,
	Location varchar(255),
	IsAnnual Boolean
);

Create Table Artist (
	ArtistID integer PRIMARY KEY,
	InfluencedBy integer,	
	URL varchar(255),
	Name varchar(255) NOT NULL,
	DOB date NOT NULL,
	NumAlbum integer NOT NULL,
	Country varchar(255) NOT NULL,
	Style varchar(255),
	FOREIGN KEY (InfluencedBy) REFERENCES Artist(ArtistID),
	FOREIGN KEY (URL) REFERENCES Label(URL)
);

Create Table Performing (
	ArtistID integer,	
	EventID integer,
	Perf_Date date,
	Primary Key (ArtistID, EventID),
	FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID),
	FOREIGN KEY (EventID) REFERENCES Event(EventID)
);

CREATE Table Song (
	SongID integer PRIMARY KEY,
	ArtistID integer NOT NULL,
	Name varchar(255) NOT NULL,
	ReleaseDate date NOT NULL,
	Duration numeric NOT NULL,
	Album varchar(255),
	FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID)
);

ALTER TABLE Artist ADD CHECK (InfluencedBy != ArtistID);

CREATE OR REPLACE FUNCTION C2()
RETURNS trigger AS $BODY$
BEGIN
IF NEW.ReleaseDate = OLD.ReleaseDate THEN
  RETURN New;
ELSE
	IF NEW.ReleaseDate > (select DOB from Artist where ArtistID = New.ArtistID) THEN
	  RETURN New;
	ELSE
	  RAISE EXCEPTION 'Invalid Release Date';
	END IF;
END IF;
END
$BODY$
LANGUAGE 'plpgsql';

CREATE TRIGGER Verify_Release_Date BEFORE INSERT OR UPDATE ON SONG FOR EACH ROW EXECUTE PROCEDURE C2();

CREATE OR REPLACE FUNCTION C3()
RETURNS trigger AS $BODY$
BEGIN
IF NEW.Perf_Date = OLD.Perf_Date THEN 
  RETURN NEW;
ELSE
	IF NEW.Perf_Date NOT IN (select Perf_Date from Performing where ArtistID = New.ArtistID) THEN
	  RETURN New;
	ELSE
	  RAISE EXCEPTION 'Artist can only attend one event at a time';
	END IF;
END IF;
END
$BODY$
LANGUAGE 'plpgsql';

CREATE TRIGGER Verify_Performance BEFORE INSERT OR UPDATE ON Performing FOR EACH ROW EXECUTE PROCEDURE C3();

CREATE OR REPLACE FUNCTION C4()
RETURNS trigger AS $BODY$
BEGIN
IF NEW.URL = OLD.URL THEN
  RETURN NEW;
ELSE  
	IF NEW.Name NOT IN (select a.NAME from Label l, Artist a where l.URL = a.URL AND a.URL = New.URL) THEN
	  RETURN New;
	ELSE
	  RAISE EXCEPTION 'A label cannot have two artists with the same name';
	END IF;
END IF;
END
$BODY$
LANGUAGE 'plpgsql';

CREATE TRIGGER verify_label_not_duplicate BEFORE INSERT OR UPDATE ON Artist FOR EACH ROW EXECUTE PROCEDURE C4();

