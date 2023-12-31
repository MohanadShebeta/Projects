
Select *
From CovidDeaths
Order By 3,4

--Select *
--From CovidVaccinations
--Order By 3,4


-- Select the Data We are going to use

SELECT Location, Date, Total_cases, New_cases, Total_deaths, Population
From CovidDeaths
ORDER BY 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows the likelyhood of dying when infected by covid

SELECT Location, Date, Total_cases, Total_deaths
, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
WHERE location = 'Egypt'
ORDER BY 1,2


-- looking at the total cases vs the population
-- shows what percentage of population got covid

SELECT Location, Date, population, Total_cases
, (total_cases/population)*100 as InfectionPercentage
From CovidDeaths
WHERE location = 'Egypt'
ORDER BY 1,2


-- Looking at Countries with Highest Inffection Rate compared to Population

SELECT Location, population, MAX(Total_cases)
, MAX((total_cases/population))*100 as InfectionPercentage
From CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY InfectionPercentage DESC


-- Showign Countries with Highest Death Count per Popultion

SELECT Location, MAX(CAST(total_deaths as int)) as TotalDeathCount
From CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC


-- Breaking Thing Down by Continent
--Showing Continents with Highest DEath Count per Population

SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
From CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC


-- GLobal Numbers
-- Sum of Infected Each day

SELECT Date, Sum(New_cases) as total_cases, Sum(Cast(new_deaths as int)) as total_deaths
, Sum(Cast(new_deaths as int))/Sum(New_cases)*100  as DeathPercentage
From CovidDeaths
WHERE Continent is not null
Group By Date
ORDER BY 1,2



-- Looking at Population vs Vacination
-- Also making Counter to Count the Total Vaccinated increasing each Day

Select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dth.location ORDER BY dth.location,
dth.date) as Consecutive_Vacincation_Counting
From CovidDeaths dth
join CovidVaccinations vac
	on dth.location = vac.location
	and dth.date = vac.date
WHERE dth.Continent is not null
order by 2,3



-- Using CTE to Calculate the Percentage of Vacinated people for each day

WITH VacPerc (Continent, Location, Date, Population, New_Vaccinations,
Consecutive_Vacincation_Counting)
as
(
Select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dth.location ORDER BY dth.location,
dth.date) as Consecutive_Vacincation_Counting
From CovidDeaths dth
join CovidVaccinations vac
	on dth.location = vac.location
	and dth.date = vac.date
WHERE dth.Continent is not null
)
Select *, (Consecutive_Vacincation_Counting / population) * 100 as Percentage_Vaccinated
From VacPerc



-- Making the Same Calculation Above, but with Temp Table
-- adding 'drop table' above the table to allow for any future modifications on the table

Drop Table if exists #Vac_Percentage
Create Table #Vac_Percentage
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccination numeric,
Consecutive_Vacincation_Counting numeric
)

INSERT into #Vac_Percentage
Select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dth.location ORDER BY dth.location,
dth.date) as Consecutive_Vacincation_Counting
From CovidDeaths dth
join CovidVaccinations vac
	on dth.location = vac.location
	and dth.date = vac.date
WHERE dth.Continent is not null


Select *, (Consecutive_Vacincation_Counting / population) * 100 as Percentage_Vaccinated
From #Vac_Percentage



--Creating Views for Data Visualizations

CREATE VIEW Vac_Percentage as
Select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dth.location ORDER BY dth.location,
dth.date) as Consecutive_Vacincation_Counting
From CovidDeaths dth
join CovidVaccinations vac
	on dth.location = vac.location
	and dth.date = vac.date
WHERE dth.Continent is not null


Select *
from Vac_Percentage
