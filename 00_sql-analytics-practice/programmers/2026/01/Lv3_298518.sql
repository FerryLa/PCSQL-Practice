-- Site   : Programmers
-- Title  : 특정 물고기를 잡은 총 수 구하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/298518
-- Date   : 2026-01-16

-- SELECT COUNT(*) AS FISH_COUNT
-- FROM FISH_INFO
-- WHERE FISH_TYPE = '0' OR FISH_TYPE = '1'
-- GROUP BY FISH_TYPE = '0' OR FISH_TYPE = '1'

-- 원인: 하드코딩, 단일집계 불가, JOIN문 생략으로 인한 이름 매핑 불가
-- 해결: GROUP BY 삭제, 이름으로 필터링

SELECT COUNT(*) AS FISH_COUNT
FROM FISH_INFO FI
LEFT JOIN FISH_NAME_INFO FNI ON FI.FISH_TYPE = FNI.FISH_TYPE
WHERE FNI.FISH_NAME IN ('BASS','SNAPPER')
