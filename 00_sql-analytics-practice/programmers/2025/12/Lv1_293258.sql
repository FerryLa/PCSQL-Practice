-- Site   : Programmers
-- Title  : 잡은 물고기의 평균 길이 구하기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/293259
-- Date   : 2025-12-04


SELECT COUNT(*) FISH_COUNT
FROM FISH_INFO
WHERE LENGTH IS NULL

-- [5단계 풀이법 점검]
-- 5단계 풀이법을 활용하면 SQL 문제를 더 쉽게 해결할 수 있다. 처음 보는 문제가 있다면 풀 수 없을 수도 있기 때문에 시간을 정해놓고 풀면 좋다.
-- 1. 문제를 전체를 빠르게 읽고 이해
-- 2. 예시 데이터를 분석
-- 3. 원하는 결과를 도출하기 위한 논리를 설계
-- 4. SQL 쿼리를 작성
-- 5. 쿼리를 테스트하고 수정

-- [7단계는 Lv이 높은 알고리즘 문제에 적용] 