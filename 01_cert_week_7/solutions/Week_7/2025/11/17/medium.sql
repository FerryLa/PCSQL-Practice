# (MySQL)과제: EMPLOYEE와 DEPARTMENT 테이블을 이용해,
# 각 부서(dept_id)별 총 급여 합계(total_salary)를 구하고,
# "전체 부서들의 평균(total_salary 평균)"보다 더 큰 부서만 조회하라.

# 출력 컬럼:
# - dept_name
# - total_salary
# 정렬: total_salary 내림차순, dept_name 오름차순.

# -- Title: Departments Earning Above Department-Average Total (변형)
# -- Difficulty: MEDIUM
# -- Link: https://example.local/sql/dep-sum-above-avg

# -- Schema hint:
# --   DEPARTMENT(dept_id INT PRIMARY KEY, dept_name VARCHAR(100))
# --   EMPLOYEE(emp_id INT PRIMARY KEY, emp_name VARCHAR(100), dept_id INT, salary INT)
#
# -- Sample rows:
# --   INSERT INTO DEPARTMENT VALUES (1,'IT'),(2,'HR'),(3,'Sales');
# --   INSERT INTO EMPLOYEE VALUES
# --     (1,'Alice','IT',9000),
# --     (2,'Bob','IT',8200),
# --     (3,'Carol','HR',7000),
# --     (4,'Dave','HR',6800),
# --     (5,'Eve','Sales',9500),
# --     (6,'Frank','Sales',9100);

-- 한줄 요약 : 각 dept_id별 total_salary를 구하고, 전체 dept_id의 평균 total_salary보다 더 큰 부서만 조회


  SELECT dept_id, salary




SELECT
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.dept_id = d.dept_id
GROUP BY
HAVING
(
 SELECT dept_id, SUM(salary) AS total_salary
 FROM EMPLOYEE
 GROUP BY dept_id
) > AVG(total_salary)
ORDER BY

# -- [답지]


# -- ⌛ 경과 시간: 25분 초과
# -- 🛑 오답 이유:
# -- 📜 복기 :

-- 한줄 요약 : 각 dept_id별 total_salary를 구하고, 전체 dept_id의 평균 total_salary보다 더 큰 부서만 조회

-- # 부서별 합계
SELECT d.dept_id, d.dept_name, SUM(e.salary) AS total_salary
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.dept_id = d.dept_id
GROUP BY dept_id, dept_name

-- 정답지는 이렇게 작성
SELECT dept_name, total_salary
FROM (
  SELECT d.dept_id, d.dept_name, SUM(e.salary) AS total_salary
  FROM EMPLOYEE e
  JOIN DEPARTMENT d ON e.dept_id = d.dept_id
  GROUP BY d.dept_id, d.dept_name
) AS dept_sum   -- FROM 뒤에 오는 서브쿼리는 별칭을 가져야 한다.
WHERE total_salary > (
  SELECT AVG(total_salary)
  FROM (
    SELECT dept_id, SUM(salary) AS total_salary
    FROM EMPLOYEE
    GROUP BY dept_id
  ) AS dept_avg -- 까먹을 수도 있으니 FROM 뒤에 오는 서브쿼리는 별칭을 가져야 한다.
)
ORDER BY total_salary DESC, dept_name ASC;