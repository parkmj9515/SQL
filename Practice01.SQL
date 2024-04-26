-- Practice
--1번문제
--1.입사일 올림차순 2.이름 월급 전화번호 입사일순서 3. 이름 월급 전화번호 입사일로 컬럼명 변경
SELECT first_name 이름,
        salary 월급,
        phone_number 전화번호,
        hire_date 입사일
FROM employees
ORDER BY hire_date;--ASC생략가능

-- 2번문제
-- 1.정렬은 입사일의 올림차순 2. 이름(fn,ln)월급 전번 입사일 순서 3. 이름 월급 전번 입사일로 컬럼명 변경
SELECT first_name || ' ' || last_name 이름,
        salary 월급,
        phone_number 전화번호,
        hire_date 입사일       
FROM employees
ORDER BY hire_date; 

--3번 문제
-- 업무별로 업무이름 최고월급을 월급의 내림차순으로 정렬
SELECT job_title 업무이름,
        max_salary 월급
FROM jobs
ORDER BY max_salary desc;

--4번
-- 매니저가 배정 되었지만 커미션비율 x 월급 > 3000 직원이름 매니저아이디 커미션비율 월급
SELECT first_name 직원이름,
        manager_id 매니저아이디,
        commission_pct 커미션비율,
        salary 월급  
FROM employees
where   manager_id is not null and 
        commission_pct is null and
        salary >3000 ;

-- 5번
-- 최고월급이 10000이상인 업무의 이름과 최고월급을 내림차순(월급순)
SELECT JOB_TITLE 업무이름,
        MAX_SALARY 최고월급
        
FROM JOBS
WHERE MAX_SALARY >= 10000
ORDER BY MAX_SALARY DESC;

--6번
-- 월급 14000미만 10000이상인 직원의 이름 월급 커미션퍼센트를 내림차순(월급) 
-- 커미션이 null이면 0으로 표시
SELECT first_name 이름,
        salary 월급,
        nvl(commission_pct,0) 커미션퍼센트
FROM employees
where salary < 14000 and salary >= 10000
ORDER BY salary;

--7번
-- 부서번호 10 90 100인 직원의 이름 월급 입사일 부서번호
-- 입사일은 1977-12와 같이 표시
SELECT first_name 이름,
        salary 월급,
TO_CHAR(hire_date,'YYYY-MM') 입사일,
        department_id 부서번호
FROM employees
where department_id in(10,90,100);

-- or연산자
SELECT first_name 이름,
        salary 월급,
TO_CHAR(hire_date,'YYYY-MM') 입사일,
        department_id 부서번호
FROM employees
where department_id=10 or
        department_id= 90 or
        department_id = 100;
    

-- 8번
-- 이름에 S 또는 s 가 들어가는 직원의 이름 월급
SELECT first_name 이름,
        salary 월급 
FROM employees  
where LOWER(first_name) LIKE '%S%' or LOWER(first_name) LIKE '%s%';
-- first_name like '%S%' or first_name like '%s%';
-- 9번
-- 부서명이 긴순서대로 출력
SELECT department_name 부서명
FROM departments
ORDER BY LENGTH(department_name)desc;

--10번
-- 대문자로 바꿔서 출력
SELECT  UPPER(country_name) 나라이름
FROM COUNTRIES
ORDER BY UPPER(country_name);

--11번
-- 입사일이 13/12/31.일 이전 입사한 직원 이름,월급,번호,입사일출력
-- 전번 333-333-3333 같은형태
SELECT first_name 이름,
        salary 월급,
        REPLACE(substr(phone_number,3),'.','-') 전화번호,
        hire_date 입사일
FROM employees
where hire_date < '13.12.31'
ORDER BY hire_date;
        
