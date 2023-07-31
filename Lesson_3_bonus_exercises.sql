/**
 * lekce 3 11.7.2023 - bonusova cviceni
 **/

SELECT COUNT(1) 
FROM czechia_price cp;

SELECT COUNT(id)
FROM czechia_payroll cp ;


-- ukol 1

SELECT 
	country,
	SUM(population)
FROM countries c
GROUP BY continent
ORDER BY SUM(population);

SELECT 
	continent,
	ROUND(AVG(surface_area))
FROM countries c
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY AVG(surface_area);

SELECT 
	religion, 
	COUNT(*)
FROM countries c 
WHERE religion IS NOT NULL
GROUP BY religion
ORDER BY COUNT(*) DESC;

-- ukol 2

SELECT 
	continent , 
	SUM(population), 
	ROUND( AVG(population) ), 
	COUNT(*)
FROM countries
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY sum(population) DESC
;

SELECT
	continent ,
    SUM(surface_area), 
    ROUND( AVG(surface_area) )
FROM countries c 
GROUP BY continent
ORDER BY SUM(surface_area) DESC;

SELECT 
	religion, 
	SUM(population), 
	COUNT(*)
FROM countries c 
GROUP BY religion 
ORDER BY SUM(population) DESC
;
-- ukol 3

SELECT 
	continent , 
    ROUND( SUM( landlocked ) / COUNT(*), 2) as landlocked_country_share,
    ROUND( SUM( landlocked * surface_area ) / SUM( surface_area ), 2 ) AS landlocked_area_share,
    ROUND( SUM( landlocked * population ) / SUM( population ), 2 ) AS landlocked_population_share
FROM countries
WHERE continent IS NOT NULL
	AND landlocked IS NOT NULL
GROUP BY continent;

-- ukol 4

SELECT
	continent,
	SUM(population),
	region_in_world
FROM countries c
WHERE continent 
IS NOT NULL
GROUP BY continent, region_in_world
ORDER BY continent ASC,
	SUM(population)DESC;
	
-- ukol 5
SELECT
	continent,
	religion,
	SUM(population),
	COUNT(*)
FROM countries c
GROUP BY continent, religion
ORDER BY continent, SUM(population) DESC;

-- ukol 6
SELECT region_in_world,
	ROUND(SUM(surface_area * yearly_average_temperature) / SUM(surface_area), 2) AS average_temperature
FROM countries c
WHERE continent = 'Africa'
	AND yearly_average_temperature IS NOT NULL
GROUP BY region_in_world
ORDER BY region_in_world

-- cviceni covid 19

SELECT sum(recovered) 
from covid19_basic cb 
WHERE date = '2020-08-30';

SELECT sum(recovered), sum(confirmed)
FROM covid19_basic cb 
where date = '2020-08-30'
;

SELECT 
	SUM(confirmed) - SUM(recovered) AS rozdil 
FROM covid19_basic cb 
WHERE date = '2020-08-30';

SELECT country, sum(confirmed)
FROM covid19_basic_differences cbd 
WHERE country = 'Czechia' AND date = '2020-08-30'
;

SELECT country , sum(confirmed)
FROM covid19_basic_differences cbd 
WHERE date >= '2020-08-01' AND date <= '2020-08-31'
GROUP BY country ;


SELECT country ,
	sum(confirmed)
FROM covid19_basic_differences cbd 
WHERE country IN ('Czechia', 'Austria', 'Slovakia')
	AND date >= '2020-08-20' 
	and date <= '2020-08-30'
GROUP BY country;

SELECT country, max(confirmed)
FROM covid19_basic_differences cbd 
GROUP BY country ;

SELECT country, MAX(confirmed)
FROM covid19_basic_differences cbd 
WHERE country LIKE 'C%'
GROUP BY country;

-- ukol 10

SELECT 
        date,
        country,
        sum(confirmed) as confirmed
FROM covid19_basic_differences
WHERE country in (
		SELECT DISTINCT country FROM lookup_table lt WHERE population>50000000)
      AND date>='2020-08-01'
GROUP BY
        date,
        country;
        
-- úkol 11
SELECT
	SUM(confirmed)
FROM covid19_detail_us_differences cdud
WHERE province = 'Arkansas';

-- ukol 12

SELECT DISTINCT province
FROM lookup_table lt
WHERE country = 'Brasil' AND province IS NOT NULL 
ORDER BY population DESC
LIMIT 1;

-- ukol 13
SELECT 
	`date`	,
	SUM(confirmed),
	ROUND(AVG(confirmed), 2)
FROM covid19_basic_differences cbd
GROUP BY `date`
ORDER BY date DESC;

-- ukol 14 
SELECT province,
	SUM(confirmed)
FROM covid19_detail_us cdu 
WHERE date = '2020-08-30' AND country = 'US'
GROUP BY province
ORDER BY SUM(confirmed)DESC;

-- ukol 15

SELECT date, country, SUM (confirmed)
FROM covid19_basic_differences cbd
GROUP BY date, country;

