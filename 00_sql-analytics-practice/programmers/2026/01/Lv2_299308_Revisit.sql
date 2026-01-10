-- Site   : Programmers
-- Title  : 분기별 분화된 대장균의 개체 수 구하기 - 복기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/299308
-- Date   : 2026-01-10

-- 케이스문 안 쓰고 할 수 있네, FLOOR 쓰는 방법 다시 복기

SELECT
CONCAT(FLOOR((MONTH(DIFFERENTIATIONDATE)-1)/3)+1,'Q') as QUARTER,
COUNT(*) AS ECOLICOUNT
FROM ECOLI_DATA
GROUP BY QUARTER
ORDER BY QUARTER

-- (MONTH(DIFFERENTIATIONDATE) - 1) / 3
-- 월을 0~11로 만든 뒤 3으로 나눠서 분기 인덱스를 구하면 각 분기 보다 -1값이 나오기 때문에
-- +1을 해주면 분기가 나오고, 그걸 CONCAT으로 Q와 이어주면 분기별 완성