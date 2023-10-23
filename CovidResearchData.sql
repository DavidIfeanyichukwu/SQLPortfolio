SELECT *
From CovidDeaths

SELECT *
From CovidVaccinations

-- Let's get the table we will be working with
SELECT [location],[date], total_cases, new_cases, total_deaths, population
From CovidDeaths
ORDER BY 1,2

-- Looking at the Total Cases vs Total Deaths
SELECT [location] [Location],[date] [Date], total_cases [Total Cases],total_deaths [Total Deaths], cast((total_deaths/total_cases) as decimal(10,2)) [Deaths by New Cases], cast((total_deaths / total_cases)* 100 as decimal(10,2)) [Death %age]
From CovidDeaths
ORDER BY 1,2

-- looking critically at specific countries

SELECT [location] [Location],[date] [Date], total_cases [Total Cases],total_deaths [Total Deaths], cast((total_deaths/total_cases) as decimal(10,2)) [Deaths by New Cases], cast((total_deaths / total_cases)* 100 as decimal(10,2)) [Death %age]
From CovidDeaths
WHERE [location] LIKE 'Nigeria'
ORDER BY 1,2

SELECT [location] [Location],[date] [Date], total_cases [Total Cases],total_deaths [Total Deaths], cast((total_deaths/total_cases) as decimal(10,2)) [Deaths by New Cases], cast((total_deaths / total_cases)* 100 as decimal(10,2)) [Death %age]
From CovidDeaths
WHERE [location] LIKE 'New Zealand'
ORDER BY 1,2

SELECT [location] [Location],[date] [Date], total_cases [Total Cases],total_deaths [Total Deaths], cast((total_deaths/total_cases) as decimal(10,2)) [Deaths by New Cases], cast((total_deaths / total_cases)* 100 as decimal(10,2)) [Death %age]
From CovidDeaths
WHERE [location] LIKE 'Africa'
ORDER BY 1,2

SELECT [location] [Location],[date] [Date], total_cases [Total Cases],total_deaths [Total Deaths], cast((total_deaths/total_cases) as decimal(10,2)) [Deaths by New Cases], cast((total_deaths / total_cases)* 100 as decimal(10,2)) [Death %age]
From CovidDeaths
WHERE [location] LIKE '%kingdom' -- for the United Kingdom
ORDER BY 1,2

SELECT [location] [Location],[date] [Date], total_cases [Total Cases],total_deaths [Total Deaths], cast((total_deaths/total_cases) as decimal(10,2)) [Deaths by New Cases], cast((total_deaths / total_cases)* 100 as decimal(10,2)) [Death %age]
From CovidDeaths
WHERE [location] LIKE '%states' -- for the United States
ORDER BY 1,2

SELECT [location] [Location],[date] [Date], total_cases [Total Cases],total_deaths [Total Deaths], cast((total_deaths/total_cases) as decimal(10,2)) [Deaths by New Cases], cast((total_deaths / total_cases)* 100 as decimal(10,2)) [Death %age]
From CovidDeaths
WHERE [location] LIKE 'Australia' -- for Australia
ORDER BY 1,2

-- Looking at the total cases vs the population for Australia and New Zealand
SELECT [location] [Location],[date] [Date], total_cases [Total Cases],total_deaths [Total Deaths], cast((total_deaths/total_cases) as decimal(10,2)) [Deaths by New Cases], cast((total_deaths / total_cases)* 100 as decimal(10,2)) [Death %age]
From CovidDeaths
WHERE [location] IN ('Australia', 'New Zealand', 'Nigeria') -- for Australia and New Zealand
ORDER BY 1,2

SELECT [location] [Location],[date] [Date], total_cases [Total Cases], population, cast((total_cases/population) as decimal(10,2)) [Ratio of Population with COVID], cast((total_cases / population)* 100 as decimal(10,2)) [Population %age with COVID]
From CovidDeaths
-- WHERE [location] IN ('Australia', 'New Zealand', 'Nigeria') -- for Australia and New Zealand
ORDER BY 1,2

-- Looking at countries with highest infection rate compared to Population
SELECT [location] [Location], population [Population], MAX([total_cases]) [Highest Infection Count], cast(MAX((total_cases / population))* 100 as decimal(10,2)) [Population %age with COVID]
From CovidDeaths
-- WHERE [location] IN ('Australia', 'New Zealand', 'Nigeria') -- for Australia and New Zealand
GROUP BY [location], population
ORDER BY 1,2

-- Let's order our result by the Population %age with COVID
SELECT [location] [Location], population [Population], MAX([total_cases]) [Highest Infection Count], cast(MAX((total_cases / population))* 100 as decimal(10,2)) [Population %age with COVID]
From CovidDeaths
-- WHERE [location] IN ('Australia', 'New Zealand', 'Nigeria') -- for Australia and New Zealand
GROUP BY [location], population
ORDER BY 4 DESC -- to get the highest sorted 

-- Showing Countries with the Highest Death Count Per Population
SELECT [location] [Location], population [Population], MAX([total_deaths]) [Total Death Count] -- cast(MAX((total_cases / population))* 100 as decimal(10,2)) [Population %age with COVID]
From CovidDeaths
-- WHERE [location] IN ('Australia', 'New Zealand', 'Nigeria') -- for Australia and New Zealand
WHERE continent IS NOT NULL
GROUP BY [location], population
ORDER BY [Total Death Count] DESC

-- Breaking things down by CONTINENT
SELECT [continent] [Continent], population [Population], MAX([total_deaths]) [Total Death Count] -- cast(MAX((total_cases / population))* 100 as decimal(10,2)) [Population %age with COVID]
From CovidDeaths
-- WHERE [location] IN ('Australia', 'New Zealand', 'Nigeria') -- for Australia and New Zealand
WHERE continent IS NOT NULL
GROUP BY [continent], population
ORDER BY [Total Death Count] DESC

SELECT [location] [Location], population [Population], MAX(total_deaths) [Total Death Count]  -- cast(MAX((total_cases / population))* 100 as decimal(10,2)) [Population %age with COVID]
From CovidDeaths
-- WHERE [location] IN ('Australia', 'New Zealand', 'Nigeria') -- for Australia and New Zealand
WHERE continent IS NULL
GROUP BY [location], population
ORDER BY [Total Death Count] DESC

SELECT [continent] [Continent], [population] [Population], MAX(CAST(total_deaths as bigint)) [Total Death Count], cast(MAX((total_cases / population))* 100 as decimal(10,2)) [Population %age with COVID]
From CovidDeaths
-- WHERE [location] IN ('Australia', 'New Zealand', 'Nigeria') -- for Australia and New Zealand
WHERE continent IS NOT NULL
GROUP BY [continent], population
ORDER BY [Total Death Count] DESC

SELECT distinct continent [Continent], sum(population) [Population]
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY [continent], population

-- To calculate the figures across the globe
SELECT [date] [Date], SUM(new_cases) [Total Cases], SUM(CAST(new_deaths as bigint)) [Total Deaths], SUM(cast(new_deaths as bigint))/SUM(cast(new_cases as bigint))*100 [Death %age]
FROM CovidProject.dbo.CovidDeaths
--WHERE continent is NOT NULL
GROUP BY [date]
ORDER BY 1,2

SELECT SUM(new_cases) [Total Cases], SUM(CAST(new_deaths as bigint)) [Total Deaths], SUM(cast(new_deaths as bigint))/SUM(cast(new_cases as bigint))*100 [Death %age]
FROM CovidProject.dbo.CovidDeaths
--WHERE continent is NOT NULL
--GROUP BY [date]
ORDER BY 1,2

SELECT *
FROM CovidProject.dbo.CovidDeaths dea 
JOIN CovidProject.dbo.CovidVaccinations vac 
    ON dea.[location] = vac.[location]
    and dea.[date] = vac.[date]

-- Looking at Total Population vs Vaccinations

SELECT dea.[continent], dea.[location], dea.[date], dea.population, vac.new_vaccinations
FROM CovidProject.dbo.CovidDeaths dea 
JOIN CovidProject.dbo.CovidVaccinations vac 
    ON dea.[location] = vac.[location]
    and dea.[date] = vac.[date]
WHERE dea.continent is NOT NULL
ORDER BY 1,2,3

SELECT dea.[continent], dea.[location], dea.[date], dea.population, vac.new_vaccinations
FROM CovidProject.dbo.CovidDeaths dea 
JOIN CovidProject.dbo.CovidVaccinations vac 
    ON dea.[location] = vac.[location]
    and dea.[date] = vac.[date]
WHERE dea.continent is NOT NULL
ORDER BY 2,3

-- We will do a rolling count on the new vaccinations to get the summation of new vaccinations
SELECT dea.[continent], dea.[location], dea.[date], dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition BY dea.location)
FROM CovidProject.dbo.CovidDeaths dea 
JOIN CovidProject.dbo.CovidVaccinations vac 
    ON dea.[location] = vac.[location]
    and dea.[date] = vac.[date]
WHERE dea.continent is NOT NULL
ORDER BY 2,3

---
SELECT dea.[continent], dea.[location], dea.[date], dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (Partition BY dea.location)
FROM CovidProject.dbo.CovidDeaths dea 
JOIN CovidProject.dbo.CovidVaccinations vac 
    ON dea.[location] = vac.[location]
    and dea.[date] = vac.[date]
WHERE dea.continent is NOT NULL
ORDER BY 2,3

SELECT dea.[continent] [Continent], dea.[location] [Location], dea.[date] [Date], dea.population [Population], vac.new_vaccinations [New Vaccinations], SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition BY dea.location order by dea.location, dea.date) [Sum of New Vaccinations]
FROM CovidProject.dbo.CovidDeaths dea 
JOIN CovidProject.dbo.CovidVaccinations vac 
    ON dea.[location] = vac.[location]
    and dea.[date] = vac.[date]
WHERE dea.continent is NOT NULL
ORDER BY 2,3

-- Using CTE to input our new column as a recognised column
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, [Sum of New Vaccinations])
AS
(
SELECT dea.[continent] [Continent], dea.[location] [Location], dea.[date] [Date], dea.population [Population], vac.new_vaccinations [New Vaccinations], SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition BY dea.location order by dea.location, dea.date) [Sum of New Vaccinations]
FROM CovidProject.dbo.CovidDeaths dea 
JOIN CovidProject.dbo.CovidVaccinations vac 
    ON dea.[location] = vac.[location]
    and dea.[date] = vac.[date]
WHERE dea.continent is NOT NULL
--ORDER BY 2,3
)
SELECT *, ([Sum of New Vaccinations]/population) * 100 [%age of Vaccinations]
FROM PopvsVac

-- Using a Temp Table
DROP table if exists #PercentPopulationVaccinated
CREATE Table #PercentPopulationVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_Vaccinations NUMERIC,
    SumOfNewVaccinations NUMERIC
)

INSERT into #PercentPopulationVaccinated
SELECT dea.[continent] [Continent], dea.[location] [Location], dea.[date] [Date], dea.population [Population], vac.new_vaccinations [New Vaccinations], SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition BY dea.location order by dea.location, dea.date) [Sum of New Vaccinations]
FROM CovidProject.dbo.CovidDeaths dea 
JOIN CovidProject.dbo.CovidVaccinations vac 
    ON dea.[location] = vac.[location]
    and dea.[date] = vac.[date]
--WHERE dea.continent is NOT NULL
--ORDER BY 2,3

SELECT *, ([SumOfNewVaccinations]/population) * 100 [%age of Vaccinations]
FROM #PercentPopulationVaccinated

-- Creating Views to store data for later visualization

SELECT [continent] [Continent], [population] [Population], MAX(CAST(total_deaths as bigint)) [Total Death Count], cast(MAX((total_cases / population))* 100 as decimal(10,2)) [Population %age with COVID]
From CovidDeaths
-- WHERE [location] IN ('Australia', 'New Zealand', 'Nigeria') -- for Australia and New Zealand
WHERE continent IS NOT NULL
GROUP BY [continent], population
ORDER BY [Total Death Count] DESC

CREATE VIEW PercentPopulationVaccinated AS 
SELECT dea.[continent] [Continent], dea.[location] [Location], dea.[date] [Date], dea.population [Population], vac.new_vaccinations [New Vaccinations], SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition BY dea.location order by dea.location, dea.date) [Sum of New Vaccinations]
FROM CovidProject.dbo.CovidDeaths dea 
JOIN CovidProject.dbo.CovidVaccinations vac 
    ON dea.[location] = vac.[location]
    and dea.[date] = vac.[date]
WHERE dea.continent is NOT NULL
--ORDER BY 2,3

-- We can now query off the View created

SELECT *
FROM PercentPopulationVaccinated