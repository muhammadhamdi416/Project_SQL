# Data Science Salary Analysis - MySQL Project

## Overview
Project analisis dataset gaji profesional data science menggunakan MySQL. Dataset mencakup informasi gaji dari tahun 2020-2022 dengan berbagai faktor seperti experience level, lokasi, tipe employment, dan lain-lain.

## Dataset
- **Source**: ds_salaries.csv
- **Records**: 607 entries
- **Period**: 2020-2022
- **Features**: work_year, experience_level, employment_type, job_title, salary, salary_currency, salary_in_usd, employee_residence, remote_ratio, company_location, company_size

## Database Schema
### Tabel Utama:
1. **salaries** - Data utama gaji
2. **yearly_trends** - Trend tahunan
3. **experience_summary** - Ringkasan berdasarkan level experience

## Quick Start
1. Clone repository ini
2. Import database schema:
   ```sql
   SOURCE database/schema.sql
   SOURCE database/data_import.sql
   SOURCE database/queries.sql


## Cara Menggunakan

1. **Buat repository baru di GitHub** dengan nama "ds-salary-mysql-analysis"

2. **Upload semua file** ke repository tersebut

3. **Import ke MySQL**:
   ```bash
   mysql -u username -p < database/schema.sql
   mysql -u username -p < database/data_import.sql
   ```

4. **Jalankan analisis**:
  ```sql
   SOURCE analysis/basic_analysis.sql;
   SOURCE analysis/advanced_queries.sql;
   SOURCE analysis/insights.sql;
  ```

## Preview Project
  1. Data_Import
<img src="Images/Data_Import.png" alt="Data_Import">

  2. Advanced_Queries
<img src="Images/Advanced_Queries.png" alt="Advanced_Queries.">
