-- EXPLORATORY DATA ANALYSIS
SELECT *
FROM laptop_staging2
;

-- flagships above average price for each company
SELECT `Company`,
round(avg(`Price_euros`), 2) AS avg_price
FROM laptop_staging2
GROUP BY `Company`
ORDER BY avg_price DESC
;
WITH avg_price_cte AS
(
SELECT `Company`,
round(avg(`Price_euros`), 2) AS avg_price
FROM laptop_staging2
GROUP BY `Company`
)
SELECT t1.Company, t1.Product, t1.Price_euros,
t2.avg_price
FROM laptop_staging2 AS t1
JOIN avg_price_cte AS t2
	ON t1.Company = t2.Company
WHERE t1.price_euros > t2.avg_price
ORDER BY t1.Company, t1.Price_euros DESC
;

-- portability by category
SELECT TypeName,
round(avg(`weight`), 3) AS avg_weight
FROM laptop_staging2
GROUP BY TypeName
;
WITH avg_weight_cte AS
(
SELECT TypeName,
round(avg(`weight`), 3) AS avg_weight
FROM laptop_staging2
GROUP BY TypeName
)
SELECT t1.Company, t1.Product, t1.TypeName, t1.weight, t2.avg_weight
FROM laptop_staging2 AS t1
JOIN avg_weight_cte AS t2
 ON t1.TypeName = t2.Typename
WHERE t1.weight < t2.avg_weight AND t1.TypeName = 'gaming'
ORDER BY t1.TypeName, t1.weight
;

-- categorize laptop market segments
SELECT Company, Product, TypeName, ram, Price_euros,
    CASE 
        WHEN ram >= 32 OR Price_euros > 2500 THEN 'Ultra High-End'
        WHEN ram >= 16 AND Price_euros BETWEEN 1200 AND 2500 THEN 'Premium Workstation'
        WHEN ram >= 8 AND Price_euros BETWEEN 500 AND 1199 THEN 'Standard Consumer'
        ELSE 'Budget / Entry'
    END AS Market_Segment
FROM laptop_staging2
ORDER BY Price_euros DESC
;











