-- order by
-- city 테이블 대상
-- 모든 정보(데이터)를
-- `인구`순으로 오름차순(작은값 -> 큰값)  정렬한다
SELECT *
FROM city
ORDER BY  city.Population ;

SELECT *
FROM city
ORDER BY  city.Population ASC;

-- 내림차순 (큰값 -> 작은값)
SELECT *
FROM city
ORDER BY  city.Population DESC;


-- 정렬 조합 -> ,기준 열거
-- 위와 동일한 데이터를 요청
-- 인구는 내림차순, 국가코드는 오름차순 정렬
-- 인구는 내람차순-> 동일수치 -> 국가코드는 오름차순 정렬
SELECT *
FROM city
ORDER BY  city.Population DESC, city.CountryCode ASC;

-- 순서 변경하여 각각 정렬되었는지 체크
-- 명목(혹은 범주)형 데이터는 먼저 배체, 연속형(혹은 수치형) 차후 배치
SELECT *
FROM city
ORDER BY  city.CountryCode ASC, city.Population DESC;


-- 실습
-- city 테이블 대상
-- 한국 데이터만 대상, 도시명 오름차순, 인구 내림차순 정렬하시오
-- 모든 데이터를 보여준다
SELECT *
FROM city AS c
WHERE c.CountryCode='KOR'
ORDER BY  c.`Name` ASC, c.Population DESC;
-- 70개 데이터, 중요도에 따라 인구 혹은 도시명을 먼저 노출!!

-- country 테이블 대상
-- 국가 면적 순으로 정렬 (내림차순)
-- 국가명, 면적만 출력하시오
SELECT co.`Name`, co.SurfaceArea
FROM country AS co
ORDER BY co.SurfaceArea DESC;


-- 중복 데이터 제거
-- city 테이블 대상
-- 국가코드의 중복 제거하여, 유니크한 국가코드 결과셋을 구하시오
-- 유니크한 국가코드만 출력!!
SELECT DISTINCT city.CountryCode
FROM city;
-- 232개 코드 결과셋

-- country 테이블에서
-- 국가 면적 순으로 정렬 (내림차순) 결과물에서
-- 상위 10(탑 10)개만 출력
-- 국가명, 면적만 출력하시오
SELECT co.`Name`, co.SurfaceArea
FROM country AS co
ORDER BY co.SurfaceArea desc
LIMIT 10;
-- (10, 2)

-- 페이징 기능 삽입 (원하는 범위만 획득)
SELECT co.`Name`, co.SurfaceArea
FROM country AS co
ORDER BY co.SurfaceArea DESC
-- LIMIT 0, 10; -- 1page
LIMIT 10, 10; -- 2page
-- 페이지값 에 따른 제한값은 
-- 페이지번호 pno, 페이지수 N
-- limit (pno-1)*N, N


-- 집계
-- city 테이블 대상
-- 같은 국가 코드를 가진 데이터간 집계
-- GROUP BY CountryCode
-- 같은 그룹내에서 인구수가 가장 작은 값을 출력, 별칭 min_popu
-- 출력값은 국가코드, 최소인구수(도시별)
-- 최소인구수 기준오름차순 정렬
-- 탑 10 데이터만 획득

-- 일반적인 요구사항
-- 국가별 도시가 여러개 존재하는데, 
-- 국가별 가장 적은 인구수를 가진
-- 도시의 인구 및 국가코드를 출력하시오
-- 오름차순, 인구수는 min_popu, 상위 10개만 출력
SELECT c.CountryCode, MIN(c.Population) AS min_popu
FROM city AS c
GROUP BY c.CountryCode
ORDER BY min_popu ASC
LIMIT 10;

-- 국가코드, 국가별로 존재하는 도시들의 평균값 출력
-- 출력항목, 국가코드, 평균인구수(avg_popu)
-- 평균 인구 기준 내림차순 정렬
-- 4번째에서(0, 1, 2, (*)3) 10개만 출력
SELECT c.CountryCode, AVG(c.Population) AS avg_popu
FROM city AS c
GROUP BY c.CountryCode
ORDER BY avg_popu desc
LIMIT 3, 10;


-- 오류 발생 -> name은 집계의 대상도 아니고, 짒계처리된 내용 x
-- 출력 결과에 사용 불가!!
SELECT c.CountryCode, AVG(c.Population) AS avg_popu, c.`Name`
FROM city AS c
GROUP BY c.CountryCode




-- having 

-- 재료 : 국가별로 가장 큰 인구수를 가진 도시의 인구수와, 국가코드
-- 조회하여 출력, 인구별로 내림차순 정렬
SELECT c.CountryCode, MAX(c.Population) AS max_popu
FROM city AS c
GROUP BY c.CountryCode
ORDER BY max_popu DESC;

-- 위의 결과 집합에서 인구수가 9000000이상(>=)인 정보만 출력하시오
-- 서브쿼리로 해결 가능함!!
-- 오후 학습 정리시 시도
SELECT c.CountryCode, MAX(c.Population) AS max_popu
FROM city AS c
-- GROUP BY는 from을 대상으로 집계
GROUP BY c.CountryCode     
-- GROUP BY를 보고(1차 가공된 데이터)  조건 처리
HAVING max_popu >= 9000000 
ORDER BY max_popu DESC;

-- country 테이블에서
-- 대륙별(Contin...)로 집계, 면적 평균 획득 avg_surf
-- 대륙별값, 면적 평균 출력
-- 면적 기준 내림차순 정렬
-- 면적 평균이 1000000 이상인 데이터만 추출
SELECT co.Continent, AVG(co.SurfaceArea) AS avg_surf
FROM country AS co
GROUP BY co.Continent
HAVING avg_surf > 1000000
ORDER BY avg_surf DESC;


-- 위까지 완료된 분들은 면적이 100,000 이하인 국가는 제외하고
-- 동일하게 진행
SELECT co.Continent, AVG(co.SurfaceArea) AS avg_surf
FROM country AS co
-- country를 대상으로한 1차 조건
WHERE co.SurfaceArea > 100000
GROUP BY co.Continent
-- 집계된 데이터를  대상으로한 2차 조건
HAVING avg_surf > 1000000
ORDER BY avg_surf DESC;


-- 중간집계
-- city 테이블에서
-- 국가별, 도시별 인구수 집계
-- 집계된 데이터별 중간합계값(ROLLUP)을 데이터로 추가
-- 조건은 where도 관계 없음
SELECT c.CountryCode, c.`Name`, SUM(c.Population) AS sum_popu
FROM city AS c
-- 도시명은 중복된 데이터가 없다-> 결과셋에 포함시키기 위해
-- 집계에 포함시킴
-- 결과셋의 마지막에 중간집계값 포함되어 있음
GROUP BY c.CountryCode, c.`Name` with  ROLLUP
-- HAVING c.CountryCode='KOR';

-- 실습 : 오후학습 정리시 sum_popu값을 내림차순 기준으로 정렬




