--24.05.03
---------------------------DB.OBJECT
-- SYSTEM으로 진행
-- VIEW 생성을 위한 SYSTEM 권한
GRANT create view TO himedia;

GRANT select on hr.employees to himedia;
GRANT select on hr.departments to himedia;

-- HIMEDIA 
-- view (논리적테이블)
-- simple view : 단일테이블,단일 뷰를 베이스로한 함수 연산식을 포함하지 않은 뷰

-- emp123
desc emp123;

-- emp123 테이블기반 department_id가 10번인 부서 소속 사원만 조회하는 뷰
create or replace view emp10
    as select employee_id,first_name,last_name,salary from emp123 
    where department_id = 10;

select * from tabs;
-- 일반 테이블처럼 활용 할 수 있다
desc emp10;
select * from emp10;
select first_name || ' ' || last_name 이름,salary from emp10;

--simple view : 제약 사항에 걸리지 않는다면 insert,update,delete 를 할수있다
update emp10 set salary = salary*2;
select * from emp10;

rollback;

-- 가급적 view 는 조회 용으로만 활용하자
-- with read only  읽기전용 뷰
create or replace view emp10
    as select employee_id, first_name, last_name, salary
    from emp123
    where department_id = 10
    with read only;
    
-- update emp10 set salary = salary*2; -- 읽기전용이라 갱신불가

---------------------------COMPLEX VIEW
-- 한 개 혹은 여러개의 테이블 혹은 뷰에 join 함수 연산식 등을 활용한 뷰
-- 특별한 경우가 아니면 INSERT UPDATE DELETE 작업 수행 불가
CREATE OR REPLACE VIEW emp_detail (employee_id, employee_name, manager_name, department_name)
    as select emp.employee_id,
                emp.first_name || '' || emp.last_name, 
                man.first_name || '' || man.last_name,
                department_name
FROM HR.employees emp 
        join HR.employees man on emp.manager_id = man.employee_id
        join HR.departments dept on emp.department_id = dept.department_id;
        
desc emp_detail;
select * from emp_detail;

-- VIEW 를 위한 딕셔너리 : VIEWS
SELECT * FROM USER_VIEWS;
SELECT * FROM USER_OBJECTS; -- VIEW 포함 모든 DB 객체들의 정보

-- VIEW 삭제 : DROP VIEW
-- VIEW 삭제해도 기반 테이블 데이터는 삭제되지 않음
DROP VIEW emp_detail;
select * from user_views;

-----------------------------INDEX
--HR.EMPLOYEES 테이블 복사 S_EMP 테이블 생성
CREATE TABLE s_emp
    as select * from hr.employees;
desc s_emp;
select * from s_emp;

-- s_emp 테이블의 employee_id에 unique index를 걸어봄
CREATE UNIQUE INDEX s_emp_id_pk
 on s_emp (employee_id);

-- 사용자가 가지고 있는 인덱스 확인
select * from USER_INDEXES;
-- 어느 인덱스가 어느 컬럼에 걸려있는지 확인
SELECT * FROM USER_IND_COLUMNS;
-- 어느 인덱스가 어느 컬럼에 걸려 있는지 JOIN해서 알아보자
SELECT t.INDEX_NAME, c.COLUMN_NAME, c.COLUMN_POSITION
FROM USER_INDEXES t
    JOIN USER_IND_COLUMNS c
        on t.INDEX_NAME = c.INDEX_NAME
WHERE t.TABLE_NAME = 's_emp'; 

--------------------------SEQUENCE
select * from author;

-- 새로운 레코드 추가 겹치지 않는 유일한 PK 필요
INSERT INTO author(author_id, author_name)
VALUES ((SELECT MAX(author_id)+1 FROM author), '이문열'); -- 

SELECT * FROM author;

rollback;

-- 순차 객체 SEQUENCE
CREATE SEQUENCE seq_author_id  
    start with 4
    increment by 1
    maxvalue 100000;
    
-- pk는 시퀀스 객체로부터 생성
INSERT INTO author(author_id, author_name, author_desc)
VALUES (seq_author_id.NEXTVAL, '스티븐 킹','쇼생크 탈출');

select * from author;

SELECT seq_author_id.currval FROM dual;

-- 새 시퀀스 생성
CREATE SEQUENCE my_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 10;
    
SELECT my_seq.NEXTVAL FROM dual;    -- 다음 시퀀스 추출 가상 컬럼
SELECT my_seq.CURRVAL FROM dual;    -- 시퀀스의 현재 상태

-- 시퀀스 수정
ALTER SEQUENCE my_seq
    INCREMENT BY 2
    MAXVALUE 1000000;
    
SELECT my_seq.CURRVAL FROM dual;
SELECT my_seq.NEXTVAL FROM dual;

-- 시퀀스를 위한 딕셔너리
SELECT * FROM USER_SEQUENCES;
SELECT  * FROM USER_OBJECTS WHERE OBJECT_TYPE = 'SEQUENCE';

-- 시퀀스 삭제
DROP SEQUENCE SEQ_PHONE_BOOK;
select * from user_sequences;

-- book table pk 현재 값 확인
SELECT book FROM book;


CREATE SEQUENCE seq_book_id
    START WITH 3
    INCREMENT BY 1
    MAXVALUE 1000000
    NOCACHE;

drop table book;
drop table author;




   
