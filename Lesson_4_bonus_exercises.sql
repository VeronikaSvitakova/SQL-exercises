/**
* Bonusova cviceni lekce 4
* ukol 1
**/

SELECT
	c.country,
	c.capital_city,
	c.population,
	r.religion,
	r.population AS 'adherent'
FROM countries c
JOIN religions r 
	ON c.country = r.country
	AND r.year = '2020';

-- ukol 2

SELECT c.country,
	round(e.GDP/1000000, 2) AS gdp_millions_dollar,
	e.gini,
	e.taxes,
	c.independence_date
FROM countries c
JOIN economies e
	ON c.country = e.country
	AND c.independence_date <= e.YEAR;
	
-- ukol 3

SELECT c.country,
	c.population
FROM countries c
LEFT JOIN economies e
	ON c.country = e.country
	AND e.YEAR =2020
WHERE e.country IS NULL 
ORDER BY c.population;

-- ukol 4
SELECT a.country,
	a.life_expectancy_1970,
	b.life_expectancy_2015,
	round(b.life_expectancy_2015/a.life_expectancy_1970, 2) AS life_expectancy_ratio
FROM
		(SELECT le.country,
			le. life_expectancy AS life_expectancy_1970
		FROM life_expectancy le
		WHERE le.YEAR = 1970) AS a
	JOIN
		(SELECT le.country,
			le. life_expectancy AS life_expectancy_2015
		FROM life_expectancy le
		WHERE le.YEAR = 2015) AS b
		ON a.country = b.country;
-- ukol 5
	
SELECT e.country,
	e.`year`,
	e2.YEAR +1 AS prev_year,
	e2.`year`,
	round((e.GDP - e2.GDP)/e2.GDP * 100, 2) AS gdp_ratio,
	round ((e.population - e2.population)/e2.population* 100, 2) AS population_ratio
FROM economies e
JOIN economies e2
	ON e.country = e2.country
	AND e.YEAR= e2.YEAR +1
	AND e.YEAR< 2020;
	
-- ukol 6

SELECT r.country,
	r.religion,
	round( r.population/r2.total_population_2020*100, 2) AS religion_share_2020
FROM religions r
JOIN (
	SELECT r.country, r.YEAR, sum(r.population) AS total_population_2020
	FROM religions r
	WHERE r.YEAR = 2020 
		AND r.country != 'All countries'
	GROUP BY r.country
	) r2
	ON r.country= r2.country
	AND r.YEAR= r2.YEAR
	AND r.population> 0;
	
-- ukol 1 (COVID - 19 JOIN)

CREATE VIEW v_lookup_table_null AS 
SELECT *
FROM lookup_table lt
WHERE province IS NULL;

-- ukol 1b

SELECT*
FROM covid19_basic cb
LEFT JOIN v_lookup_table_null AS a
	ON cb.country = a.country;
	
-- ukol 2

SELECT*
FROM covid19_basic cb
LEFT JOIN covid19_basic_differences cbd
	ON cb.country = cbd.country
	AND cb.`date`= cbd.`date`;

-- ukol 3

SELECT cdu.*,
	cdud.confirmed AS confirmed_diff
FROM covid19_detail_us cdu
LEFT JOIN covid19_detail_us_differences cdud
	ON cdu.`date`= cdud.`date`
	AND cdu.country=cdud.country
	AND cdu.admin2=cdud.admin2
	;

-- ukol 4
SELECT *
FROM covid19_detail_us cdu
LEFT JOIN covid19_detail_us_differences cdud
	ON cdu.country=cdud.country
	AND cdu.`date`=cdud.`date`
	AND cdu.province = cdud.province
	AND cdu.admin2 = cdud.admin2
LEFT JOIN lookup_table lt
	ON cdu.country=lt.country
	AND cdu.province=lt.province
	AND cdu.admin2=lt. admin2;

-- ukol 5
SELECT 
        *
FROM covid19_detail_global cdg  
LEFT JOIN covid19_detail_global_differences cdgd
	ON     cdg.date = cdgd.date
   AND cdg..country = cdgd.country
   AND cdg.province = cdgd.province;
  
 -- ukol 6
  
  SELECT 
        *
FROM covid19_detail_global base 
LEFT JOIN covid19_detail_global_differences a
ON     base.date = a.date
   AND base.country = a.country
   AND base.province = a.province 
LEFT JOIN lookup_table b 
ON     base.country = b.country
   AND base.province = b.province
   
  -- ukol 7
   
SELECT
        base.date,
        base.country,
        (base.confirmed*1000000)/a.population
FROM (
          SELECT 
                  date,
                country,
                confirmed 
          FROM covid19_basic cb
          WHERE country IN ('Czechia','Germany')
         ) base
LEFT JOIN 
         (
          SELECT
                  country,
                  population
          FROM lookup_table lt 
          WHERE country IN ('Czechia','Germany')
                AND province is null
         ) a
ON base.country = a.country
ORDER BY date desc, country

-- ukol 10
SELECT cb.*,
	a.population
FROM (SELECT lt.country, lt.population
	FROM lookup_table lt
	WHERE province IS NULL 
	AND population < 1000000
) a
INNER JOIN covid19_basic cb
	ON cb.country=a.country;
-- ukol 11
SELECT 
    datumy.date,
    zeme.country
FROM (
     SELECT DISTINCT 
         date
     FROM covid19_basic
     ) datumy
CROSS JOIN
    (
     SELECT DISTINCT 
         country
     FROM covid19_basic
     ) zeme;
    
-- ukol 12

SELECT 
    datumy.date,
    zeme.country,
    CASE WHEN cbd.confirmed IS NULL THEN 0
    ELSE cbd.confirmed END AS confirmed
FROM (
     SELECT DISTINCT 
         date
     FROM covid19_basic
     ) datumy
CROSS JOIN
    (
     SELECT DISTINCT 
         country
     FROM covid19_basic
     ) zeme
LEFT JOIN covid19_basic_differences cbd
	ON datumy.`date`=cbd.`date`
	AND zeme.country = cbd.country;

-- covid -19: pokracovani join - ukol 1
	
SELECT c.country , c.province , c.date, 
    case when WEEKDAY(c.date) in (5, 6) then 1 else 0 end as weekend, 
    c.confirmed , lt.population , 
    round( c.confirmed / lt.population * 1000000, 2 ) as cases_per_million
FROM covid19_detail_global_differences c
JOIN lookup_table lt 
    on c.country = lt.country 
    and c.province = lt.province 
    and c.country = 'United Kingdom'
    and lt.population > 1000000
    and month(c.date) = 11
ORDER BY c.province , c.date desc


-- ukol 2


 
