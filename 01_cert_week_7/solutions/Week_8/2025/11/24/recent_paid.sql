-- 📌 (MySQL) 복습 문제: 사용자별 ‘가장 최근 결제일’을 기준으로 최근 21일간 결제 활성 사용자 수 집계
-- 🧱 테이블 스키마
-- USERS(
--   user_id    INT PRIMARY KEY,
--   user_name  VARCHAR(100)
-- )

-- PAYMENTS(
--   pay_id      INT PRIMARY KEY,
--   user_id     INT,          -- FK → USERS.user_id
--   paid_at     DATE,         -- 결제 완료 일자
--   amount      INT,          -- 결제 금액
--   status      VARCHAR(20)   -- 'PAID', 'FAIL', 'REFUND'
-- )

-- 📌 문제 설명
-- 어떤 구독 서비스 회사가 최근 21일간 결제 활동이 있었던 사용자 수를
-- 날짜별로 집계하려고 한다.
-- 여기서 “결제 활동(Active Payment)”의 정의는 다음과 같다.


-- 🧩 조건
-- 1) 각 사용자별 최신 결제일을 구한다
-- status = 'PAID'인 결제만 인정한다.
-- MAX(paid_at)이 그 유저의 가장 최근 결제일이다.

-- 2) 최근 21일 동안 결제를 완료한 사용자만 대상
-- 기준일은 CURDATE().
-- 다음 조건에 해당하는 사용자만 집계한다:
-- recent_paid_at BETWEEN CURDATE() - INTERVAL 21 DAY AND CURDATE()

-- 3) 날짜별 집계
-- 각 날짜(recent_paid_at)가 첫 결제일인 사용자 수를 세서:
-- recent_paid_at
-- paying_user_count
-- 을 출력한다.
--
-- 4) 정렬
-- recent_paid_at ASC
--
-- 📌 예시 데이터 (넣어도 되고 말아도 됨)
-- INSERT INTO USERS VALUES
--   (1,'Alice'),
--   (2,'Bob'),
--   (3,'Carol'),
--   (4,'Dave'),
--   (5,'Eve');
--
-- INSERT INTO PAYMENTS VALUES
--   (201,1,'2024-03-02',10000,'PAID'),
--   (202,1,'2024-03-18',15000,'PAID'),
--   (203,2,'2024-03-10',20000,'FAIL'),
--   (204,2,'2024-03-12',30000,'PAID'),
--   (205,3,'2024-02-28',12000,'PAID'),
--   (206,3,'2024-03-25',15000,'PAID'),
--   (207,4,'2024-03-29',30000,'PAID'),
--   (208,5,'2024-03-01',20000,'REFUND');
--
--
-- 이 데이터 기준으로 하면:
-- Alice: 최근 결제일 3/18
-- Bob: 최근 결제일 3/12
-- Carol: 최근 결제일 3/25
-- Dave: 최근 결제일 3/29
-- Eve: PAID 없음 → 제외
--
-- 최근 21일 조건이라면
-- 3/12, 3/18, 3/25, 3/29 네 날짜가 집계됨.
--
-- ✨ 출력 예시 형태 (정답 아님)
-- recent_paid_at | paying_user_count
-- -----------------------------------
-- 2024-03-12     | 1
-- 2024-03-18     | 1
-- 2024-03-25     | 1
-- 2024-03-29     | 1
--
-- 📌 힌트 (너 정도면 이 정도만 줘도 충분)
-- 먼저 CTE에서 사용자별 최신 결제일 뽑기
-- GROUP BY user_id
-- MAX(paid_at)
-- WHERE status = 'PAID'
-- 바깥 SELECT에서
-- 최근 21일 필터
-- GROUP BY recent_paid_at
-- COUNT(*)
-- JOIN 불필요 (LOGIN_HISTORY 문제와 동일 패턴)
--
-- ⏱ 예상 풀이 시간
-- 15–25분 (오늘 너 상태 기준)

-- [풀이]
-- 논리 설계 : 최근 21일간 결제한 이력이 있는 사용자 수를 날짜별로 집계
-- 쿼리 설계 : PAYMENTS status가 'PAID'이고, paid_at가 CURDATE() - INTERVAL 21 DAY를 이용하여 최근 21일 결제 내역이 있는 사용자 수를 조회
-- CTE를 이용? 안 써도 되는거 같은데 잠시 써야되네. 사용자 수를 CTE로 마지막으로 날짜별로 집계
-- 아닌가? 이거 그냥 서브쿼리로 처리해야 하나?
-- 출력 recent_paid_at, paying_user_count
SELECT c.paid_at recent_paid_at, COUNT(*) paying_user_count
FROM PAYMENTS p
JOIN (
SELECT user_id, paid_at
    FROM PAYMENTS
    WHERE paid_at BETWEEN CURDATE() AND CURDATE() - INTERVAL 21 DAY
        AND status = 'PAID'
) AS c ON p.user_id = c.user_id
GROUP BY p.user_id
ORDER BY recent_paid_at AS

-- JOIN을 쓰지 않아도 되는 이유가 뭐지?
-- JOIN을 쓰면 복잡도가 늘어나나? CTE가 메모리를 덜 잡아 먹나?

-- [오답 이유]
-- 사용자별 최신 결제일을 안 구함 -> MAX(paid_at)
-- BETWEEN을 사용하려면 작은 날짜 먼저
-- JOIN 자체가 쓸모 없는 이유는 -> 안&바깥쪽 모두 PAYMENTS를 쓰고 있어 row만 뻥튀기: JOIN을 쓰는 이유는 다른 테이블을 붙이기 위함?
-- 다틀렸네. 최종적으로 묶어야 하는 것은 날짜(recent_paid_at)별 사용자 수라 GROUP BY recent_paid_at
-- 정말 간단하게 표현하면 CTE는 가독성이 좋아서 씀, JOIN은 테이블을 붙이기 위해서 씀


WITH latest_payment AS (
    SELECT
        user_id,
        MAX(paid_at) AS recent_paid_at  -- 가장 최근 일: MAX(paid_at)
    FROM PAYMENTS
    WHERE status = 'PAID'
    GROUP BY user_id
)
SELECT
    recent_paid_at, COUNT(*) paying_user_count
FROM latest_payment
WHERE
    recent_paid_at BETWEEN CURDATE() - INTERVAL 24 DAY AND  CURDATE()
GROUP BY
    recent_paid_at
ORDER BY
    recent_paid_at ASC; -- 문제에서 ASC 쓰래

