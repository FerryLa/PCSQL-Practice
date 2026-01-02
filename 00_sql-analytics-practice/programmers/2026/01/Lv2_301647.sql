-- Site   : Programmers
-- Title  : 부모의 형질을 모두 가지는 대장균 찾기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/301647
-- Date   : 2026-01-03

SELECT E.ID, E.GENOTYPE, E.PARENT_GENOTYPE
FROM ECOLI_DATA E
JOIN ECOLI_DATA S ON E.PARENT_ID = S.ID
WHERE E.GENOTYPE & S.GENOTYPE = 1
ORDER BY ID;

-- 시간 10분 복기 다시