-- Site   : Programmers
-- Title  : 조건에 맞는 사용자 정보 조회하기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/164670
-- Date   : 2025-12-18

SELECT 
    USER_ID,
    NICKNAME,
    CONCAT(CITY, ' ', STREET_ADDRESS1, ' ', STREET_ADDRESS2) '전체주소',
    CONCAT(LEFT(TLNO,3), '-', SUBSTR(TLNO,4,4), '-', RIGHT(TLNO,4)) '전화번호'
FROM USED_GOODS_USER U
JOIN (   
    SELECT WRITER_ID, COUNT(*) AS CNT_WRITER
    FROM USED_GOODS_BOARD 
    GROUP BY WRITER_ID
    HAVING CNT_WRITER >= 3
) AS B ON U.USER_ID = B.WRITER_ID
ORDER BY USER_ID DESC;

-- 중고거래 게시물을 3건 등록한 사용자
-- ID, 닉네임, 주소(시,도로명 주소, 상세주소), 전화번호
-- 전화번호는 xxx-xxxx-xxxx
-- 회원ID 기준 내림차순