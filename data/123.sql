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

-- city 테이블에서 
-- name, Population 컬럼만 조회하여
-- 모든 데이터를 가져오시오
SELECT name, Population
FROM city;

-- select_expression 자리에는 컬럼을 순서대로
-- 나열하면 결과를 원하는대로 가져올수 있다
-- 컬럼의 이름이 너무 길거나, 특정되지 않는다!!
-- 별칭 -> 결과셋의 컬럼명을 변경
-- 원본 이름 as 별칭
-- 컬럼명을 변조 -> 원본 테이블의 컬럼명 노출 방지(긍정)
SELECT NAME AS nm, 
Population AS popu
FROM city;


-- city 테이블에서
-- 이상,이하 (>=, <=), 초과,미만 (>, <)
-- 인구수가 5,000,000 이상(>=)이 되는 
-- 도시를 추출(조회)하시오 -> 모든 컬럼
-- 테이블명.컬럼명 자동완성됨 -> tool에서 제공
SELECT *
FROM city
WHERE city.Population >= 5000000;
-- (24c x 5c)

-- 위의 쿼리문 기반으로 조건 변경
-- 인구수가 5백만 이상이고(AND),  6백만 이하인 
-- 도시의 모든 데이터 조회
SELECT *
FROM city
WHERE city.population >= 5000000 AND city.population <= 6000000;