USE PlayStoreDB;
-- Level 0
-- 1
SELECT UPPER(DeveloperName)
FROM Developers;
-- 2
SELECT LOWER(DeveloperName)
FROM Developers;
-- 3
SELECT AppName,LENGTH(AppName) AS
NameLength
FROM Apps;
-- 4
SELECT CategoryName,LENGTH(CategoryName)
AS NameLength
FROM Categories;
-- 5 
SELECT CURRENT_DATE(),
CURRENT_TIME();
-- 6
SELECT AppName,ROUND(Rating,0)
AS RoundedRating
FROM Apps;

-- Level 1
-- 1
SELECT AppName,SUBSTRING(AppName,1,5) 
AS First5Characters
FROM Apps;
-- 2
SELECT CONCAT(DeveloperName,' ',Country) AS
DeveloperCountry FROM Developers;
-- 3
SELECT AppName,ROUND(Rating,1)
AS RoundedRating
FROM Apps;
-- 4
SELECT AppName,CEIL(Price) AS 
CeilPrice
FROM Apps;
-- 5
SELECT DeveloperName,FoundedYear
FROM Developers;
-- 6
SELECT AppName, CAST(Downloads AS CHAR) 
AS DownloadsText
FROM Apps;

-- Level 2
-- 1
SELECT UPPER(AppName) AS AppName,
Rating
FROM Apps;
-- 2
SELECT CategoryName,
SUBSTRING(CategoryName,1,3) AS 
First3Characters
FROM Categories;
-- 3
SELECT AppName,ABS(Price-200)
AS PriceDifference 
FROM Apps;
-- 4
SELECT DeveloperName,
LENGTH(DeveloperName) AS
NameLength
FROM Developers;
-- 5
SELECT CURRENT_DATE(),
CURRENT_TIME();
-- 6
SELECT CAST(12345 AS CHAR) AS
CharacterValue;
SELECT CONVERT(12345,CHAR) AS
CharacterValue;