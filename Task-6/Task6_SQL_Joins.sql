USE PlayStoreDB;
-- LEVEL 0 
-- 1 
SELECT A.AppName,D.DeveloperName
FROM Apps A 
INNER JOIN Developers D 
ON A.DeveloperID = D.DeveloperID;
-- 2
SELECT A.AppName, P.PublisherName
FROM Apps as A
INNER JOIN Publishers P
ON A.PublisherID =P.PublisherID;
-- 3
SELECT A.AppName, C.CategoryName
FROM Apps A
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID;
-- 4
SELECT A.AppName,D.DeveloperName,P.publisherName
FROM Apps A 
INNER JOIN Developers D 
ON A.DeveloperID=D.DeveloperID
INNER JOIN Publishers P 
ON A.PublisherID=P.PublisherID;
-- 5
SELECT A.AppName,D.DeveloperName,C.CategoryName 
FROM Apps A 
INNER JOIN Developers D 
ON A.DeveloperID=D.DeveloperID
INNER JOIN Categories C 
ON A.CategoryID=C.CategoryID;
-- 6
SELECT P.PublisherName, A.AppName
FROM Publishers P
LEFT JOIN Apps A
ON P.PublisherID = A.PublisherID;
-- 7
SELECT C.CategoryName,A.AppName
FROM Categories C 
LEFT JOIN Apps A 
ON C.CategoryID=A.CategoryID;

-- LEVEL 1
-- 1
SELECT P.PublisherName, A.AppName
FROM Publishers P
LEFT JOIN Apps A
ON P.PublisherID = A.PublisherID;
-- 2
SELECT A.AppName, P.PublisherName
FROM Apps A
RIGHT JOIN Publishers P
ON A.PublisherID = P.PublisherID;
-- 3
SELECT C.CategoryName, A.AppName
FROM Categories C
LEFT JOIN Apps A
ON C.CategoryID = A.CategoryID;
-- 4
SELECT A.AppName,
       D.DeveloperName,
       D.Country
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID;
-- 5
SELECT A.AppName,
       D.DeveloperName,
       P.PublisherName,
       C.CategoryName
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
INNER JOIN Publishers P
ON A.PublisherID = P.PublisherID
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID;
-- 6
SELECT A.AppName,
       D.DeveloperName,
       D.Country
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
WHERE D.Country = 'USA';
-- 7
SELECT A.AppName,
       C.CategoryName,
       P.PublisherName
FROM Apps A
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID
INNER JOIN Publishers P
ON A.PublisherID = P.PublisherID
WHERE C.CategoryName = 'Gaming';
-- 8
SELECT A.AppName,
       A.Rating,
       D.DeveloperName
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
WHERE A.Rating > 4.5;
-- LEVEL 2
-- 1
SELECT P.PublisherName, A.AppName
FROM Publishers P
LEFT JOIN Apps A
ON P.PublisherID = A.PublisherID;
-- 2
SELECT P.PublisherName
FROM Publishers P
LEFT JOIN Apps A
ON P.PublisherID = A.PublisherID
WHERE A.AppID IS NULL;
-- 3
SELECT A.AppName, C.CategoryName
FROM Apps A
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID
ORDER BY C.CategoryName;
-- 4
SELECT A.AppName, D.DeveloperName,
       P.PublisherName, C.CategoryName, A.Rating
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
INNER JOIN Publishers P
ON A.PublisherID = P.PublisherID
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID;
-- 5
SELECT A.AppName, D.DeveloperName,
       D.Country, P.PublisherName
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
INNER JOIN Publishers P
ON A.PublisherID = P.PublisherID
WHERE D.Country = 'USA'
AND P.PublisherName = 'Google Play';
-- 6
SELECT D.DeveloperName, A.AppName
FROM Developers D
LEFT JOIN Apps A
ON D.DeveloperID = A.DeveloperID;
-- 7
SELECT D1.DeveloperName AS Developer1,
       D2.DeveloperName AS Developer2,
       D1.Country
FROM Developers D1
INNER JOIN Developers D2
ON D1.Country = D2.Country
AND D1.DeveloperID < D2.DeveloperID;
-- 8
SELECT P.PublisherName, C.CategoryName
FROM Publishers P
CROSS JOIN Categories C;
-- 9
SELECT P.PublisherName, A.AppName
FROM Publishers P
LEFT JOIN Apps A
ON P.PublisherID = A.PublisherID

UNION

SELECT P.PublisherName, A.AppName
FROM Publishers P
RIGHT JOIN Apps A
ON P.PublisherID = A.PublisherID;
-- 10
SELECT A.AppName, C.CategoryName,
       D.DeveloperName, P.PublisherName
FROM Apps A
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
INNER JOIN Publishers P
ON A.PublisherID = P.PublisherID
WHERE C.CategoryName IN ('Gaming', 'Social');
-- 11
SELECT A.AppName, C.CategoryName,
       D.DeveloperName, P.PublisherName
FROM Apps A
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
INNER JOIN Publishers P
ON A.PublisherID = P.PublisherID
WHERE C.CategoryName IN ('Gaming', 'Social');
-- 12
SELECT D.DeveloperName, D.Country, A.AppName
FROM Developers D
INNER JOIN Apps A
ON D.DeveloperID = A.DeveloperID
WHERE D.Country <> 'India';

-- Optional questions
-- 1
SELECT D.DeveloperName,
       D.Country,
       COUNT(A.AppID) AS Total_Applications,
       AVG(A.Rating) AS Average_Rating
FROM Developers D
INNER JOIN Apps A
ON D.DeveloperID = A.DeveloperID
GROUP BY D.DeveloperID, D.DeveloperName, D.Country
HAVING COUNT(A.AppID) > 1;
-- 2
SELECT UPPER(A.AppName) AS AppName,
       UPPER(D.DeveloperName) AS DeveloperName,
       UPPER(D.Country) AS Country
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
WHERE D.Country = 'USA';
-- 3
SELECT P.PublisherName,
       COUNT(A.AppID) AS Total_Applications,
       COALESCE(SUM(A.Downloads), 0) AS Total_Downloads
FROM Publishers P
LEFT JOIN Apps A
ON P.PublisherID = A.PublisherID
GROUP BY P.PublisherID, P.PublisherName
ORDER BY Total_Downloads DESC;
-- 4
SELECT A.AppName,
       D.DeveloperName,
       C.CategoryName,
       ROUND(A.Rating, 0) AS Rounded_Rating
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID;
-- 5
SELECT D.DeveloperName,
       A.AppName,
       P.PublisherName,
       CAST(D.FoundedYear AS CHAR) AS Founded_Year
FROM Developers D
INNER JOIN Apps A
ON D.DeveloperID = A.DeveloperID
INNER JOIN Publishers P
ON A.PublisherID = P.PublisherID;
-- 6
SELECT C.CategoryName,
       COUNT(A.AppID) AS Total_Applications,
       AVG(A.Rating) AS Average_Rating
FROM Categories C
INNER JOIN Apps A
ON C.CategoryID = A.CategoryID
GROUP BY C.CategoryID, C.CategoryName
HAVING AVG(A.Rating) > 4.3
ORDER BY Average_Rating DESC;


