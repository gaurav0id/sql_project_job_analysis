SELECT
    companies.name,
    postings.job_health_insurance,
    EXTRACT(MONTH FROM postings.job_posted_date) as month
FROM
    company_dim as companies
LEFT JOIN
    job_postings_fact as postings on companies.company_id = postings.company_id
WHERE
    postings.job_health_insurance IS TRUE AND
    EXTRACT(MONTH FROM postings.job_posted_date) between 4 and 6

create table january_jobs as
    SELECT *
    FROM 
        job_postings_fact
    WHERE
        EXTRACT(month FROM job_posted_date) = 1;

create table february_jobs as
    SELECT *
    FROM 
        job_postings_fact
    WHERE
        EXTRACT(month FROM job_posted_date) = 2;

create table march_jobs as
    SELECT *
    FROM 
        job_postings_fact
    WHERE
        EXTRACT(month FROM job_posted_date) = 3;

SELECT
    count(job_id) as job_postings,
    case 
        when job_location = 'Anywhere' then 'Remote'
        when job_location = 'New York, NY' then 'Local'
        else 'On-Site'
    end as location_type
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_type;

SELECT
    job_title_short,
    salary_year_avg,
    case
        when salary_year_avg < '75000' then 'Low salary'
        when salary_year_avg between '75000' and '100000' then 'Standard'
        else 'High salary'
    end as salary_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst' and
    salary_year_avg IS not null
ORDER BY
    salary_year_avg DESC;

SELECT
    company_id,
    name as company_name
FROM
    company_dim
WHERE
    company_id in (
        SELECT
            company_id
        FROM
            job_postings_fact
        WHERE
            job_no_degree_mention is TRUE
        ORDER BY
            company_id
    )

with company_job_count as (
    SELECT
        company_id,
        count(*) as total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)
SELECT
    companies.name as company_name,
    company_job_count.total_jobs
FROM
    company_dim as companies
LEFT JOIN company_job_count on company_job_count.company_id = companies.company_id
ORDER BY
    company_job_count.total_jobs DESC

with top_skills as (   
    SELECT
        skill_id,
        count(skill_id) as no_of_times_mentioned
    from
        skills_job_dim
    GROUP BY
        skill_id
    ORDER BY
        no_of_times_mentioned DESC
    limit 5
)
SELECT
    skills.skills,
    skills.skill_id,
    top_skills.no_of_times_mentioned
from
    skills_dim as skills
inner JOIN 
    top_skills on skills.skill_id = top_skills.skill_id
ORDER BY
    no_of_times_mentioned DESC

with jobs as (
    SELECT
        company_id,
        count(job_id) as job_count
    FROM
        job_postings_fact
    GROUP BY
        company_id
)   
SELECT
    companies.name as company_name,
    jobs.job_count,
    case
        when jobs.job_count < 10 then 'Small'
        when jobs.job_count between 10 and 50 then 'Medium'
        else 'Large'
    end as job_catogary
FROM
    company_dim as companies
LEFT JOIN 
    jobs on companies.company_id = jobs.company_id
ORDER BY
    job_count DESC

with Remote_job_skills as (
    SELECT
        skill_id,
        count(*) as skill_count
    FROM
        skills_job_dim as skills_to_job
    inner JOIN
        job_postings_fact as job_postings on job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home is TRUE and
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)
SELECT
    skills.skill_id,
    skills.skills as skill_name,
    skill_count
FROM
    Remote_job_skills
inner JOIN
    skills_dim as skills on skills.skill_id = Remote_job_skills.skill_id
ORDER BY
    skill_count DESC
limit 5;

SELECT 
    q1_job_postings.job_title_short,
    skills.skills as skill_name,
    skills.type as skill_type,
    q1_job_postings.job_posted_date::date,
    q1_job_postings.job_via,
    q1_job_postings.salary_year_avg
from (
    SELECT *
    from january_jobs
    UNION all
    SELECT *
    from february_jobs
    UNION all
    SELECT *
    from march_jobs
) as q1_job_postings
LEFT JOIN
    skills_job_dim as skills_to_job on skills_to_job.job_id = q1_job_postings.job_id
LEFT JOIN
    skills_dim as skills on skills.skill_id = skills_to_job.skill_id
WHERE
    salary_year_avg > 70000 and
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC

