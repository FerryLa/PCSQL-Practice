-- Site   : Programmers
-- Title  : Python 개발자 찾기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/276013
-- Date   : 2025-12-22

SELECT ID, EMAIL, FIRST_NAME, LAST_NAME
FROM DEVELOPER_INFOS
WHERE SKILL_1 = 'Python'
    OR SKILL_2 = 'Python'
    OR SKILL_3 = 'Python'
ORDER BY ID ASC;

-- 1레벨 푸는데 고작 2분 정도?