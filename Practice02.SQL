--1
SELECT manager_id FROM employees;

--2
SELECT max_salary 최고임금,
        min_salary 최저임금,
       max_salary - min_salary 임금차이
FROM jobs;

--3
SELECT hire_date 입사일,
    TO_CHAR(hire_date,'YYYY"년"MM"월"dd"일"')
    from employees
ORDER BY HIRE_DATE DESC;
