-- Site   : Programmers
-- Title  : 업그레이드 할 수 없는 아이템 구하기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/273712
-- Date   : 2025-12-20

SELECT ITEM_ID, ITEM_NAME, RARITY
FROM ITEM_INFO
WHERE ITEM_ID NOT IN (
    SELECT PARENT_ITEM_ID
    FROM ITEM_TREE
    WHERE PARENT_ITEM_ID IS NOT NULL)
ORDER BY ITEM_ID DESC;

-- IS NOT NULL은 조건문, IN과 NOT IN 뒤에는 VALUE로 값 비교 형식