-- 2) [플랫폼 스타일] 한국 휴대폰 형식 검사
--
-- Title: Phone Number Format Check (정규식 중급)
-- Difficulty: MEDIUM
-- Schema hint:
-- USER(id INT, phone VARCHAR(20))
-- Goal: phone이 정확히 010-####-#### 형식인 행만 조회. 하이픈 위치도 정확해야 한다.
-- Sample rows:
--
-- INSERT INTO USER VALUES
--   (1,'010-1234-5678'),
--   (2,'010-123-5678'),
--   (3,'011-1234-5678'),
--   (4,'01012345678'),
--   (5,'010-9999-0000');

SELECT id, phone
FROM user
WHERE REGEXP_LIKE(phone, '010\-____\-____', );



[답지]

SELECT id, phone
FROM USER
WHERE phone REGEXP '^010-[0-9]{4}-[0-9]{4}$'
ORDER BY id;

-- 그러니까 ^는 시작행이고 $는 끝을 알리는거네요.
-- [0-9]{4}-[0-9]{4}& 확인

[복습]
SELECT id, phone
FROM phone
WHERE phone REGEXP '^010-[0-9]{4}-[0-9]{4]$'
ORDER BY id;