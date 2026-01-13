-- Site   : Programmers
-- Title  : 조건에 맞는 사원 정보 조회하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/284527
-- Date   : 2026-01-13


SELECT S.SCORE, E.EMP_NO, E.EMP_NAME, E.POSITION, E.EMAIL
FROM HR_EMPLOYEES E
JOIN (
    SELECT SUM(SCORE) AS SCORE, EMP_NO
    FROM HR_GRADE
    WHERE YEAR = '2022'
    GROUP BY EMP_NO
) S ON E.EMP_NO = S.EMP_NO
ORDER BY SCORE DESC
LIMIT 1

-- SUM과 MAX을 동시에 사용해야 할 때 LIMIT 1로 최대값을 구하는 방법