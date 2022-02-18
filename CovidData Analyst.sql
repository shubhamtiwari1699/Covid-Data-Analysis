select * 
from [Data Analyst Project 1]..['CovidDeaths$']
where continent is not null
order by 3,4

----------------------------------------------------------------------------------------------------------------------------------------------------

-- (1) Selecting the data what we are going to use in this project (1)
select location,date,total_cases,new_cases,total_deaths,population
from [Data Analyst Project 1]..['CovidDeaths$']
order by 1,2

----------------------------------------------------------------------------------------------------------------------------------------------------

-- Looking at total cases vs total death
--(2) Here we find the death percentage(%) 
select location,date,total_cases,new_cases,total_deaths, (total_deaths/total_cases)*100 as '% of deaths'
from [Data Analyst Project 1]..['CovidDeaths$']
where location like '%india%' 
order by 1,2

----------------------------------------------------------------------------------------------------------------------------------------------------

--(3) Total cases vs population
-- Shows what percentage of population got covid

select location,date,total_cases,population,(total_cases/population)*100   as 'Total cases percentage'
from [Data Analyst Project 1]..['CovidDeaths$']
where location like '%india%'
order by 1,2

----------------------------------------------------------------------------------------------------------------------------------------------------

--(4) TOTAL CASES in every continent
SELECT continent, sum(total_cases) AS 'Total Cases'
FROM [Data Analyst Project 1]..['CovidDeaths$']
group by continent


----------------------------------------------------------------------------------------------------------------------------------------------------
-- (5) Country with highest infection rate compared to population

select location,max(total_Cases) as 'Highest Infection Count', max((total_cases/population))*100 as 'Total Cases'
from [Data Analyst Project 1]..['CovidDeaths$']
group by population,location
order by [Total Cases] desc

----------------------------------------------------------------------------------------------------------------------------------------------------

--(6) Showing countries with Highest death count per population
-- In this query we use 'CAST' method to change the data type

select location, max(cast(total_deaths as int)) as'Total Death Count'
from [Data Analyst Project 1]..['CovidDeaths$']
--where location like '%india'
where continent is not null
group by population,location
order by [Total Death Count] desc

----------------------------------------------------------------------------------------------------------------------------------------------------

--(7) Breaking down into continents
--Showing contients with Highest death count per population

select location as 'Continent', max(cast(total_deaths as int)) as'Total Death Count'
from [Data Analyst Project 1]..['CovidDeaths$']
where continent is  null
group by location
order by [Total Death Count] desc


----------------------------------------------------------------------------------------------------------------------------------------------------

--(8) Global Numbers

select date,sum(new_cases) as 'Total Cases', sum(cast(new_deaths as int)) as 'Total Deaths',
sum(cast(new_deaths as int))/sum(new_cases)*100 as '% of deaths'
from [Data Analyst Project 1]..['CovidDeaths$']
--where location like '%india%' 
where continent is not null
group by date
order by 1,2
---------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- NOW WE ARE GOING TO USE THE COVID VACCONATION TABLE
-- WILL JOIN WITH THE COVID DEATH TABLE
---------------------------------------------------------------------------------------------------------------------------------------------------

-- USE CTE

-- (9) lOOKING AT TOTAL POPULATION VS VACCINATIONS

with  popVsVacc (continent, location,date, new_vaccinations,population,RollingPeopleVaccinated)
as(
select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
sum(convert(int,vacc.new_vaccinations )) over(partition by dea.location order by dea.location, dea.date)
as 'rollingPeopleVaccinated'
from [Data Analyst Project 1]..['CovidVaccinations$'] vacc
join [Data Analyst Project 1]..['CovidDeaths$'] dea
on  dea.location=vacc.location
and dea.date=vacc.date
where dea.continent is not null
--order by  2,3
)
select *,(RollingPeopleVaccinated/population) as 'Percentage of RollingPeopleVaccinated' 
from popVsVacc



--------------------------------------------------------------------------------------------------------------------------------------------------


-- (10) TEMP TABLE
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric 
)

insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
sum(convert(int,vacc.new_vaccinations )) over(partition by dea.location order by dea.location, dea.date)
as 'rollingPeopleVaccinated'
from [Data Analyst Project 1]..['CovidVaccinations$'] vacc
join [Data Analyst Project 1]..['CovidDeaths$'] dea
on  dea.location=vacc.location
and dea.date=vacc.date
where dea.continent is not null
order by  2,3

select *,(RollingPeopleVaccinated/population) as 'Percentage of RollingPeopleVaccinated' 
from #PercentPopulationVaccinated

--------------------------------------------------------------------------------------------------------------------------------------

-- Creating view for later visualization

create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
sum(convert(int,vacc.new_vaccinations )) over(partition by dea.location order by dea.location, dea.date)
as 'rollingPeopleVaccinated'
from [Data Analyst Project 1]..['CovidVaccinations$'] vacc
join [Data Analyst Project 1]..['CovidDeaths$'] dea
on  dea.location=vacc.location
and dea.date=vacc.date
where dea.continent is not null
--order by  2,3










































































