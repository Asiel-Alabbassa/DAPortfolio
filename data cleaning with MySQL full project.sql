-- DATA CLEANING
SELECT * 
FROM layoffs;

-- STEPS
-- 1. REMOVE DUPLICATES IF THERE IS ANY
-- 2. STANDARIZED THE DATA (if there issues with spelling etc.)
-- 3. Null Values or blank values 
-- 4. Remove any columns that not related to our goal

CREATE TABLE layoffs_staging 
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;
--
SELECT * FROM layoffs_staging;
-- ----------------
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging ;
-- ======================================= put in a CTE
WITH duplicate_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging 
)
SELECT *
FROM duplicate_cte
WHERE row_num >1 ;

-- its so nice if we can delete from CTE  
-- DELETE FROM duplicate_cte WHERE row_num >1 ;
-- but we can not delete from CTE 
-- ====  to check the dublicates from the list we got in the CTE

SELECT *
FROM layoffs_staging 
WHERE company ='Casper';

-- we want to delete one row of the duplicate rows we need to create another table that has a row_num feild so we can delete the records
-- right click on the table and select copy to clipboard and select create table add a new field called row_num
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 -- 
SELECT *
FROM layoffs_staging2;

-- INSERT the values from the select statment that we create for the CTE in the new table layoffs_staging2 because we can have the value or the row_number too in the
-- new field that we added when we copy the table structure 
INSERT INTO layoffs_staging2 
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging ;

-- check the new table contents and if the row_num fireld is there
SELECT *
FROM layoffs_staging2
WHERE row_num >1 ;


DELETE
FROM layoffs_staging2
WHERE row_num >1 ;
