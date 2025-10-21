# (Python)과제: 두 정수 A와 B를 입력받아 A+B를 출력

# Title: A+B
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/1000
# I/O 예시
# 입력: 1 2
# 출력: 3

import sys

def solve():
    a, b = map(int, sys.stdin.readline().split())
    print(a + b)

if __name__ == "__main__":
    from io import StringIO
    sys.stdin = StringIO('3 4\n')
    solve()







# [답지]
# 입력 처리...
# a, b = map(int, input().split())
# 로직...
# result = a + b
# 출력...
# print(result)

# ⌛경과 시간:
# 🛑오답 이유:
# 📜복기 :
