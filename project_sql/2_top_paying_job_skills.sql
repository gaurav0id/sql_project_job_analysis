/*
Question: What skills are required for the top-paying data analyst jobs?
- use the top 10 highest-paying data analyst jobs from first querry
- add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        salary_year_avg,
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
)
SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg

/*
SQL (7), Excel (6), and Python (5) are the most in-demand skills for top-paying data analyst roles in India. This aligns with industry trends, where SQL is crucial for database querying, Excel for data manipulation, and Python for advanced analytics.
*/