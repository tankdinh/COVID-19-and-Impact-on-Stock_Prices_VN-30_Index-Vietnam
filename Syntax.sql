1.
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS death_rate
FROM dbo.covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date;

2.
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS death_rate
FROM dbo.covid_deaths
WHERE location = 'Vietnam'
ORDER BY date;

3.
SELECT location, date, total_cases, population, (total_cases/population) * 100 AS infection_rate
FROM dbo.covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date;

4.
SELECT location, date, total_cases, population, (total_cases/population) * 100 AS infection_rate
FROM dbo.covid_deaths
WHERE location = 'Malaysia'
ORDER BY date;

5.
SELECT location, population, MAX(total_cases) AS total_cases, MAX((total_cases/population)) * 100 AS infection_rate
FROM dbo.covid_deaths
GROUP BY location, population
ORDER BY infection_rate DESC;

6. 
SELECT location, population, MAX(total_cases) AS total_cases, MAX((total_cases/population)) * 100 AS infection_rate
FROM dbo.covid_deaths
WHERE location = 'Malaysia'
GROUP BY location, population
--ORDER BY infection_rate DESC;

7.
SELECT location, population, MAX(total_deaths) AS total_deaths, (MAX(total_deaths)/population) * 100 AS death_rate_by_population
FROM dbo.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY death_rate_by_population DESC;

8.
SELECT location, population, MAX(total_deaths) AS total_deaths, (MAX(total_deaths)/population) * 100 AS death_rate_by_population
FROM dbo.covid_deaths
WHERE location = 'Malaysia'
GROUP BY location, population
ORDER BY death_rate_by_population DESC;

9.
SELECT d.location, d.population, MAX(total_cases) AS total_cases, 
 MAX(total_deaths) AS total_deaths,
 (MAX(total_cases)/d.population) * 100 AS infection_rate, 
 (MAX(total_deaths)/MAX(total_cases)) * 100 AS death_perc
FROM dbo.covid_deaths AS d
JOIN dbo.covid_vaccs AS v
 ON d.date = v.date
WHERE d.continent IS NULL
 AND d.location != 'World'
 AND d.location != 'International'
 AND d.location != 'European Union'
GROUP BY d.continent, d.location, d.population
ORDER BY (MAX(total_cases)/d.population) * 100 DESC;

 10. Worldwide - Total Cases, Total Death, Infection Rate, Death Rate (if infected), and Vaccination Rate by Income Level

SELECT 
  ct.location, ct.population,
  MAX(cs.total_cases) AS total_cases, 
  MAX(cs.total_deaths) AS total_deaths,
  100.0 * MAX(cs.total_cases) / ct.population AS infection_rate,
  100.0 * MAX(cs.total_deaths) / MAX(cs.total_cases) AS death_infected_rate,
  100.0 * MAX(vc.total_vaccinations) / ct.population AS total_vaccination_rate
FROM countries ct 
JOIN cases cs ON cs.iso_code = ct.iso_code
JOIN vaccinations vc ON vc.iso_code = ct.iso_code
WHERE ct.location LIKE '%income'
GROUP BY ct.location, ct.population
ORDER BY death_infected_rate DESC;


10.
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
 SUM(CONVERT(INT,v.new_vaccinations)) OVER (PARTITION BY d.location
  ORDER BY d.location, d.date) 
  AS rolling_vaccinations
-- Partition by location & date to ensure that once the rolling sum of new vaccinations for a location stops, the rolling sum starts for the next location
FROM dbo.covid_deaths AS d
JOIN dbo.covid_vaccs AS v
 ON d.location = v.location 
AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY d.location, d.date;

 1. Worldwide - Total Vaccinations, People Vaccinated, People Fully Vaccinated, and Total Boosters by Country

11.
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
 SUM(CONVERT(INT,v.new_vaccinations)) OVER (PARTITION BY d.location
  ORDER BY d.location, d.date) AS rolling_vaccinations
FROM dbo.covid_deaths AS d
JOIN dbo.covid_vaccs AS v
 ON d.location = v.location 
 AND d.date = v.date
WHERE d.location = 'Vietnam'
ORDER BY d.location, d.date;

12.
WITH vaccination_per_population
AS 
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
 SUM(CONVERT(INT,v.new_vaccinations)) OVER (PARTITION BY d.location
  ORDER BY d.location, d.date) AS rolling_vaccinations
FROM dbo.covid_deaths AS d
JOIN dbo.covid_vaccs AS v
 ON d.location = v.location 
 AND d.date = v.date
WHERE d.continent IS NOT NULL AND d.location = 'Malaysia'
)
SELECT *, (rolling_vaccinations/population) * 100 AS vaccinated_per_population
FROM vaccination_per_population;

13.
