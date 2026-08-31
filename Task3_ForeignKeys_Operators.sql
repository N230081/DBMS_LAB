USE PlayStoreDB;
-- LEVEL 0
-- 1
ALTER TABLE Apps
ADD CONSTRAINT fk_developer
FOREIGN KEY(DeveloperID)
REFERENCES 
Developers(DeveloperID);
-- 2
ALTER TABLE Apps
ADD CONSTRAINT fk_publisher
FOREIGN KEY (PublisherID)
REFERENCES
Publishers(PublisherID) ;
-- 3
ALTER TABLE Apps
ADD CONSTRAINT fk_category
FOREIGN KEY (CategoryID)
REFERENCES
Categories(CategoryID);
-- 4
SELECT * 
FROM Apps
WHERE Rating > 4.5;
-- 5
SELECT *
FROM Apps
WHERE Price=0;
-- 6
SELECT * 
FROM Apps
WHERE CategoryID=305;

-- LEVEL 1
-- 1
SELECT * FROM Apps
WHERE Downloads > 500000000;
-- 2
SELECT *
FROM Apps
WHERE Rating BETWEEN 4.3 AND 4.7; 
-- 3
SELECT * 
FROM Apps
WHERE Price IN(0,299);
-- 4
SELECT *
FROM Apps
WHERE AppName LIKE 'G%';
-- 5
SELECT *
FROM Apps
WHERE AppName LIKE '%GOOGLE%';
-- 6
SELECT *
FROM Apps
WHERE Rating>4.0
AND Downloads > 500000000;
-- 7
SELECT *
FROM Apps
WHERE CategoryID=301
OR CategoryID=305;

-- LEVEL 2
-- 1
SELECT *
FROM Apps
WHERE AppName NOT LIKE 'G%';
-- 2
SELECT * 
FROM APPS
WHERE RATING < 4.5
OR Downloads > 1000000000;
-- 3
SELECT *
FROM Developers
WHERE DeveloperName LIKE '%a%';
-- 4
SELECT *
FROM Apps
WHERE Price BETWEEN 0 AND 300;
-- 5
SELECT *
FROM Apps
WHERE PublisherID IN (201,204);
-- 6
INSERT INTO Apps
VALUES (1012,'Test App',999,201,301,4.0,100000,0); 
-- 7
SELECT *
FROM Apps
WHERE CategoryID <> 305;



