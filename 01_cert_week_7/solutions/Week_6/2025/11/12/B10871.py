# (Python)과제: 1부터 N까지 정수 중에서 X로 나누어떨어지는 수를 모두 출력하라
# Title: 나누어 떨어지는 수 찾기 (응용형)
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/10871
# (유사 문제 — X보다 작은 수)
# 설명: 정수 N과 X가 주어졌을 때, 1부터 N까지의 수 중에서 X로 나누어떨어지는 모든 수를 공백으로 구분해 출력한다.
# 예제 입력
# 10 3
# 예제 출력
# 3 6 9

N, X = map(input().strip())

for i in range(1, N+1):
    if i % X == 0:
        print(i + ' ')

# strip()은 개행(\n)을 제거해준다. 이제는 외워라
# input().split() -> "10, 3"과 같은 입력을 ["10", "3"]리스트로 쪼개준다. 말 그대로 개행문자를 기점으로 나눠서 리스트를 만들어준다.
# print(i, end=' ') 는 i를 출력하고, 그 뒤에 자동으로 줄바꿈하는 대신 ' ' 한 칸을 붙여라 라는 뜻으로 사용.
# 자바문에서 사용하는 i + ' '는 파이썬으로 해야한다.

# 복기: 전날꺼 복습하면서 해야겠다.

# 💡 답지
# n, x = map(int, input().split())
# for i in range(1, n + 1):
#     if i % x == 0:
#         print(i, end=' ')
