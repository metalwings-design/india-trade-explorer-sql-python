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

## 🗄️ Database Schema

India Trade Balance (2018-2024)

**SQL Query** (see `code/02_analysis.sql` for full query):


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


query output:
year	total_exports	total_imports	trade_balance
2018	32347653.8000	50379684.1800	-18032030.3800
2019	30709385.8400	46521510.4200	-15812124.5800
2020	28597234.9600	38654717.2200	-10057482.2600
2021	41356431.2000	60079101.8800	-18722670.6800
2022	44204857.0600	70164953.1800	-25960096.1200
2023	42833061.8800	66465048.4400	-23631986.5600
2024	42895045.9000	70677624.5000	-27782578.6000
