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


-- 특정 컬럼의 값을 산술 연산에 포함
SELECT first_name, salary, salary * 12 FROM employees;

-- 다음 문장을 실행해보자
SELECT first_name, job_id, job_id * 12 FROM employees; 
-- 위 코드 오류의 원인 : job_id는 문자열이다 (varchar)
DESC employees; 