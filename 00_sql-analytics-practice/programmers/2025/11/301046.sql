-- Site   : Programmers
-- Title  : 특정 형질을 가지는 대장균 찾기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/301646
-- Date   : 2025-11-28

SELECT COUNT(*) AS COUNT
FROM ECOLI_DATA
WHERE (GENOTYPE & 2) = 0
    AND ((GENOTYPE & 1) > 0 OR (GENOTYPE & 4) > 0);