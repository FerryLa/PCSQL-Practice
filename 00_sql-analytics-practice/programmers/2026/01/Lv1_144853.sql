-- Site   : Programmers
-- Title  : 조건에 맞는 도서 리스트 출력하기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/144853
-- Date   : 2026-01-19

SELECT 
    BOOK_ID, 
    DATE_FORMAT(PUBLISHED_DATE, '%Y-%m-%d') AS PUBLISHED_DATE
FROM BOOK
WHERE CATEGORY = '인문'
    AND YEAR(PUBLISHED_DATE) = 2021
ORDER BY PUBLISHED_DATE;