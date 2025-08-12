-- HR Analytics Dashboard: Tableau and Excel Component Validation
--
-- This SQL file contains the queries used to extract and validate key performance indicators (KPIs) and data points
-- for the HR Analytics dashboards built in Tableau and Excel. The queries were tested against a sample dataset
-- (`hr_analytics_validation_sample.csv`) to ensure accuracy and to confirm that the visualizations would function as intended on the full dataset
-- (`HR_Analytics_Data.csv`).
--
-- The goal was to provide a repeatable and verifiable source of truth for all dashboard metrics.
--
-- Developed by: Daryll Giovanny Bikak Mbal
-- Date: August 11, 2025


select * from hr_analytics_validation_sample;

-- Employee Count
select sum(employee_count) as employee_count from hr_analytics_validation_sample;

-- Attrition Count
select count(attrition) as attrition_count from hr_analytics_validation_sample where attrition = 'Yes';


--Attrition Rate
select round (((select count(attrition) from hr_analytics_validation_sample where attrition='Yes' and department = 'Sales')/ sum(employee_count)) * 100,2)
as attrition_rate from hr_analytics_validation_sample

-- Active Employees
select sum(employee_count) - (select count(attrition) from hr_analytics_validation_sample where attrition='Yes') from hr_analytics_validation_sample;

--Average Age
select round (avg(age),0)  as average_age from hr_analytics_validation_sample;

--Attrition By Gender: 
select gender, count(attrition) as attrition_count from hr_analytics_validation_sample
where attrition = 'Yes' --and education = 'High School'
group by gender
order by count(attrition) desc;

--Department wise attrtion
select department, count(attrition) as attrition_count,
round((cast(count(attrition) as numeric)/(select count(attrition) from hr_analytics_validation_sample where attrition = 'Yes'))*100,2) as attrition_rate from hr_analytics_validation_sample
where attrition = 'Yes'
group by department
order by count(attrition) desc;

--No of Employee by Age Group
SELECT age, sum(employee_count) AS employee_count FROM hr_analytics_validation_sample
GROUP BY age
order by age;

--Education Field wise Attrition:
select education_field, count(attrition) as attrition_count from hr_analytics_validation_sample
where attrition='Yes'
group by education_field
order by count(attrition) desc;

--Attrition Rate by Gender for different Age Group
select gender, age_band, count(attrition) as attrition_count,
round((cast(count(attrition) as numeric)/(select count(attrition) from hr_analytics_validation_sample where attrition = 'Yes'))*100,2) as attrition_rate from hr_analytics_validation_sample
where attrition = 'Yes'
group by age_band, gender
order by age_band, gender desc;

--Job Satisfaction Rating
CREATE EXTENSION IF NOT EXISTS tablefunc;
SELECT *
FROM crosstab (
'SELECT job_role, job_satisfaction, sum (employee_count)
FROM hrdata
GROUP BY job_role, job_satisfaction ORDER BY job_role, job_satisfaction'
) As ct(job_role varchar (50), one numeric, two numeric, three numeric, four numeric)
ORDER BY job_role;
