USE ds_salary_analysis;

-- 1. Statistik Dasar
SELECT 
    COUNT(*) as total_records,
    MIN(work_year) as start_year,
    MAX(work_year) as end_year,
    AVG(salary_in_usd) as avg_salary_usd,
    MIN(salary_in_usd) as min_salary_usd,
    MAX(salary_in_usd) as max_salary_usd
FROM salaries;

-- 2. Gaji Rata-rata berdasarkan Tahun
SELECT 
    work_year,
    ROUND(AVG(salary_in_usd), 2) as avg_salary_usd,
    COUNT(*) as job_count
FROM salaries
GROUP BY work_year
ORDER BY work_year;

-- 3. Distribusi Level Experience
SELECT 
    es.level_description,
    COUNT(*) as job_count,
    ROUND(AVG(s.salary_in_usd), 2) as avg_salary_usd,
    ROUND(MIN(s.salary_in_usd), 2) as min_salary_usd,
    ROUND(MAX(s.salary_in_usd), 2) as max_salary_usd
FROM salaries s
JOIN experience_summary es ON s.experience_level = es.experience_level
GROUP BY es.level_description, es.experience_level
ORDER BY avg_salary_usd DESC;

-- 4. Top 10 Job Title dengan Gaji Tertinggi
SELECT 
    job_title,
    ROUND(AVG(salary_in_usd), 2) as avg_salary_usd,
    COUNT(*) as job_count
FROM salaries
GROUP BY job_title
HAVING COUNT(*) >= 5  -- Hanya job title dengan minimal 5 records
ORDER BY avg_salary_usd DESC
LIMIT 10;

-- 5. Distribusi Company Size
SELECT 
    company_size,
    CASE 
        WHEN company_size = 'S' THEN 'Small'
        WHEN company_size = 'M' THEN 'Medium'
        WHEN company_size = 'L' THEN 'Large'
    END as size_description,
    COUNT(*) as job_count,
    ROUND(AVG(salary_in_usd), 2) as avg_salary_usd
FROM salaries
GROUP BY company_size
ORDER BY avg_salary_usd DESC;