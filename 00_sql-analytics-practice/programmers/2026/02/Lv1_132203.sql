-- Site   : Programmers
-- Title  : 흉부외과 또는 일반외과 의사 목록 출력하기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/132203
-- Date   : 2026-02-16

SELECT
    DR_NAME,
    DR_ID,
    MCDP_CD,
    DATE_FORMAT(HIRE_YMD, '%Y-%m-%d') HIRE_YMD
FROM DOCTOR
WHERE MCDP_CD = 'CS' OR MCDP_CD = 'GS'
ORDER BY HIRE_YMD DESC, DR_NAME ASC;

-- IN도 사용가능, REGEXP는 CPU 사용량이 대폭 증가