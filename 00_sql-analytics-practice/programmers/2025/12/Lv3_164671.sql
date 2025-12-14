-- Site   : Programmers
-- Title  : 조회수가 가장 많은 중고거래 게시판의 첨부파일 조회하기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/164671
-- Date   : 2025-12-13

SELECT CONCAT('/home/grep/src/', BOARD_ID, '/', FILE_ID, FILE_NAME, FILE_EXT) FILE_PATH
FROM USED_GOODS_FILE
WHERE BOARD_ID = (
    SELECT BOARD_ID
    FROM USED_GOODS_BOARD
    ORDER BY VIEWS DESC
    LIMIT 1 -- 동률 처리나 인덱스 상황에 따라 달라질 수 있다.
)

-- 오답이니까 복습 필요 MAX를 사용해야함