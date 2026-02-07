-- 순위 함수들 (RANK 계열)
RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS rank_num           -- 동점시 순위 건너뜀[web:15][web:26]

DENSE_RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS dense_rank   -- 동점시 순위 연속[web:15][web:26]

NTILE(4) OVER(PARTITION BY region ORDER BY sales DESC) AS sales_quartile     -- 4개 구간 분할[web:27]

집계 윈도우 함수들
SUM(sales) OVER(PARTITION BY month) AS monthly_total                         -- 월별 총합[web:26]

AVG(sales) OVER(PARTITION BY product ORDER BY date ROWS UNBOUNDED PRECEDING) AS moving_avg  -- 누적 평균[web:26]

COUNT(*) OVER(PARTITION BY customer) AS order_count                          -- 고객별 주문건수[web:26]

이동 윈도우 함수들 (LAG/LEAD)
LAG(sales, 1) OVER(PARTITION BY product ORDER BY date) AS prev_sales         -- 이전일 매출[web:26][web:27]

LEAD(sales, 1) OVER(PARTITION BY product ORDER BY date) AS next_sales        -- 다음날 매출[web:26][web:27]

FIRST_VALUE(sales) OVER(PARTITION BY month ORDER BY sales DESC) AS top_sales -- 월별 1위 매출[web:26]

실제 CTE 조합 예시
WITH analysis AS (
    SELECT 
        product, date, sales,
        -- 순위
        ROW_NUMBER() OVER(PARTITION BY product ORDER BY sales DESC) AS rn,
        RANK() OVER(PARTITION BY product ORDER BY sales DESC) AS rk,
        -- 집계
        SUM(sales) OVER(PARTITION BY product) AS total_sales,
        -- 이동
        LAG(sales) OVER(PARTITION BY product ORDER BY date) AS prev_day
    FROM sales_data
)
SELECT * FROM analysis WHERE rn <= 3;

--

재귀 CTE (Common Table Expression)
WITH RECURSIVE 이름 AS (
    ① 시작값 (Anchor)
    UNION ALL
    ② 반복될 부분 (Recursive)
)


-- 1. 부서별 급여 1위 찾기
ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS rank[web:15]

-- 2. 월별 매출 상위 3개 상품
ROW_NUMBER() OVER(PARTITION BY sale_month ORDER BY total_sales DESC) AS monthly_rank[web:19]

-- 3. 고객별 최근 주문순
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date DESC) AS recent_order[web:13]

-- 4. 카테고리별 리뷰 평점 순위
ROW_NUMBER() OVER(PARTITION BY category ORDER BY avg_rating DESC) AS category_rank[web:18]

-- 5. 팀별 실적 순위 (공동 1위 허용)
RANK() OVER(PARTITION BY team_id ORDER BY performance DESC) AS team_rank[web:14]

-- 6. 연도별 신규 가입자 순위
ROW_NUMBER() OVER(PARTITION BY signup_year ORDER BY new_users DESC) AS yearly_rank[web:20]

-- 7. 매장별 방문자 랭킹 (동점시 순위 유지)
DENSE_RANK() OVER(PARTITION BY store_id ORDER BY visitors DESC) AS store_rank[web:14]

-- 8. 제품별 매출 성장률 순위
ROW_NUMBER() OVER(PARTITION BY product_type ORDER BY sales_growth DESC) AS growth_rank[web:20]

-- 9. 지역별 매출액 랭킹 (공지 우선)
ROW_NUMBER() OVER(PARTITION BY region ORDER BY is_priority DESC, revenue DESC) AS region_rank[web:13]

-- 10. 날짜별 일일 활성 사용자 순위
ROW_NUMBER() OVER(PARTITION BY activity_date ORDER BY dau DESC) AS daily_rank[web:20]
