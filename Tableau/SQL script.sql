
-- world average data
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths$
where continent is not null 
order by 1,2

-- show cases and deaths by continent
Select location, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeathCount,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths$
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc;

--show cases and deaths by country
Select location, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeathCount,
sum(new_cases)/max(population)*100 as PercentInfected
From PortfolioProject.dbo.CovidDeaths$
Where continent is not null 
Group by location
order by PercentInfected desc;


-- infection rates 
select location, max(population) as Population, max(total_cases) as TotalCases, max(total_cases)/max(population) * 100 as InfectionRate
from PortfolioProject.dbo.CovidDeaths$
where continent is not null --and location like '%canada%'
group by location
order by location,Population desc;

select location, max(population) as Population, max(total_cases) as TotalCases, max(total_cases)/max(population) * 100 as InfectionRate
from PortfolioProject.dbo.CovidDeaths$
Where continent is null 
and location not in ('World', 'European Union', 'International')
group by location
order by location,Population desc;


-- vacination rates

select location, max(cast(people_fully_vaccinated as int)) as FullyVaccinated, max(population) as Population, max(cast(people_fully_vaccinated as int))/max(population)*100 as VaccinationPercentage
from PortfolioProject.dbo.CovidVaccinations$
where continent is not null 
group by location
order by VaccinationPercentage desc;
