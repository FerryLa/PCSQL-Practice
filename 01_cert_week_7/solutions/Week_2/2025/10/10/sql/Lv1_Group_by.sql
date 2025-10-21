-- Suppliers에서 도시 목록을 “중복 없이 알파벳순”
-- 으로 뽑으려면, DISTINCT 버전 한 줄로 써봐.

SELECT DISTINCT Country FROM Suppliers WHERE Country ASC;
