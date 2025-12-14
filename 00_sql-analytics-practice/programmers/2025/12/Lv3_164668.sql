-- Site   : Programmers
-- Title  : 조건에 맞는 사용자와 총 거래금액 조회하기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/164668
-- Date   : 2025-12-09

SELECT u.USER_ID, u.NICKNAME, SUM(b.PRICE) AS TOTAL_PRICE
FROM USED_GOODS_USER u
JOIN USED_GOODS_BOARD b ON u.USER_ID = b.WRITER_ID
WHERE STATUS = 'DONE'
GROUP BY u.USER_ID
HAVING SUM(b.PRICE) >= 700000
ORDER BY TOTAL_PRICE;