-- Site   : Programmers
-- Title  : 상품을 구매한 회원 비율 구하기 (LEVEL 5)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131534
-- Date   : 2025-12-25


-- # SELECT 
-- #     YEAR(USER_ID),
-- #     ROUND(
-- #     (SELECT USER_ID, JOINED
-- #     FROM USER_INFO
-- #     WHERE YEAR(JOINED) = '2021')/(SELECT U.USER_ID, U.JOINED
-- #     FROM ONLINE_SALE S
-- #     JOIN USER_INFO U ON S.USER_ID = U.USER_ID
-- #     WHERE YEAR(JOINED) = '2021'))
-- # FROM USER_INFO

SELECT 
    YEAR(sales_date) year, 
    MONTH(sales_date) month, 
    COUNT(DISTINCT user_id) purchased_users,
    ROUND(COUNT(DISTINCT user_id) / (SELECT COUNT(DISTINCT user_id)
    FROM user_info
    WHERE YEAR(joined) = 2021), 1) puchased_ratio
FROM user_info
JOIN online_sale USING (user_id)
WHERE YEAR(joined) = 2021
GROUP BY YEAR(sales_date), MONTH(sales_date)

-- 다음 4,5단계 문제는 프로그래머스에서 말고 CTE 사용해서 독자적으로 풀기