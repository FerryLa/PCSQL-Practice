# (Python)과제: 10개의 정수를 입력받아 42로 나눈 나머지의 서로 다른 값의 개수를 출력하라
# Title: BOJ 3052 나머지
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/3052
# 예제 입력:
# 42
# 84
# 252
# 420
# 1
# 2
# 3
# 4
# 5
# 6
# 예제 출력:
# 7



import sys

mods = set()
for _ in range(10):
    n_str = sys.stdin.readline()
    n = int(n_str)
    mods.add(n % 42)
    print(len(mods))


# [답지]
# Python PCCP 시험에 들어가는 답지
#
# import sys
#
# mods = set()
# for _ in range(10):
#     n = int(sys.stdin.readline())
# mods.add(n % 42)
# print(len(mods))
#
# ⌛경과 시간: 5분 초과
# 🛑오답 이유: mods = set() set에 대한 이해 -> set은 "무엇이 들어 있냐", map은 "어떻게 바꿀까?"
# Set은 중복제거 + 순서없음 /  map은  '1' → 1로 바꾸긴 하지만 순서는 유지
# 📜복기 : 따라서 len(set(num)은 set으로 중복제거 한 길이 즉, 중복제거된 num의 개수

import sys
mods = set()

for _ in range(10):
    n_str = sys.stdin.readline()
    n = int(n_str)
    mods.add(n % 42)

print(len(set(n)))
