select *
from coco..CovidDeaths
order by 3,4

--select *
--from coco..CovidVaccinations
--order by 3,4

--Select the data we are going to be using 

select location,date, total_cases, total_deaths,population
from coco..CovidDeaths
order by 1,2

--look at Total Cases vs Total Deathes
--shows Likelihood of dying if you contract covid in your country
select location,date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from coco..CovidDeaths
where location like '%states%'
order by 1,2

--Looking at Total Cases vs Population 
--show perscntage of population got Covid

select location,date, population, total_cases,(total_cases/population)*100 as PercentPopulationInfected
from coco..CovidDeaths
where location like '%states%'
order by 1,2

--Looking at Countries with Infection Rate compared to Population

select location,population, Max(total_cases)as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulatuionInfected
from coco..CovidDeaths
--where location like '%states%'
Group by location,population
order by PercentPopulatuionInfected desc



--showing countries with Death count per population 

select location,Max(cast(total_deaths as int)) as TotalDeathCount
from coco..CovidDeaths
--where location like '%states%'
Group by location,population
order by TotalDeathCount desc

select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
(new_deaths as int))/SUM(New_cases)*100 as DeathsPercentage
from coco..CovidDeaths
--where location like '%states%'
where continent is not null
order by 1,2


--Use CTE

with popvsvac (continent,Location,Date,Population,New_vaccinations,RollingPeopleVaccination)
as
(
--Looking at Total Population vs vaccinations
select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
,sum(CONVERT(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location,
dea.Date) as RollingPeopleVaccination
from coco..CovidDeaths dea		
join coco..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

)
select *,(RollingPeopleVaccination/Population)*100
from popvsvac


--Temp Table

Insert into 
select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
,sum(CONVERT(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location,
dea.Date) as RollingPeopleVaccination
from coco..CovidDeaths dea		
join coco..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


--Creating View

Create View PercentPopulationVaccionated as 
select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
,sum(CONVERT(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location,
dea.Date) as RollingPeopleVaccination
from coco..CovidDeaths dea		
join coco..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--  order by 2,3

select * 
from PercentPopulationVaccionated