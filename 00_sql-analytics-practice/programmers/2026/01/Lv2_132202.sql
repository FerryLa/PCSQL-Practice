-- Site   : Programmers
-- Title  : 진료과별 총 예약 횟수 출력하기 (LEVEL 2) 
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/132202
-- Date   : 2026-01-26

SELECT MCDP_CD '진료과코드', COUNT(PT_NO) '5월예약건수'
FROM APPOINTMENT
WHERE DATE_FORMAT(APNT_YMD, '%Y-%m') = '2022-05'
    AND APNT_CNCL_YN = 'N' OR APNT_CNCL_YN IS NULL
# WHERE APNT_YMD >= DATE('2022-05-01') AND APNT_YMD < DATE('2022-06-01')
GROUP BY MCDP_CD
ORDER BY '5월예약건수', '진료과 코드';

-- 오답 복기 필요