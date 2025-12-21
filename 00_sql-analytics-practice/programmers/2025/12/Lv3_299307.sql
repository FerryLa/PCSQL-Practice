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

-- CASE WHEN THEN ELSE END 문법은 SELECT 절에서 사용만 할 수 있는 것이 아니다. WHERE 절이나 ORDER BY 절 등에서도 사용 가능하다.
-- 다만, GROUP BY 절에서는 사용할 수 없다.