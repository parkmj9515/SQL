-- 24.05.01
-- DCL AND DDL
-- 사용자 생성 > Create USER 권한이 있어야 함
-- system 계쩡으로 수행
-- connect system/manager

-- himedia라는 이름의 계정을 만들고 비밀번호 himedia로 설정
CREATE USER himedia IDENTIFIED himedia; -- 불가
-- Oracle 18버전부터 container Database 개념 도입
-- 방법1. 사용자 계정 c##
CREATE USER C##HIMEDIA IDENTIFIED BY himedia;

-- 비밀번호 변경 : ALTER USER
ALTER USER C##HIMEDIA IDENTIFIED BY new_password;

-- 계정삭제 : DROP USER
DROP USER C##HIMEDIA CASCADE; -- CASCADE : 폭포수 or 연결된 것 의미(스키마 등)

-- 사용자 생성 방법.2 : CD(ContainDatabase)기능 무력화
-- 연습상태 방법.2를 사용해서 사용자 생성(추천하지않음)
ALTER SESSION SET "_ORACLE_SCRIPT" = true;
CREATE USER himedia IDENTIFIED BY himedia;
-- 접속불가상태
-- 데이터베이스 접속,테이블 생성, 데이터베이스 객체 작업을 수행 > connect, resource ROLE
GRANT CONNECT, RESOURCE TO himedia;
-- cmd sqlplus himedia/himedia
-- CREATE TABLE test(a NUMBER);
-- DESC test; > 테이블 test의 구조보기

-- himedia 사용자로 진행
-- 데이터 추가
DESCRIBE test;
INSERT INTO test VALUES(2024); -- 테이블 스페이스 : 실제데이터가 저장되는 공간
-- USERS 테이블 스페이스에 대한 접근 권한이 없다 
-- Oracle 18이상 
-- System계정
ALTER USER himedia DEFAULT TABLESPACE USERS
QUOTA unlimited on USERS; -- tablespace권한 부여
-- himedia로 복귀
insert into test values(2024);
select * FROM test;
SELECT * FROM USER_USERS; -- 현재 로그인한 사용자 정보
SELECT * FROM ALL_USERS; -- 모든 사용자 정보
-- DBA 전용(sysdba 로 로그인 해야 확인 가능)
-- cmd > sqlplus > sys/oracle as sysdba -> sysdba 접속 가능(초기비번없음)
SELECT * FROM DBA_USERS; 


-- 시나리오 : HR 스키마의 employees table 조회 권한 > himedia에게 부여 하고자한다
-- hr스키마의 owner > hr
-- hr로 접속
GRANT select on employees TO himedia;

select * FROM hr.employees; -- hr.employees에 select 할수있는 권한
select * FROM hr.departments; -- hr.departments 권한은없다 (찾을수없음)

-- 현재 사용자에게 부여된 ROLE의 확인
select * FROM user_role_privs;
-- connect 와 resource 역할은 어떤 권한으로 구성되어 있나
-- sysdba로 진행 : cmd > sqlplus sys/oracle as sysdba
-- desc role_sys_privs;
-- connect 롤에는 어떤 권한이 포함되어 있나
-- SELECT PRIVILEGE FROM ROLE_SYS_PRIVS WHERE ROLE='CONNECT';
-- RESOURCE 롤에는 어떤 권한이 포함 되어 있나
-- SELECT PRIVILEGE FROM ROLE_SYS_PRIVS WHERE ROLE='RESOURCE';


--------------------------------DDL
-- 스키마 내의 모든 테이블을 확인
select * FROM tabs; -- taps: table 정보 dictionary
-- 테이블 생성 : Create Table
CREATE TABLE book (
    book_id number(5),
    title VARCHAR2(50),
    author varchar2(10),
    pub_date DATE DEFAULT sysdate);
-- 테이블 정보 확인
DESC book;

-- subquery를 이용한 테이블 생성
select * FROM hr.employees;
-- hr.employees 테이블에서 job_id가 'IT' 관련된 직원들의 목록으로 새 테이블 생성
select * FROM hr.employees where job_id LIKE 'IT_%';
CREATE TABLE emp_it AS ( select * FROM hr.employees where job_id LIKE 'IT_%'); -- not null 제약 조건만 물려받음
SELECT * FROM tabs;
desc emp_IT;

-- DB 테이블 삭제 : DROP
DROP TABLE emp_it;
-- 삭제 확인
select * FROM tabs;

Desc book;

----------------------------------------------------------------------
--24.05.02
-- author 테이블 생성
CREATE TABLE author (author_id number(10),
                    author_name varchar(100) not null,
                    author_desc varchar(500),
                    primary key (author_id));
-- author table 확인        
desc author;

-- book table에 author 컬럼 삭제
-- 나중에 author_id 컬럼추가 >author.author_id와 참조 연결할 예정
ALTER TABLE book DROP COLUMN author;
DESC book

-- 테이블에 author_id 컬럼 추가
-- author.author_id를 참조하는 컬럼 author.author_id 컬럼과 같은 형태여야 한다
ALTER TABLE book ADD (author_id NUMBER(10));
desc book;

-- book 테이블의 book_id도 author 테이블의 pk와 같은 데이터타입인 NUMBER(10)으로 변경
ALTER TABLE book MODIFY (book_id NUMBER(10));;
DESC book;

-- book테이블의 book_id 컬럼에 primary key 제약조건을 부여
ALTER TABLE book
ADD CONSTRAINT pk_book_id PRIMARY KEY (book_id);
DESC book;

-- book 테이블의 author_id 컬럼과 author 테이블의 author)id를 rx로 연결
ALTER TABLE book
ADD CONSTRAINT fk_author_id
FOREIGN KEY (author_id)
REFERENCES author(author_id);
DESC book;

-- DICTIONARY 

-- USER_ : 현재 로그인된 사용자에게 허용된 뷰
-- ALL_ : 모든 사용자 뷰
-- DBA_ : DBA에게 허용된 뷰

-- 모든 DICTIONARY 확인
--SELECT * FROM DICTIONARY;

-- 사용자 스키마 객체 : USER_OBJECTS
SELECT * FROM USER_OBJECTS;
-- 사용자 스키마의 이름과 타입 정보 출력
SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS;

-- 제약조건의 확인
SELECT * FROM USER_CONSTRAINTS;
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE,SEARCH_CONDITION,TABLE_NAME FROM USER_CONSTRAINTS;

-- BOOK 테이블에 적용된 제약조건의 확인
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE,SEARCH_CONDITION FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'BOOK';

----------------------------------------INSERT

-- INSERT : 테이블에 새 레코드(튜플) 추가
-- 제공된 컬럼 목록의 순서와 타입,값 목록의 순서와 타입이 일치해야 함
-- 컬럼 목록을 제공하지 않으면 테이블 생성시 정의된 컬럼의 순서와 타입을 따른다

-- 컬럼 목록이 제시되지 않았을 때
INSERT INTO author values(1,'박경리','토지 작가');

-- 컬럼 목록을 제시했을 경우 > 제시한 컬럼의 순서와 타입대로 값 목록을 제공해야 한다
INSERT INTO author (author_id,author_name) values(2,'김영하');

-- 컬럼 목록을 제공했을때, 테이블 생성시 정의된 컬럼의 순서와 상관없이 데이터 제공 가능
INSERT INTO author (AUTHOR_NAME,AUTHOR_ID,AUTHOR_DESC) values('류츠신', 3 ,'삼체 작가');

ALTER TABLE author RENAME COLUMN AUTHOR_NAME TO author_name;

ROLLBACK; -- 반영취소
SELECT * FROM author;


INSERT INTO author values(1,'박경리','토지 작가');
insert INTO author ( author_id,author_name) values(2,'김영하');
INSERT INTO author (author_name,author_id,author_desc) values('류츠신',3,'삼체 작가');

select * FROM author;

COMMIT; -- 변경사항 반영

SELECT * FROM author;

----------------------------------UPDATE + WHERE
-- 특정 레코드의 컬럼 값을 변경한다
-- where 절이 없으면 모든 레코드가 변경
-- 가급적 where 절로 변경하고자 하는 레코드를 지정하도록함
UPDATE author set author_desc = '알쓸신잡 출연';
select * from author; --> 3개의 DESC값 다 변경되었음

ROLLBACK;

SELECT * FROM AUTHOR;

UPDATE author set author_desc = '알쓸신잡 출연'
WHERE author_name = '김영하';
select * from author;

commit;


--------------DELETE + WHERE
-- 테이블로부터 특정 레코드를 삭제
-- WHERE 절이 없으면 모든 레코드 삭제 *주의

-- 연습
-- HR.EMPLOYEES 테이블을 기반으로 department_id(10,20,30)인 직원들만 새 테이블 emp123으로 생성
CREATE TABLE emp123 as (select * FROM hr.employees
                        where department_id IN(10,20,30));
                        
desc emp123;
select first_name,salary,department_id FROM emp123;

-- 부서가 30번인 직원들의 급여를 10% 인상
UPDATE emp123 set salary = salary + salary * 0.1
where department_id = 30;
select * from emp123;

-- job_id = MK로 시작하는 직원을 삭제
DELETE FROM emp123 where job_id LIKE 'MK_%';
select * from emp123;

DELETE FROM emp123;     -- where 절이 생략된 DELETE문 > 모든 레코드를 삭제 -> 주의
select * from emp123;
ROLLBACK;       
select * from emp123;

------------------------------Transaction
-- 트랜잭션 테스트 테이블
CREATE TABLE t_test(log_text VARCHAR2(100));

-- 첫번째 DML이 수행된 시점에서 Transaction
INSERT INTO t_test VALUES('트랜잭션 시작');
SELECT * FROM t_test;
INSERT INTO t_test VALUES('데이터 INSERT');
SELECT * FROM t_test;

SAVEPOINT sp1; -- savepoint 설정

INSERT INTO t_test VALUES('데이터 2 INSERT');
SELECT * FROM t_test;

SAVEPOINT sp2;

UPDATE t_test SET log_text = '업데이트';

SELECT * FROM t_test;
ROLLBACK sp1; -- sp1 세이브포인트로 귀환
SELECT * FROM t_test;

INSERT INTO t_test VALUES('데이터 3 INSERT');
SELECT * FROM t_test;

-- 반영은 COMMIT or 취소:ROLLBACK
-- 명시적으로 Transaction 종료
COMMIT;
SELECT * FROM t_test;

--------------------------------------------------------------------------
--24.05.08
delete from author;
commit;
select * from author;
desc book;

-- LIST
select author_id,author_name,author_desc FROM author;

select * FROM author;
select * FROM employees;
SELECT first_name || ' ' || last_name, email, phone_number, hire_date  FROM employees WHERE lower(first_name) Like '&' or lower(last_name) Like '%';
