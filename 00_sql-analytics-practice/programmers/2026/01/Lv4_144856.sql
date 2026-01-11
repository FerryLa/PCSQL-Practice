-- Site   : Programmers
-- Title  : 저자 별 카테고리 별 매출액 집계하기 (LEVEL 4)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/144856
-- Date   : 2026-01-12

SELECT 
    A.AUTHOR_ID,
    A.AUTHOR_NAME,
    S.CATEGORY,
    S.TOTAL_SALES
FROM AUTHOR AS A
JOIN(
    SELECT B.AUTHOR_ID, B.CATEGORY, SUM(B.PRICE * S.SALES) AS TOTAL_SALES
    FROM BOOK AS B
    JOIN BOOK_SALES AS S
    ON B.BOOK_ID = S.BOOK_ID
    WHERE DATE_FORMAT(S.SALES_DATE, '%Y-%m') = '2022-01'
    GROUP BY B.AUTHOR_ID, B.CATEGORY
) AS S ON A.AUTHOR_ID = S.AUTHOR_ID
ORDER BY A.AUTHOR_ID, S.CATEGORY DESC;

-- DATE_FORMAT으로 연-월 형태로 바꿔서 2022-01월 매출만 집계