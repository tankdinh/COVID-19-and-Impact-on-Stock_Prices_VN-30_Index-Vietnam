
## :bookmark_tabs: Table of Contents 

 * [Data Preparation](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/README.md?plain=1#L13)
 * [Data Processing](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/blob/aaf7c55bb45240001aa7e734fd8a61a45f61cb04/README.md?plain=1#L18-L20)
 * [Exploratory Data Analysis]()
 * [Data Visualization]()

---

### Data Preparation
The dataset for this project which contains raw COVID-19 data collected from January 2020 to date and stock prices of in total 30 indexes listed on Vn-30 Index updated to 25th-June-2021 are available on [Our World In Data](https://ourworldindata.org/covid-deaths) and [Kaggle](https://www.kaggle.com/datasets/nguyenngocphung/stock-prices-vn30-indexvietnam?resource=download) with the [CC0: Public Domain](https://creativecommons.org/publicdomain/zero/1.0/) license. More details and information can be found in this [Github Document](https://github.com/owid/covid-19-data/blob/master/public/data/README.md).
location
date
total_cases
total_deaths
population

location
continent
new_vaccination

---

### Data Processing
Subsequently, the .XLSX files are imported to SQL server

---

### Exploratory Data Analysis

####1. Total Cases, Total Deaths and Death Rate sorted by Country and Date Worldwide
--Death Rate shows the likelihood of dying if you are infected with Covid-19
```TSQL
SELECT location, date, total_cases, total_deaths, concat(round((total_deaths/total_cases)*100,2), '%')  as death_rate
FROM COVID.dbo.covid_death$
WHERE continent is not null and total_cases is not null
ORDER BY 1,2;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/58c4281d-8fc0-4379-8ab7-9227060eaa6a)

* Afghanistan had the 1st death on 23 Mar 2020 after 40 cases. The likelihood of dying on that date was 2.5%.

####2. Total Cases, Total Deaths and Death Rate sorted by Country and Date in Vietnam
--Death Rate shows the likelihood of dying if you are infected with Covid-19
```TSQL
SELECT location, date, total_cases, total_deaths, concat((total_deaths/total_cases) * 100, '%') as death_rate
FROM COVID.dbo.covid_death$
WHERE continent is not null and location = 'Vietnam'
ORDER BY 1,2;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/6f75ffe4-6cd8-499f-bb19-ca5d53ee02de)
* Vietnam had 2 first deaths on 1st Aug 2020. The likelihood of dying on that date was 0.35%.
  
####3. Infection Rate per Population sorted by Country & Date Worldwide
-- Show the percentage of population infected Covid-19 at a given date
```TSQL
SELECT location, date, total_cases, population, total_cases, (total_cases/population)*100 as infection_rate
FROM COVID.dbo.covid_death$
WHERE continent is not null and total_cases is not null
ORDER BY 1,2;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/87974321-2882-4a48-9425-878787411242)
* This is the infection rate over the population of a country at a given date.
  
####4. Infection Rate per Population by Date in Vietnam
-- Show the percentage of population contracting Covid-19 in Vietnam at a given date
```TSQL
SELECT location, date, total_cases, population, (total_cases/population) * 100 as infection_rate
FROM COVID.dbo.covid_death$
WHERE location = 'Vietnam' and total_cases is not null
ORDER BY 2;
```
 ![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/2f4e5fae-3516-4cd8-b93b-2b5c9ef71060)
*On April 2023, the infection rate was 11 to 12 out of 100 people in Vietnam.

####5. Countries with Highest Infection Rate compared to Population Worldwide
```TSQL
SELECT location, population, MAX(total_cases) AS total_cases, MAX((total_cases/population)) * 100 AS infection_rate
FROM COVID.dbo.covid_death$
WHERE continent is not null and total_cases is not null
GROUP BY location, population
ORDER BY 4 DESC;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/b9ec0f5c-4346-4ce4-af29-a0960e6d2e1a)
* Above is the top 18 countries with highest infection rate.

####6. Overall Highest Infection Rate in Vietnam
```TSQL
SELECT location, population, MAX(total_cases) AS total_cases, MAX((total_cases/population)) * 100 AS infection_rate
FROM COVID.dbo.covid_death$
WHERE location = 'Vietnam' and total_cases is not null
GROUP BY location, population
ORDER BY 4 DESC;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/1e5053b4-720b-4adf-b9e0-bd6fc3edad03)
* With the population of more than 98 million, until 12 Dec 2022, the infection rate in Vietnam is 11.74%.
  
####7. Highest Death Count per Population & Death Rate Worldwide
```TSQL
SELECT location, population, MAX(total_deaths) AS total_deaths, (MAX(total_deaths)/population) * 100 AS death_rate_by_population
FROM COVID.dbo.covid_death$
WHERE continent is not null and total_cases is not null
GROUP BY location, population
ORDER BY death_rate_by_population DESC;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/82968362-bfea-4ea9-9a26-7bdc65835029)
* Peru has highest death rate, while US has highest death count.
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/f0deba9c-6afe-4829-ad70-60b22e7e65b6)

####8. Highest Death Count by Population & Death Rate in Vietnam
```TSQL
SELECT location, population, MAX(total_deaths) AS total_deaths, (MAX(total_deaths)/population) * 100 AS death_rate_by_population
FROM COVID.dbo.covid_death$
WHERE location = 'Vietnam' and total_cases is not null
GROUP BY location, population
ORDER BY death_rate_by_population DESC;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/57d38036-50fc-4b4d-b47f-09f4740fac2f)
* Up to 12 Dec 2022, Vietnam has the average death of 0.04%.

####9. Infection Rate & Death Rate by Continent 
```TSQL
SELECT d.location, d.population, MAX(total_cases) AS total_cases, 
 MAX(total_deaths) AS total_deaths,
 (MAX(total_cases)/d.population) * 100 AS infection_rate, 
 (MAX(total_deaths)/MAX(total_cases)) * 100 AS death_perc
FROM COVID.dbo.covid_death$ AS d
JOIN COVID.dbo.covid_vaccination$ AS v
 ON d.date = v.date
WHERE d.continent IS NULL
 AND d.location NOT IN ('World', 'International', 'European Union') 
 AND d.location NOT LIKE '%income'
GROUP BY d.continent, d.location, d.population
ORDER BY (MAX(total_cases)/d.population) * 100 DESC;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/b27e51fb-c814-4923-87ed-7efcaa8ef557)
* Africa has the highest death rate (if infected), followed by Americas.
* Americas has highest vaccination rate, followed by Asia.
* Europe has the highest infection rate, followed by Oceania.

10. Total Cases, Total Death, Infection Rate, Death Rate (if infected), and Vaccination Rate by Income Level Worldwide
```TSQL
SELECT d.location, d.population, MAX(total_cases) AS total_cases, 
 MAX(total_deaths) AS total_deaths,
 (MAX(total_cases)/d.population) * 100 AS infection_rate, 
 (MAX(total_deaths)/MAX(total_cases)) * 100 AS death_perc
FROM COVID.dbo.covid_death$ AS d
JOIN COVID.dbo.covid_vaccination$ AS v
 ON d.date = v.date
WHERE d.continent IS NULL
  AND d.location  LIKE '%income'
GROUP BY d.continent, d.location, d.population
ORDER BY (MAX(total_cases)/d.population) * 100 DESC;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/361dd74e-2aff-4829-b00c-a37d61af280a)
* Low income countries have highest death rate (if infected) and lowest vaccination rate.
* High income countries have the lowest death rate (if infected) and highest vaccination rate.

-- ANALYSIS BY VACCINATION --

####1. Total Vaccinations, People Vaccinated, People Fully Vaccinated, and Total Boosters by Country
```TSQL
SELECT 
  d.location, d.population,
  MAX(v.total_vaccinations) AS total_vaccination, 
  MAX(v.people_vaccinated) AS people_vaccinated, 
  MAX(v.people_fully_vaccinated) AS people_fully_vaccinated,
  MAX(v.total_boosters) AS total_boosters
FROM COVID.dbo.covid_vaccination$  AS v
JOIN COVID.dbo.covid_death$ AS d ON d.date = v.date
WHERE d.continent IS NOT NULL
GROUP BY d.location, d.population
ORDER BY total_vaccination DESC;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/5c5bbb17-6c4c-45f4-a7ba-de056d3e6cb3)
* Above is the 10 leading countries in terms of total number of vaccinations. 
* China is currently on top, Vietnam is at 9th place.

####2. Total Vaccinations, People Vaccinated, People Fully Vaccinated, and Total Boosters in Vietnam
```TSQL
SELECT 
  d.location, d.population,
  MAX(v.total_vaccinations) AS total_vaccination, 
  MAX(v.people_vaccinated) AS people_vaccinated, 
  MAX(v.people_fully_vaccinated) AS people_fully_vaccinated,
  MAX(v.total_boosters) AS total_boosters
FROM COVID.dbo.covid_vaccination$  AS v
JOIN COVID.dbo.covid_death$ AS d ON d.date = v.date
WHERE d.location = 'Vietnam'
GROUP BY d.location, d.population
ORDER BY total_vaccination DESC;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/4fcfc7d2-e86b-4caa-9c2a-0cdf86d4d975)


####3. Total Vaccinations Rate, People Vaccinated Rate, People Fully Vaccinated Rate, and Total Boosters Rate by Country. 
--- These metrics show the overall percentage of population vaccinated against Covid-19
```TSQL
SELECT 
   d.continent, d.location, d.population,
  MAX(v.total_vaccinations)/d.population *100 AS total_vaccination_rate, 
  MAX(v.people_vaccinated)/d.population *100 AS people_vaccinated_rate, 
  MAX(v.people_fully_vaccinated)/d.population *100 AS people_fully_vaccinated_rate,
  MAX(v.total_boosters)/d.population *100 AS total_boosters_rate
FROM COVID.dbo.covid_vaccination$  AS v
JOIN COVID.dbo.covid_death$ AS d ON d.date = v.date
WHERE d.continent IS NOT NULL
GROUP BY d.continent, d.location, d.population
ORDER BY total_vaccination_rate DESC;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/cffb2e5c-b8a2-4e65-aac0-a8523401943e)
* Cuba has the highest total vaccination rate. Most Asia countries are on top 12.

####4. Total Vaccinations Rate, People Vaccinated Rate, People Fully Vaccinated Rate, and Total Boosters Rate in Vietnam.
---These metrics show the overall percentage of Vietnamese population vaccinated against Covid-19
```TSQL
SELECT 
    d.location, d.population,
  MAX(v.total_vaccinations)/d.population *100 AS total_vaccination_rate, 
  MAX(v.people_vaccinated)/d.population *100 AS people_vaccinated_rate, 
  MAX(v.people_fully_vaccinated)/d.population *100 AS people_fully_vaccinated_rate,
  MAX(v.total_boosters)/d.population *100 AS total_boosters_rate
FROM COVID.dbo.covid_vaccination$  AS v
JOIN COVID.dbo.covid_death$ AS d ON d.date = v.date
WHERE d.location = 'Vietnam'
GROUP BY d.location, d.population;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/b3ce9c93-642e-43c6-9b00-fa809ac55179)
* The vaccination rate over the population of Vietnam is about 269%, which is true. Up to now, most Vietnamese have already vaccinated at least twice.
* Over 92% of Vietnamese population has vaccinated at least 1 dose.
* Over 86% of Vietnamese population has fully vacciated.
  
####5. Rolling Vaccination Rate, New Cases, and New Deaths by Country and Date.
---These metrics show the movement of New Cases and New Deaths as the population vaccinated rate increases
```TSQL
SELECT 
  d.continent, d.location, v.date, d.population, 
  SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, v.date) AS rolling_vaccination,
  SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, v.date)
    / d.population * 100.0 AS vaccination_per_pop,
  d.new_cases, d.new_deaths
FROM COVID.dbo.covid_vaccination$  AS v
JOIN COVID.dbo.covid_death$ AS d ON d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY d.location, v.date;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/31197fcb-4f62-4592-acde-8996c3abc4f6)
* Vaccinations in Malaysia began on 25 Feb 2021.
  
####6. Rolling Vaccination Rate, New Cases, and New Deaths by Date in Vietnam.
---These metrics show the movement of New Cases and New Deaths as the population vaccinated rate increases
```TSQL
SELECT 
 d.continent, d.location, v.date, d.population, 
  SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, v.date) AS rolling_vaccination,
  SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, v.date)
    / d.population * 100.0 AS vaccination_per_pop,
  d.new_cases, d.new_deaths
FROM COVID.dbo.covid_vaccination$  AS v
JOIN COVID.dbo.covid_death$ AS d ON d.date = v.date
WHERE d.location = 'Vietnam'
ORDER BY v.date
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/7e0b0cd7-b966-43d1-beaf-ecc87322982e)
* Vaccinations in Vietnam began on 12 Mar 2021.

####1. Stock Prices of 30 indexes listed on VN-30 Index a year before the Pandemic.
```TSQL
SELECT [ticker], AVG([open]) AS avg_open, AVG([high]) AS avg_high, AVG([low]) AS avg_low, AVG([close]) AS avg_close, AVG([volume]) AS avg_volume
FROM COVID.dbo.index$
WHERE [date] BETWEEN '2019-01-01' AND '2020-01-22'
GROUP BY [ticker], [date]
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/25f9da60-5c35-4478-9275-32b77defaddf)


####2. Infection Rate & Death Rate vs Vn-30 Index Closing Price by Date during Phase 1 of the Pandemic (23 January – 24 July 2020).
```TSQL
SELECT d.date, location, new_cases, total_cases, new_deaths, total_deaths, (total_cases/population) * 100 AS infection_rate, 
  i.[ticker], i.[close]
FROM COVID.dbo.covid_death$ AS d
LEFT JOIN COVID.dbo.index$ AS i
 ON d.date = i.date
WHERE location = 'Vietnam' AND i.[ticker] is not null
 AND d.date BETWEEN '2020-01-23' AND '2020-07-24'
 ORDER BY i.[ticker], d.date ASC;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/4440d5bb-a3b7-4348-8d65-d343a0b753ec)
* Stock prices across the world, including in Vietnam, experienced significant declines as the pandemic spread and lockdowns were implemented. Investors were uncertain about the economic impact of the virus.

####3. Infection Rate & Death Rate vs Vn-30 Index Closing Price by Date during Phase 2 of the Pandemic (25 July 2020 – 27 January 2021)
```TSQL
SELECT d.date, location, new_cases, total_cases, new_deaths, total_deaths, (total_cases/population) * 100 AS infection_rate, 
  i.[close], i.[ticker]
FROM COVID.dbo.covid_death$ AS d
LEFT JOIN COVID.dbo.index$ AS i
 ON d.date = i.date
WHERE location = 'Vietnam' AND i.[ticker] is not null
 AND d.date BETWEEN '2020-07-25' AND '2021-01-27'
ORDER BY i.[ticker], d.date ASC;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/68785394-72ad-4a62-b5c4-36157c37ad18)
* As governments and central banks implemented fiscal and monetary measures to counteract the economic effects of the pandemic, stock prices often experienced periods of volatility and recovery. News about vaccine developments and easing restrictions might have contributed to market optimism.
* Vietnam was declared free of community transmission of COVID-19 for the second time. The stock prices of the VN-30 Index reached record highs.

####4. Infection Rate & Death Rate vs Vn-30 Index Closing Price by Date during Phase 3 of the Pandemic (28 January – 26 April 2021)
```TSQL
SELECT d.date, location, new_cases, total_cases, new_deaths, total_deaths, (total_cases/population) * 100 AS infection_rate, 
  i.[close], i.[ticker]
FROM COVID.dbo.covid_death$ AS d
LEFT JOIN COVID.dbo.index$ AS i
 ON d.date = i.date
WHERE location = 'Vietnam' AND i.[ticker] is not null
 AND d.date BETWEEN '2021-01-28' AND '2021-04-26'
ORDER BY i.[ticker], d.date ASC;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/8c811236-a512-48c5-8c88-6a9820a1c6db)
* This outbreak started in Hai Duong from a person who was found positive after entering Japan, and the true source of the infection is unknown. The VN-30 Index fell by 2.2% on that day, as investors became concerned about the economic impact of the new outbreaks but it slowly recovered.
  
####5. Infection Rate & Death Rate vs Vn-30 Index Closing Price by Date during Phase 4 of the Pandemic (27 April 2021 – ongoing)
```TSQL
SELECT d.date, location, new_cases, total_cases, new_deaths, total_deaths, (total_cases/population) * 100 AS infection_rate, 
  i.[close], i.[ticker]
FROM COVID.dbo.covid_death$ AS d
LEFT JOIN COVID.dbo.index$ AS i
 ON d.date = i.date
WHERE location = 'Vietnam' AND i.[ticker] is not null
 AND d.date > '2021-04-27'
ORDER BY i.[ticker], d.date ASC;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/0b137b71-5cf8-48a3-b543-2c83cca0d505)
* Outbreaks were discovered in all localities due to the more transmissible Delta variant and Omicron variant was negative. It initially scared the investors just like the previous outbreak and it also recovered just like the precedent.

####6.
```TSQL
SELECT v.date, location, population, new_vaccinations, total_vaccinations, (total_vaccinations/population) * 100 AS vaccination_rate, 
  i.[close], i.[ticker]
FROM COVID.dbo.covid_vaccination$ AS v
LEFT JOIN COVID.dbo.index$ AS i
 ON v.date = i.date
WHERE location = 'Vietnam' AND i.[ticker] is not null
  AND (total_vaccinations/population) * 100 > 1
ORDER BY i.[ticker], v.date ASC;
```
![image](https://github.com/tankdinh/COVID-19-and-Impact-on-Stock_Prices_VN-30_Index-Vietnam/assets/126235420/2987e8b0-bb30-4421-87f2-ba756500301c)
* Stock Prices showed promising numbers when vaccinations started to take effect in Viet Nam.

Different sectors of the economy were affected differently. Sectors such as tourism, hospitality, and retail might have seen more significant declines due to lockdowns and reduced consumer activity. On the other hand, sectors related to technology, healthcare, and e-commerce might have experienced relative resilience or even growth.
Measures taken by the Vietnamese government to manage the pandemic, such as lockdowns, travel restrictions, and economic support packages, could have influenced investor sentiment and stock prices.
Over time, as Vietnam adapted to the pandemic and businesses adjusted their operations, stock prices might have reflected changing market dynamics.   
