/*문제1.
평균 급여보다 적은 급여을 받는 직원은 몇명인지 구하시요.
(56건)*/
select avg(salary) FROM employees; --6461
select count(salary) FROM employees ,(select avg(salary) FROM employees)
where avg(salary) > salary;

select count(*) FROM employees
where salary < (select avg(salary) FROM employees);

/*문제2.
평균급여 이상, 최대급여 이하의 월급을 받는 사원의
직원번호(employee_id), 이름(first_name), 급여(salary), 평균급여, 최대급여를 급여의 오름차
순으로 정렬하여 출력하세요
(51건)*/
select avg(salary),max(salary) FROM employees;  -- 6461,24000
select employee_id,first_name,salary
FROM employees
where salary > any(6461,24000)
ORDER BY salary;

select emp.employee_id, emp.first_name,emp.salary,
        t.avgSalary,t.maxSalary
FROM employees emp
    JOIN (select round(avg(salary))avgSalary,
                max(salary) maxSalary
                FROM employees)t
    on emp.salary between t.avgSalary and t.maxSalary
ORDER BY salary;
/*문제3.
직원중 Steven(first_name) king(last_name)이 소속된 부서(departments)가 있는 곳의 주소
를 알아보려고 한다.
도시아이디(location_id), 거리명(street_address), 우편번호(postal_code), 도시명(city), 주
(state_province), 나라아이디(country_id) 를 출력하세요
(1건)*/

SELECT location_id 도시아이디, street_address 거리명, postal_code 우편번호, city 도시명, 
    state_province 주, country_id 나라아이디
FROM locations loc
WHERE loc.location_id = (SELECT dept.location_id
                        FROM departments dept
                        JOIN employees emp ON dept.department_id = emp.department_id
                        WHERE emp.first_name = 'Steven' AND emp.last_name = 'King');

select location_id,
    street_address,
    postal_code,
    city,
    state_province,
    country_id
FROM locations
where location_id = (select location_id FROM departments where department_id =
                        (select department_id FROM employees
                        where first_name = 'Steven' and last_name = 'King'));
                        
select location_id,
    street_address,
    postal_code,
    city,
    state_province,
    country_id
FROM locations
    natural join departments -- location_id로 조인
    join employees on employees.department_id = departments.department_id
where first_name = 'Steven' and last_name = 'King';    
    

/*문제4.
job_id 가 'ST_MAN' 인 직원의 급여보다 작은 직원의 사번,이름,급여를 급여의 내림차순으로
출력하세요 -ANY연산자 사용
(74건)*/

select job_id ,salary FROM employees where job_id = 'ST_MAN';
select employee_id,first_name,salary FROM employees
where salary < any(8200,8000,7900,6500,5800)
ORDER BY salary desc;

select employee_id,first_name,salary FROM employees
where salary <any(select salary from employees where job_id='ST_MAN')
ORDER BY salary desc;

/*문제5.
각 부서별로 최고의 급여를 받는 사원의 직원번호(employee_id), 이름(first_name)과 급여
(salary) 부서번호(department_id)를 조회하세요
단 조회결과는 급여의 내림차순으로 정렬되어 나타나야 합니다.
조건절비교, 테이블조인 2가지 방법으로 작성하세요
(11건)*/
SELECT emp.employee_id 직원번호, emp.first_name 이름, emp.salary 급여, emp.department_id 부서번호
FROM employees emp JOIN (SELECT department_id, MAX(salary) salary
                        FROM employees
                        GROUP BY department_id) max_salary 
                        ON emp.department_id = max_salary.department_id 
                        AND emp.salary =  max_salary.salary
ORDER BY emp.salary DESC;

-- 조건절
select emp.employee_id,
        emp.first_name,
        emp.salary,
        emp.department_id 
FROM employees emp
where (emp.department_id,emp.salary) in (select department_id,max(salary)
                                        FROM employees  GROUP BY department_id)
ORDER BY salary desc;

-- 테이블 조인
select emp.employee_id,
        emp.salary,
        emp.department_id
FROM employees emp
    join (select department_id,max(salary) salary
        FROM employees GROUP BY department_id) t
    on emp.department_id = t.department_id
where emp.salary = t.salary
ORDER BY emp.salary desc;

-- 부서별 최고급여
--select department_id, max(salary) FROM employees GROUP BY department_id;


/*문제6.
각 업무(job) 별로 연봉(salary)의 총합을 구하고자 합니다.
연봉 총합이 가장 높은 업무부터 업무명(job_title)과 연봉 총합을 조회하시오
(19건)*/
SELECT j.job_title, SUM(emp.salary)
FROM jobs j
INNER JOIN employees emp ON j.job_id = emp.job_id
GROUP BY j.job_title
ORDER BY SUM(emp.salary) DESC;

SELECT j.job_title,
        t.sumSalary,
        j.job_id,
        t.job_id
FROM jobs j
    join (select job_id,sum(salary)sumSalary FROM employees GROUP BY job_id) t
    on j.job_id = t.job_id
ORDER BY sumSalary desc;    
--6-2 서브쿼리
SELECT job_title, (SELECT SUM(salary)   
                    FROM employees
                    WHERE employees.job_id = jobs.job_id) salary
FROM jobs
ORDER BY salary DESC;

/*문제7.
자신의 부서 평균 급여보다 연봉(salary)이 많은 직원의 직원번호(employee_id), 이름
(first_name)과 급여(salary)을 조회하세요
(38건)*/
SELECT employee_id, first_name, salary
FROM employees outer
WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id = outer.department_id)
ORDER BY salary;

select emp.employee_id,
        emp.first_name,
        emp.salary
FROM employees emp
    JOIN (select department_id,avg(salary) salary FROM employees
GROUP BY department_id) t
        on emp.department_id = t.department_id
WHERE emp.salary > t.salary;        


/*문제8.
직원 입사일이 11번째에서 15번째의 직원의 사번, 이름, 급여, 입사일을 입사일 순서로 출력
하세요*/
SELECT rownum, employee_id, first_name, salary, hire_date
FROM (SELECT employee_id, first_name, salary, hire_date, rownum rnum FROM employees)
WHERE rnum >= 11 AND rnum <= 15
ORDER BY hire_date;

------------------------------
select  rownum rn,
        employee_id,
        first_name,
        salary,
        hire_date
FROM (select employee_id,first_name,salary,hire_date
FROM (select employee_id,first_name,salary,hire_date
    FROM employees
    ORDER BY hire_date))
    where rn >=11 and rn <=15;
-------------------------ROWNUM 
SELECT rownum, employee_id, first_name, salary, hire_date
FROM
    (SELECT employee_id, first_name, salary, hire_date,
            ROW_NUMBER() OVER (ORDER BY hire_date) AS rnum
    FROM employees)
WHERE rnum >= 11 AND rnum <= 15;

-- RANK 함수사용
select rank, employee_id,first_name,salary,hire_date 
FROM (select employee_id,first_name,salary,hire_date,
        RANK() OVER (ORDER BY hire_date asc) AS rank FROM employees)
where rank between  11 and 15;       
