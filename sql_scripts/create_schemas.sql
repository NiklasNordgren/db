CREATE SCHEMA IF NOT EXISTS db DEFAULT CHARACTER SET utf8 ;
USE db;

<<<<<<< HEAD
GRANT ALL PRIVILEGES ON db.* TO 'root'@'%' WITH GRANT OPTION;

CREATE TABLE IF NOT EXISTS Academy (
	Id INT PRIMARY KEY AUTO_INCREMENT,
	Name VARCHAR(255) UNIQUE NOT NULL,
	Abbreviation CHAR(5) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS Subject (
	Id INT PRIMARY KEY AUTO_INCREMENT,
    Code CHAR(2) UNIQUE NOT NULL,
	Name VARCHAR(255) UNIQUE NOT NULL,
	AcademyId INT NOT NULL,
	FOREIGN KEY (AcademyId)
		REFERENCES Academy(Id)
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Course (
	Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) UNIQUE NOT NULL,
    CourseCode CHAR(7) UNIQUE NOT NULL,
	SubjectId INT NOT NULL,
	FOREIGN KEY (SubjectId)
		REFERENCES Subject(Id)
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Exam (
	Id INT PRIMARY KEY AUTO_INCREMENT,
    Date DATE NOT NULL,
    Filename VARCHAR(255) UNIQUE NOT NULL,
    CourseId INT NOT NULL,
    UnpublishDate DATE NOT NULL,
    Unpublished TINYINT NOT NULL,
=======
-- -----------------------------------------------------
-- Table db.Academy
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS db.Academy (
  Id INT(11) NOT NULL AUTO_INCREMENT,
  Name VARCHAR(255) NOT NULL,
  Abbreviation VARCHAR(255) NOT NULL,
  unpublished TINYINT(1) NOT NULL,
  PRIMARY KEY (Id),
  UNIQUE INDEX Name (Name ASC) VISIBLE,
  UNIQUE INDEX Abbreviation (Abbreviation ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 73
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table db.Subject
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS db.Subject (
  Id INT(11) NOT NULL AUTO_INCREMENT,
  Code VARCHAR(2) NOT NULL,
  Name VARCHAR(255) NOT NULL,
  Unpublished TINYINT(1) NOT NULL,
  AcademyId INT(11) NOT NULL,
  PRIMARY KEY (Id),
  UNIQUE INDEX Code (Code ASC) VISIBLE,
  UNIQUE INDEX Name (Name ASC) VISIBLE,
  INDEX AcademyId (AcademyId ASC) VISIBLE,
  CONSTRAINT Subject_ibfk_1
    FOREIGN KEY (AcademyId)
    REFERENCES db.Academy (Id)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 37
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table db.Course
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS db.Course (
  Id INT(11) NOT NULL AUTO_INCREMENT,
  Name VARCHAR(255) NOT NULL,
  CourseCode VARCHAR(7) NOT NULL,
  Unpublished TINYINT(1) NOT NULL,
  SubjectId INT(11) NOT NULL,
  PRIMARY KEY (Id),
  UNIQUE INDEX Name (Name ASC) VISIBLE,
  UNIQUE INDEX CourseCode (CourseCode ASC) VISIBLE,
  INDEX SubjectId (SubjectId ASC) VISIBLE,
  CONSTRAINT Course_ibfk_1
    FOREIGN KEY (SubjectId)
    REFERENCES db.Subject (Id)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 23
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table db.Exam
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS db.Exam (
  Id INT(11) NOT NULL AUTO_INCREMENT,
  Filename VARCHAR(255) NOT NULL,
  Date DATE NOT NULL,
  CourseId INT(11) NOT NULL,
  UnpublishDate DATE NOT NULL,
  Unpublished TINYINT(1) NOT NULL,
  PRIMARY KEY (Id),
  UNIQUE INDEX Name (Filename ASC) VISIBLE,
  INDEX CourseId (CourseId ASC) VISIBLE,
  CONSTRAINT Exam_ibfk_1
>>>>>>> parent of 0977d2f... Update create_schemas.sql
    FOREIGN KEY (CourseId)
    REFERENCES db.Course (Id)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 297
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table db.Settings
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS db.Settings (
  Id INT(11) NOT NULL AUTO_INCREMENT,
  CookieSessionMinutes INT(11) NOT NULL,
  HomePageHtml TEXT NOT NULL,
  AboutPageHtml TEXT NOT NULL,
  UnpublishTimeYears INT(11) NOT NULL,
  Created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (Id),
  UNIQUE INDEX Created (Created ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 62
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table db.User
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS db.User (
  Id INT(11) NOT NULL AUTO_INCREMENT,
  Name VARCHAR(255) NOT NULL,
  IsSuperUser TINYINT(1) NOT NULL,
  PRIMARY KEY (Id),
  UNIQUE INDEX Name (Name ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 72
DEFAULT CHARACTER SET = utf8;

USE db;

DELIMITER $$
USE db$$
CREATE
DEFINER=db@'%'
TRIGGER db.CourseCodeCompliesWithSubjectCode
BEFORE INSERT ON db.Course
FOR EACH ROW
BEGIN
<<<<<<< HEAD
    IF CHAR_LENGTH(NEW.Name) < 3 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Academy name must be at least three characters long';
    END IF;
    IF NOT REGEXP_LIKE(NEW.Name, '^[[:blank:][:alpha:],-]+$') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Academy name must contain only letters, hyphens and commas';
	END IF;
    IF CHAR_LENGTH(NEW.Abbreviation) < 2 OR CHAR_LENGTH(NEW.Abbreviation) > 5 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Academy abbreviation must be between two and five characters long';
    END IF;
    IF NOT REGEXP_LIKE(NEW.Abbreviation, '^[[:upper:]]+$', 'c') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Academy abbreviation must contain only uppercase letters';
	END IF;
END$$

CREATE TRIGGER SubjectInsert BEFORE INSERT ON Subject
FOR EACH ROW
BEGIN
    IF NOT REGEXP_LIKE(NEW.Code, '[[:upper:]]+$', 'c') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Subject code must contain only uppercase letters';
    END IF;
    IF CHAR_LENGTH(NEW.Code) <> 2 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Subject code must be two characters long';
    END IF;
    IF NOT REGEXP_LIKE(NEW.Name, '^[[:blank:][:alpha:],-]+$') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Subject name must contain only letters, hyphens and commas';
    END IF;
    IF CHAR_LENGTH(NEW.Name) < 3 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Subject name must be at least three characters long';
    END IF;
END$$

CREATE TRIGGER SubjectUpdate BEFORE UPDATE ON Subject
FOR EACH ROW
BEGIN
    IF NOT REGEXP_LIKE(NEW.Code, '^[[:upper:]]+$', 'c') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Subject code must contain only uppercase letters';
    END IF;
    IF CHAR_LENGTH(NEW.Code) <> 2 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Subject code must be two characters long';
    END IF;
    IF NOT REGEXP_LIKE(NEW.Name, '^[[:blank:][:alpha:],-]+$') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Subject name must contain only letters, , hyphens and commas';
    END IF;
    IF CHAR_LENGTH(NEW.Name) < 3 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Subject name must be at least three characters long';
    END IF;
END$$

CREATE TRIGGER CourseInsert
	BEFORE INSERT
    ON Course FOR EACH ROW
BEGIN
	IF NOT REGEXP_LIKE(NEW.Name, '^[[:blank:][:alpha:],-]+$') THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Course name must contain only letters, hyphens and commas';
    END IF;
    IF CHAR_LENGTH(NEW.Name) < 3 THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Course name must be at least three letters long';
    END IF;
    IF CHAR_LENGTH(NEW.CourseCode) < 6 THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Course code must start with three uppercase letters followed by three or four digits';
    END IF;
    IF NOT REGEXP_LIKE(NEW.CourseCode, '^[A-ZÅÄÖ]{3}[0-9]{3}', 'c') THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Course code must start with three uppercase letters followed by three or four digits';
    END IF;
=======
>>>>>>> parent of 0977d2f... Update create_schemas.sql
	IF SUBSTRING(new.CourseCode, 1, 2) <> (SELECT 	Code
											FROM	Subject
                                            WHERE	Subject.Id = new.SubjectId)
	THEN
		SIGNAL SQLSTATE '23503'
			SET MESSAGE_TEXT = 'Subject code must correspond to the subject code of the subject specified as a foreign key';
	END IF;
<<<<<<< HEAD
END $$

CREATE TRIGGER CourseUpdate
	BEFORE UPDATE
    ON Course FOR EACH ROW
BEGIN
	IF NOT REGEXP_LIKE(NEW.Name, '^[[:blank:][:alpha:],-]+$') THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Course name must contain only letters, hyphens and commas';
    END IF;
    IF CHAR_LENGTH(NEW.Name) < 3 THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Course name must be at least three letters long';
    END IF;
    IF CHAR_LENGTH(NEW.CourseCode) < 6 THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Course code must start with three uppercase letters followed by three digits';
    END IF;
    IF NOT REGEXP_LIKE(NEW.CourseCode, '^[A-ZÅÄÖ]{3}[0-9]{3}', 'c') THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Course code must start with three uppercase letters followed by three digits';
    END IF;
	IF SUBSTRING(new.CourseCode, 1, 2) <> (SELECT 	Code
											FROM	Subject
                                            WHERE	Subject.Id = new.SubjectId)
	THEN
		SIGNAL SQLSTATE '23503'
			SET MESSAGE_TEXT = 'Course code must correspond to the subject code of the subject specified as a foreign key';
	END IF;
END $$

CREATE TRIGGER ExamInsert BEFORE INSERT ON Exam FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.Filename) < 3 THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Filename must be at least three letter long';
    END IF;
END $$

CREATE TRIGGER ExamUpdate BEFORE UPDATE ON Exam FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.Filename) < 3 THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Filename must be at least three letter long';
    END IF;
END $$

CREATE TRIGGER UserInsert BEFORE INSERT ON User FOR EACH ROW
BEGIN
    IF NOT REGEXP_LIKE(NEW.Name, '^[[:alnum:]-_]+$') THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Username must contain only alphanumeric characters, hyphens and underscores';
    END IF;
    IF CHAR_LENGTH(NEW.Name) < 2 THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Username must contain at least two characters';
    END IF;
END $$

CREATE TRIGGER UserUpdate BEFORE UPDATE ON User FOR EACH ROW
BEGIN
    IF NOT REGEXP_LIKE(NEW.Name, '^[[:alnum:]-_]+$') THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Username must contain only alphanumeric characters, hyphens and underscores';
    END IF;
    IF CHAR_LENGTH(NEW.Name) < 2 THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Username must contain at least two characters';
    END IF;
END $$

CREATE TRIGGER SettingsInsert BEFORE INSERT ON Settings FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.HomePageHtml) < 2 THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Home page HTML code must contain at least two characters';
    END IF;
    IF CHAR_LENGTH(NEW.AboutPageHtml) < 2 THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'About page HTML code must contain at least two characters';
    END IF;
    IF NEW.UnpublishTimeYears < 1 THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Unpublish time must be at least 1 year';
    END IF;
    IF NEW.CookieSessionMinutes < 5 THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cookie session time must be at least 5 minutes';
    END IF;
END $$
=======
END$$
>>>>>>> parent of 0977d2f... Update create_schemas.sql


DELIMITER ;

<<<<<<< HEAD
CREATE ROLE IF NOT EXISTS app;
GRANT UPDATE, DELETE, INSERT, SELECT ON db.academy TO app@'%';
GRANT UPDATE, DELETE, INSERT, SELECT ON db.course TO app@'%';
GRANT UPDATE, DELETE, INSERT, SELECT ON db.exam TO app@'%';
GRANT UPDATE, DELETE, INSERT, SELECT ON db.subject TO app@'%';
GRANT UPDATE, DELETE, INSERT, SELECT ON db.user TO app@'%';
GRANT SELECT, INSERT ON db.settings TO app@'%';
CREATE USER 'exte_app'@'%' IDENTIFIED BY 'exte_app';
GRANT 'app' TO 'exte_app'@'%';
=======
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
>>>>>>> parent of 0977d2f... Update create_schemas.sql
