
-- LIKE 단순 패턴 매칭
-- 단순 와일드 카드 / %(0개 이상 문자), _(1개 문자) 두 개밖에 모른다.
city LIKE 'A%'   -- A로 시작
city LIKE '%a'   -- a로 끝
city LIKE '%oo%' -- 중간에 oo 포함


-- REGEXP 진짜 정규식 검색

city REGEXP '^[aeiou]'     -- 모음으로 시작하는 모든 문자열
ex) SELECT 'apple' REGEXP '^a'; -- 일치
ex) SELECT 'banana' REGEXP '^a'; -- 불일치

city REGEXP 'a$'           -- a로 끝
city REGEXP '(on|an)$'     -- on 또는 an으로 끝


/*
-- 그 외 문법 --
^	문자열 시작	'apple' REGEXP '^a'
$	문자열 끝	'data' REGEXP 'a$'
.   임의의 한 글자    'cat' REGEXP 'c.t' (cat, cot, cut)
[]  문자 집합     'dog' REGEXP '[aeiou]' (모음 존재)
[^] 부정 문자 집합    'sky' REGEXP '[^aeiou]' (모음 제외 문자 존재) -- 햇갈릴수도 있겄따 ^[]랑 [^]
*   0회 이상 반복 'boo' REGEXP 'bo*' (b, bo, boo, booo)
?   0 또는 1회     'bat' REGEXP 'ba?t' (bat, bt)
{m,n}   반복 횟수 지정    '111' REGEXP '1{2,3}'   (2~3회 반복)
()  그룹 `'abc' REGEXP '(ab cd)c'`

-- REGEXP_LIKE / MySQL 8.0 이상 --
REGEXP_LIKE(col, '패턴', '옵션')
'i' (대소문자 무시), 'c' (구분), 'm' (멀티라인) 등