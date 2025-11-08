# (Python)과제: 정수 N개로 이루어진 수열 A와 정수 X가 주어진다. 이때, A에서 X보다 작은 수를 모두 출력하는 프로그램을 작성하시오.
# Title: X보다 작은 수
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/10871
# 조건:
# 첫째 줄에 N과 X가 주어진다. (1 ≤ N, X ≤ 10,000)
# 둘째 줄에 수열 A를 이루는 정수 N개가 주어진다. 주어지는 정수는 모두 1보다 크거나 같고, 10,000보다 작거나 같은 정수이다.
# 예제 입력:
# 10 5
# 1 10 4 9 2 3 8 5 7 6
# 예제 출력:
# 1 4 2 3

import sys

input = sys.stdin.readline

N, X = map(int, input().split())

res = []
for a in A:
    if a < X:
        res.append(a)

print(*res)  # 공백 구분, 끝에 공백 없음


# [답지]
# Python PCCP 시험에 들어가는 답지
# ⌛경과 시간: 15분 초과
# 🛑오답 이유: 미숙,, 외우자 input = sys.stdin.readline / N, X = map(int, input().split()) 여러 정수 받기 / list(int, input().split()) 정수 리스트 받기
# 📜복기 : 리스트 컴프레션 사용 가능 // join문을 이용하여 쉬운 printing

import sys
input = sys.stdin.readline

N, X = map(int, input().split())
A = [int(input()) for _ in range(N)] # A <- N개 만큼 for문(줄바꿈)

res = [str(a) for a in A if a < X]
print(" ".join(res))
