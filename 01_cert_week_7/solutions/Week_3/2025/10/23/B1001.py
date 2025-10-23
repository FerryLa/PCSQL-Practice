# (Python)과제: 두 수 A와 B를 입력받아 A-B를 출력
#
# Title: A-B
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/1001
# Example Input:
# 3 2
# Example Output:
# 1

"""
import sys
def solve():
    a, b = map(int, input().strip())
    print(a-b)
    pass

if __name__ == "__main__":
    from io import StringIO
    sys.stdin = StringIO('3 2\n')
    solve()
"""

# [답지]
#
# 입력 처리...
#
# a, b = map(int, input().split())
#
# 로직...
#
# result = a - b
#
# 출력...
#
# print(result)
#
# ⌛경과 시간: 03:47
# 🛑오답 이유: 파이썬 구문 오류 - 입력 파싱에서 문자열을 정수 쌍으로 나누지 못함
# 그래서 공백 분리 구문 사용 a, b = map(int, input().split()) / 그리고 불필요한 pass, StringIO 제거,, 코테 준비하는 거다.
# 📜복기 : 입력 문자열은 무조건 split()으로 자르고 매핑

import sys
def solve():
    a, b = map(int, input().split())
    print(a - b)

if __name__ == "__main__":
    from io import StringIO
    sys.stdin = StringIO('3 2\n')
    solve()

# 불필요한 pass, StringIO 스텁 제거하고 표준 입력 사용. 라고 했는데 그럼 어떻게 입력값을 출력하나요?