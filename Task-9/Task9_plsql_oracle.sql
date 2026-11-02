-- ============================================================
-- DBMS LAB TASK 9 - ORACLE PL/SQL
-- Database: PlayStoreDB
-- File: week9_plsql_oracle.sql
-- ============================================================

SET SERVEROUTPUT ON;

-- Verify tables and records
SELECT * FROM Developers;
SELECT * FROM Publishers;
SELECT * FROM Categories;
SELECT * FROM Apps;

-- ============================================================
-- 6. MEDIUM-LEVEL ACTIVITIES
-- ============================================================

-- PART A - TASK 1
-- Function: classify_rating

CREATE OR REPLACE FUNCTION classify_rating(
    p_rating NUMBER
)
RETURN VARCHAR2
IS
BEGIN
    IF p_rating IS NULL THEN
        RETURN 'Not Rated';
    ELSIF p_rating >= 4.5 THEN
        RETURN 'Excellent';
    ELSIF p_rating >= 4.0 THEN
        RETURN 'Very Good';
    ELSIF p_rating >= 3.0 THEN
        RETURN 'Good';
    ELSE
        RETURN 'Needs Improvement';
    END IF;
END;
/

-- Test the function with five values including NULL
SELECT classify_rating(4.8) AS result FROM DUAL;
SELECT classify_rating(4.2) AS result FROM DUAL;
SELECT classify_rating(3.5) AS result FROM DUAL;
SELECT classify_rating(2.5) AS result FROM DUAL;
SELECT classify_rating(NULL) AS result FROM DUAL;

-- PART B - TASK 2
-- Procedure: application_details

CREATE OR REPLACE PROCEDURE application_details(
    p_application_id IN NUMBER
)
IS
    v_app_id Apps.AppID%TYPE;
    v_app_name Apps.AppName%TYPE;
    v_rating Apps.Rating%TYPE;
    v_price Apps.Price%TYPE;
    v_downloads Apps.Downloads%TYPE;
    v_developer_name Developers.DeveloperName%TYPE;
    v_publisher_name Publishers.PublisherName%TYPE;
    v_category_name Categories.CategoryName%TYPE;

BEGIN
    SELECT A.AppID, A.AppName, A.Rating, A.Price, A.Downloads,
           D.DeveloperName, P.PublisherName, C.CategoryName
    INTO v_app_id, v_app_name, v_rating, v_price, v_downloads,
         v_developer_name, v_publisher_name, v_category_name
    FROM Apps A
    JOIN Developers D ON A.DeveloperID = D.DeveloperID
    JOIN Publishers P ON A.PublisherID = P.PublisherID
    JOIN Categories C ON A.CategoryID = C.CategoryID
    WHERE A.AppID = p_application_id;

    DBMS_OUTPUT.PUT_LINE('Application ID: ' || v_app_id);
    DBMS_OUTPUT.PUT_LINE('Application Name: ' || v_app_name);
    DBMS_OUTPUT.PUT_LINE('Rating: ' || v_rating);
    DBMS_OUTPUT.PUT_LINE('Price: ' || v_price);
    DBMS_OUTPUT.PUT_LINE('Downloads: ' || v_downloads);
    DBMS_OUTPUT.PUT_LINE('Developer: ' || v_developer_name);
    DBMS_OUTPUT.PUT_LINE('Publisher: ' || v_publisher_name);
    DBMS_OUTPUT.PUT_LINE('Category: ' || v_category_name);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
END;
/

EXEC application_details(1001);
EXEC application_details(9999);

-- PART C - TASK 3
-- Function: get_developer_app_count

CREATE OR REPLACE FUNCTION get_developer_app_count(
    p_developer_id NUMBER
)
RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM Apps
    WHERE DeveloperID = p_developer_id;

    RETURN v_count;
END;
/

-- Display application count for all developers
SELECT D.DeveloperID,
       D.DeveloperName,
       get_developer_app_count(D.DeveloperID) AS Number_Of_Applications
FROM Developers D;


-- ============================================================
-- 7. LEVEL 1 QUESTIONS
-- ============================================================

-- QUESTION 1
-- Procedure: category_application_summary

CREATE OR REPLACE PROCEDURE category_application_summary(
    p_category_id IN NUMBER
)
IS
    v_category_name Categories.CategoryName%TYPE;
    v_total NUMBER;
    v_free NUMBER;
    v_paid NUMBER;
    v_average_rating NUMBER;
BEGIN
    SELECT CategoryName
    INTO v_category_name
    FROM Categories
    WHERE CategoryID = p_category_id;

    SELECT COUNT(*),
           NVL(SUM(CASE WHEN Price = 0 THEN 1 ELSE 0 END), 0),
           NVL(SUM(CASE WHEN Price > 0 THEN 1 ELSE 0 END), 0),
           AVG(Rating)
    INTO v_total, v_free, v_paid, v_average_rating
    FROM Apps
    WHERE CategoryID = p_category_id;

    DBMS_OUTPUT.PUT_LINE('Category Name: ' || v_category_name);
    DBMS_OUTPUT.PUT_LINE('Total Applications: ' || v_total);
    DBMS_OUTPUT.PUT_LINE('Free Applications: ' || v_free);
    DBMS_OUTPUT.PUT_LINE('Paid Applications: ' || v_paid);
    DBMS_OUTPUT.PUT_LINE('Average Rating: ' || NVL(TO_CHAR(v_average_rating), 'Not Available'));

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Category not found');
END;
/

EXEC category_application_summary(301);
EXEC category_application_summary(999);


-- QUESTION 2
-- Function: classify_app_price

CREATE OR REPLACE FUNCTION classify_app_price(
    p_price NUMBER
)
RETURN VARCHAR2
IS
BEGIN
    IF p_price = 0 THEN
        RETURN 'Free';
    ELSIF p_price <= 100 THEN
        RETURN 'Budget';
    ELSIF p_price <= 500 THEN
        RETURN 'Premium';
    ELSE
        RETURN 'High Premium';
    END IF;
END;
/

SELECT AppID,
       AppName,
       Price,
       classify_app_price(Price) AS Price_Category
FROM Apps;


-- QUESTION 3
-- Procedure: application_rating_decision

CREATE OR REPLACE PROCEDURE application_rating_decision(
    p_app_id IN NUMBER
)
IS
    v_rating Apps.Rating%TYPE;
BEGIN
    SELECT Rating
    INTO v_rating
    FROM Apps
    WHERE AppID = p_app_id;

    IF v_rating IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Rating Not Available');
    ELSIF v_rating >= 4.5 THEN
        DBMS_OUTPUT.PUT_LINE('Highly Rated Application');
    ELSIF v_rating >= 4.0 THEN
        DBMS_OUTPUT.PUT_LINE('Good Application');
    ELSIF v_rating >= 3.0 THEN
        DBMS_OUTPUT.PUT_LINE('Average Application');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Low Rated Application');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
END;
/

EXEC application_rating_decision(1001);
EXEC application_rating_decision(9999);


-- ============================================================
-- 8. LEVEL 2 QUESTIONS
-- ============================================================

-- QUESTION 1A
-- Simple LOOP: display numbers 1 to 10

DECLARE
    v_counter NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('Application Number: ' || v_counter);
        v_counter := v_counter + 1;

        EXIT WHEN v_counter > 10;
    END LOOP;
END;
/


-- QUESTION 1B
-- WHILE LOOP: display numbers 1 to 10

DECLARE
    v_counter NUMBER := 1;
BEGIN
    WHILE v_counter <= 10 LOOP
        DBMS_OUTPUT.PUT_LINE('Application Number: ' || v_counter);
        v_counter := v_counter + 1;
    END LOOP;
END;
/


-- QUESTION 1C
-- FOR LOOP: display numbers 1 to 10

BEGIN
    FOR v_counter IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('Application Number: ' || v_counter);
    END LOOP;
END;
/


-- QUESTION 2
-- Explicit cursor with cursor attributes

DECLARE
    CURSOR app_cursor IS
        SELECT AppID, AppName, Rating, Price, Downloads
        FROM Apps;

    v_id Apps.AppID%TYPE;
    v_name Apps.AppName%TYPE;
    v_rating Apps.Rating%TYPE;
    v_price Apps.Price%TYPE;
    v_downloads Apps.Downloads%TYPE;

BEGIN
    OPEN app_cursor;

    IF app_cursor%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('Application cursor is open');
    END IF;

    LOOP
        FETCH app_cursor
        INTO v_id, v_name, v_rating, v_price, v_downloads;

        EXIT WHEN app_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || v_id ||
            ' | Name: ' || v_name ||
            ' | Rating: ' || v_rating ||
            ' | Price: ' || v_price ||
            ' | Downloads: ' || v_downloads
        );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total rows processed: ' || app_cursor%ROWCOUNT);

    CLOSE app_cursor;
END;
/


-- Cursor FOR LOOP

BEGIN
    FOR app_rec IN (
        SELECT AppID, AppName, Rating, Price, Downloads
        FROM Apps
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            app_rec.AppID || ' - ' ||
            app_rec.AppName || ' - ' ||
            app_rec.Rating || ' - ' ||
            app_rec.Price || ' - ' ||
            app_rec.Downloads
        );
    END LOOP;
END;
/


-- QUESTION 3
-- Procedure: update_app_rating
-- Checks existence and validates rating between 0 and 5

CREATE OR REPLACE PROCEDURE update_app_rating(
    p_application_id IN NUMBER,
    p_new_rating IN NUMBER
)
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM Apps
    WHERE AppID = p_application_id;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');

    ELSIF p_new_rating IS NULL OR p_new_rating < 0 OR p_new_rating > 5 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid application rating');

    ELSE
        UPDATE Apps
        SET Rating = p_new_rating
        WHERE AppID = p_application_id;

        DBMS_OUTPUT.PUT_LINE('Application rating updated successfully');

        FOR app_rec IN (
            SELECT AppID, AppName, Rating
            FROM Apps
            WHERE AppID = p_application_id
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE(
                app_rec.AppID || ' - ' ||
                app_rec.AppName || ' - ' ||
                app_rec.Rating
            );
        END LOOP;
    END IF;
END;
/

-- Safe test example; updates rating to 4.8
-- EXEC update_app_rating(1001, 4.8);

-- Invalid rating test
EXEC update_app_rating(1001, 6);

-- Missing application test
EXEC update_app_rating(9999, 4.5);


-- QUESTION 4
-- Procedure: update_download_count
-- IN application ID, IN additional downloads, IN OUT total downloads

CREATE OR REPLACE PROCEDURE update_download_count(
    p_application_id IN NUMBER,
    p_additional_downloads IN NUMBER,
    p_total_downloads IN OUT NUMBER
)
IS
    v_existing_downloads Apps.Downloads%TYPE;
BEGIN
    SELECT Downloads
    INTO v_existing_downloads
    FROM Apps
    WHERE AppID = p_application_id;

    p_total_downloads := v_existing_downloads + p_additional_downloads;

    UPDATE Apps
    SET Downloads = p_total_downloads
    WHERE AppID = p_application_id;

    DBMS_OUTPUT.PUT_LINE('Updated Downloads: ' || p_total_downloads);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
END;
/

-- Test IN OUT parameter
DECLARE
    v_total NUMBER := 0;
BEGIN
    update_download_count(1001, 1000, v_total);
    DBMS_OUTPUT.PUT_LINE('IN OUT Total: ' || v_total);
END;
/


-- QUESTION 5
-- Application exception handling

CREATE OR REPLACE PROCEDURE application_exception_handling(
    p_application_id IN NUMBER
)
IS
    v_name Apps.AppName%TYPE;
    v_rating Apps.Rating%TYPE;
    v_price Apps.Price%TYPE;
    v_downloads Apps.Downloads%TYPE;
BEGIN
    SELECT AppName, Rating, Price, Downloads
    INTO v_name, v_rating, v_price, v_downloads
    FROM Apps
    WHERE AppID = p_application_id;

    DBMS_OUTPUT.PUT_LINE('Application Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Rating: ' || v_rating);
    DBMS_OUTPUT.PUT_LINE('Price: ' || v_price);
    DBMS_OUTPUT.PUT_LINE('Downloads: ' || v_downloads);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');

    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Multiple applications found');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/

EXEC application_exception_handling(1001);
EXEC application_exception_handling(9999);


-- ============================================================
-- 9. LEVEL 3 QUESTIONS
-- ============================================================

-- QUESTION 1
-- Complete application processing report

CREATE OR REPLACE PROCEDURE process_application(
    p_application_id IN NUMBER
)
IS
    v_app_id Apps.AppID%TYPE;
    v_app_name Apps.AppName%TYPE;
    v_rating Apps.Rating%TYPE;
    v_price Apps.Price%TYPE;
    v_downloads Apps.Downloads%TYPE;
    v_developer Developers.DeveloperName%TYPE;
    v_publisher Publishers.PublisherName%TYPE;
    v_category Categories.CategoryName%TYPE;
    v_rating_category VARCHAR2(30);
    v_price_category VARCHAR2(40);

BEGIN
    SELECT A.AppID, A.AppName, A.Rating, A.Price, A.Downloads,
           D.DeveloperName, P.PublisherName, C.CategoryName
    INTO v_app_id, v_app_name, v_rating, v_price, v_downloads,
         v_developer, v_publisher, v_category
    FROM Apps A
    JOIN Developers D ON A.DeveloperID = D.DeveloperID
    JOIN Publishers P ON A.PublisherID = P.PublisherID
    JOIN Categories C ON A.CategoryID = C.CategoryID
    WHERE A.AppID = p_application_id;

    v_rating_category := classify_rating(v_rating);
    v_price_category := classify_app_price(v_price);

    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('       APPLICATION DETAILS REPORT');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Application ID: ' || v_app_id);
    DBMS_OUTPUT.PUT_LINE('Application Name: ' || v_app_name);
    DBMS_OUTPUT.PUT_LINE('Developer Name: ' || v_developer);
    DBMS_OUTPUT.PUT_LINE('Publisher Name: ' || v_publisher);
    DBMS_OUTPUT.PUT_LINE('Category Name: ' || v_category);
    DBMS_OUTPUT.PUT_LINE('Rating: ' || NVL(TO_CHAR(v_rating), 'NULL'));
    DBMS_OUTPUT.PUT_LINE('Rating Category: ' || v_rating_category);
    DBMS_OUTPUT.PUT_LINE('Price: ' || v_price);
    DBMS_OUTPUT.PUT_LINE('Price Category: ' || v_price_category);
    DBMS_OUTPUT.PUT_LINE('Downloads: ' || v_downloads);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
END;
/

EXEC process_application(1001);
EXEC process_application(9999);


-- QUESTION 2
-- Developer application cursor processing

DECLARE
    CURSOR developer_cursor IS
        SELECT D.DeveloperID, D.DeveloperName,
               COUNT(A.AppID) AS app_count,
               AVG(A.Rating) AS average_rating,
               NVL(SUM(A.Downloads), 0) AS total_downloads
        FROM Developers D
        JOIN Apps A ON D.DeveloperID = A.DeveloperID
        GROUP BY D.DeveloperID, D.DeveloperName;

BEGIN
    FOR dev_rec IN developer_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Developer ID: ' || dev_rec.DeveloperID);
        DBMS_OUTPUT.PUT_LINE('Developer Name: ' || dev_rec.DeveloperName);
        DBMS_OUTPUT.PUT_LINE('Number of Applications: ' || dev_rec.app_count);
        DBMS_OUTPUT.PUT_LINE('Average Rating: ' || NVL(TO_CHAR(dev_rec.average_rating), 'Not Available'));
        DBMS_OUTPUT.PUT_LINE('Total Downloads: ' || dev_rec.total_downloads);
        DBMS_OUTPUT.PUT_LINE('--------------------------------');
    END LOOP;
END;
/


-- QUESTION 3
-- Combined function and cursor

DECLARE
    CURSOR developer_cursor IS
        SELECT DeveloperID, DeveloperName
        FROM Developers;

    v_count NUMBER;
    v_category VARCHAR2(30);

BEGIN
    FOR dev_rec IN developer_cursor LOOP

        v_count := get_developer_app_count(dev_rec.DeveloperID);

        IF v_count = 0 THEN
            v_category := 'No Applications';
        ELSIF v_count <= 2 THEN
            v_category := 'Small Portfolio';
        ELSE
            v_category := 'Large Portfolio';
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            'Developer ID: ' || dev_rec.DeveloperID ||
            ' | Name: ' || dev_rec.DeveloperName ||
            ' | Application Count: ' || v_count ||
            ' | Category: ' || v_category
        );
    END LOOP;
END;
/


-- ============================================================
-- 10. CHALLENGE QUESTION
-- PlayStore Application Processing Report
-- Oracle PL/SQL implementation as specified in the PDF
-- ============================================================

CREATE OR REPLACE PROCEDURE generate_application_report
IS
    CURSOR report_cursor IS
        SELECT A.AppID, A.AppName, D.DeveloperName,
               C.CategoryName, A.Rating, A.Price, A.Downloads
        FROM Apps A
        JOIN Developers D ON A.DeveloperID = D.DeveloperID
        JOIN Categories C ON A.CategoryID = C.CategoryID;

    v_rating_category VARCHAR2(30);
    v_price_category VARCHAR2(40);

    v_total_apps NUMBER := 0;
    v_free_apps NUMBER := 0;
    v_paid_apps NUMBER := 0;
    v_highly_rated NUMBER := 0;
    v_total_downloads NUMBER := 0;

BEGIN
    DBMS_OUTPUT.PUT_LINE('==============================================');
    DBMS_OUTPUT.PUT_LINE('       PLAYSTORE APPLICATION REPORT');
    DBMS_OUTPUT.PUT_LINE('==============================================');

    FOR app_rec IN report_cursor LOOP

        v_rating_category := classify_rating(app_rec.Rating);
        v_price_category := classify_app_price(app_rec.Price);

        v_total_apps := v_total_apps + 1;
        v_total_downloads := v_total_downloads + NVL(app_rec.Downloads, 0);

        IF app_rec.Price = 0 THEN
            v_free_apps := v_free_apps + 1;
        ELSE
            v_paid_apps := v_paid_apps + 1;
        END IF;

        IF app_rec.Rating >= 4.5 THEN
            v_highly_rated := v_highly_rated + 1;
        END IF;

        DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Application ID: ' || app_rec.AppID);
        DBMS_OUTPUT.PUT_LINE('Application Name: ' || app_rec.AppName);
        DBMS_OUTPUT.PUT_LINE('Developer Name: ' || app_rec.DeveloperName);
        DBMS_OUTPUT.PUT_LINE('Category Name: ' || app_rec.CategoryName);
        DBMS_OUTPUT.PUT_LINE('Application Rating: ' || NVL(TO_CHAR(app_rec.Rating), 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Rating Category: ' || v_rating_category);
        DBMS_OUTPUT.PUT_LINE('Application Price: ' || app_rec.Price);
        DBMS_OUTPUT.PUT_LINE('Price Category: ' || v_price_category);
        DBMS_OUTPUT.PUT_LINE('Downloads: ' || app_rec.Downloads);

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('==============================================');
    DBMS_OUTPUT.PUT_LINE('             FINAL SUMMARY');
    DBMS_OUTPUT.PUT_LINE('==============================================');
    DBMS_OUTPUT.PUT_LINE('Total Applications Processed: ' || v_total_apps);
    DBMS_OUTPUT.PUT_LINE('Total Free Applications: ' || v_free_apps);
    DBMS_OUTPUT.PUT_LINE('Total Paid Applications: ' || v_paid_apps);
    DBMS_OUTPUT.PUT_LINE('Total Highly Rated Applications: ' || v_highly_rated);
    DBMS_OUTPUT.PUT_LINE('Total Downloads: ' || v_total_downloads);
    DBMS_OUTPUT.PUT_LINE('==============================================');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Report generation error: ' || SQLERRM);
END;
/

EXEC generate_application_report;


-- ============================================================
-- END OF LAB TASK 9 - ORACLE PL/SQL
-- ============================================================
