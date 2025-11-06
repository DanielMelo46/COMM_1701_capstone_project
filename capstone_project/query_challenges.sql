SELECT * 
FROM teams AS t
JOIN match_teams as mt ON t.team_id = mt.team_id
JOIN matches AS m ON mt.match_id = m.match_id
WHERE m.match_date > '2024-08-31' - INTERVAL 3 MONTH;