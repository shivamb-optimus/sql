CREATE DATABASE Assignment_DB;

USE Assignment_DB;

CREATE TABLE Species
(SpeciesID int PRIMARY KEY,
CommonName varchar(50),
ScientificName varchar(50),
Habitat char(20),
Venomous bit);

CREATE TABLE Snakes
(SnakeID int PRIMARY KEY,
SpeciesID int FOREIGN KEY references Species(SpeciesID),
Lenth numeric(10, 2),
Age int,
Color char(15));

CREATE TABLE Sightings
(SightingID int PRIMARY KEY,
SnakeID int FOREIGN KEY references Snakes(SnakeID),
Location varchar(50),
SightingDate date,
Observer char(30));

CREATE TABLE ConservationStatus
(StatusID int PRIMARY KEY,
SpeciesID int FOREIGN KEY references Species(SpeciesID),
Status varchar(100),
LastUpdated date);

INSERT INTO Species values
(1, 'King Cobra', 'Ophiophagus hannah', 'Forest', 1),
(2, 'Corn Snake', 'Pantherophis guttatus', 'Grassland', 0),
(3, 'Rattlesnake', 'Crotalus atrox', 'Desert', 1),
(4, 'Python', 'Python bivittatus', 'Swamp', 0),
(5, 'Boa Constrictor', 'Boa constrictor', 'Rainforest', 0),
(6, 'Green Anaconda', 'Eunectes murinus', 'Swamp', 0);

INSERT INTO Snakes values
(1, 1, 3.5, 5, 'Brown'),
(2, 2, 1.2, 2, 'Orange'),
(3, 3, 2.0, 4, 'Gray'),
(4, 4, 4.8, 7, 'Green'),
(5, 1, 2.5, 3, 'Black'),
(6, 6, 5.0, 6, 'Dark Green'),
(7, 1, 4.0, 6, 'Brown'),
(8, 2, 1.5, 3, 'Orange'),
(9, 3, 2.2, 5, 'Gray'),
(10, 4, 5.2, 8, 'Green'),
(11, 5, 3.0, 4, 'Red'),
(12, 6, 6.0, 7, 'Dark Green'),
(13, 1, 4.5, 7, 'Brown'),
(14, 2, 1.8, 4, 'Orange'),
(15, 3, 2.5, 6, 'Gray'),
(16, 4, 5.5, 9, 'Green'),
(17, 5, 3.2, 5, 'Red'),
(18, 6, 6.5, 8, 'Dark Green'),
(19, 1, 4.8, 8, 'Brown'),
(20, 2, 2.0, 5, 'Orange'),
(21, 3, 2.8, 7, 'Gray'),
(22, 4, 6.0, 10, 'Green'),
(23, 5, 3.5, 6, 'Red'),
(24, 6, 7.0, 9, 'Dark Green');

INSERT INTO Sightings values
(1, 1, 'Amazon Rainforest', '2024-01-15', 'John Doe'),
(2, 2, 'Florida Everglades', '2024-02-20', 'Jane Smith'),
(3, 3, 'Arizona Desert', '2024-03-10', 'Alice Johnson'),
(4, 4, 'Congo Basin', '2024-04-05', 'Bob Brown'),
(5, 1, 'Indian Forest', '2024-05-12', 'Charlie Green'),
(6, 6, 'Amazon Rainforest', '2024-06-18', 'Eve White'),
(7, 7, 'Indian Forest', '2024-07-22', 'David Black'),
(8, 8, 'Florida Everglades', '2024-08-15', 'Jane Smith'),
(9, 9, 'Arizona Desert', '2024-09-10', 'Alice Johnson'),
(10, 10, 'Congo Basin', '2024-10-05', 'Bob Brown'),
(11, 11, 'Amazon Rainforest', '2024-11-12', 'Charlie Green'),
(12, 12, 'Amazon Rainforest', '2024-12-18', 'Eve White');

INSERT INTO ConservationStatus values
(1, 1, 'Vulnerable', '2024-01-01'),
(2, 2, 'Least Concern', '2024-01-01'),
(3, 3, 'Endangered', '2024-01-01'),
(4, 4, 'Near Threatened', '2024-01-01'),
(5, 1, 'Vulnerable', '2024-06-01'),
(6, 6, 'Least Concern', '2024-06-01');


Select * FROM Species;

Select * FROM Snakes;

Select * FROM Sightings;

Select * FROM ConservationStatus;



-- Query1

SELECT s1.*, s3.CommonName 
FROM Sightings s1
JOIN Snakes s2
ON s1.SnakeID = s2.SnakeID
JOIN Species s3
ON s2.SpeciesID = s3.SpeciesID
WHERE s3.CommonName = 'Russel Viper';


-- Query2

SELECT SpeciesID, AVG(Lenth) as avg_length
FROM Snakes 
GROUP BY SpeciesID;


--Query3

WITH Top_Snakes AS
(
SELECT SpeciesID, SnakeID, Lenth, RANK() OVER(Partition BY SpeciesID ORDER BY Lenth DESC) as Lenth_rank
FROM Snakes
)
SELECT SpeciesID, SnakeId, Lenth 
FROM Top_Snakes ts
WHERE Lenth_rank <= 5;



-- Query4

SELECT TOP 1 Observer, SpeciesID, COUNT(*) as Count_seen
FROM Sightings s1
JOIN Snakes s2
ON s1.SnakeID = s2.SnakeID
GROUP BY Observer, SpeciesID
ORDER BY Count_seen DESC;

-- Query5

CREATE TRIGGER UpdateDateOnTableUpdation
ON ConservationStatus
AFTER INSERT, UPDATE
AS
BEGIN
UPDATE ConservationStatus
SET LastUpdated = GETDATE() WHERE StatusID IN (SELECT StatusID FROM inserted);
END;

UPDATE ConservationStatus
SET Status = 'Threatened' WHERE StatusId = 6;

-- Query6

SELECT SpeciesMoreThan10.SpeciesID FROM 
(SELECT s2.SpeciesID
FROM Sightings s1
JOIN Snakes s2
ON s1.SnakeID = s2.SnakeID
GROUP BY s2.SpeciesID
HAVING COUNT(*) > 10 ) AS SpeciesMoreThan10
JOIN ConservationStatus c
ON SpeciesMoreThan10.SpeciesID = c.SpeciesID AND c.Status = 'Endangered';
