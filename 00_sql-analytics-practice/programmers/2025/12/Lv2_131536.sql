-- Site   : Programmers
-- Title  : 재구매가 일어난 상품과 회원 리스트 구하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131536
-- Date   : 2025-12-03 

SELECT DISTINCT o1.USER_ID, o1.PRODUCT_ID
FROM ONLINE_SALE o1
JOIN ONLINE_SALE o2
  ON o1.ONLINE_SALE_ID > o2.ONLINE_SALE_ID
 AND o1.USER_ID = o2.USER_ID
 AND o1.PRODUCT_ID = o2.PRODUCT_ID
ORDER BY o1.USER_ID ASC, o1.PRODUCT_ID DESC;

-- 정석 답과 다름, 복기필요
