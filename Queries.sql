SELECT T.NAME as Name, T.sur_name as Surname,
CASE
	WHEN G.GENDER = 'M' THEN 'MUSKI'
	WHEN G.GENDER = 'F' THEN 'ZENSKI'
	ELSE 'OSTALO'
END AS GENDER,
C.name, C.average_income
FROM TRAINER T
JOIN GENDERS G ON T.GENDERID = G.ID
JOIN COUNTRY C ON T.COUNTRYID = C.ID


--Naziv i termin održavanja svake sportske igre zajedno s imenima glavnih trenera 
--(u formatu Prezime, I.; npr. Horvat, M.; Petrović, T.).
SELECT ATY.NAME AS NAME, AI.DATE, AI.START_TIME,
CONCAT(SUBSTRING(T.NAME FROM 1 FOR 1), '. ', T.SUR_NAME) AS main_trainer 
FROM ACTIVITY_INSTANCE AI
JOIN ACTIVITY A ON A.ID = AI.ACTIVITY_ID
JOIN ACTIVITYTYPES ATY ON ATY.ID = A.ACTIVITY_TYPE_ID
JOIN TRAINER T ON T.ID = A.MAIN_TRAINER_ID

--Top 3 fitness centra s najvećim brojem aktivnosti u rasporedu
SELECT COUNT(AI.ID) AS INSTANCE, F.ID AS FITNESS_CENTER_ID, F.NAME AS FITNESS_CENTER FROM ACTIVITY_INSTANCE AI
JOIN ACTIVITY A ON A.ID = AI.ACTIVITY_ID
JOIN FITNESS_CENTER F ON F.ID = A.FITNESS_CENTER_ID
GROUP BY F.ID
ORDER BY COUNT(AI.ID) DESC
LIMIT 3

--Po svakom terneru koliko trenutno aktivnosti vodi; ako nema aktivnosti, ispiši “DOSTUPAN”,
--ako ima do 3 ispiši “AKTIVAN”, a ako je na više ispiši “POTPUNO ZAUZET”.
SELECT CONCAT(T.NAME,' ', T.SUR_NAME) AS Trainer, T.ID, COUNT(A.main_trainer_id),
CASE
	WHEN COUNT(A.main_trainer_id) = 0 then 'DOSTUPAN'
	WHEN COUNT(A.main_trainer_id) <= 3 then 'AKTIVAN'
	ELSE 'ZAUZET'
END AS AVAILABILTY
FROM TRAINER T
JOIN ACTIVITY A ON A.MAIN_TRAINER_ID = T.ID
GROUP BY T.ID

--Imena svih članova koji trenutno sudjeluju na nekoj aktivnosti.
SELECT m.name
from MEMBER M
WHERE EXISTS (
	SELECT 1
	FROM ACTIVITY_INSTANCE_MEMBER AM
	WHERE AM.MEMBER_ID = M.ID
)
	






















