-- Site   : Programmers
-- Title  : 분기별 분화된 대장균의 개체 수 구하기(LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/299308
-- Date   : 2026-01-09

SELECT
CONCAT(FLOOR((MONTH(DIFFERENTIATIONDATE)-1)/3)+1,'Q') as QUARTER,
COUNT(*) AS ECOLICOUNT
FROM ECOLI_DATA
GROUP BY QUARTER
ORDER BY QUARTER

-- 케이스문 안 쓰고 할 수 있네, FLOOR 쓰는 방법 다시 복기