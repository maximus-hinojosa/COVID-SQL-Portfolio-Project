--Full tables of all data
Select *
From [Portfolio Project]..CovidDeaths
order by 3,4

Select *
From [Portfolio Project]..CovidVaccinations
order by 3,4
--
Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Chronological mortality rate of COVID 19 in the United States

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as MortalityRate
From [Portfolio Project]..CovidDeaths
Where Location like '%state%'
order by 1,2


-- Looking at Total Cases vs Population
--Percentage of United States population who have contracted Covid

Select Location, date, total_cases, population, (total_cases/population)*100 as InfectionRate
From [Portfolio Project]..CovidDeaths
Where Location like '%state%'
order by 1,2


-- Looking at Countries with Highest Infection Rate compared to Population

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectionRate
From [Portfolio Project]..CovidDeaths
Group by Location, population
order by InfectionRate desc

-- Showing Countries with Highest Death Count per Population

Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where continent is not null
Group by Location
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT


-- Showing continents with the highest death count

Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/Sum(New_Cases)*100 as MortalityRate
From [Portfolio Project]..CovidDeaths
Where continent is not null
Group by date
order by 1,2


--Looking at Total Population vs. Vaccinations

Select *
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date


--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
	dea.Date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac




