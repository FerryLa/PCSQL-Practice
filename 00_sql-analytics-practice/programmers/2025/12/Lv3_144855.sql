-- Site   : Programmers
-- Title  : 카테고리 별 도서 판매량 집계하기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/144855
-- Date   : 2025-12-16

SELECT B.CATEGORY, SUM(S.SALES) TOTAL_SALES
FROM BOOK_SALES S
JOIN BOOK B ON S.BOOK_ID = B.BOOK_ID
WHERE S.SALES_DATE >= '2022-01-01'
    AND S.SALES_DATE < '2022-02-01'
GROUP BY B.CATEGORY
ORDER BY CATEGORY;

-- 실수는 없었으나 DATE 범위 설정에서 DATE_FORMAT을 쓸 뻔 했다. 
-- DATE_FORMAT은 출력용이지 조건용이 아니다.