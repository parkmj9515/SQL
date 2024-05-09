-- MYSQL은 사용자와 DataBase를 구분하는 DBMS
show databases;

-- 데이터베이스 사용 선언alter
use sakila;

-- 데이터베이스 내에 어떤 테이블이 있는가?
show tables;
-- 테이블 구조 확인
describe actor;

-- 간단한 쿼리 실행
select version(), current_date;
select version(), current_date FROM dual;

-- 특정 테이블 데이터를 조회할때
select * from actor;

-- 데이터베이스 생성
-- webdb 데이터베이스 생성
create database webdb;

-- 시스템 설정에 좌우되는 경우 많음
drop database webdb;

-- 문자셋, 정렬 방식을 명시적으로 지정하는 것이 좋다
create DATABASE webdb charset utf8mb4
	collate utf8mb4_unicode_ci;
show databases;

-- 사용자 만들기
create user 'dev'@'localhost'identified BY 'dev';
-- 사용자 비밀번호 변경
-- alter user 'dev'@'localhost'identified BY 'new_password';
-- 사용자 삭제
-- drop user 'dev'@'localhost';

-- 권한 부여
-- grant 권한목록 on 객체 to '계정'@'접속호스트';
grant all privileges on webdb.* to 'dev'@'localhost';
-- 권한 회수
-- revoke 권한목록 on 객체 from '계정'@'접속호스트';
-- 'dev'@'localhost'에게 webdb 데이터베이스의 모든 객체에 대한 권한 허용
-- revoke all privileges on webdb.* from 'dev'@'localhost';

-- 데이터베이스 확인
show databases;
use webdb;
-- author 테이블 생성
create table author;
create table author (
author_id int primary key,
author_name varchar(50) not null,
author_desc varchar(500) );

desc author;
-- 테이블 생성정보
show create table author;
