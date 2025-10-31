USE ds_salary_analysis;

-- 1. Trend Gaji per Tahun untuk Setiap Level Experience 
SELECT 
    s.work_year,
    s.experience_level,
    es.level_description,
    ROUND(AVG(s.salary_in_usd), 2) as avg_salary_usd,
    COUNT(*) as job_count
FROM salaries s
JOIN experience_summary es ON s.experience_level = es.experience_level
GROUP BY s.work_year, s.experience_level, es.level_description
ORDER BY s.work_year, avg_salary_usd DESC;

-- 2. Analisis Remote Work vs Salary 
SELECT 
    CASE 
        WHEN s.remote_ratio = 0 THEN 'No Remote'
        WHEN s.remote_ratio = 50 THEN 'Hybrid'
        WHEN s.remote_ratio = 100 THEN 'Fully Remote'
    END as work_type,
    COUNT(*) as job_count,
    ROUND(AVG(s.salary_in_usd), 2) as avg_salary_usd,
    ROUND(MIN(s.salary_in_usd), 2) as min_salary_usd,
    ROUND(MAX(s.salary_in_usd), 2) as max_salary_usd
FROM salaries s
GROUP BY work_type
ORDER BY avg_salary_usd DESC;

-- 3. Top 5 Negara dengan Gaji Tertinggi (berdasarkan company location)
SELECT 
    s.company_location,
    COUNT(*) as job_count,
    ROUND(AVG(s.salary_in_usd), 2) as avg_salary_usd,
    ROUND(MIN(s.salary_in_usd), 2) as min_salary_usd,
    ROUND(MAX(s.salary_in_usd), 2) as max_salary_usd
FROM salaries s
GROUP BY s.company_location
HAVING COUNT(*) >= 10  -- Hanya negara dengan minimal 10 records
ORDER BY avg_salary_usd DESC
LIMIT 5;

-- 4. Perbandingan Gaji: Employee Residence vs Company Location 
SELECT 
    s.employee_residence,
    s.company_location,
    COUNT(*) as job_count,
    ROUND(AVG(s.salary_in_usd), 2) as avg_salary_usd
FROM salaries s
WHERE s.employee_residence != s.company_location
GROUP BY s.employee_residence, s.company_location
HAVING COUNT(*) >= 3
ORDER BY avg_salary_usd DESC
LIMIT 10;

-- 5. Pertumbuhan Gaji untuk Data Scientist (job title paling populer) 
SELECT 
    s.work_year,
    COUNT(*) as job_count,
    ROUND(AVG(s.salary_in_usd), 2) as avg_salary_usd,
    ROUND((AVG(s.salary_in_usd) - LAG(AVG(s.salary_in_usd)) OVER (ORDER BY s.work_year)) / 
          LAG(AVG(s.salary_in_usd)) OVER (ORDER BY s.work_year) * 100, 2) as growth_percentage
FROM salaries s
WHERE s.job_title LIKE '%Data Scientist%'
GROUP BY s.work_year
ORDER BY s.work_year;
