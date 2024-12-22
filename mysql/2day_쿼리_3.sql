-- 조인
-- 대상 테이블 데이터(레코드)수 체크
-- city, country 대상
-- 각각 데이터의 개수 체크
SELECT COUNT(*) FROM city;		-- (4079,)
SELECT COUNT(*) FROM country;	-- (239,)

-- 각 테이블의 구조 체크 -> 중복(데이터기준)되는 컬럼 체크
DESC city;		-- CountryCode
DESC country;	-- Code
-- 위의 2개 테이블은 CountryCode와 Code의 값이 일치

-- 기본 조인
-- 2(n)개의 테이블을 결합하여 1개의 결과셋 획득
-- 왼쪽 테이블과 오른쪽 테이블 고려
-- 왼쪽에 city 배치, 오른족 country <= 가정
-- 조건 city의 CountryCode 와 country 의 Code가 일치하는 
-- 모든 레코드만 추출
SELECT *
-- 왼쪽 테이블
FROM city
-- 오른쪽에 어떤 테이블과 결합 묘사
JOIN country
-- 결합의 조건
ON city.CountryCode = country.`Code`;
-- (4079, 20)
-- 결과집합은 왼쪽 테이블의 데이터수보다 작거나 같다!! (특징)
-- 위의 *의 문제점 : 중복 데이터 등장, 컬럼명 중복 가능성 존재

-- 개선 -> 테이블명 별칭 처리 필요 -> 간결, 명확하게
SELECT *
FROM city AS A
JOIN country AS B
ON A.CountryCode = B.`Code`;


-- 개선 -> *이 아닌, 필요한 컬럼만 사용!!
-- 대륙, 국가, 도시, 면적, 인구 순서로 결과셋 획득
SELECT 
	B.Continent, 	
	A.CountryCode, 
	A.`Name`, 
	B.SurfaceArea, 
	A.Population
FROM city AS A
JOIN country AS B
ON A.CountryCode = B.`Code`;

-- countrylanguage 테이블 대상
-- 한국 기준 사용하는 언어 데이터 모두 획득
DESC countrylanguage;

SELECT *
FROM countrylanguage AS cl
WHERE cl.CountryCode='KOR';

SELECT *
FROM countrylanguage AS cl
WHERE cl.CountryCode='JPN';


-- 3개 테이블 조인
-- city, country, countrylanguage 순으로 조인
-- 국가 코드가 일치하는 조건으로 조인
-- 모든 데이터 조회
SELECT *
FROM city AS A
JOIN country AS B			  ON A.CountryCode = B.`Code`
JOIN countrylanguage AS C ON A.CountryCode = C.CountryCode;
-- (30670, 24)
-- city 데이터 4079개 였는데, countrylanguage가 국가별로
-- 사용언어가 여러개로 조회되는 관계로 => city 데이터수보다
-- 많게 결과가 나왔음!! -> 조인하는 테이블의 상황에 따라 상이해짐


-- car_order를 중심으로
-- car_orderdetail, car_product, car_store, car_member '조인'
-- 각 테이블별로 필요한 컬럼만 구성하여 => 구매 내역 데이터마트구성 => View
-- View -> 각종 데이터분석(파이썬, DB쿼리,..) ( 관리자쪽에서 진행)
-- 조인 기준 -> 구성 다음시간 체크
-- 중요: car_order의 데이터개수를 초과하면 않됨, 동일 개수 유지 : left join
SELECT A.*
	,B.prod_cd
	,B.quantity
	,C.price
	-- , 단가 * 총량 => 판매금액
	,C.brand
	,C.model
	,D.store_addr
	,E.gender
	,E.age
	,E.addr
	,E.join_date
FROM car_order AS A
left JOIN car_orderdetail 	AS B ON A.order_no = B.order_no
left JOIN car_product 		AS C ON B.prod_cd  = C.prod_cd
left JOIN car_store 			AS D ON A.store_cd = D.store_cd
left JOIN car_member 		AS E ON A.mem_no   = E.mem_no
;
-- (4176, 14) 
-- 이 데이터를 기반으로 추가 분석 쿼리 -> 마케팅 계획 수립!!

-- 기본 join == inner join => 교집합 중심
SELECT COUNT(*)
FROM city AS A
JOIN country AS B
ON A.CountryCode = B.`Code`;
-- 4079

SELECT COUNT(*)
FROM city AS A
inner JOIN country AS B
ON A.CountryCode = B.`Code`;
-- 4079

-- left join,왼쪽 테이블의 데이터는 유지!! (마스터 데이터 배치)
SELECT COUNT(*)
FROM city AS A
left JOIN country AS B
ON A.CountryCode = B.`Code`;
-- 4079

SELECT COUNT(*) FROM city;
-- 4079


-- 오른쪽 조인 -> 개수는 다른 결과로 나왔음(예측 잘 않됨)
-- right join
SELECT COUNT(*)
FROM city AS A
right JOIN country AS B
ON A.CountryCode = B.`Code`;
-- 4086, city와 숫자와 다름
SELECT COUNT(*) FROM country;

-- full join -> x
-- 대체제 : union or union all
SELECT *
FROM city AS A
left JOIN country AS B
ON A.CountryCode = B.`Code`

union

SELECT *
FROM city AS A
right JOIN country AS B
ON A.CountryCode = B.`Code`;
-- (4086, 20)


-- union, union all
-- A 집합
-- city 테이블 대상
-- 한국만 대상, 인구수 9000000 이상인 데이터에서
-- 도시명, 인구수 조회
SELECT c.`Name`, c.Population
FROM city AS c
WHERE c.CountryCode='KOR' AND c.Population>=9000000;
-- 1

-- B 집합
-- city 테이블 대상
-- 한국만 대상, 인구수 800000 이상인 데이터에서
-- 도시명, 인구수 조회
SELECT c.`Name`, c.Population
FROM city AS c
WHERE c.CountryCode='KOR' AND c.Population>=800000;
-- 8


-- A 집합 union b 집합
SELECT c.`Name`, c.Population
FROM city AS c
WHERE c.CountryCode='KOR' AND c.Population>=9000000
UNION
SELECT c.`Name`, c.Population
FROM city AS c
WHERE c.CountryCode='KOR' AND c.Population>=800000;
-- 8개 결과

-- A 집합 union all b 집합
-- 중복 제거 x
SELECT c.`Name`, c.Population
FROM city AS c
WHERE c.CountryCode='KOR' AND c.Population>=9000000
UNION all
SELECT c.`Name`, c.Population
FROM city AS c
WHERE c.CountryCode='KOR' AND c.Population>=800000;

