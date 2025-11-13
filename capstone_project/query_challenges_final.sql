-- Active: 1756406076235@@127.0.0.1@3306@sports_tracker
-- # 1

-- Hockey tracks player goals and assists. List the top 5 players by 
-- their sum of goals and assists from matches played in the last 12 months.
SELECT p.name, COUNT(pm.event_id) AS Goals_and_Assists
FROM players p 
JOIN player_match_stats pm 
ON p.player_id = pm.player_id
JOIN matches m
ON m.match_id = pm.match_id
JOIN seasons sns ON sns.season_id = m.season_id
JOIN leagues l ON l.league_id = sns.league_id
JOIN sports s ON s.sport_id = l.sport_id
WHERE s.sport_id = (
    SELECT sport_id
    FROM sports
    WHERE name = "Hockey"
)
AND pm.event_id IN (
    SELECT event_id FROM events
    WHERE event_name = "Goal" OR event_name = "Assist"
)
AND 
m.match_date > "2024-11-06 00:00:00" -- Simulated date 
GROUP BY p.name
ORDER BY Goals_and_Assists DESC
LIMIT 5;

-- # 2
-- From among all hockey players with at least 5 games played, 
-- who had the highest average number of assists per game?

SELECT p.name, COUNT(e.event_id) / 
               NULLIF(COUNT(DISTINCT(m.match_id)),0)
     AS avg_assists_per_game
FROM players p
JOIN player_match_stats pm ON pm.player_id = p.player_id
JOIN events e ON pm.event_id = e.event_id
JOIN matches m ON m.match_id = pm.match_id
JOIN seasons sns ON sns.season_id = m.season_id
JOIN leagues l ON l.league_id = sns.league_id
JOIN sports s ON s.sport_id = l.sport_id
WHERE 
    e.event_name = 'Assist'
    AND s.name = 'Hockey' 
GROUP BY p.name
HAVING COUNT(DISTINCT(m.match_id)) > 4
ORDER BY avg_assists_per_game DESC
LIMIT 1;

-- #3

-- There is a Fortnite (video game) league where match outcomes are 15-12-10-8-7-6-5-4-3-2-1
--  points for 1st through 11th place, respectively (and 12th to last getting zero), in their 
-- 20-team matches. List all the teams by overall performance in the last three months.

SELECT t.team_id , t.name AS team_name , SUM(ot.outcome_points) AS total_points
FROM sports AS s
JOIN leagues AS l ON s.sport_id = l.sport_id
JOIN teams AS t ON l.league_id = t.league_id
JOIN match_teams as mt ON t.team_id = mt.team_id
JOIN matches AS m ON mt.match_id = m.match_id
JOIN outcome_type AS ot ON mt.outcome_type_id = ot.outcome_type_id

WHERE 
     s.name = 'Fortnite'    
AND
    m.match_date > CURDATE() - INTERVAL 3 MONTH
GROUP BY 
    t.name, team_id
ORDER BY
    total_points DESC
;

-- #  4
-- Fortnite tracks player shooting accuracy (as a percentage), kills, and
-- time spent alive in each match. For each match played, list the average
--  time spent alive for each team that got 0 match points.
SELECT mt.match_id, t.name AS team_name, ot.outcome_points AS total_points,
    AVG(pms.`value`) AS avg_time_alive
FROM matches AS m
JOIN match_teams AS mt ON m.match_id = mt.match_id
JOIN teams AS t ON mt.team_id = t.team_id
JOIN outcome_type AS ot ON mt.outcome_type_id = ot.outcome_type_id
JOIN leagues AS l ON t.league_id = l.league_id
JOIN sports AS s ON l.sport_id = s.sport_id
JOIN player_match_stats AS pms ON pms.match_id = m.match_id
JOIN events AS e ON pms.event_id = e.event_id
JOIN player_teams AS pt 
  ON pt.player_id = pms.player_id 
  AND pt.team_id = t.team_id
WHERE 
    s.name = 'Fortnite'
    AND ot.outcome_points = 0
    AND e.event_name = 'TimeAlive'
GROUP BY
    mt.match_id , t.name
;
-- # 5
-- Order all the players by number of sports played, then by number of times they’ve changed teams.
SELECT 
    p.name,
    COUNT(s.name) as number_sports_played, 
    COUNT(pt.team_id)-1 AS number_of_changes -- Number of teams the player 
                                             -- belonged to -1 to count changes.
FROM players p
JOIN player_teams pt ON p.player_id = pt.player_id
JOIN teams t ON pt.team_id = t.team_id
JOIN leagues l ON t.league_id = l.league_id
JOIN sports s ON l.sport_id = s.sport_id
GROUP BY p.name
ORDER BY number_sports_played DESC,
         number_of_changes DESC
;

-- # 6
-- Which soccer team had the highest score differential (goals scored minus goals conceded) in a given season?
SELECT t.name, SUM((scorer.team_id = t.team_id)) -
        SUM((scorer.team_id != t.team_id)) AS score_diff
FROM matches m
JOIN seasons sns ON m.season_id = sns.season_id
JOIN match_teams mt ON m.match_id = mt.match_id
JOIN teams t ON mt.team_id = t.team_id
JOIN leagues l ON t.league_id = l.league_id
JOIN sports s ON l.sport_id = s.sport_id
JOIN player_match_stats pms ON pms.match_id = m.match_id
JOIN events e ON pms.event_id = e.event_id
JOIN player_teams AS scorer ON scorer.player_id = pms.player_id
WHERE 
    s.name = 'Soccer'
    AND e.event_name = 'Goal'
    AND sns.season_number = 2024 -- Given season
    AND m.match_date BETWEEN scorer.start_date 
        AND COALESCE(scorer.end_date, m.match_date) -- Making sure the player 
                                                    -- played for the team when
                                                    -- the match took place.
GROUP BY t.team_id
;


-- # 7 
-- Show all players who have never played in a match.

SELECT p.name AS 'Player Name'
FROM players p 
LEFT JOIN player_match_stats pm ON p.player_id = pm.player_id
WHERE match_id IS NULL;

-- # 8
-- Which team has played the most matches?

SELECT t.name AS 'Team Name', COUNT(mt.match_id) AS 'Matches Played'
FROM teams t
INNER JOIN match_teams mt ON t.team_id = mt.team_id
GROUP BY t.name
ORDER BY COUNT(mt.match_id) DESC
LIMIT 1;

-- # 9 
-- Challenge: Who is the player with the greatest number of matches played with a
--  single team (or all the players, in the case of a tie)?

-- Description:
-- This finds the players with the most matches played for a single team 
-- Uses a subquery to calculate the maximum number of matches any player has with
-- any team 
-- The HAVING clause filters only those player-team pairs that match this maximum
-- COALESCE makes sure current players with no end date are still included
SELECT p.name, t.name, COUNT(m.match_id) AS number_of_matches
FROM players p
JOIN player_teams pt ON p.player_id = pt.player_id
JOIN teams t ON pt.team_id = t.team_id              
JOIN match_teams mt ON t.team_id = mt.team_id
JOIN matches m ON mt.match_id = m.match_id
WHERE m.match_date BETWEEN pt.start_date 
    AND COALESCE(pt.end_date, m.match_date) -- Making sure the player 
                                            -- played for the team when
                                            -- the match took place.
GROUP BY p.player_id, t.team_id
HAVING COUNT(m.match_id) = ( -- Comparing to find max with a sub query
    SELECT MAX(match_count)
    FROM (
        SELECT COUNT(m2.match_id) AS match_count
        FROM players p2
        JOIN player_teams pt2 ON p2.player_id = pt2.player_id
        JOIN teams t2 ON pt2.team_id = t2.team_id
        JOIN match_teams mt2 ON t2.team_id = mt2.team_id
        JOIN matches m2 ON mt2.match_id = m2.match_id
        WHERE m2.match_date BETWEEN pt2.start_date 
              AND COALESCE(pt2.end_date, m2.match_date)
        GROUP BY p2.player_id, t2.team_id
    ) AS counts
);

-- # 10
-- Query: For each team that the player “Michael Jordan” has played 
-- on, list their win percentage from games that occurred while he 
-- was on their team. (Assume he only plays in sports where match 
-- outcomes are limited to “win” and “loss”.)
-- Solution: 
-- Finds the win percentage for each team Michael Jordan played on
-- USES NULLIF to handle the case in which for some reason, MJ
-- has no matches as a total (likely impossible due to filters
-- but still there).
-- ORDER BY the win_percentage in a DESC order.
-- GROUP BY team id as we are looking into teams.
SELECT t.name, p.name, (SUM(ot.outcome_name = 'Win') /
                        NULLIF(COUNT(m.match_id), 0)) * 100 as win_percentage
FROM players p
JOIN player_teams pt ON p.player_id = pt.player_id
JOIN match_teams mt ON pt.team_id = mt.team_id
JOIN matches m ON mt.match_id = m.match_id
JOIN outcome_type ot ON mt.outcome_type_id = ot.outcome_type_id
JOIN teams t ON pt.team_id = t.team_id
WHERE p.name = 'Michael Jordan'
AND m.match_date BETWEEN pt.start_date 
    AND COALESCE(pt.end_date, m.match_date) -- Making sure the player 
                                            -- played for the team when
                                            -- the match took place.
AND ot.outcome_name IN ('Win', 'Loss')
GROUP BY t.team_id
ORDER BY win_percentage DESC;
;

