BEGIN;

DELETE FROM alias_von;
DELETE FROM singt;
DELETE FROM hoert;
DELETE FROM teil_von;
DELETE FROM hinzugefuegt;
DELETE FROM hat_Rechte;
DELETE FROM Track;
DELETE FROM CD;
DELETE FROM Lied;
DELETE FROM Album;
DELETE FROM SaengerIn;
DELETE FROM KuenstlerIn;
DELETE FROM ProduzentIn;
DELETE FROM Person;
DELETE FROM Playlist;
DELETE FROM Account;

SELECT setval('seq_playlist',10000,false);
SELECT setval('seq_lied', 1, false);

COMMIT;

INSERT INTO Person(vname, nname) VALUES
       ('Thees', 'Ullmann'),
       ('Andreas', 'Spechtl'),
       ('Martin', 'Grohe'),
       ('Teren', 'Jones'),
       ('Deltron', 'Zero'),
       ('Daniel', 'Nakamura'),
       ('Brian', 'Burton'),
       ('Danger', 'Mouse'),
       ('MF', 'DOOM'),
       ('Dan', 'Automator');
	

INSERT INTO alias_von(AliasVName, AliasNName, vname, nname) VALUES
       ('Dan', 'Automator', 'Daniel', 'Nakamura'),
       ('Danger', 'Mouse', 'Brian', 'Burton'),
       ('Deltron', 'Zero', 'Teren', 'Jones');

INSERT INTO KuenstlerIn VALUES
       ('Thees', 'Ullmann', '0'),
       ('Andreas', 'Spechtl', '0'),
       ('Deltron', 'Zero', '0'),
       ('MF', 'DOOM', '0'),
       ('Danger', 'Mouse', '0');

INSERT INTO ProduzentIn VALUES
       ('Andreas', 'Spechtl', 'andreasspechtl.com'),
       ('Dan', 'Automator', 'google.com'),
       ('Danger', 'Mouse', '30thcenturyrecords.com');

INSERT INTO SaengerIn VALUES
       ('Thees', 'Ullmann'),
       ('MF', 'DOOM'),
       ('Andreas', 'Spechtl'),
       ('Deltron', 'Zero');
    
BEGIN;


INSERT INTO Album VALUES
       ('Deltron 3030', 2004, 'Dan', 'Automator', 'Deltron', 'Zero'),
       ('DMD KIU LIDT', 2011, 'Andreas', 'Spechtl', 'Andreas', 'Spechtl'),
       ('The Mouse and the Mask', 2005, 'Danger', 'Mouse', 'MF', 'DOOM');

INSERT INTO hat_Rechte VALUES
       ('Deltron 3030', 'Dan', 'Automator'),
       ('DMD KIU LIDT', 'Andreas', 'Spechtl');

INSERT INTO CD VALUES
       ('Deltron 3030', 1, 'Album', '75 Ark'),
       ('DMD KIU LIDT', 4, 'Album', 'Staatsakt');
       
INSERT INTO Lied(titel, dauer) VALUES
    ('Mastermind', 214.0),
    ('3030', 449.5),
    ('Positive Contact', 282.1),
    ('Nevermind', 329.7),
    ('Trouble', 184.3),
    ('Alles Hin, Hin, Hin', 197.2);
    
    
INSERT INTO singt VALUES
    ('Andreas', 'Spechtl', 'Nevermind', 4),
    ('Andreas', 'Spechtl', 'Trouble', 5),
    ('Andreas', 'Spechtl', 'Alles Hin, Hin, Hin', 6),
    ('Deltron', 'Zero', 'Mastermind', 1);
    
INSERT INTO Account VALUES
    ('fake@mail', '123', 'musicfan', 10100, 'Chill'),
    ('cool@yahoo', 'Goh4ekohngahxahy', 'securityking', 10200, 'Starbucks Music'),
    ('follow@ig', 'igigi', 'hallo', 10500, 'Best tracks 2018');
    
INSERT INTO Playlist(name, info, email, datum) VALUES
    ('Nice Sounds', 'bla', 'fake@mail', '2017-04-13'),
    ('Chill', 'blu', 'fake@mail', '2017-04-14'),
    ('Starbucks Music', 'bli', 'fake@mail', '2018-06-17'),
    ('laid back soft-vocal-chill', '(y)', 'fake@mail', '2018-10-27'),
    ('Best of 2018', 'so good', 'follow@ig', '2018-02-20'),
    ('Best tracks 2018', 'the best', 'follow@ig', '2018-03-14');
    
INSERT INTO teil_von VALUES
    (10000, 'Nice Sounds', 10100, 'Chill'),
    (10100, 'Chill', 10200, 'Starbucks Music'),
    (10100, 'Chill', 10300, 'laid back soft-vocal-chill');

INSERT INTO hinzugefuegt VALUES
    (1, 'Mastermind', 'fake@mail', 10000, 'Nice Sounds', '2018-03-02');
COMMIT;
