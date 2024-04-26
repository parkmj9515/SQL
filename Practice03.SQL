--
SELECT emp.employee_id,
        emp.first_name,
        last_name,
        department_name
        FROM employees emp left outer join departments dept
          on emp.employee_id = dept.department_id
 ORDER BY dept.department_id , emp.employee_id desc;    
---------------------------------------------------------------------------
/* 2.employees 테이블의 job_id는 현재의 업무아이디를 가지고 있습니다.
직원들의 사번(employee_id), 이름(firt_name), 급여(salary), 부서명(department_name), 현
재업무(job_title)를 사번(employee_id) 오름차순 으로 정렬하세요.
부서가 없는 Kimberely(사번 178)은 표시하지 않습니다.*/
SELECT emp.employee_id,
             first_name,
             salary,
             j.job_id
        
FROM employees emp left outer join jobs j
on emp.employee_id = j.job_id
ORDER BY emp.employee_id desc;
 
--문제2에서 부서가 없는 Kimberely(사번 178)까지 표시해 보세요   
 
 
/* 4.도시별로 위치한 부서들을 파악하려고 합니다.
도시아이디, 도시명, 부서명, 부서아이디를 도시아이디(오름차순)로 정렬하여 출력하세요
부서가 없는 도시는 표시하지 않습니다. */
select department_name
FROm departments;

SELECT  cou.country_id,
        cou.country_name,
        dep.department_name,
        dep.department_id
FROM countries cou right outer join departments dep    
    on cou.country_name = dep.department_name
    ORDER BY cou.country_id;
    
--3-1 문제3에서 부서가 없는 도시도 표시합니다. 


/* 4.지역(regions)에 속한 나라들을 지역이름(region_name), 나라이름(country_name)으로 출력하
되 지역이름(오름차순), 나라이름(내림차순) 으로 정렬하세요.*/
select country_name
FROM countries;
SELECT re.region_name,
        co.country_name
FROM regions re right outer join countries co
on re.region_name = co.country_name
ORDER BY re.region_name , co.country_name desc;

/* 5.자신의 매니저보다 채용일(hire_date)이 빠른 사원의
사번(employee_id), 이름(first_name)과 채용일(hire_date), 매니저이름(first_name), 매니저입
사일(hire_date)을 조회하세요. */
select hire_date
from employees;
SELECT emp.employee_id,
        emp.first_name,
        emp.hire_date,
        dep.hire_date,
        dep.first_name
FROM employees emp  join employees dep   
    where emp.hire_date = dep.manager_id;
--where emp.hire_date > dep.hire_date;    




        
          
