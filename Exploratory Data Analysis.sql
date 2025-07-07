-- Exploratory Data Analysis
SELECT *
FROM layoffs_staging2;

-- Q. max laid offs, max percentage  of layoffs
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Q. list of companies that 100% laid_off its represented by 1 in the database 
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
ORDER BY total_laid_off DESC;

-- Q. 100% laidoffs and fund raised
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC;

-- Q. laidoffs by company 
SELECT company,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company ORDER BY SUM(total_laid_off) DESC;

-- Q. the period that the layoffs happened in
SELECT MIN(`date`), MAX(`date`) 
FROM layoffs_staging2;

-- Q. which industry has the max layoffs
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry ORDER BY SUM(total_laid_off) DESC;

-- Q. which country has the max layoffs
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country ORDER BY SUM(total_laid_off) DESC;

-- Q. total layoffs in a day
SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date` ORDER BY `date` DESC;

-- Q. total layoffs by a year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`) ORDER BY YEAR(`date`) DESC;


-- Q. total layoffs by a stage of the comapny 
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage ORDER BY 2 DESC;

-- Q. total layoffs by a month
SELECT SUBSTR(`date`,1,7) AS `MONTH`, SUM(total_laid_off)  AS total_off_each_month
FROM layoffs_staging2
WHERE SUBSTR(`date`,1,7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY `MONTH`;

-- Q. Rolling total of  layoffs ( adding the total of each month to the sumation 
WITH Rolling_Total AS
(
SELECT SUBSTR(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off_each_month
FROM layoffs_staging2
WHERE SUBSTR(`date`,1,7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY `MONTH`
)
SELECT `MONTH`, total_off_each_month, SUM(total_off_each_month) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- Q. laidoffs by company in a year 
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Q.Rank which company  laid off the most employees  in the year 
-- for example we want to rank the company which laid of the most number of employee in a year to be Rank 1 and so on 
-- we will have companies rank for each year starting with Rank = 1   means company rank =1 is the comapny which laid most number of employees in the year
WITH Company_Year (company, years, total_laid_off ) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking ;

-- Q. filter the most 5 companies that they laid off in each year 
-- create another CTE
-- and then we run the SELECT statement with less than <5 ranking 
WITH Company_Year (company, years, total_laid_off ) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;