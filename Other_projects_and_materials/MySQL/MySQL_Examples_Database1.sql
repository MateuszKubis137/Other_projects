# The following code depends on a database that is available in a folder named "databases" under the name "database1"

# Which official languages are the most commonly used in Europe?
# The soultion using subquery
SELECT 
    language, 
    COUNT(*) liczba
FROM countrylanguage
WHERE 
    IsOfficial = 'T'
    AND countrycode IN (
    SELECT code FROM country WHERE continent = 'Europe')
GROUP BY language
ORDER BY liczba DESC;

# The solution using join
SELECT 
    language, 
    COUNT(*) liczba
FROM countrylanguage, country
WHERE
    IsOfficial = 'T'
    AND continent = 'Europe'
    AND countrylanguage.countrycode = country.code
GROUP BY language
ORDER BY liczba DESC;

# Select the names, population, and surface area of all Asian countries, and calculate the population density. The population of each country must be greater than 
# the population of the most populous European country, and the population density must be greater than the population density of all African countries.
SELECT
    name,
    population,
    surfaceArea,
    ROUND(population/surfaceArea, 2) `Population density`
FROM country
WHERE 
    continent = 'Asia'
    AND population > (
        SELECT MAX(population) 
        FROM country 
        WHERE 
            continent = 'Europe' 
            AND name <> 'Russian Federation')
    AND ROUND(population/surfaceArea, 2) > ALL (
        SELECT ROUND(population/surfaceArea, 2) 'density' 
        FROM country 
        WHERE continent = 'Africa' 
        order by `density` desc);

# Select country name, continent, population and languages that are official and used by over 50% of the population order by continent and country name.
SELECT 
    country.Name,
    continent,
    population,
    language
FROM countrylanguage
    JOIN country ON countrylanguage.countrycode = country.code
WHERE 
    GNP > 1000 
    AND countrylanguage.Percentage > 50
    AND isofficial = 'T'
Order BY continent, country.name; 

# Retrieve country names and determine the number of people living in cities with a population greater than 100,000. 
# Calculate the percentage of the total population living in these cities for the given country.
SELECT 
    country.name, 
    SUM(city.population) BigCitiesPopulation, 
    CONCAT(ROUND(SUM(city.population) / ANY_VALUE(country.population) * 100, 2), "%")  PercentageOfTotal 
FROM country 
    JOIN city ON country.code = city.countrycode 
WHERE 
    continent = 'South America' 
    AND city.population > 100000 
GROUP BY country.name;

# Select languages that are not official in any country but are used in more than 10 countries.
SELECT DISTINCT language
FROM countrylanguage 
WHERE language IN (
    SELECT language 
    FROM (
        SELECT language, COUNT(*) `number of countries`
        FROM countrylanguage 
        WHERE IsOfficial = 'F' 
        GROUP BY language
        ) table1 
    WHERE `number of countries` > 10)

EXCEPT

SELECT language
FROM countrylanguage 
WHERE IsOfficial = 'T';

# Select the maximum average city population for all South American countries, all Oceania countries, and all North American countries.
SELECT 
    Continent, 
    MAX(avg_population) `Maximum average population` 
FROM (
    SELECT 
	country.name, 
        ANY_VALUE(continent) Continent, 
	AVG(city.population) avg_population
    FROM city 
        INNER JOIN country ON city.CountryCode = country.Code
    WHERE continent IN (
        'South America', 
        'North America', 
        'Oceania')
    GROUP BY country.name
    ) AS table_1
Group by Continent
ORDER BY MAX(avg_population) 
;
