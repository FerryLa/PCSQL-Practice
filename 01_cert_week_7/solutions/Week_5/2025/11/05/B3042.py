# (Python)과제: 두 자연수 A와 B가 있을 때, A%B는 A를 B로 나눈 나머지 이다. 예를 들어, 7, 14, 27, 38을 3으로 나눈 나머지는 1, 2, 0, 2이다.
# 수 10개를 입력받은 뒤, 이를 42로 나눈 나머지를 구한다. 그 다음 서로 다른 값이 몇 개 있는지 출력하는 프로그램을 작성하시오.
# Title: 나머지
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/3052
# 입력: 첫째 줄부터 열번째 줄 까지 숫자가 한 줄에 하나씩 주어진다. 이 숫자는 1,000보다 작거나 같고, 음이 아닌 정수이다
# 예제 입력:
# 1
# 2
# 3
# 4
# 5
# 6
# 7
# 8
# 9
# 10
# 출력: 첫째 줄에, 42로 나누었을 때, 서로 다른 나머지가 몇 개 있는지 출력한다.
# 예제 출력:
# 10

import sys

input = sys.stdin.readline

A = [int(input()) for _ in range(10)]
B = int, input().split()

res = [int(a) for a in A if int(-1 < a <= 1000)]
...

# [답지]
# Python PCCP 시험에 들어가는 답지
# ⌛경과 시간: 15분 초과
# 🛑오답 이유:
# 📜복기 : 컴프리헨션과 중복제거(unique)로 간단하게 처리

# 리스트 컴프레션
# A = [int(input()) for _ in range(N)]
# ===
# A = []
# for _ in range(N):
#     A.append(int(input()))


A = [int(input()) for _ in range(10)]    # 10개 입력
remainders = [x % 42 for x in A]         # 나머지 리스트
unique = set(remainders)                 # 중복 제거
print(len(unique))
