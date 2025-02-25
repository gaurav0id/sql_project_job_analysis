# Introduction
This project analyzes the data analytics job market in India to uncover top-paying roles, in-demand skills, and the best skills to learn for career growth. Using SQL, we extract insights from job market data to help aspiring data analysts make informed decisions.  

SQL queries:- [project_sql_queries](project_sql)
# Background
With the rising demand for data analysts, knowing the right skills can give a competitive edge. This project answers key questions:
1. Which data analyst roles pay the most?
2. What skills do these high-paying jobs require?
3. Which skills are in the highest demand?
4. Which skills lead to higher salaries?
5. What are the most optimal skills to learn?

By leveraging SQL queries, we break down salary trends and skill demand to guide job seekers toward data-driven career choices.
# Tools I used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.  
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.  
- **Visual Studio Code:** My go-to for database management and executing SQL queries.  
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question: 

### 1. Top paying Data Analyst Jobs 
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location. This query highlights the high paying opportunities in the field.
```sql
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
```
| Job Title                                         | Company               | Average Salary (USD) |
|--------------------------------------------------|----------------------|---------------------|
| Senior Business & Data Analyst                  | Deutsche Bank        | 119,250.00         |
| Sr. Enterprise Data Analyst                     | ACA Group           | 118,140.00         |
| HR Data Operations Analyst                      | Clarivate           | 104,550.00         |
| Financial Data Analyst                          | Loop Health         | 93,600.00          |
| Healthcare Research & Data Analyst              | Clarivate           | 89,118.00          |
| AI Research Engineer                            | AlphaSense          | 79,200.00          |
| Data Integration & Business Intelligence Analyst | Miratech            | 79,200.00          |
| Data Analyst - Price Hub                        | Cargill             | 75,067.50          |
| Data Analyst I                                  | Bristol Myers Squibb | 71,600.00          |
| IT Data Analytic Architect - Biopharma          | Merck Group         | 64,800.00          |  

Here is a breakdown of the top data analyst jobs in 2023:
Senior & Specialized Roles Pay the Most

- The highest-paying roles are Senior Business & Data Analyst ($119,250) and Sr. Enterprise Data Analyst ($118,140).
This suggests that **experience and specialization significantly impact salaries.**
- **Industry Matters**  
**Finance & Banking:** Deutsche Bank and ACA Group offer the highest salaries.
**Healthcare & Research:** Clarivate and Loop Health also appear, showing demand for analysts in healthcare and biotech.
- Data Analyst I (Bristol Myers Squibb - $71,600) and IT Data Analytics Architect (Merck Group - $64,800) have **lower salaries, suggesting less experience or different responsibilities.**

### 2. Skills for top paying jobs 
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
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
```
Here is the quick breakdown of most demanded skills for the top 10 highest paying data analysts jobs in 2023 in India:
1. **SQL (7), Excel (6), and Python (5) are the most in-demand skills for top-paying data analyst roles in India.** This aligns with industry trends, where SQL is crucial for database querying, Excel for data manipulation, and Python for advanced analytics.
2. **Tableau (2) and Power BI (1)** indicate that data visualization is valued but not as frequently listed as SQL/Python. 

| Skills      | Average Salary |
|------------|---------------------|
| Visio      | 119,250.00          |
| Confluence | 119,250.00          |
| Jira       | 119,250.00          |
| Azure      | 118,140.00          |
| Power BI   | 118,140.00          |
| PowerPoint | 104,550.00          |
| Flow       | 96,603.75           |
| Sheets     | 93,600.00           |
| Word       | 89,578.50           |
| SQL        | 85,397.28           |


### 3. In demand skills for data analysts 
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.
```sql
SELECT
    skills,
    count(skills_job_dim.job_id) as demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'India'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```
Here's the breakdown of the most demanded skills for data analysts in 2023  

- SQL Pays Well but Isn’t the Highest
- SQL ($85,397.28), though essential, isn't the highest-paying skill.
- This suggests that while SQL is a necessary foundation, combining it with other high-paying skills (Azure, Power BI, or project management tools) can significantly boost earning potential.    

 **Most In-Demand Skills for Data Analysts (2023)**  
The table below shows the top skills in demand for data analyst roles based on job postings.

| Skills   | Demand Count |
|----------|-------------|
| SQL      | 1,016       |
| Excel    | 717         |
| Python   | 687         |
| Tableau  | 545         |
| Power BI | 402         |
### 4. Skills based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
SELECT
    skills,
    round(avg(salary_year_avg), 2) as avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'India'AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 10
```
Here is the breakdown of the results of top paying skills for data analysts  
- **Top Paying Skills: Visio, Confluence, and Jira** have the highest average salaries at ₹119,250 per year.
- **Cloud & BI Tools: Azure and Power BI** follow closely, indicating strong demand for cloud computing and business intelligence tools.
- **Microsoft Suite: PowerPoint, Word, and Excel (Sheets)** are also valuable but have comparatively lower salaries.
- **SQL Demand:** Despite being fundamental, SQL has the lowest average salary in this list, suggesting it is a necessary but not high-paying differentiator.  

**Skills & Average Salaries:**

| Rank | Skill        | Average Salary |
|------|-------------|----------------------|
| 1    | Visio       | $119,250.00          |
| 2    | Confluence  | $119,250.00          |
| 3    | Jira        | $119,250.00          |
| 4    | Azure       | $118,140.00          |
| 5    | Power BI    | $118,140.00          |
| 6    | PowerPoint  | $104,550.00          |
| 7    | Flow        | $96,603.75           |
| 8    | Sheets      | $93,600.00           |
| 9    | Word        | $89,578.50           |
| 10   | SQL         | $85,397.28           |
### 5. Most optimal skills to learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.
```sql
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
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    count(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25
```
 **Top High-Demand & High-Paying Tech Skills (2023)** 

| Skill ID | Skill        | Demand Count | Average Salary |
|----------|-------------|--------------|----------------------|
| 80       | Snowflake   | 241          | $111,578            |
| 92       | Spark       | 187          | $113,002            |
| 97       | Hadoop      | 140          | $110,888            |
| 75       | Databricks  | 102          | $112,881            |
| 93       | Pandas      | 90           | $110,767            |
| 81       | GCP        | 78           | $113,065            |
| 210      | Git        | 74           | $112,250            |
| 96       | Airflow    | 71           | $116,387            |
| 3        | Scala      | 59           | $115,480            |
| 169      | Linux      | 58           | $114,883            |
| 234      | Confluence | 62           | $114,153            |
| 95       | Pyspark    | 49           | $114,058            |
| 6        | Shell      | 44           | $111,496            |
| 98       | Kafka      | 40           | $129,999            |
| 168      | Unix       | 37           | $111,123            |
| 99       | TensorFlow | 24           | $120,647            |
| 137      | Phoenix    | 23           | $109,259            |
| 101      | PyTorch    | 20           | $125,226            |
| 31       | Perl       | 20           | $124,686            |
| 193      | Splunk     | 15           | $112,928            |
Here's a breakdown of the most optimal skills for Data Analysts in 2023:  
- **Kafka** (Skill ID: 98) has the highest average salary at $129,999 but lower demand (40 job postings).
- **Snowflake** (Skill ID: 80) has the highest demand (241 job postings) with a competitive salary of $111,578.
- **Machine Learning & Data Engineering skills (Kafka, PyTorch, TensorFlow, Hadoop, Airflow)** continue to command high salaries.
- **General-purpose programming & scripting skills (Scala, Python libraries like Pandas & Pyspark, Shell scripting)** remain highly valuable.
# What I Learned? 
Throughout this adventure, I've brushed up my SQL skills.
-  **Complex Query Crafting:** Mastered the art of **advanced SQL, merging tables** like a pro and wielding **WITH clauses** for ninja-level temp table maneuvers.
- **Data Aggregation:** Got cozy with **GROUP BY** and turned aggregate functions like **COUNT() and AVG()** into my data-summarizing sidekicks.
-  **Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.
# Conclusion
## Insights
**1. SQL, Excel, and Python Dominate Demand**  
- **SQL** is the most sought-after skill with **1,016 job postings**, followed by **Excel (717) and Python (687)**.
- This highlights that **data manipulation, analysis, and automation skills** are fundamental for data analysts in 2023.  

**2. Balance Between High Demand & High Pay**  
- Some skills like **Snowflake (241 jobs, $111K) and Hadoop (140 jobs, $110K)** offer both **high job availability and strong salaries.**
- On the other hand, specialized tools like **Kafka and PyTorch pay exceptionally well but have fewer job openings,** making them high-risk, high-reward skills to learn.
## Closing Thoughts
This project strengthened my SQL skills and provided key insights into the data analyst job market. The analysis serves as a strategic guide for prioritizing skill development and job search efforts. By focusing on high-demand and high-paying skills, aspiring data analysts can enhance their competitiveness in the industry. This exploration underscores the importance of continuous learning and staying adaptable to evolving trends in data analytics.
