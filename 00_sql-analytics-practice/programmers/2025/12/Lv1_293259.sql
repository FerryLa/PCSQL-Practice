-- Site   : Programmers
-- Title  : 잡은 물고기의 평균 길이 구하기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/293259
-- Date   : 2025-12-04


SELECT ROUND(AVG(COALESCE(LENGTH, 10)), 2) AVERAGE_LENGTH
FROM FISH_INFO;

