# (Python)과제: 9개의 자연수 중 최댓값과 그 위치(1부터)를 출력하라
# Title: 최댓값 (BOJ 2562)
# Difficulty: EASY
# 원문 링크: https://www.acmicpc.net/problem/2562
# 설명: 서로 다른 9개의 자연수가 주어질 때, 최댓값과 그 값의 입력 순서 위치를 출력한다.
# 예제 입력
# 3
# 29
# 38
# 12
# 57
# 74
# 40
# 85
# 61
# 예제 출력
# 85
# 8

import sys

read = sys.stdin.readline()

max_val, max_pos = -1, -1

for i in range(1, 10):
    val = int(read)
    if val > max_val:
        max_val = val
        max_pos = i

print(max_val)
print(max_pos)

        
# [답지]
# Python PCCP 시험에 들어가는 답지
# ⌛경과 시간:
# 🛑오답 이유:
# 📜복기 :