-- 데이터 직접 입력
-- users 테이블 대상
INSERT INTO users
-- 대상 컬럼 나열
-- 생략 가능 : 1. 자동 삽입( ex)id )되는 컬럼 2. null 허용 컬럼
( uid, upw, age, email, regdate) 
VALUES ( 'guest', '1234', '25', 'a@a.com', NOW());

SELECT * FROM users;

-- 중볷된 데이터가 존재 -> KEY 오류 발생
-- 이미 가입된 아이디가 잇다? 아이디가 중복된다!!
INSERT INTO users
( uid, upw, age, email, regdate) 
VALUES ( 'guest', '1234', '25', 'a@a.com', NOW());

-- uid에 대한 unique 처리가 않되 있어서 통과된다!! => 테이블 수정
-- uid unique 인텍스 처리 필요!! => 오전학습 정리때 시도
INSERT INTO users
( uid, upw, age, email, regdate) 
VALUES ( 'guest', '12345', '25', 'a@a.com', NOW());

-- 컬럼 파트는 생략 가능함 , 통째로 -> 데이터는 순서대로 배치해야함
-- 가급적 풀버전으로 sql 구성 => 관리상 유리
INSERT INTO users
VALUES ( 4, 'guest1', '12345', '35', 'b@b.com', NOW());

-- 멀티 데이터 밀어 넣기
-- 1개 이상 데이터 넣기
-- 데이터 파트를 , 구분하여 나열
INSERT INTO users
( uid, upw, age, email, regdate) 
VALUES 
	( 'guest5', '123450', '35', 'a1@a.com', NOW()),
	( 'guest6', '123451', '45', 'a2@a.com', NOW()),
	( 'guest7', '123452', '55', 'a3@a.com', NOW()) ;		


SELECT * FROM users;

-- 구조가 동일한 테이블이 있다면
-- 오전 학습 정리시 users 테이블과 동일한 구조의 users_copy 생성후
-- 아래 쿼리 실행!!
INSERT INTO users_copy SELECT * FROM users;



-- 회원 정보 수정
UPDATE users
SET email='c@c.com', age=age+5; -- 전제 수정

-- 5번 회원의 정보를 수정!!!
UPDATE users
SET email='d@d.com', age=age+5
WHERE id=5; -- 특정 대상만 수정

SELECT * FROM users;


-- 글삭제, 회원 탈퇴,..
DELETE FROM users
WHERE id=4;

-- 글-댓글, country-city
-- 기본키, 참조키 연관
-- 1:N(일대 다 개념)
-- 1개 국가에는 여러개의 도시가 존재한다, 부모대 자식 관계

-- 더미 테이블 - 국가
CREATE TABLE country2 (
	country_id INTEGER,
	NAME VARCHAR(64),
	population INTEGER,
	PRIMARY KEY (country_id)
);
-- 더미 데이터 추가
INSERT INTO country2
VALUES (1, '서울', 10000000),(2,'부산', 5000000); -- 멀티 데이터 입력

-- FK : FOREIGN KEY (외래키, 참조키)

FOREIGN KEY (컬럼)
REFERENCES 테이블명 (참조할컬럼명)
[ON DELETE CASCADE ] -- [] 생략가능,  
-- CASCADE : 국가데이터삭제->참조하는 모든 도시도 삭제

-- 더미 테이블 - 도시
CREATE TABLE city2 (
	city_id INTEGER,
	NAME VARCHAR(64),	
	country_id INTEGER,  -- country2 를 참조!! -> FK
	
	PRIMARY KEY (city_id),
	FOREIGN KEY (country_id) -- city2.country_id 임
	REFERENCES country2 (country_id)
	ON DELETE CASCADE -- 참조하는 데이터가 삭제되면 같이 모두 삭제된다!!
);

-- 도시(자치구) 더미 데이터 
INSERT INTO city2
VALUES 
	(1, '성북구', 1), -- (고유번호, 자치구명, 서울고유값(1))
	(2, '강남구', 1),
	(3, '부산진구', 2); -- (고유번호, 자치구명, 부산고유값(2))

SELECT * FROM country2;
SELECT * FROM city2;

-- 삭제 처리
-- 서울 삭제 -> 서울을 참조하고 있는 모든 자치구도 삭제
DELETE FROM country2 WHERE country_id=1;

-- 서울내 자치구는 모두 삭제되었고, 부산만 남았음
SELECT * FROM city2; 



-- 완전삭제
TRUNCATE TABLE city2;

SELECT * FROM city2;


-- 테이블 삭제
DROP TABLE city2;
DROP TABLE country2;
-- 데이터베이스 삭제
DROP DATABASES 디비명;
