-- Site   : Programmers
-- Title  : 대장균의 크기에 따라 분류하기 2 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/301649
-- Date   : 2026-01-04


-- ID, COLONY_NAME, 분류된 사이즈 -> ID 오름차순

-- # WITH TOTAL_SIZE AS (
-- #     SELECT SUM(SIZE_OF_COLONY) AS SUM_SIZE FROM ECOLI_DATA
-- # )
-- # SELECT 
-- #     E.ID, 
-- #     CASE 
-- #         WHEN (E.SIZE_OF_COLONY * 100.0 / T.SUM_SIZE) <= 25 THEN 'CRITICAL'
-- #         WHEN (E.SIZE_OF_COLONY * 100.0 / T.SUM_SIZE) BETWEEN 26 AND 75 THEN 'LOW'
-- #         ELSE 'HIGH'  -- 76 이상
-- #     END AS COLONY_NAME
-- # FROM ECOLI_DATA E
-- # CROSS JOIN TOTAL_SIZE T
-- # ORDER BY E.ID;

WITH ranked AS (
    SELECT ID,
           ROW_NUMBER() OVER(ORDER BY SIZE_OF_COLONY DESC) AS rn,
           COUNT(*) OVER() AS total_cnt
    FROM ECOLI_DATA
)
SELECT ID,
       CASE 
           WHEN rn <= total_cnt * 0.25 THEN 'CRITICAL'
           WHEN rn <= total_cnt * 0.50 THEN 'HIGH'
           WHEN rn <= total_cnt * 0.75 THEN 'MEDIUM'
           ELSE 'LOW'
       END AS COLONY_NAME
FROM ranked
ORDER BY ID;

-- 비율 해석 어류 : 내림차순으로 정렬했을 때 상위 0%~25%는 순위 기반 퍼센타일이므로 SUM이 아니라 ROW_NUMBER() DESC로 순위 계산, COUNT(*) OVER() 전체 개수 구함
-- 전반적으로 이해했으며 기억하기 위해 다시 복기 필요
