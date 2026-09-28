USE PlayStoreDB;

-- Disable Safe Update Mode for this lab session
SET SQL_SAFE_UPDATES = 0;

-- TASK 5 : TCL & DCL COMMANDS

-- LEVEL 0 - BASIC

-- Q1. Update the rating of Google Keep and permanently
-- save the change using COMMIT.

START TRANSACTION;

UPDATE Apps
SET Rating = 4.6
WHERE AppID = 1002;

COMMIT;


-- Q2. Update the price of BYJU'S Learning and cancel
-- the change using ROLLBACK.
-- BYJU'S Learning = AppID 1006


START TRANSACTION;

UPDATE Apps
SET Price = 199
WHERE AppID = 1006;

ROLLBACK;

-- Q3. Insert a new application and permanently
-- save it using COMMIT.

START TRANSACTION;

INSERT INTO Apps
(AppID, AppName, DeveloperID, PublisherID, CategoryID,
 Rating, Downloads, Price)
SELECT
1012, 'ChatGPT', 101, 201, 301,
4.8, 100000000, 0
WHERE NOT EXISTS
(
    SELECT 1
    FROM Apps
    WHERE AppID = 1012
);

COMMIT;


-- Q4. Insert a new developer and cancel the insertion
-- using ROLLBACK.

START TRANSACTION;

INSERT INTO Developers
(DeveloperID, DeveloperName, Country, FoundedYear)
SELECT
106, 'OpenAI', 'USA', 2015
WHERE NOT EXISTS
(
    SELECT 1
    FROM Developers
    WHERE DeveloperID = 106
);

ROLLBACK;

-- Q5. Create a savepoint after updating an
-- application's rating.

START TRANSACTION;

UPDATE Apps
SET Rating = 4.7
WHERE AppID = 1001;

SAVEPOINT rating_savepoint;

COMMIT;

-- LEVEL 1 - INTERMEDIATE

-- Q1 & Q2.
-- Update two applications with a savepoint between them,
-- perform another update, and rollback to the savepoint.

START TRANSACTION;

-- First update
UPDATE Apps
SET Rating = 4.7
WHERE AppID = 1001;

-- Savepoint after first update
SAVEPOINT after_first_update;

-- Second update
UPDATE Apps
SET Rating = 4.8
WHERE AppID = 1004;

-- Another update
UPDATE Apps
SET Rating = 4.9
WHERE AppID = 1005;

-- Undo changes made after the savepoint.
-- The first update remains.
ROLLBACK TO SAVEPOINT after_first_update;

COMMIT;


-- Q3. Insert a new application, create a savepoint,
-- update its price, and roll back to the savepoint.

START TRANSACTION;

INSERT INTO Apps
(AppID, AppName, DeveloperID, PublisherID, CategoryID,
 Rating, Downloads, Price)
SELECT
1013, 'Study Assistant', 101, 201, 301,
4.5, 50000000, 99
WHERE NOT EXISTS
(
    SELECT 1
    FROM Apps
    WHERE AppID = 1013
);

SAVEPOINT after_app_insert;

UPDATE Apps
SET Price = 199
WHERE AppID = 1013;

ROLLBACK TO SAVEPOINT after_app_insert;

COMMIT;

-- Q4. Grant SELECT privilege on Apps.
-- CURRENT_USER() refers to the MySQL account currently
-- connected to Workbench.


GRANT SELECT
ON PlayStoreDB.Apps
TO CURRENT_USER();


-- Q5. Grant SELECT and INSERT privileges on Apps.


GRANT SELECT, INSERT
ON PlayStoreDB.Apps
TO CURRENT_USER();



-- Q6. Revoke INSERT privilege from the current user.


REVOKE INSERT
ON PlayStoreDB.Apps
FROM CURRENT_USER();

-- LEVEL 2 - PRACTICE

-- Q1. Perform multiple updates using SAVEPOINT and
-- ROLLBACK TO selectively.

START TRANSACTION;

-- First update
UPDATE Apps
SET Rating = 4.6
WHERE AppID = 1002;

SAVEPOINT update_one;

-- Second update
UPDATE Apps
SET Price = 49
WHERE AppID = 1001;

SAVEPOINT update_two;

-- Third update
UPDATE Apps
SET Rating = 4.9
WHERE AppID = 1005;

-- Undo only the third update.
ROLLBACK TO SAVEPOINT update_two;

COMMIT;

-- Q2. Insert two records into Categories, create a
-- savepoint, then rollback to the savepoint.

START TRANSACTION;

INSERT INTO Categories
(CategoryID, CategoryName, MinimumAge)
SELECT
306, 'Artificial Intelligence', 12
WHERE NOT EXISTS
(
    SELECT 1
    FROM Categories
    WHERE CategoryID = 306
);

INSERT INTO Categories
(CategoryID, CategoryName, MinimumAge)
SELECT
307, 'Health', 12
WHERE NOT EXISTS
(
    SELECT 1
    FROM Categories
    WHERE CategoryID = 307
);

SAVEPOINT category_savepoint;

ROLLBACK TO SAVEPOINT category_savepoint;

COMMIT;



-- Q3. Grant SELECT, INSERT and UPDATE privileges
-- on Apps.

GRANT SELECT, INSERT, UPDATE
ON PlayStoreDB.Apps
TO CURRENT_USER();

-- Q4. Revoke UPDATE privilege from the user.

REVOKE UPDATE
ON PlayStoreDB.Apps
FROM CURRENT_USER();



-- Q5. Grant SELECT privilege on Developers and
-- revoke the same privilege.


GRANT SELECT
ON PlayStoreDB.Developers
TO CURRENT_USER();

REVOKE SELECT
ON PlayStoreDB.Developers
FROM CURRENT_USER();


-- Q6. Perform multiple operations in a transaction
-- and permanently save them using COMMIT.

START TRANSACTION;

UPDATE Apps
SET Rating = 4.6
WHERE AppID = 1002;

UPDATE Apps
SET Price = 0
WHERE AppID = 1001;

INSERT INTO Apps
(AppID, AppName, DeveloperID, PublisherID, CategoryID,
 Rating, Downloads, Price)
SELECT
1014, 'Study Companion', 101, 201, 301,
4.4, 25000000, 0
WHERE NOT EXISTS
(
    SELECT 1
    FROM Apps
    WHERE AppID = 1014
);

COMMIT;



-- Q7. Verify the effects of COMMIT and ROLLBACK.


-- Verify Google Keep
SELECT *
FROM Apps
WHERE AppID = 1002;


-- Verify BYJU'S Learning.
-- Its price should remain 299 because Q2 used ROLLBACK.
SELECT *
FROM Apps
WHERE AppID = 1006;


-- Verify committed ChatGPT
SELECT *
FROM Apps
WHERE AppID = 1012;


-- Verify Study Assistant
-- Its price should remain 99 because the price update
-- was rolled back to the savepoint.
SELECT *
FROM Apps
WHERE AppID = 1013;


-- Verify the developer insertion was rolled back.
-- DeveloperID 106 should NOT exist if Q4 executed successfully.
SELECT *
FROM Developers
WHERE DeveloperID = 106;


-- Verify the final committed application
SELECT *
FROM Apps
WHERE AppID = 1014;