-- import data melalui "Tabel data import wizard"
USE ds_salary_analysis;

insert into salaries (
	work_year, 
	experience_level, 
	employment_type, 
	job_title, salary, 
	salary_currency, 
	salary_in_usd, 
	employee_residence,
	remote_ratio,
	company_location,
	company_size) 
select 
	work_year, 
	experience_level, 
	employment_type, 
	job_title, salary, 
	salary_currency, 
	salary_in_usd, 
	employee_residence,
	remote_ratio,
	company_location,
	company_size
    from ds_salaries;


-- Update deskripsi experience level
set sql_safe_updates = 0;
UPDATE experience_summary es
JOIN (
    SELECT 
        experience_level,
        AVG(salary_in_usd) as avg_salary,
        MIN(salary_in_usd) as min_salary,
        MAX(salary_in_usd) as max_salary,
        COUNT(*) as job_count
    FROM salaries
    GROUP BY experience_level
) s ON es.experience_level = s.experience_level
SET 
    es.avg_salary_usd = s.avg_salary,
    es.min_salary_usd = s.min_salary,
    es.max_salary_usd = s.max_salary,
    es.job_count = s.job_count;
set sql_safe_updates = 1;

-- Populasi tabel yearly_trends
INSERT INTO yearly_trends (work_year, avg_salary_usd, total_jobs, popular_job_title, popular_job_count)
SELECT 
    work_year,
    AVG(salary_in_usd) as avg_salary_usd,
    COUNT(*) as total_jobs,
    (SELECT job_title FROM salaries s2 
     WHERE s2.work_year = s1.work_year 
     GROUP BY job_title 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) as popular_job_title,
    (SELECT COUNT(*) FROM salaries s3 
     WHERE s3.work_year = s1.work_year 
     AND s3.job_title = (SELECT job_title FROM salaries s4 
                        WHERE s4.work_year = s1.work_year 
                        GROUP BY job_title 
                        ORDER BY COUNT(*) DESC 
                        LIMIT 1)) as popular_job_count
FROM salaries s1
GROUP BY work_year;
