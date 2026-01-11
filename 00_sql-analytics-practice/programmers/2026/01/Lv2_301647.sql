-- Site   : Programmers
-- Title  : 대장균들의 자식의 수 구하기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/299305
-- Date   : 2026-01-07

SELECT E.ID, IFNULL(C.CHILD_COUNT, 0) AS CHILD_COUNT
FROM ECOLI_DATA E
LEFT JOIN (
SELECT PARENT_ID, COUNT(*) AS CHILD_COUNT
FROM ECOLI_DATA
GROUP BY PARENT_ID
) AS C ON E.ID = C.PARENT_ID
ORDER BY E.ID;

-- 시간 적당, 정답, 정규화 확인