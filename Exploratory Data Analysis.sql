-- Exploratory Data Analysis

select *
from layoffs_staging2;

select max(total_laid_off),max(percentage_laid_off)
from layoffs_staging2;
-- here 1% indicate total 100% of company was laid off--

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

-- Company Wise --
select company,sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- Duration of dates --
select max(`date`),min(`date`)
from layoffs_staging2;

-- Industry Wise --
select industry,sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

-- Country Wise
select country,sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

-- Date wise --
select `date`,sum(total_laid_off)
from layoffs_staging2
group by `date`
order by 1 desc;

-- Year wise--
select year(`date`),sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

-- Stage Wise--
select stage,sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

-- ROLLING TOTAL LAYOFFS--
select substring(`date`,6,2) as `month`
from layoffs_staging2;

select substring(`date`,6,2) as `month`,sum(total_laid_off)
from layoffs_staging2
group by `month`;

# much better result then above one
select substring(`date`,1,7) as `month`,sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;

with rolling_table as
(
select substring(`date`,1,7) as `month`,sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`,total_off,sum(total_off) over(order by `month`) as rolling_total
from rolling_table;


select company, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
order by company asc;

select company, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
order by 3 desc;

-- Rank which yrs company laid off the most--
with company_year (company,years,total_laid_off) as
(
select company, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
)
select *
from company_year;

with company_year (company,years,total_laid_off) as
(
select company, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
)
select *,dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from company_year
where years is not null
order by Ranking asc;

--- Top 5 Company laid off
with company_year (company,years,total_laid_off) as
(
select company, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
),company_year_rank as
(select *,dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from company_year
where years is not null
)
select *
from company_year_rank
where Ranking <= 5;