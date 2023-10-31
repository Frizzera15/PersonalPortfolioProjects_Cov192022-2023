

Select  * from CovidDeath 
where continent = 'Africa' and CovidDeath.[location] = 'Madagascar' 

/* Select top 20 * from CovidVacc
where continent = 'Africa' and CovidVacc.[location] = 'Madagascar' 
 */

/* Select CovidDeath.[location], CovidDeath.[date], 
SUM(CovidDeath.total_cases) OVER (PARTITION BY CovidDeath.[location]) as TotalCasePerLocation
from CovidDeath */

Select continent, CovidDeath.[location], 
SUM(Cast(CovidDeath.total_cases as bigint)) as TotalCase
from CovidDeath
Where continent is not NULL
Group by continent, [location]
Order by continent, [location]

Select continent, CovidDeath.[location], [date], total_cases, total_deaths
from CovidDeath
Where continent is not NULL and [location] = 'Afghanistan'
Order by continent, [location], [date]

Select top 10 * from CovidDeath

Select top 10 * from CovidVacc

Select top 5 * from CovidDeath as CD 
Join CovidVacc as CV 
On CD.location = CV.location and CD.date = CV.date;

Select CD.location, CD.date, CD.new_cases, CD.total_cases, CD.total_deaths,
        CV.total_tests, CV.total_vaccinations, CV.positive_rate
from CovidDeath as CD
Join CovidVacc as CV 
on CD.[location] = CV.[location] and CD.[date] = CV.[date]
where CV.total_tests is not NULL and CD.location like '%states%'

Select Distinct CD.[location], CD.iso_code, CD.continent from CovidDeath as CD
where CD.continent is not NULL
order by CD.[location]

-- Looking at the likelihood of mortality rate of the Covid 19's cases based on the total cases registered in daily basis
-- Rough estimate on how deadly the Covid's case in different countries
Select CD.location, CD.date, CD.total_cases, CD.total_deaths, (Cast(CD.total_deaths as FLOAT)/CD.total_cases)*100 as DeathPercentage
from CovidDeath as CD
Where location like '%Indonesia%'
order by 1,2

-- Looking at the severity of the Covid 19's mortality rate towards total population in a country
Select CD.location, CD.date, CD.total_cases, CD.total_deaths, (Cast(CD.total_deaths as FLOAT)/CD.population)*100 as MortalityRateByCov19
from CovidDeath as CD
Where location like '%Indonesia%'
order by 1,2

-- Countries infection ranking compared to total population
Select CD.location, CD.population, MAX(CD.total_cases) as HighestInfectionRecord, MAX((Cast(CD.total_cases as FLOAT)/CD.population)*100) as HighestInfectionRate
from CovidDeath as CD
where CD.continent IS NOT NULL
Group BY CD.[location], CD.population
order by HighestInfectionRate DESC;

-- Show Countries with Highest Death Count per Population
Select CD.location, MAX(CD.total_deaths) as HighestDeathCount2022
from CovidDeath as CD
where CD.continent is NOT NULL
Group BY CD.[location]
order by HighestDeathCount2022 DESC;

-- LET's BREAK THINGS DOWN BY CONTINENT
Select CD.[location], MAX(CD.total_deaths) as HighestDeathCount2022
from CovidDeath as CD
where CD.continent is NULL
Group BY CD.[location]
order by HighestDeathCount2022 DESC;

-- Showing the continent with hi8ghest death count
Select CD.continent, MAX(CD.total_deaths) as HighestDeathCount2022
from CovidDeath as CD
where CD.continent is NOT NULL
Group BY CD.continent
order by HighestDeathCount2022 DESC;

-- Global Numbers
Select SUM(CD.new_cases) as TotaDailyNewCase, SUM(CD.new_deaths) as TotalVictim, SUM(Cast(CD.new_deaths as FLOAT))/SUM(CD.new_cases)*100 as TotalMortalityRateByCov19
from CovidDeath as CD
where CD.continent is not NULL
/* Group BY CD.[date] */
order by 1,2

-- Look At Total Population and Total Vaccinations
With PopsVac (continent, location, date, population, new_vaccinations, RollingTotalVaccDone)
AS
(
Select CV.continent, CV.[location], CV.[date], CD.population, CV.new_vaccinations, 
SUM(CV.new_vaccinations) 
OVER (
        Partition BY CV.[location]
        Order BY CV.[location], CV.[date]
        ) as RollingTotalVaccDone
from CovidVacc as CV
join CovidDeath as CD
on CV.[date] = CD.[date] and CD.[location] = CV.[location]
where CV.continent is NOT NULL and CV.new_vaccinations is not NULL 
/* Order by 2,3 */
)
Select *, ((CAST(RollingTotalVaccDone as FLOAT))/population)*100 as VaccinationRatePerCountries
from PopsVac
-- CTE Example ABOVE

-- Temp Table

Drop table if EXISTS #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date DATETIME,
Population numeric,
New_vaccinations numeric,
RollingTotalVaccDone numeric
)

Insert INTO #PercentPopulationVaccinated 
Select CV.continent, CV.[location], CV.[date], CD.population, CV.new_vaccinations, 
SUM(CV.new_vaccinations) 
OVER (
        Partition BY CV.[location]
        Order BY CV.[location], CV.[date]
        ) as RollingTotalVaccDone
from CovidVacc as CV
join CovidDeath as CD
on CV.[date] = CD.[date] and CD.[location] = CV.[location]

-- Creating View to stopre data for later visualization stage

Create view PercentagePopulationVaccinated AS
Select CD.continent, CD.[location], CD.[date], CD.population, CV.new_vaccinations, 
SUM(CV.new_vaccinations) 
OVER (
        Partition BY CV.[location]
        Order BY CV.[location], CV.[date]
        ) as RollingTotalVaccDone
from CovidDeath as CD
join CovidVacc as CV
on CV.[date] = CD.[date] and CD.[location] = CV.[location]
where CD.continent is NOT NULL
--order by 2,3

Select CD.continent, CD.[location], CD.[date], CD.population, CV.new_vaccinations, 
SUM(CV.new_vaccinations) 
OVER (
        Partition BY CV.[location]
        Order BY CV.[location], CV.[date]
        ) as RollingTotalVaccDone
from CovidDeath as CD
join CovidVacc as CV
on CV.[date] = CD.[date] and CD.[location] = CV.[location]
where CD.location = 'Afghanistan'











select [location], [date], new_vaccinations
from CovidVacc
where new_vaccinations is not null and continent is not null

SELECT CD.location, CD.[date], CD.total_cases, CD.total_deaths, CD.hosp_patients, CD.icu_patients, CV.new_tests, CV.total_tests
from CovidDeath as CD
join CovidVacc as CV
on CD.location = CV.location and CD.[date] = CV.[date]
where CD.[location] like '%Indonesia%'
order by 2,3

select * from CovidDeath
where location like '%Indonesia%'


Select distinct CD.location
from CovidDeath as CD

/* select CD.[location], CD.population, (Select AVG(CV.total_vaccinations) from CovidVacc as CV) as AverageVacc, AVG(CD.new_cases) as AVGDailyCase
from CovidDeath as CD
where CD.[location] IN ('Indonesia', 'Thailand', 'Malaysia')
 */
select CD.location, SUM(CD.total_cases) as TotalAnnualCase, SUM(CD.total_deaths) as TotalAnnualDeaths
from CovidDeath as CD
where CD.location IN ('Indonesia', 'Malaysia', 'Thailand')
Group by CD.location;

--