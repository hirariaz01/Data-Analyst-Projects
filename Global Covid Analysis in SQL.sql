/* 
     Globally Covid Data Analysis in SQL
*/


-- Total covid cases in  each continent

select continent,sum(total_cases) as Total_Cases
from covid.vaccination
group by continent;


-- Percentage of population infected with Covid (total cases VS population)--

select location, date, Population, total_cases,(total_cases/population)*100 as PercentPopulationInfected
from covid.details
group by location;

-- Showing contintents with the highest death count per population

Select continent, MAX(Total_deaths) as TotalDeathCount
From covid.vaccination 
Group by continent
order by TotalDeathCount desc;

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covid.details
Group by Location, Population
order by PercentPopulationInfected desc;

-- Month wise new cases VS deaths in United States

select sum(new_cases),sum(new_deaths),(date) as Month 
from covid.vaccinat
where location = 'United States'
group by monthname(date);


 -- To Calculate total positive cases of each country

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covid.details
Group by Location, Population
order by PercentPopulationInfected desc;

-- list 5 countries of least covid cases  

Select location, sum(new_cases) as Totalcases
From covid.vaccination 
Group by location
order by Totalcases asc
limit 5;

-- People Vaccinated in each country

select country,total_cases,sum(new_vaccination) as peolple_vaccinated
from covid.details
group by country

-- Creating View to update covid table

CREATE PROCEDURE UPDATE_COVID_DATA(IN in_location varchar(40),IN in_date date,IN in_new_case int,IN in_new_death int,IN in_new_vaccinated int)
BEGIN
   UPDATE covid.details 
       SET 'location' = in_location
       SET 'date'= in_date
	   SET 'new_cases' = in_new_cases
       SET 'new_deaths' = in_new_deaths
       SET "new_vaccination" = in_new_vaccinated
END


