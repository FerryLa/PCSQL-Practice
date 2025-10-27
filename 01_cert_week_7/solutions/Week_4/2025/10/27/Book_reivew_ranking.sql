# 문제: Book 리뷰 랭킹

## 스키마

* `books(book_id, title, author_id, published_year, genre)`
* `authors(author_id, name, country)`
* `reviews(review_id, book_id, user_id, rating, review_date)`
* `users(user_id, name, signup_date, tier)`

## 요구사항

최근 1년 이내의 리뷰만 기준으로 다음을 구하세요.

각 **장르(genre)** 에서

* 평균 평점이 **4.2 이상**이고
* 리뷰 수가 **30개 이상**인 **책들** 중에서,

그 장르에서 **가장 우수한 책 1권**을 출력합니다. 우수 기준은

1. 평균 평점 내림차순
2. 리뷰 수 내림차순
3. 제목(title) 오름차순

### 결과 컬럼

`genre, title, author_name, avg_rating, review_count`

### 정렬

최종 결과는 `avg_rating` 내림차순, 그다음 `review_count` 내림차순.

## 힌트

* 날짜 필터: `review_date >= CURRENT_DATE - INTERVAL '1 year'`
* 먼저 책 단위로 `avg(rating), count(*)` 집계 후 장르 기준으로 **창문 함수**로 1등만 고르기.
* 마지막에 `authors` 조인으로 `author_name` 붙이기.

이 문제에서 **먼저 만들 집계 서브쿼리에는 어떤 컬럼들이 꼭 들어가야 할까요?** (하나만 말해봐요. 거기서부터 굴려보죠.)

WITH recent_reviews AS (
  SELECT r.book_id, r.rating
  FROM reviews r
  WHERE r.review_date >= CURRENT_DATE - INTERVAL '1 year'
),
book_stats AS (
  SELECT
    b.genre,
    r.book_id,
    AVG(r.rating)       AS avg_rating,
    COUNT(*)            AS review_count
  FROM recent_reviews r
  JOIN books b ON b.book_id = r.book_id
  GROUP BY b.genre, r.book_id
),
qualified AS (
  SELECT *
  FROM book_stats
  WHERE avg_rating >= 4.2
    AND review_count >= 30
),
ranked AS (
  SELECT
    q.genre,
    q.book_id,
    q.avg_rating,
    q.review_count,
    ROW_NUMBER() OVER (
      PARTITION BY q.genre
      ORDER BY q.avg_rating DESC, q.review_count DESC, b.title ASC
    ) AS rn
  FROM qualified q
  JOIN books b ON b.book_id = q.book_id
)
SELECT
  r.genre,
  b.title,
  a.name AS author_name,
  ROUND(r.avg_rating, 2) AS avg_rating,
  r.review_count
FROM ranked r
JOIN books b   ON b.book_id = r.book_id
JOIN authors a ON a.author_id = b.author_id
WHERE r.rn = 1
ORDER BY r.avg_rating DESC, r.review_count DESC;

-- 쉽지 않네. 대강 WITH AS랑 ROW_NUMBER() OVER 구문을 연습해야겠따.