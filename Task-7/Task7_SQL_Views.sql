
USE PlayStoreDB;

-- PART A: VERIFY PREVIOUS DATABASE

SHOW TABLES;

SELECT * FROM Developers;
SELECT * FROM Publishers;
SELECT * FROM Categories;
SELECT * FROM Apps;

-- LEVEL 1 - UNDERSTANDING

-- Q1. Create a View displaying all application records

CREATE OR REPLACE VIEW All_Apps_View AS
SELECT *
FROM Apps;

-- Q2. Create a View displaying AppID, AppName, Rating and Price

CREATE OR REPLACE VIEW App_Basic_View AS
SELECT AppID, AppName, Rating, Price
FROM Apps;

-- Q3. Create a View displaying applications with rating >= 4.5

CREATE OR REPLACE VIEW Highly_Rated_Apps AS
SELECT AppID, AppName, Rating, Downloads
FROM Apps
WHERE Rating >= 4.5;

-- Q4. Create a View displaying free applications

CREATE OR REPLACE VIEW Free_Apps AS
SELECT AppID, AppName, Rating, Downloads, Price
FROM Apps
WHERE Price = 0;

-- Q5. Retrieve all records from Highly_Rated_Apps View

SELECT * FROM Highly_Rated_Apps;

-- Q6. Display all Views available in the database

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

-- LEVEL 2 - APPLICATION

-- Q1. View displaying application names and developer names

CREATE OR REPLACE VIEW App_Developer_View AS
SELECT A.AppName, D.DeveloperName
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID;

-- Q2. View displaying application names and publisher names

CREATE OR REPLACE VIEW App_Publisher_View AS
SELECT A.AppName, P.PublisherName
FROM Apps A
INNER JOIN Publishers P
ON A.PublisherID = P.PublisherID;

-- Q3. View displaying application names and category names

CREATE OR REPLACE VIEW App_Category_View AS
SELECT A.AppName, C.CategoryName
FROM Apps A
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID;

-- Q4. View displaying application details with developer names and countries

CREATE OR REPLACE VIEW App_Developer_Details AS
SELECT A.AppID, A.AppName, A.Rating, A.Price,
       D.DeveloperName, D.Country
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID;

-- Q5. View displaying total applications for each category

CREATE OR REPLACE VIEW Category_App_Count AS
SELECT CategoryID, COUNT(*) AS Total_Applications
FROM Apps
GROUP BY CategoryID;

-- Q6. View displaying total applications for each developer

CREATE OR REPLACE VIEW Developer_App_Count AS
SELECT DeveloperID, COUNT(*) AS Total_Applications
FROM Apps
GROUP BY DeveloperID;

-- Q7. View displaying average rating for each category

CREATE OR REPLACE VIEW Category_Avg_Rating AS
SELECT CategoryID, AVG(Rating) AS Average_Rating
FROM Apps
GROUP BY CategoryID;

-- Q8. View displaying applications with rating > 4.3 and developer names

CREATE OR REPLACE VIEW Highly_Rated_Developer_View AS
SELECT A.AppName, A.Rating, D.DeveloperName
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
WHERE A.Rating > 4.3;

-- Q9. Retrieve selected columns from an existing View using WHERE

SELECT AppName, DeveloperName
FROM Highly_Rated_Developer_View
WHERE Rating > 4.5;

-- Q10. Display the definition of a created View

SHOW CREATE VIEW App_Developer_View;

-- LEVEL 3 - MEDIUM TO ADVANCED

-- Q1. View displaying category names and total application counts using JOIN and GROUP BY

CREATE OR REPLACE VIEW Category_Name_Count AS
SELECT C.CategoryName,
       COUNT(A.AppID) AS Total_Applications
FROM Categories C
LEFT JOIN Apps A
ON C.CategoryID = A.CategoryID
GROUP BY C.CategoryID, C.CategoryName;

-- Q2. View displaying developers having more than one application

CREATE OR REPLACE VIEW Developers_Multiple_Apps AS
SELECT D.DeveloperID, D.DeveloperName,
       COUNT(A.AppID) AS Total_Applications
FROM Developers D
INNER JOIN Apps A
ON D.DeveloperID = A.DeveloperID
GROUP BY D.DeveloperID, D.DeveloperName
HAVING COUNT(A.AppID) > 1;

-- Q3. View displaying each category with highest and lowest application ratings

CREATE OR REPLACE VIEW Category_Rating_Range AS
SELECT C.CategoryName,
       MAX(A.Rating) AS Highest_Rating,
       MIN(A.Rating) AS Lowest_Rating
FROM Categories C
LEFT JOIN Apps A
ON C.CategoryID = A.CategoryID
GROUP BY C.CategoryID, C.CategoryName;

-- Q4. View displaying developer names and total applications developed

CREATE OR REPLACE VIEW Developer_Total_Apps AS
SELECT D.DeveloperName,
       COUNT(A.AppID) AS Total_Applications
FROM Developers D
LEFT JOIN Apps A
ON D.DeveloperID = A.DeveloperID
GROUP BY D.DeveloperID, D.DeveloperName;

-- Q5. View combining application, developer, publisher and category details

CREATE OR REPLACE VIEW Complete_App_Details AS
SELECT A.AppID, A.AppName, A.Rating, A.Downloads, A.Price,
       D.DeveloperName, D.Country,
       P.PublisherName,
       C.CategoryName
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
INNER JOIN Publishers P
ON A.PublisherID = P.PublisherID
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID;

-- Q6. View displaying highly rated applications with developer and category names

CREATE OR REPLACE VIEW Highly_Rated_App_Details AS
SELECT A.AppName, A.Rating,
       D.DeveloperName, C.CategoryName
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID
WHERE A.Rating >= 4.5;

-- Q7. View displaying publisher names, total applications and downloads,
-- including publishers without applications

CREATE OR REPLACE VIEW Publisher_App_Statistics AS
SELECT P.PublisherName,
       COUNT(A.AppID) AS Total_Applications,
       COALESCE(SUM(A.Downloads), 0) AS Total_Downloads
FROM Publishers P
LEFT JOIN Apps A
ON P.PublisherID = A.PublisherID
GROUP BY P.PublisherID, P.PublisherName;

-- Q8. Retrieve records from a View using filtering and sorting conditions

SELECT *
FROM Complete_App_Details
WHERE Rating > 4.3
ORDER BY Rating DESC;

-- Q9. Create a simple updatable View and update application rating

CREATE OR REPLACE VIEW App_Rating_View AS
SELECT AppID, AppName, Rating
FROM Apps;

UPDATE App_Rating_View
SET Rating = 4.8
WHERE AppID = 1008;

SELECT * FROM App_Rating_View;

SELECT * FROM Apps;

-- Q10. Drop a created View and verify its removal

DROP VIEW IF EXISTS App_Rating_View;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

-- REAL-WORLD GOOGLE PLAY STORE ANALYSIS
-- OPTIONAL PRACTICE

-- Task 1. View for all highly rated applications

CREATE OR REPLACE VIEW RW_Highly_Rated_Apps AS
SELECT *
FROM Apps
WHERE Rating >= 4.5;

-- Task 2. Category-wise application statistics

CREATE OR REPLACE VIEW RW_Category_Statistics AS
SELECT C.CategoryName,
       COUNT(A.AppID) AS Total_Applications,
       AVG(A.Rating) AS Average_Rating
FROM Categories C
LEFT JOIN Apps A
ON C.CategoryID = A.CategoryID
GROUP BY C.CategoryID, C.CategoryName;

-- Task 3. Developer-wise application statistics

CREATE OR REPLACE VIEW RW_Developer_Statistics AS
SELECT D.DeveloperName,
       COUNT(A.AppID) AS Total_Applications,
       AVG(A.Rating) AS Average_Rating
FROM Developers D
LEFT JOIN Apps A
ON D.DeveloperID = A.DeveloperID
GROUP BY D.DeveloperID, D.DeveloperName;

-- Task 4. Publisher-wise application counts and total downloads

CREATE OR REPLACE VIEW RW_Publisher_Statistics AS
SELECT P.PublisherName,
       COUNT(A.AppID) AS Total_Applications,
       COALESCE(SUM(A.Downloads), 0) AS Total_Downloads
FROM Publishers P
LEFT JOIN Apps A
ON P.PublisherID = A.PublisherID
GROUP BY P.PublisherID, P.PublisherName;

-- Task 5. View combining application, developer, publisher and category information

CREATE OR REPLACE VIEW RW_Complete_App_Details AS
SELECT A.AppID, A.AppName,
       D.DeveloperName,
       P.PublisherName,
       C.CategoryName,
       A.Rating, A.Downloads, A.Price
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
INNER JOIN Publishers P
ON A.PublisherID = P.PublisherID
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID;

-- Task 6. Applications with ratings greater than overall average rating

CREATE OR REPLACE VIEW RW_Above_Average_Apps AS
SELECT AppID, AppName, Rating
FROM Apps
WHERE Rating > (SELECT AVG(Rating) FROM Apps);

-- Task 7. Most downloaded applications in each category

CREATE OR REPLACE VIEW RW_Most_Downloaded_Apps AS
SELECT A.AppID, A.AppName, A.CategoryID, A.Downloads
FROM Apps A
WHERE A.Downloads = (
    SELECT MAX(A2.Downloads)
    FROM Apps A2
    WHERE A2.CategoryID = A.CategoryID
);

-- Task 8. Google Play Store application dashboard

CREATE OR REPLACE VIEW RW_App_Dashboard AS
SELECT A.AppName,
       D.DeveloperName,
       P.PublisherName,
       C.CategoryName,
       A.Rating,
       A.Downloads,
       A.Price
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
INNER JOIN Publishers P
ON A.PublisherID = P.PublisherID
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID;

-- VERIFY ALL CREATED VIEWS

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

SELECT * FROM RW_App_Dashboard;
