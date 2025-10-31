USE ds_salary_analysis;

-- INSIGHT 1: Kenaikan Gaji Rata-rata per Tahun
SELECT 
    work_year,
    ROUND(AVG(salary_in_usd), 2) as avg_salary,
    ROUND((AVG(salary_in_usd) - LAG(AVG(salary_in_usd)) OVER (ORDER BY work_year)) / 
          LAG(AVG(salary_in_usd)) OVER (ORDER BY work_year) * 100, 2) as yoy_growth
FROM salaries
GROUP BY work_year
ORDER BY work_year;

-- INSIGHT 2: Perbandingan Gaji berdasarkan Company Size dan Experience Level
SELECT 
    company_size,
    CASE 
        WHEN company_size = 'S' THEN 'Small'
        WHEN company_size = 'M' THEN 'Medium'
        WHEN company_size = 'L' THEN 'Large'
    END as size_description,
    experience_level,
    es.level_description,
    COUNT(*) as job_count,
    ROUND(AVG(salary_in_usd), 2) as avg_salary_usd
FROM salaries s
JOIN experience_summary es ON s.experience_level = es.experience_level
GROUP BY company_size, experience_level, es.level_description
ORDER BY company_size, avg_salary_usd DESC;

-- INSIGHT 3: Top Paying Roles di Setiap Experience Level
WITH RankedJobs AS (
    SELECT 
        experience_level,
        job_title,
        AVG(salary_in_usd) as avg_salary,
        COUNT(*) as job_count,
        ROW_NUMBER() OVER (PARTITION BY experience_level ORDER BY AVG(salary_in_usd) DESC) as rank_num
    FROM salaries
    GROUP BY experience_level, job_title
    HAVING COUNT(*) >= 3  -- Minimal 3 records untuk reliabilitas
)
SELECT 
    rj.experience_level,
    es.level_description,
    rj.job_title,
    ROUND(rj.avg_salary, 2) as avg_salary_usd,
    rj.job_count
FROM RankedJobs rj
JOIN experience_summary es ON rj.experience_level = es.experience_level
WHERE rj.rank_num <= 3  -- Top 3 untuk setiap level
ORDER BY rj.experience_level, rj.rank_num;

-- INSIGHT 4: Analisis Remote Work Preference per Tahun
SELECT 
    work_year,
    CASE 
        WHEN remote_ratio = 0 THEN 'No Remote'
        WHEN remote_ratio = 50 THEN 'Hybrid'
        WHEN remote_ratio = 100 THEN 'Fully Remote'
    END as work_type,
    COUNT(*) as job_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY work_year), 2) as percentage
FROM salaries
GROUP BY work_year, work_type
ORDER BY work_year, job_count DESC;
