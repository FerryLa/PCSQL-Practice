-- Site   : Programmers
-- Title  : 상품 별 오프라인 매출 구하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131533
-- Date   : 2025-12-02

SELECT PRODUCT_CODE, (p.PRICE * s.SUM_AMOUNT) AS SALES
FROM PRODUCT p
JOIN
(
    SELECT PRODUCT_ID, SUM(SALES_AMOUNT) AS SUM_AMOUNT
    FROM OFFLINE_SALE
    GROUP BY PRODUCT_ID
) AS s ON p.PRODUCT_ID = s.PRODUCT_ID
ORDER BY SALES DESC, p.PRODUCT_CODE ASC;