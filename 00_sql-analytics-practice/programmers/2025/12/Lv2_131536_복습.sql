-- Site   : Programmers
-- Title  : 재구매가 일어난 상품과 회원 리스트 구하기 (LEVEL 2) - 복습
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131536
-- Date   : 2025-12-28

-- 재구매가 일어난 상품과 회원 리스트 구하기
-- 1. 동일한 회원이 동일한 상품을 재구매한 데이터 -> 재구매한 회원 ID
-- 2. 재구매한 회원 ID, 재구매한 상품 ID 결과 출력 -> (하나의 판매 데이터만)
-- 3. 그럼 SELF JOIN을 사용해서 DATE를 ASC하여 DISTINCT로 제일 과거 구매 날짜를 가져옴
-- 3-2. 제일 과거 날짜 구매 회원 USER_ID,PRODUCT_ID,DATE를 기존 테이블 회원 USER_ID,PRODUCT_ID,DATE랑 비교하여 USER_ID는 같고, PRODUCT_ID도 같고, DATE는 다른 값을 구하면 재구매한 데이터가 나옴 

-- # SELECT DISTINCT o1.USER_ID, o1.PRODUCT_ID
-- # FROM ONLINE_SALE o1
-- # JOIN ONLINE_SALE o2 
-- #   ON o1.ONLINE_SALE_ID > o2.ONLINE_SALE_ID
-- #  AND o1.USER_ID = o2.USER_ID
-- #  AND o1.PRODUCT_ID = o2.PRODUCT_ID
-- # ORDER BY o1.USER_ID ASC, o1.PRODUCT_ID DESC;


-- 다시 동일한 회원이 동일한 제품을 재구매한 데이터를 구하는 방법
-- 출력은 재구매한 회원, 재구매한 상품을 조회
-- 첫구매와 재구매를 비교해서 같으면 재구매의 내역을 조회 하는 방법

-- # SELECT USER_ID, PRODUCT_ID
-- # FROM ONLINE_SALE
-- # GROUP BY USER_ID, PRODUCT_ID
-- # HAVING COUNT(*) >= 2
-- # ORDER BY USER_ID ASC, PRODUCT_ID DESC;

-- 동일한 회원이 동일한 상품을 재구매한 데이터를 구하라.
-- 회원ID 기준 오르차순, 상품 ID 기준 내림차순

SELECT USER_ID, PRODUCT_ID
FROM ONLINE_SALE
GROUP BY USER_ID, PRODUCT_ID
HAVING COUNT(*) >= 2
ORDER BY USER_ID ASC, PRODUCT_ID DESC;

-- GROUP BY는 행을 묶어서 나타내는 것이고 DISTINCT와 다른 점은 HAVING절 활용과 COUNT와 SUM을 적용시킬 수 있다는 것