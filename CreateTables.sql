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

ALTER TABLE Activity
	--ADD CONSTRAINT CHECK_PRICE_IS_NOTNEGATIVE CHECK(PRICE > 0)
	ADD CONSTRAINT CHECK_CAPACITY_IS_NOTNEGATIVE CHECK(CAPACITY >0)


CREATE TABLE ACTIVITY_INSTANCE(
	Id SERIAL PRIMARY KEY,
	Activity_Id INT REFERENCES Activity(Id) NOT NULL,
	Start_time TIME NOT NULL,
	End_time TIME NOT NULL
)

CREATE TABLE Activity_Instance_Member(
	Activity_Instance_Id INT REFERENCES ACTIVITY_INSTANCE(Id) NOT NULL,
	Member_Id INT REFERENCES Member(Id) NOT NULL,
	PRIMARY KEY(Activity_Instance_Id, Member_Id)
)

CREATE TABLE ACTIVITY_TRAINER(
	Activity_Id INT REFERENCES ACTIVITY(ID),
	Trainer_Id INT REFERENCES TRAINER(ID),
	ActivityType_Id INT REFERENCES ActivityTypes(Id),
	PRIMARY KEY (Activity_Id, Trainer_Id)
)
	  
ALTER TABLE ACTIVITY_TRAINER
	ADD COLUMN TRAINER_TYPE INT REFERENCES TRAINERTYPE(ID)
	
ALTER TABLE IF EXISTS public.activity_trainer
    ADD CONSTRAINT activity_trainer_pkey PRIMARY KEY (activity_id, trainer_id)


CREATE UNIQUE INDEX one_main_trainer_per_activity
ON ACTIVITY_TRAINER (Activity_Id)
WHERE TRAINER_TYPE = 3;

SELECT * FROM ACTIVITY_TRAINER WHERE