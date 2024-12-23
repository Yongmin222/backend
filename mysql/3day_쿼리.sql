-- 도커 클라이언트 가동
-- 컨테이너에서 mysql 재생버튼 클릭
-- 하이디sql 접속

-- t1 데이터베이스 사용
USE t1;

-- 수치형 데이터의 길이?
-- 길이 계산의 대상은 문자열, 수치형 관계 없다
SELECT c.name,  c.population, LENGTH(c.population) AS size
FROM city AS c;


-- 기본 결합
-- 값을 필요한 만큼 나열
SELECT CONCAT('hello', '-', 'world');

-- null이 존재하면 모두 null
SELECT CONCAT('hello', null, 'world');

-- 실제 테이블에서 적용
-- 형식 : "도시명-인구수" 결과셋으로 나오는 결과 요청
-- 컬러명 spec으로 지정
SELECT CONCAT(c.`Name`, '-', c.Population) AS spec
FROM city AS c;


-- 위치 체크
-- 맨앞 1
SELECT LOCATE('w','world');

SELECT LOCATE('or','world');

-- 없으면 0
SELECT LOCATE('z','world');

-- 특정 게시물, 말뭉치(텍스트덩어리)에서 검색어가 존재하는지 체크

-- 절차 1
-- 도시명, "se"의 위치값(loc) 표현하는 쿼리 구성!!
SELECT c.`Name`, LOCATE( 'se', c.`Name` ) AS loc
FROM city AS c


-- city 테이블에서
-- 도시이름이 se로 시작하는 모든 도시들을 찾아서
-- 위치값이 1<= 위치값 <4 : 1, 2, 3 만 해당
-- 해당 데이터들은 모두 오름차순 정렬
-- 출력값 도시명, 위치값(loc)
-- SQL 구성하시오

-- 서브 쿼리 사용 -> 결과셋을 이용하여 요구사항 구현
-- 서브 쿼리를 테이블에 배치 -> 별칭부여(필수) -> 기본 조회
SELECT *
FROM (
	SELECT c.`Name`, LOCATE( 'se', c.`Name` ) AS loc
	FROM city AS c
) AS A
-- 조건 부여 실습
-- 위치값이 1<= 위치값 <4 : 1, 2, 3 만 해당
-- 해당 데이터들은 모두 오름차순 정렬 (위치값 기준)
WHERE 0 < A.loc AND A.loc < 4
ORDER BY A.loc ASC;

-- 똑같은 결과시도
-- 서브쿼리 x
-- 조건 변경 : 1<= loc <=2
-- 조건표현시 사용 : BETWEEN ~ AND ~

-- where 사용시 연산으로 의해 동적으로 만들어진(가공후) 컬럼 인지 x
-- where에서 막히면(동적 컬럼 원인) -> 서브쿼리 or having
SELECT c.`Name`, LOCATE( 'se', c.`Name` ) AS loc
FROM city AS c
-- WHERE loc BETWEEN 1 AND 2
HAVING loc BETWEEN 1 AND 2
ORDER BY loc ASC;



-- left(), right()

-- 왼쪽 기준 3개
SELECT LEFT('hello world', 3);

-- 오른 쪽 기준 3개
SELECT RIGHT('hello world', 3);

-- 테이블에 적용
-- 문자열, 수치형 -> 모두OK
SELECT
	LEFT(c.`Name`, 2), c.`Name`, RIGHT(c.`Name`, 3), -- 문자열
	LEFT(c.Population, 2), c.Population, 
	RIGHT(c.Population, 3) -- 수치형	
FROM city AS c;

-- 소문자, 대문자 변환
-- 오직 알파벳문자만 대상 처리됨
SELECT LOWER('abAB12가나!@');
SELECT UPPER('abAB12가나!@');

-- 테이블 컬럼에서 적용
SELECT NAME, LOWER(NAME), UPPER(NAME)
FROM city;


-- 원본데이터기준 특정 문자열을 다른 문자열로 교체
SELECT REPLACE('abAB12가나!@', 'bAB', '-비ab-');

-- 수치형 적용
-- 1780000 => 178****
SELECT city.Population, REPLACE(city.Population, '0', '*')
FROM city;


-- 공백제거, 특정 문자 제거
SELECT TRIM('     ab   cd    ') -- 좌우 공백 제거 OK
,TRIM('    ab') -- 앞쪽 공백 제거
,TRIM('ab    ') -- 뒤쪽 공백 제거
-- 대상 문자열에서 @ 제거
-- 시작문자, 끝문자 중요-연속성중요
,TRIM(LEADING '@' FROM '@@@ A @@@') 
,TRIM(TRAILING '@' FROM '@@@ A @@@')
,TRIM(BOTH '@' FROM '@@@ A @@@') 
,TRIM(BOTH '@' FROM '[@@@ A @@@]')
;

-- 테이블 적용
-- 대소문자 구분
SELECT c.name, TRIM(LEADING 'S' from c.`Name`)
FROM city AS c
WHERE c.CountryCode='kor';

-- 포멧
-- FORMAT( 수치형 데이터, 소수부 자리수 지정)
-- 정수부는 무조건 3자리 단위로 , 삽입
-- 소수부는 자리수에 맞춰서 남김 -> 반올림 처리
SELECT FORMAT( 234234343423.2455432432, 3), -- xxxx.246
       FORMAT( 234234343423.2423432432, 4);

-- 테이블 적용
-- 1780000 => 1,780,000 문자열로 처리해서 표현
SELECT city.Population, FORMAT( city.Population, 0)
FROM city;

-- 문자열 자르기, left:왼쪽기준, right:오른쪽기준, 
-- substring():원하는 위치에서 자르기
-- 위치 정보는 1부터 출발
-- SUBSTRING(타겟문자열, 시작위치, 길이)
SELECT SUBSTRING('ABCDEFG', 2, 3);

-- 포멧팅된 로그 잘라서 추출, 문자열 분할처리 유용


-- 수학 함수
-- 부동소수 데이터를 정수로 변환->정보손실 동반함
SELECT 
	FLOOR(3.95), -- 내림
	CEIL(3.95),  -- 올림
	CEIL(3.11),  -- 올림
	ROUND(3.5),	 -- 반올림
	ROUND(3.4);  -- 반올림

SELECT
	CEILING(1.56); -- 올림과 유사, 큰값쪽으로 지향하는 의미
	
	
-- 수학 계산
-- 참고
-- 데이터가 특정구간에 밀집해 있다면 => 데이터 흐트러 놔야 한다
-- LOG()를 이용하여 데이터를 분산시켜서 분석 => 결론 => exp() 원복
SELECT
	SQRT(4), -- 루트 처리
	POW(2,3), -- 2*2*2 => 2의 3제곱근, 거급제곱
	EXP(3), -- e^3, e의 3 거듭제곱
	LOG( EXP(3) ) ;  -- EXP() <-> 역함수 <-> LOG()
	
-- 삼각함수
-- 거리계산시 사용 !! 데이터가 GPS존재한다면
-- 두 지점의 직선거리 계산시 유용
SELECT PI(), 
	SIN( PI()/2 ),
	COS( PI() ),
	TAN( PI()/4 );
	

-- 절대값, 난수
-- 0.0 <= RAND() <= 1.0
SELECT
	ABS(-1), -- 절대값 => 양으로 표현!!
	ABS(1),
	RAND();

-- 난수 응용, 0<= 난수 <=10 구현하시오 -> 정수!!
-- 0.0*10 <= RAND()*10 <= 1.0*10
-- 0.0 <= RAND() <= 10.0
-- 반올림으로 임의로 정수  처리
SELECT ROUND(RAND()*10, 0);
-- 임의값에 의해서 이벤트, 추첨 
-- => 주의 (확률 세팅) => 프로그램에서 해결
-- 간단하게 난수로 값들 조정할때 사용

-- 표준편차, 분산()
-- 데이터가 얼마나 서로 떨어져 있는가?
-- 데이터 분포를 파악, 설명하는 용도 => 분석분야
SELECT STD(city.Population)
FROM city


-- car_product 테이블
-- price 컬럼에서 ,를 제거(replace)하여 price_int 라는 컬럼 생성
-- 모든컬럼, price_int 이렇게 출력되게 구성
SELECT
	COUNT( price_int ) AS 주문수,
	SUM( price_int ) AS 주문금액합산,
	AVG( price_int ) AS 주문금액평균,
	STD( price_int ) AS 주문금액표준편차
FROM (
	SELECT 
		*, 
		REPLACE( price, ',', '') AS price_int
	FROM car_product
) AS A
-- ( 48, 6 )


-- yyyymmdd hhmmss 정보 각각 획득
SELECT NOW(), CURDATE(), CURTIME();

-- 시간값 자를수 있는가?
SELECT left(CURDATE(), 4);
-- 활용용도 -> 회원(쇼핑몰) -> 가입일, 수정일, 탈퇴일, 구매시간
-- 고객 분류 -> 마케팅, 서비스등제공, 고객등급결정 
-- 가입월일 계산 : (현재시간 - 가입시간) => 월(주,년)로 환산

-- 세부적인 시간 정보
SELECT NOW(),
	YEAR(   NOW() ), 
	DATE(   NOW() ),
	MONTH(  NOW() ),
	DAY(    NOW() ),
	HOUR(   NOW() ),
	MINUTE( NOW() ),
	SECOND( NOW() );
	
-- 기타 정보 -> 월의 이름, 요일의 이름
-- 시간 -> 요일 -> 주간 매출 분석 -> 어떤 요일에 ...
SELECT NOW(), 
	MONTHNAME( NOW() ),
	DAYNAME( NOW() );	

-- 기타 정보, 주간, 월간, 년간 단위 현재 시간의 위치
SELECT NOW(),
	DAYOFWEEK(  NOW() ),
	DAYOFMONTH( NOW() ),
	DAYOFYEAR(  NOW() );
	
-- 포멧 -> 시간의 형식을 자유롭게 구성!!
SELECT DATE_FORMAT( NOW(), '%D %y %s %d %m %j' );
-- 일 : %D, %d
-- 년 : %y
-- 초 : %s
-- 월 : %m
-- DAYOFYEAR : %j

-- 가장 많이 사용!! -> 시간 차이 계산!!
-- 시간차이 => ex) 가입한지 몇일 되었지?
-- ex) 2024/12/3 - 대통령 취임일  = 1000
-- DATEDIFF( 시간, 상대적으로 과거 ) => 양수로 나온다
-- 양으로 표현 => ABS(), 무조건양수
SELECT 
	-- 만약 시간의 양(일수만 체크하고 싶다면) -> 무조건 양수
	ABS(DATEDIFF( NOW(), '2024-12-01')), -- 과거시간
	ABS(DATEDIFF( NOW(), '2024-12-20')), -- 미래시간
	ABS(DATEDIFF( '2024-12-20' , NOW())); -- 미래시간
	
-- 시간 기입은 직접 가능 (형식 일치해야함)
SELECT ABS(DATEDIFF( '2024-12-01', '2024-12-18'));

	