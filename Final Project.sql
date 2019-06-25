--Create my database tables
CREATE TABLE offensiveStats (
	offensiveStatsID int identity
	, tdReceptions int
	, tdRuns int
	, tdThrows int
	, totalYardsRushing int
	, totalYardsReceiving int
	, receptions int
	, rushingAttempts int
	, intThrown int
	, fumbles int
	, pancakes int
	, sacksSurrendered int
	, passingAttempts int
	CONSTRAINT PK_offensiveStats PRIMARY KEY (offensiveStatsID)
)

CREATE TABLE defensiveStats (
	defensiveStatsID int identity
	, sacks int
	, interceptions int
	, defensiveTD int
	, fumblesCaused int
	, tacklesForLoss int
	, passesDefended int
	, yardsAllowed int
	CONSTRAINT PK_defensiveStats PRIMARY KEY (defensiveStatsID)
)


CREATE TABLE stats (
	statsID int identity
	, offensiveStatsID int
	, defensiveStatsID int
	, CONSTRAINT PK1_stats PRIMARY KEY (statsID)
	, CONSTRAINT FK1_stats FOREIGN KEY (offensiveStatsID) REFERENCES offensiveStats(offensiveStatsID)
	, CONSTRAINT FK2_stats FOREIGN KEY (defensiveStatsID) REFERENCES defensiveStats(defensiveStatsID)
)


CREATE TABLE competition (
	competitionID int identity
	, schoolVisit varchar(20)
	, offer varchar(20)
	, otherSchool int
	, CONSTRAINT PK_competition PRIMARY KEY (competitionID)
)


CREATE TABLE otherSchool (
	otherSchool int identity
	, otherSchoolName varchar(40)
	, competitionID int
	, CONSTRAINT PK_otherSchool PRIMARY KEY (otherSchool)
	, CONSTRAINT FK_otherSchool FOREIGN KEY (competitionID) REFERENCES competition(competitionID)
)


CREATE TABLE ranking (
	rankingID int identity
	, overallRanking char(4) not null
	, positionRanking char(4) not null
	, stateRanking char(4) not null
	, CONSTRAINT PK_ranking PRIMARY KEY (rankingID)
)


CREATE TABLE academicYear (
	academicYearID int identity
	, academicYear varchar(30) not null
	, academicYearIndex int
	, CONSTRAINT PK_academicYear PRIMARY KEY (academicYearID)
)


CREATE TABLE school (
	schoolID int identity
	, schoolName varchar(40) not null
	, city varchar(30) not null
	, state varchar(30) not null
	, academicYearID int 
	, CONSTRAINT PK_school PRIMARY KEY (schoolID)
	, CONSTRAINT FK1_school FOREIGN KEY (academicYearID) REFERENCES academicYear(academicYearID)
)


CREATE TABLE position (
	positionID int identity
	, position varchar(30)
	, CONSTRAINT PK_position PRIMARY KEY (positionID) 
)


CREATE TABLE player (
	playerID int identity
	, name varchar(30)
	, height int
	, weight int
	, birthDate datetime
	, grade decimal(3,2)
	, schoolID int
	, positionID int
	, rankingID int
	, competitionID int
	, statsID int
	, CONSTRAINT PK_player PRIMARY KEY (playerID)
	, CONSTRAINT FK1_player FOREIGN KEY (schoolID) REFERENCES school(schoolID)
	, CONSTRAINT FK2_player FOREIGN KEY (positionID) REFERENCES position(positionID)
	, CONSTRAINT FK3_player FOREIGN KEY (rankingID) REFERENCES ranking(rankingID)
	, CONSTRAINT FK4_player FOREIGN KEY (competitionID) REFERENCES competition(competitionID)
	, CONSTRAINT FK5_player FOREIGN KEY (statsID) REFERENCES stats(statsID)
)


--After more consideration, i've decided to drop the competition and other school table.
--Regardless of the other schools, we'll still make offers to players we like.

ALTER TABLE player DROP CONSTRAINT FK4_player
ALTER TABLE otherSchool DROP CONSTRAINT FK_otherSchool

ALTER TABLE player DROP COLUMN competitionID

DROP TABLE competition;
DROP TABLE otherSchool;


--Start adding info to tables
INSERT INTO player(name,height,weight,birthDate,grade) 
	VALUES
		('Sal Vulcano',76,270,'05/24/2002',3.4),
		('Joe Gatto',70,230,'06/19/2003',2.8),
		('Brian Quinn',73,210,'11/04/2002',3.1),
		('James Murray',75,185,'02/28/2002',2.9),
		('Dandy Chiggins',77,280,'04/19/2002',3.0)

SELECT * FROM player

--The birth date was not set correctly. Created UPDATE statement to correct.
UPDATE player
	SET	birthDate = '2002-05-24'
	WHERE playerID = 1
		
UPDATE player
	SET	birthDate = '2003-06-19'
	WHERE playerID = 2

UPDATE player
	SET	birthDate = '2002-11-04'
	WHERE playerID = 3

UPDATE player
	SET	birthDate = '2002-02-28'
	WHERE playerID = 4

UPDATE player
	SET	birthDate = '2002-04-19'
	WHERE playerID = 5

--Insert positions into the position table
INSERT INTO position (position)
	VALUES
	('Left Tackle'),
	('Linebacker'),
	('Quarterback'),
	('Wide Receiver'),
	('Defensive End')

SELECT * FROM position

--Update position ID in player table
UPDATE player
	SET	positionID = 1
	WHERE playerID = 1

UPDATE player
	SET	positionID = 2
	WHERE playerID = 2

UPDATE player
	SET	positionID = 3
	WHERE playerID = 3

UPDATE player
	SET	positionID = 4
	WHERE playerID = 4

UPDATE player
	SET	positionID = 5
	WHERE playerID = 5

--Check changes
SELECT * FROM player
JOIN position ON player.positionID = position.positionID

--Create school names
INSERT INTO school(schoolName,city,state)
	VALUES
	('Staten Island HS','Staten Island','NY'),
	('Miami Central HS','Miami','FL'),
	('Bishop Gorman HS','Las Vegas','NV'),
	('St. Thomas Aquinas HS','Ft Lauderdale','FL'),
	('John Bosco','Los Angeles','CA')

SELECT * FROM school

--Update school ID in player table
UPDATE player
	SET	schoolID = 1
	WHERE playerID = 1

UPDATE player
	SET	schoolID = 2
	WHERE playerID = 2

UPDATE player
	SET	schoolID = 3
	WHERE playerID = 3

UPDATE player
	SET	schoolID = 4
	WHERE playerID = 4

UPDATE player
	SET	schoolID = 5
	WHERE playerID = 5

--Check changes
SELECT * FROM player
JOIN school ON player.schoolID = school.schoolID


--Create rankings
INSERT INTO ranking(overallRanking,positionRanking,stateRanking)
	VALUES
	('33','3','1'),
	('76','5','2'),
	('120','7','5'),
	('23','1','1'),
	('47','12','4')

SELECT * FROM ranking


--Update ranking ID in player table
UPDATE player
	SET	rankingID = 1
	WHERE playerID = 1

UPDATE player
	SET	rankingID = 2
	WHERE playerID = 2

UPDATE player
	SET	rankingID = 3
	WHERE playerID = 3

UPDATE player
	SET	rankingID = 4
	WHERE playerID = 4

UPDATE player
	SET	rankingID = 5
	WHERE playerID = 5

SELECT * FROM player
JOIN ranking ON player.rankingID = ranking.rankingID

--Populate stats tables
INSERT INTO offensiveStats(pancakes,sacksSurrendered)
	VALUES
	(24,3)

INSERT INTO defensiveStats(sacks,interceptions,fumblesCaused,tacklesForLoss)
	VALUES
	(21,3,4,12)

INSERT INTO offensiveStats(tdRuns,tdThrows,intThrown,passingAttempts)
	VALUES
	(12,45,4,189)

INSERT INTO offensiveStats(tdReceptions,tdRuns,totalYardsReceiving,receptions,fumbles)
	VALUES
	(24,2,1257,59,2)

INSERT INTO defensiveStats(sacks,defensiveTD,tacklesForLoss)
	VALUES
	(15,4,17)

select * from offensiveStats
select * from defensiveStats

--On second thought, having 2 tables for stats seems to be overkill.
--Consolidating into 1 stats table and deleting other 2.
ALTER TABLE stats DROP CONSTRAINT FK1_stats
ALTER TABLE stats DROP CONSTRAINT FK2_stats

DROP TABLE offensiveStats;
DROP TABLE defensiveStats;

ALTER TABLE stats DROP COLUMN offensiveStatsID
ALTER TABLE stats DROP COLUMN defensiveStatsID

--Add columns to stats table
ALTER TABLE stats
	ADD
	tdReceptions int
	, tdRuns int
	, tdThrows int
	, totalYardsRushing int
	, totalYardsReceiving int
	, receptions int
	, rushingAttempts int
	, intThrown int
	, fumbles int
	, pancakes int
	, sacksSurrendered int
	, passingAttempts int
	, sacks int
	, interceptions int
	, defensiveTD int
	, fumblesCaused int
	, tacklesForLoss int
	, passesDefended int
	, yardsAllowed int

--Enter stats again
INSERT INTO stats(pancakes,sacksSurrendered)
	VALUES
	(24,3)

INSERT INTO stats(sacks,interceptions,fumblesCaused,tacklesForLoss)
	VALUES
	(21,3,4,12)

INSERT INTO stats(tdRuns,tdThrows,intThrown,passingAttempts)
	VALUES
	(12,45,4,189)

INSERT INTO stats(tdReceptions,tdRuns,totalYardsReceiving,receptions,fumbles)
	VALUES
	(24,2,1257,59,2)

INSERT INTO stats(sacks,defensiveTD,tacklesForLoss)
	VALUES
	(15,4,17)

SELECT * FROM stats

--Update stats ID in player table
UPDATE player
	SET	statsID = 1
	WHERE playerID = 1

UPDATE player
	SET	statsID = 2
	WHERE playerID = 2

UPDATE player
	SET	statsID = 3
	WHERE playerID = 3

UPDATE player
	SET	statsID = 4
	WHERE playerID = 4

UPDATE player
	SET	statsID = 5
	WHERE playerID = 5

--Verify stats
SELECT * FROM player
JOIN stats ON player.statsID = stats.statsID

--Create query to see which players have over 10 td runs or 10 td receptions
SELECT
	player.name
	, player.height
	, player.weight
	, player.birthDate
	, player.grade
	, position.position
	, school.schoolName
	, stats.tdReceptions
	, stats.tdRuns
	, ranking.overallRanking
FROM
	player
	JOIN position ON position.positionID = player.positionID
	JOIN school ON school.schoolID = player.schoolID
	JOIN stats ON stats.statsID = player.statsID
	JOIN ranking ON ranking.rankingID = player.rankingID
WHERE
	stats.tdReceptions > 10
	OR stats.tdRuns > 10


--Create query to see which players are ranked top 5 in their state
SELECT
	player.name
	, player.height
	, player.weight
	, position.position
	, school.schoolName
	, ranking.positionRanking
	, school.state
FROM
	player
	JOIN position ON position.positionID = player.positionID
	JOIN school ON school.schoolID = player.schoolID
	JOIN stats ON stats.statsID = player.statsID
	JOIN ranking ON ranking.rankingID = player.rankingID
WHERE
	ranking.positionRanking <= 10


--Create query to see which players have a GPA greater than 3
SELECT
	player.name
	, player.grade
	, position.position
	, school.schoolName
	, school.state
FROM
	player
	JOIN position ON position.positionID = player.positionID
	JOIN school ON school.schoolID = player.schoolID
WHERE
	player.grade >= 3


--View QB's
SELECT
	player.name
	, player.height
	, player.weight
	, player.birthDate
	, player.grade
	, position.position
	, school.schoolName
	, school.city
	, school.state
	, stats.tdThrows
	, stats.tdRuns
	, stats.intThrown
FROM
	player
	JOIN position ON position.positionID = player.positionID
	JOIN school ON school.schoolID = player.schoolID
	JOIN stats ON stats.statsID = player.statsID
WHERE
	position.position = 'Quarterback'

--Look at defensive studs
SELECT
	player.name
	, player.height
	, player.weight
	, player.birthDate
	, player.grade
	, position.position
	, school.schoolName
	, school.city
	, school.state
	, stats.sacks
	, stats.tacklesForLoss
FROM
	player
	JOIN position ON position.positionID = player.positionID
	JOIN school ON school.schoolID = player.schoolID
	JOIN stats ON stats.statsID = player.statsID
WHERE
	stats.sacks >= 10
	AND stats.tacklesForLoss >= 10