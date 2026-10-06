# World Life Expectancy Project (Exploratory Data Analysis)

SELECT *
FROM world_life_expectancy
;

#Let's see the min life expectancy a country had and compare it to the max life expectancy and let's check the countries that had the biggest difference on their min and max life expectancy
SELECT
    country,
        MIN(lifeexpectancy), 
        MAX(lifeexpectancy),
        ROUND(MAX(lifeexpectancy) - MIN(lifeexpectancy), 1) AS life_increase
FROM world_life_expectancy
GROUP BY country
HAVING MIN(lifeexpectancy) <> 0
AND MAX(lifeexpectancy) <> 0
ORDER BY life_increase DESC
;

#Years with the highest life expectancy
SELECT
    year,
    ROUND(AVG(lifeexpectancy), 1)
FROM world_life_expectancy
WHERE lifeexpectancy <> 0
GROUP BY year
ORDER BY year DESC
;

#Correlation between GDP and life expectancy
SELECT country, ROUND(AVG(lifeexpectancy), 1) AS lifeexpectancy, ROUND(AVG(gdp), 1) AS gdp
FROM world_life_expectancy
GROUP BY country
HAVING lifeexpectancy > 0
AND gdp > 0
ORDER BY gdp
;

SELECT 
    SUM(CASE WHEN gdp >= 1500 THEN 1 ELSE 0 END) AS high_gdp_count,
    AVG(CASE WHEN gdp >= 1500 THEN lifeexpectancy ELSE NULL END) AS high_gdp_lifeexpectancy,
    SUM(CASE WHEN gdp < 1500 THEN 1 ELSE 0 END) AS low_gdp_count,
    AVG(CASE WHEN gdp < 1500 THEN lifeexpectancy ELSE NULL END) AS low_gdp_lifeexpectancy
FROM world_life_expectancy
;

#Average life expectancy between developing and developed countries
SELECT status, COUNT(DISTINCT country), ROUND(AVG(lifeexpectancy), 1)
FROM world_life_expectancy
GROUP BY status
;

#Correlation between BMI and life expectancy
SELECT country, ROUND(AVG(lifeexpectancy), 1) AS lifeexpectancy, ROUND(AVG(bmi), 1) AS bmi
FROM world_life_expectancy
GROUP BY country
HAVING lifeexpectancy > 0
AND bmi > 0
ORDER BY bmi DESC
;

#Correlation between adult mortality and life expectancy
SELECT 
    country, 
    year, 
    lifeexpectancy, 
    adultmortality,
    SUM(adultmortality) OVER(PARTITION BY country ORDER BY year) AS rolling_total
FROM world_life_expectancy
WHERE country LIKE '%United%'
;