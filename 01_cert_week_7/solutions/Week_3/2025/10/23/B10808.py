# (Python)과제: 주어진 문자열에서 각 알파벳의 개수를 세어 출력
#
# Title: 알파벳 개수
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/10808
# Example Input:
# baekjoon
# Example Output:
# 1 0 0 0 1 0 0 1 0 1 1 0 0 1 2 0 0 1 0 0 0 0 0 0 0 0

"""import sys

def solve():
    s = list(input().strip())

    count = 0
    for i in s:
        if i < len(s):
            count += 1
            continue
        else:
            break

    result = count
    print(result)

if __name__ == "__main__":
    from io import StringIO
    sys.stdin = StringIO('baekjoon')
    solve()"""




# [답지]
#
# 입력 처리...
#
# s = input().strip()
#
# 로직...
#
# count = [0] * 26
# for ch in s:
#     count[ord(ch) - ord('a')] += 1
#
# 출력...
#
# print(*count)
#
# ⌛경과 시간: 5분 경과
# 🛑오답 이유: 문제 요구 사항 이해 X
#              길이 세는 것이 아니라 26개 알파벳의 카운터 배열 필요
# 📜복기 :

import sys
def solve():
    s = input().strip()
    count = [0] * 26  # 26개 카운트 배열 필요
    for ch in s:
        count[ord(ch) - ord('a')] += 1  # 알파벳 개수 인덱스 설정
    print(*count)

if __name__ == "__main__":
    from io import StringIO
    sys.stdin = StringIO('baeckjoon')
    solve()


    # *count 이건 머하는 구문