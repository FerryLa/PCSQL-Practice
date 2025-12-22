-- Site   : Programmers
-- Title  : 업그레이드 된 아이템 구하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/273711
-- Date   : 2025-12-21

SELECT I.ITEM_ID, I.ITEM_NAME, I.RARITY
FROM ITEM_INFO I
JOIN ITEM_TREE T ON I.ITEM_ID = T.ITEM_ID
WHERE T.PARENT_ITEM_ID IN (
    SELECT ITEM_ID
    FROM ITEM_INFO
    WHERE RARITY = 'RARE'
)
ORDER BY ITEM_ID DESC;

-- 문제 난이도 LEVEL 2가 나에겐 더 어려웠다.