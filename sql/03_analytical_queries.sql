-- Soccer Competition Database - Analytical Queries
-- Business questions answered with joins, aggregation, and subqueries (Oracle SQL)
-- ISYS5000 Group 13 - Waranyu Bancherdvanich, Farhan Bhuiyan, Thinley Dorji

-- ========================================================================
-- Query 1: Season ladder: result points, BoG points, goals, and home/away wins per club
-- ========================================================================
SELECT
cl.clubName AS "Club Name",
crs.total_result_points AS "Result Points",
bogp.total_bog_points AS "BOG Points",
tgs.goals_scored_count AS "Goals Scored",
hws.home_win_count AS "Home Wins",
aws.away_win_count AS "Away Wins",
crs.total_result_points + bogp.total_bog_points AS "Total Points (Result + BOG)"
FROM Club cl
JOIN (
SELECT cg.clubID, SUM(rs.points) AS total_result_points
FROM ClubGame cg
JOIN Result rs ON rs.resultID = cg.resultID
GROUP BY cg.clubID
) crs ON crs.clubID = cl.clubID
JOIN (
SELECT pl.clubID, SUM(bog.points) AS total_bog_points
FROM BogPlayer bp
JOIN BestOnGround bog ON bog.bogID = bp.bogID
JOIN GamePlayer gp ON gp.gamePlayerID = bp.gamePlayerID
JOIN Player pl ON pl.playerID = gp.playerID
GROUP BY pl.clubID
) bogp ON bogp.clubID = cl.clubID
JOIN (
SELECT cg.clubID, SUM(cg.goalScored) AS goals_scored_count
FROM ClubGame cg
GROUP BY cg.clubID
) tgs ON tgs.clubID = cl.clubID
JOIN (
SELECT cg.clubID, COUNT(*) AS home_win_count
FROM ClubGame cg
WHERE cg.resultID = 'RS02'
GROUP BY cg.clubID
) hws ON hws.clubID = cl.clubID
JOIN (
SELECT cg.clubID, COUNT(*) AS away_win_count
FROM ClubGame cg
WHERE cg.resultID = 'RS01'
GROUP BY cg.clubID
) aws ON aws.clubID = cl.clubID
ORDER BY "Result Points" DESC;

-- ========================================================================
-- Query 2: Club competition summary: points, goals, and full home/away win-loss record
-- ========================================================================
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

-- ========================================================================
-- Query 3: All goals scored in the season, in chronological order
-- ========================================================================
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

-- ========================================================================
-- Query 4: Average goals per game at each ground (LEFT JOIN keeps goalless games)
-- ========================================================================
SELECT
grn.name AS "Ground Name",
COUNT(sg.goalID) AS "Total Goals",
ROUND(COUNT(sg.goalID) / COUNT(DISTINCT gm.gameID), 0) AS "Average Goals per Game"
FROM Ground grn
JOIN Game gm ON grn.groundID = gm.groundID
JOIN GamePlayer gp ON gm.gameID = gp.gameID
LEFT JOIN ScoredGoal sg ON gp.gamePlayerID = sg.gamePlayerID
GROUP BY grn.name;

-- ========================================================================
-- Query 5: Top goal scorers across the competition
-- ========================================================================
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

-- ========================================================================
-- Query 6: Goals scored by the season's top scorer(s), with opponent and ground
-- ========================================================================
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

-- ========================================================================
-- Query 7: Best-on-Ground (MVP) points per player, ranked
-- ========================================================================
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

-- ========================================================================
-- Query 8: Best-on-Ground record across the season for the MVP player
-- ========================================================================
SELECT gm.gameID, gm.gameDate, pl.playerID, pl.firstName || ' ' || pl.lastName AS "Player Name", bog.points AS "BoG Points"
FROM Player pl
JOIN GamePlayer gp ON pl.playerID = gp.playerID
JOIN BogPlayer bp ON gp.gamePlayerID = bp.gamePlayerID
JOIN BestOnGround bog ON bp.bogID = bog.bogID
JOIN Game gm ON gp.gameID = gm.gameID
WHERE pl.playerID = 'PL810' /* PL810: Chris Brooks, MVP from 4.3a */
ORDER BY gm.gameDate;

-- ========================================================================
-- Query 9: Each club's away record: away wins, draws, and losses
-- ========================================================================
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
/* Finding the highest away team score */
HAVING SUM(rs.points) = (
SELECT MAX(highest_pts)
FROM (SELECT cg.clubID, SUM(rs.points) AS highest_pts
FROM ClubGame cg
JOIN Result rs ON cg.resultID = rs.resultID
JOIN Game gm ON cg.gameID = gm.gameID
JOIN Ground grn ON gm.groundID = grn.groundID
WHERE cg.clubID != grn.clubID
GROUP BY cg.clubID)
);

