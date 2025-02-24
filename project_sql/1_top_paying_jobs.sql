/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying data analyst roles that are available in India.
-Focus on job postings with specified salaries (remove nulls).
 */

SELECT
    job_id,
    job_title,
    job_location,
    salary_year_avg,
    job_posted_date,
    name as company_name
FROM
    job_postings_fact
LEFT JOIN company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'India' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10