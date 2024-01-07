Select *
From PortfolioProject..ClimateVirusDeaths 
order by 3,4

--Select *
--From PortfolioProject..ClimateVirusVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..ClimateVirusDeaths
order by 1,2


Select Location, date, total_cases, total_deaths, (total_deaths/population)*100 as DeathPercentage
From PortfolioProject..ClimateVirusDeaths
Where location like '%Germany%'
order by 1,2

Select Location, date, total_cases, Population, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..ClimateVirusDeaths
--Where location like '%Germany%'
order by 1,2

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..ClimateVirusDeaths
--Where location like '%Germany%'
Group by location, Population
order by PercentPopulationInfected desc

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..ClimateVirusDeaths
--Where location like '%Germany%'
Group by Location
order by TotalDeathCount desc

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Portfolioproject..ClimateVirusDeaths
--Where location like '%Germany%'
Where continent is null
Group by location
order by TotalDeathCount desc

Select date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..ClimateVirusDeaths
--Where location like '%Germany%'
Where continent is not null
Group By date
order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..ClimateVirusDeaths
--Where location like '%Germany'
Where continent is not null
--Group by date
order by 1,2


--Looking at Total Population vs Vaccinations

Select dea.continent, dea.Location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated 
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..ClimateVirusDeaths dea
Join PortfolioProject..ClimateVirusVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVacinnated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated 
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..ClimateVirusDeaths dea
Join PortfolioProject..ClimateVirusVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVacinnated/Population)*100
From PopvsVac 


Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated 
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..ClimateVirusDeaths dea
Join PortfolioProject..ClimateVirusVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVacinnated/Population)*100
From #PercentPopulationVaccinated


Create View #PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated 
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..ClimateVirusDeaths dea
Join PortfolioProject..ClimateVirusVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated