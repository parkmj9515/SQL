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
author_name varchar(100) not null,
author_desc varchar(500)
 );

desc author;
-- 테이블 생성정보
show create table author;

-- 북테이블 생성
create table book (
				book_id int primary key,
                title varchar(100) not null,
                pubs varchar(100) null,
                pub_date datetime default now(),
                author_id int,
                constraint fk_book foreign key (author_id)
                references author(author_id)
                );
                show tables;
                desc book;
-- insert 새로운 레코드 삽입
-- 묵시적 방법 : 컬럼목록을 제공하지 않는다 > 선언된 컬럼의 순서대로 
insert into author values(1,'박경리','토지작가');

-- 명시적 방법 : 컬럼 목록 제공, 컬럼 목록의 숫자 순서 데이터타입이 값 목록의 숫자 순서 데이터타입과 일치 해야한다
insert into author(author_id,author_name) values (2,'김영하');
select * from author;

-- MYSQL은 기본적으로 자동 커밋이 활성화
-- auto 커밋을 비활성화 > auto commit 옵션을 0으로 설정
set autocommit =0;

-- mysql은 명시적으로 트랜잭션을 수행
start transaction;
select*FRom author;

-- update author set author_desc = '알쓸신잡 출연'; -- where 절이 없으면 전체 레코드 변경 mysql이 자체적으로 막음
update author set author_desc = '알쓸신잡 출연' where author_id = 2;
select * from author;
-- rollback; --변경사항 반영 취소
commit; -- 변경사항 영구 반영

-- auto_increment 속성 : 연속된 순차정보, 주로 pk속성에 사용
-- author 테이블의 pk에 auto_increment 속성 부여
alter table author modify author_id int auto_increment primary key;

-- 1. 외래 키 정보 확인
select * from information_schema.key_column_usage;
select constraint_name from information_schema.key_column_usage where table_name = 'book';

-- 2. 외래 키 삭제 : 삭제를 해야 기존 프라이머리 키 삭제가능 > book테이블의 fk( fk_book)
alter table book drop foreign key fk_book;

-- 3. author의 pk에 auto_increment속성 부여 
-- > 기존 pk를 삭제 
alter table author drop primary key;
-- auto increment 속성이 부여된 새로운 primary key 생성
alter table author modify author_id int auto_increment primary key;

-- 4. book의 author_id에 fk 다시 연결
alter table book add constraint fk_book foreign key (author_id) references author(author_id);

-- auto commit을 다시
set autocommit = 1;

select * from author;

-- 새로운 auto_increment값을 부여하기 위해 pk 최댓값을 구함
select max(author_id) from author;

-- 새로 생성되는 auto_increment 시작 값을 변경
alter table author auto_increment = 3; -- 3번 부터 시작
desc author;

insert into author(author_name) values('스티븐 킹');
insert into author(author_name , author_desc) values('류츠신','삼체 작가');
select * from author;

-- 테이블 생성시 auto_increment 속성 부여하는 방법
drop table book cascade;
create table book (
				book_id int auto_increment primary key,
				title varchar(100) not null,
				pubs varchar(100),
				pub_date datetime default now(),
				author_id int,
				constraint book_fk foreign key (author_id) references author(author_id));
insert into book (title, pub_date, author_id) value ('토지','1994-03-04',1);
insert into book (title, author_id) value ('살인자의 기억법',2);
insert into book (title, author_id) value ('쇼생크 탈출',3);
insert into book (title, author_id) value ('삼체',4);

select * from book;

-- JOIN
select title 제목, pub_date 출판일, author_name 저자명, author_desc '저자 상세'
from book b join author a on a.author_id = b.author_id;