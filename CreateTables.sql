CREATE TABLE ActivityTypes(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL
)

ALTER TABLE ActivityTypes
	ADD CONSTRAINT AvailableTypes CHECK(Name in ('Strength training', 'Cardio', 'Yoga', 'Dance', 'Injury Rehabilitation'))

CREATE TABLE COUNTRY(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	Population INT,
	Average_Income FLOAT
)

ALTER TABLE COUNTRY
	ADD CONSTRAINT POP_NOT_NEGATIVE CHECK(POPULATION > 0),
	ADD CONSTRAINT ANG_INCOME_NOT_NEGATIVE CHECK(AVERAGE_INCOME > 0)

CREATE TABLE TrainerType(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL
)

ALTER TABLE TrainerType
	ADD CONSTRAINT AvailableTypes CHECK(Name in ('Main', 'Helper'))

CREATE TABLE Member(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	Gender CHAR NOT NULL,
	DOB DATE NOT NULL
)

ALTER TABLE MEMBER
	ADD COLUMN Fitness_Center_id INT REFERENCES fitness_center(ID)
ALTER TABLE MEMBER
	ADD COLUMN COUNTRY_ID INT REFERENCES COUNTRY(ID)
ALTER TABLE Member
	ADD CONSTRAINT Member CHECK(Gender in ('F', 'M'))
ALTER TABLE Member
	DROP COLUMN Gender
ALTER TABLE Member
	ADD COLUMN GenderId INT REFERENCES Genders(Id)


CREATE TABLE FITNESS_CENTER(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	open_at TIME NOT NULL,
    close_at TIME NOT NULL,
	Country_Id INT REFERENCES COUNTRY(ID)
)

CREATE TABLE TRAINER(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	DOB DATE NOT NULL,
	GenderId INT REFERENCES Genders(Id),
	Fitness_Center_Id INT REFERENCES FITNESS_CENTER,
	CountryId INT REFERENCES COUNTRY(Id)
)

ALTER TABLE TRAINER
	ADD COLUMN SUR_NAME VARCHAR(50) NOT NULL



CREATE TABLE Genders(
	Id SERIAL PRIMARY KEY,
	Gender CHAR NOT NULL
)
ALTER TABLE Genders
	ADD CONSTRAINT Member CHECK(Gender in ('F', 'M'))

CREATE TABLE Activity(
	Id SERIAL PRIMARY KEY,
	activity_type_id INT REFERENCES ActivityTypes(ID),
	Capacity INT,
	Price Float,
	Fitness_center_id INT REFERENCES FITNESS_CENTER(Id)
)

ALTER TABLE ACTIVITY
	ADD COLUMN Main_trainer_id INT REFERENCES TRAINER(ID)

ALTER TABLE Activity
	--ADD CONSTRAINT CHECK_PRICE_IS_NOTNEGATIVE CHECK(PRICE > 0)
	ADD CONSTRAINT CHECK_CAPACITY_IS_NOTNEGATIVE CHECK(CAPACITY >0)


CREATE OR REPLACE FUNCTION trainer_activity_limit()
RETURNS TRIGGER AS $$
BEGIN
    IF (
        SELECT COUNT(*) 
        FROM Activity
        WHERE main_trainer_id = NEW.main_trainer_id
    ) > 2 THEN
        RAISE EXCEPTION 'Trainer can be main trainer for up to 2 activites.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trainer_activity_limit_trigger
BEFORE INSERT OR UPDATE ON Activity
FOR EACH ROW
EXECUTE FUNCTION trainer_activity_limit();




CREATE TABLE ACTIVITY_INSTANCE(
	Id SERIAL PRIMARY KEY,
	Activity_Id INT REFERENCES Activity(Id) NOT NULL,
	Start_time TIME NOT NULL,
	End_time TIME NOT NULL
)
ALTER TABLE ACTIVITY_INSTANCE
	ADD COLUMN DATE DATE NOT NULL

CREATE TABLE Activity_Instance_Member(
	Activity_Instance_Id INT REFERENCES ACTIVITY_INSTANCE(Id) NOT NULL,
	Member_Id INT REFERENCES Member(Id) NOT NULL,
	PRIMARY KEY(Activity_Instance_Id, Member_Id)
)

CREATE TABLE ACTIVITY_HELPER_TRAINERS(
	Activity_Id INT REFERENCES ACTIVITY(ID),
	Trainer_Id INT REFERENCES TRAINER(ID),
	PRIMARY KEY (Activity_Id, Trainer_Id)
)
	  

CREATE OR REPLACE FUNCTION enforce_no_overlap_main_helper()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM activity a
        WHERE a.id = NEW.activity_id AND a.main_trainer_id = NEW.trainer_id
    ) THEN
        RAISE EXCEPTION 'Helper trainer cannot be the main trainer for the activity';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_no_main_helper_overlap
BEFORE INSERT OR UPDATE ON activity_helper_trainers
FOR EACH ROW
EXECUTE FUNCTION enforce_no_overlap_main_helper();


