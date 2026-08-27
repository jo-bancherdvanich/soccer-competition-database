# Data Dictionary

Every table, column, type and constraint in the schema. Generated from
[`sql/01_create_tables.sql`](../sql/01_create_tables.sql), so it always matches the DDL.

**16 tables.** Reference tables first, then the entities, then the junction tables that record what happened in a game.

| Table | Rows in sample data | What it holds |
|---|---|---|
| [`Coach`](#coach) | 8 | One coach per club |
| [`CompetitionWeek`](#competitionweek) | 14 | The 14 rounds of the season |
| [`Referee`](#referee) | 12 | Accredited match officials |
| [`StartPosition`](#startposition) | 12 | The 11 pitch positions plus Substitute |
| [`BestOnGround`](#bestonground) | 3 | The three best-on-ground placings and their point values |
| [`Result`](#result) | 6 | The six result types and their competition points |
| [`Club`](#club) | 8 | The eight competing clubs |
| [`Player`](#player) | 96 | Twelve players per club |
| [`Ground`](#ground) | 8 | One home ground per club |
| [`Game`](#game) | 56 | Every fixture in the season |
| [`ClubGame`](#clubgame) | 112 | One row per club per game: goals scored and result |
| [`GameReferee`](#gamereferee) | 145 | Which referees officiated which game, and in what role |
| [`GamePlayer`](#gameplayer) | 1344 | One row per player per game: their start position and minutes |
| [`AwardedCard`](#awardedcard) | 81 | Yellow and red cards, tied to an appearance and the issuing official |
| [`ScoredGoal`](#scoredgoal) | 154 | Every goal, tied to the appearance that scored it |
| [`BOGPlayer`](#bogplayer) | 168 | Best-on-ground awards, three per game |

---

## Coach

One coach per club.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `coachID` | CHAR(4) | Yes | PK | Unique ID and primary key of a coach |
| `firstName` | VARCHAR2(25) | Yes |  | Coach's first name |
| `lastName` | VARCHAR2(25) | Yes |  | Coach's last name |
| `phoneNum` | CHAR(10) | No |  | Coach's contact number |
| `email` | VARCHAR2(30) | No |  | Coach's email address |
| `dateOfBirth` | DATE | No |  | Coach's date of birth |
| `gender` | CHAR(1) | No |  | M or F |
| `startDate` | DATE | No |  | Date the coach started with the competition |

## CompetitionWeek

The 14 rounds of the season.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `weekID` | CHAR(4) | Yes | PK | Unique ID and primary key of a competition week |
| `description` | VARCHAR2(25) | Yes |  | Name of the round, e.g. "Opening Round" |
| `startDate` | DATE | Yes |  | First day of the round |
| `endDate` | DATE | Yes |  | Last day of the round |

## Referee

Accredited match officials.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `refereeID` | CHAR(4) | Yes | PK | Unique ID and primary key of a referee |
| `firstName` | VARCHAR2(25) | Yes |  | Referee's first name |
| `lastName` | VARCHAR2(25) | Yes |  | Referee's last name |
| `dateOfBirth` | DATE | No |  | Referee's date of birth |
| `phoneNum` | CHAR(10) | No |  | Referee's contact number |
| `startDate` | DATE | No |  | Referee's accreditation start date |
| `gender` | CHAR(1) | No |  | M or F |
| `refLevel` | CHAR(1) | No |  | Accreditation level, 1 (highest) to 4 |

## StartPosition

The 11 pitch positions plus Substitute.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `positionID` | CHAR(4) | Yes | PK | Unique ID and primary key of a pitch start position |
| `description` | VARCHAR2(25) | Yes |  | Name of the position, e.g. "Goalkeeper", "Substitute" |

## BestOnGround

The three best-on-ground placings and their point values.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `bogID` | CHAR(3) | Yes | PK | Unique ID and primary key of a best-on-ground placing |
| `rank` | CHAR(1) | Yes |  | Placing: 1, 2 or 3 |
| `points` | NUMBER(3) | Yes |  | Points awarded for that placing: 3, 2 or 1 |

## Result

The six result types and their competition points.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `resultID` | CHAR(4) | Yes | PK | Unique ID and primary key of a result type |
| `description` | VARCHAR2(15) | Yes |  | Home Win, Away Win, Home Draw, Away Draw, Home Loss or Away Loss |
| `points` | NUMBER(1,0) | Yes |  | Competition points for the result: 3 for a win, 1 for a draw, 0 for a loss |

## Club

The eight competing clubs.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `clubID` | CHAR(4) | Yes | PK | Unique ID and primary key of a club |
| `clubName` | VARCHAR2(25) | Yes |  | Club's name |
| `yearEstablished` | NUMBER(4,0) | No |  | Year the club was founded |
| `majorSponsor` | VARCHAR2(25) | No |  | Club's principal sponsor |
| `numOfMembers` | NUMBER(5,0) | No |  | Total registered members |
| `coachID` | CHAR(4) | Yes | FK → Coach.coachID | The club's coach |

**Constraints**

- `Club_PK` primary key on `clubID`
- `Club_Coach_FK` foreign key `coachID` → `Coach(coachID)`

## Player

Twelve players per club.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `playerID` | CHAR(5) | Yes | PK | Unique ID and primary key of a player |
| `firstName` | VARCHAR2(30) | Yes |  | Player's first name |
| `lastName` | VARCHAR2(30) | Yes |  | Player's last name |
| `phoneNum` | CHAR(10) | No |  | Player's contact number |
| `email` | VARCHAR2(30) | No |  | Player's email address |
| `jerseyNumber` | VARCHAR2(2) | No |  | Squad number worn by the player |
| `dateOfBirth` | DATE | No |  | Player's date of birth |
| `height` | NUMBER(3,0) | No |  | Height in centimetres |
| `weight` | NUMBER(3,0) | No |  | Weight in kilograms |
| `clubID` | CHAR(4) | Yes | FK → Club.clubID | The club the player is registered to |

**Constraints**

- `Player_PK` primary key on `playerID`
- `Player_Club_FK` foreign key `clubID` → `Club(clubID)`

## Ground

One home ground per club.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `groundID` | CHAR(4) | Yes | PK | Unique ID and primary key of a ground |
| `name` | VARCHAR2(30) | Yes |  | Name of the ground |
| `address` | VARCHAR2(40) | Yes |  | Street address of the ground |
| `capacity` | NUMBER(5,0) | Yes |  | Spectator capacity |
| `clubID` | CHAR(4) | Yes | FK → Club.clubID | The club that trains at and owns this ground |

**Constraints**

- `Ground_PK` primary key on `groundID`
- `Ground_Club_FK` foreign key `clubID` → `Club(clubID)`

## Game

Every fixture in the season.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `gameID` | CHAR(4) | Yes | PK | Unique ID and primary key of a game |
| `description` | VARCHAR2(15) | Yes |  | Fixture label, e.g. "CL01 v CL02" |
| `gameDate` | DATE | Yes |  | Date the game was played |
| `startTime` | DATE | Yes |  | Kick-off time |
| `endTime` | DATE | Yes |  | Full-time |
| `weekID` | CHAR(4) | Yes | FK → CompetitionWeek.weekID | The competition week the game belongs to |
| `groundID` | CHAR(4) | Yes | FK → Ground.groundID | The ground the game was played at |

**Constraints**

- `Game_PK` primary key on `gameID`
- `Game_CompetitionWeek_FK` foreign key `weekID` → `CompetitionWeek(weekID)`
- `Game_Ground_FK` foreign key `groundID` → `Ground(groundID)`

## ClubGame

One row per club per game: goals scored and result.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `clubGameID` | CHAR(5) | Yes | PK | Unique ID and primary key of one club's participation in one game |
| `gameID` | CHAR(4) | Yes | FK → Game.gameID | The game |
| `clubID` | CHAR(4) | Yes | FK → Club.clubID | The club |
| `goalScored` | NUMBER(2,0) | Yes |  | Goals this club scored in this game |
| `resultID` | CHAR(4) | Yes | FK → Result.resultID | This club's result in this game |

**Constraints**

- `ClubGame_PK` primary key on `clubGameID`
- `clubGame_game_FK` foreign key `gameID` → `Game(gameID)`
- `clubGame_club_FK` foreign key `clubID` → `Club(clubID)`
- `clubGame_result_FK` foreign key `resultID` → `Result(resultID)`

## GameReferee

Which referees officiated which game, and in what role.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `gameRefereeID` | CHAR(6) | Yes | PK | Unique ID and primary key of a refereeing appointment |
| `refRole` | VARCHAR2(15) | Yes |  | Head Referee, Assistant, or Fourth Official |
| `gameID` | CHAR(4) | Yes | FK → Game.gameID | The game officiated |
| `refereeID` | CHAR(4) | Yes | FK → Referee.refereeID | The referee appointed |

**Constraints**

- `GameReferee_PK` primary key on `gameRefereeID`
- `GR_Game_FK` foreign key `gameID` → `Game(gameID)`
- `GR_Referee_FK` foreign key `refereeID` → `Referee(refereeID)`

## GamePlayer

One row per player per game: their start position and minutes.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `gamePlayerID` | CHAR(6) | Yes | PK | Unique ID and primary key of one player's appearance in one game |
| `gameID` | CHAR(4) | Yes | FK → Game.gameID | The game |
| `playerID` | CHAR(5) | Yes | FK → Player.playerID | The player |
| `positionID` | CHAR(4) | Yes | FK → StartPosition.positionID | Start position; "Substitute" (SP12) marks a player who came off the bench |
| `gameMinute` | NUMBER(3,0) | Yes |  | Minutes played. 90 for a starter; fewer for a substitute |

**Constraints**

- `GamePlayer_PK` primary key on `gamePlayerID`
- `GamePlayer_Game_FK` foreign key `gameID` → `Game(gameID)`
- `GamePlayer_Player_FK` foreign key `playerID` → `Player(playerID)`
- `GamePlayer_Position_FK` foreign key `positionID` → `StartPosition(positionID)`

## AwardedCard

Yellow and red cards, tied to an appearance and the issuing official.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `awardedCardID` | CHAR(5) | Yes | PK | Unique ID and primary key of a disciplinary card |
| `cardDescription` | VARCHAR2(6) | Yes |  | Yellow or Red |
| `minute` | NUMBER(3,0) | Yes |  | Match minute the card was shown |
| `gamePlayerID` | CHAR(6) | Yes | FK → GamePlayer.gamePlayerID | The appearance the card was shown to |
| `gameRefereeID` | CHAR(6) | Yes | FK → GameReferee.gameRefereeID | The officiating appointment that issued the card |

**Constraints**

- `AwardedCard_PK` primary key on `awardedCardID`
- `AwardedCard_GamePlayer_FK` foreign key `gamePlayerID` → `GamePlayer(gamePlayerID)`
- `AwardedCard_GameReferee_FK` foreign key `gameRefereeID` → `GameReferee(gameRefereeID)`

## ScoredGoal

Every goal, tied to the appearance that scored it.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `goalID` | CHAR(5) | Yes | PK | Unique ID and primary key of a goal |
| `gamePlayerID` | CHAR(6) | Yes | FK → GamePlayer.gamePlayerID | The appearance that scored the goal |
| `gameMinute` | NUMBER(3,0) | Yes |  | Match minute the goal was scored |

**Constraints**

- `ScoredGoal_PK` primary key on `goalID`
- `ScoredGoal_GamePlayer_FK` foreign key `gamePlayerID` → `GamePlayer(gamePlayerID)`

## BOGPlayer

Best-on-ground awards, three per game.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| `bogPlayerID` | CHAR(6) | Yes | PK | Unique ID and primary key of a best-on-ground award |
| `bogID` | CHAR(3) | Yes | FK → BestOnGround.bogID | The placing awarded (1st, 2nd or 3rd) |
| `gamePlayerID` | CHAR(6) | Yes | FK → GamePlayer.gamePlayerID | The appearance that received the award |

**Constraints**

- `BOGPlayer_PK` primary key on `bogPlayerID`
- `BogPlayer_BOG_FK` foreign key `bogID` → `BestOnGround(bogID)`
- `BogPlayer_GamePlayer_FK` foreign key `gamePlayerID` → `GamePlayer(gamePlayerID)`
