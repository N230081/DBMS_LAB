SET SERVEROUTPUT ON;

-- =========================================
-- 1. DEVELOPERS TABLE
-- =========================================

CREATE TABLE Developers (
    DeveloperID NUMBER(10) PRIMARY KEY,
    DeveloperName VARCHAR2(60) NOT NULL,
    Country VARCHAR2(30),
    FoundedYear NUMBER(4)
);

-- =========================================
-- 2. PUBLISHERS TABLE
-- =========================================

CREATE TABLE Publishers (
    PublisherID NUMBER(10) PRIMARY KEY,
    PublisherName VARCHAR2(60),
    HeadOffice VARCHAR2(40),
    SupportEmail VARCHAR2(60)
);

-- =========================================
-- 3. CATEGORIES TABLE
-- =========================================

CREATE TABLE Categories (
    CategoryID NUMBER(10) PRIMARY KEY,
    CategoryName VARCHAR2(40),
    MinimumAge NUMBER(3)
);

-- =========================================
-- 4. APPS TABLE
-- =========================================

CREATE TABLE Apps (
    AppID NUMBER(10) PRIMARY KEY,
    AppName VARCHAR2(60),
    DeveloperID NUMBER(10),
    PublisherID NUMBER(10),
    CategoryID NUMBER(10),
    Rating NUMBER(2,1),
    Downloads NUMBER(12),
    Price NUMBER(6,2)
);

-- 1. INSERT DEVELOPERS

INSERT INTO Developers VALUES (101, 'Google LLC', 'USA', 1998);
INSERT INTO Developers VALUES (102, 'Meta Platforms', 'USA', 2004);
INSERT INTO Developers VALUES (103, 'Spotify AB', 'Sweden', 2006);
INSERT INTO Developers VALUES (104, 'Canva Pty Ltd', 'Australia', 2012);
INSERT INTO Developers VALUES (105, 'BYJUS', 'India', 2011);


-- 2. INSERT PUBLISHERS

INSERT INTO Publishers VALUES (201, 'Google Play', 'California', 'support@google.com');
INSERT INTO Publishers VALUES (202, 'Samsung Galaxy Store', 'Seoul', 'support@samsung.com');
INSERT INTO Publishers VALUES (203, 'Huawei AppGallery', 'Shenzhen', 'support@huawei.com');
INSERT INTO Publishers VALUES (204, 'Amazon Appstore', 'Seattle', 'support@amazon.com');


-- 3. INSERT CATEGORIES

INSERT INTO Categories VALUES (301, 'Education', 3);
INSERT INTO Categories VALUES (302, 'Productivity', 3);
INSERT INTO Categories VALUES (303, 'Music', 12);
INSERT INTO Categories VALUES (304, 'Social', 13);
INSERT INTO Categories VALUES (305, 'Gaming', 16);

-- INSERT APPLICATION RECORDS

INSERT INTO Apps VALUES
(1001, 'Google Classroom', 101, 201, 301, 4.6, 500000000, 0);

INSERT INTO Apps VALUES
(1002, 'Google Keep', 101, 201, 302, 4.5, 1000000000, 0);

INSERT INTO Apps VALUES
(1003, 'Instagram', 102, 201, 304, 4.4, 5000000000, 0);

INSERT INTO Apps VALUES
(1004, 'Spotify', 103, 201, 303, 4.5, 1000000000, 0);

INSERT INTO Apps VALUES
(1005, 'Canva', 104, 201, 302, 4.7, 500000000, 0);

INSERT INTO Apps VALUES
(1006, 'BYJU''S Learning', 105, 201, 301, 4.3, 100000000, 299);

INSERT INTO Apps VALUES
(1007, 'Candy Crush', 102, 204, 305, 4.6, 1000000000, 0);

INSERT INTO Apps VALUES
(1008, 'Temple Run', 104, 203, 305, 4.2, 500000000, 0);

COMMIT;

SELECT 'DEVELOPERS' AS TABLE_NAME, COUNT(*) AS TOTAL_RECORDS
FROM Developers

UNION ALL

SELECT 'PUBLISHERS', COUNT(*) FROM Publishers

UNION ALL

SELECT 'CATEGORIES', COUNT(*) FROM Categories

UNION ALL

SELECT 'APPS', COUNT(*) FROM Apps;


-- ============================================================
-- DBMS LAB TASK 8 - ORACLE PL/SQL
-- Database: PlayStoreDB
-- File: week8_plsql_oracle.sql
-- ============================================================

SET SERVEROUTPUT ON;

-- ============================================================
-- PART A - GETTING STARTED
-- ============================================================

-- TASK 1: Welcome message

BEGIN
    DBMS_OUTPUT.PUT_LINE('Welcome to PlayStoreDB');
END;
/

-- TASK 3: Retrieve application name and rating using variables

DECLARE
    v_app_name Apps.AppName%TYPE;
    v_rating   Apps.Rating%TYPE;
BEGIN
    SELECT AppName, Rating
    INTO v_app_name, v_rating
    FROM Apps
    WHERE AppID = 1001;

    DBMS_OUTPUT.PUT_LINE('Application Name: ' || v_app_name);
    DBMS_OUTPUT.PUT_LINE('Application Rating: ' || v_rating);
END;
/

-- TASK 5: Procedure to retrieve application rating

CREATE OR REPLACE PROCEDURE oracle_get_app_rating(
    p_app_id IN Apps.AppID%TYPE
)
IS
    v_app_name Apps.AppName%TYPE;
    v_rating   Apps.Rating%TYPE;
BEGIN
    SELECT AppName, Rating
    INTO v_app_name, v_rating
    FROM Apps
    WHERE AppID = p_app_id;

    DBMS_OUTPUT.PUT_LINE('Application Name: ' || v_app_name);
    DBMS_OUTPUT.PUT_LINE('Application Rating: ' || v_rating);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
END;
/

-- Execute Task 5 procedure

BEGIN
    oracle_get_app_rating(1001);
END;
/

-- ============================================================
-- LEVEL 0
-- ============================================================

-- QUESTION 1: Calculate 10% of application price

DECLARE
    v_price Apps.Price%TYPE;
    v_discount NUMBER(10,2);
BEGIN
    SELECT Price
    INTO v_price
    FROM Apps
    WHERE AppID = 1006;

    v_discount := v_price * 0.10;

    DBMS_OUTPUT.PUT_LINE('Application Price: ' || v_price);
    DBMS_OUTPUT.PUT_LINE('10% of Price: ' || v_discount);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
END;
/

-- QUESTION 2: Procedure to display application details

CREATE OR REPLACE PROCEDURE display_application_details(
    p_app_id IN Apps.AppID%TYPE
)
IS
    v_app_name Apps.AppName%TYPE;
    v_rating   Apps.Rating%TYPE;
    v_price    Apps.Price%TYPE;
    v_downloads Apps.Downloads%TYPE;
BEGIN
    SELECT AppName, Rating, Price, Downloads
    INTO v_app_name, v_rating, v_price, v_downloads
    FROM Apps
    WHERE AppID = p_app_id;

    DBMS_OUTPUT.PUT_LINE('Application Name: ' || v_app_name);
    DBMS_OUTPUT.PUT_LINE('Rating: ' || v_rating);
    DBMS_OUTPUT.PUT_LINE('Price: ' || v_price);
    DBMS_OUTPUT.PUT_LINE('Downloads: ' || v_downloads);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
END;
/

-- Execute Question 2

BEGIN
    display_application_details(1001);
END;
/

-- QUESTION 3: Rating classification

DECLARE
    v_rating Apps.Rating%TYPE;
    v_app_id Apps.AppID%TYPE := 1001;
BEGIN
    SELECT Rating
    INTO v_rating
    FROM Apps
    WHERE AppID = v_app_id;

    IF v_rating >= 4.5 THEN
        DBMS_OUTPUT.PUT_LINE('Highly Rated');

    ELSIF v_rating >= 3.5 THEN
        DBMS_OUTPUT.PUT_LINE('Moderately Rated');

    ELSE
        DBMS_OUTPUT.PUT_LINE('Low Rated');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
END;
/

-- QUESTION 4: Function to classify application price

CREATE OR REPLACE FUNCTION classify_application_price(
    p_price IN Apps.Price%TYPE
)
RETURN VARCHAR2
IS
BEGIN
    IF p_price > 0 THEN
        RETURN 'Paid Application';
    ELSE
        RETURN 'Free Application';
    END IF;
END;
/

-- Test Question 4

BEGIN
    DBMS_OUTPUT.PUT_LINE(
        classify_application_price(299)
    );

    DBMS_OUTPUT.PUT_LINE(
        classify_application_price(0)
    );
END;
/

-- QUESTION 5: Loop to display numbers from 1 to 10

DECLARE
    v_counter NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_counter);

        v_counter := v_counter + 1;

        EXIT WHEN v_counter > 10;
    END LOOP;
END;
/

-- ============================================================
-- LEVEL 1
-- ============================================================

-- QUESTION 1: classify_application_rating procedure

CREATE OR REPLACE PROCEDURE classify_application_rating(
    p_app_id IN Apps.AppID%TYPE
)
IS
    v_rating Apps.Rating%TYPE;
BEGIN
    SELECT Rating
    INTO v_rating
    FROM Apps
    WHERE AppID = p_app_id;

    IF v_rating >= 4.5 THEN
        DBMS_OUTPUT.PUT_LINE('Excellent Application');

    ELSIF v_rating >= 4.0 THEN
        DBMS_OUTPUT.PUT_LINE('Good Application');

    ELSIF v_rating >= 3.5 THEN
        DBMS_OUTPUT.PUT_LINE('Average Application');

    ELSE
        DBMS_OUTPUT.PUT_LINE('Low Rated Application');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
END;
/

-- Execute Question 1

BEGIN
    classify_application_rating(1001);
END;
/

-- QUESTION 2: Function to retrieve application rating

CREATE OR REPLACE FUNCTION get_application_rating(
    p_app_id IN Apps.AppID%TYPE
)
RETURN Apps.Rating%TYPE
IS
    v_rating Apps.Rating%TYPE;
BEGIN
    SELECT Rating
    INTO v_rating
    FROM Apps
    WHERE AppID = p_app_id;

    RETURN v_rating;
END;
/

-- Display all applications using the function

SELECT
    AppID,
    AppName,
    get_application_rating(AppID) AS Application_Rating
FROM Apps
ORDER BY AppID;

-- ============================================================
-- LEVEL 2
-- ============================================================

-- QUESTION 1: Explicit cursor to display all applications

DECLARE
    CURSOR app_cursor IS
        SELECT AppName, Rating, Price, Downloads
        FROM Apps
        ORDER BY AppID;

    v_app_name Apps.AppName%TYPE;
    v_rating Apps.Rating%TYPE;
    v_price Apps.Price%TYPE;
    v_downloads Apps.Downloads%TYPE;

BEGIN
    OPEN app_cursor;

    IF app_cursor%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('Cursor is open');
    END IF;

    LOOP
        FETCH app_cursor
        INTO v_app_name, v_rating, v_price, v_downloads;

        EXIT WHEN app_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Name: ' || v_app_name ||
            ' | Rating: ' || v_rating ||
            ' | Price: ' || v_price ||
            ' | Downloads: ' || v_downloads
        );

    END LOOP;

    DBMS_OUTPUT.PUT_LINE(
        'Total Records: ' || app_cursor%ROWCOUNT
    );

    IF app_cursor%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('All records processed');
    END IF;

    CLOSE app_cursor;
END;
/

-- QUESTION 2: Exception handling procedure

CREATE OR REPLACE PROCEDURE find_application(
    p_app_id IN Apps.AppID%TYPE
)
IS
    v_app_name Apps.AppName%TYPE;
    v_rating Apps.Rating%TYPE;
    v_price Apps.Price%TYPE;
BEGIN
    SELECT AppName, Rating, Price
    INTO v_app_name, v_rating, v_price
    FROM Apps
    WHERE AppID = p_app_id;

    DBMS_OUTPUT.PUT_LINE('Application Name: ' || v_app_name);
    DBMS_OUTPUT.PUT_LINE('Rating: ' || v_rating);
    DBMS_OUTPUT.PUT_LINE('Price: ' || v_price);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');

    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Multiple applications found');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

-- Test with existing application

BEGIN
    find_application(1001);
END;
/

-- Test with non-existing application

BEGIN
    find_application(9999);
END;
/

-- ============================================================
-- OPTIONAL QUESTIONS
-- ============================================================

-- OPTIONAL QUESTION 1:
-- Update application rating procedure

CREATE OR REPLACE PROCEDURE update_application_rating(
    p_app_id IN Apps.AppID%TYPE,
    p_new_rating IN Apps.Rating%TYPE
)
IS
    v_app_name Apps.AppName%TYPE;
    v_rating Apps.Rating%TYPE;
BEGIN
    SELECT AppName
    INTO v_app_name
    FROM Apps
    WHERE AppID = p_app_id;

    UPDATE Apps
    SET Rating = p_new_rating
    WHERE AppID = p_app_id;

    COMMIT;

    SELECT AppName, Rating
    INTO v_app_name, v_rating
    FROM Apps
    WHERE AppID = p_app_id;

    DBMS_OUTPUT.PUT_LINE('Application Name: ' || v_app_name);
    DBMS_OUTPUT.PUT_LINE('Updated Rating: ' || v_rating);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');

    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Example execution (uncomment only when you want to update)
-- BEGIN
--     update_application_rating(1001, 4.8);
-- END;
-- /

-- OPTIONAL QUESTION 2:
-- CASE statement to classify rating

CREATE OR REPLACE PROCEDURE classify_rating_case(
    p_rating IN Apps.Rating%TYPE
)
IS
    v_category VARCHAR2(30);
BEGIN
    v_category :=
        CASE
            WHEN p_rating >= 4.5 THEN 'Excellent'
            WHEN p_rating >= 4.0 THEN 'Good'
            WHEN p_rating >= 3.5 THEN 'Average'
            ELSE 'Low Rated'
        END;

    DBMS_OUTPUT.PUT_LINE('Rating Category: ' || v_category);
END;
/

-- Test CASE procedure

BEGIN
    classify_rating_case(4.7);
END;
/

-- OPTIONAL QUESTION 3:
-- Display application and developer details

CREATE OR REPLACE PROCEDURE application_developer_details(
    p_app_id IN Apps.AppID%TYPE
)
IS
    v_app_name Apps.AppName%TYPE;
    v_rating Apps.Rating%TYPE;
    v_price Apps.Price%TYPE;
    v_developer_id Developers.DeveloperID%TYPE;
    v_developer_name Developers.DeveloperName%TYPE;
    v_country Developers.Country%TYPE;
BEGIN
    SELECT
        A.AppName,
        A.Rating,
        A.Price,
        D.DeveloperID,
        D.DeveloperName,
        D.Country
    INTO
        v_app_name,
        v_rating,
        v_price,
        v_developer_id,
        v_developer_name,
        v_country
    FROM Apps A
    JOIN Developers D
    ON A.DeveloperID = D.DeveloperID
    WHERE A.AppID = p_app_id;

    DBMS_OUTPUT.PUT_LINE('App ID: ' || p_app_id);
    DBMS_OUTPUT.PUT_LINE('App Name: ' || v_app_name);
    DBMS_OUTPUT.PUT_LINE('Rating: ' || v_rating);
    DBMS_OUTPUT.PUT_LINE('Price: ' || v_price);
    DBMS_OUTPUT.PUT_LINE('Developer ID: ' || v_developer_id);
    DBMS_OUTPUT.PUT_LINE('Developer Name: ' || v_developer_name);
    DBMS_OUTPUT.PUT_LINE('Country: ' || v_country);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
END;
/

-- Test optional Question 3

BEGIN
    application_developer_details(1001);
END;
/

-- OPTIONAL QUESTION 4:
-- Cursor FOR LOOP to display all applications

BEGIN
    FOR app_rec IN (
        SELECT AppID, AppName, Rating, Downloads
        FROM Apps
        ORDER BY AppID
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'App ID: ' || app_rec.AppID ||
            ' | Name: ' || app_rec.AppName ||
            ' | Rating: ' || app_rec.Rating ||
            ' | Downloads: ' || app_rec.Downloads
        );
    END LOOP;
END;
/

-- OPTIONAL QUESTION 5:
-- Function to classify application rating

CREATE OR REPLACE FUNCTION classify_rating_value(
    p_rating IN Apps.Rating%TYPE
)
RETURN VARCHAR2
IS
BEGIN
    IF p_rating IS NULL THEN
        RETURN 'Not Rated';

    ELSIF p_rating >= 4.5 THEN
        RETURN 'Excellent';

    ELSIF p_rating >= 4.0 THEN
        RETURN 'Good';

    ELSIF p_rating >= 3.5 THEN
        RETURN 'Average';

    ELSE
        RETURN 'Low Rated';
    END IF;
END;
/

-- Display all applications with rating classification

SELECT
    AppID,
    AppName,
    Rating,
    classify_rating_value(Rating) AS Rating_Category
FROM Apps
ORDER BY AppID;

-- ============================================================
-- END OF DBMS LAB TASK 8 - ORACLE PL/SQL
-- ============================================================

