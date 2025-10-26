# (Python)과제: 테스트 케이스 T개에 대해 A+B를 출력 (각 줄에 두 수)

# Title: A+B - 3
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/10950
# Example Input:
# 5
# 1 1
# 2 3
# 3 4
# 9 8
# 5 2
# Example Output:
# 2
# 5
# 7
# 17
# 7

import sys

def solve():
    t = int(sys.stdin.readline())
    for _ in range(t):
        a, b = map(int, sys.stdin.readline().split())
        print(a + b)

if __name__ == "__main__":
#     import io
#     sys.stdin = io.StringIO("""7
# 1 1
# 2 3
# 3 4
# 9 8
# 5 2
# 3 6
# 1 12
# """)
    solve()




# [답지]
# 입력 처리...
# t = int(input())
# for _ in range(t):
#     a, b = map(int, input().split())
# 로직...
#     s = a + b
# 출력...
#     print(s)

# ⌛경과 시간:
# 🛑오답 이유:
# 📜복기 :
