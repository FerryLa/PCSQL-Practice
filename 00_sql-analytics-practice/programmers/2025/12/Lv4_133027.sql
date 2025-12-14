-- Site   : Programmers
-- Title  : 주문량이 많은 아이스크림들 조회하기 (LEVEL 4)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/133027
-- Date   : 2025-12-10

SELECT f.FLAVOR
FROM FIRST_HALF f
JOIN 
(
SELECT FLAVOR, SUM(TOTAL_ORDER) AS TOTAL_ORDER
FROM JULY
GROUP BY FLAVOR
) j ON f.FLAVOR = j.FLAVOR
ORDER BY (f.TOTAL_ORDER + j.TOTAL_ORDER) DESC
LIMIT 3;

-- 문제만 잘 읽고 단계적으로 접근하면 쉽게 해결하는 문제