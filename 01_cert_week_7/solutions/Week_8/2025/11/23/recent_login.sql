-- (MySQL)과제: 사용자별 ‘가장 최근 로그인일’을 기준으로 최근 14일 동안 로그인한 사용자 수를 날짜별로 집계하라.

-- 🔸 테이블 스키마
-- USERS(
--   user_id    INT PRIMARY KEY,
--   user_name  VARCHAR(100)
-- )

-- LOGIN_HISTORY(
--   log_id     INT PRIMARY KEY,
--   user_id    INT,           -- FK → USERS.user_id
--   login_date DATE           -- 로그인 일자
-- )

-- 🔸 요구사항
-- 각 사용자마다 가장 최근 로그인일(MAX(login_date))을 구한다.
-- 기준일은 CURDATE().
-- 최근 14일 동안 로그인한 사용자만 집계한다.
-- recent_login_date BETWEEN CURDATE() - INTERVAL 14 DAY AND CURDATE()
-- 날짜별로 집계한다:
-- login_date (가장 최근 로그인일)
-- user_count (그 날짜가 “해당 유저의 가장 최근 로그인일”인 사람 수)

-- 정렬:
-- login_date 오름차순

-- 🔸 샘플 데이터 예시
-- INSERT INTO USERS VALUES
--   (1,'Alice'),
--   (2,'Bob'),
--   (3,'Carol'),
--   (4,'Dave');

-- INSERT INTO LOGIN_HISTORY VALUES
--   (101,1,'2024-03-01'),
--   (102,1,'2024-03-10'),
--   (103,2,'2024-03-05'),
--   (104,2,'2024-03-07'),
--   (105,3,'2024-02-28'),
--   (106,3,'2024-03-15'),
--   (107,4,'2024-03-20');

-- → 이 데이터라면
-- Alice 최근 로그인: 3/10
-- Bob 최근 로그인: 3/07
-- Carol 최근 로그인: 3/15
-- Dave 최근 로그인: 3/20
-- …이런 식으로 나올 거고,
-- 그걸 14일 조건으로 걸러서 날짜별 인원을 세는 문제다.

-- 🙅‍♂️ 출력해야 하는 컬럼 (정답은 아님)
-- recent_login_date | user_count
-- --------------------------------
-- 2024-03-07        |   1
-- 2024-03-10        |   1
-- 2024-03-15        |   1
-- 2024-03-20        |   1


-- 논리적 한 줄 요약 : 사용자별 '가장 최근 로그인일'을 기준으로 최근 14일동안 로그인한 사용자 수를 구하여라.
-- 물리적 요약 :
-- 1. (USERS테이블의 user_id를 그룹화하여 Login테이블을 JOIN하여 MAX(date)를 이용한 가장 최근 로그인을 구한다.)
-- 이걸 윈도우 함수로 바꿔서 ranked_logins
-- 2. WHERE 조건절로 CURDATE()와 INTERVAL 14 DAY을 활용하여 최근 14일동안 로그인한 사용자 수를 구할 수 있다.

WITH ranked_logins AS(
    SELECT
        u.user_id,
        MAX(l.login_date) first_login_date
    FROM USERS u
    JOIN LOGIN_HISTORY l ON u.log_id = l.log_id,
    GROUP BY l.login_date, l.log_id
    ORDER BY l.login_date
)
SELECT l.login_date recent_login_date, COUNT(*) user_count
FROM LOGIN_HISTORY l
JOIN ranked_logins r ON l.log_id = r.log_id   -- 가장 최근일 기준 테이블
JOIN USERS u2 ON l.log_id = u2.log_id
WHERE r.first_login_date >= CURDATE() - INTERVAL 14 DAY
    AND r.first_login_date <= CURDATE()
GROUP BY l.login_date
ORDER BY l.login_date DESC;

-- 시간 : 14분
-- 오답 이유 :
-- GROUP BY가 완전 바보같음 유저별 최신 로그인일을 뽑는 건데 두 그룹을 묶어 로그인 행이 그대로 유지 됨
-- -> 이건 쿼리 문법이 이상해서 수정하는 과정에서 앞뒤없이 수정해서 그럼 여튼 답은 : GROUP BY user_id
-- 바깥쿼리의 JOIN 조건절도 잘못 되었다. USERS 테이블에 log_id는 없고, OUTER_SELECT에도 JOIN키가 틀림 user_id만 있을뿐
-- -> user_id로 통일
-- 잘한 점은 최근 14일을 무의식적으로 WHERE절에 넣었다는 것 집계쿼리가 아니라는 것을 알았음
-- -> 다만 날짜별 집계는 바깥 셀렉트에서 윈도우함수절의 recent_login_date를 가져와야 함 << 잘못 표기해서 first_login_date로 되어있지만 수정 필요

-- 복기 :
WITH ranked_logins( -- LOGIN_HISTORY 테이블에서 모두 해결됨
    SELECT
        user_id
        MAX(login_date) recent_login_date
    FROM LOGIN_HISTORY
    GROUP BY user_id
)
SELECT r.recent_login_date, COUNT(*) user_count
FROM LOGIN_HISTORY l
JOIN ranked_logins r ON l.user_id = r.user_id
JOIN ORDERS o ON l.user_id = o.user_id
WHERE r.recent_login_date >= CURDATE() - INTERVAL 14 DAY
AND r.recent_login_date <= CURDATE()
GROUP BY r.recent_login_date
ORDER BY r.recent_login_date DESC;  --> 사실 ASC가 맞음 문제에서... ogin_date 오름차순 끝까지 틀려

-- 복기 문제 한번더 풀어보고 감잡으면 될듯. 리뷰는 그때가서 함더