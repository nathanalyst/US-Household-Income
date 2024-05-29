-- US household Income EDA (Exploratory Data Analysis)
USE us_household_income;

SELECT *
FROM
   USHouseholdIncome
;

SELECT *
FROM
   household_statistics
;


SELECT
   State_Name,
   ALand,
   AWater
FROM
   USHouseholdIncome
;


SELECT
   State_Name,
   SUM(ALand) total_land,
   SUM(AWater) total_water
FROM
   USHouseholdIncome
GROUP BY
   State_Name
ORDER BY
   total_water DESC -- total_land DESC -- 
;
-- something is clearly wrong with my dataset because Oregon should not have that much land (more than California?) what is going on? 
-- if this was my job I would definitely have to look into this because these numbers are very wrong.

SELECT *
FROM
   USHouseholdIncome us
JOIN
household_statistics stat
ON us.id = stat.id
;

-- how to see how many records dont match from the tables
SELECT *
FROM
   USHouseholdIncome us
RIGHT JOIN -- LEFT JOIN -- 
household_statistics stat
ON us.id = stat.id
WHERE
   us.id IS NULL OR us.id = '' -- stat.id IS NULL OR stat.id = '' -- 
;
-- perfect

SELECT *
FROM
   USHouseholdIncome us
INNER JOIN
household_statistics stat
ON us.id = stat.id
ORDER BY Mean
;
-- there are a few zeroes here, so we might need to figure out how to approach this situation and clean it or simply remove the data depending on what the issue is and how it happened and how many zeroes there are. Out of 30,000 + there really isnt that many
SELECT
   COUNT(*)
FROM
   USHouseholdIncome us
INNER JOIN
household_statistics stat
ON us.id = stat.id
WHERE
   Mean = 0 OR Mean = '' OR Mean = NULL
;
-- 315, approximately only 1% of the data, not bad at all

SELECT
   us.State_Name, County, Type, `Primary`, Mean, Median
FROM
   USHouseholdIncome us
INNER JOIN
household_statistics stat
ON us.id = stat.id
WHERE Mean <> 0
;


SELECT
   us.State_Name, 
   ROUND(AVG(Mean), 1) AS mean_income, 
   ROUND(AVG(Median), 1) AS median_income
FROM
   USHouseholdIncome us
INNER JOIN
household_statistics stat
ON us.id = stat.id
WHERE Mean <> 0
GROUP BY
   us.State_Name
ORDER BY
   mean_income DESC -- ASC
;


SELECT
   us.State_Name, 
   ROUND(AVG(Mean), 1) AS mean_income, 
   ROUND(AVG(Median), 1) AS median_income
FROM
   USHouseholdIncome us
INNER JOIN
household_statistics stat
ON us.id = stat.id
WHERE Mean <> 0
GROUP BY
   us.State_Name
ORDER BY
   median_income DESC -- ASC 
;

-- now lets look at it in terms of type and primary instead of state

SELECT
   Type, 
   ROUND(AVG(Mean), 1) AS mean_income, 
   ROUND(AVG(Median), 1) AS median_income
FROM
   USHouseholdIncome us
INNER JOIN
household_statistics stat
ON us.id = stat.id
WHERE Mean <> 0
GROUP BY
   Type
ORDER BY
   mean_income DESC -- ASC median_income DESC -- ASC
;
-- lets check out communities because it is the lowest, where would they be? Puerto Rico maybe?

SELECT *
FROM
   USHouseholdIncome
WHERE
   Type = 'Community'
;
-- Yes, Pureto Rico
-- But you probably wont even want outputs of type with such low count, so lets filter them out by enforcing a certain count
SELECT
   Type,
   COUNT(Type),
   ROUND(AVG(Mean), 1) AS mean_income, 
   ROUND(AVG(Median), 1) AS median_income
FROM
   USHouseholdIncome us
INNER JOIN
household_statistics stat
ON us.id = stat.id
WHERE Mean <> 0
GROUP BY
   Type
HAVING
   COUNT(Type) > 100
ORDER BY
   mean_income DESC -- ASC median_income DESC -- ASC
;
-- definitely need to consider what to do with these kinds of outliers

-- lets look at the cities and compare the income that way

SELECT
   us.State_Name,
   City,
   ROUND(AVG(Mean), 1) AS mean_income, 
   ROUND(AVG(Median), 1) AS median_income
FROM
   USHouseholdIncome us
INNER JOIN
household_statistics stat
ON us.id = stat.id
WHERE Mean <> 0
GROUP BY
   us.State_Name,
   City
ORDER BY
   mean_income DESC -- ASC
LIMIT 100
;
-- you could also filter it by state to just get the cities from that particular state

SELECT
   us.State_Name,
   City,
   COUNT(City),
   ROUND(AVG(Mean), 1) AS mean_income, 
   ROUND(AVG(Median), 1) AS median_income
FROM
   USHouseholdIncome us
INNER JOIN
household_statistics stat
ON us.id = stat.id
WHERE Mean <> 0
AND us.State_Name = 'Texas'
GROUP BY
   us.State_Name,
   City
ORDER BY
   COUNT(City) DESC-- ASC
;
-- the problem with grouping it by city is that there isnt hardly any data per city, the vast majority have 10 or less data points. Having 30 or even at least 10 from each city would have helped a lot, but I think what they had in mind was to keep the sample representative of the population to not skew the data

SELECT
   ROUND(AVG(Mean), 1) AS mean_income, 
   ROUND(AVG(Median), 1) AS median_income
FROM
   USHouseholdIncome us
INNER JOIN
household_statistics stat
ON us.id = stat.id
WHERE Mean <> 0
AND us.State_Name <> 'Puerto Rico' AND us.State_Name <> 'Hawaii' AND us.State_Name <> 'Alaska'
AND us.State_Name = 'Texas'
;
-- so lets make it a goal to make over $66,000 a year and become over the average in a below average spending environment such as Nacogdoches, actually better yet lets make it to the 50th percentile of people and go for 87.1k income every year





