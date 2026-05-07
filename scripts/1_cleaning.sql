
SELECT *
FROM laptop_staging
;

-- dedup
-- standardize
-- nulls blanks
-- remove col

-- DEDUPLUCATE
CREATE TABLE laptop_staging
LIKE laptop_price
;
INSERT laptop_staging
SELECT *
FROM laptop_price
;
SELECT *
FROM laptop_staging
;
SELECT *,
ROW_NUMBER() OVER(PARTITION BY `Company`, `Product`, `TypeName`, `Inches`, `ScreenResolution`, 
`Cpu`, `Ram`, `Memory`, `Gpu`, `OpSys`, `Weight`, `Price_euros`
)AS row_num
FROM laptop_staging
;
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY `Company`, `Product`, `TypeName`, `Inches`, `ScreenResolution`, 
`Cpu`, `Ram`, `Memory`, `Gpu`, `OpSys`, `Weight`, `Price_euros`
)AS row_num
FROM laptop_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1
;
CREATE TABLE `laptop_staging2` (
  `laptop_ID` int DEFAULT NULL,
  `Company` text,
  `Product` text,
  `TypeName` text,
  `Inches` double DEFAULT NULL,
  `ScreenResolution` text,
  `Cpu` text,
  `Ram` text,
  `Memory` text,
  `Gpu` text,
  `OpSys` text,
  `Weight` text,
  `Price_euros` double DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM laptop_staging2
;
INSERT laptop_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Company`, `Product`, `TypeName`, `Inches`, `ScreenResolution`, 
`Cpu`, `Ram`, `Memory`, `Gpu`, `OpSys`, `Weight`, `Price_euros`
)AS row_num
FROM laptop_staging
;
DELETE
FROM laptop_staging2
WHERE row_num > 1
;

-- STANDARDIZE
SELECT *
FROM laptop_staging2
;

SELECT DISTINCT opsys
FROM laptop_staging2
;
UPDATE laptop_staging2
SET company = trim(company)
;
UPDATE laptop_staging2
SET product = trim(product)
;
SELECT ram, trim(replace(`ram`, 'GB', ''))
FROM laptop_staging2
;
SELECT `weight`, trim(replace(`weight`, 'kg', ''))
FROM laptop_staging2
;
UPDATE laptop_staging2
SET ram = trim(replace(`ram`, 'GB', '')),
weight = trim(replace(`weight`, 'kg', ''))
;
SELECT *
FROM laptop_staging2
;
ALTER TABLE laptop_staging2
MODIFY COLUMN `ram` INT,
MODIFY COLUMN `weight` DECIMAL (10,1),
MODIFY COLUMN `inches` DECIMAL (10,1)
;

-- NULLS AND BLANKS
SELECT * 
FROM laptop_staging2
;
SELECT *
FROM laptop_staging2 
WHERE Company IS NULL
	OR product IS NULL
	OR ram IS NULL
	OR weight IS NULL
	OR Inches IS NULL
    OR Price_euros IS NULL
    ;
SELECT *
FROM laptop_staging2 
WHERE Company = ''
	OR product = ''
	OR ram = ''
	OR weight = ''
	OR Inches = ''
    OR Price_euros = ''
    ;

-- REMOVE COLUMN
SELECT *
FROM laptop_staging2
;
ALTER TABLE laptop_staging2
DROP COLUMN row_num
;





