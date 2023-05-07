SELECT *
FROM PortofolioProject..CovidDeaths
ORDER BY 3,4


SELECT *
FROM PortofolioProject..CovidVaccinations
ORDER BY 3,4


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortofolioProject..CovidDeaths
ORDER BY 1,2


--looking at total_cases vs total_deaths
SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 AS DeathPercentage 
FROM PortofolioProject..CovidDeaths
ORDER BY 1,2


--looking at total_cases vs total_deaths in EGYPT
SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 AS DeathPercentage 
FROM PortofolioProject..CovidDeaths
WHERE location = 'Egypt'
ORDER BY 1,2


-- looking at total_cases vs population
SELECT location, date, total_cases, population, (total_cases / population)*100 AS InfectionPercentage
FROM PortofolioProject..CovidDeaths
WHERE location = 'Egypt'
ORDER BY 1,2



-- looking at countries with highest infection percentage
SELECT location, population, MAX(total_cases) AS total_cases_count, MAX((total_cases / population))*100 AS InfectionPercentage
FROM PortofolioProject..CovidDeaths
GROUP BY location, population
ORDER BY 4 DESC

-- looking at countries with highest deaths count
SELECT location, MAX(total_deaths) AS total_deaths_count
FROM PortofolioProject..CovidDeaths
GROUP BY location
ORDER BY 2 DESC
** appear here there is aproblem in the order so we look for the total_deaths column type

-- looking at countries with highest deaths count after corecction of total_deaths column type
SELECT location, MAX(cast(total_deaths AS int)) AS total_deaths_count
FROM PortofolioProject..CovidDeaths
GROUP BY location
ORDER BY 2 DESC
** here appears continent count

--  looking at countries with highest deaths count after removing continent count
SELECT location, MAX(cast(total_deaths AS int)) AS total_deaths_count
FROM PortofolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC


-- looking at continent with highest deaths count
SELECT continent, SUM(cast(total_deaths AS int)) AS total_deaths_count
FROM PortofolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC



-- looking at population vs total vaccinations
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
				SUM(CONVERT(int,v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS rolling_total_vaccinations
FROM PortofolioProject..CovidDeaths AS d
JOIN PortofolioProject..CovidVaccinations AS v
ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY d.location, d.date



-- getting rolling total vaccinations per population using table
WITH t1 
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
				SUM(CONVERT(int,v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS rolling_total_vaccinations
FROM PortofolioProject..CovidDeaths AS d
JOIN PortofolioProject..CovidVaccinations AS v
ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY d.location, d.date
)

SELECT * , (rolling_total_vaccination / population)*100 
FROM t1

