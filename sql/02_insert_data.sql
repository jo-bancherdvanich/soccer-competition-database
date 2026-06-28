-- Soccer Competition Database - Sample Data
-- Oracle INSERT ALL statements populating all tables
-- ISYS5000 Group 13

INSERT ALL
  INTO Coach (coachID, firstName, lastName, phoneNum, email, dateOfBirth, gender, startDate INSERT ALL
INTO Coach (coachID, firstName, lastName, phoneNum, email, dateOfBirth, gender, startDate)
VALUES ('CH01','Robert','Taylor','0415789833','robert.t@email.com',TO_DATE('04/01/1968','MM/DD/YYYY'),'M',TO_DATE('01/15/2001','MM/DD/YYYY'))
INTO Coach (coachID, firstName, lastName, phoneNum, email, dateOfBirth, gender, startDate)
VALUES ('CH02','Emily','Clarke','0413942657','emily.c@email.com',TO_DATE('09/14/1970','MM/DD/YYYY'),'F',TO_DATE('06/09/2003','MM/DD/YYYY'))
INTO Coach (coachID, firstName, lastName, phoneNum, email, dateOfBirth, gender, startDate)
VALUES ('CH03','Anthony','Li','0413390691','anthony.li@email.com',TO_DATE('12/21/1969','MM/DD/YYYY'),'M',TO_DATE('02/20/2006','MM/DD/YYYY'))
…
INTO Coach (coachID, firstName, lastName, phoneNum, email, dateOfBirth, gender, startDate)
VALUES ('CH07','Peter','Johnson','0412374254','peter.j@email.com',TO_DATE('01/05/1971','MM/DD/YYYY'),'M',TO_DATE('03/28/2005','MM/DD/YYYY'))
INTO Coach (coachID, firstName, lastName, phoneNum, email, dateOfBirth, gender, startDate)
VALUES ('CH08','Amanda','Wright','0411161045','amanda.w@email.com',TO_DATE('10/20/1974','MM/DD/YYYY'),'F',TO_DATE('07/30/2012','MM/DD/YYYY'))
SELECT * FROM dual;

INSERT ALL
INTO CompetitionWeek (weekID, description, startDate, endDate)
VALUES ('WK01','Opening Round',TO_DATE('05/12/2025','MM/DD/YYYY'),TO_DATE('05/18/2025','MM/DD/YYYY'))
INTO CompetitionWeek (weekID, description, startDate, endDate)
VALUES ('WK02','Rivalry Round',TO_DATE('05/19/2025','MM/DD/YYYY'),TO_DATE('05/25/2025','MM/DD/YYYY'))
INTO CompetitionWeek (weekID, description, startDate, endDate)
VALUES ('WK03','Home Advantage Round',TO_DATE('05/26/2025','MM/DD/YYYY'),TO_DATE('06/01/2025','MM/DD/YYYY'))
…
VALUES ('WK12','Penultimate Round',TO_DATE('07/28/2025','MM/DD/YYYY'),TO_DATE('08/03/2025','MM/DD/YYYY'))
INTO CompetitionWeek (weekID, description, startDate, endDate)
VALUES ('WK13','Climactic Round',TO_DATE('08/04/2025','MM/DD/YYYY'),TO_DATE('08/10/2025','MM/DD/YYYY'))
INTO CompetitionWeek (weekID, description, startDate, endDate)
VALUES ('WK14','Final Matchweek',TO_DATE('08/11/2025','MM/DD/YYYY'),TO_DATE('08/17/2025','MM/DD/YYYY'))
SELECT * FROM dual;

INSERT ALL
INTO Referee (refereeID, firstName, lastName, dateOfBirth, phoneNum, startDate, gender, refLevel)
VALUES ('RF01','Sarah','Wilson',TO_DATE('06/12/1984','MM/DD/YYYY'),'0404000001',TO_DATE('03/01/2010','MM/DD/YYYY'),'F',1)
INTO Referee (refereeID, firstName, lastName, dateOfBirth, phoneNum, startDate, gender, refLevel)
VALUES ('RF02','Michael','Jones',TO_DATE('11/22/1981','MM/DD/YYYY'),'0404000002',TO_DATE('05/10/2008','MM/DD/YYYY'),'M',1)
…
INTO Referee (refereeID, firstName, lastName, dateOfBirth, phoneNum, startDate, gender, refLevel)
VALUES ('RF11','Grace','Martin',TO_DATE('11/06/1994','MM/DD/YYYY'),'0404000011',TO_DATE('04/10/2019','MM/DD/YYYY'),'F',4)
INTO Referee (refereeID, firstName, lastName, dateOfBirth, phoneNum, startDate, gender, refLevel)
VALUES ('RF12','Thomas','Baker',TO_DATE('02/23/1979','MM/DD/YYYY'),'0404000012',TO_DATE('09/18/2006','MM/DD/YYYY'),'M',3)
SELECT * FROM dual;

INSERT ALL
INTO StartPosition (positionID, description) VALUES ('SP01','Goalkeeper')
INTO StartPosition (positionID, description) VALUES ('SP02','Right Back')
INTO StartPosition (positionID, description) VALUES ('SP03','Left Back')
INTO StartPosition (positionID, description) VALUES ('SP10','Left Wing')
INTO StartPosition (positionID, description) VALUES ('SP11','Center Forward')
INTO StartPosition (positionID, description) VALUES ('SP12','Substitute')
SELECT * FROM dual;

INSERT ALL
INTO BestOnGround (bestOnGroundID, rank, points) VALUES ('BG1', 1, 3)
INTO BestOnGround (bestOnGroundID, rank, points) VALUES ('BG2', 2, 2)
INTO BestOnGround (bestOnGroundID, rank, points) VALUES ('BG3', 3, 1)
SELECT * FROM dual;

INSERT ALL
INTO Club (clubID, clubName, yearEstablished, majorSponsor, numOfMembers, coachID)
VALUES ('CL01','Eagle Bay Eagles',1985,'Busselton Motors',120,'CH01')
INTO Club (clubID, clubName, yearEstablished, majorSponsor, numOfMembers, coachID)
VALUES ('CL02','Dunsborough Dingos',1978,'SurfCo Insurance',115,'CH02')
INTO Club (clubID, clubName, yearEstablished, majorSponsor, numOfMembers, coachID)
VALUES ('CL03','Broadwater Bandicoots',1990,'Busselton Fresh',130,'CH03')
INTO Club (clubID, clubName, yearEstablished, majorSponsor, numOfMembers, coachID)
VALUES ('CL04','Mary-Brook Magpies',1982,'Brook Wines',110,'CH04')
INTO Club (clubID, clubName, yearEstablished, majorSponsor, numOfMembers, coachID)
VALUES ('CL05','Reinscourt Rabbits',1988,'West Coast Bank',125,'CH05')
INTO Club (clubID, clubName, yearEstablished, majorSponsor, numOfMembers, coachID)
VALUES ('CL06','Wonnerup Wombats',1975,'Wonn Chemicals',118,'CH06')
INTO Club (clubID, clubName, yearEstablished, majorSponsor, numOfMembers, coachID)
VALUES ('CL07','New Caves Rd Numbats',1993,'Cave Tours WA',112,'CH07')
INTO Club (clubID, clubName, yearEstablished, majorSponsor, numOfMembers, coachID)
VALUES ('CL08','Hanes Hawkes',1980,'Hanes Builders',128,'CH08')
SELECT * FROM DUAL;

INSERT ALL
INTO Player (playerID, firstName, lastName, phoneNum, email, jerseyNumber, dateOfBirth, height, weight, clubID)
VALUES ('PL101','Liam','Taylor','0495888726','liam.taylor1@email.com','80',TO_DATE('10-06-98','DD-MM-RR'),175,75,'CL01')
INTO Player (playerID, firstName, lastName, phoneNum, email, jerseyNumber, dateOfBirth, height, weight, clubID)
VALUES ('PL102','Martin','Carter','0422519875','martin.carter2@email.com','60',TO_DATE('04-03-00','DD-MM-RR'),187,79,'CL01')
INTO Player (playerID, firstName, lastName, phoneNum, email, jerseyNumber, dateOfBirth, height, weight, clubID)
VALUES ('PL103','Stuart','Martin','0416138399','stuart.martin3@email.com','98',TO_DATE('22-12-01','DD-MM-RR'),174,76,'CL01')
INTO Player (playerID, firstName, lastName, phoneNum, email, jerseyNumber, dateOfBirth, height, weight, clubID)
VALUES ('PL104','Mark','Wright','0427054234','mark.wright4@email.com','83',TO_DATE('20-04-92','DD-MM-RR'),177,79,'CL01')
INTO Player (playerID, firstName, lastName, phoneNum, email, jerseyNumber, dateOfBirth, height, weight, clubID)
....
VALUES ('PL809','George','Evans','0458920186','george.evans93@email.com','34',TO_DATE('20-10-96','DD-MM-RR'),187,82,'CL08')
INTO Player (playerID, firstName, lastName, phoneNum, email, jerseyNumber, dateOfBirth, height, weight, clubID)
VALUES ('PL810','Chris','Brooks','0425974901','chris.brooks94@email.com','3',TO_DATE('01-07-99','DD-MM-RR'),177,69,'CL08')
INTO Player (playerID, firstName, lastName, phoneNum, email, jerseyNumber, dateOfBirth, height, weight, clubID)
VALUES ('PL811','Daniel','Carter','0416421248','daniel.carter95@email.com','72',TO_DATE('26-08-97','DD-MM-RR'),190,80,'CL08')
INTO Player (playerID, firstName, lastName, phoneNum, email, jerseyNumber, dateOfBirth, height, weight, clubID)
VALUES ('PL812','Peter','Foster','0420056507','peter.foster96@email.com','16',TO_DATE('24-10-94','DD-MM-RR'),180,79,'CL08')
SELECT * FROM DUAL;

INSERT ALL
INTO Ground (groundID, name, address, capacity, clubID)
VALUES ('GR01','Eagle Bay Centre','Eagle Bay Rd, Busselton WA',2000,'CL01')
INTO Ground (groundID, name, address, capacity, clubID)
VALUES ('GR02','Quedjinup Reserve','Naturaliste Terrace, WA',1500,'CL02')
INTO Ground (groundID, name, address, capacity, clubID)
VALUES ('GR03','Broadwater Bay Oval','Broadwater WA',2200,'CL03')
INTO Ground (groundID, name, address, capacity, clubID)
VALUES ('GR06','Wonnerup Sports Ground','Wonnerup WA',1700,'CL06')
INTO Ground (groundID, name, address, capacity, clubID)
VALUES ('GR07','Caves Road Reserve','Caves Rd, Busselton WA',1600,'CL07')
INTO Ground (groundID, name, address, capacity, clubID)
VALUES ('GR08','Hanes Sports Ground','Hanes WA',1900,'CL08')
SELECT * FROM dual;

INSERT ALL
INTO Game (GAMEID, DESCRIPTION, GAMEDATE, STARTTIME, ENDTIME, WEEKID, GROUNDID) VALUES ('GM01','CL01 v CL02',TO_DATE('05/12/2025','MM/DD/YYYY'),TO_DATE('08:00','HH24:MI'),TO_DATE('09:30','HH24:MI'),'WK01','GR01')
INTO Game (GAMEID, DESCRIPTION, GAMEDATE, STARTTIME, ENDTIME, WEEKID, GROUNDID) VALUES ('GM02','CL03 v CL04',TO_DATE('05/14/2025','MM/DD/YYYY'),TO_DATE('14:00','HH24:MI'),TO_DATE('15:30','HH24:MI'),'WK01','GR03')
INTO Game (GAMEID, DESCRIPTION, GAMEDATE, STARTTIME, ENDTIME, WEEKID, GROUNDID) VALUES ('GM03','CL05 v CL06',TO_DATE('05/16/2025','MM/DD/YYYY'),TO_DATE('08:00','HH24:MI'),TO_DATE('09:30','HH24:MI'),'WK01','GR05')
....
INTO Game (GAMEID, DESCRIPTION, GAMEDATE, STARTTIME, ENDTIME, WEEKID, GROUNDID) VALUES ('GM54','CL03 v CL02',TO_DATE('08/13/2025','MM/DD/YYYY'),TO_DATE('14:00','HH24:MI'),TO_DATE('15:30','HH24:MI'),'WK14','GR03')
INTO Game (GAMEID, DESCRIPTION, GAMEDATE, STARTTIME, ENDTIME, WEEKID, GROUNDID) VALUES ('GM55','CL07 v CL04',TO_DATE('08/15/2025','MM/DD/YYYY'),TO_DATE('08:00','HH24:MI'),TO_DATE('09:30','HH24:MI'),'WK14','GR07')
INTO Game (GAMEID, DESCRIPTION, GAMEDATE, STARTTIME, ENDTIME, WEEKID, GROUNDID) VALUES ('GM56','CL06 v CL05',TO_DATE('08/17/2025','MM/DD/YYYY'),TO_DATE('14:00','HH24:MI'),TO_DATE('15:30','HH24:MI'),'WK14','GR06')
SELECT * FROM dual;

INSERT ALL
INTO ClubGame (clubGameID, gameID, clubID, goalScored, resultID)
VALUES ('CG001','GM01','CL01',4,'RS02')
INTO ClubGame VALUES ('CG002','GM01','CL02',1,'RS05')
INTO ClubGame VALUES ('CG003','GM02','CL03',1,'RS04')
INTO ClubGame VALUES ('CG004','GM02','CL04',1,'RS03')
....
INTO ClubGame VALUES ('CG110','GM55','CL03',1,'RS01')
INTO ClubGame VALUES ('CG111','GM56','CL05',1,'RS04')
INTO ClubGame VALUES ('CG112','GM56','CL04',1,'RS03')
SELECT * FROM DUAL;

INSERT ALL
INTO GamePlayer (gamePlayerID, gameID, playerID, positionID, gameMinute)
VALUES ('GP0001','GM01','PL101','SP01',90)
INTO GamePlayer (gamePlayerID, gameID, playerID, positionID, gameMinute)
VALUES ('GP0002','GM01','PL102','SP02',90)
INTO GamePlayer (gamePlayerID, gameID, playerID, positionID, gameMinute)
VALUES ('GP0003','GM01','PL103','SP03',90)
INTO GamePlayer (gamePlayerID, gameID, playerID, positionID, gameMinute)
VALUES ('GP0004','GM01','PL104','SP04',90)
INTO GamePlayer (gamePlayerID, gameID, playerID, positionID, gameMinute)
VALUES ('GP0005','GM01','PL105','SP05',90)
...
INTO GamePlayer (gamePlayerID, gameID, playerID, positionID, gameMinute)
VALUES ('GP1340','GM56','PL408','SP08',90)
INTO GamePlayer (gamePlayerID, gameID, playerID, positionID, gameMinute)
VALUES ('GP1341','GM56','PL409','SP09',90)
INTO GamePlayer (gamePlayerID, gameID, playerID, positionID, gameMinute)
VALUES ('GP1342','GM56','PL410','SP10',90)
INTO GamePlayer (gamePlayerID, gameID, playerID, positionID, gameMinute)
VALUES ('GP1343','GM56','PL411','SP11',90)
INTO GamePlayer (gamePlayerID, gameID, playerID, positionID, gameMinute)
VALUES ('GP1344','GM56','PL412','SP12',9)
SELECT * FROM dual;

INSERT ALL
INTO AwardedCard (awardedCardID, cardDescription, minute, gamePlayerID, gameRefereeID) VALUES ('AC001', 'Yellow', 15, 'GP0010', 'GRF001')
INTO AwardedCard (awardedCardID, cardDescription, minute, gamePlayerID, gameRefereeID) VALUES ('AC002', 'Yellow', 22, 'GP0009', 'GRF001')
INTO AwardedCard (awardedCardID, cardDescription, minute, gamePlayerID, gameRefereeID) VALUES ('AC003', 'Yellow', 25, 'GP0009', 'GRF001')
INTO AwardedCard (awardedCardID, cardDescription, minute, gamePlayerID, gameRefereeID) VALUES ('AC004', 'Yellow', 28, 'GP0025', 'GRF004')
....
INTO AwardedCard (awardedCardID, cardDescription, minute, gamePlayerID, gameRefereeID) VALUES ('AC012', 'Yellow', 76, 'GP0990', 'GRF124')
INTO AwardedCard (awardedCardID, cardDescription, minute, gamePlayerID, gameRefereeID) VALUES ('AC013', 'Yellow', 42, 'GP0995', 'GRF124')
INTO AwardedCard (awardedCardID, cardDescription, minute, gamePlayerID, gameRefereeID) VALUES ('AC014', 'Yellow', 74, 'GP0995', 'GRF124')
INTO AwardedCard (awardedCardID, cardDescription, minute, gamePlayerID, gameRefereeID) VALUES ('ACO15', 'Red', 50, 'GP0220', 'GRF028')
SELECT * FROM dual;

INSERT ALL
INTO ScoredGoal (goalID, gamePlayerID, gameMinute) VALUES ('GL001', 'GP0010', 44)
INTO ScoredGoal (goalID, gamePlayerID, gameMinute) VALUES ('GL002', 'GP0010', 66)
INTO ScoredGoal (goalID, gamePlayerID, gameMinute) VALUES ('GL003', 'GP0010', 78)
INTO ScoredGoal (goalID, gamePlayerID, gameMinute) VALUES ('GL004', 'GP0022', 40)
....
INTO ScoredGoal (goalID, gamePlayerID, gameMinute) VALUES ('GL150', 'GP1283', 89)
INTO ScoredGoal (goalID, gamePlayerID, gameMinute) VALUES ('GL151', 'GP1319', 65)
INTO ScoredGoal (goalID, gamePlayerID, gameMinute) VALUES ('GL152', 'GP1342', 77)
INTO ScoredGoal (goalID, gamePlayerID, gameMinute) VALUES ('GL153', 'GP1328', 83)
SELECT * FROM dual;

INSERT ALL
INTO BogPlayer (bogPlayerID, bogID, gamePlayerID) VALUES ('BP0001', 'BG1', 'GP0010')
INTO BogPlayer (bogPlayerID, bogID, gamePlayerID) VALUES ('BP0002', 'BG2', 'GP0022')
INTO BogPlayer (bogPlayerID, bogID, gamePlayerID) VALUES ('BP0003', 'BG3', 'GP0011')
....
INTO BogPlayer (bogPlayerID, bogID, gamePlayerID) VALUES ('BP0166', 'BG1', 'GP1342')
INTO BogPlayer (bogPlayerID, bogID, gamePlayerID) VALUES ('BP0167', 'BG2', 'GP1328')
INTO BogPlayer (bogPlayerID, bogID, gamePlayerID) VALUES ('BP0168', 'BG3', 'GP1331')
SELECT * FROM dual;

