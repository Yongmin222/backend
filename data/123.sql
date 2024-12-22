--데이터베이스 상에 존재하는 모든 테이블 조회
SHOW TABLES;

-- city라는 테이블에서 => 출처
-- 모든 데이터를 => 모든(*) 컬럼
-- 가져(조회)오시오
-- 문장의 끝 => ; 반드시 붙임
-- 결과셋 : (4079, 5)
SELECT *
FROM city;
-- * : 사용 가급적 금지!!
-- 반드시 조건 사용!! -> 모두 가져오기 x

SELECT name
FROM city2

SELECT NAME, population
FROM city2;