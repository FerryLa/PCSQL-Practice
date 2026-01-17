-- Site   : Programmers
-- Title  : 특정 조건을 만족하는 물고기별 수와 최대 길이 구하기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/298519
-- Date   : 2026-01-17


SELECT COUNT(*) AS FISH_COUNT, AVG(LENGTH) AS MAX_LENGH, FISH_TYPE
FROM FISH_INFO
GROUP BY FISH_TYPE
HAVING MAX_LENGH >= 33

-- 오답: 10cm이하(NULL) 물고기 조건 부합하지 않음, 33m이상인 최대길이
-- 풀이: 평균 길이를 구하려면 10cm이하인 물고기가 NULL인 경우를 치환해서 풀어야함

SELECT 
    COUNT(*) AS FISH_COUNT,
    MAX(IF(LENGTH IS NULL, 10, LENGTH)) AS MAX_LENGTH,
    #IF구문 사용법 IF(조건, true인자, else인자)
    FISH_TYPE
FROM FISH_INFO
GROUP BY FISH_TYPE
HAVING AVG(LENGTH) >= 33
ORDER BY FISH_TYPE;

-- 결론: 시간에 쫓겨서 문제도 제대로 읽지 않고 풀다 말은 듯