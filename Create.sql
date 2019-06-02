DELETE FROM LABEL;
insert into LABEL (URL, Name) values ('label.com', 'label');
insert into LABEL (URL, Name) values ('label1.com', 'label2');

SELECT * FROM Label;

DELETE FROM Artist;
insert into Artist (ArtistID, Name, DOB, Country, Style, NumAlbum, URL) values (1, 'Test', '1989-04-07', 'UK','POP', 1, 'label.com' );
insert into Artist (ArtistID, Name, DOB, Country, Style, NumAlbum, URL) values (2, 'Test2', '1989-04-07', 'UK','POP', 1, 'label.com' );
insert into Artist (ArtistID, Name, DOB, Country, Style, NumAlbum, URL) values (3, 'Test3', '1989-04-07', 'UK','POP', 1, 'label1.com' );
insert into Artist (ArtistID, Name, DOB, Country, Style, NumAlbum, URL) values (4, 'Test4', '1989-04-07', 'UK','POP', 1, 'label1.com' );
UPDATE Artist SET InfluencedBy = 1 WHERE ArtistID IN (2, 3);
UPDATE Artist SET InfluencedBy = 2 WHERE ArtistID IN (4);

SELECT * FROM Artist;

DELETE FROM Song;
insert into Song values (1, 1, 'TA1','2017-04-07','2.5','hello world');
insert into Song values (2, 2, 'TA2','2017-04-07','2.5','hello world 2');
insert into Song values (3, 2, 'TA3','2018-04-07','2.5','hello world 2.0');

SELECT * FROM Song;

DELETE FROM EVENT;
insert into EVENT values (1, '2017 new year party', '2017-12-31', '2018-01-01', 'London', True);
insert into EVENT values (2, 'Sing for Charity', '2017-12-01', '2018-02-01', 'London', False);

SELECT * FROM EVENT;

DELETE FROM Performing;
insert into Performing values (1, 1, '2017-12-31');
insert into Performing values (1, 2, '2017-12-30');
insert into Performing values (4, 1, '2017-12-31');

SELECT * FROM Performing;
