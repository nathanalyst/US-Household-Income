-- US household income Data Cleaning
USE us_household_income;

SELECT
   COUNT(*)
FROM  
   USHouseholdIncome
;
-- should be getting over 32,000 rows, but only got less than 19,000 rows
-- now it is correct, perfect, used the sql file

SELECT
   COUNT(*)
FROM  
   household_statistics
;
-- this dataset imported everything but less than 10 rows, this one should be pretty good


-- DATA CLEANING ---------------------------

SELECT *
FROM  
   USHouseholdIncome
;
-- lets check for duplicates

SELECT
   id,
   COUNT(id)
FROM
   USHouseholdIncome
GROUP BY
   id
HAVING
   COUNT(id) > 1
;
-- we can use the row_id as the unique column, lets make sure all row_id's are unique though
SELECT
   row_id,
   COUNT(row_id)
FROM
   USHouseholdIncome
GROUP BY
   row_id
HAVING
   COUNT(row_id) > 1
;
-- perfect no row_id duplicates

SELECT *
FROM (
   SELECT
      row_id,
      id,
      ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
   FROM
      USHouseholdIncome
      ) AS duplicates
WHERE
   row_num > 1
;
-- after running the delete from query below there are now no duplicates, perfect

-- now we can delete these rows by selecting just the row_id's
DELETE FROM USHouseholdIncome
WHERE row_id IN (
SELECT
   row_id
FROM (
   SELECT
      row_id,
      id,
      ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
   FROM
      USHouseholdIncome
      ) AS duplicates
WHERE
   row_num > 1
   )
;



SELECT
   id,
   COUNT(id)
FROM  
   household_statistics
GROUP BY
   id
HAVING COUNT(id) > 1
;
-- no duplicates for the statistics table, perfect

-- We saw an Alabama that was actually alabama, so lets fix that
SELECT *
FROM  
   USHouseholdIncome
;


SELECT
   State_Name,
   COUNT(State_Name)
FROM
   USHouseholdIncome
GROUP BY
   State_Name
;
-- interesting, when we run this, it looks like it might automatically be fixing state_name's for us when they are spelled correctly but the capitalization is off which could potentially be a problem hmm
-- lets try using DISTINCT
SELECT
   DISTINCT(State_Name)
FROM
   USHouseholdIncome
;
-- still not coming up, hmm, but lets fix the georia
UPDATE USHouseholdIncome
SET State_Name = 'Georgia'
WHERE
   State_Name = 'georia'
;
-- perfect now that row is fixed
UPDATE USHouseholdIncome
SET State_Name = 'Alabama'
WHERE
   State_Name = 'alabama'
;


SELECT
   DISTINCT(State_ab)
FROM
   USHouseholdIncome
;


SELECT *
FROM  
   USHouseholdIncome
;


UPDATE USHouseholdIncome
SET Place = 'Autaugaville'
WHERE
   id = '102216'
   AND row_id = '32'
;


SELECT
   Type,
   COUNT(Type)
FROM
   USHouseholdIncome
GROUP BY
   Type
;

UPDATE USHouseholdIncome
SET Type = 'CDP'
WHERE Type = 'CPD'
;

UPDATE USHouseholdIncome
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;


SELECT DISTINCT AWater
FROM
   USHouseholdIncome
WHERE
   AWater = 0 OR AWater = '' OR AWater = NULL
;

SELECT ALand -- looked at ALand distinct, no nulls or blanks
FROM
   USHouseholdIncome
WHERE
   ALand = 0 OR ALand = '' OR ALand = NULL
;

SELECT ALand, AWater -- looked at ALand distinct, no nulls or blanks
FROM
   USHouseholdIncome
WHERE (ALand = 0 OR ALand = '' OR ALand = NULL)
      AND (AWater = 0 OR AWater = '' OR AWater = NULL)
;
-- okay perfect, apparently there are places that are just water
SELECT ALand, AWater
FROM
   USHouseholdIncome
WHERE (ALand = 0 OR ALand = '' OR ALand = NULL)
;