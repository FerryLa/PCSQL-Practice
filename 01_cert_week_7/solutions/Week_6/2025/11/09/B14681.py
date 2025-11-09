# (Python)과제: 두 정수의 좌표 (x, y)가 주어지면 점이 위치한 사분면 번호를 출력하라
# Title: 사분면 고르기 (BOJ 14681)
# Difficulty: EASY
# 원문 링크: https://www.acmicpc.net/problem/14681
# 예제 입력
# 10
# -3
# 예제 출력
# 4

import sys
x = int(input().strip())
y = int(input().strip())

if x > 0 and y > 0:
    print(1)
elif x < 0 and y > 0:
    print(2)
elif x < 0 and y < 0:
    print(3)
else: print(4)



# ⌛경과 시간:
# 🛑오답 이유:
# 📜복기 :