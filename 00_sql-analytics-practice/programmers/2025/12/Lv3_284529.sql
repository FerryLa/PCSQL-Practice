-- Site   : Programmers
-- Title  : 부서별 평균 연봉 조회하기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/284529
-- Date   : 2025-12-09

SELECT D.DEPT_ID, D.DEPT_NAME_EN, ROUND(AVG(E.SAL), 0) AS AVG_SAL
FROM HR_EMPLOYEES E
JOIN HR_DEPARTMENT D ON E.DEPT_ID = D.DEPT_ID
GROUP BY D.DEPT_ID
ORDER BY AVG_SAL DESC;