/*직원들의 사번(employee_id), 이름(firt_name), 성(last_name)과 부서명(department_name)을
조회하여 부서이름(department_name) 오름차순, 사번(employee_id) 내림차순 으로 정렬하세
요.
(106건)*/
-- simple join
SELECT emp.employee_id,
        emp.first_name,
        emp.last_name,
        dept.department_name
        FROM employees emp ,departments dept
          where emp.department_id = dept.department_id
 ORDER BY dept.department_name asc, emp.employee_id desc;    
 
 -- ANSI : join의 의도를 명확하게 하고 조인 조건과 selection 조건을 분리하는 효과
 SELECT emp.employee_id,
        emp.first_name,
        emp.last_name,
        dept.department_name
FROM  employees emp -- 중심 테이블
        JOIN departments dept
        on emp.department_id = dept.department_id
ORDER BY dept.department_name, emp.employee_id desc;
---------------------------------------------------------------------------
/* 2.employees 테이블의 job_id는 현재의 업무아이디를 가지고 있습니다.
직원들의 사번(employee_id), 이름(firt_name), 급여(salary), 부서명(department_name), 현
재업무(job_title)를 사번(employee_id) 오름차순 으로 정렬하세요.
부서가 없는 Kimberely(사번 178)은 표시하지 않습니다.*/

-- simple join
SELECT emp.employee_id 사번,
             emp.first_name 이름,
             emp.salary 급여,
             dept.department_name 부서명,
             j.job_title 현재업무

FROM employees emp, departments dept, jobs j 
where dept.department_id = emp.department_id and
        emp.job_id = j.job_id
ORDER BY emp.employee_id asc;

-- ANSI JOIN
SELECT emp.employee_id 사번,
             emp.first_name 이름,
             emp.salary 급여,
             dept.department_name 부서명,
             j.job_title 현재업무
FROM employees emp  -- 중심 테이블
    join departments dept
        on emp.department_id = dept.department_id -- emp 테이블과 dept 테이블 join조건
    join jobs j
        on emp.job_id = j.job_id
ORDER BY emp.employee_id asc;            

--2-1.문제2에서 부서가 없는 Kimberely(사번 178)까지 표시해 보세요   
-- SELECT* FROM employees where department_id is null;
SELECT emp.employee_id 사번,
        emp.first_name 이름,
        emp.salary 급여,
        dept.department_name 부서명,
        j.job_title 현재업무
FROM employees emp, departments dept, jobs j
where emp.department_id = dept.department_id(+) -- null이 포함된 테이블에 '+'
        and emp.job_id = j.job_id
ORDER BY emp.employee_id asc;        

-- ANSI JOIN
SELECT emp.employee_id 사번,
             emp.first_name 이름,
             emp.salary 급여,
             dept.department_name 부서명,
             j.job_title 현재업무
FROM employees emp  -- 중심 테이블
    left outer join departments dept
        on emp.department_id = dept.department_id -- emp 테이블과 dept 테이블 join조건
    join jobs j
        on emp.job_id = j.job_id
ORDER BY emp.employee_id asc; 
 
 
/* 3.도시별로 위치한 부서들을 파악하려고 합니다.
도시아이디, 도시명, 부서명, 부서아이디를 도시아이디(오름차순)로 정렬하여 출력하세요
부서가 없는 도시는 표시하지 않습니다. */

-- ANSI JOIN
select loc.location_id 도시아이디,
        loc.city 도시명,
        dept.department_name 부서명,
        dept.department_id 부서아이디
FROm locations loc JOIN departments dept
    ON loc.location_id = dept.location_id
ORDER BY loc.location_id asc;
    
--3-1 문제3에서 부서가 없는 도시도 표시합니다. 
select loc.location_id 도시아이디,
        loc.city 도시명,
        dept.department_name 부서명,
        dept.department_id 부서아이디
FROm locations loc left outer JOIN departments dept
    ON loc.location_id = dept.location_id
ORDER BY loc.location_id asc;

/* 4.지역(regions)에 속한 나라들을 지역이름(region_name), 나라이름(country_name)으로 출력하
되 지역이름(오름차순), 나라이름(내림차순) 으로 정렬하세요.*/

SELECT re.region_name 지역명,
        co.country_name 나라이름
FROM regions re --중심테이블
join countries co
on re.region_id = co.region_id
ORDER BY re.region_name asc, co.country_name desc;

/* 5.자신의 매니저보다 채용일(hire_date)이 빠른 사원의
사번(employee_id), 이름(first_name)과 채용일(hire_date), 매니저이름(first_name), 매니저입
사일(hire_date)을 조회하세요. */

--self join 별칭필수
SELECT emp.employee_id 사원아이디,
        emp.first_name 이름,
        emp.hire_date 입사일,
        man.first_name 매니저이름,
        man.hire_date "매니저 입사일"
FROM employees emp  join employees man   
    on emp.manager_id = man.employee_id -- join연결 조건
where emp.hire_date < man.hire_date;   -- selcetion 조건 

/*문제6.
나라별로 어떠한 부서들이 위치하고 있는지 파악하려고 합니다.
나라명, 나라아이디, 도시명, 도시아이디, 부서명, 부서아이디를 나라명(오름차순)로 정렬하여
출력하세요.
값이 없는 경우 표시하지 않습니다.(27건)*/

SELECT cou.country_name 나라명,
        cou.country_id 나라아이디,
        loc.city 도시명,
        loc.location_id 도시아이디,
        dept.department_name 부서명,
        dept.departmnet_id 부서아이디
FROM countries cou 
    join locations loc
        on cou.country_id = loc.country_id
    join departments dept
        on loc.location_id = dept.location_id
ORDER BY cou.country_name asc;

/*문제7.
job_history 테이블은 과거의 담당업무의 데이터를 가지고 있다.
과거의 업무아이디(job_id)가 ‘AC_ACCOUNT’로 근무한 사원의 사번, 이름(풀네임), 업무아이
디, 시작일, 종료일을 출력하세요.
이름은 first_name과 last_name을 합쳐 출력합니다.(2건) */

SELECT  emp.employee_id 사번,
        emp.first_name || ' ' || last_name 이름,
        jh.job_id 업무아이디,
        jh.start_date 시작일,
        jh.end_date 종료일
        
FROM employees emp
      join job_history jh
          on emp.employee_id = jh.employee_id  --join 조건
where j.job_id = "AC_ACCOUNT";

/*문제8.
각 부서(department)에 대해서 부서번호(department_id), 부서이름(department_name),
매니저(manager)의 이름(first_name), 위치(locations)한 도시(city), 나라(countries)의 이름
(countries_name) 그리고 지역구분(regions)의 이름(resion_name)까지 전부 출력해 보세요.
(11건)*/        
SELECT dept.department_id 부서번호,
        dept.department_name 부서명,
        man.first_name 매니저이름,
        loc.city 위치한도시,
        cou.country_name 나라이름,
        reg.region_name 지역
        
FROM departments dept
    join employees man on dept.manager_id = man.employee_id
    join locations loc on dept.location_id = loc.location_id
    join countries cou on loc.country_id = cou.country_id
    join regions reg on cou.country_id = reg.region_id
ORDER BY dept.department_id asc; 

/* 문제9.
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

        
          
