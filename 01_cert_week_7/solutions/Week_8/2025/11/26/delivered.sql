-- (MySQL) 복습 과제: 최근 14일 기준, 배송 완료(‘DELIVERED’) 상태인
 -- 주문 수를 날짜별로 집계하라
-- 🔹 테이블 스키마
-- -- 주문 기본 정보
-- ORDERS (
-- order_id     INT PRIMARY KEY,
-- user_id      INT,
-- ordered_at   DATE
-- );
--
-- -- 주문 상태 이력
-- ORDER_STATUS_HISTORY (
-- history_id   INT PRIMARY KEY,
-- order_id     INT,          -- FK → ORDERS.order_id
-- changed_at   DATE,         -- 상태 변경일
-- status       VARCHAR(20)   -- 'PENDING', 'PAID', 'DELIVERED', 'CANCELLED', 'RETURNED' 등
-- );
--
-- 🔹 요구사항
-- 각 order_id별로 가장 최근 상태 변경일 MAX(changed_at)을 구한다.
-- 그 날의 status가 그 주문의 현재 상태라고 가정한다.
-- 기준일은 CURDATE().
-- 최근 14일 기준으로, 날짜별로 다음을 구하라:
-- latest_status_date : 해당 주문의 최신 상태 변경일 (예: 2024-04-01, 2024-04-02 …)
-- delivered_order_count :
-- 그 날짜 기준 가장 최근 상태가 'DELIVERED'인 주문 수
-- 단, 단순히 “현재 상태가 DELIVERED”인 모든 주문이 아니라,
-- **“가장 최근 상태가 'DELIVERED'이고, 그 changed_at이 최근 14일 안에 있는 주문”**만 센다.

-- 즉, 조건은:
-- latest_status_date BETWEEN CURDATE() - INTERVAL 14 DAY AND CURDATE()
-- AND latest_status_status = 'DELIVERED'

-- 최종 출력 컬럼:
-- latest_status_date (주문의 가장 최근 상태 변경일)
-- delivered_order_count (그 날짜에 최종적으로 DELIVERED가 된 주문 수)

-- 정렬:
-- ORDER BY latest_status_date ASC

-- 🔹 샘플 데이터 예시
-- INSERT INTO ORDERS VALUES
-- (101, 1, '2024-03-01'),
-- (102, 2, '2024-03-05'),
-- (103, 3, '2024-03-10'),
-- (104, 4, '2024-03-20');

-- INSERT INTO ORDER_STATUS_HISTORY VALUES
-- (301, 101, '2024-03-02', 'PENDING'),
-- (302, 101, '2024-03-03', 'PAID'),
-- (303, 101, '2024-03-05', 'DELIVERED'),

-- (304, 102, '2024-03-06', 'PENDING'),
-- (305, 102, '2024-03-08', 'PAID'),
-- (306, 102, '2024-03-15', 'CANCELLED'),

-- (307, 103, '2024-03-12', 'PENDING'),
-- (308, 103, '2024-03-18', 'PAID'),
-- (309, 103, '2024-03-22', 'DELIVERED'),

-- (310, 104, '2024-03-21', 'PENDING'),
-- (311, 104, '2024-03-25', 'DELIVERED'),
-- (312, 104, '2024-03-28', 'RETURNED');

-- 각 주문의 최신 상태를 보면:
-- order_id 101

-- 최신: 2024-03-05, status = DELIVERED
-- order_id 102

-- 최신: 2024-03-15, status = CANCELLED
-- order_id 103

-- 최신: 2024-03-22, status = DELIVERED
-- order_id 104

-- 최신: 2024-03-28, status = RETURNED
-- CURDATE()를 2024-03-30이라고 가정하면,
-- 최근 14일: 2024-03-17 ~ 2024-03-30
-- 101: 최신 3/5 → 범위 밖
-- 102: 최신 3/15 → 범위 밖
-- 103: 최신 3/22, DELIVERED → 포함
-- 104: 최신 3/28, RETURNED → 상태가 DELIVERED가 아님 → 제외
-- 그래서 예시 결과 느낌은:
--
-- latest_status_date | delivered_order_count
-- -----------------------------------------
-- 2024-03-22         | 1

-- [풀이]
-- 요구사항 따라하기 해보자.
-- 가장 최근 상태를 구하기 위해서는 changed_at이 상태 변경일이니까, 그날의 상태 변경일에 status가 DELIVERED걸 먼저 구하고
-- 최근 14일 안에 구해야 한다. ?? 여기서 궁금한점은 나누는 편보다 WHERE절로 하면 되지 않나? 그럼 차라리 해보자.
-- group by로 묶어야 되서 순서가 안되네. 그러면 status가 DELIVERED인 상태만 뽑고
-- 그리고 주문 수를 날짜별로 집계
-- NULL 체크, 불필요한거 체크
-- 결과 출력은 latest_status_date, delivered_order_count
WITH latest_delivered
(
    SELECT
        MAX(changed_at) latest_status_date
    FROM ORDER_STATUS_HISTORY
    WHERE status = 'DELIVERED'
    GROUP BY order_id
)
SELECT
    latest_status_date,
    COUNT(*) AS delivered_order_count
FROM latest_delivered
WHERE
    latest_status_date BETWEEN CURDATE() - INTERVAL 14 DAY AND CURDATE()
GROUP BY latest_status_date
ORDER BY latest_status_date ASC;

-- 시간 경과: 29분 29초
-- 오답 이유: 일단 잘한 점은 7단계 풀이법을 적용
-- CTE에 기입한 조건절 논리는 나중에 RETURNED, CANCELLED로 바뀐 주문도 예전에 DELIVERED였던 적이 있으면 카운트에 들어갈 위험이 있음
-- [답지]
WITH latest_status AS (
    SELECT
        order_id,
        changed_at AS latest_status_date,
        status     AS latest_status,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY changed_at DESC
        ) AS rn
    FROM ORDER_STATUS_HISTORY
)
SELECT
    latest_status_date,
    COUNT(*) AS delivered_order_count
FROM latest_status
WHERE
    rn = 1
    AND latest_status_date BETWEEN CURDATE() - INTERVAL 14 DAY AND CURDATE()
    AND latest_status = 'DELIVERED'
GROUP BY latest_status_date
ORDER BY latest_status_date ASC;




-- 복기:
-- 7단계 중 어딜 못했나? -> 순서랑 기준(분류 기준)을 잘못 잡은 문제

-- [다시]
WITH latest
(
    SELECT
        order_id,
        changed_at latest_status_date
        status latest_status
    FROM ORDER_STATUS_HISTORY   -- 순서
    ROW_NUMBER() OVER ( -- 윈도우 함수 개념 다시
    PARTITION user_id   -- user_id아니고 order_id 문제 다시 읽기
    ORDER BY changed_at DESC
    ) AS rn
)
SELECT
    latest_statu_date,  -- 오타
    COUNT(*) delivered_order_count
FROM latest
WHERE latest_status = 'DELIVERD'
    latest_status_date BETWEEN CURDATE() - INTERVAL 14 DAY AND CURDATE() -- AND 안 넣어줌
GROUP BY latest_status_date
ORDER BY latest_status_date ASC;

-- 문법 점검 후 다시
WITH latest AS  -- AS 써야됨
(
    SELECT
        order_id,   -- 쿼리에는 안 들어가지만 rn기준으로 order_id 넣었는지에 필요
        changed_at AS latest_status_date,
        status AS latest_status,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY changed_at DESC
        ) AS rn
    FROM ORDER_STATUS_HISTORY
)
SELECT
    latest_status_date,
    COUNT(*) delivered_order_count
FROM latest
WHERE
    rn = 1
    AND latest_status = 'DELIVERED' -- DELIVERD 오타
    AND latest_status_date BETWEEN CURDATE() - INTERVAL 14 DAY AND CURDATE()
GROUP BY latest_status_date
ORDER BY latest_status_date ASC;