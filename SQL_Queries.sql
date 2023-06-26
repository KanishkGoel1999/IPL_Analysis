
-- Delhi Capital's total wins batting first
(SELECT
count(DISTINCT ID)
FROM
`Dataa.Matches`
WHERE
WinningTeam='Delhi Daredevils' OR WinningTeam='Delhi Capitals' AND WonBY='Runs');

-- Delhi Capital's total wins batting second
(SELECT
count(DISTINCT ID)
FROM
`Dataa.Matches`
WHERE
WinningTeam='Delhi Capitals' OR WinningTeam='Delhi Daredevils' AND WonBY='Wickets');


-- All winning margins
SELECT
cast(margin as integer)
FROM
`Dataa.Matches`
WHERE margin != 'NA'
ORDER BY 
1 DesC;


-- Average margin runs batting 1st 
SELECT
AVG(ma)
FROM
(SELECT
cast(margin as integer) ma
FROM
`Dataa.Matches`
WHERE margin != 'NA' AND wonby='Runs') as s;


-- Average margin runs batting 2nd 
SELECT
AVG(ma)
FROM
(SELECT
cast(margin as integer) ma
FROM
`Dataa.Matches`
WHERE margin != 'NA' AND wonby='Wickets') as s;


-- Delhi average runs per location
SELECT s1.city, s1.sm/s2.cnt
FROM
(SELECT b.BattingTeam, city, sum(total_run) as sm
FROM `Dataa.BallByBall` as b inner join `Dataa.Matches` as m ON b.ID=m.ID WHERE b.BattingTeam='Delhi Daredevils' OR b.BattingTeam='Delhi Capitols' GROUP BY b.BattingTeam, city) as s1 inner join
(SELECT city, count(DISTINCT ID) as cnt FROM `Dataa.Matches`  WHERE Team1='Delhi Capitals' OR Team1='Delhi Daredevils' OR Team2='Delhi Capitals' OR Team2='Delhi Daredevils' GROUP BY city) as s2 ON s1.city=s2.city;



-- Match wise total by teams
SELECT
ID, BattingTeam, sum(total_run)
FROM
`Dataa.BallByBall`
GROUP BY
ID, BattingTeam
ORDER BY ID;


-- Score per match
SELECT
s1.ID, BattingTeam, total_score, city, extras, season
FROM
(SELECT
ID, BattingTeam, sum(total_run) as total_score, sum(extras_run) extras
FROM
`Dataa.BallByBall`
GROUP BY
ID, BattingTeam) as s1,
`Dataa.Matches` as m
WHERE s1.ID=m.ID
ORDER BY 1;


-- Delhi Capital's average at all cities
SELECT
s1.city, round(total/s2.cnt,2)
FROM
(SELECT
city, sum(total_score) as total
FROM
`Dataa.Score_per_match`
WHERE BattingTeam="Delhi Daredevils" OR BattingTeam='Delhi Capitols'
GROUP BY
 city) as s1, (SELECT city,count(ID) cnt FROM `Dataa.Score_per_match` WHERE BattingTeam="Delhi Daredevils" OR BattingTeam='Delhi Capitols'  GROUP BY city) as s2
 WHERE s1.city=s2.city
 ORDER BY 2;


-- Count of 200+ scores per season
SELECT
season, count(total_score)
from
`Dataa.Seasonal_score`
WHERE
total_score>=200
GROUP BY
season;


-- All innings with 200+ scores of all seasons
SELECT
season, total_score
from
`Dataa.Seasonal_score`
WHERE
total_score>=200;


-- Average score per city
SELECT 
city, round(sum(total_score)/count(total_score),2)
FROM
`Dataa.Score_per_match` as s
GROUP BY
city;


-- Collapses happened per city
SELECT
city, count(total_score)
FROM
`Dataa.Score_per_match`
WHERE
total_score<101
GROUP BY
city;


-- Collapses happened per season
SELECT
season, count(total_score)
FROM
`Dataa.Seasonal_score`
WHERE
total_score<101
GROUP BY
season;


-- Total runs scored by all batters over the seasons
SELECT
batter, sum(total_run) as Total_Runs
FROM
`Dataa.BallByBall`
GROUP BY 
batter
ORDER BY
2 DESC;


-- Maximum scores for all seasons
SELECT
season, max(sm)
FROM
(SELECT
batter, id, sum(total_run)-sum(extras_run) as sm
FROM
`Dataa.BallByBall` b
GROUP BY
batter, id) b inner join `Dataa.Seasonal_score` s ON
b.id=s.ID
GROUP BY
season;


-- Count of matches won by different ways
SELECT
wonBY, count(Id)
FROM
`Dataa.Matches`
GROUP BY
WonBy;


-- Total wins per season for each franchise
SELECT
winningTeam, season, count(ID)
FROM
`Dataa.Matches`
GROUP BY
1,2;
