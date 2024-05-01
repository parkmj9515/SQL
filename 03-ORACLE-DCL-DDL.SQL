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