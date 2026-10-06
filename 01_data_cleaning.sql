#World Life Expectancy Project (Data Cleaning)

SELECT * 
FROM world_life_expectancy
;

#1. REMOVE DUPLICATES

#There should be only one country per year, so we have to find if there are repetition of country and year, e.g. 2 rows for Abania 2019
SELECT country, year, CONCAT(country, year), COUNT(CONCAT(country, year))
FROM world_life_expectancy
GROUP BY country, year
HAVING COUNT(CONCAT(country, year)) > 1
;

#Now that we found there are 3 duplicates, we will find the row_id for the duplicates and then we will remove them
SELECT *
FROM (SELECT
        row_id,
        CONCAT(country, year),
        ROW_NUMBER() OVER(PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) AS row_num
    FROM world_life_expectancy
) AS row_table
WHERE row_num > 1
;

#And finally we will delete the duplicated rows from the table
DELETE FROM world_life_expectancy
WHERE 
    row_id IN (
        SELECT row_id
        FROM (SELECT
                row_id,
                CONCAT(country, year),
                ROW_NUMBER() OVER(PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) AS row_num
            FROM world_life_expectancy
        ) AS row_table
        WHERE row_num > 1
    )
    ;

#2. POPULATING EMPTY FIELDS ON STATUS COLUMN
#First we find the missing status cells
SELECT * 
FROM world_life_expectancy
WHERE status = ''
;

#Then we see what are the different status options available
SELECT DISTINCT(status)
FROM world_life_expectancy
WHERE status <> ''
;

#If a country has a 'Developing' status on other years, then the empty status should be populated as 'Developing'
SELECT DISTINCT(country)
FROM world_life_expectancy
WHERE status = 'Developing'
;

#Joining the table to itself so we can filter the blank and populated cells from the other table
UPDATE world_life_expectancy AS t1
JOIN world_life_expectancy AS t2
    ON t1.country = t2.country
SET t1.status = 'Developing'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'Developing'
;

UPDATE world_life_expectancy AS t1
JOIN world_life_expectancy AS t2
    ON t1.country = t2.country
SET t1.status = 'Developed'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'Developed'
;

#3. POPULATING LIFE EXPECTANCY COLUMN WITH THE AVERAGE OF PREVIOUS AND FOLLOWING YEARS
SELECT * 
FROM world_life_expectancy
WHERE lifeexpectancy = ''
;

SELECT 
    t1.country, t1.year, t1.lifeexpectancy,
    t2.country, t2.year, t2.lifeexpectancy,
    t3.country, t3.year, t3.lifeexpectancy,
    ROUND((t2.lifeexpectancy + t3.lifeexpectancy) / 2, 1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.country = t2.country
    AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
    ON t1.country = t3.country
    AND t1.year = t3.year + 1
WHERE t1.lifeexpectancy = ''
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.country = t2.country
    AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
    ON t1.country = t3.country
    AND t1.year = t3.year + 1
SET t1.lifeexpectancy = ROUND((t2.lifeexpectancy + t3.lifeexpectancy) / 2, 1)
WHERE t1.lifeexpectancy = ''
;