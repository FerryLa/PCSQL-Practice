-- Site   : Programmers
-- Title  : 조건에 맞는 도서와 저자 리스트 출력하기(LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/144854
-- Date   : 2026-01-11


SELECT B.BOOK_ID, A.AUTHOR_NAME, DATE_FORMAT(PUBLISHED_DATE, '%Y-%m-%d') as PUBLISHED_DATE
FROM BOOK B JOIN AUTHOR A
ON B.AUTHOR_ID = A.AUTHOR_ID
WHERE B.CATEGORY = '경제'
ORDER BY PUBLISHED_DATE