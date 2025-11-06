DROP DATABASE IF EXISTS sports_tracker;
CREATE DATABASE IF NOT EXISTS sports_tracker;
USE sports_tracker; 

DROP TABLE IF EXISTS sports;

CREATE TABLE IF NOT EXISTS sports(
    sport_id INT PRIMARY KEY,
    name VARCHAR (100),
    description TEXT,
    UNIQUE(name)
);

DROP TABLE IF EXISTS leagues;

CREATE TABLE IF NOT EXISTS leagues(
    league_id INT PRIMARY KEY,
    name VARCHAR (100),
    sport_id INT,
    description TEXT,
    FOREIGN KEY (sport_id) REFERENCES sports(sport_id),
    UNIQUE(name)
);

DROP TABLE IF EXISTS seasons;

CREATE TABLE IF NOT EXISTS seasons(
    season_id INT PRIMARY KEY,
    league_id INT,
    season_number INT UNSIGNED,
    FOREIGN KEY (league_id) REFERENCES leagues(league_id)
);

DROP TABLE IF EXISTS teams;

CREATE TABLE IF NOT EXISTS teams(
    team_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR (50),
    league_id INT,
    FOREIGN KEY (league_id) REFERENCES leagues(league_id),
    UNIQUE(name)
);

DROP TABLE IF EXISTS players;

CREATE TABLE IF NOT EXISTS players(
    player_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    UNIQUE(name)
);

DROP TABLE IF EXISTS player_teams;

CREATE TABLE IF NOT EXISTS player_teams(
    player_id INT,
    team_id INT,
    start_date DATE,
    end_date DATE,
    position VARCHAR(50),
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (team_id) REFERENCES teams(team_id),
    PRIMARY KEY(player_id, team_id)
);

DROP TABLE IF EXISTS locations;

CREATE TABLE IF NOT EXISTS locations(
    location_id INT PRIMARY KEY,
    name VARCHAR(250),
    city VARCHAR(100),
    UNIQUE(name)
);

DROP TABLE IF EXISTS matches;

CREATE TABLE IF NOT EXISTS matches(
    match_id INT PRIMARY KEY,
    season_id INT,
    match_date DATETIME,
    location_id INT,
    FOREIGN KEY (season_id) REFERENCES seasons(season_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

DROP TABLE IF EXISTS outcome_type;

CREATE TABLE IF NOT EXISTS outcome_type(
    outcome_type_id INT PRIMARY KEY,
    league_id INT,
    outcome_name VARCHAR(50),
    outcome_points INT,
    FOREIGN KEY (league_id) REFERENCES leagues(league_id)
);

DROP TABLE IF EXISTS match_teams;

CREATE TABLE IF NOT EXISTS match_teams(
    match_id INT,
    team_id INT,
    outcome_type_id INT,
    PRIMARY KEY(match_id, team_id),
    FOREIGN KEY (match_id) REFERENCES matches(match_id),
    FOREIGN KEY (team_id) REFERENCES teams(team_id),
    FOREIGN KEY (outcome_type_id) REFERENCES outcome_type(outcome_type_id)
);

DROP TABLE IF EXISTS events;

CREATE TABLE IF NOT EXISTS events(
    event_id INT PRIMARY KEY,
    event_name VARCHAR(100),
    UNIQUE(event_name)
);

DROP TABLE IF EXISTS player_match_stats;

CREATE TABLE IF NOT EXISTS player_match_stats(
    player_match_stats_id INT PRIMARY KEY,
    player_id INT,
    match_id INT,
    time DATETIME,
    event_id INT,
    value DECIMAL(5,2),
    FOREIGN KEY (match_id) REFERENCES matches(match_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (event_id) REFERENCES events(event_id)
);

INSERT INTO sports (sport_id, name, description)
VALUES
(1, 'Hockey', 'A team sport played on ice where players use sticks to direct a puck into the opposing goal.'),
(2, 'Soccer', 'A team sport played on a field where players aim to score goals by kicking a ball into the opponent’s net.'),
(3, 'Fortnite', 'A competitive video game league tracking team-based matches and performance outcomes.'),
(4, 'Baseball', 'A bat-and-ball game played between two teams who take turns batting and fielding.'),
(5, 'Basketball', 'A team sport where two teams try to score points by throwing a ball through the opposing hoop.');

INSERT INTO leagues (league_id, name, sport_id, description)
VALUES
(1, 'NHL', 1, 'National Hockey League'),
(2, 'FIFA World League', 2, 'Global soccer competition under FIFA regulations'),
(3, 'Fortnite NA League', 3, 'North American regional Fortnite competition'),
(4, 'MLB', 4, 'Major League Baseball'),
(5, 'NBA', 5, 'National Basketball Association');

INSERT INTO seasons (season_id, league_id, season_number)
VALUES
(1, 1, 2024),
(2, 2, 2024),
(3, 3, 2024),
(4, 4, 2024),
(5, 5, 2024),
(6, 3, 2025);

INSERT INTO teams (team_id, name, city, league_id)
VALUES
(1, 'Toronto Blades', 'Toronto', 1),
(2, 'Vancouver Wolves', 'Vancouver', 1),
(3, 'Madrid Eagles', 'Madrid', 2),
(4, 'Buenos Aires Lions', 'Buenos Aires', 2),
(5, 'Team Omega', 'New York', 3),
(6, 'Team Nova', 'Los Angeles', 3),
(7, 'Chicago Bats', 'Chicago', 4),
(8, 'New York Rockets', 'New York', 4),
(9, 'Chicago Bulls', 'Chicago', 5),
(10, 'Los Angeles Flames', 'Los Angeles', 5);

INSERT INTO players (player_id, name, age)
VALUES
(1, 'Wayne Gretzky', 63),
(2, 'Sidney Crosby', 37),
(3, 'Lionel Messi', 37),
(4, 'Cristiano Ronaldo', 40),
(5, 'Ninja', 33),
(6, 'Tfue', 31),
(7, 'Babe Ruth', 129),
(8, 'Shohei Ohtani', 30),
(9, 'Michael Jordan', 62),
(10, 'LeBron James', 40),
(11, 'Alex Benchwarmer', 22);

INSERT INTO player_teams (player_id, team_id, start_date, end_date, position)
VALUES
(1, 1, '2023-01-01', NULL, 'Center'),
(2, 2, '2022-09-01', NULL, 'Forward'),
(3, 3, '2023-02-15', NULL, 'Forward'),
(4, 4, '2022-08-10', NULL, 'Striker'),
(5, 5, '2023-01-10', NULL, 'Shooter'),
(6, 6, '2023-01-10', NULL, 'Builder'),
(7, 7, '2022-04-01', '2024-03-30', 'Pitcher'),
(8, 8, '2024-04-01', NULL, 'Designated Hitter'),
(9, 9, '2023-09-01', NULL, 'Shooting Guard'),
(10, 10, '2022-10-01', NULL, 'Forward'),
(9, 7, '1994-01-01', '1995-12-31', 'Outfielder');

INSERT INTO locations (location_id, name, city)
VALUES
(1, 'Toronto Ice Arena', 'Toronto'),
(2, 'Vancouver Skydome', 'Vancouver'),
(3, 'Madrid National Stadium', 'Madrid'),
(4, 'Buenos Aires Arena', 'Buenos Aires'),
(5, 'Fortnite Virtual Island', 'Online'),
(6, 'Chicago Ballpark', 'Chicago'),
(7, 'New York Grand Park', 'New York'),
(8, 'United Center', 'Chicago'),
(9, 'LA Sports Complex', 'Los Angeles');

INSERT INTO matches (match_id, season_id, match_date, location_id)
VALUES
(1, 1, '2024-03-15 19:00:00', 1),
(2, 1, '2024-04-20 19:00:00', 2),
(3, 2, '2024-05-10 20:00:00', 3),
(4, 2, '2024-06-02 18:00:00', 4),
(5, 3, '2024-07-01 17:00:00', 5),
(6, 3, '2024-08-01 17:00:00', 5),
(7, 4, '2024-04-15 19:00:00', 6),
(8, 4, '2024-05-05 19:00:00', 7),
(9, 5, '2024-03-10 19:00:00', 8),
(10, 5, '2024-04-20 19:00:00', 9),
(11, 6, '2025-08-05 17:00:00', 5),
(12, 6, '2025-08-20 17:00:00', 5),
(13, 6, '2025-09-10 17:00:00', 5),
(14, 6, '2025-09-25 17:00:00', 5),
(15, 6, '2025-10-10 17:00:00', 5),
(16, 1, '2024-11-10 19:00:00', 1),
(17, 1, '2025-01-15 19:00:00', 2),
(18, 1, '2025-03-10 19:00:00', 1),
(19, 1, '2025-05-20 19:00:00', 2),
(20, 1, '2025-07-25 19:00:00', 1),
(21, 6, '2025-10-23 17:00:00', 5);

INSERT INTO outcome_type (outcome_type_id, league_id, outcome_name, outcome_points)
VALUES
(1, 1, 'Win', 2),
(2, 1, 'OT Loss', 1),
(3, 1, 'Loss', 0),
(4, 2, 'Win', 3),
(5, 2, 'Draw', 1),
(6, 2, 'Loss', 0),
(7, 3, '1st', 15),
(8, 3, '2nd', 12),
(9, 3, '3rd', 10),
(10, 3, '4th', 8),
(11, 3, '5th', 7),
(12, 3, '6th', 6),
(13, 3, '7th', 5),
(14, 3, '8th', 4),
(15, 3, '9th', 3),
(16, 3, '10th', 2),
(17, 3, '11th', 1),
(18, 3, '12th+', 0),
(19, 4, 'Win', 2),
(20, 4, 'Loss', 0),
(21, 5, 'Win', 2),
(22, 5, 'Loss', 0);

INSERT INTO match_teams (match_id, team_id, outcome_type_id)
VALUES
(1, 1, 1),
(1, 2, 3),
(2, 1, 2),
(2, 2, 1),
(3, 3, 4),
(3, 4, 6),
(4, 3, 5),
(4, 4, 5),
(5, 5, 7),
(5, 6, 8),
(6, 5, 9),
(6, 6, 11),
(7, 7, 19),
(7, 8, 20),
(8, 7, 20),
(8, 8, 19),
(9, 9, 21),
(9, 10, 22),
(10, 9, 22),
(10, 10, 21),
(11, 5, 7),
(11, 6, 8),
(12, 5, 9),
(12, 6, 10),
(13, 5, 11),
(13, 6, 12),
(14, 5, 13),
(14, 6, 14),
(15, 5, 15),
(15, 6, 16),
(16, 1, 1),
(16, 2, 3),
(17, 1, 2),
(17, 2, 1),
(18, 1, 1),
(18, 2, 3),
(19, 1, 1),
(19, 2, 3),
(20, 1, 1),
(20, 2, 3),
(21, 5, 18),
(21, 6, 11);

INSERT INTO events (event_id, event_name)
VALUES
(1, 'Goal'),
(2, 'Assist'),
(3, 'Penalty'),
(4, 'Kill'),
(5, 'Accuracy'),
(6, 'TimeAlive'),
(7, 'HomeRun'),
(8, 'Strike'),
(9, 'Rebound'),
(10, '3Pointer'),
(11, 'FreeThrow');

INSERT INTO player_match_stats (player_match_stats_id, player_id, match_id, event_id, value)
VALUES
(1, 1, 1, 1, 1),
(2, 1, 1, 2, 1),
(3, 2, 1, 1, 1),
(4, 2, 2, 1, 1),
(5, 2, 2, 2, 1),
(6, 3, 3, 1, 1),
(7, 3, 3, 2, 1),
(8, 4, 4, 1, 1),
(9, 5, 5, 4, 5),
(10, 5, 5, 5, 89.50),
(11, 5, 5, 6, 97.80),
(12, 6, 5, 4, 3),
(13, 6, 5, 5, 92.10),
(14, 6, 5, 6, 100.50),
(15, 6, 6, 4, 7),
(16, 6, 6, 5, 88.00),
(17, 6, 6, 6, 95.70),
(18, 7, 7, 7, 1),
(19, 8, 8, 7, 1),
(20, 9, 7, 8, 1),
(21, 9, 9, 10, 2),
(22, 9, 9, 11, 5),
(23, 10, 9, 9, 10),
(24, 10, 10, 10, 3),
(25, 10, 10, 11, 4),
(56, 1, 16, 1, 1),
(57, 1, 16, 2, 2),
(58, 1, 17, 1, 1),
(59, 1, 17, 2, 1),
(60, 1, 18, 2, 1),
(61, 2, 16, 1, 1),
(62, 2, 17, 2, 1),
(63, 2, 18, 2, 1),
(64, 2, 19, 1, 1),
(65, 2, 20, 2, 1),
(66, 3, 3, 1, 2),
(67, 3, 4, 2, 1),
(68, 4, 3, 1, 1),
(69, 4, 4, 1, 1),
(70, 5, 11, 4, 6),
(71, 5, 11, 5, 90.20),
(72, 5, 11, 6, 99.50),
(73, 6, 11, 4, 4),
(74, 6, 11, 5, 87.10),
(75, 6, 11, 6, 95.40),
(76, 5, 12, 4, 5),
(77, 5, 12, 5, 91.00),
(78, 5, 12, 6, 98.70),
(79, 6, 12, 4, 6),
(80, 6, 12, 5, 89.40),
(81, 6, 12, 6, 97.90),
(82, 5, 13, 4, 4),
(83, 5, 13, 5, 92.10),
(84, 5, 13, 6, 97.80),
(85, 6, 13, 4, 7),
(86, 6, 13, 5, 93.20),
(87, 6, 13, 6, 99.30),
(88, 5, 14, 4, 3),
(89, 5, 14, 5, 85.40),
(90, 5, 14, 6, 94.20),
(91, 6, 14, 4, 8),
(92, 6, 14, 5, 90.30),
(93, 6, 14, 6, 96.00),
(94, 5, 15, 4, 2),
(95, 5, 15, 5, 82.90),
(96, 5, 15, 6, 93.10),
(97, 6, 15, 4, 9),
(98, 6, 15, 5, 94.80),
(99, 6, 15, 6, 97.70),
(100, 5, 21, 4, 4),
(101, 5, 21, 5, 88.60),
(102, 5, 21, 6, 98.40),
(103, 6, 21, 4, 5),
(104, 6, 21, 5, 91.00),
(105, 6, 21, 6, 95.20); 
