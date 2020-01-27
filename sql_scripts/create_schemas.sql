CREATE SCHEMA IF NOT EXISTS db DEFAULT CHARACTER SET utf8 ;
USE db;

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
USE 'db'$$
CREATE
DEFINER='db'@'%'
TRIGGER 'db'.'CourseCodeCompliesWithSubjectCode'
BEFORE INSERT ON 'db'.'Course'
FOR EACH ROW
BEGIN
	IF SUBSTRING(new.CourseCode, 1, 2) <> (SELECT 	Code
											FROM	Subject
                                            WHERE	Subject.Id = new.SubjectId)
	THEN
		SIGNAL SQLSTATE '23503'
			SET MESSAGE_TEXT = 'Subject code must correspond to the subject code of the subject specified as a foreign key';
	END IF;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
