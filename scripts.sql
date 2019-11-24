/* 1. What range of years does the provided database cover?*/
SELECT DISTINCT yearid
FROM batting
ORDER BY yearid;
-- 146 Distinct years 
--1871 to 2016

/* 2. Find the name and height of the shortest player in the database.*/ 

SELECT *
FROM people
LIMIT 10;

SELECT 
playerid,
namefirst, 
namelast,
namegiven,
height
FROM people
WHERE height = (
    SELECT MIN(height) 
    FROM people
);
-- gaedeed01 Eddie Gaedel(Edward Carl) height(43)

/* How many games did he play in? What is the name of the team for which he played?*/

SELECT *
FROM batting AS b
WHERE playerid = 'gaedeed01';

-- total games = 1
-- names of team = St. Louis Browns(SLA) 

SELECT *
FROM teams
WHERE teamid = 'SLA';


/* 3. Find all players in the database who played at Vanderbilt University. */
SELECT DISTINCT(c.playerid) AS num_players,  s.schoolname
FROM schools AS s
JOIN collegeplaying AS c
USING(schoolid)
WHERE schoolname = 'Vanderbilt University'
GROUP BY s.schoolname, c.playerid;
--24 players

/*Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues.*/

SELECT   
p.namefirst, 
p.namelast, 
SUM(sa.salary) AS sum_salary
FROM schools AS s
JOIN collegeplaying AS c
USING(schoolid)
JOIN people AS p
USING (playerid)
JOIN salaries AS sa
USING(playerid)
WHERE schoolname = 'Vanderbilt University'
GROUP BY p.namefirst, p.namelast
ORDER BY sum_salary;

--END



/*SELECT *
FROM salaries
WHERE playerid = 'barkele01';
LIMIT ;*/


/*Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?*/
SELECT 
p.namefirst, 
p.namelast,
SUM(sa.salary) AS sum_salary
FROM people AS p, salaries AS sa
WHERE p.playerid IN
         (SELECT  
           c.playerid
           FROM collegeplaying AS c, schools d
            WHERE c.schoolid = d.schoolid
AND schoolname = 'Vanderbilt University')
and p.playerid = sa.playerid
GROUP BY p.namefirst, p.namelast, sa.playerid
ORDER BY sum_salary DESC;
--David Price 81,851,296
--END


FROM schools AS s
JOIN collegeplaying AS c
USING(schoolid)
JOIN people AS p
USING (playerid)
JOIN salaries AS sa
USING(playerid)
WHERE schoolname = 'Vanderbilt University'

--David Price 81,851,296

/* 4.Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", 
those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". 
Determine the number of putouts made by each of these three groups in 2016.*/


SELECT  
CASE WHEN pos = 'OF' THEN 'Outfield'
WHEN pos = 'P' or pos = 'C' THEN 'Battery'
ELSE 'Infield' END AS position
FROM fielding AS f
WHERE yearid = '2016'
GROUP BY CASE 
WHEN pos = 'OF' THEN 'Outfield'
WHEN pos = 'P' or pos = 'C' THEN 'Battery'
ELSE 'Infield' END
ORDER BY position DESC;
---END
--THE TOTAL NUMBER OF PUT_OUTS
SELECT 
position,
count(position),
sum(po) AS put_outs 
FROM
(SELECT pos, po,  
CASE WHEN pos = 'OF' THEN 'Outfield'
WHEN pos = 'P' or pos = 'C' THEN 'Battery'
ELSE 'Infield' END AS position
FROM fielding AS f
WHERE yearid = '2016'
) AS subquery
GROUP BY position;
--END

/* 5.Find the average number of strikeouts per game by decade since 1920. 
Round the numbers you report to 2 decimal places. 
Do the same for home runs per game. Do you see any trends?*/
SELECT * FROM teams limit 10;
--strikeouts per game by decade since 1920

SELECT FLOOR (yearid/10)*10 AS decade, round(cast(avg(cast(so as float))as numeric),2) as avg_strikeouts
FROM battingpost
where yearid >=1920
group by decade
order by decade DESC;

--END
	

--Homeruns per game by decade since 1920
SELECT FLOOR (yearid/10)*10 AS decade, round(cast(avg(cast(hr as float))as numeric),2) as avg_homeruns
FROM battingpost
where yearid >=1920
group by decade
order by decade DESC;

--END 

-- Both strikeouts and Homeruns avgs 
SELECT FLOOR (yearid/10)*10 AS decade, round(cast(avg(cast(so as float))as numeric),2) as avg_strikeouts, round(cast(avg(cast(hr as float))as numeric),2) as avg_homeruns
FROM battingpost
where yearid >=1920
group by decade
order by decade DESC;

--There is an increase in the # of strikeouts and homeruns since 1920 to 2016	
-- As the strikesout increase homeruns increase and viceversa
--END--



There is an increase in the # of strikeouts and homeruns since 1920 to 2016		

/* 6. Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of stolen base attempts which are successful. 
(A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted at least 20 stolen bases.*/
SELECT 
p.namefirst,
p.namelast,
p.namegiven

SELECT b.playerid, MAX(p.namefirst),
MAX(p.namelast),
MAX(p.namegiven),
	  MAX(b.sb) AS most_steal
FROM batting AS b

INNER JOIN people AS p
ON b.playerid = p.playerid

WHERE yearid = '2016' AND sb>=20
GROUP BY b.playerid
ORDER BY most_steal DESC;
-- END--
SELECT 
--DISTINCT playerid
p.namefirst,
p.namelast,
p.namegiven,
(b.sb),
b.cs
FROM batting AS b
JOIN people AS p
USING(playerid)
WHERE yearid ='2016'
AND (sb+cs) >= 20
ORDER BY sb DESC; 

--Jonathan Villar
--  47 players with a total sb and cs >= 20


SELECT 
DISTINCT (b.playerid),
p.namefirst,
p.namelast,
p.namegiven,
b.sb,
b.cs
FROM batting AS b
JOIN people AS p
USING(playerid)
WHERE yearid ='2016'
AND sb >= 20
ORDER BY sb DESC; 
--Jonathan Villar
-- 28 players only with sb >=20


/* 7. From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? */

SELECT DISTINCT(t.teamid),
 t.name,
 t.wswin,
 t.w
FROM teams AS t
WHERE wswin = 'N'
AND yearid >= 1970 
GROUP BY name, t.teamid, t.wswin, t.w
ORDER BY t.w DESC;

-- SEA Seattle Mariners 116

/* What is the smallest number of wins 
for a team that did win the world series?*/ 
SELECT DISTINCT(t.teamid),

 t.yearid,
 t.name,
 t.wswin,
 MIN(t.w) 
FROM teams AS t
WHERE wswin = 'Y'
AND yearid >= 1970
GROUP BY name, t.teamid, t.wswin,t.w, t.yearid
ORDER BY MIN(t.w);

-- TOR Los Angeles Dodgers 63, (strike in 1981)


/*Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. 
How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?*/
select yearid, teamid, g,wswin
from teams;

select distinct teams.wswin
from teams;

select yearid, teamid
from teams
where wswin= 'Y'
and yearid between 1970 and 2016
group by yearid, teamid;
----
WITH most_wins_per_year AS(
with win_ranks as (
WITH win_ranks as (
select 
	yearid, 
	teamid,
	w,
	wswin,
	row_number()over(partition by yearid order by w desc, wswin desc)as rank
from teams
where yearid between 1970 and 2016)
select yearid, teamid
FROM win_ranks
where rank = 1
),
ws_wins_by_year AS(	
select yearid, teamid
from teams
where wswin= 'Y'
and yearid between 1970 and 2016
group by yearid, teamid
)

SELECT COUNT(distinct mwby.yearid), 
2017-1970-1 as total_years,
round(count(distinct(mwby)))
FROM most_wins_by_year mwby
INNER JOIN ws_wins_by_year wwby
ON mwby.yearid = mwby.yearid
AND mwby.teamid = mwby.teamid;

---GOOD CTEs
with most_wins_by_year as (
    with win_ranks as (
        select
               yearid,
               teamid,
               w,
               wswin,
               row_number() over (partition by yearid order by w desc, wswin desc) as rank
        from teams
        where yearid between 1970 and 2016
    )
    select yearid, teamid
    from win_ranks
    where rank = 1
),
ws_wins_by_year as (
    select yearid, teamid
    from teams
    where wswin = 'Y'
        and yearid between 1970 and 2016
    group by yearid, teamid
)
select count(distinct mwby.yearid),
       2017 - 1970 - 1 as total_years,
       round(count(distinct mwby.yearid) / (2017 - 1970 - 1)::numeric, 2) * 100 as pct_did_win
from most_wins_by_year mwby
inner join ws_wins_by_year wwby
    on mwby.yearid = wwby.yearid
           AND mwby.teamid = wwby.teamid;


	
--- END
SELECT DISTINCT(t.teamid),
 t.name,
 t.wswin,
 COUNT(t.w) AS Total_wins
FROM teams AS t
WHERE wswin = 'Y' 
AND yearid >= 1970
GROUP BY name, t.teamid, t.wswin
ORDER BY COUNT(t.w) DESC;
-- only 21 teams
-- largest number of wins 7

SELECT DISTINCT(t.teamid),
 t.name,
 t.wswin,
 COUNT(t.w) AS Total_wins
FROM teams AS t
WHERE wswin = 'Y'
AND yearid >= 1970
GROUP BY name, t.teamid, t.wswin
ORDER BY COUNT(t.w) ASC;

-- Anaheim Angels 1 win


SELECT DISTINCT(t.teamid),
 t.name,
 t.wswin,
 SUM(t.w) ,
CASE WHEN t.wswin = 'Y' AND SUM(t.w) >=1 THEN 'WIN'
	ELSE 'LOSE' END AS win_or_lose
FROM teams AS t
WHERE wswin = 'Y'
AND yearid >= 1970
GROUP BY (t.teamid), t.name, t.wswin
ORDER BY  sum DESC;
-- 21 teams
*---Percentage of the times ?

/* 8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games).
Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.*/

SELECT DISTINCT(hmg.team), 
MAX(hmg.park), 
max(hmg.games),
max(p.park_name),
max(t.name),
ROUND((hmg.attendance/hmg.games),2) AS avg_attendance
FROM homegames AS hmg
inner JOIN parks AS p
USING (park)
JOIN teams AS t
ON t.teamid = hmg.team
WHERE year = '2016'
AND games >=10
GROUP BY hmg.team,hmg.attendance,hmg.games
ORDER by avg_attendance DESC
LIMIT 5;
--park name         Team name              avg_attendance
--Dodger stadium    Los Angeles Dodgers
--Busch Stadium III St.LoUIS Perfectos
-- Rogers Centre    Toronto Blue Jays
--AT&T Park         San Francisco Giants
-- Wringley Field   Chicago White Stockings

/* 9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? 
Give their full name and the teams that they were managing when they won the award.*/
---taylors
--unique players
WITH nl_managers AS(
	SELECT playerid, yearid
	FROM awardsmanagers
	where lgid = 'NL' AND awardid = 'TSN Manager of the Year'
	group by playerid, yearid
),
al_managers AS(	
	SELECT playerid, yearid
	FROM awardsmanagers
	where lgid = 'AL' AND awardid = 'TSN Manager of the Year'
	group by playerid, yearid
	)	
SELECT al_m.playerid, p.namefirst || ' ' ||p.namelast as full_name, m.yearid, m.teamid
	FROM nl_managers  nl_m
	INNER JOIN al_managers al_m using (playerid)
	INNER JOIN people p using (playerid)
	left JOIN managers m ON p.playerid = m.playerid AND (m.yearid = al_m.yearid or m.yearid = nl_m.yearid)
	ORDER BY al_m.yearid, playerid;
--END---		
	

--Open-ended questions

/* 10. Analyze all the colleges in the state of Tennessee. Which college has had the most success in the major leagues. 
Use whatever metric for success you like - number of players, number of games, salaries, world series wins, etc.*/

SELECT Distinct(s.schoolid), 
max(s.schoolname), 
Max(s.schoolstate),
COUNT(t.wswin) AS world_series_wins
FROM schools AS s
JOIN collegeplaying AS c
USING(schoolid)
JOIN teams AS t
ON c.yearid = t.yearid
WHERE schoolstate = 'TN'
AND t.wswin = 'Y'
GROUP BY schoolid
ORDER BY COUNT(t.wswin) DESC;
-- UNIVERSITY OF TENNESSEE 87 WSWINS




SELECT *
FROM collegeplaying
limit 10;
select *
FROM teams
limit 10;

/* Is there any correlation between number of wins and team salary?.Use data from 2000 and later to answer this question. 
As you do this analysis, keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis.*/
SELECT DISTINCT(t.yearid),
COUNT(t.w) AS total_Wins,
SUM(s.salary) AS total_salary_per_year
FROM teams AS t
JOIN salaries AS s
USING (teamid)
WHERE t.yearid >=2000
GROUP BY t.yearid
ORDER BY total_wins DESC, total_salary_per_year DESC;

/*There  is no any correlation between number of wins and team salary. For Example 2000 had the highest wins and salary was 51,820,095,947
as compared to the least wins in 2016 and the salary was 53,062,200,283*/
 
---END ---

/* 12. In this question, you will explore the connection between number of wins and attendance.
i. Does there appear to be any correlation between attendance at home games and number of wins?*/

SELECT t.w,
h.attendance 
FROM teams AS t
JOIN homegames AS h
On t.yearid = h.year;

--NO correlation between home games and number of wins


/* ii. Do teams that win the world series see a boost in attendance the following year? What about teams that made the playoffs? 
Making the playoffs means either being a division winner or a wild card winner.*/
SELECT DISTINCT(t.yearid), 
MAX(t.wswin) AS world_series_win,
SUM(h.attendance) AS attendance
FROM teams AS t
JOIN homegames AS h
On t.yearid = h.year
WHERE wswin = 'Y'
GROUP BY t.yearid
ORDER BY t.yearid DESC;


SELECT DISTINCT(t.yearid), 
MAX(t.wswin) AS world_series_win,
SUM(h.attendance) AS attendance
FROM teams AS t
JOIN homegames AS h
On t.yearid = h.year
WHERE wswin = 'N'
GROUP BY t.yearid
ORDER BY t.yearid DESC;

SELECT *
FROM teams
limit 10;

/* 13. It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective. 
Investigate this claim and present evidence to either support or dispute this claim. First, determine just how rare left-handed pitchers are compared with right-handed pitchers. 
Are left-handed pitchers more likely to win the Cy Young Award? Are they more likely to make it into the hall of fame?*/
SELECT *
FROM people
limit 10;

SELECT
DISTINCT(COUNT(p.throws)) AS total_count,
CASE WHEN throws = 'L' THEN 'left_handed'
ELSE 'right_handed' END AS right_hand_pitcher
FROM people AS p
GROUP BY p.throws;

SELECT

(CASE WHEN COUNT(p.throws ='L') + COUNT(p.throws = 'R')  THEN COUNT(p.throws = 'L') + COUNT(p.throws = 'R')) AS total
WHEN  COUNT(p.throws = 'L') + COUNT(p.throws = 'R')/ COUNT(p.throws = 'L') THEN COUNT(p.throws = 'L') + COUNT(p.throws = 'R')/ COUNT(p.throws = 'L')AS percentage_left_handed
ELSE AS percentage_right_handed END 
FROM people AS p;
GROUP BY p.throws;


SELECT 
DISTINCT(COUNT(p.throws)) AS total_count,
p.throws
--CASE WHEN throws = 'L' THEN COUNT'(p.throws = 'L')' AS left_handed
--ELSE 'right_handed' END AS right_hand_pitcher
FROM people AS p
GROUP BY p.throws;





--EXTRA_personal
SELECT  

(CASE WHEN yearid >=1920 AND yearid <=1929 THEN '1920_1929'
	WHEN yearid >=1930 AND yearid <= 1939 THEN '1930_1939'
	WHEN yearid >=1940 AND yearid <= 1949 THEN '1940_1949'
	WHEN yearid >=1950 AND yearid <= 1959 THEN '1950_1959'
	WHEN yearid >=1960 AND yearid <= 1969 THEN '1960_1969'
	WHEN yearid >=1970 AND yearid <= 1979 THEN '1970_1979'
	WHEN yearid >=1980 AND yearid <= 1989 THEN '1980_1989'
	WHEN yearid >=1990 AND yearid <= 1999 THEN '1990_1999'
	WHEN yearid >=2000 AND yearid <= 2009 THEN '2000_2009'
	ELSE  '2010_2016' END) AS decades, 
	SUM(t.hr) AS total_homeruns 
	
FROM teams AS t
 GROUP BY (CASE WHEN yearid >=1920 and yearid <=1929 THEN '1920_1929'
	WHEN yearid >=1930 and yearid <= 1939 THEN '1930_1939'
	WHEN yearid >=1940 and yearid <= 1949 THEN '1940_1949'
	WHEN yearid >=1950 and yearid <= 1959 THEN '1950_1959'
	WHEN yearid >=1960 and yearid <= 1969 THEN '1960_1969'
	WHEN yearid >=1970 and yearid <= 1979 THEN '1970_1979'
	WHEN yearid >=1980 and yearid <= 1989 THEN '1980_1989'
	WHEN yearid >=1990 and yearid <= 1999 THEN '1990_1999'
	WHEN yearid >=2000 and yearid <= 2009 THEN '2000_2009'
	ELSE  '2010_2016' END)
	ORDER BY total_homeruns DESC;
	
	
	
	/* date      pay
	   jan 15    1500
	   feb 31 .  1400
	   
compare jan salary to salary 6 months in the future
do a len()
Do your join first
