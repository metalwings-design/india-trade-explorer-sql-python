# India Trade Explorer: SQL + Python Analytics

[![Python 3.9+](https://img.shields.io/badge/Python-3.9+-blue.svg)](https://www.python.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-orange.svg)](https://www.postgresql.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive data pipeline analyzing India's international trade patterns, port traffic, and tariff rates using SQL (PostgreSQL) and Python visualizations.

## 📊 Pipeline Overview

**Data Source → PostgreSQL → Python Visualization**

This project demonstrates a complete data engineering and analytics workflow:

1. **Data Collection** - Downloaded from authoritative government and international sources
2. **Data Cleaning & Loading** - Python scripts load and clean data into PostgreSQL
3. **SQL Analysis** - Complex queries for trade patterns, balances, and trends
4. **Visualization** - Python generates plots

## 📦 Data Sources

| Dataset | Source | Description |
|---------|--------|-------------|
| Port Traffic | [UNCTADstat](https://unctadstat.unctad.org/datacentre/) | Container port traffic volumes |
| HS Codes | [World Bank WITS](https://wits.worldbank.org/referencedata.html) | Harmonized System product classification |
| Import/Export | [DGFT India](https://www.dgft.gov.in/CP/?opt=itchs-import-export) | India's trade data (2018-2025) |
| Tariff Rates | [UNCTADstat](https://unctadstat.unctad.org/datacentre/) | Import tariff rates on non-agricultural/non-fuel products |

## 🗄️ Finddings

### India Trade Balance (2018-2024)

India has consistently maintained a **trade deficit** throughout the 2018-2024 period, meaning imports have exceeded exports every year. The deficit narrowed temporarily in 2020 (likely due to pandemic-related disruptions) but widened significantly post-2021, reaching its highest level in 2024 at **27,782 Million**.

```sql
SELECT 
    COALESCE(e.year, i.year) as year,
    COALESCE(SUM(e.amt), 0) as total_exports,
    COALESCE(SUM(i.amt), 0) as total_imports,
    COALESCE(SUM(e.amt), 0) - COALESCE(SUM(i.amt), 0) as trade_balance
FROM exports_india e
FULL OUTER JOIN imports_india i ON e.year = i.year
GROUP BY COALESCE(e.year, i.year)
ORDER BY year;
```

```markdown
**Query Results:**

| year | total_exports | total_imports | trade_balance |
|------|--------------|---------------|----------------|
| 2018 | 32347653.8000 | 50379684.1800 | -18032030.3800 |
| 2019 | 30709385.8400 | 46521510.4200 | -15812124.5800 |
| 2020 | 28597234.9600 | 38654717.2200 | -10057482.2600 |
| 2021 | 41356431.2000 | 60079101.8800 | -18722670.6800 |
| 2022 | 44204857.0600 | 70164953.1800 | -25960096.1200 |
| 2023 | 42833061.8800 | 66465048.4400 | -23631986.5600 |
| 2024 | 42895045.9000 | 70677624.5000 | -27782578.6000 |

```

![Plot](plots/Figure_1.png)

### Top 10 Highest Tariff Nations & Commodities in 2023
This analysis identifies countries with the highest protective trade barriers. Morocco and Bolivia dominate the list, with Morocco appearing 4 times across different product categories. The highest tariff rate (33.64%) is imposed by Bolivia on "Other manufactured goods" (HS Code 9). Notably, Argentina, Algeria, and Belize also feature among the most protectionist nations for specific commodity categories.

```sql
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
```
```markdown
| Rank | Country | Highest Tariff (%) | Product Category |
|------|---------|-------------------|------------------|
| 1 | Bolivia | 33.64% | Other manufactured goods |
| 2 | Morocco | 33.11% | Other manufactured goods |
| 3 | Argentina | 30.19% | Other manufactured goods |
| 4 | Algeria | 30.00% | Chemical products |
| 5 | Belize | 30.00% | Machinery & transport equipment |
```
![Plot](plots/2_tariff_nations.png)

###  India Container Port Traffic Growth (2010-2024)
India's container port traffic has shown remarkable growth over the past 15 years, increasing from 9.2 million TEU in 2010 to 23.9 million TEU in 2024 - a 158% increase. This steady upward trend reflects India's growing integration into global trade networks, expanding manufacturing sector, and improving port infrastructure.

```sql
SELECT 
    year,
    Economy_Label as country,
    twentyftEU as container_volume
FROM port_traffic
WHERE Economy_Label = 'India'
ORDER BY year;
```

```marakdown
year	country	container_volume
2010	India	9235765
2011	India	9878067
2012	India	10017480
2013	India	10571320
2014	India	11652174
2015	India	12318610
2016	India	13724110
2017	India	15450523
2018	India	16996593
2019	India	17487621
2020	India	17597062
2021	India	19561769
2022	India	19717168
2023	India	22208000
2024	India	23898000
```
![Plot](plots/2_tariff_nations.png)
