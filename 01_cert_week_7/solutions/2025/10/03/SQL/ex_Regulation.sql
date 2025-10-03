/* [미니 체크리스트]
* [ ] 키워드 대문자, 식별자 소문자
* [ ] 절별 줄바꿈, 고정 들여쓰기
* [ ] 한 줄 한 컬럼, 트레일링 콤마
* [ ] JOIN/ON 줄바꿈 정렬
* [ ] WHERE 조건 한 줄 하나, AND/OR 줄 앞
* [ ] `SELECT *` 금지, 별칭 의미 있게
* [ ] 긴 서브쿼리는 CTE로 승격
* [ ] 주석 남기기

   Ctrl + ALT + L : (세계 표준?) 줄바꿈
*/

-- 예시 1
SELECT c.customer_id,
       c.customer_name,
       ct.total_amount_30d,
       CASE
           WHEN ct.total_amount_30d >= 100000 THEN 'vip'
           WHEN ct.total_amount_30d >= 50000 THEN 'gold'
           ELSE 'standard'
           END AS tier
FROM sales.customers AS c
         JOIN customer_totals AS ct
              ON ct.customer_id = c.customer_id
WHERE c.is_active = TRUE
  AND ct.total_amount_30d > 0
ORDER BY ct.total_amount_30d DESC LIMIT 100;

-- 예시 2
WITH recent_orders AS (SELECT o.order_id,
                              o.customer_id,
                              o.order_date,
                              o.total_amount
                       FROM sales.orders AS o
                       WHERE o.order_date >= CURRENT_DATE -
    INTERVAL '30 days'
    )
   , customer_totals AS (
SELECT
    r.customer_id, SUM (r.total_amount) AS total_amount_30d
FROM recent_orders AS r
GROUP BY r.customer_id
    )

/*

[자주 쓰는 디테일 규칙]
* 쉼표 위치: 열 목록은 트레일링 콤마. 마지막 열만 콤마 없음.
* AND/OR 줄 배치: `AND`/`OR`를 줄 **앞**에 둔다.
* 정규화된 참조: 조인 많으면 `스키마.테이블`까지 적고, 컬럼은 항상 별칭 접두.
* 숫자/날짜 상수: DB 방언에 맞는 리터럴 사용. 문자열 더하기로 날짜 만들지 않기.
* 주석**: 설명은 `--` 한 줄 주석, 블록은 `/* ... */`. 쿼리 상단에 목적/입력 파라미터/주의점.

* [명명 규칙(DDL)]
  * 테이블: `snake_case` 단수 또는 복수 중 하나만 고정.
  * PK: `pk_<table>`, FK: `fk_<child>__<parent>`, 인덱스: `ix_<table>__<cols>`.
* 방언 차이 주의: `LIMIT`(PostgreSQL/MySQL) vs `FETCH FIRST`(표준/Oracle), 날짜 함수 등은 벤더별로 다르다.

*/
