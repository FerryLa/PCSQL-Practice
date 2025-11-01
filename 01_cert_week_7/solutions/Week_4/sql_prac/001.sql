🧩 문제 1

EMPLOYEES 테이블과 DEPARTMENTS 테이블이 있다.

(EMPLOYEES 테이블)
EMP_ID	DEPT_ID	SALARY	JOB_ID
E1	D1	3000	J1
E2	D1	2500	J2
E3	D2	4000	J1
E4	D3	2000	J1
E5	D3	1500	J2

(DEPARTMENTS 테이블)
DEPT_ID	DEPT_NAME
D1	SALES
D2	IT
D3	HR

문제:
각 부서별로 J1 직무의 평균 급여를 구하고, 그 평균이 2500 이상인 부서의 이름과 평균 급여를 출력하시오.
힌트: GROUP BY, HAVING, JOIN 중 어떤 게 필요한지부터 판단해봐.

SELECT e.name, AVG(e.salary) avg_salary
FROM employee e
WHERE e.job_id = 'J1'
GROUP BY DEPARTMENTS d
HAVING AVG(salary) >= 2500;
