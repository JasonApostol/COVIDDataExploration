-- Test to ensure that both tables (.CSV) have imported properly 

-- SELECT * 
-- FROM CovidData.coviddeaths
-- ORDER BY 3,4;

-- SELECT *
-- FROM CovidData.covidvaccinations
-- ORDER BY 3,4;

-- Looking at Total Deaths vs Total Cases (by country)
SELECT Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases) *100 AS DeathPercentage
FROM CovidData.coviddeaths
ORDER BY Location;

-- Looking at Total Deaths vs Total Cases (USA)
SELECT Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases) *100 AS DeathPercentage
FROM CovidData.coviddeaths
WHERE Location LIKE '%states%'
ORDER BY Location;

-- Looking at Total Cases vs Population
-- Percentage of population that has COVID
SELECT Location, date, population, new_cases, total_cases, (total_cases/population) *100 AS PopulationPercentInfected
FROM CovidData.coviddeaths
ORDER BY Location;

-- Looking at countries with highest infection rate compared to population
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)) *100 AS PopulationPercentInfected
FROM CovidData.coviddeaths
GROUP BY Location, Population
ORDER BY PopulationPercentInfected DESC;

-- Looking at countries with highest death count 
SELECT Location, Population, MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM CovidData.coviddeaths
GROUP BY Location, Population
ORDER BY TotalDeathCount DESC;

-- Filtering death count by continent
SELECT continent, MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM CovidData.coviddeaths
WHERE continent NOT LIKE "" -- Hard coded to remove glitch within .CSV file 
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Global numbers
SELECT date, SUM(new_cases) AS GlobalCases, SUM(new_deaths) AS GlobalDeathCount, (SUM(new_deaths)/SUM(new_cases)) * 100 AS DeathPercentage
FROM CovidData.coviddeaths
GROUP BY date 
ORDER BY date DESC;

-- Looking at Total Population vs Total Vaccinations
SELECT cd.continent, cd.location, cd.date, cd.population, CAST(cv.new_vaccinations AS UNSIGNED) as newVax, SUM(CAST(cv.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY cd.location) AS RollingPeopleVaccinated
FROM CovidData.coviddeaths cd, CovidData.covidvaccinations cv
WHERE cd.location = cv.location AND cd.date = cv.date
ORDER BY cd.location, cd.date;

-- Using view

-- CREATE VIEW PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS 
-- SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,  CAST(cv.new_vaccinations AS UNSIGNED) as newVax, SUM(CAST(cv.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY cd.location) AS RollingPeopleVaccinated
-- FROM CovidData.coviddeaths cd, CovidData.covidvaccinations cv
-- WHERE cd.location = cv.location AND cd.date = cv.date;
-- Testing view

-- SELECT (RollingPeopleVaccinated/Population) * 100 AS PercentVaccinated
-- FROM PopvsVac;

-- DROP TABLE IF EXISTS;
-- CREATE TABLE PercentPopulationVaccinated(
-- Continent nvarchar(255),
-- Location nvarchar(255),
-- Date datetime,
-- Population numeric,
-- New_vaccinations numeric,
-- RollingPeopleVaccinated numeric
-- )

