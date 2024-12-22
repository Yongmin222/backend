-- 함수 -  문자열
SELECT LENGTH('hi');
SELECT LENGTH('HI');
SELECT LENGTH('가나다'); -- 한글은 3byte 길이
SELECT LENGTH('12');
SELECT LENGTH('!@');

-- city 테이블에서
-- 도시명, 도시명의 길이 출력 -> 별칭으로  size 
-- 도시명의 길이순으로 내림차순 정렬
-- 상위 5개만 출력
SELECT c.`Name`, LENGTH(c.`Name`) AS size
FROM city AS c
ORDER BY size DESC
LIMIT 5;
