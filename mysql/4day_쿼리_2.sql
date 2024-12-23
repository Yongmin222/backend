-- 계정, 인증
-- 관련 디비
SHOW DATABASES;

-- 계정, 인증 관련 DB로 사용 설정 변경
USE mysql;

-- 사용자 확인
SELECT HOST, user, authentication_string
FROM user;

-- 실습1 = 계정 만들고 삭제하기
-- 1. 계정 생성 : 아이디만 부여
CREATE user guest1;

-- 2. 계정 확인
SELECT HOST, user, authentication_string FROM user;

-- 3. 계정 삭제
DROP user guest1;

-- 4. 계정 확인
SELECT HOST, user, authentication_string FROM user;

-- 실습2 - 아이디, 비번, host(접속위치) 넣어서 생성
-- 5. localhost 라는 것은 디비가 물리적으로 설치된  PC에서 접속하겠다!!
CREATE user guest1@localhost IDENTIFIED BY '1234';

-- 6. 계정 확인
SELECT HOST, user, authentication_string FROM user;

-- 7. 계정 삭제
DROP user guest1@localhost;

-- 실습3 - 아이디, 비번, host(접속위치):모든 곳에서 접근가능하게!!
-- 8. 원격 접속가능하게!! -> % <- 보안에 좋지 않음, 전세계 접근 가능함
CREATE user guest1@'%' IDENTIFIED BY '1234';

-- 9. 계정 확인
SELECT HOST, user, authentication_string FROM user;

-- 10. 세션 관리자에서 접근해봄
-- xxxx_sh... 디비만 보임, 접속은된다!!, 업무  x => 권한 부여 필요

-- 실습 4- 권한부여
GRANT [권한] ON [db].[테이블] TO [유저아이디]@[호스트]
-- 11. t1 디비에 모든 권한 부여!!
GRANT ALL PRIVILEGES ON t1.* TO 'guest1'@'%';

-- 12. 메모리 저장
FLUSH PRIVILEGES;

-- 13. 세션관리자 확인
-- guest1 / 1234 => t1 확인됨

-- 14. 권한 확인
SHOW GRANTS FOR guest1;

-- 15. 권한 삭제
-- 루트 권한에서만 승인됨 (작업)
REVOKE ALL PRIVILEGES ON t1.* FROM 'guest1'@'%';




