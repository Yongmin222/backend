-- DDL

-- create table ~ as select ~
-- city 테이블과 동일한 구조와 동일한 데이터를 가진 테이블  
-- city_copy 만드시오
CREATE TABLE city_copy 
AS SELECT * FROM city;

-- 카피된 테이블 확인
SELECT COUNT(*) FROM city_copy;

-- city_sub 테이블 생성
-- city 테이블 기반
-- 조건 : 국가코드 한국, 미국, 일본만 데이터로 카피<= IN
-- 컬럼 : 국가코드, 도시명, 인구수만 포함
-- city_sub 만드시오
CREATE TABLE city_sub
AS 
SELECT  c.CountryCode, c.`Name`, c.Population
FROM city AS c
WHERE c.CountryCode IN ('KOR','USA','JPN');

-- 확인
SELECT * FROM city_sub;


-- 데이터베이스 
-- 인코딩 utf8mb4_gerneral_ci <= 한글 정상적 처리
CREATE DATABASE A1;

SHOW DATABASES;

DROP DATABASE A1;

SHOW DATABASES;


-- 테이블 생성 코드
CREATE TABLE `guiusers` (
	`id` INT NOT NULL AUTO_INCREMENT COMMENT '회원고유번호',
	`uid` VARCHAR(32) NOT NULL COMMENT '회원고유아이디' COLLATE 'utf8mb4_general_ci',
	`upw` VARCHAR(256) NOT NULL COMMENT '비밀번호-암호화' COLLATE 'utf8mb4_general_ci',
	`age` TINYINT NULL DEFAULT NULL COMMENT '나이',
	`email` VARCHAR(128) NULL DEFAULT NULL COMMENT '이메일' COLLATE 'utf8mb4_general_ci',
	`regdate` TIMESTAMP NOT NULL DEFAULT (now()) COMMENT '가입일',
	
	
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `uid_upw` (`uid`, `upw`) USING BTREE
)
COMMENT='회원 테이블'
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;



-- 테이블 생성
-- 직접 작성 or  자바코드에서 자동 생성(SQL 몰라도 가능함)
-- 간단한 회원테이블
CREATE TABLE users (
	id INT NOT NULL PRIMARY KEY,
	uid VARCHAR(32) NOT NULL,
	upw VARCHAR(256) NOT NULL,
	age INT 	NULL,
	email VARCHAR(32) NULL,
	regdate TIMESTAMP NOT null
);
SHOW TABLES;

DESC users;


-- alter table
DESC users;

-- 컬럼 추가
ALTER TABLE users
ADD col INT NULL; 

DESC users;

-- 컬럼 수정
-- 유투브 -> 조회수 최대 5억뷰 -> 강남스타일 -> 오류발생 -> 타입 확장
-- 이미 데이터가 대량으로 존재함 -> 타입을 수정하는등 수정 조치!!
ALTER TABLE users
MODIFY col VARCHAR(128); -- 타입 변경 처리

DESC users;

-- 컬럼 삭제
-- 필요없는 컬럼 발생
ALTER TABLE users
DROP col;

DESC users;


-- index
-- 특정 테이블의 인덱스 정보 출력
-- primary key  지정=> 자동으로 btree 적용됨
SHOW INDEX FROM users;

-- 인덱스 생성 -> 검색 효율
CREATE INDEX uid_idx
ON users (uid); 

SHOW INDEX FROM users;

-- 중복을 허용하지(Unique) 않는 인덱스
CREATE UNIQUE INDEX email_idx
ON users (email);

-- 멀티 인덱스
-- 아래 케이스 => 로그인시 빠르게 결과나 나옴(상대적)
CREATE UNIQUE INDEX uid_upw_idx
ON users (uid, upw);

SHOW INDEX FROM users;

-- index 삭제
-- email_idx로 검색할 필요가 없다!!
ALTER TABLE users
DROP INDEX email_idx;

SHOW INDEX FROM users;

-- fulltext index 
-- 텍스트 검색시 유용 => 게시판에서 검색어 넣어서 검색시
-- 텍스트용 컬럼이 없어서 아이디에 임시 반영
ALTER TABLE users
ADD FULLTEXT uid_check (uid);

SHOW INDEX FROM users;


-- view 
-- 뷰 생성
-- city 테이블에서 한국 데이터만 가져와서 가상테이블 view로 생성
-- 왜? 가정 한국 도시 데이터를 주로 자주 사용하더라!!
-- 한국 도시 데이터를 가상 테이블로 생성 => 직접 사용
CREATE VIEW city_view
AS
SELECT city.`Name`, city.Population
FROM city
WHERE city.CountryCode='KOR';

-- city 테이블에서 한국 데이터만 가져와서 => view 사용
-- SQL 단계가 축소됨
SELECT *
FROM city_view;

-- city, country, countryLanguage 조인
-- test_all_data.sql 에는 ERD 파일이 없음
-- ERD 확인 -> 관계성 확인!!
-- city <-> country <-> countryLanguage
-- 조인 : 
  -- ERD 확인 : PK, FK 확인하여 조인 => ON ~ 
  -- ERD 부재시 : (동일한 컬럼|동일한 값) 이 존재하는가?
-- 오직 한국에 대한 정보만 뷰로 생성
-- where 국가코드='KOR'
-- 컬럼 : 도시명, 면적, 인구수, 랭귀지
-- select ~ 
-- 뷰의 이름은 total_kor_view
CREATE VIEW total_kor_view
AS
SELECT A.`Name`, B.SurfaceArea, A.Population, C.`Language`
FROM city AS A
JOIN country AS B ON A.CountryCode = B.`Code`
JOIN countrylanguage AS C ON A.CountryCode = C.CountryCode
WHERE A.CountryCode = 'KOR';

SELECT COUNT(*) FROM total_kor_view;



-- alter view
-- view 수정
-- city_view : 도시명, 인구수 : 교체전
-- city_view : 국가코드, 인구수 : 교체후
ALTER VIEW city_view
AS SELECT countrycode, population FROM city;

SELECT * FROM city_view;

-- drop view
-- view 삭제 -> 가상 테이블 삭제
-- 원본 테이블 데이터 보전됨
DROP VIEW city_view;









