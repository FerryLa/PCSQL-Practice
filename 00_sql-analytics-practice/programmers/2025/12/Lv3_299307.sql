-- Site   : Programmers
-- Title  : 대장균의 크기에 따라 분류하기 1 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/299307
-- Date   : 2025-12-19

SELECT ID, CASE
    WHEN SIZE_OF_COLONY <= 100 THEN 'LOW'
    WHEN SIZE_OF_COLONY > 1000 THEN 'HIGH'
    ELSE 'MEDIUM'
    END AS SIZE
FROM ECOLI_DATA
ORDER BY ID;