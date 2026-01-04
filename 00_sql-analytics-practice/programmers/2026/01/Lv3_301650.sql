-- Site   : Programmers
-- Title  : 특정 세대의 대장균 찾기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/301650
-- Date   : 2026-01-05

SELECT A.ID
FROM ECOLI_DATA A
JOIN ECOLI_DATA B ON A.PARENT_ID = B.ID
JOIN ECOLI_DATA C ON B.PARENT_ID = C.ID
WHERE C.PARENT_ID IS NULL;

-- 대장균 문제가 쉽지 않다. 주말에 다시 복기 필요 (RECURSIVE CTE 사용 방법과 더블 JOIN 방법 모두 숙지 필요)
-- 구조적 분석: 관계지향이 아니라 객체지향으로 가고있다는 내용