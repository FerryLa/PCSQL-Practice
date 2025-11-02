-- [문제]
-- 온라인 저지에 submissions 테이블이 있다.
-- id INT: 제출 ID
-- user_id INT: 사용자 ID
-- difficulty ENUM('Easy','Medium','Hard'): 문제 난이도
-- result ENUM('PASS','FAIL'): 채점 결과
-- created_at DATETIME: 제출 시각
-- 머쓱이는 통과한 제출들만 대상으로, 어떤 난이도가 가장 많이 출제되었는지(=가장 많이 통과되었는지) 알고 싶다. 결과는 아래 조건을 따르라.
-- 가장 많이 나온 난이도가 여러 개인 경우, 사전순으로 가장 앞선 난이도 하나만 출력한다.
-- 출력 컬럼은 difficulty 하나만.

-- [요구사항]
-- 가장 많이 나온 난이도를 한 행으로 반환하는 SQL을 작성하라.
-- 발판(네가 채워 넣을 골격)
-- SELECT difficulty
-- FROM (
--   SELECT difficulty, COUNT(*) AS cnt
--   FROM submissions
--   WHERE ____________________        -- 통과 제출만 남기기
--   GROUP BY difficulty
-- ) AS t
-- ORDER BY __________ DESC, __________ ASC   -- 동률일 때 사전순
-- LIMIT 1;
--
-- 한 번에 질문 하나만: WHERE에 들어가야 하는 조건을 정확히 써봐.

SELECT difficulty
FROM (
    SELECT difficulty, COUNT(*) AS cnt
    FROM submissions
    WHERE result = 'PASS'
    GROUP BY difficulty
    ) AS t
ORDER BY cnt DESC, difficulty ASC
LIMIT 1;