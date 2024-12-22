-- 테이블 확인
SHOW TABLES;

-- 테이블 설명
DESC city;

-- 샘플 데이터(전체)
SELECT * FROM city;

-- city 테이블에서
-- name, Population 등 특정 컬러만 
-- 모든 데이터를 가져온다 
SELECT name, Population
            FROM city;
            
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
-- (24r x 5c)

-- 위의 쿼리문 기반으로 조건 변경
-- 인구수가 5백만 이상이고(AND),  6백만 이하인 
-- 도시의 모든 데이터 조회
SELECT *
FROM city
WHERE  city.Population >= 5000000 
	AND city.Population <= 6000000;


-- 인구수가 5598953이 아닌(!=, <>) 도시의 모든 개수를 구하시오
-- 개수는 count(*) 함수 사용, 별칭 부여 cnt
SELECT COUNT(*) AS cnt
FROM city
WHERE Population != 5598953;

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
-- 컬럼명 IN ('','','',...)
-- 값 표기 => '값'
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


-- 동일 요구사항, 단 District 컬럼값에 'New York'를 이용하여 구성
-- 주 정보를 이용하여 국가코드 획득 -> 해당국가의 모든 도시 정보 획득
SELECT *
FROM city
WHERE city.CountryCode=( 	SELECT CountryCode
								 	FROM city
									WHERE District='New York'
								);
-- 오류발생, 1개의 일치된 값을 요구하는 조건문에 N개의 값을 대입
-- 해결 : 서브쿼리 조정-> 결과가 1개만 나오게 처리 (의도는 아님)
-- 다른 방식 : ANY, SOME을 응용하여 처리가능


-- 서브쿼리를 FROM에 사용 -> n개의 결과셋을 대상으로 진행
-- 통상 별칭 부여 -> 결과셋의 이름부여
-- 컬럼을 나열할때 이름.컬럼명 표현하여 출처를 명확하게 명시
-- 최종 컬럼명 별칭.컬럼명
SELECT A.*
FROM (SELECT CountryCode, `NAME` AS city_nm
	 	FROM city
		WHERE District='New York') AS A


-- 뉴욕`주`인 데이터 대상으로 인구를 구한다
-- 해당 인구보다 크기만 하면, 특정 대상이 되어, 
-- 모든 도시 정보를 출력한다

-- 모든 데이터들중에 뉴욕`주`에 해당되는 인구수보다 크면 조회된다
SELECT *
FROM city
WHERE Population > ( SELECT Population
							FROM city
							WHERE District='New York'
						 );

-- ANY 적용
SELECT *
FROM city
WHERE Population > ANY ( SELECT Population
							FROM city
							WHERE District='New York'
						 );
-- 3782

SELECT *
FROM city
WHERE Population > SOME ( SELECT Population
							FROM city
							WHERE District='New York'
						 );
-- 3782
-- 결론:뉴욕주의 가장 작인 인구수를 가진 도시보다 크기만 하면 모두 대상이됨


-- IN 하고 같은 결과물
SELECT *
FROM city
WHERE Population = ANY ( SELECT Population
							FROM city
							WHERE District='New York'
						 );
						 
						 
-- ALL
-- 서브 쿼리의 결과 셋과 다 비교하여 모두 만족할때 대상이 됨
-- 가장 큰값보다 크면 모두 해당됨!!
SELECT *
FROM city
WHERE Population > ALL ( SELECT Population
							FROM city
							WHERE District='New York'
						 );
						 
						