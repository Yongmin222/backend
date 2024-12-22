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
WHERE  city.Population >= 5000000 
AND city.Population <= 6000000;

-- 인구수가 5598953이 아닌(!=, <>) 도시의 모든 개수를 구하시오
-- 개수는 count(*) 함수 사용, 별칭 부여 cnt
SELECT
FROM city
WHERE population != 5598953;
SELECT COUNT(*) AS cnt

FROM city
WHERE Population <> 5598953;
-- 전체는 4,079개, 조건부여 4,078개     

-- city 테이블에서
-- 국가코드(CountryCode)가 KOR 혹은(OR) USA인 데이터를
-- 모두 가져오시오
SELECT *
FROM city
WHERE city.CountryCode='KOR' OR CountryCode='USA';

-- 한국의 도시들중 AND 인구수가 백만이상인 도시 데이터만
-- 모두 조회하시오
SELECT *
FROM city
WHERE city.CountryCode='KOR' AND city.Population>=1000000;
-- 0.016초

SELECT *
FROM city
WHERE city.Population>=1000000 AND city.CountryCode='KOR';
-- 0.000초

-- 조건식의 배치 순서에 따라 처리 속도가 다름!!

-- city 테이블에서
-- 모든데이터를 가져온다
-- 단, 인구수가 5백만이상, 6백만 이하인 도시만 해당된다
-- 5000000 <= 인구수 <= 6000000
SELECT *
FROM city
WHERE city.Population BETWEEN 5000000 AND 6000000;


-- 도시 이름이 서울, 부산, 인천인 경우 -> IN
-- 모든 데이터 조회하여 출력하시오
-- 컬러명 IN ('', '', '',...)
-- 값 표기 => '값;
SELECT *
FROM city
WHERE NAME IN('seoul','pusan','inchon');

-- 한국(KOR), 미국(USA), 일본(JPN), 프랑스(FRA) 도시를대상
-- 모든 데이터 총 수를 구하시오, 별칭은 cnt
SELECT COUNT(*) AS cnt
FROM city
WHERE city.CountryCode IN ('KOR','USA','JPN','FRA');
-- 632


-- 한국(KOR), 미국(USA), 일본(JPN), 프랑스(FRA) 도시를대상
-- 이중 인구수가 6백만 이상(>=)인 도시 => AND로 연결
-- 도시명, 인구수만 출력하시오
SELECT `NAME`, Population
FROM city
WHERE  city.CountryCode IN ('KOR','USA','JPN','FRA')
   AND city.Population >= 6000000;
-- 3


-- 프랑스에 존재하는 모든 도시 정보를 출력하시오
-- 조건- 국가 코드를 모른다!!
-- paris라는 도시명은 알고 있다!!
-- 해결 => paris를 이용하여 프랑스 국가코드를 획득 
--      => 위의 결과를 이용하여 <-'프랑스' <-'모든 도시 정보 획득'
-- (서브 쿼리->결과값 1개인가(where) n개 인가(from)?)
  SELECT *
  FROM city
  WHERE city.CountryCode=( 	SELECT CountryCode
	                           FROM city
	                           WHERE `NAME`='paris'
                                  );
  -- 서브쿼리 결과 FRA -> 1개의 결과
