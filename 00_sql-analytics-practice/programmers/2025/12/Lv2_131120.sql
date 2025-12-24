-- Site   : Programmers
-- Title  : 3월에 태어난 여성 회원 목록 출력하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131120
-- Date   : 2025-12-24 


SELECT MEMBER_ID, MEMBER_NAME, GENDER, 
        DATE_FORMAT(DATE_OF_BIRTH, '%Y-%m-%d') DATE_OF_BIRTH
FROM MEMBER_PROFILE
WHERE MONTH(DATE_OF_BIRTH) = 3
    AND TLNO IS NOT NULL
    AND GENDER = 'W'
ORDER BY MEMBER_ID;

-- 문제 조금만 유심히 봤으면 좋았을 듯, 여성이라고 적혀있네요