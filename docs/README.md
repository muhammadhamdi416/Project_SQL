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
