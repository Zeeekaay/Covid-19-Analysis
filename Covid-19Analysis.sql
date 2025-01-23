SELECT *
FROM `PortfolioProject-Covid19`.`coviddeaths`
order by 3,4;

SELECT continent, location
FROM `PortfolioProject-Covid19`.`coviddeaths`;

/*SELECT *
FROM `PortfolioProject-Covid19`.`covidvaccinations`
order by 3,4;*/

-- Select the data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From `PortfolioProject-Covid19`.`coviddeaths`;

-- Analyzing total cases vs total deaths

select Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
from `PortfolioProject-Covid19`.`coviddeaths`
-- where Location like '%states%'
order by Location,STR_TO_DATE(date, '%m/%d/%Y');

-- Analyzing total cases vs population: Shows what percentage of the population got covid

select  Location, date, total_cases, population, (total_cases/population) * 100 as PercentofInfectedPopulation
from `PortfolioProject-Covid19`.`coviddeaths`
where location like '%states%'
order by Location,STR_TO_DATE(date, '%m/%d/%Y');

-- Looking at countries with highest infection rate compared to population

select  Location, population, max(total_cases) as HighestInfected, (max(total_cases)/population) * 100 as PercentofInfectedPopulation
from `PortfolioProject-Covid19`.`coviddeaths`
group by Location,population
order by PercentofInfectedPopulation desc;




-- Showing countries with highest death count per population

select  Location, MAX(cast(total_deaths as unsigned )) as HighestDeaths
from `PortfolioProject-Covid19`.`coviddeaths`
where continent != ''
group by Location
order by HighestDeaths desc;




-- Analyzing per continent
-- Continents with the highest death count per population

select  continent, MAX(cast(total_deaths as unsigned )) as HighestDeaths
from `PortfolioProject-Covid19`.`coviddeaths`
where continent != ''
group by continent
order by HighestDeaths desc;



-- GLOBAL ANALYSIS

select date, SUM(new_cases) as total_new_cases, SUM(cast(new_deaths as unsigned)) as total_new_deaths, (sum(cast(new_deaths as unsigned))/sum(new_cases)) * 100 as DeathPercentage
from `PortfolioProject-Covid19`.`coviddeaths`
where continent != ''
group by date
order by total_new_cases,STR_TO_DATE(date, '%m/%d/%Y');


/*select SUM(new_cases) as total_new_cases, SUM(cast(new_deaths as unsigned)) as total_new_deaths, (sum(cast(new_deaths as unsigned))/sum(new_cases)) * 100 as DeathPercentage
from `PortfolioProject-Covid19`.`coviddeaths`
where continent != ''
order by total_new_cases;*/


-- Analyzing number of vaccinated poeple among the population

WITH vacamongpop (continent, location, date, population, new_vaccinations,Rolling_people_vaccinated)
as(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as unsigned)) OVER (Partition by dea.location order by dea.location, STR_TO_DATE(dea.date, '%m/%d/%Y')) as Rolling_people_vaccinated
from `PortfolioProject-Covid19`.`coviddeaths` dea
Join `PortfolioProject-Covid19`.`covidvaccinations` vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent != ''
order by  2,STR_TO_DATE(dea.date, '%m/%d/%Y'))

Select *, (rolling_people_vaccinated/Population) *100 as percentvaccinated from vacamongpop;


-- CREATING A VIEW 

create view bycontinent as
select  continent, MAX(cast(total_deaths as unsigned )) as HighestDeaths
from `PortfolioProject-Covid19`.`coviddeaths`
where continent != ''
group by continent;



