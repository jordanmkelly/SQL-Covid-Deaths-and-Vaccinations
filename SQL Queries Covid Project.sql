/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Converting Data Types

Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

-- Looking at Total Cases vs Total Deaths in U.S.
-- Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2

--Looking at Total Cases vs Population in U.S.
-- Shows what percentage of population got Covid
Select Location, date, total_cases, population, (total_cases/population)*100 as InfectionRate
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2

 --Looking at Countries with Highest Infection Rate compared to Population

 Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectionRate  
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location, Population
order by InfectionRate desc

-- Showing Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount  
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
order by TotalDeathCount desc

-- Let's break things down by continent...

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc

-- GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int))as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2

--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as rollingpeoplevaccinated
From PortfolioProject..CovidVaccinations vac
Join PortfolioProject..CovidDeaths dea
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as rollingpeoplevaccinated
From PortfolioProject..CovidVaccinations vac
Join PortfolioProject..CovidDeaths dea
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
 
