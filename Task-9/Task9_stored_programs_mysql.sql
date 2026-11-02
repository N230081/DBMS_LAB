-- DBMS LAB TASK 9 - MYSQL STORED PROGRAMS
-- Database: PlayStoreDB
-- File: week9_stored_programs_mysql.sql

USE PlayStoreDB;

-- Verify existing tables and records
SHOW TABLES;

SELECT * FROM Developers;
SELECT * FROM Publishers;
SELECT * FROM Categories;
SELECT * FROM Apps;

-- 6. MEDIUM-LEVEL ACTIVITIES

-- PART A - TASK 1
-- Function: classify_rating

DROP FUNCTION IF EXISTS classify_rating;

DELIMITER //

CREATE FUNCTION classify_rating(p_rating DECIMAL(2,1))
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    IF p_rating IS NULL THEN
        RETURN 'Not Rated';
    ELSEIF p_rating >= 4.5 THEN
        RETURN 'Excellent';
    ELSEIF p_rating >= 4.0 THEN
        RETURN 'Very Good';
    ELSEIF p_rating >= 3.0 THEN
        RETURN 'Good';
    ELSE
        RETURN 'Needs Improvement';
    END IF;
END //

DELIMITER ;

-- Test with five values, including NULL
SELECT classify_rating(4.8) AS result;
SELECT classify_rating(4.2) AS result;
SELECT classify_rating(3.5) AS result;
SELECT classify_rating(2.5) AS result;
SELECT classify_rating(NULL) AS result;


-- PART B - TASK 2
-- Procedure: application_details

DROP PROCEDURE IF EXISTS application_details;

DELIMITER //

CREATE PROCEDURE application_details(IN p_application_id INT)
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_app_id INT;
    DECLARE v_app_name VARCHAR(60);
    DECLARE v_rating DECIMAL(2,1);
    DECLARE v_price DECIMAL(6,2);
    DECLARE v_downloads BIGINT;
    DECLARE v_developer VARCHAR(60);
    DECLARE v_publisher VARCHAR(60);
    DECLARE v_category VARCHAR(40);

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;

    SELECT A.AppID, A.AppName, A.Rating, A.Price, A.Downloads,
           D.DeveloperName, P.PublisherName, C.CategoryName
    INTO v_app_id, v_app_name, v_rating, v_price, v_downloads,
         v_developer, v_publisher, v_category
    FROM Apps A
    JOIN Developers D ON A.DeveloperID = D.DeveloperID
    JOIN Publishers P ON A.PublisherID = P.PublisherID
    JOIN Categories C ON A.CategoryID = C.CategoryID
    WHERE A.AppID = p_application_id;

    IF v_done = 1 THEN
        SELECT 'Application not found' AS message;
    ELSE
        SELECT v_app_id AS application_id,
               v_app_name AS application_name,
               v_rating AS rating,
               v_price AS price,
               v_downloads AS downloads,
               v_developer AS developer_name,
               v_publisher AS publisher_name,
               v_category AS category_name;
    END IF;
END //

DELIMITER ;

CALL application_details(1001);
CALL application_details(9999);


-- PART C - TASK 3
-- Function: get_developer_app_count

DROP FUNCTION IF EXISTS get_developer_app_count;

DELIMITER //

CREATE FUNCTION get_developer_app_count(p_developer_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*)
    INTO v_count
    FROM Apps
    WHERE DeveloperID = p_developer_id;

    RETURN v_count;
END //

DELIMITER ;

-- Display application count for all developers
SELECT D.DeveloperID,
       D.DeveloperName,
       get_developer_app_count(D.DeveloperID) AS Number_Of_Applications
FROM Developers D;

-- 7. LEVEL 1 QUESTIONS

-- QUESTION 1
-- Procedure: category_application_summary

DROP PROCEDURE IF EXISTS category_application_summary;

DELIMITER //

CREATE PROCEDURE category_application_summary(IN p_category_id INT)
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_category_name VARCHAR(40);
    DECLARE v_total INT;
    DECLARE v_free INT;
    DECLARE v_paid INT;
    DECLARE v_average_rating DECIMAL(4,2);

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;

    SELECT CategoryName
    INTO v_category_name
    FROM Categories
    WHERE CategoryID = p_category_id;

    IF v_done = 1 THEN
        SELECT 'Category not found' AS message;
    ELSE
        SELECT COUNT(*),
               SUM(CASE WHEN Price = 0 THEN 1 ELSE 0 END),
               SUM(CASE WHEN Price > 0 THEN 1 ELSE 0 END),
               AVG(Rating)
        INTO v_total, v_free, v_paid, v_average_rating
        FROM Apps
        WHERE CategoryID = p_category_id;

        SELECT v_category_name AS category_name,
               v_total AS total_applications,
               v_free AS free_applications,
               v_paid AS paid_applications,
               v_average_rating AS average_rating;
    END IF;
END //

DELIMITER ;

CALL category_application_summary(301);
CALL category_application_summary(999);


-- QUESTION 2
-- Function: classify_app_price

DROP FUNCTION IF EXISTS classify_app_price;

DELIMITER //

CREATE FUNCTION classify_app_price(p_price DECIMAL(6,2))
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    IF p_price = 0 THEN
        RETURN 'Free';
    ELSEIF p_price <= 100 THEN
        RETURN 'Budget';
    ELSEIF p_price <= 500 THEN
        RETURN 'Premium';
    ELSE
        RETURN 'High Premium';
    END IF;
END //

DELIMITER ;

SELECT AppID,
       AppName,
       Price,
       classify_app_price(Price) AS Price_Category
FROM Apps;


-- QUESTION 3
-- Procedure: application_rating_decision

DROP PROCEDURE IF EXISTS application_rating_decision;

DELIMITER //

CREATE PROCEDURE application_rating_decision(IN p_app_id INT)
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_rating DECIMAL(2,1);

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;

    SELECT Rating
    INTO v_rating
    FROM Apps
    WHERE AppID = p_app_id;

    IF v_done = 1 THEN
        SELECT 'Application not found' AS message;
    ELSEIF v_rating IS NULL THEN
        SELECT 'Rating Not Available' AS message;
    ELSEIF v_rating >= 4.5 THEN
        SELECT 'Highly Rated Application' AS message;
    ELSEIF v_rating >= 4.0 THEN
        SELECT 'Good Application' AS message;
    ELSEIF v_rating >= 3.0 THEN
        SELECT 'Average Application' AS message;
    ELSE
        SELECT 'Low Rated Application' AS message;
    END IF;
END //

DELIMITER ;

CALL application_rating_decision(1001);
CALL application_rating_decision(9999);


-- ============================================================
-- 8. LEVEL 2 QUESTIONS
-- ============================================================

-- QUESTION 1A
-- LOOP: display numbers 1 to 10

DROP PROCEDURE IF EXISTS display_numbers_loop;

DELIMITER //

CREATE PROCEDURE display_numbers_loop()
BEGIN
    DECLARE v_counter INT DEFAULT 1;

    number_loop: LOOP
        IF v_counter > 10 THEN
            LEAVE number_loop;
        END IF;

        SELECT v_counter AS number,
               'PlayStore Application' AS message;

        SET v_counter = v_counter + 1;
    END LOOP;
END //

DELIMITER ;

CALL display_numbers_loop();


-- QUESTION 1B
-- WHILE LOOP: display numbers 1 to 10

DROP PROCEDURE IF EXISTS display_numbers_while;

DELIMITER //

CREATE PROCEDURE display_numbers_while()
BEGIN
    DECLARE v_counter INT DEFAULT 1;

    WHILE v_counter <= 10 DO
        SELECT v_counter AS number,
               'PlayStore Application' AS message;

        SET v_counter = v_counter + 1;
    END WHILE;
END //

DELIMITER ;

CALL display_numbers_while();


-- QUESTION 1C
-- REPEAT LOOP: display numbers 1 to 10

DROP PROCEDURE IF EXISTS display_numbers_repeat;

DELIMITER //

CREATE PROCEDURE display_numbers_repeat()
BEGIN
    DECLARE v_counter INT DEFAULT 1;

    REPEAT
        SELECT v_counter AS number,
               'PlayStore Application' AS message;

        SET v_counter = v_counter + 1;
    UNTIL v_counter > 10
    END REPEAT;
END //

DELIMITER ;

CALL display_numbers_repeat();


-- QUESTION 2
-- Cursor-based application processing

DROP PROCEDURE IF EXISTS display_all_applications;

DELIMITER //

CREATE PROCEDURE display_all_applications()
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_id INT;
    DECLARE v_name VARCHAR(60);
    DECLARE v_rating DECIMAL(2,1);
    DECLARE v_price DECIMAL(6,2);
    DECLARE v_downloads BIGINT;

    DECLARE app_cursor CURSOR FOR
        SELECT AppID, AppName, Rating, Price, Downloads
        FROM Apps;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;

    OPEN app_cursor;

    read_loop: LOOP
        FETCH app_cursor
        INTO v_id, v_name, v_rating, v_price, v_downloads;

        IF v_done = 1 THEN
            LEAVE read_loop;
        END IF;

        SELECT v_id AS AppID,
               v_name AS AppName,
               v_rating AS Rating,
               v_price AS Price,
               v_downloads AS Downloads;
    END LOOP;

    CLOSE app_cursor;
END //

DELIMITER ;

CALL display_all_applications();


-- QUESTION 3
-- Procedure: update_app_rating
-- Checks application existence and validates rating from 0 to 5

DROP PROCEDURE IF EXISTS update_app_rating;

DELIMITER //

CREATE PROCEDURE update_app_rating(
    IN p_application_id INT,
    IN p_new_rating DECIMAL(2,1)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_count
    FROM Apps
    WHERE AppID = p_application_id;

    IF v_count = 0 THEN
        SELECT 'Application not found' AS message;

    ELSEIF p_new_rating IS NULL
           OR p_new_rating < 0
           OR p_new_rating > 5 THEN
        SELECT 'Invalid application rating' AS message;

    ELSE
        UPDATE Apps
        SET Rating = p_new_rating
        WHERE AppID = p_application_id;

        SELECT AppID, AppName, Rating
        FROM Apps
        WHERE AppID = p_application_id;
    END IF;
END //

DELIMITER ;

-- Example valid update (uncomment to execute)
-- CALL update_app_rating(1001, 4.8);

-- Invalid rating test
CALL update_app_rating(1001, 6);

-- Missing application test
CALL update_app_rating(9999, 4.5);


-- QUESTION 4
-- INOUT procedure: update_download_count

DROP PROCEDURE IF EXISTS update_download_count;

DELIMITER //

CREATE PROCEDURE update_download_count(
    IN p_application_id INT,
    IN p_additional_downloads BIGINT,
    INOUT p_total_downloads BIGINT
)
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_existing_downloads BIGINT;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;

    SELECT Downloads
    INTO v_existing_downloads
    FROM Apps
    WHERE AppID = p_application_id;

    IF v_done = 1 THEN
        SELECT 'Application not found' AS message;
    ELSE
        SET p_total_downloads =
            v_existing_downloads + p_additional_downloads;

        UPDATE Apps
        SET Downloads = p_total_downloads
        WHERE AppID = p_application_id;

        SELECT p_total_downloads AS updated_download_count;
    END IF;
END //

DELIMITER ;

-- Test INOUT parameter
SET @total_downloads = 0;

CALL update_download_count(1001, 1000, @total_downloads);

SELECT @total_downloads AS final_download_count;


-- QUESTION 5
-- Application exception handling with NOT FOUND and SQLEXCEPTION

DROP PROCEDURE IF EXISTS application_exception_handling;

DELIMITER //

CREATE PROCEDURE application_exception_handling(IN p_application_id INT)
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_name VARCHAR(60);
    DECLARE v_rating DECIMAL(2,1);
    DECLARE v_price DECIMAL(6,2);
    DECLARE v_downloads BIGINT;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'An SQL exception occurred' AS message;
    END;

    SELECT AppName, Rating, Price, Downloads
    INTO v_name, v_rating, v_price, v_downloads
    FROM Apps
    WHERE AppID = p_application_id;

    IF v_done = 1 THEN
        SELECT 'Application not found' AS message;
    ELSE
        SELECT v_name AS application_name,
               v_rating AS rating,
               v_price AS price,
               v_downloads AS downloads;
    END IF;
END //

DELIMITER ;

CALL application_exception_handling(1001);
CALL application_exception_handling(9999);

-- 9. LEVEL 3 QUESTIONS

-- QUESTION 1
-- Complete application processing report

DROP PROCEDURE IF EXISTS process_application;

DELIMITER //

CREATE PROCEDURE process_application(IN p_application_id INT)
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_app_id INT;
    DECLARE v_app_name VARCHAR(60);
    DECLARE v_rating DECIMAL(2,1);
    DECLARE v_price DECIMAL(6,2);
    DECLARE v_downloads BIGINT;
    DECLARE v_developer VARCHAR(60);
    DECLARE v_publisher VARCHAR(60);
    DECLARE v_category VARCHAR(40);
    DECLARE v_rating_category VARCHAR(30);
    DECLARE v_price_category VARCHAR(40);

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;

    SELECT A.AppID, A.AppName, A.Rating, A.Price, A.Downloads,
           D.DeveloperName, P.PublisherName, C.CategoryName
    INTO v_app_id, v_app_name, v_rating, v_price, v_downloads,
         v_developer, v_publisher, v_category
    FROM Apps A
    JOIN Developers D ON A.DeveloperID = D.DeveloperID
    JOIN Publishers P ON A.PublisherID = P.PublisherID
    JOIN Categories C ON A.CategoryID = C.CategoryID
    WHERE A.AppID = p_application_id;

    IF v_done = 1 THEN
        SELECT 'Application not found' AS message;
    ELSE
        SET v_rating_category = classify_rating(v_rating);
        SET v_price_category = classify_app_price(v_price);

        SELECT
            'APPLICATION DETAILS REPORT' AS report_title,
            v_app_id AS application_id,
            v_app_name AS application_name,
            v_developer AS developer_name,
            v_publisher AS publisher_name,
            v_category AS category_name,
            v_rating AS rating,
            v_rating_category AS rating_category,
            v_price AS price,
            v_price_category AS price_category,
            v_downloads AS downloads;
    END IF;
END //

DELIMITER ;

CALL process_application(1001);
CALL process_application(9999);


-- QUESTION 2
-- Developer application cursor processing

DROP PROCEDURE IF EXISTS developer_application_cursor;

DELIMITER //

CREATE PROCEDURE developer_application_cursor()
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_developer_id INT;
    DECLARE v_developer_name VARCHAR(60);
    DECLARE v_app_count INT;
    DECLARE v_average_rating DECIMAL(4,2);
    DECLARE v_total_downloads BIGINT;

    DECLARE developer_cursor CURSOR FOR
        SELECT D.DeveloperID,
               D.DeveloperName,
               COUNT(A.AppID),
               AVG(A.Rating),
               COALESCE(SUM(A.Downloads), 0)
        FROM Developers D
        JOIN Apps A ON D.DeveloperID = A.DeveloperID
        GROUP BY D.DeveloperID, D.DeveloperName;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;

    OPEN developer_cursor;

    read_loop: LOOP
        FETCH developer_cursor
        INTO v_developer_id, v_developer_name,
             v_app_count, v_average_rating, v_total_downloads;

        IF v_done = 1 THEN
            LEAVE read_loop;
        END IF;

        SELECT v_developer_id AS developer_id,
               v_developer_name AS developer_name,
               v_app_count AS number_of_applications,
               v_average_rating AS average_application_rating,
               v_total_downloads AS total_downloads;
    END LOOP;

    CLOSE developer_cursor;
END //

DELIMITER ;

CALL developer_application_cursor();

-- QUESTION 3
-- Combined function and cursor
-- Uses get_developer_app_count() for every developer

DROP PROCEDURE IF EXISTS developer_portfolio_cursor;

DELIMITER //

CREATE PROCEDURE developer_portfolio_cursor()
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_developer_id INT;
    DECLARE v_developer_name VARCHAR(60);
    DECLARE v_count INT;
    DECLARE v_category VARCHAR(30);

    DECLARE developer_cursor CURSOR FOR
        SELECT DeveloperID, DeveloperName
        FROM Developers;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;

    OPEN developer_cursor;

    read_loop: LOOP
        FETCH developer_cursor
        INTO v_developer_id, v_developer_name;

        IF v_done = 1 THEN
            LEAVE read_loop;
        END IF;

        SET v_count = get_developer_app_count(v_developer_id);

        IF v_count = 0 THEN
            SET v_category = 'No Applications';
        ELSEIF v_count <= 2 THEN
            SET v_category = 'Small Portfolio';
        ELSE
            SET v_category = 'Large Portfolio';
        END IF;

        SELECT v_developer_id AS developer_id,
               v_developer_name AS developer_name,
               v_count AS application_count,
               v_category AS developer_application_category;
    END LOOP;

    CLOSE developer_cursor;
END //

DELIMITER ;

CALL developer_portfolio_cursor();

-- END OF LAB TASK 9 - MYSQL STORED PROGRAMS
