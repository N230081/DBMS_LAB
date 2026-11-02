-- DBMS LAB - TASK 8
-- MYSQL STORED PROGRAMS
-- Database: PlayStoreDB
-- File: week8_stored_programs_mysql.sql
USE PlayStoreDB;

-- Verify the existing tables before running the programs
SHOW TABLES;

SELECT * FROM Developers;
SELECT * FROM Publishers;
SELECT * FROM Categories;
SELECT * FROM Apps;

-- PART A - GETTING STARTED

-- TASK 2: Welcome procedure

DELIMITER //

CREATE PROCEDURE welcome_playstore()
BEGIN
    SELECT 'Welcome to PlayStoreDB' AS message;
END //

DELIMITER ;

CALL welcome_playstore();

-- TASK 4 AND TASK 5: Retrieve application name and rating
-- using AppID as an IN parameter

DELIMITER //

CREATE PROCEDURE get_app_rating(IN p_app_id INT)
BEGIN
    DECLARE v_app_name VARCHAR(60);
    DECLARE v_rating DECIMAL(2,1);

    SELECT AppName, Rating
    INTO v_app_name, v_rating
    FROM Apps
    WHERE AppID = p_app_id;

    SELECT v_app_name AS application_name,
           v_rating AS application_rating;
END //

DELIMITER ;

CALL get_app_rating(1001);

-- LEVEL 0

-- QUESTION 1: Calculate 10% of application price

DELIMITER //

CREATE PROCEDURE calculate_app_discount(IN p_app_id INT)
BEGIN
    DECLARE v_price DECIMAL(6,2);
    DECLARE v_discount DECIMAL(8,2);

    SELECT Price
    INTO v_price
    FROM Apps
    WHERE AppID = p_app_id;

    SET v_discount = v_price * 0.10;

    SELECT v_price AS original_price,
           v_discount AS ten_percent_of_price;
END //

DELIMITER ;

CALL calculate_app_discount(1006);

-- QUESTION 2: Display application details

DELIMITER //

CREATE PROCEDURE display_application_details(IN p_app_id INT)
BEGIN
    DECLARE v_name VARCHAR(60);
    DECLARE v_rating DECIMAL(2,1);
    DECLARE v_price DECIMAL(6,2);
    DECLARE v_downloads BIGINT;

    SELECT AppName, Rating, Price, Downloads
    INTO v_name, v_rating, v_price, v_downloads
    FROM Apps
    WHERE AppID = p_app_id;

    SELECT v_name AS application_name,
           v_rating AS rating,
           v_price AS price,
           v_downloads AS downloads;
END //

DELIMITER ;

CALL display_application_details(1001);


-- QUESTION 3: Classify application rating

DELIMITER //

CREATE PROCEDURE classify_app_rating(IN p_app_id INT)
BEGIN
    DECLARE v_rating DECIMAL(2,1);
    DECLARE v_category VARCHAR(30);

    SELECT Rating
    INTO v_rating
    FROM Apps
    WHERE AppID = p_app_id;

    IF v_rating >= 4.5 THEN
        SET v_category = 'Highly Rated';
    ELSEIF v_rating >= 3.5 THEN
        SET v_category = 'Moderately Rated';
    ELSE
        SET v_category = 'Low Rated';
    END IF;

    SELECT v_rating AS rating,
           v_category AS classification;
END //

DELIMITER ;

CALL classify_app_rating(1001);


-- QUESTION 4: Function to classify application price

DELIMITER //

CREATE FUNCTION classify_application_price(p_price DECIMAL(6,2))
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    IF p_price > 0 THEN
        RETURN 'Paid Application';
    ELSE
        RETURN 'Free Application';
    END IF;
END //

DELIMITER ;

SELECT AppID, AppName, Price,
       classify_application_price(Price) AS price_category
FROM Apps;


-- QUESTION 5: Loop from 1 to 10

DELIMITER //

CREATE PROCEDURE display_numbers()
BEGIN
    DECLARE counter INT DEFAULT 1;

    WHILE counter <= 10 DO
        SELECT counter AS number,
               'PlayStore Application' AS message;

        SET counter = counter + 1;
    END WHILE;
END //

DELIMITER ;

CALL display_numbers();


-- ============================================================
-- LEVEL 1
-- ============================================================

-- QUESTION 1: Classify application rating using IF / ELSEIF

DELIMITER //

CREATE PROCEDURE classify_application_rating(IN p_app_id INT)
BEGIN
    DECLARE v_rating DECIMAL(2,1);
    DECLARE v_category VARCHAR(40);

    SELECT Rating
    INTO v_rating
    FROM Apps
    WHERE AppID = p_app_id;

    IF v_rating >= 4.5 THEN
        SET v_category = 'Excellent Application';
    ELSEIF v_rating >= 4.0 THEN
        SET v_category = 'Good Application';
    ELSEIF v_rating >= 3.5 THEN
        SET v_category = 'Average Application';
    ELSE
        SET v_category = 'Low Rated Application';
    END IF;

    SELECT v_rating AS rating,
           v_category AS classification;
END //

DELIMITER ;

CALL classify_application_rating(1001);


-- QUESTION 2: Function to return application rating

DELIMITER //

CREATE FUNCTION get_application_rating(p_app_id INT)
RETURNS DECIMAL(2,1)
READS SQL DATA
BEGIN
    DECLARE v_rating DECIMAL(2,1);

    SELECT Rating
    INTO v_rating
    FROM Apps
    WHERE AppID = p_app_id;

    RETURN v_rating;
END //

DELIMITER ;

SELECT AppName,
       get_application_rating(AppID) AS Rating
FROM Apps;


-- ============================================================
-- LEVEL 2
-- ============================================================

-- QUESTION 1: Cursor to process all applications
-- Uses CURSOR, NOT FOUND HANDLER and LOOP

DELIMITER //

CREATE PROCEDURE display_all_applications()
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_name VARCHAR(60);
    DECLARE v_rating DECIMAL(2,1);
    DECLARE v_price DECIMAL(6,2);
    DECLARE v_downloads BIGINT;

    DECLARE app_cursor CURSOR FOR
        SELECT AppName, Rating, Price, Downloads
        FROM Apps;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;

    OPEN app_cursor;

    read_loop: LOOP
        FETCH app_cursor
        INTO v_name, v_rating, v_price, v_downloads;

        IF v_done = 1 THEN
            LEAVE read_loop;
        END IF;

        SELECT v_name AS application_name,
               v_rating AS rating,
               v_price AS price,
               v_downloads AS downloads;
    END LOOP;

    CLOSE app_cursor;
END //

DELIMITER ;

CALL display_all_applications();


-- QUESTION 2: Exception handling using NOT FOUND handler

DELIMITER //

CREATE PROCEDURE find_application(IN p_app_id INT)
BEGIN
    DECLARE v_not_found INT DEFAULT 0;
    DECLARE v_name VARCHAR(60);
    DECLARE v_rating DECIMAL(2,1);
    DECLARE v_price DECIMAL(6,2);

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_not_found = 1;

    SELECT AppName, Rating, Price
    INTO v_name, v_rating, v_price
    FROM Apps
    WHERE AppID = p_app_id;

    IF v_not_found = 1 THEN
        SELECT 'Application not found' AS message;
    ELSE
        SELECT v_name AS application_name,
               v_rating AS rating,
               v_price AS price;
    END IF;
END //

DELIMITER ;

-- Test with an existing AppID
CALL find_application(1001);

-- Test with a non-existing AppID
CALL find_application(9999);

-- OPTIONAL QUESTIONS

-- OPTIONAL 1: Update application rating
-- First checks whether the application exists.

DELIMITER //

CREATE PROCEDURE update_application_rating(
    IN p_app_id INT,
    IN p_new_rating DECIMAL(2,1)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_count
    FROM Apps
    WHERE AppID = p_app_id;

    IF v_count = 0 THEN
        SELECT 'Application not found' AS message;
    ELSE
        UPDATE Apps
        SET Rating = p_new_rating
        WHERE AppID = p_app_id;

        SELECT AppID, AppName, Rating
        FROM Apps
        WHERE AppID = p_app_id;
    END IF;
END //

DELIMITER ;

-- Example test (uncomment to update an application)
-- CALL update_application_rating(1001, 4.8);


-- OPTIONAL 2: CASE statement for rating classification

DELIMITER //

CREATE PROCEDURE classify_rating_case(IN p_rating DECIMAL(2,1))
BEGIN
    DECLARE v_category VARCHAR(30);

    CASE
        WHEN p_rating >= 4.5 THEN
            SET v_category = 'Excellent';
        WHEN p_rating >= 4.0 THEN
            SET v_category = 'Good';
        WHEN p_rating >= 3.5 THEN
            SET v_category = 'Average';
        ELSE
            SET v_category = 'Low Rated';
    END CASE;

    SELECT v_category AS classification;
END //

DELIMITER ;

CALL classify_rating_case(4.6);


-- OPTIONAL 3: Application and developer details

DELIMITER //

CREATE PROCEDURE application_developer_details(IN p_app_id INT)
BEGIN
    SELECT A.AppID,
           A.AppName,
           A.Rating,
           A.Price,
           A.DeveloperID,
           D.DeveloperName,
           D.Country
    FROM Apps A
    JOIN Developers D
        ON A.DeveloperID = D.DeveloperID
    WHERE A.AppID = p_app_id;
END //

DELIMITER ;

CALL application_developer_details(1001);


-- OPTIONAL 4: Cursor to display AppID, AppName, Rating and Downloads

DELIMITER //

CREATE PROCEDURE display_app_cursor()
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_id INT;
    DECLARE v_name VARCHAR(60);
    DECLARE v_rating DECIMAL(2,1);
    DECLARE v_downloads BIGINT;

    DECLARE app_cursor CURSOR FOR
        SELECT AppID, AppName, Rating, Downloads
        FROM Apps;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;

    OPEN app_cursor;

    read_loop: LOOP
        FETCH app_cursor
        INTO v_id, v_name, v_rating, v_downloads;

        IF v_done = 1 THEN
            LEAVE read_loop;
        END IF;

        SELECT v_id AS AppID,
               v_name AS AppName,
               v_rating AS Rating,
               v_downloads AS Downloads;
    END LOOP;

    CLOSE app_cursor;
END //

DELIMITER ;

CALL display_app_cursor();


-- OPTIONAL 5: Function for rating classification

DELIMITER //

CREATE FUNCTION classify_rating_value(p_rating DECIMAL(2,1))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF p_rating IS NULL THEN
        RETURN 'Not Rated';
    ELSEIF p_rating >= 4.5 THEN
        RETURN 'Excellent';
    ELSEIF p_rating >= 4.0 THEN
        RETURN 'Good';
    ELSEIF p_rating >= 3.5 THEN
        RETURN 'Average';
    ELSE
        RETURN 'Low Rated';
    END IF;
END //

DELIMITER ;

SELECT AppID,
       AppName,
       Rating,
       classify_rating_value(Rating) AS classification
FROM Apps;

