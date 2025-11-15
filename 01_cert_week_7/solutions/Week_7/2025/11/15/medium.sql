-- [상황]
-- 온라인 주문 시스템에 다음 테이블이 있다.
-- CUSTOMER(cust_id, cust_name, grade)
-- ORDERS(order_id, cust_id, order_date, amount)
--
-- [요구사항]
-- 각 고객별로 2024년 한 해 동안의 총 주문 금액(sum_amount)을 구한다.
-- 그 중에서 총 주문 금액이 1,000,000 이상인 고객만 조회한다.
-- 출력 컬럼:
-- cust_name
-- grade
-- sum_amount
--
-- 결과는
-- sum_amount 내림차순
-- 금액이 같다면 grade 오름차순
-- 그 다음 cust_name 오름차순
--
-- 👉 너가 작성할 것:
-- WHERE에서 기간 조건 정확히 쓰기 (2024-01-01 ~ 2024-12-31)
-- GROUP BY, HAVING, ORDER BY를 모두 포함한 SQL 1개.
-- 힌트:
-- “그룹 기준 조건”은 HAVING
-- “행 기준 조건(날짜, 등급 등)”은 WHERE

SELECT c.cust_nmae, c.grade, SUM(o.amount) AS sum_amount
FROM CUSTOMER c
WHERE o.order_date TO_DATE('2024', 'YYYY.MM.DD')
JOIN ORDERS o ON c.cust_id = o.cust_id
GROUP BY order_date
HAVING o.amount => 1000000
ORDER BY sum_amount DESC, grade ASC, cust_name ASC;

-- [답지]
SELECT
    c.cust_name,
    c.grade,
    SUM(o.amount) AS sum_amount
FROM CUSTOMER c
JOIN ORDERS o ON c.cust_id = o.cust_id
WHERE o.order_date
    BETWEEN TO_DATE('2024-01-01', 'YYYY-MM-DD')
        AND TO_DATE('2024-12-31', 'YYYY-MM-DD')
GROUP BY c.cust_id
HAVING o.amount >= 1000000
ORDER BY sum_amount DESC, grade ASC, cust_name ASC;

-- [오답 복기]
-- JOIN절은 맞고 SELECT절의 오토빼고는 정답, WHERE절이 다음으로 와야되고, {컬럼} BETWEEN AND으로 TO_DATE 기간 정확히 설정
-- GROUP BY는 왜 저랫지? 실수 고객별이니까 고객 id나 name으로 바꾸면 됨.
-- 실수: SELECT절 오타, HAVING절 >= 연산은 equal이 우측에.

