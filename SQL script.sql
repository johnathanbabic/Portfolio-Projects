-- From Jan 28, 2020 to Sep 13, 2021

select *
from PortfolioProject.dbo.CovidDeaths$
where continent is not null -- and location like '%canada%'
order by location,date DESC;

--select *
--from PortfolioProject.dbo.CovidVaccinations$
-- where continent is not null -- and location like '%canada%'
--order by location,date DESC;

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject.dbo.CovidDeaths$
where continent is not null -- and location like '%canada%'
order by location, date DESC;



-- Getting the death rates of countries since Jan 2020

select location, date, total_cases, total_deaths, (total_deaths/population)*100 as death_percentage
from PortfolioProject.dbo.CovidDeaths$
where continent is not null -- and location like '%canada%'
order by location, date DESC;



-- looking at what percentage of population got covid

select location, population, date, total_cases, (total_cases/population)*100 as Infection_Rate
from PortfolioProject.dbo.CovidDeaths$
where continent is not null -- and location like '%canada%'
order by location, date ASC;



-- looking at countries highest infection rate compared to population

select location,population ,max(total_cases) as Highest_Infection_Count, max(total_cases/population)*100 as Highest_Infection_Rate
from PortfolioProject.dbo.CovidDeaths$
where continent is not null -- and location like '%canada%'
group by location, population
order by Highest_Infection_Rate DESC;



-- looking highest death count by country

select location,max(cast(total_deaths as int)) as Total_Death_Count
from PortfolioProject.dbo.CovidDeaths$
where continent is not null
group by location
order by Total_Death_Count DESC;



-- looking at highest death count by continent

select continent, sum(cast(new_deaths as int)) as Total_Death_Count
from PortfolioProject.dbo.CovidDeaths$
where continent is not null
group by continent 
order by Total_Death_Count desc;



-- world numbers

select date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_percent
from PortfolioProject.dbo.CovidDeaths$
where continent is not null
group by date
order by date DESC;


-- join tables
-- looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over 
(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths$ dea
join PortfolioProject.dbo.CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by dea.location, dea.date DESC;



-- use CTE

with PopsVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over 
(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths$ dea
join PortfolioProject.dbo.CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select * ,(RollingPeopleVaccinated/Population)*100 as RollinVaccinated_percent
from PopsVsVac
order by location, date DESC;



-- using views

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over 
(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths$ dea
join PortfolioProject.dbo.CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

