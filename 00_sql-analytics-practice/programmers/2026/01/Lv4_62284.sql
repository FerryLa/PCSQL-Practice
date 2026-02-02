-- Site   : Programmers
-- Title  : 우유와 요거트가 담긴 장바구니 (LEVEL 4)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/62284
-- Date   : 2026-01-23

SELECT DISTINCT C1.CART_ID
FROM CART_PRODUCTS C1
JOIN CART_PRODUCTS C2 ON C1.CART_ID = C2.CART_ID
    AND C1.ID != C2.ID
WHERE C1.NAME = 'Yogurt' AND C2.NAME = 'Milk'
ORDER BY C1.ID;

-- C1.ID < C2.ID가 왜 안되는지 모르겠음