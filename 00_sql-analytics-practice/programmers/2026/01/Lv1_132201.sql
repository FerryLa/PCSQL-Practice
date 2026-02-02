-- Site   : Programmers
-- Title  : 12세 이하인 여자 환자 목록 출력하기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/132201
-- Date   : 2026-01-31

SELECT 
    PT_NAME,
    PT_NO,
    GEND_CD,
    AGE,
    IFNULL(TLNO, 'NONE') TLNO
FROM PATIENT
WHERE AGE <= 12 AND GEND_CD = 'W'
ORDER BY AGE DESC, PT_NAME;

