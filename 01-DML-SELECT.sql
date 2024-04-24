-- sql 문장의 주석
-- 마지막에 ; 세미콜론으로 끝난다
-- 키워드 ,테이블명 컬럼 등은 대소문자 구분x
-- 실제데이터의 경우 대소문자 구분o
--  VARCHAR2(25)  > 가변문자(길이가 가변적)

-- table 구조확인 > DESCRIBE 
DESCRIBE employees;
describe EMPLOYEES;
Describe Departments;
Describe Locations;

-- DML(Data Manipulation 
-- selcet

--  * : 테이블 내의 모든 컬럼을 Projection, 테이블 설계시에 정의한 순서대로 출력된다
SELECT * FROM employees;

-- 특정 컬럼만 Projection 하고자 하면 목록을 명시

-- employees 테이블의 first name Phone Number, Hire_date, salary 만 보고싶다면
SELECT first_name, phone_number , hire_date, salary FROM employees;


-- 사원의 이름,성,급여,전화번호,입사일 정보 출력
SELECT first_name, last_name, salary, phone_number, hire_date FROM employees;

-- 사원 정보로부터 사번,이름,성 정보 출력
SELECT employee_id, first_name, last_name FROM employees;

-- 산술연산 : 기본적인 산술연산을 수행 할 수 있다
SELECT 3.14159 * 10*10 FROM dual; -- 특정테이블의 값이 아닌 시스템으로 부터 데이터를 받아오고자 할때 : Dual(가상테이블)

-- NULL
-- 이름 급여 커미션 비율을 출력
SELECT first_name,salary, commission_pct FROM employees;

-- 이름 커미션을포함한 급여를 출력
SELECT first_name , salary, commission_pct, salary + salary *commission_pct  FROM employees; 
-- NULL이 포함된 연산식의 결과는 NULL
-- NULL을 처리하기 위한 함수
-- NVL(표현식1,표현식1이 NULL일 경우의 대체값

-- NVL함수 활용 대체값 계산
SELECT first_name, salary, commission_pct, salary+salary * NVL(commission_pct , 0)  FROM employees;

-- NULL은 0이나 공백문자와는 다르게 빈 값이다
-- NULL은 산술연산 결과 통계 결과를 왜곡이 생김 > NULL처리는 철저히 해야함


-- 특정 컬럼의 값을 산술 연산에 포함
SELECT first_name, salary, salary * 12 FROM employees;

-- 다음 문장을 실행해보자
SELECT first_name, job_id, job_id * 12 FROM employees; 
-- 위 코드 오류의 원인 : job_id는 문자열이다 (varchar)


---------------------------------------------------------------------------------------------------------------------------
-- 별칭 Alias : Projection 단계에서 출력용으로 표시되는 임시 컬럼제목
-- 컬럼명 뒤에 별칭을 붙이거나
-- 컬럼명 뒤에 as별칭
-- 표시명에 특수문자가 포함된경우 "" 으로 묶어서 부여

-- 직원id ,이름 , 급여를 출력 > (직원아이디: empNo) (이름 : f-name) (급여 : 월급)
SELECT employee_id empNo , first_name  as "f-name",  salary "월 급" FROM employees;

-- 직원이름 (First_name+Last_name) = name
-- 급여 (커미션이 포함된 급여) 급여*12 연봉 별칭으로 표기
SELECT first_name || ' ' || last_name "Full Name" , salary + salary * NVL(commission_pct , 0) "급 여(커미션 포함)", salary*12 연봉  FROM employees;

-- 연습문제
SELECT first_name || ' ' || last_name 이름, hire_date 입사일, phone_number 전화번호, salary 급여, salary*12 연봉 FROM employees;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- where 특정 조건을 기준으로 레코드를 선택(Selection)
-- 비교연산(=,<>, >=, <=,>,<)
-- 사원들중 급여가 15000 이상인 직원의 이름과 급여
SELECT first_name, salary FROM employees where salary>= 15000;

-- 입사일이 17/01/01 이후인 직원들의 이름과 입사일
SELECT first_name,hire_date FROM employees where hire_date  >= '17/01/01';
-- 급여가 14000 이하이거나 17000 이상인 사람의 이름과 급여
SELECT first_name, salary FROM employees where salary <= 14000  or salary >= 17000;
-- 급여가 14000 이상이고 17000 이하인 사원의 이름과 급여
SELECT first_name, salary FROM employees where salary >= 14000 and salary < 17000;

-- BETWEEN
SELECT first_name , salary FROM employees where salary BETWEEN 14000 and 17000;

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NULL 체크 : =, <> 사용불가
-- IS NULL , IS NOT NULL사용

-- COMMISSION을 받지않는 사람들 > commission_pct 가 null인 레코드
SELECT first_name , commission_pct FROM employees where commission_pct is null;  -- null체크

--COMMISSION을 받는 사람들 > commission_pct 가 null이 아닌 레코드
SELECT first_name , commission_pct FROM employees where commission_pct is not null; -- null이 아님을 체크
-- IN연산자 : 특정 집합의 요소와 비교
-- 사원들 중에서 10번 20번 40번 부서에서 근무하는 직원들의 이름과 부서아이디
SELECT first_name , department_id FROM employees where department_id = 10 or department_id= 20 or department_id=40;
-- IN 절 활용 : 특정집합의 요소와 비교
SELECT first_name , department_id FROM employees where department_id in( 10, 20, 40 );

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- LIKE 연산
-- wildcard : % , _ 를이용한 부분 문자열 매핑
-- %  : 0개 이상의 정해지지않은 문자열
-- _ : 1개의 정해지지 않은 문자

-- 이름에 an을 포함하고 있는 사원의 이름과 급여 출력
SELECT first_name , salary FROM employees where LOWER(first_name) LIKE '%an%';
-- 이름에 두번째 글자가 a인 사원의 이름과 급여
SELECT first_name , salary FROM employees  where LOWER(first_name) LIKE '_a%';

-- 이름에 네번쨰 글자가 a인 사원의 이름과 급여
SELECT first_name, salary FROM employees where LOWER(first_name) like '___a%';
-- 이름이 네글자인 사원들 중에서 두번째 글자가 a인 사원의 이름과 급여
SELECT first_name, salary FROM employees where LOWER(first_name) like '_a__';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 연습문제

-- 부서ID가 90인 사원중 급여가 20000 이상인 사원 이름과 급여
SELECT first_name , department_id , salary FROM employees where department_id = 90 and salary >= 20000;

-- 입사일이 07/01/01 - 07/12/31 구간에 있는 사원의 목록 
SELECT hire_date , first_name FROM employees where hire_date >= '11/01/01' and hire_date <= '17/12/31';
SELECT hire_date , first_name FROM employees where hire_date BETWEEN '11/01/01' and '17/12/31' ;

-- maneger_ID가 100 120 147인 사원의 명단 사원id 이름, maneger_ID
-- 1.비교연산자 + 논리연산자
SELECT employee_id ,first_name ,manager_id FROM employees where manager_id =100 OR manager_id =120 OR manager_id =147;
-- 2. IN연산자 
SELECT employee_id ,first_name ,manager_id FROM employees where manager_id in(100, 120, 147);

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ORDER BY
-- 부서번호를 오름차순(asc 오름차순 디폴트값)으로 정렬하고 부서번호 급여 이름을 출력
SELECT first_name , salary , department_id FROM employees order by department_id ;
-- 급여가 10000이상인 직원의 이름을 급여 내침차순 으로 출력
SELECT first_name , salary FROM employees  where salary >=10000  order by salary desc ;
-- 부서번호 급여 이름 순으로 출력하되 부서번호 오름차순 급여 내림차순
SELECT department_id ,salary ,first_name FROM employees  order by department_id , salary desc;
-- 정렬기준을 어떻게 세우느냐에 따라서 성능 출력결과에 영향을 미칠수있다

