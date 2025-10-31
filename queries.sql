USE ds_salary_analysis;

-- =============================================
-- QUICK UTILITY QUERIES
-- =============================================

-- 1. Cek struktur tabel
DESCRIBE salaries;
DESCRIBE yearly_trends;
DESCRIBE experience_summary;

-- 2. Cek total data
SELECT 
    (SELECT COUNT(*) FROM salaries) as total_salaries,
    (SELECT COUNT(*) FROM yearly_trends) as total_yearly_trends,
    (SELECT COUNT(*) FROM experience_summary) as total_experience_levels;

-- =============================================
-- DATA EXPLORATION QUERIES
-- =============================================

-- 3. Lihat sample data dengan format rapi
SELECT 
    id,
    work_year,
    experience_level,
    employment_type,
    job_title,
    FORMAT(salary, 0) as salary_local,
    salary_currency,
    FORMAT(salary_in_usd, 0) as salary_usd,
    employee_residence,
    company_location,
    company_size
FROM salaries 
LIMIT 10;

-- 4. Cek unique values untuk setiap kolom kategori
SELECT 'experience_level' as column_name, COUNT(DISTINCT experience_level) as unique_count FROM salaries
UNION ALL
SELECT 'employment_type', COUNT(DISTINCT employment_type) FROM salaries
UNION ALL
SELECT 'job_title', COUNT(DISTINCT job_title) FROM salaries
UNION ALL
SELECT 'company_size', COUNT(DISTINCT company_size) FROM salaries
UNION ALL
SELECT 'remote_ratio', COUNT(DISTINCT remote_ratio) FROM salaries;

-- 5. List semua job title yang ada
SELECT 
    job_title,
    COUNT(*) as frequency
FROM salaries
GROUP BY job_title
ORDER BY frequency DESC;

-- =============================================
-- QUICK ANALYSIS QUERIES
-- =============================================

-- 6. Gaji tertinggi dan terendah
SELECT 
    'HIGHEST' as type,
    job_title,
    experience_level,
    company_location,
    FORMAT(salary_in_usd, 0) as salary_usd
FROM salaries
ORDER BY salary_in_usd DESC
LIMIT 5;

SELECT 
    'LOWEST' as type,
    job_title,
    experience_level,
    company_location,
    FORMAT(salary_in_usd, 0) as salary_usd
FROM salaries
ORDER BY salary_in_usd ASC
LIMIT 5;

-- 7. Perbandingan gaji: Local vs USD untuk currency tertentu
SELECT 
    salary_currency,
    COUNT(*) as record_count,
    FORMAT(AVG(salary), 0) as avg_local_salary,
    FORMAT(AVG(salary_in_usd), 0) as avg_usd_salary
FROM salaries
WHERE salary_currency IN ('USD', 'EUR', 'GBP', 'CAD')
GROUP BY salary_currency
ORDER BY record_count DESC;

-- =============================================
-- FILTERING & SEARCH QUERIES
-- =============================================

-- 8. Cari gaji untuk role tertentu
SELECT 
    job_title,
    experience_level,
    company_location,
    company_size,
    FORMAT(salary_in_usd, 0) as salary_usd
FROM salaries
WHERE job_title LIKE '%Data Scientist%'
ORDER BY salary_in_usd DESC
LIMIT 15;

-- 9. Filter berdasarkan experience level dan company size
SELECT 
    job_title,
    company_location,
    FORMAT(AVG(salary_in_usd), 0) as avg_salary_usd,
    COUNT(*) as job_count
FROM salaries
WHERE experience_level = 'SE' 
  AND company_size = 'L'
GROUP BY job_title, company_location
HAVING COUNT(*) >= 2
ORDER BY avg_salary_usd DESC;

-- 10. Cari remote jobs dengan gaji tinggi
SELECT 
    job_title,
    company_location,
    CASE 
        WHEN remote_ratio = 100 THEN 'Fully Remote'
        WHEN remote_ratio = 50 THEN 'Hybrid'
        ELSE 'On-site'
    END as work_type,
    FORMAT(salary_in_usd, 0) as salary_usd
FROM salaries
WHERE remote_ratio >= 50
  AND salary_in_usd > 100000
ORDER BY salary_in_usd DESC
LIMIT 10;

-- =============================================
-- DATA QUALITY CHECK QUERIES
-- =============================================

-- 11. Cek data anomalies
SELECT 
    'Zero Salary' as check_type,
    COUNT(*) as problematic_records
FROM salaries
WHERE salary_in_usd = 0 OR salary = 0

UNION ALL

SELECT 
    'Missing Experience Level',
    COUNT(*)
FROM salaries
WHERE experience_level IS NULL OR experience_level = ''

UNION ALL

SELECT 
    'Extreme Outliers (Above 1M)',
    COUNT(*)
FROM salaries
WHERE salary_in_usd > 1000000;

-- 12. Cek konsistensi currency conversion
SELECT 
    salary_currency,
    ROUND(AVG(salary_in_usd / NULLIF(salary, 0)), 4) as avg_conversion_rate,
    COUNT(*) as samples
FROM salaries
WHERE salary > 0 AND salary_in_usd > 0
GROUP BY salary_currency
HAVING samples >= 5
ORDER BY samples DESC;

-- =============================================
-- EXPORT QUERIES (untuk visualisasi)
-- =============================================

-- 13. Data untuk chart: Salary trend per tahun
SELECT 
    work_year,
    experience_level,
    ROUND(AVG(salary_in_usd), 2) as avg_salary
FROM salaries
GROUP BY work_year, experience_level
ORDER BY work_year, 
    CASE experience_level
        WHEN 'EN' THEN 1
        WHEN 'MI' THEN 2
        WHEN 'SE' THEN 3
        WHEN 'EX' THEN 4
    END;

-- 14. Data untuk chart: Salary distribution by company size
SELECT 
    company_size,
    CASE 
        WHEN company_size = 'S' THEN 'Small'
        WHEN company_size = 'M' THEN 'Medium'
        WHEN company_size = 'L' THEN 'Large'
    END as size_label,
    ROUND(AVG(salary_in_usd), 2) as avg_salary,
    COUNT(*) as job_count
FROM salaries
GROUP BY company_size
ORDER BY avg_salary DESC;

-- =============================================
-- QUICK INSIGHT QUERIES
-- =============================================

-- 15. Quick business insights
SELECT 
    'Average Salary by Year' as insight,
    work_year,
    FORMAT(AVG(salary_in_usd), 0) as avg_salary
FROM salaries
GROUP BY work_year

UNION ALL

SELECT 
    'Remote Work Popularity',
    work_year,
    COUNT(*) as remote_jobs
FROM salaries
WHERE remote_ratio = 100
GROUP BY work_year

UNION ALL

SELECT 
    'Most Popular Job Title',
    work_year,
    (SELECT job_title FROM salaries s2 
     WHERE s2.work_year = s1.work_year 
     GROUP BY job_title 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) as popular_job
FROM salaries s1
GROUP BY work_year;

-- 16. Salary premium untuk experience
SELECT 
    'Salary Premium Analysis' as analysis_type,
    experience_level,
    FORMAT(AVG(salary_in_usd), 0) as avg_salary,
    FORMAT(AVG(salary_in_usd) - (SELECT AVG(salary_in_usd) FROM salaries), 0) as difference_from_mean
FROM salaries
GROUP BY experience_level
ORDER BY avg_salary DESC;