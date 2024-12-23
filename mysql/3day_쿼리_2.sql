-- 형변환 함수
-- cast() 함수
-- 문자 -> 수치
-- UNSIGNED 부호가 없는 수치 => 양수
SELECT '123', CAST('123' AS UNSIGNED);

-- 문자|숫자 -> 날짜
SELECT CAST('20241218' AS DATE); -- 2024-12-18
SELECT CAST(20241218 AS DATE); -- 2024-12-18

-- 숫자 -> 문자
SELECT CONVERT(457398348, CHAR);


-- 홍콩 면적을 기준으로 '홍콩보다 작은 면적', '홍콩보다 큰면적(>=)'
-- 대상 country 테이블 대상
-- 새로운 컬럼 sf_band
-- 출력값  code, name, 면적, sf_band 출력
-- 기존 데이터를 기반으로 새로운 컬럼 생성!! 
-- -> case -when ~ then ~ else ~ end

-- 홍콩의 국가코드는 HKG
SELECT
	co.`Code`, co.`Name`, co.SurfaceArea,
	
	case
	-- when 조건식 then '값1' 
	-- when co.SurfaceArea < 홍콩의면적  then '홍콩보다 작은 면적' 
	when co.SurfaceArea < (
		-- 서브 쿼리를 조건식에 사용 -> 값이 1개 or 값이 n개(ANY,SOME, ALL)
		SELECT SurfaceArea FROM country WHERE CODE='HKG'
	)  then '홍콩보다 작은 면적' 
	ELSE '홍콩보다 큰면적' END
	AS sf_band
	
FROM country AS co;

-- case when => 컬럼추가(파생변수) 
-- =>집계(group by) => 통계 => 시각화(대시보드)
SELECT
	co.`Code`, co.`Name`, co.SurfaceArea,
	case
	when co.SurfaceArea < (
		SELECT SurfaceArea FROM country WHERE CODE='HKG'
	)  then '홍콩보다 작은 면적' 
	ELSE '홍콩보다 큰면적' END
	AS sf_band
FROM country AS co;

-- car_member 테이블 대상
-- age_band라는 컬럼 동적 추가
-- 해당 컬럼은 age 컬럼보고 판단
-- 20대미만(<20), 20대(20~29), 30대, 40대, 50대, 60대이상(60~)
-- 출력, car_member 모든 컬럼 + age_band 로 출력
-- 실습 5분 - 고객 데이터를 기반으로 연령대별로 분류(군집(그룹)해라)
SELECT *,
	case
	when cm.age < 20 then '20대미만' 
	when cm.age BETWEEN 20 AND 29 then '20대' 
	when cm.age BETWEEN 30 AND 39 then '30대' 
	when cm.age BETWEEN 40 AND 49 then '40대' 
	when cm.age BETWEEN 50 AND 59 then '50대'
	ELSE '60대이상' END
	AS age_band
FROM car_member AS cm;


-- like
SELECT *
FROM (
	SELECT *,
		case
		when cm.age < 20 then '20대미만' 
		when cm.age BETWEEN 20 AND 29 then '20대' 
		when cm.age BETWEEN 30 AND 39 then '30대' 
		when cm.age BETWEEN 40 AND 49 then '40대' 
		when cm.age BETWEEN 50 AND 59 then '50대'
		ELSE '60대이상' END
		AS age_band
	FROM car_member AS cm
) AS A
-- 조건에서 like 사용
-- WHERE A.age_band LIKE '20대%'; -- "20대"로 시작하는데이터를 모두추출
-- WHERE A.age_band LIKE '%이상'; -- "이상" 으로 끝나는 모든 데이터 추출
WHERE A.age_band LIKE '%이%'; -- 위치에 상관없이 "이"있기만 하면됨(검색)


-- 랭킹
-- 자동차 주문 날짜 <- 오름차순 정렬후
SELECT co.mem_no, co.order_date
	,ROW_NUMBER() OVER (ORDER BY co.order_date ASC) AS RANK1
	,RANK()       OVER (ORDER BY co.order_date ASC) AS RANK2
	,DENSE_RANK() OVER (ORDER BY co.order_date ASC) AS RANK3
FROM car_order AS co;





