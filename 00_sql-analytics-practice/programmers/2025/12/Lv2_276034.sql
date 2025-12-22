-- Site   : Programmers
-- Title  : 조건에 맞는 개발자 찾기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/276034
-- Date   : 2025-12-22

SELECT ID, EMAIL, FIRST_NAME, LAST_NAME
FROM DEVELOPERS D
JOIN SKILLCODES S ON D.SKILL_CODE & S.CODE = S.CODE -- 중복행 방지로 SELECT 문에서 DISTINCT 사용 필요할 수도
WHERE S.NAME IN ('Python', 'C#')
ORDER BY ID ASC;


-- & 결과가 0이 아니면 → TRUE (조건 통과) # &연산자는 모든 숫자를 2진수로 해석해서 비교