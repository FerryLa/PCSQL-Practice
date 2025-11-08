-- 1) [이커머스 스타일] 이메일 도메인 필터링
--
-- Title: Customer Email Filter (정규식 기초)
-- Difficulty: EASY
-- Schema hint:
-- CUSTOMER(id INT, name VARCHAR(50), email VARCHAR(200))
-- Goal: email이 gmail.com 또는 naver.com인 고객만 사전순 조회. 대소문자 무시.
-- Sample rows:
-- INSERT INTO CUSTOMER VALUES
--   (1,'Alice','alice@gmail.com'),
--   (2,'Bob','BOB@NAVER.COM'),
--   (3,'Carol','carol@yahoo.com'),
--   (4,'Dave','dave@Gmail.com');


SELECT id, name, email
FROM customer
WHERE REGEXP_LIKE(email, 'gmail.com' or 'naver.com',i)
ORDER BY email


[답지]
SELECT name, email
FROM CUSTOMER
WHERE REGEXP_LIKE(email, '@(gmail\.com|naver\.com)$', 'i')
ORDER BY name;

-- 오답 : 세미콜론 기입하기 / 정규식 @(gmail\.com|naver\.com)$ / i 따옴표로 감싸기
