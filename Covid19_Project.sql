select *
from PortfolioProject..CovedDeath 
order by 3,4

select *
from PortfolioProject..CovedVaccinations
order by 3,4

SELECT location , date , total_cases , total_deaths , new_cases , population 
FROM PortfolioProject..CovedDeath
order by 1 , 2;


SELECT location , date , total_cases , total_deaths , total_deaths / NULLIF(total_cases, 0) * 100 AS Deathpercentage
FROM PortfolioProject..CovedDeath
where location  like 'eg%' 
order by 1 , 2;

-- Looking at Total Cases vs Population

SELECT location , date , population , total_cases  , total_cases / NULLIF(population, 0) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovedDeath
where location  like 'eg%' 
order by 1 , 2;



-- Looking at countries with highest infection rates Compared to Population

SELECT location , population , max(total_cases) as HighestInfectionCount  ,
max(total_cases / NULLIF(population, 0)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovedDeath
--where location  like 'eg%' 
Group by location , population
order by PercentPopulationInfected desc;



-- Showing Countries With Highest Death Count Per Population 

SELECT location  , max(total_deaths) as TotalDeathCount  
FROM PortfolioProject..CovedDeath 
--where location  like 'eg%' 
Group by location
order by TotalDeathCount desc;


-- Showing Continent  With Highest Death Count Per Population 

SELECT Continent  , max(total_deaths) as TotalDeathCount  
FROM PortfolioProject..CovedDeath 
--where location  like 'eg%'
where Continent != ' '
Group by Continent
order by TotalDeathCount desc;


-- GLOBAL NUMBERS

SELECT date , sum(total_cases) as Total_Cases ,sum(new_deaths) as Total_Deaths ,
(sum(new_deaths) / nullif(sum(new_cases) ,0)) *100 as Death_Percentage 
FROM PortfolioProject..CovedDeath
--where location  like 'eg%' 
where Continent IS NOT NULL
group by date
order by 1 , 2;

-- Total_Cases , Total_Deaths And The Death Percentage 

SELECT sum(total_cases) as Total_Cases ,sum(new_deaths) as Total_Deaths ,
(sum(new_deaths) / nullif(sum(new_cases) ,0)) *100 as Death_Percentage 
FROM PortfolioProject..CovedDeath
--where location  like 'eg%' 
where Continent != ' '
order by 1 , 2;

-- Calculation total population vs vaccinations

select 
	dea.continent , 
	dea.location , 
	dea.date , 
	dea.population ,
	vacc.new_vaccinations , 
		sum(vacc.new_vaccinations) over (partition by dea.location order by dea.location ,dea.date ) as RollingPeopleVaccinated 
from PortfolioProject..CovedDeath dea  
	join PortfolioProject..CovedVaccinations vacc 
		on dea.location = vacc.location 
		and dea.date = vacc.date 
where dea.continent != ' ' and vacc.new_vaccinations!= 0
order by 1 ,2

--Temp Table 
drop table if exists #percentPopulationVaccinated
create table #percentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime ,
Population numeric ,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric
)
insert into #percentPopulationVaccinated
select 
	dea.continent , 
	dea.location , 
	dea.date , 
	dea.population ,
	vacc.new_vaccinations , 
		sum(vacc.new_vaccinations) over (partition by dea.location order by dea.location ,dea.date ) as RollingPeopleVaccinated 
from PortfolioProject..CovedDeath dea  
	join PortfolioProject..CovedVaccinations vacc 
		on dea.location = vacc.location 
		and dea.date = vacc.date 
where dea.continent != ' ' and vacc.new_vaccinations!= 0
order by 1 ,2
select * from #percentPopulationVaccinated


-- Creating view to store date 

Create view percentPopulationVaccinated as 
select 
	dea.continent , 
	dea.location , 
	dea.date , 
	dea.population ,
	vacc.new_vaccinations , 
		sum(vacc.new_vaccinations) over (partition by dea.location order by dea.location ,dea.date ) as RollingPeopleVaccinated 
from PortfolioProject..CovedDeath dea  
	join PortfolioProject..CovedVaccinations vacc 
		on dea.location = vacc.location 
		and dea.date = vacc.date 
where dea.continent != ' ' and vacc.new_vaccinations!= 0
--order by 1 ,2
select  *
from
percentPopulationVaccinated