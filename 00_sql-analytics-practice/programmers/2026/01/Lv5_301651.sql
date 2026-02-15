-- Site   : Programmers
-- Title  : 멸종위기의 대장균 찾기 (LEVEL 5)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/301651
-- Date   : 2026-01-06 / 2026-02-15


-- 다시 풀어보기 시간 초과

-- SELECT COUNT(*)
-- FROM ECOLI_DATA
-- WHERE PARENT_ID IS NULL


-- 세대별 자식 없는 개체 수 GENERATION / COUNT
-- GENERATION ASC

WITH RECURSIVE GENERATION AS (
    SELECT  -- 1세대 (루트) 설정
        ID,
        PARENT_ID,
        1 AS GENERATION
    FROM ECOLI_DATA
    WHERE PARENT_ID IS NULL

UNION ALL
    
    SELECT  -- 자식 세대 생성
        E.ID,
        E.PARENT_ID,
        G.GENERATION + 1 AS GENERATION
    FROM ECOLI_DATA E
    JOIN GENERATION G ON E.PARENT_ID = G.ID
),
LEAF_ECOLI AS (
    SELECT  -- 자식이 없는 개체 찾기
        G.GENERATION
    FROM GENERATION G
    LEFT JOIN ECOLI_DATA C ON G.ID = C.PARENT_ID
    WHERE C.ID IS NULL
)
SELECT
    COUNT(*) AS COUNT,
    GENERATION
FROM LEAF_ECOLI
GROUP BY GENERATION
ORDER BY GENERATION;

-- 대장균 문제는 재귀 함수를 기본적으로 쓴다.
