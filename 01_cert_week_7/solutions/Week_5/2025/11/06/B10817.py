# (Python)과제: 세 정수 A, B, C가 주어진다. 이때, 두 번째로 큰 정수를 출력하는 프로그램을 작성하시오.
# Title: 세 수
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/10817
# 예제 입력:
# 20 30 10
# 예제 출력:
# 20

import sys
input = sys.stdin.readline
A, B, C = map(int(input().split()))

if A > B:
    if A < C:
        print(A)
    else:
        print(C)
else:
    print(B)



# [답지]
# Python PCCP 시험에 들어가는 답지
# ⌛경과 시간: 5분 초과 이걸로?...
# 🛑오답 이유:
# 📜복기 :