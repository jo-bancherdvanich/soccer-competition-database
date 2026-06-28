-- Soccer Competition Database
-- Oracle DDL: table creation with primary and foreign key constraints
-- ISYS5000 Group 13 - Waranyu Bancherdvanich, Farhan Bhuiyan, Thinley Dorji
--
-- NOTE: This is a revised version updated after marker feedback.
-- The Substitution table has been removed: substitutions are captured by the
-- gameMinute value in GamePlayer together with the StartPosition "Substitute"
-- (SP12), so a separate table created an unresolved many-to-many and was not needed.

CREATE TABLE Coach (
coachID CHAR(4) NOT NULL,
firstName VARCHAR2(25) NOT NULL,
lastName VARCHAR2(25) NOT NULL,
phoneNum CHAR(10),
email VARCHAR2(30),
dateOfBirth DATE,
gender CHAR(1),
startDate DATE,
CONSTRAINT Coach_PK PRIMARY KEY (coachID)
);

CREATE TABLE CompetitionWeek (
weekID CHAR(4) NOT NULL,
description VARCHAR2(25) NOT NULL,
startDate DATE NOT NULL,
endDate DATE NOT NULL,
CONSTRAINT CompetitionWeek_PK PRIMARY KEY (weekID)
);

CREATE TABLE Referee (
refereeID CHAR (4) NOT NULL,
firstName VARCHAR2(25) NOT NULL,
lastName VARCHAR2(25) NOT NULL,
dateOfBirth DATE,
phoneNum CHAR(10),
startDate DATE,
gender CHAR(1),
refLevel CHAR(1),
CONSTRAINT Referee_PK PRIMARY KEY (refereeID)
);

CREATE TABLE StartPosition (
positionID CHAR(4) NOT NULL,
description VARCHAR2(25) NOT NULL,
CONSTRAINT StartPosition_PK PRIMARY KEY (positionID)
);

CREATE TABLE BestOnGround (
bogID CHAR(3) NOT NULL,
rank CHAR(1) NOT NULL,
points NUMBER(3) NOT NULL,
CONSTRAINT BestOnGround_PK PRIMARY KEY (bestOnGroundID)
);

CREATE TABLE Result (
resultID CHAR(4) NOT NULL,
description VARCHAR2(15) NOT NULL,
points NUMBER(1,0) NOT NULL,
CONSTRAINT Result_PK PRIMARY KEY (resultID)
);

CREATE TABLE Club (
clubID CHAR(4) NOT NULL,
clubName VARCHAR2(25) NOT NULL,
yearEstablished NUMBER(4,0),
majorSponsor VARCHAR2(25),
numOfMembers NUMBER(5,0),
coachID CHAR(4) NOT NULL,
CONSTRAINT Club_PK PRIMARY KEY (clubID),
CONSTRAINT Club_Coach_FK FOREIGN KEY (coachID) REFERENCES Coach(coachID)
);

CREATE TABLE Player (
playerID CHAR(5) NOT NULL,
firstName VARCHAR2(30) NOT NULL,
lastName VARCHAR2(30) NOT NULL,
phoneNum CHAR(10),
email VARCHAR2(30),
jerseyNumber VARCHAR2(2),
dateOfBirth DATE,
height NUMBER(3,0),
weight NUMBER(3,0),
clubID CHAR(4) NOT NULL,
CONSTRAINT Player_PK PRIMARY KEY (playerID),
CONSTRAINT Player_Club_FK FOREIGN KEY (clubID) REFERENCES Club(clubID)
);

CREATE TABLE Ground (
groundID CHAR(4) NOT NULL,
name VARCHAR2(30) NOT NULL,
address VARCHAR2(40) NOT NULL,
capacity NUMBER(5,0) NOT NULL,
clubID CHAR(4) NOT NULL,
CONSTRAINT Ground_PK PRIMARY KEY (groundID),
CONSTRAINT Ground_Club_FK FOREIGN KEY (clubID) REFERENCES Club(clubID)
);

CREATE TABLE Game (
gameID CHAR(4) NOT NULL,
description VARCHAR2(15) NOT NULL,
gameDate DATE NOT NULL,
startTime DATE NOT NULL,
endTime DATE NOT NULL,
weekID CHAR(4) NOT NULL,
groundID CHAR(4) NOT NULL,
CONSTRAINT Game_PK PRIMARY KEY (gameID),
CONSTRAINT Game_CompetitionWeek_FK FOREIGN KEY (weekID) REFERENCES CompetitionWeek(weekID),
CONSTRAINT Game_Ground_FK FOREIGN KEY (groundID) REFERENCES Ground(groundID)
);

CREATE TABLE ClubGame (
clubGameID CHAR(5) NOT NULL,
gameID CHAR(4) NOT NULL,
clubID CHAR(4) NOT NULL,
goalScored NUMBER(2,0) NOT NULL,
resultID CHAR(4) NOT NULL,
CONSTRAINT clubGame_PK PRIMARY KEY (clubGameID),
CONSTRAINT clubGame_game_FK FOREIGN KEY (gameID) REFERENCES Game(gameID),
CONSTRAINT clubGame_club_FK FOREIGN KEY (clubID) REFERENCES Club(clubID),
CONSTRAINT clubGame_result_FK FOREIGN KEY (resultID) REFERENCES Result(resultID)
);

CREATE TABLE GameReferee (
gameRefereeID CHAR(6) NOT NULL,
refRole VARCHAR2(15) NOT NULL,
gameID CHAR(4) NOT NULL,
refereeID CHAR(4) NOT NULL,
CONSTRAINT GameReferee_PK PRIMARY KEY (gameRefereeID),
CONSTRAINT GR_Game_FK FOREIGN KEY (gameID) REFERENCES Game(gameID),
CONSTRAINT GR_Referee_FK FOREIGN KEY (refereeID) REFERENCES Referee(refereeID)
);

CREATE TABLE GamePlayer (
gamePlayerID CHAR(6) NOT NULL,
gameID CHAR(4) NOT NULL,
playerID CHAR(5) NOT NULL,
positionID CHAR(4) NOT NULL,
gameMinute NUMBER(3,0) NOT NULL,
CONSTRAINT GamePlayer_PK PRIMARY KEY (gamePlayerID),
CONSTRAINT GamePlayer_Game_FK FOREIGN KEY (gameID) REFERENCES Game(gameID),
CONSTRAINT GamePlayer_Player_FK FOREIGN KEY (playerID) REFERENCES Player(playerID),
CONSTRAINT GamePlayer_Position_FK FOREIGN KEY (positionID) REFERENCES    StartPosition(positionID)
);

CREATE TABLE AwardedCard (
awardedCardID CHAR(5) NOT NULL,
cardDescription VARCHAR2(6) NOT NULL,
minute NUMBER(3,0) NOT NULL,
gamePlayerID CHAR(6) NOT NULL,
gameRefereeID CHAR(6) NOT NULL,
CONSTRAINT AwardedCard_PK PRIMARY KEY (awardedCardID),
CONSTRAINT AwardedCard_GamePlayer_FK FOREIGN KEY (gamePlayerID) REFERENCES GamePlayer(gamePlayerID),
CONSTRAINT AwardedCard_GameReferee_FK FOREIGN KEY (gameRefereeID) REFERENCES GameReferee(gameRefereeID)
);

CREATE TABLE ScoredGoal (
goalID CHAR(5) NOT NULL,
gamePlayerID CHAR(6) NOT NULL,
gameMinute NUMBER(3,0) NOT NULL,
CONSTRAINT ScoredGoal_PK PRIMARY KEY (goalID),
CONSTRAINT ScoredGoal_GamePlayer_FK FOREIGN KEY (gamePlayerID) REFERENCES 	GamePlayer(gamePlayerID)
);

CREATE TABLE BOGPlayer (
bogPlayerID CHAR(6) NOT NULL,
bogID CHAR(3) NOT NULL,
gamePlayerID CHAR(6) NOT NULL,
CONSTRAINT BogPlayer_PK PRIMARY KEY (bogPlayerID),
CONSTRAINT BogPlayer_BOG_FK FOREIGN KEY (bogID) REFERENCES BestOnGround(bogID),
CONSTRAINT BogPlayer_GamePlayer_FK FOREIGN KEY (gamePlayerID) REFERENCES 	GamePlayer(gamePlayerID)
);

