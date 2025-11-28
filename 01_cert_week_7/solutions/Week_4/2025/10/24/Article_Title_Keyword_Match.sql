3) [콘텐츠 스타일] 제목 패턴 필터링 + 대소문자 무시

Title: Article Title Keyword Match (정규식 실전)
Difficulty: MEDIUM
Schema hint:
ARTICLE(id INT, title VARCHAR(200))
Goal: title이 error 또는 fail 또는 exception을 포함하면 조회. 대소문자 무시, 최신 등록 순 정렬이라고 가정해 id 내림차순.
Sample rows:

INSERT INTO ARTICLE VALUES
  (1,'Build passed successfully'),
  (2,'Unhandled Exception in module'),
  (3,'Minor warning only'),
  (4,'Login FAILED due to timeout'),
  (5,'Runtime error occurred');

SELECT id, title
FROM ARTICLE
WHERE REGEXP_LIKE(title, 'error|fail|exception', 'i')
ORDER BY id DESC;



[답지]

SELECT id, title
FROM ARTICLE
WHERE REGEXP_LIKE(title, 'error|fail|exception', 'i')
ORDER BY id DESC;


-- 정규식 연습하기 좋은 REGEXP_LIKE