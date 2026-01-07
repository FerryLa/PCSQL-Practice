-- Site   : Programmers
-- Title  : 연도별 대장균 크기의 편차 구하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/299310
-- Date   : 2026-01-08

WITH MAX_BY_YEAR AS (
    SELECT 
        YEAR(DIFFERENTIATION_DATE) AS YEAR,
        MAX(SIZE_OF_COLONY) AS MAX_SIZE
    FROM ECOLI_DATA
    GROUP BY YEAR(DIFFERENTIATION_DATE)
)
SELECT 
    M.YEAR,
    M.MAX_SIZE - E.SIZE_OF_COLONY AS YEAR_DEV,
    E.ID
FROM ECOLI_DATA E
JOIN MAX_BY_YEAR M ON YEAR(E.DIFFERENTIATION_DATE) = M.YEAR
ORDER BY M.YEAR, YEAR_DEV

-- 윈도우 함수를 사용해 구했지만 더 간편한 답이 있고, MAX_BY_YEAR로 나머지 사이즈를 뺄 생각을 하지 못했음 / 복기필요