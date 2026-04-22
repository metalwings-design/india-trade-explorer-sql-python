---------------------------------------------------------------------
--       1    basic
------------------------------------------------------------------------------

-- 1. What years are covered in your data?
SELECT DISTINCT year FROM tariff_rates ORDER BY year;
SELECT DISTINCT year FROM port_traffic ORDER BY year;
SELECT DISTINCT year FROM exports_india ORDER BY year;

-- 2. What countries/ economies are in your data?
SELECT DISTINCT Economy_Label FROM port_traffic LIMIT 20;
SELECT DISTINCT Market_Label FROM tariff_rates LIMIT 20;

-- 3. What HS code sections exist?
SELECT DISTINCT HSCode FROM hs_products WHERE HSCode IS NOT NULL LIMIT 20;

-- 4. Check data ranges for trade values
SELECT 
    MIN(amt) as min_value,
    MAX(amt) as max_value,
    AVG(amt) as avg_value
FROM exports_india;


---------------------------------------------
--             2 business question
------------------------------------------------

-- 5. Top 10 Export Commodities from India (by value)
SELECT 
    e.HSCode,
    h.ProductDescription,
    SUM(e.amt) as total_export_value
FROM exports_india e
LEFT JOIN hs_products h ON e.HSCode = h.HSCode
GROUP BY e.HSCode, h.ProductDescription
ORDER BY total_export_value DESC
LIMIT 10;

-- 6. Top 10 Import Commodities to India (by value)
SELECT 
    i.HSCode,
    h.ProductDescription,
    SUM(i.amt) as total_import_value
FROM imports_india i
LEFT JOIN hs_products h ON i.HSCode = h.HSCode
GROUP BY i.HSCode, h.ProductDescription
ORDER BY total_import_value DESC
LIMIT 10;

-- 7. India's Trade Balance by Year (Exports - Imports)
SELECT 
    COALESCE(e.year, i.year) as year,
    COALESCE(SUM(e.amt), 0) as total_exports,
    COALESCE(SUM(i.amt), 0) as total_imports,
    COALESCE(SUM(e.amt), 0) - COALESCE(SUM(i.amt), 0) as trade_balance
FROM exports_india e
FULL OUTER JOIN imports_india i ON e.year = i.year
GROUP BY COALESCE(e.year, i.year)
ORDER BY year;


--------------------------------------------------------
-- 8. Which commodities have the highest import tariffs?

--------------------------------------------------
-------------------------------------------
--  Top 10 Highest Tariffs Overall (Simple)
-------------------------------------------
SELECT 
    Market_Label as country,
    HSCode,
    ProductCategory_Label as product_category,
    Simple_average_of_rates as tariff_rate_percent,
    year
FROM tariff_rates
WHERE Simple_average_of_rates IS NOT NULL
ORDER BY Simple_average_of_rates DESC
LIMIT 10;


-------------------------------------------
-- Top 10 Highest Tariffs for Year 2023 Only
----------------------------------------------
SELECT 
    Market_Label as country,
    HSCode,
    ProductCategory_Label as product_category,
    Simple_average_of_rates as tariff_rate_percent
FROM tariff_rates
WHERE year = 2023
    AND Simple_average_of_rates IS NOT NULL
ORDER BY Simple_average_of_rates DESC
LIMIT 10;


------------------------------------------------
-- Top 10 Highest Tariffs with Country and Origin (Most Detailed)
------------------------------------------------\
SELECT 
    Market_Label as importing_country,
    Origin_Label as origin_country,
    HSCode,
    ProductCategory_Label as product_category,
    Simple_average_of_rates as tariff_rate_percent,
    DutyType_Label as duty_type,
    year
FROM tariff_rates
WHERE Simple_average_of_rates IS NOT NULL
ORDER BY Simple_average_of_rates DESC
LIMIT 10;


---------------------------------------------------

--          3 advance aanalytics

---------------------------------------------------
-- 9. Top 10 Ports by Container Traffic
SELECT 
    MIN(twentyftEU) as min_containers,
    MAX(twentyftEU) as max_containers,
    AVG(twentyftEU) as avg_containers,
    SUM(twentyftEU) as total_containers,
    COUNT(*) as total_records
FROM port_traffic
WHERE twentyftEU IS NOT NULL;

--All Data for Indiacontainer volume
SELECT 
    year,
    Economy_Label as country,
    twentyftEU as container_volume
FROM port_traffic
WHERE Economy_Label = 'India'
ORDER BY year;

--top 5 container volume
SELECT 
    year,
    Economy_Label as country,
    twentyftEU as container_volume
FROM port_traffic
ORDER BY twentyftEU DESC
LIMIT 5;

--bottom 5 contaainer volume
SELECT 
    year,
    Economy_Label as country,
    twentyftEU as container_volume
FROM port_traffic
WHERE twentyftEU > 0 
    AND twentyftEU IS NOT NULL
ORDER BY twentyftEU ASC
LIMIT 5;


--india top 5 container volume
SELECT 
    year,
    Economy_Label as country,
    twentyftEU as container_volume
FROM port_traffic
WHERE Economy_Label = 'India'
ORDER BY twentyftEU DESC
LIMIT 5;

--india bottom 5 container volume
SELECT 
    year,
    Economy_Label as country,
    twentyftEU as container_volume
FROM port_traffic
WHERE Economy_Label = 'India'
    AND twentyftEU > 0
ORDER BY twentyftEU ASC
LIMIT 5;



-- analyse india and its trding ppartners export imoprts
-- Need to add country column to your exports/imports tables first
-- But if you don't have country, use port_traffic as proxy

SELECT 
    Economy_Label as trading_partner,
    SUM(twentyftEU) as total_container_volume
FROM port_traffic
WHERE Economy_Label != 'India'
GROUP BY Economy_Label
ORDER BY total_container_volume DESC
LIMIT 10;


-- India's Export Growth to Specific Regions (Using Port Traffic)

SELECT 
    year,
    Economy_Label as country,
    twentyftEU as container_volume
FROM port_traffic
WHERE Economy_Label IN ('China', 'USA', 'UAE', 'Singapore', 'Germany')
ORDER BY Economy_Label, year;


SELECT 
    year,
    SUM(CASE WHEN Economy_Label = 'India' THEN twentyftEU ELSE 0 END) as india_volume,
    SUM(CASE WHEN Economy_Label = 'China' THEN twentyftEU ELSE 0 END) as china_volume
FROM port_traffic
WHERE Economy_Label IN ('India', 'China')
GROUP BY year
ORDER BY year;


--------------------------------------------
-- import export findings
---------------------------------------------
-- india top 10 export product by value all years:
SELECT 
    Commodity,
    SUM(amt) as total_exports_million_usd
FROM exports_india
GROUP BY Commodity
ORDER BY total_exports_million_usd DESC
LIMIT 10;


--India's Top 10 Export Products for 2023
SELECT 
    Commodity,
    amt as exports_million_usd_2023
FROM exports_india
WHERE year = 2023
    AND amt > 0
ORDER BY amt DESC
LIMIT 10;

--India's Top 10 Import Products for 2023
SELECT 
    Commodity,
    amt as imports_million_usd_2023
FROM imports_india
WHERE year = 2023
    AND amt > 0
ORDER BY amt DESC
LIMIT 10;


