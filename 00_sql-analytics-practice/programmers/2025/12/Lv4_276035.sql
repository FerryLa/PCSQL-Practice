-- Site   : Programmers
-- Title  : FrontEnd 개발자 찾기 (LEVEL 4)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/276035
-- Date   : 2025-12-23

SELECT DISTINCT ID, EMAIL,  FIRST_NAME, LAST_NAME
FROM DEVELOPERS D
JOIN SKILLCODES S ON (D.SKILL_CODE & S.CODE) = S.CODE
WHERE S.CATEGORY = 'Front End'
ORDER BY ID;

-- JOIN(INNER JOIN)은 데카르트곱-> ON 조건 필터링-> 교집합 결과-> SELECT/DISTINCT/ORDER BY
-- D(3행) × S(5행) = 15행 (데카르트 곱) -> ↓ ON 필터링 (예: 4행 TRUE) -> 결과: 4행 (교집합)