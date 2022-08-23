/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

select *
from protfolioproject.coviddeath;

select *
from protfolioproject.covidvaccination;

select Location, date, total_cases, new_cases, total_deaths, population
from protfolioproject.coviddeath
order by 1, 2;


select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from protfolioproject.coviddeath
where location = 'India'
and continent <> ''
order by 1, 2;


select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
from protfolioproject.coviddeath
where location = 'India'
and continent <> ''
order by total_cases asc;



select Location, max(total_cases) as HighestInfectionCount, population, max((total_cases/population))*100 as PercentPopulationInfected
from protfolioproject.coviddeath
-- where location = 'India'
Where continent <> ''
group by Location, population
order by PercentPopulationInfected desc;



select Location, max(cast(total_deaths as UNSIGNED)) as TotalDeathCount
from protfolioproject.coviddeath
-- where location = 'India'
Where continent <> ''
group by Location
order by TotalDeathCount desc;

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population


select continent, max(cast(total_deaths as UNSIGNED)) as TotalDeathCount
from protfolioproject.coviddeath
-- where location = 'India'
Where continent <> ''
group by continent
order by TotalDeathCount desc;


-- GLOBAL NUMBERS


select sum(new_cases) as total_cases, sum(cast(new_deaths as unsigned)) as total_deaths,
(sum(cast(new_deaths as unsigned))/sum(new_cases))*100 as DeathPercentage
from protfolioproject.coviddeath
-- where location = 'India'
where continent <> ''
-- group by date
order by 1,2;

-- Total Population Vs Vaccination

select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(cast(v.new_vaccinations as unsigned)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from protfolioproject.coviddeath as d
join protfolioproject.covidvaccination as v
 on d.location = v.location
 and d.date = v.date
where d.continent <> ''
order by 2,3;


-- Using CTC

with PopvsVac (continent, location, date, population, new_vaccination, RollingPeopleVaccinated)
as
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(cast(v.new_vaccinations as unsigned)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from protfolioproject.coviddeath as d
join protfolioproject.covidvaccination as v
 on d.location = v.location
 and d.date = v.date
where d.continent <> ''
)
select *, (RollingPeopleVaccinated/population)*100
From PopvsVac;


-- Using Temp Table

DROP  Temporary Table if exists PercentPopulationVaccinated;
Create Temporary Table PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);

Insert into PercentPopulationVaccinated
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(cast(v.new_vaccinations as unsigned)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
From protfolioproject.CovidDeath d
Join protfolioproject.CovidVaccination v
	On d.location = v.location
	and d.date = v.date;
-- where d.continent <> '' 
-- order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From PercentPopulationVaccinated;


-- Creating View

Create View PercentPopulationVaccinated as
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(cast(v.new_vaccinations as unsigned)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from protfolioproject.coviddeath as d
join protfolioproject.covidvaccination as v
 on d.location = v.location
 and d.date = v.date
where d.continent <> '';


