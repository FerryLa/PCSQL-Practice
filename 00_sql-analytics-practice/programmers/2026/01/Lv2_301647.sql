-- Site   : Programmers
-- Title  : 부모의 형질을 모두 가지는 대장균 찾기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/301647
-- Date   : 2026-01-03

-- SELECT E.ID, E.GENOTYPE, S.GENOTYPE PARENT_GENOTYPE
-- FROM ECOLI_DATA E
-- JOIN ECOLI_DATA S ON E.PARENT_ID = S.ID
-- WHERE (E.GENOTYPE & S.GENOTYPE) = 1
-- ORDER BY ID;

-- 시간 10분 복기 다시

SELECT E.ID, E.GENOTYPE, S.GENOTYPE AS PARENT_GENOTYPE
FROM ECOLI_DATA E  -- E: 자식 행
JOIN ECOLI_DATA S ON E.PARENT_ID = S.ID  -- PARENT_ID = 부모.ID
WHERE (E.GENOTYPE & S.GENOTYPE) = S.GENOTYPE  -- 자식이 부모 형질 모두 상속 ex) 11000 & 11010 이면 11010이 자식행으로 11000의 부모행을 모두 가짐
ORDER BY E.ID;

-- 11000 & 11010 이면 11010이 자식행으로 11000의 부모행을 모두 가짐
-- JOIN으로 기존 행 뒤에 부모 형질 붙이기 위해서는, 기존 행 PARENT_ID와 부모 행 ID로 JOIN
-- &말고도 |도 가능  왜냐면 부모의 형질을 모두 가진다는 것은 부모의 형질이 1인 부분은 자식도 1이어야 하기 때문
