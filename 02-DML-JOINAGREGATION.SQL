------------------------------------------------
-- 24.04.26
-- JOIN
-- employees , department 테이블
DESC employees;
DESC departments;

-- 카티젼 프로덕트
SELECT * FROM employees;    -- 107
SELECT * FROM departments;  -- 27
SELECT * 
FROM employees,departments;

-- Inner-join , Equi-join
SELECT *
FROM employees, departments
where employees.department_id = departments.department_id ; --106 department_id가 null인 직원 join에서 배제

-- alias를 이용한 원하는 필드의 Projection 
-- simple-join or Equi-join
SELECT first_name,
        emp.department_id,
        dept.department_id,
        department_name
FROM employees emp, departments dept
where emp.department_id = dept.department_id;

select *
FROM employees
where department_id is null; -- 178번 

SELECT emp.first_name,
        emp.departmnent_id,
        dept.department_id,
        dept.department_name
 FROM employees emp  JOIN departments dept USING(department_id); 

-----------------------------------------------------------------------------------

 -- Theta-Join
 -- join 조건이 =이 아닌 다른조건들
 -- 급여가 직군 평균 급여보다 낮은 직원들 목록
 SELECT emp.employee_id ,
        emp.first_name,
        emp.salary,
        emp.job_id,
        j.job_id,
        j.job_title
FROM employees emp JOIN jobs j
            ON emp.job_id = j.job_id
where emp.salary <= (j.min_salary + j.max_salary)/2;  

----------------------------------------------------------------------------

-- outer-Join
-- 조건을 만족하는 '짝'이없는 튜플도 NULL을 포함해서 결과출력에 참여시키는 방법
-- 모든결과를 표현할 테이블이 어느 쪽에 위치하는가에 따라서 LEFT,RIGHT,FULL. OUTER-JOIN으로 구분
-- Oracle SQL의 경우 NULL이 출력 되는 쪽에 '+'를 붙인다

-- LEFT OUTER JOIN
-- Oracle SQL
SELECT emp.first_name,
        emp.department_id,
        dept.department_id,
        department_name
FROM employees emp, departments dept
where emp.department_id = dept.department_id(+); -- null이 포함된 테이블쪽에 + 표시

SELECT *
FROM employees where department_id is null; -- kimberely > 부서에 소속되지 않음

-- ANSI SQL 명시적으로 JOIN 방법을 정한다
SELECT first_name,
        emp.department_id,
        dept.department_id,
        department_name
        FROM employees emp left outer join departments dept 
            on emp.department_id = dept.department_id;
--------------------------------------------------------------------------------
-- RIGHT OUTER JOIN

-- Oracle SQL
-- RIGHT 테이블의 모든 레코드가 출력 
SELECT first_name,
        emp.department_id,
        dept.department_id,
        department_name
FROM employees emp, departments dept
where emp.department_id(+) = dept.department_id;    -- department 테이블 레코드 전부를 출력에 참여 / 총122레코드

--ANSI SQL
SELECT first_name,
        emp.department_id,
        dept.department_id,
        department_name
FROM employees emp RIGHT OUTER JOIN departments dept
on emp.department_id = dept.department_id;

--------------------------------------------------------------------------------
-- FULL OUTER JOIN > ANSI SQL에서만 가능 오라클 불가
-- JOIN에 참여한 모든 테이블의 모든 레코드를 출력에 참여
-- 짝이 없는 레코드들은 null을 포함해서 출력에 참여시킨다
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp FULL OUTER JOIN departments dept
    on emp.department_id = dept.department_id;

----------------------------------------------------------------------------
-- NATURAL JOIN *주의* 
-- 조인할 테이블에 같은 이름의 컬림이 있을경우 해당 컬럼을 기준으로 조인
-- 실제 본인이 조인 할 조건과 일치하는지 확인
SELECT * FROM employees emp natural JOIN departments dept;
SELECT * FROM employees emp JOIN departments dept on emp.department_id = dept.department_id and emp.manager_id = dept.manager_id;

-----------------------------------------------------------------------------------
-- Self JOIN 자기 자신과 join
-- 자신을 두번 호출 > 별칭을 '반드시' 부여해야 할 필요가 있다
SELECT * FROM employees; --107명

SELECT emp.employee_id,
        emp.first_name,
        emp.manager_id,
        man.first_name
--FROM employees emp join employees man
--      on emp.manager_id = man.manager_id;
 
FROM employees emp, employees man
where emp.manager_id = man.employee_id;

-- 해보자 Steeven (매니저없는 분)까지 포함해서 출력

------------------------------------------------------------------------------------------
-- 24.04.29
-- 집계 : 여러 행으로부터 데이터를 수집 하나의 행으로 반환
-- COUNT : 갯수 세기 함수
-- employees 테이블의 총 레코드 갯수
SELECT count(*) FROM employees;

-- *로 카운트하면 모든 행의 수를 반환
-- 특정 컬럼 내 null값이 포함되어 있는지에 대한 여부는 중요하지않다

-- commission을 갖는 직원의 수를 알고싶을 경우
-- commission_pct 가 null인 경우를 제외하고 싶을경우
select count(commission_pct) FROM employees;
-- 컬럼내에 포함된 null 데이터를 카운트하지 않음
-- 위 커리는 아래 커리와 같다
SELECT count(*)FROM employees
where commission_pct is not null;

-- 합계함수 sum
-- 모든사원의 급여 합계
SELECT sum(salary) FROM employees;

-- 평균함수 avg
-- 사원의 평균 급여
SELECT avg(salary) FROM employees;

-- 사원들이 받는 평균 commission 비율의 평균
SELECT avg(commission_pct) FROM employees;

-- avg 함수는 null 값이 포함되어있는경우 그 값을 집계 수치에서 제외
-- null 값을 집계 결과에 포함시킬지 여부는 정책으로 결정하고 수행해야함
SELECT avg(nvl(commission_pct,0)) FROM employees;

--min / max함수 최소값/최대값
-- avg / median 산술평균 / 중앙값
SELECT min(salary) 최소급여,
        max(salary) 최대급여,
        avg(salary) 평균급여,
        median(salary) 급여중앙값
FROM employees;

-- 흔히 범하는 오류
-- 부서별로 평균 급여를 구하고자 할 때
SELECT department_id, avg(salary)
FROM employees;

SELECT avg(salary)
FROM employees;

SELECT department_id, salary
FROM employees
ORDER BY department_id;
        
-- GROUP BY
SELECT department_id, Round(avg(salary),2)
FROM employees
GROUP BY department_id      -- 집계를 위해 특정 컬럼을 기준으로 그룹핑
ORDER BY department_id;

-- 부서별 평균 급여에 부서명도 포함하여 출력
SELECT emp.department_id, dept.department_name, ROUND(avg(emp.salary),2)
FROM employees emp
    join departments dept
        on emp.department_id = dept.department_id
GROUP BY emp.department_id
ORDER BY emp.department_id; -- error : 그룹바이 절 이후에는 그룹바이에 참여한 컬럼과 집계함수만 남는다

SELECT emp.department_id , dept.department_name, ROUND(avg(emp.salary),2)
FROM employees emp
    join departments dept
        on emp.department_id = dept.department_id
GROUP BY emp.department_id , dept.department_name
ORDER BY emp.department_id;  -- 성공

-- 평균 급여가 7000달러 이상인 부서만 출력
SELECT department_id,
        avg(salary)
FROM employees
where avg(salary) > 7000
GROUP BY department_id
ORDER BY department_id; --error : where 절에서 아직 집계 함수가 시행되지 않은 상태 > 집계함수의 비교 불가

-- 집계함수 이후의 조건 비교 : Having 절을 이용
SELECT department_id,
        avg(salary)
FROM employees
GROUP BY department_id
    having avg(salary) >= 7000
ORDER BY department_id; -- 성공 / GROUP BY agregation의 조건 필터링

-- Rollup : GROUP BY절 과 함께 사용
-- 그룹지어진 결과에 대한 좀더 상세한 요약을 제공하는 기능 수행
-- 일종의 아이템토탈 
SELECT department_id,
        job_id,
        sum(salary)
FROM employees
GROUP BY ROLLUP(department_id, job_id);

-- cube : Cross Tap에 대한 summery를 함꼐 추출하는 함수
-- rollup 함수에 의해 출력되는 아이템토탈 값 과 함께 컬럼 토탈값을 함께 추출
SELECT department_id,
        job_id,
        sum(salary)
FROM employees
GROUP BY cube(department_id, job_id)
ORDER BY department_id;

--------------------------------------------------------------------------
-- SUBQUERY

-- 모든 직원급여의 중앙값보다 많은 급여를 받는 사원의 목록
-- 1. 직원급여의 중앙값? median
SELECT median(salary) FROM employees;   --6200
-- 2. 1번 결과보다 많은 급여를 받는 직원의목록?
SELECT first_name,
        salary
FROM employees
where salary >= 6200;
-- 1번과 2번 쿼리 합치기
SELECT first_name,
        salary
FROM employees
where salary >= (SELECT median(salary) FROM employees)
ORDER BY salary desc;

-- 수잔보다 늦게 입사한 사원의 정보
-- 1.수잔의 입사일
SELECT hire_date FROM employees where first_name = 'Susan'; -- 12/06/07
-- 2.1번의결과보다 늦게 입사한 사원의 정보
SELECT first_name,
        hire_date
FROM employees
where hire_date > '12/06/07';
-- 1,2번 합치기
SELECT first_name, hire_date
FROM employees
where hire_date > (SELECT hire_date FROM employees where first_name = 'Susan');

-- 연습문제
-- 급여를 모든 직원급여의 중앙값 보다 많이 받으면서 '수잔'보다 늦게 입사한직원의 목록
SELECT median(salary)FROM employees; --6200
SELECT first_name,salary,hire_date
FROM employees
where salary > (SELECT median(salary)FROM employees) and   -- 조건.1
        hire_date > (SELECT hire_date FROM employees where first_name = 'Susan') -- 조건.2
ORDER BY hire_date, salary desc;        

-------------------------------------------------------------------------------------------
-- 24.04.30
-- 다중행 서브쿼리 : 서브쿼리 결과가 둘 이상의 레코드일때 단일행 비교 연산자는 사용할수없다
-- 집합연산에 관련된 IN, ANY, ALL, EXISTS등을 사용해야 한다

------------------------- IN 연산자
-- 직원들 중 110번 부서 사람들이 받는 급여와 같은 급여를 받는 직원들의 목록
-- 1. 110번 부서 사람들의 급여는 얼마인가
SELECT first_name, salary FROM employees 
where department_id = 110; --12008, 8300

-- 2.직원 중 급여가 12008,8300인 직원의 목록
SELECT first_name,salary FROM employees 
where salary IN (12008,8300);
-- 3. 두쿼리를 하나로 합친다
SELECT first_name, salary FROM  employees
where salary IN(select salary FROM employees where department_id = 110);

---------------------- ALL 연산자(and 연산자)
-- 110번부서 사람들이 받는 급여보다 많은 급여를 받는 직원들의 목록
-- 1. 110번부서 직원들의 급여
select salary FROM employees where department_id = 110; 

-- 2. 1번쿼리 전체보다 많은 급여를 받는 직원들의 목록
select first_name, salary FROM employees where salary > ALL(12008,8300);

----------------------- ANY 연산자(or 연산자)
-- 110번 부서 사람들이 받는 급여중 하나보다 많은 급여를 받는 직원들의 목록
-- 1. 110번 부서 사람들이 받는 사람들의급여
select salary FROM employees where department_id = 110; 
-- 2. 1번 쿼리 중 하나보다 많은 급여를 받는 직원들의 목록
select first_name, salary FROM employees
where salary > ANY(12008,8300) -- 12008 > salary >= 8300
ORDER BY salary desc;


---------------------Correlated Query 연관쿼리
-- 바깥쪽 쿼리(Outer Query와 안쪽 쿼리(Inner Query)가 서로 연관된 쿼리
select first_name, salary, department_id
FROM employees outer
where salary > (select avg(salary) FROM employees where department_id = outer.department_id);

-- 외부쿼리 : 급여를 특정 값보다 많이 받는 직원의 이름과 급여, 부서아이디

-- 내부쿼리 : 특정 부서에 소속된 직원의 평균 급여

-- 자신이 속한 부서의 평균 급여보다 많이 받는 직원의 목록을 구하라는 의미
-- 외부쿼리가 내부쿼리에 영향을 미치고 내부쿼리 결과가 다시 외부쿼리에 영향을 미침

------------------------- 서브쿼리 연습
-- 각 부서별로 최고급여를 받는 사원의 목록 (조건절에서 서브쿼리 활용)
-- 1. 각부서별 최고급여를 뽑을수있는 쿼리
select department_id, max(salary) FROM employees
GROUP BY department_id;

-- 2. 1번쿼리에서 나온 department_id 와 max(salary)값을 이용해서 외부 쿼리를 작성
select department_id,employee_id, first_name, salary FROM employees
where (department_id,salary) IN(select department_id, max(salary) FROM employees
GROUP BY department_id)
ORDER BY department_id;

-- 각부서별로 최고 급여를 받는 사원의목록(서브쿼리를 이용 임시테이블 생성 > 테이블조인)
-- 1.각 부서의 최고 급여를 출력하는 쿼리를 생성
select department_id,max(salary) FROM employees
GROUP BY department_id;

-- 2.1번쿼리에서 생성한 임시테이블과 외부쿼리를 조인
select emp.department_id,
        emp.employee_id,
        emp.first_name,
        emp.salary
FROM employees emp, (select department_id,max(salary) salary FROM employees
                    GROUP BY department_id) sal
where emp.department_id = sal.department_id -- 조인 조건
AND emp.salary = sal.salary
ORDER BY emp.department_id;
-----------------------Top-k Query : Oracle에서만 가능
-- 질의의 결과로 부여된 가상 컬럼 rownum 값을 사용해서 쿼리 순서 반합
-- rownum 값을 활용해서 상위 k개의 값을 얻어오는 쿼리

-- 2017년 입사자 중에서 연봉순위 5위까지 출력
-- 1. 2017년 입사자
select* FROM employees
where hire_date LIKE '17%'
ORDER BY salary desc;

-- 2. 1번쿼리를 활용해서 rownum값까지 확인, rownum <= 5 이하인 레코드 > 상위 5개의 레코드
select rownum, first_name, salary 
FROM (select* FROM employees where hire_date LIKE '17%' ORDER BY salary desc)                                      
where rownum <= 5;

------------------집합연산
select first_name, salary, hire_date FROM employees where hire_date < '2015-01-01'; -- 15년 이전 입사자 레코드:24개
select first_name, salary, hire_date FROM employees where salary >12000; -- 12000초과 급여 받는 직원목록 레코드:8개

-- 합집합 : UNION > 중복 레코드는 한개로 취급
select first_name, salary, hire_date FROM employees where hire_date < '2015-01-01'
union
select first_name, salary, hire_date FROM employees where salary >12000
ORDER BY salary desc; -- 26개

-- 합집합2 : UNION ALL > 중복레코드는 별개로 취급
select first_name, salary, hire_date FROM employees where hire_date < '2015-01-01'
union all
select first_name, salary, hire_date FROM employees where salary >12000
ORDER BY salary desc; -- 32개

-- 교집합 : INTERSECT (Inner Join)과 같은결과
select first_name, salary, hire_date FROM employees where hire_date < '2015-01-01'
intersect
select first_name, salary, hire_date FROM employees where salary >12000
ORDER BY salary desc; -- 6개

-- 차집합 : MINUS
select first_name, salary, hire_date FROM employees where hire_date < '2015-01-01'
minus
select first_name, salary, hire_date FROM employees where salary >12000
ORDER BY salary desc; -- 18개

------------------------------RANK 관련함수 : Oracle 특화함수
select salary,first_name,
        RANK() OVER (ORDER BY salary desc) as rank, -- 일반적인 순위
        DENSE_RANK() OVER(ORDER BY salary desc) as dense_link, 
        ROW_NUMBER() OVER(ORDER BY salary desc) as row_number, -- 정렬했을때의 실제 행번호
        rownum  -- 쿼리 결과의 행번호(가상컬럼)
FROM employees;

---------------------------Hierarchical Query : 트리형태 구조 표현 > Oracle 특화
-- level 이라는 가상 컬럼 활용 쿼리
select level,employee_id, first_name, manager_id
FROM employees
start with manager_id is null  -- 트리 형태의 root(최상위)가 되는 조건명시
connect by prior employee_id = manager_id -- 상위 레벨과의 연결조건 (가지치기 조건)
ORDER BY level; -- 트리의 길이를 나타내는 Oracle 가상컬럼