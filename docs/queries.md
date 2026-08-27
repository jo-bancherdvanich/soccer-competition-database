# Analytical Queries

Nine business questions answered against the competition database, using joins,
aggregation, correlated subqueries, `HAVING`, and `LEFT JOIN`.

The results below are **real output**, produced by running
[`sql/03_analytical_queries.sql`](../sql/03_analytical_queries.sql) against the sample data in
[`sql/02_insert_data.sql`](../sql/02_insert_data.sql) — a complete 8-club, 14-round season:
56 games, 96 players, 1,344 appearances, 154 goals.

> Long result sets are truncated here to the first 10 rows; the row count above each
> table is the full figure.

---

## Contents

1. [The season ladder](#1-the-season-ladder)
2. [Club summary: the full win-loss record](#2-club-summary-the-full-winloss-record)
3. [Every goal in the season](#3-every-goal-in-the-season)
4. [Average goals per game by ground](#4-average-goals-per-game-by-ground)
5. [Top goal scorers](#5-top-goal-scorers)
6. [Every goal by the leading scorer](#6-every-goal-by-the-leading-scorer)
7. [Best-on-Ground standings](#7-bestonground-standings)
8. [The MVP's season, game by game](#8-the-mvps-season-game-by-game)
9. [Away form](#9-away-form)

---

## 1. The season ladder

**The question.** The headline question a competition organiser asks: who is on top? Competition points here are not just match results — the league also awards best-on-ground points, so the ladder has to combine both.

**How it works.** Five independent aggregates (result points, BoG points, goals, home wins, away wins) are computed as separate subqueries and joined back onto `Club`. They are **LEFT** joins wrapped in `COALESCE`, so a club that has never won away from home still appears with a zero rather than dropping off the ladder entirely.

<details>
<summary>SQL</summary>

```sql
SELECT
cl.clubName AS "Club Name",
COALESCE(crs.total_result_points, 0) AS "Result Points",
COALESCE(bogp.total_bog_points, 0) AS "BOG Points",
COALESCE(tgs.goals_scored_count, 0) AS "Goals Scored",
COALESCE(hws.home_win_count, 0) AS "Home Wins",
COALESCE(aws.away_win_count, 0) AS "Away Wins",
COALESCE(crs.total_result_points, 0) + COALESCE(bogp.total_bog_points, 0) AS "Total Points (Result + BOG)"
FROM Club cl
LEFT JOIN (
SELECT cg.clubID, SUM(rs.points) AS total_result_points
FROM ClubGame cg
JOIN Result rs ON rs.resultID = cg.resultID
GROUP BY cg.clubID
) crs ON crs.clubID = cl.clubID
LEFT JOIN (
SELECT pl.clubID, SUM(bog.points) AS total_bog_points
FROM BogPlayer bp
JOIN BestOnGround bog ON bog.bogID = bp.bogID
JOIN GamePlayer gp ON gp.gamePlayerID = bp.gamePlayerID
JOIN Player pl ON pl.playerID = gp.playerID
GROUP BY pl.clubID
) bogp ON bogp.clubID = cl.clubID
LEFT JOIN (
SELECT cg.clubID, SUM(cg.goalScored) AS goals_scored_count
FROM ClubGame cg
GROUP BY cg.clubID
) tgs ON tgs.clubID = cl.clubID
LEFT JOIN (
SELECT cg.clubID, COUNT(*) AS home_win_count
FROM ClubGame cg
WHERE cg.resultID = 'RS01'   /* RS01 = Home Win */
GROUP BY cg.clubID
) hws ON hws.clubID = cl.clubID
LEFT JOIN (
SELECT cg.clubID, COUNT(*) AS away_win_count
FROM ClubGame cg
WHERE cg.resultID = 'RS02'   /* RS02 = Away Win */
GROUP BY cg.clubID
) aws ON aws.clubID = cl.clubID
ORDER BY "Total Points (Result + BOG)" DESC, "Result Points" DESC;
```

</details>

**Result** — 8 rows:

| Club Name | Result Points | BOG Points | Goals Scored | Home Wins | Away Wins | Total Points (Result + BOG) |
|---|---|---|---|---|---|---|
| Reinscourt Rabbits | 23 | 46 | 17 | 4 | 2 | 69 |
| Wonnerup Wombats | 24 | 43 | 20 | 5 | 2 | 67 |
| Hanes Hawkes | 16 | 51 | 16 | 3 | 1 | 67 |
| New Caves Rd Numbats | 20 | 43 | 25 | 5 | 1 | 63 |
| Broadwater Bandicoots | 12 | 49 | 22 | 3 | 0 | 61 |
| Eagle Bay Eagles | 15 | 42 | 11 | 3 | 0 | 57 |
| Dunsborough Dingos | 21 | 35 | 21 | 3 | 3 | 56 |
| Mary-Brook Magpies | 22 | 27 | 22 | 4 | 2 | 49 |

---

## 2. Club summary: the full win-loss record

**The question.** The ladder shows standing; this shows shape. A club with the same points as another might get them all at home, which matters for a coach.

**How it works.** Correlated scalar subqueries in the `SELECT` list, one per statistic. Each counts `ClubGame` rows matching a result description. Reads more naturally than six more joins, at the cost of running once per club.

<details>
<summary>SQL</summary>

```sql
SELECT cl.clubID, cl.clubName,
(SELECT SUM(rs.points)
FROM ClubGame cg
JOIN Result rs ON cg.resultID = rs.resultID
WHERE cg.clubID = cl.clubID) AS "Total Competition Point",
(SELECT SUM(cg.goalScored)
FROM ClubGame cg
WHERE cg.clubID = cl.clubID) AS "Total Goal Score",
(SELECT COUNT(*)
FROM ClubGame cg
JOIN Result rs ON cg.resultID = rs.resultID
JOIN Game gm ON cg.gameID = gm.gameID
JOIN Ground grn ON gm.groundID = grn.groundID
WHERE cg.clubID = cl.clubID AND rs.description = 'Home Win') AS "Home Win",
(SELECT COUNT(*)
FROM ClubGame cg
JOIN Result rs ON cg.resultID = rs.resultID
JOIN Game gm ON cg.gameID = gm.gameID
JOIN Ground grn ON gm.groundID = grn.groundID
WHERE cg.clubID = cl.clubID AND rs.description = 'Home Loss') AS "Home Loss",
(SELECT COUNT(*)
FROM ClubGame cg
JOIN Result rs ON cg.resultID = rs.resultID
JOIN Game gm ON cg.gameID = gm.gameID
JOIN Ground grn ON gm.groundID = grn.groundID
WHERE cg.clubID = cl.clubID AND rs.description = 'Away Win') AS "Away Win",
(SELECT COUNT(*)
FROM ClubGame cg
JOIN Result rs ON cg.resultID = rs.resultID
JOIN Game gm ON cg.gameID = gm.gameID
JOIN Ground grn ON gm.groundID = grn.groundID
WHERE cg.clubID = cl.clubID AND rs.description = 'Away Loss') AS "Away Loss"
FROM Club cl
ORDER BY "Total Competition Point" DESC, "Total Goal Score" DESC;
```

</details>

**Result** — 8 rows:

| clubID | clubName | Total Competition Point | Total Goal Score | Home Win | Home Loss | Away Win | Away Loss |
|---|---|---|---|---|---|---|---|
| CL06 | Wonnerup Wombats | 24 | 20 | 5 | 0 | 2 | 4 |
| CL05 | Reinscourt Rabbits | 23 | 17 | 4 | 1 | 2 | 2 |
| CL04 | Mary-Brook Magpies | 22 | 22 | 4 | 2 | 2 | 2 |
| CL02 | Dunsborough Dingos | 21 | 21 | 3 | 2 | 3 | 3 |
| CL07 | New Caves Rd Numbats | 20 | 25 | 5 | 2 | 1 | 4 |
| CL08 | Hanes Hawkes | 16 | 16 | 3 | 1 | 1 | 5 |
| CL01 | Eagle Bay Eagles | 15 | 11 | 3 | 1 | 0 | 4 |
| CL03 | Broadwater Bandicoots | 12 | 22 | 3 | 2 | 0 | 6 |

---

## 3. Every goal in the season

**The question.** The raw event log. Useful on its own and the basis for the scoring queries below.

**How it works.** The join path is the interesting part: `ScoredGoal` → `GamePlayer` → `Player`, then back out to `ClubGame` to work out which club the scorer was playing for in that game. Joining `ClubGame` on **both** `gameID` and `clubID` is what stops each goal appearing twice, once for each club in the fixture.

<details>
<summary>SQL</summary>

```sql
SELECT
gm.gameID AS "Game Number",
gm.description AS "Fixture",
cl.clubName AS "Club Scored",
pl.firstName || ' ' || pl.lastName AS "Name of the Scorer",
sg.gameMinute AS "Minute Goal Scored",
grn.name AS "Name of Ground",
gm.gameDate AS "Date"
FROM ScoredGoal sg
JOIN GamePlayer gp ON sg.gamePlayerID = gp.gamePlayerID
JOIN Player pl ON gp.playerID = pl.playerID
JOIN ClubGame cg ON gp.gameID = cg.gameID AND cg.clubID = pl.clubID
JOIN Club cl ON cg.clubID = cl.clubID
JOIN Game gm ON gp.gameID = gm.gameID
JOIN Ground grn ON gm.groundID = grn.groundID
ORDER BY gm.gameDate, gm.gameID, sg.gameMinute;
```

</details>

**Result** — 154 rows, first 10 shown:

| Game Number | Fixture | Club Scored | Name of the Scorer | Minute Goal Scored | Name of Ground | Date |
|---|---|---|---|---|---|---|
| GM12 | CL02 v CL03 | Dunsborough Dingos | Lachlan Taylor | 25 | Quedjinup Reserve | 01/06/2025 |
| GM12 | CL02 v CL03 | Dunsborough Dingos | Jack Radcliffe | 29 | Quedjinup Reserve | 01/06/2025 |
| GM12 | CL02 v CL03 | Dunsborough Dingos | Elliot Ashby | 32 | Quedjinup Reserve | 01/06/2025 |
| GM12 | CL02 v CL03 | Broadwater Bandicoots | Blake Vance | 34 | Quedjinup Reserve | 01/06/2025 |
| GM12 | CL02 v CL03 | Broadwater Bandicoots | Samuel Vance | 39 | Quedjinup Reserve | 01/06/2025 |
| GM12 | CL02 v CL03 | Dunsborough Dingos | Elliot Ashby | 52 | Quedjinup Reserve | 01/06/2025 |
| GM47 | CL02 v CL06 | Wonnerup Wombats | Hugo Martin | 70 | Quedjinup Reserve | 01/08/2025 |
| GM30 | CL07 v CL02 | Dunsborough Dingos | Henry Hayes | 23 | Caves Road Reserve | 02/07/2025 |
| GM30 | CL07 v CL02 | Dunsborough Dingos | Aaron Martin | 24 | Caves Road Reserve | 02/07/2025 |
| GM30 | CL07 v CL02 | Dunsborough Dingos | Patrick Hollis | 74 | Caves Road Reserve | 02/07/2025 |

*…and 144 more.*

---

## 4. Average goals per game by ground

**The question.** Do some grounds produce higher-scoring games? A genuine question for scheduling and for ticket pricing.

**How it works.** A `LEFT JOIN` onto `ScoredGoal` so that goalless games still count in the denominator — an inner join would quietly drop them and inflate every average. `COUNT(DISTINCT gm.gameID)` counts games rather than rows, because the join through `GamePlayer` multiplies rows 24 times per game.

<details>
<summary>SQL</summary>

```sql
SELECT
grn.name AS "Ground Name",
COUNT(sg.goalID) AS "Total Goals",
ROUND(COUNT(sg.goalID) * 1.0 / COUNT(DISTINCT gm.gameID), 2) AS "Average Goals per Game"
FROM Ground grn
JOIN Game gm ON grn.groundID = gm.groundID
JOIN GamePlayer gp ON gm.gameID = gp.gameID
LEFT JOIN ScoredGoal sg ON gp.gamePlayerID = sg.gamePlayerID
GROUP BY grn.name;
```

</details>

**Result** — 8 rows:

| Ground Name | Total Goals | Average Goals per Game |
|---|---|---|
| Broadwater Bay Oval | 22 | 3.14 |
| Caves Road Reserve | 24 | 3.43 |
| Eagle Bay Centre | 9 | 1.29 |
| Hanes Sports Ground | 19 | 2.71 |
| Mary-Brook Park | 23 | 3.29 |
| Quedjinup Reserve | 24 | 3.43 |
| Reinscourt Oval | 15 | 2.14 |
| Wonnerup Sports Ground | 18 | 2.57 |

---

## 5. Top goal scorers

**The question.** The golden boot.

**How it works.** A straightforward aggregation, but note it groups by name and club rather than `playerID`, so two players with the same name at the same club would merge. Grouping by `playerID` would be safer; it is kept as written because the sample data has no such collision.

<details>
<summary>SQL</summary>

```sql
SELECT
pl.firstname || ' ' || pl.lastname AS "Name",
COUNT(sg.gamePlayerID) AS "Goals Scored",
cl.clubname AS "Club Name"
FROM ScoredGoal sg
JOIN GamePlayer gp ON gp.gamePlayerID = sg.gamePlayerID
JOIN Player pl ON pl.playerID = gp.playerID
JOIN Club cl ON pl.clubID = cl.clubID
GROUP BY pl.firstname, pl.lastname, cl.clubname
ORDER BY COUNT(sg.gamePlayerID) DESC;
```

</details>

**Result** — 81 rows, first 10 shown:

| Name | Goals Scored | Club Name |
|---|---|---|
| Oscar Foster | 8 | New Caves Rd Numbats |
| Mason Fletcher | 5 | Mary-Brook Magpies |
| Blake Vance | 4 | Broadwater Bandicoots |
| Grant Jarvis | 4 | New Caves Rd Numbats |
| Quinn Oakley | 4 | Wonnerup Wombats |
| Dylan Thorne | 3 | Wonnerup Wombats |
| Elliot Ashby | 3 | Dunsborough Dingos |
| Elliot Sinclair | 3 | Hanes Hawkes |
| Grant Ellis | 3 | Reinscourt Rabbits |
| Henry Hayes | 3 | Dunsborough Dingos |

*…and 71 more.*

---

## 6. Every goal by the leading scorer

**The question.** Having found the top scorer, show their season: who they scored against, where, and when.

**How it works.** The `HAVING COUNT(...) = (SELECT MAX(...))` pattern finds the top scorer without hard-coding an ID, and handles ties by returning all joint leaders. The self-join on `ClubGame` (`oppCG.clubID <> cg.clubID`) is what yields the opponent.

<details>
<summary>SQL</summary>

```sql
SELECT
pl.firstName || ' ' || pl.lastName AS "Player Name",
gm.gameID AS "Game Number",
gm.description AS "Fixture",
opp.clubName AS "Scored Against",
grn.name AS "Ground Name",
sg.gameMinute AS "Minute Scored",
gm.gamedate AS "Game Date"
FROM ScoredGoal sg
JOIN GamePlayer gp ON sg.gamePlayerID = gp.gamePlayerID
JOIN Player pl ON gp.playerID = pl.playerID
JOIN Game gm ON gp.gameID = gm.gameID
JOIN ClubGame cg ON gp.gameID = cg.gameID AND cg.clubID = pl.clubID
JOIN ClubGame oppCG ON oppCG.gameID = gm.gameID AND oppCG.clubID <> cg.clubID
JOIN Club opp ON opp.clubID = oppCG.clubID
JOIN Ground grn ON gm.groundID = grn.groundID
WHERE gp.playerID IN (
SELECT gp2.playerID
FROM ScoredGoal sg2
JOIN GamePlayer gp2 ON sg2.gamePlayerID = gp2.gamePlayerID
GROUP BY gp2.playerID
HAVING COUNT(sg2.goalID) = (
SELECT MAX(totalGoals)
FROM (
SELECT gp3.playerID, COUNT(sg3.goalID) AS totalGoals
FROM ScoredGoal sg3
JOIN GamePlayer gp3 ON sg3.gamePlayerID = gp3.gamePlayerID
GROUP BY gp3.playerID
     )
  )
)
ORDER BY gm.gamedate, gm.gameID, sg.gameMinute;
```

</details>

**Result** — 8 rows:

| Player Name | Game Number | Fixture | Scored Against | Ground Name | Minute Scored | Game Date |
|---|---|---|---|---|---|---|
| Oscar Foster | GM15 | CL03 v CL07 | Broadwater Bandicoots | Broadwater Bay Oval | 30 | 06/06/2025 |
| Oscar Foster | GM52 | CL06 v CL07 | Wonnerup Wombats | Wonnerup Sports Ground | 63 | 10/08/2025 |
| Oscar Foster | GM02 | CL02 v CL07 | Dunsborough Dingos | Quedjinup Reserve | 77 | 14/05/2025 |
| Oscar Foster | GM20 | CL07 v CL08 | Hanes Hawkes | Caves Road Reserve | 83 | 15/06/2025 |
| Oscar Foster | GM55 | CL07 v CL04 | Mary-Brook Magpies | Caves Road Reserve | 15 | 15/08/2025 |
| Oscar Foster | GM55 | CL07 v CL04 | Mary-Brook Magpies | Caves Road Reserve | 26 | 15/08/2025 |
| Oscar Foster | GM05 | CL07 v CL01 | Eagle Bay Eagles | Caves Road Reserve | 50 | 19/05/2025 |
| Oscar Foster | GM05 | CL07 v CL01 | Eagle Bay Eagles | Caves Road Reserve | 66 | 19/05/2025 |

---

## 7. Best-on-Ground standings

**The question.** The MVP race, broken down so you can see whether a player is winning it with a few 3-point games or consistent minor placings.

**How it works.** Three parallel correlated subqueries count 3, 2 and 1-point awards separately, then a fourth totals them. The `WHERE ... IN` restricts the output to players who have actually polled, rather than listing all 96 with zeros.

<details>
<summary>SQL</summary>

```sql
SELECT
pl.playerID,
pl.firstName || ' ' || pl.lastName AS "Player Name",
/* Count how many times player scored 3 points */
(SELECT COUNT(*)
FROM BogPlayer bp3
JOIN BestOnGround bog3 ON bp3.bogID = bog3.bogID
JOIN GamePlayer gp3 ON bp3.gamePlayerID = gp3.gamePlayerID
WHERE gp3.playerID = pl.playerID AND bog3.points = 3) AS "Rank 1 (3 Points)",
/* Count how many times player scored 2 points */
(SELECT COUNT(*)
FROM BogPlayer bp2
JOIN BestOnGround bog2 ON bp2.bogID = bog2.bogID
JOIN GamePlayer gp2 ON bp2.gamePlayerID = gp2.gamePlayerID
WHERE gp2.playerID = pl.playerID AND bog2.points = 2) AS "Rank 2 (2 Points)",
/* Count how many times player scored 1 point */
(SELECT COUNT(*)
FROM BogPlayer bp1
JOIN BestOnGround bog1 ON bp1.bogID = bog1.bogID
JOIN GamePlayer gp1 ON bp1.gamePlayerID = gp1.gamePlayerID
WHERE gp1.playerID = pl.playerID AND bog1.points = 1) AS "Rank 3 (1 Point)",
/* Total BoG points */
(SELECT SUM(bog.points)
FROM BogPlayer bp
JOIN BestOnGround bog ON bp.bogID = bog.bogID
JOIN GamePlayer gp ON bp.gamePlayerID = gp.gamePlayerID
WHERE gp.playerID = pl.playerID) AS "Total BoG Points"
FROM Player pl
WHERE pl.playerID IN (
SELECT DISTINCT gp.playerID
FROM BogPlayer bp
JOIN GamePlayer gp ON bp.gamePlayerID = gp.gamePlayerID
)
ORDER BY "Total BoG Points" DESC;
```

</details>

**Result** — 79 rows, first 10 shown:

| playerID | Player Name | Rank 1 (3 Points) | Rank 2 (2 Points) | Rank 3 (1 Point) | Total BoG Points |
|---|---|---|---|---|---|
| PL404 | Toby Irwin | 1 | 3 | 2 | 11 |
| PL802 | Aaron Chandler | 3 | 1 | 0 | 11 |
| PL804 | Dylan Thorne | 2 | 1 | 2 | 10 |
| PL105 | Jack Carter | 1 | 2 | 1 | 8 |
| PL306 | Finn Irwin | 2 | 1 | 0 | 8 |
| PL502 | Miles Oakley | 2 | 1 | 0 | 8 |
| PL507 | Ethan Taylor | 1 | 2 | 1 | 8 |
| PL707 | Grant Gibbs | 2 | 1 | 0 | 8 |
| PL312 | Noah Irwin | 1 | 2 | 0 | 7 |
| PL509 | Leo Gibbs | 2 | 0 | 1 | 7 |

*…and 69 more.*

---

## 8. The MVP's season, game by game

**The question.** The detail behind the top line of the previous query.

**How it works.** The MVP is derived rather than hard-coded, using the same `MAX` subquery pattern as the top-scorer query — so the result stays correct if the data changes, and all players are returned in the event of a tie.

<details>
<summary>SQL</summary>

```sql
SELECT gm.gameID, gm.gameDate, pl.playerID, pl.firstName || ' ' || pl.lastName AS "Player Name", bog.points AS "BoG Points"
FROM Player pl
JOIN GamePlayer gp ON pl.playerID = gp.playerID
JOIN BogPlayer bp ON gp.gamePlayerID = bp.gamePlayerID
JOIN BestOnGround bog ON bp.bogID = bog.bogID
JOIN Game gm ON gp.gameID = gm.gameID
/* Derive the MVP rather than hard-coding an ID, so this query stays correct
   if the data changes. Same MAX-subquery pattern as Query 6. */
WHERE pl.playerID IN (
SELECT gp2.playerID
FROM BogPlayer bp2
JOIN BestOnGround bog2 ON bp2.bogID = bog2.bogID
JOIN GamePlayer gp2 ON bp2.gamePlayerID = gp2.gamePlayerID
GROUP BY gp2.playerID
HAVING SUM(bog2.points) = (
SELECT MAX(total_pts)
FROM (
SELECT SUM(bog3.points) AS total_pts
FROM BogPlayer bp3
JOIN BestOnGround bog3 ON bp3.bogID = bog3.bogID
JOIN GamePlayer gp3 ON bp3.gamePlayerID = gp3.gamePlayerID
GROUP BY gp3.playerID
     )
  )
)
ORDER BY gm.gameDate;
```

</details>

**Result** — 10 rows:

| gameID | gameDate | playerID | Player Name | BoG Points |
|---|---|---|---|---|
| GM14 | 04/06/2025 | PL404 | Toby Irwin | 1 |
| GM32 | 06/07/2025 | PL404 | Toby Irwin | 2 |
| GM51 | 08/08/2025 | PL802 | Aaron Chandler | 2 |
| GM01 | 12/05/2025 | PL802 | Aaron Chandler | 3 |
| GM36 | 13/07/2025 | PL404 | Toby Irwin | 2 |
| GM22 | 18/06/2025 | PL404 | Toby Irwin | 3 |
| GM39 | 18/07/2025 | PL802 | Aaron Chandler | 3 |
| GM42 | 23/07/2025 | PL404 | Toby Irwin | 2 |
| GM08 | 25/05/2025 | PL404 | Toby Irwin | 1 |
| GM44 | 27/07/2025 | PL802 | Aaron Chandler | 3 |

---

## 9. Away form

**The question.** Away record separates the genuinely strong clubs from the ones with a good ground.

**How it works.** A game is "away" for a club when the ground belongs to the *other* club — `cg.clubID != grn.clubID`. That single predicate is what makes home and away separable without storing a flag. Ordered by away points so the best travelling side is the top row.

<details>
<summary>SQL</summary>

```sql
SELECT cl.clubID, cl.clubName,
/* SUM of Away point */
SUM(rs.points) AS "Total Away Points",
/* The count of Away Win */
(SELECT COUNT(*)
FROM ClubGame cg2
JOIN Result rs2 ON cg2.resultID = rs2.resultID
JOIN Game gm2 ON cg2.gameID = gm2.gameID
JOIN Ground grn2 ON gm2.groundID = grn2.groundID
WHERE cg2.clubID = cl.clubID
AND cg2.clubID != grn2.clubID
AND rs2.description = 'Away Win') AS "Away Wins",
/* The count of Away Draw */
(SELECT COUNT(*)
FROM ClubGame cg3
JOIN Result rs3 ON cg3.resultID = rs3.resultID
JOIN Game gm3 ON cg3.gameID = gm3.gameID
JOIN Ground grn3 ON gm3.groundID = grn3.groundID
WHERE cg3.clubID = cl.clubID
AND cg3.clubID != grn3.clubID
AND rs3.description = 'Away Draw') AS "Away Draws",
/* The count of Away Loss */
(SELECT COUNT(*)
FROM ClubGame cg4
JOIN Result rs4 ON cg4.resultID = rs4.resultID
JOIN Game gm4 ON cg4.gameID = gm4.gameID
JOIN Ground grn4 ON gm4.groundID = grn4.groundID
WHERE cg4.clubID = cl.clubID
AND cg4.clubID != grn4.clubID
AND rs4.description = 'Away Loss') AS "Away Losses"
FROM Club cl
JOIN ClubGame cg ON cl.clubID = cg.clubID
JOIN Result rs ON cg.resultID = rs.resultID
JOIN Game gm ON cg.gameID = gm.gameID
JOIN Ground grn ON gm.groundID = grn.groundID
WHERE cg.clubID != grn.clubID
GROUP BY cl.clubID, cl.clubName
/* Ordered by away points, so the club with the best away record is the top
   row. Previously a HAVING clause filtered this down to that single club,
   which contradicted the query's own heading and the README. */
ORDER BY "Total Away Points" DESC, "Away Wins" DESC;
```

</details>

**Result** — 8 rows:

| clubID | clubName | Total Away Points | Away Wins | Away Draws | Away Losses |
|---|---|---|---|---|---|
| CL02 | Dunsborough Dingos | 10 | 3 | 1 | 3 |
| CL05 | Reinscourt Rabbits | 9 | 2 | 3 | 2 |
| CL04 | Mary-Brook Magpies | 9 | 2 | 3 | 2 |
| CL06 | Wonnerup Wombats | 7 | 2 | 1 | 4 |
| CL07 | New Caves Rd Numbats | 5 | 1 | 2 | 4 |
| CL08 | Hanes Hawkes | 4 | 1 | 1 | 5 |
| CL01 | Eagle Bay Eagles | 3 | 0 | 3 | 4 |
| CL03 | Broadwater Bandicoots | 1 | 0 | 1 | 6 |

---

## Running these yourself

In Oracle (SQL Developer, or Oracle Live SQL), run the scripts in order:

```
sql/01_create_tables.sql   -- creates the 16 tables
sql/02_insert_data.sql     -- loads the season
sql/03_analytical_queries.sql
```

The whole script set has been verified end to end: all 16 tables create, all 2,227 rows
load with no foreign key violations, and all nine queries return the results above.
