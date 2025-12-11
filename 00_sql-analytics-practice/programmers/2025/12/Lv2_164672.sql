-- Site   : Programmers
-- Title  : 조건에 부합하는 중고거래 상태 조회하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/164672
-- Date   : 2025-12-11

SELECT 
    BOARD_ID,
    WRITER_ID,
    TITLE,
    PRICE,
    CASE 
        WHEN STATUS = 'DONE' THEN '거래완료'
        WHEN STATUS = 'SALE' THEN '판매중'
        ELSE '예약중'
    END AS STATUS
FROM USED_GOODS_BOARD
WHERE CREATED_DATE = DATE_FORMAT('2022-10-05', '%Y-%m-%d')
ORDER BY BOARD_ID DESC;

-- SELECT CASE WHEN STATUS = 'DONE' THEN '거래완료' WHEN STATUS = 'SALE' THEN '판매중' ELSE '예약중' END AS STATUS FROM USED_GOODS_BOARD;