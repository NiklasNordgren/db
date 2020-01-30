CREATE SCHEMA IF NOT EXISTS db DEFAULT CHARACTER SET utf8 ;
USE db;

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
    FOREIGN KEY (CourseId)
		REFERENCES Course(Id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS User (
	Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) UNIQUE NOT NULL,
    IsSuperUser TINYINT NOT NULL
);

CREATE TABLE IF NOT EXISTS Settings (
	Id INT PRIMARY KEY AUTO_INCREMENT,
	CookieSessionMinutes INT NOT NULL,
    HomePageHtml TEXT NOT NULL,
    AboutPageHtml TEXT NOT NULL,
    UnpublishTimeYears INT NOT NULL
);

DELIMITER $$
CREATE TRIGGER AcademyInsert BEFORE INSERT ON Academy
FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.Name) < 3 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Academy name must be at least three characters long';
    END IF;
    IF REGEXP_LIKE(NEW.Name, '^[[:blank:][:alpha:],-]+$') = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Academy name must contain only alphanumeric characters, hyphens and commas';
	END IF;
    IF CHAR_LENGTH(NEW.Abbreviation) < 2 OR CHAR_LENGTH(NEW.Abbreviation) > 5 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Academy abbreviation must be between two and five characters long';
    END IF;
    IF REGEXP_LIKE(NEW.Abbreviation, '^[[:upper:]]+$', 'c') = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Academy abbreviation must contain only uppercase letters';
	END IF;
END$$

CREATE TRIGGER AcademyUpdate BEFORE UPDATE ON Academy
FOR EACH ROW
BEGIN
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
	IF SUBSTRING(new.CourseCode, 1, 2) <> (SELECT 	Code
											FROM	Subject
                                            WHERE	Subject.Id = new.SubjectId)
	THEN
		SIGNAL SQLSTATE '23503'
			SET MESSAGE_TEXT = 'Course code must correspond to the subject code of the subject specified as a foreign key';
	END IF;
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

CREATE TRIGGER SettingsUpdate BEFORE UPDATE ON Settings FOR EACH ROW
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

DELIMITER;