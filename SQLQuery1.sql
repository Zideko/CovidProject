select * from Coviddeaths1data$
order by 3,4;

--select * from Covidvaccinations1data$
--order by 3,4;

select location, date, total_cases, new_cases, total_deaths, population  from Coviddeaths1data$
order by 1,2;

--looking at total cases versus total deaths
--Shows the likelihood of dying after contracting covid

select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as Percentage_deaths  from Coviddeaths1data$
order by 1,2;

--Looking at total cases vs population
--Shows the infection rate

select location, date, total_cases, population, (total_cases/population)*100 as infection_rate  from Coviddeaths1data$
order by 1,2;

--Looking at highest infection rates compared to population for all countries.

select location, max(total_cases)as Max_cases, population, max((total_cases/population))*100 as highest_infection_rate  from Coviddeaths1data$
group by location,population
order by highest_infection_rate desc;

--Showing the highest mortality rate per population in each country

select location, max(cast(total_deaths as int)) as total_death_count from Coviddeaths1data$
where continent is not null
group by  location
order by total_death_count desc

--Showing continents with highest death count per population

select continent, max(cast(total_deaths as bigint)) as total_death_count from Coviddeaths1data$
where continent is not null
group by continent
order by total_death_count desc

--Global numbers
--sum of new cases

select date, sum(new_cases) as total_new_Cases from Coviddeaths1data$
where continent is not null
group by date
order by 1, 2

--sum of new cases and new deaths

select date, sum(new_cases),sum(cast(new_deaths as int)) from Coviddeaths1data$
where continent is not null
group by date
order by 1, 2

--Global death percentage

select date, sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as global_percentage from Coviddeaths1data$
where continent is not null
group by date
order by 1, 2

--Total population vs vaccination

select Coviddeaths1data$.continent, Coviddeaths1data$.location, Coviddeaths1data$.date,
Coviddeaths1data$.population, Covidvaccinations1data$.new_vaccinations,
SUM(Cast(Covidvaccinations1data$.new_vaccinations as bigint)) OVER (Partition by Coviddeaths1data$.location order by 
Coviddeaths1data$.location, Coviddeaths1data$.date) as RollingPeople_Vaccinated
from Coviddeaths1data$
join Covidvaccinations1data$
on Coviddeaths1data$.location=  Covidvaccinations1data$.location
and Coviddeaths1data$.date = Covidvaccinations1data$.date
where Coviddeaths1data$.continent is not null
order by 2,3
