USE PlayStoreDB;
-- Task 4
-- LEVEL 0
-- Q1
SELECT COUNT(*) AS Total_Applications
FROM Apps;

-- Q2
SELECT AVG(Rating) AS Average_Rating
FROM Apps;

-- Q3
SELECT MAX(Rating) AS Highest_Rating
FROM Apps;

-- Q4
SELECT MIN(Rating) AS Lowest_Rating
FROM Apps;

-- Q5
SELECT SUM(Downloads) AS Total_Downloads
FROM Apps;

-- Q6
SELECT *
FROM Apps
ORDER BY Rating DESC;


-- ============================================
-- LEVEL 1
-- ============================================

-- Q1
SELECT CategoryID,
       COUNT(*) AS Application_Count
FROM Apps
GROUP BY CategoryID;

-- Q2
SELECT CategoryID,
       AVG(Rating) AS Average_Rating
FROM Apps
GROUP BY CategoryID;

-- Q3
SELECT MAX(Price) AS Maximum_Price,
       MIN(Price) AS Minimum_Price
FROM Apps;

-- Q4
SELECT *
FROM Apps
ORDER BY Downloads DESC;

-- Q5
SELECT DeveloperID,
       COUNT(*) AS Application_Count
FROM Apps
GROUP BY DeveloperID;

-- Q6
SELECT CategoryID,
       COUNT(*) AS Application_Count
FROM Apps
GROUP BY CategoryID
HAVING COUNT(*) > 1;


-- ============================================
-- LEVEL 2
-- ============================================

-- Q1
SELECT DeveloperID,
       SUM(Downloads) AS Total_Downloads
FROM Apps
GROUP BY DeveloperID;

-- Q2
SELECT PublisherID,
       AVG(Rating) AS Average_Rating
FROM Apps
GROUP BY PublisherID;

-- Q3
SELECT DeveloperID,
       COUNT(*) AS Application_Count
FROM Apps
GROUP BY DeveloperID
HAVING COUNT(*) > 1;

-- Q4
SELECT CategoryID,
       AVG(Rating) AS Average_Rating
FROM Apps
GROUP BY CategoryID
HAVING AVG(Rating) > 4.3;

-- Q5
SELECT CategoryID,
       COUNT(*) AS Application_Count
FROM Apps
GROUP BY CategoryID
ORDER BY Application_Count DESC;

-- Q6
SELECT *
FROM Apps
WHERE Rating = (
    SELECT MAX(Rating)
    FROM Apps
);

-- Q7
SELECT DeveloperID,
       SUM(Price) AS Total_Price
FROM Apps
GROUP BY DeveloperID;