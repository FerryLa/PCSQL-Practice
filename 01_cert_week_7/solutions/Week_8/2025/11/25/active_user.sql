-- (MySQL) 연습 과제: 최근 7일 기준, 활성(‘ACTIVE’) 구독 상태인 사용자 수를 날짜별로 집계하라
-- 🔸 테이블 스키마
-- USERS(
--   user_id    INT PRIMARY KEY,
--   user_name  VARCHAR(100),
--   joined_at  DATE
-- )

-- SUBSCRIPTION_HISTORY(
--   history_id   INT PRIMARY KEY,
--   user_id      INT,           -- FK → USERS.user_id
--   changed_at   DATE,          -- 상태 변경일
--   status       VARCHAR(20)    -- 'ACTIVE', 'CANCELLED', 'PAUSED' 등
-- )

-- 🔸 요구사항
-- 각 사용자별로 가장 최근 상태 변경일(MAX(changed_at))을 구한다.
-- 그 날의 status가 그 사용자의 “현재 구독 상태”라고 가정한다.
-- 기준일은 CURDATE().
-- 최근 7일 기준으로, 날짜별로 다음을 구하라:
-- snapshot_date: 기준 날짜 (예: 오늘, 어제, 그제…)
-- active_user_count: 그 날짜 기준으로 “가장 최근 상태가 ACTIVE인 사용자 수”
-- 단, 이 문제는 단순화를 위해 **“현재 기준만 본다”가 아니라,
-- “가장 최근 상태가 ACTIVE이고, 그 changed_at이 최근 7일 안에 있는 사용자”**만 본다고 하자.
-- 즉,
-- latest_status_date BETWEEN CURDATE() - INTERVAL 7 DAY AND CURDATE()
-- 그 날의 status = 'ACTIVE'

-- 최종 출력은:
-- latest_status_date (사용자의 가장 최근 상태 변경일)
-- active_user_count (그 날짜에 ACTIVE 상태가 된 사용자 수)
-- 정렬:
-- latest_status_date 오름차순

-- 🔸 샘플 데이터 예시
-- INSERT INTO USERS VALUES
--   (1, 'Alice', '2024-01-01'),
--   (2, 'Bob',   '2024-01-10'),
--   (3, 'Carol', '2024-02-01'),
--   (4, 'Dave',  '2024-02-15');

-- INSERT INTO SUBSCRIPTION_HISTORY VALUES
--   (201, 1, '2024-03-01', 'ACTIVE'),
--   (202, 1, '2024-03-10', 'CANCELLED'),
--   (203, 2, '2024-03-05', 'ACTIVE'),
--   (204, 2, '2024-03-20', 'PAUSED'),
--   (205, 3, '2024-03-15', 'ACTIVE'),
--   (206, 3, '2024-03-25', 'ACTIVE'),
--   (207, 4, '2024-03-28', 'ACTIVE');

-- user_id 1
-- 최신: 2024-03-10, status = CANCELLED

-- user_id 2
-- 최신: 2024-03-20, status = PAUSED

-- user_id 3
-- 최신: 2024-03-25, status = ACTIVE
--
-- user_id 4
-- 최신: 2024-03-28, status = ACTIVE

-- CURDATE()를 2024-03-30이라고 가정하면,
-- 최근 7일: 2024-03-24 ~ 2024-03-30

-- 1번: 3/10 → 범위 밖
-- 2번: 3/20 → 범위 밖
-- 3번: 3/25, ACTIVE → 포함
-- 4번: 3/28, ACTIVE → 포함
-- → 예를 들어 결과는 이런 느낌:

-- latest_status_date | active_user_count
-- --------------------------------------
-- 2024-03-25         | 1
-- 2024-03-28         | 1
-- (샘플일 뿐, 네가 실제로 넣는 날짜/기준일에 따라 달라짐)

SELECT
FROM SUBSCRIPTION_HISTORY
WHERE status = 'ACTIVE'
GROUP BY




-- 현재 구독 상태인지 아는 방법은?
-- 그러니까 저 두 테이블에서 구독 상태인 사용자를 구하려면  changed_at을 제일 최근으로 구해서,
-- 그 시점으로 ACTIVE 상태인 것을 구하면 해당 사용자가 구독 상태인줄 알 수 있다.

SELECT user_id, MAX(changed_at) latest_status_date
FROM SUBSCRIPTION_HISTORY
GROUP BY user_id
HAVING latest_status_date = 'ACTIVE'

-- 최종 출력은:
-- latest_status_date (사용자의 가장 최근 상태 변경일)
-- active_user_count (그 날짜에 ACTIVE 상태가 된 사용자 수)
-- 정렬:
-- latest_status_date 오름차순

-- 이걸 다시 7일 기준으로 묶으려면
WITH active_user AS
(
    SELECT user_id, MAX(changed_at) latest_status_date
    FROM SUBSCRIPTION_HISTORY
    GROUP BY user_id
    HAVING latest_status_date = 'ACTIVE'
)
SELECT au.latest_status_date, COUNT(*) active_user_count
FROM active_user au
JOIN USERS u ON au.user_id = u.user_id
WHERE latest_status_date BETWEEN CURDATE() - INTERVAL 7 DAY AND CURDATE()
GROUP BY au.user_id
ORDER BY au.latest_status_date DESC;

-- 잠시 바로 못가네. GROUP BY를 한 번더 해야한다. 맞지?
WITH active_user AS
(
    SELECT user_id, MAX(changed_at) latest_status_date
    FROM SUBSCRIPTION_HISTORY
    GROUP BY user_id
    HAVING status = 'ACTIVE'
) AS au,
count_user
(
    SELECT COUNT(*) active_user_count
    FROM USERS u
    JOIN active_user au ON u.user_id, au.user_id
    GROUP BY u.user_id
) AS cu
SELECT
FROM USERS u
JOIN
GROUP BY


-- 오케이 다틀렸네
-- [실무형 답지]
WITH latest AS (
    SELECT
        user_id,
        MAX(changed_at) AS latest_status_date
    FROM SUBSCRIPTION_HISTORY
    GROUP BY user_id
)
SELECT
    s.changed_at AS latest_status_date,
    COUNT(*) AS active_user_count
FROM latest l
JOIN SUBSCRIPTION_HISTORY s
  ON s.user_id = l.user_id
 AND s.changed_at = l.latest_status_date   -- 최신 상태 한 줄만
WHERE s.status = 'ACTIVE'                 -- 그 줄의 상태가 ACTIVE
  AND s.changed_at BETWEEN CURDATE() - INTERVAL 7 DAY
                      AND CURDATE()
GROUP BY s.changed_at
ORDER BY s.changed_at ASC;

WITH latest AS (
    SELECT
        user_id,
        MAX(changed_at) AS latest_status_date
    FROM SUBSCRIPTION_HISTORY
    GROUP BY user_id
)
SELECT
    s.changed_at AS latest_status_date,
    COUNT(*) AS active_user_count
FROM latest l
JOIN SUBSCRIPTION_HISTORY s


-- 다시 복기

WITH latest AS  -- 필요없는 USERS 테이블은 쓰지도 않음
(
    SELECT user_id, MAX(changed_at) latest_status_date
    FROM SUBSCRIPTION_HISTORY
    GROUP BY user_id
)
SELECT l.latest_status_date, COUNT(*) active_user_count
FROM latest l
JOIN SUBSCRIPTION_HISTORY s
    ON l.user_id = s.user_id                -- 고유 키
    AND l.latest_status_date = s.changed_at -- 최근 날짜를 해당 테이블에 적용
WHERE latest_status_date BETWEEN CURDATE() - INTERVAL 7 DAY AND CURDATE()
    AND l.status = 'ACTIVE'
GROUP BY l.latest_status_date
ORDER BY l.latest_status_date ASC;

-- 비슷한 문제 복습 필요