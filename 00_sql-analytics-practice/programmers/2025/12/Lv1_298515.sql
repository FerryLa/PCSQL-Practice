-- Site   : Programmers
-- Title  : 잡은 물고기 중 가장 큰 물고기의 길이 구하기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/298515
-- Date   : 2025-12-02

SELECT concat(MAX(LENGTH), 'cm') AS MAX_LENGTH
FROM FISH_INFO; 