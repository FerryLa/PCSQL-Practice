-- https://www.hackerrank.com/challenges/name-of-employees/problem
-- Title: Employee Names
-- Difficulty: Easy

(MySQL)과제: EMPLOYEE 테이블에서 모든 직원의 이름을 알파벳 오름차순으로 조회하라. 출력 컬럼은 NAME 하나만 사용한다.


SELECT name
FROM Employee
ORDER BY name ASC;

-- [답지]
-- 참고 스키마 예시: EMPLOYEE(employee_id, name, salary, ...)
-- SELECT name
-- FROM EMPLOYEE
-- ORDER BY name ASC;

-- ⌛경과 시간: 2분
-- 🛑오답 이유: 문제를 파악하는 시간이 오래 걸림
-- 📜복기 :