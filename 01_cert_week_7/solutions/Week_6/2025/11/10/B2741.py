# (Python)과제: 1부터 N까지 한 줄에 하나씩 출력하라
# Title: N 찍기 (BOJ 2741)
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/2741
# 설명: 자연수 N이 주어지면 1부터 N까지를 한 줄에 하나씩 출력하는 프로그램을 작성하라.
# 예제 입력
# 5
# 예제 출력
# 1
# 2
# 3
# 4
# 5


N = int(input().strip())

res = 0
for i in range(N):
    res += 1
    print(res)



# 💡 힌트:
#
# n = int(input())
# for i in range(1, n+1):
#     print(i)