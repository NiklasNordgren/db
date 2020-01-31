--
-- Script was generated by Devart dbForge Studio 2019 for MySQL, Version 8.2.23.0
-- Product home page: http://www.devart.com/dbforge/mysql/studio
-- Script date 2020-01-30 16:29:49
-- Server version: 5.7.25
-- Client version: 4.1
--

-- 
-- Disable foreign keys
-- 
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- 
-- Set SQL mode
-- 
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 
-- Set character set the client will use to send SQL statements to the server
--
SET NAMES 'utf8';

--
-- Set default database
--
USE db;

--
-- Drop table `Settings`
--
DROP TABLE IF EXISTS Settings;

--
-- Drop table `User`
--
DROP TABLE IF EXISTS User;

--
-- Drop table `Exam`
--
DROP TABLE IF EXISTS Exam;

--
-- Drop table `Course`
--
DROP TABLE IF EXISTS Course;

--
-- Drop table `Subject`
--
DROP TABLE IF EXISTS Subject;

--
-- Drop table `Academy`
--
DROP TABLE IF EXISTS Academy;

--
-- Set default database
--
USE db;

--
-- Create table `Academy`
--
CREATE TABLE Academy (
  Id INT(11) NOT NULL AUTO_INCREMENT,
  Name VARCHAR(255) NOT NULL,
  Abbreviation VARCHAR(255) NOT NULL,
  unpublished TINYINT(1) NOT NULL,
  PRIMARY KEY (Id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 1,
AVG_ROW_LENGTH = 5461,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `Abbreviation` on table `Academy`
--
ALTER TABLE Academy 
  ADD UNIQUE INDEX Abbreviation(Abbreviation);

--
-- Create index `Name` on table `Academy`
--
ALTER TABLE Academy 
  ADD UNIQUE INDEX Name(Name);

--
-- Create table `Subject`
--
CREATE TABLE Subject (
  Id INT(11) NOT NULL AUTO_INCREMENT,
  Code VARCHAR(2) NOT NULL,
  Name VARCHAR(255) NOT NULL,
  Unpublished TINYINT(1) NOT NULL,
  AcademyId INT(11) NOT NULL,
  PRIMARY KEY (Id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 1,
AVG_ROW_LENGTH = 963,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `Code` on table `Subject`
--
ALTER TABLE Subject 
  ADD UNIQUE INDEX Code(Code);

--
-- Create index `Name` on table `Subject`
--
ALTER TABLE Subject 
  ADD UNIQUE INDEX Name(Name);

--
-- Create foreign key
--
ALTER TABLE Subject 
  ADD CONSTRAINT Subject_ibfk_1 FOREIGN KEY (AcademyId)
    REFERENCES Academy(Id) ON DELETE CASCADE;

--
-- Create table `Course`
--
CREATE TABLE Course (
  Id INT(11) NOT NULL AUTO_INCREMENT,
  Name VARCHAR(255) NOT NULL,
  CourseCode VARCHAR(7) NOT NULL,
  Unpublished TINYINT(1) NOT NULL,
  SubjectId INT(11) NOT NULL,
  PRIMARY KEY (Id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 1,
AVG_ROW_LENGTH = 1489,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `CourseCode` on table `Course`
--
ALTER TABLE Course 
  ADD UNIQUE INDEX CourseCode(CourseCode);

--
-- Create index `Name` on table `Course`
--
ALTER TABLE Course 
  ADD UNIQUE INDEX Name(Name);

--
-- Create foreign key
--
ALTER TABLE Course 
  ADD CONSTRAINT Course_ibfk_1 FOREIGN KEY (SubjectId)
    REFERENCES Subject(Id) ON DELETE CASCADE;

--
-- Create table `Exam`
--
CREATE TABLE Exam (
  Id INT(11) NOT NULL AUTO_INCREMENT,
  Filename VARCHAR(255) NOT NULL,
  Date DATE NOT NULL,
  CourseId INT(11) NOT NULL,
  UnpublishDate DATE NOT NULL,
  Unpublished TINYINT(1) NOT NULL,
  PRIMARY KEY (Id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 1,
AVG_ROW_LENGTH = 2340,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `Name` on table `Exam`
--
ALTER TABLE Exam 
  ADD UNIQUE INDEX Name(Filename);

--
-- Create foreign key
--
ALTER TABLE Exam 
  ADD CONSTRAINT Exam_ibfk_1 FOREIGN KEY (CourseId)
    REFERENCES Course(Id) ON DELETE CASCADE;

--
-- Create table `User`
--
CREATE TABLE User (
  Id INT(11) NOT NULL AUTO_INCREMENT,
  Name VARCHAR(255) NOT NULL,
  IsSuperUser TINYINT(1) NOT NULL,
  PRIMARY KEY (Id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 1,
AVG_ROW_LENGTH = 5461,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `Name` on table `User`
--
ALTER TABLE User 
  ADD UNIQUE INDEX Name(Name);

--
-- Create table `Settings`
--
CREATE TABLE Settings (
  Id INT(11) NOT NULL AUTO_INCREMENT,
  CookieSessionMinutes INT(11) NOT NULL,
  HomePageHtml TEXT NOT NULL,
  AboutPageHtml TEXT NOT NULL,
  UnpublishTimeYears INT(11) NOT NULL,
  Created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (Id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 1,
AVG_ROW_LENGTH = 1966,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `Created` on table `Settings`
--
ALTER TABLE Settings 
  ADD UNIQUE INDEX Created(Created);

-- 
-- Dumping data for table Academy
--
INSERT INTO Academy VALUES
(11, 'Akademi för hälsa och arbetsliv', 'AHA', 0),
(12, 'Akademin för teknik och miljö', 'ATM', 0),
(13, 'Akademin för utbildning och ekonomi', 'AUE', 0);

-- 
-- Dumping data for table Subject
--
INSERT INTO Subject VALUES
(3, 'AH', 'Arbetshälsovetenskap', 0, 11),
(4, 'CB', 'CBF', 0, 11),
(5, 'FH', 'Folkhälsovetenskap', 0, 11),
(6, 'AR', 'Arkitekturrrr', 0, 12),
(7, 'BE', 'Besluts-, risk- och policyanalys', 0, 12),
(8, 'BY', 'Byggnadsteknik', 0, 12),
(9, 'BI', 'Biologi', 0, 13),
(10, 'DI', 'Didaktik', 0, 13),
(11, 'DP', 'Dramapedagogik', 0, 13),
(37, 'ID', 'Idrott', 0, 11),
(38, 'KR', 'Kriminologi', 0, 11),
(39, 'DV', 'Datavetenskap', 0, 12),
(40, 'MA', 'Matematik', 0, 12),
(41, 'FY', 'Fysik', 0, 12),
(42, 'EN', 'Engelska', 0, 13),
(43, 'PE', 'Pedagogik', 0, 13),
(44, 'HG', 'ghag', 0, 11);

-- 
-- Dumping data for table Course
--
INSERT INTO Course VALUES
(6, 'Hannakunskap', 'AHG100', 0, 3),
(7, 'Sannakunskap', 'CBG100', 0, 4),
(8, 'Mattiaskunskap', 'ARG100', 0, 6),
(9, 'Niklaskunskap', 'BEG100', 0, 7),
(10, 'Thomaskunskap', 'BIG100', 0, 9),
(11, 'Åkekunskap', 'DIG100', 0, 10),
(12, 'Lenåäökunskap', 'LKU100', 0, 3),
(19, 'Thomaskunskap2', 'AHD300', 0, 3),
(20, 'BHSBGHE', 'CAH357', 0, 4),
(24, 'Linjär Algebra', 'MAG051', 0, 40),
(25, 'Hälsa för arbetare', 'DVG345', 0, 39);

-- 
-- Dumping data for table User
--
INSERT INTO User VALUES
(1, '17hame01', 1),
(2, '17mame03', 1),
(3, '17salu03', 1);
(4, 'thu16nnn', 1);

-- 
-- Dumping data for table Settings
--
INSERT INTO Settings VALUES
(1, 120, '<h1>Welcome to Högskolan i Gävle''s Exam Center!</h1>\n<p>\nHere you will find exams for many of the courses offered at HiG so that you can study for and do well at your upcoming exams.\n</p>\n<p>\nBrowse for exams by choosing an academy in the toolbar above or use the search field in the top-right corner.\n</p>', '<h1>About</h1>\n    <p>This website is made for the Univeristy of Gävle, to get easier access to the example exams they offer.</p>\n    <p>You can simply click on an Academy on the top navbar and navigate thorugh subjects and courses to find \n        <br>your exams\n        or you could use the search bar to find what you are looking for.\n    </p>\n    <p>Made by students, for students.</p>', 3, '2020-01-17 08:24:03');

-- 
-- Dumping data for table Exam
--
INSERT INTO Exam VALUES

--
-- Set default database
--
USE db;

--
-- Drop trigger `CourseCodeCompliesWithSubjectCode`
--
DROP TRIGGER IF EXISTS CourseCodeCompliesWithSubjectCode;

--
-- Set default database
--
USE db;

DELIMITER $$

--
-- Create trigger `CourseCodeCompliesWithSubjectCode`
--
CREATE 
	DEFINER = 'db'@'%'
TRIGGER CourseCodeCompliesWithSubjectCode
	BEFORE INSERT
	ON Course
	FOR EACH ROW
BEGIN
	IF SUBSTRING(new.CourseCode, 1, 2) <> ( SELECT
    Code
  FROM Subject
  WHERE Subject.Id = new.SubjectId) THEN
		SIGNAL SQLSTATE '23503'
			SET MESSAGE_TEXT = 'Subject code must correspond to the subject code of the subject specified as a foreign key';
	END IF;
END
$$

DELIMITER ;

-- 
-- Restore previous SQL mode
-- 
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

-- 
-- Enable foreign keys
-- 
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;