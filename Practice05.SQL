/*문제1.
담당 매니저가 배정되어있으나 커미션비율이 없고, 월급이 3000초과인 직원의
이름, 매니저 아이디, 커미션 비율, 월급을 출력하세요.
(45건)*/
select first_name 이름,manager_id, commission_pct,salary 월급
FROM employees
where salary > 3000 and commission_pct is null and manager_id is not null;

/*문제2.
각 부서별로 최고의 급여를 받는 사원의 직원번호(employee_id), 이름(first_name), 급여
(salary), 입사일(hire_date), 전화번호(phone_number), 부서번호(department_id)를 조회하세
요
-조건절 비교 방법으로 작성하세요
-급여의 내림차순으로 정렬하세요
-입사일은 2001-01-13 토요일 형식으로 출력합니다.
-전화번호는 515-123-4567 형식으로 출력합니다.
(11건)*/
select emp.employee_id 직원번호,
        emp.first_name 이름,
        emp.salary 급여,
        TO_CHAR(emp.hire_date,'YYYY-MM-DD DAY') 입사일,
        REPLACE(substr(emp.phone_number,3),'.','-') 전화번호,
        emp.department_id 부서번호
FROM employees emp
where (emp.department_id,emp.salary) in (select department_id,max(salary) FROM employees GROUP BY department_id)
ORDER BY salary desc;


/*문제3
매니저별로 평균급여 최소급여 최대급여를 알아보려고 한다.
-통계대상(직원)은 2015년 이후의 입사자 입니다.
-매니저별 평균급여가 5000이상만 출력합니다.
-매니저별 평균급여의 내림차순으로 출력합니다.
-매니저별 평균급여는 소수점 첫째자리에서 반올림 합니다.
-출력내용은 매니저 아이디, 매니저이름(first_name), 매니저별 평균급여, 매니저별 최소급여,
매니저별 최대급여 입니다.
(9건)*/
select  emp.manager_id 매니저아이디,
        first_name 이름,
        dept.manager_id,
        round(avg(salary)) 평균급여,
        min(salary) 최소급여,
        max(salary) 최대급여,
        
FROM employees emp , departments dept
where emp.employee_id = dept.manager_id
group by first_name,emp.manager_id,dept.manager_id
ORDER BY avg(salary) desc;

/*문제4.
각 사원(employee)에 대해서 사번(employee_id), 이름(first_name), 부서명
(department_name), 매니저(manager)의 이름(first_name)을 조회하세요.
부서가 없는 직원(Kimberely)도 표시합니다.
(106명)*/
SELECT emp.employee_id 사번,
        emp.first_name 이름,
        dept.department_name 부서명,
        man.first_name 매니저명
FROM employees emp left outer join departments dept
    on emp.department_id = dept.department_id
    join employees man
    on emp.manager_id = man.employee_id;
  
/*문제5.
2015년 이후 입사한 직원 중에 입사일이 11번째에서 20번째의 직원의
사번, 이름, 부서명, 급여, 입사일을 입사일 순서로 출력하세요*/
SELECT rownum, employee_id, first_name, salary, hire_date
FROM (SELECT employee_id, first_name, salary, hire_date, rownum rnum FROM employees) 
WHERE rnum >= 11 AND rnum <= 20
ORDER BY hire_date;

/*문제6.
가장 늦게 입사한 직원의 이름(first_name last_name)과 연봉(salary)과 근무하는 부서 이름
(department_name)은?*/
SELECT  to_char(max(hire_date),'YYYY"년"MM"월"DD"일"') 마지막입사일,
        first_name || ' ' || last_name 이름,
        salary*12 연봉,
        department_name 부서명
FROM employees , departments
where max(hire_date)
group by first_name || ' ' || last_name,salary*12,department_name
order by max(hire_date) desc;

select  to_char(max(hire_date),'YYYY"년"MM"월"DD"일"')
from employees;
/*문제7.
평균연봉(salary)이 가장 높은 부서 직원들의 직원번호(employee_id), 이름(firt_name), 성
(last_name)과 업무(job_title), 연봉(salary)을 조회하시오.*/
select  
        emp.employee_id 사번,
        emp.first_name 이름,
        emp.last_name 성,
        j.job_title 업무,
        avg(salary*12) ,
        emp.salary*12 연봉
FROM employees emp, departments dept, jobs j 
where dept.department_id = emp.department_id and
        emp.job_id = j.job_id
GROUP BY emp.employee_id,
        emp.first_name,
        emp.last_name,
        j.job_title,
        emp.salary*12     
ORDER BY emp.salary*12 desc;
        
SELECT emp.employee_id 사번,
             emp.first_name 이름,
             emp.salary 급여,
             dept.department_name 부서명,
             j.job_title 현재업무

FROM employees emp, departments dept, jobs j 
where dept.department_id = emp.department_id and
        emp.job_id = j.job_id
ORDER BY emp.employee_id asc;


/*문제8.
평균 급여(salary)가 가장 높은 부서는?*/

/*문제9.
평균 급여(salary)가 가장 높은 지역은?*/

/*문제10.
평균 급여(salary)가 가장 높은 업무는?*/