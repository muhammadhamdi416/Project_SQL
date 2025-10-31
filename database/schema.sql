-- Buat database
CREATE DATABASE IF NOT EXISTS ds_salary_analysis;
USE ds_salary_analysis;

-- Tabel utama untuk data gaji
CREATE TABLE salaries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    work_year INT,
    experience_level ENUM('EN', 'MI', 'SE', 'EX'),
    employment_type ENUM('FT', 'PT', 'CT', 'FL'),
    job_title VARCHAR(100),
    salary DECIMAL(15,2),
    salary_currency VARCHAR(10),
    salary_in_usd DECIMAL(15,2),
    employee_residence VARCHAR(10),
    remote_ratio INT,
    company_location VARCHAR(10),
    company_size ENUM('S', 'M', 'L')
);


-- Tabel untuk analisis trend tahunan
CREATE TABLE yearly_trends (
    id INT PRIMARY KEY AUTO_INCREMENT,
    work_year INT,
    avg_salary_usd DECIMAL(15,2),
    total_jobs INT,
    popular_job_title VARCHAR(100),
    popular_job_count INT
);

-- Tabel untuk ringkasan berdasarkan level experience
CREATE TABLE experience_summary (
    id INT PRIMARY KEY AUTO_INCREMENT,
    experience_level ENUM('EN', 'MI', 'SE', 'EX'),
    level_description VARCHAR(50),
    avg_salary_usd DECIMAL(15,2),
    min_salary_usd DECIMAL(15,2),
    max_salary_usd DECIMAL(15,2),
    job_count INT
);

-- Insert deskripsi level experience
INSERT INTO experience_summary (experience_level, level_description) VALUES
('EN', 'Entry-level'),
('MI', 'Mid-level'),
('SE', 'Senior-level'),
('EX', 'Executive-level');
