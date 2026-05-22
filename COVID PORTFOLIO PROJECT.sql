select *
from CovidDeaths
where continent is not null
order by 3,4


--total_cases Vs total_deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as totalpercent
from CovidDeaths
where location = 'Nigeria'
order by 1,2


--total_cases Vs Population

select location, date, total_cases, population, (total_deaths/population)*100 as totalpercent
from CovidDeaths
where location = 'Nigeria'
order by 1,2


--countries with the highest infection

select location, population, max(total_cases) as mostinfected, max(total_cases/population)*100 as totalpercent
from CovidDeaths
--where location = 'Nigeria'
group by location, population
order by totalpercent desc


--countries with highest death

select location, max(cast(total_deaths as int)) as highestdeath
from CovidDeaths
where continent is not null
group by location
order by highestdeath desc


--global numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


--total population and vaccinations

select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population,CovidVaccinations.new_vaccinations
,sum(cast(CovidVaccinations.new_vaccinations as bigint)) over(partition by CovidDeaths.location) as peoplevaccinated
from CovidDeaths
join CovidVaccinations
on CovidVaccinations.location = CovidDeaths.location 
and CovidVaccinations.date = CovidDeaths.date
where CovidDeaths.location is not null
order by 2,3


--use CTE

with PopulationVsVaccination (continent, location, date, population, new_vaccination, peoplevaccinated) 
as (
select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population,CovidVaccinations.new_vaccinations
,sum(cast(CovidVaccinations.new_vaccinations as bigint)) over(partition by CovidDeaths.location) as peoplevaccinated
from CovidDeaths
join CovidVaccinations
on CovidVaccinations.location = CovidDeaths.location 
and CovidVaccinations.date = CovidDeaths.date
where CovidDeaths.location is not null
--order by 2,3

select *, (peoplevaccinated/population)*100 
from PopulationVsVaccination


--temp table

create table #peoplevaccinatepercentage (
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
New_Vaccinations numeric, 
PeopleVaccinated numeric,
)
insert into #peoplevaccinatepercentage
select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population,CovidVaccinations.new_vaccinations
,sum(cast(CovidVaccinations.new_vaccinations as bigint)) over(partition by CovidDeaths.location) as peoplevaccinated
from CovidDeaths
join CovidVaccinations
on CovidVaccinations.location = CovidDeaths.location 
and CovidVaccinations.date = CovidDeaths.date
where CovidDeaths.location is not null
--order by 2,3

select *, (peoplevaccinated/population)*100 
from #peoplevaccinatepercentage