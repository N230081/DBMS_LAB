CREATE DATABASE PlayStoreDB;
USE PlayStoreDB;

CREATE TABLE Developers(
  DeveloperID INT PRIMARY KEY,
  DeveloperName VARCHAR(60) NOT NULL,
  Country VARCHAR(30),
  FoundedYear INT
  );
  
CREATE TABLE Publishers(
PublisherID INT PRIMARY KEY,
PublisherName VARCHAR(60) ,
HeadOffice VARCHAR(40),
SupportEmail VARCHAR(60)
);

CREATE TABLE Categories(
CategoryID INT PRIMARY KEY,
CategoryName VARCHAR(40),
MinimumAge INT
);

CREATE TABLE Apps(
AppID INT PRIMARY KEY,
AppName VARCHAR(60),
DeveloperID INT,
PublisherID INT,
CategoryID INT,
Rating DECIMAL,
Downloads INT,
Price DECIMAL(6.2)
);

INSERT INTO Developers
VALUES
(101,'Google LLC','USA',1998),
(102,'Meta Platforms','USA',2004),
(103,'Spotify AB','Sweden',2006),
(104,'Canva Pty Ltd','Australia',2012),
(105,'BYJU''S','India',2011);

INSERT INTO Publishers
VALUES
(201,'Google Play','california','support@google.com'),
(202,'Samsung Galaxy Store','Seoul','support@samsung.com'),
(203,'Huawai AppGallery','Shenzhen','support@huawei.com'),
(204,'Amazon Appstore','Seattle','support@amazon.com');

INSERT INTO Categories
VALUES
(301,'Education',3),
(302,'Productivy',3),
(303,'Music',12),
(304,'Social',13),
(305,'Gaming',16);

DROP TABLE Apps;
CREATE TABLE Apps(
AppID INT PRIMARY KEY,
AppName VARCHAR(60),
DeveloperID INT,
PublisherID INT,
CategoryID INT,
Rating DECIMAL,
Downloads BIGINT,
Price DECIMAL(6.2)
);
INSERT INTO Apps
VALUES
(1001,'Google Classroom',101,201,301,4.6,500000000,0),
(1002,'Google Keep',101,201,302,4.5,1000000000,0),
(1003,'Instagram',102,201,304,4.4,5000000000,0),
(1004,'Spotify',103,201,303,4.5,1000000000,0),
(1005,'Canva',104,201,302,4.7,500000000,0),
(1006,'BYJU''S Learning',105,201,301,4.3,100000000,299),
(1007,'Candy Crush',102,204,305,4.6,1000000000,0),
(1008,'Temple Run',104,203,305,4.2,500000000,0);

SELECT *FROM Developers;
SELECT *FROM Publishers;
SELECT *FROM Categories;
DESC Apps;

-- level1
-- 1
INSERT INTO Developers
VALUES
(106,'OpenAI','USA',2015);
-- 2
INSERT INTO Categories
VALUES
(306,'Artifical Intelligence',12);
-- 3
INSERT INTO Apps
VALUES
(1009,'ChatGpt',106,201,306,4.9,100000000000,0);
-- 4
UPDATE Apps
SET Rating = 4.5
WHERE AppID=1008;
-- 5
DELETE FROM Developers
WHERE DeveloperID=105;

-- LEVEL2
-- 1
UPDATE Publishers
SET SupportEmail='support@samsunggalaxy.com'
WHERE PublisherID=202;
-- 2
INSERT INTO Apps
VALUES
(1010,'Whatsapp',102,201,304,4.7,4000000000,0),
(1011,'Youtube',101,201,303,4.8,10000000000,0);
-- 3
UPDATE Apps
SET Price=199
WHERE AppID=1006;
-- 4
DELETE FROM Categories
WHERE CategoryID=303;
-- 5
SELECT * FROM Developers;
SELECT * FROM Publishers;
SELECT * FROM Categories;
SELECT * FROM Apps;