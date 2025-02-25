/*
Question: What are the most optimal skills to learn?
- Identify skills in high demand and have higher average salaries for data analyst roles in India.
Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career in data analysis.
*/

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    count(skills_job_dim.job_id) as demand_count,
    round(avg(job_postings_fact.salary_year_avg), 0) as avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'India' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    count(skills_job_dim.job_id) > 2
ORDER BY
    avg_salary DESC,
    demand_count DESC