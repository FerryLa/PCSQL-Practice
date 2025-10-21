-- [solvesql] Lv1. 모든 데이터 조회하기
/*
points 테이블은 프란시스 앤스컴이 만든 Anscombe's quartet 데이터를 담고 있습니다.
이 데이터는 quartet 컬럼에 의해 4개의 서브셋으로 나뉘어지고, 각 서브셋은 평균, 표본 분산,
상관계수 등이 거의 동일하나 데이터의 분포를 시각화하면 전혀 다른 분포를 가지는 특징이 있습니다.

points 테이블에 있는 모든 데이터를 조회하는 쿼리를 작성해주세요.
*/

SELECT *
FROM points

---------------------


-- [solvesql] Lv1. 일부 데이터 조회하기
/*
points 테이블에서 quartet 컬럼의 값이 I인 데이터만 조회하는 쿼리를 작성해주세요.
*/

SELECT *
FROM points
WHERE quartet = 'I'

---------------------


-- [solvesql] Lv1. 데이터 정렬하기
/*
points 테이블에서 quartet 컬럼의 값이 I인 데이터만 조회하되,
y 컬럼의 값을 기준으로 오름차순 정렬이 되도록 쿼리를 작성해주세요.
*/

SELECT
    *
FROM
    points
WHERE
    quartet = 'I'
ORDER BY
    y