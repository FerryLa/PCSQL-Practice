# (Python)과제: 주어진 정수 N이 소수인지 판별
#
# Title: 소수 판별
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/1978

# Example Input:
# 4
# 1 3 5 7

# Example Output:
# 3

# import sys
# def solve():
#     num = int(input())
#     nums = list(map(int, input().split()))
#
#     count = 0
#     for i in nums:
#         if i > 1:
#             i % 3 ==
#             count += 1
#
# if __name__ == "__main__":

# [답지]
# 입력 처리...
# n = int(input())
# nums = list(map(int, input().split()))
# 로직...
# count = 0
# for num in nums:
#     if num > 1:
#     for i in range(2, int(num ** 0.5) + 1):
#     if num % i == 0:
#     break
# else:
# count += 1
# 출력...
# print(count)
#
# ⌛경과 시간: 5분 초과
# 🛑오답 이유: 소수 판별식 도출 실패
# 📜복기 : int(num ** 0.5)는 제곱근 식
# 어떤 수의 약수는 제곱근을 기준으로 쌍으로 나오기 때문에

import sys

def solve():
    n = int(input())
    nums = list(map(int, input().split()))

    count = 0
    for num in nums:
        if num > 1:
            # 2부터 int(num ** 0.5)까지 나눠보고, 하나도 안 나누어 떨어지면 소수
            for i in range(2, int(num ** 0.5) + 1):
                if num % i == 0:
                    break
            else:
                count += 1

    print(count)



if __name__ == "__main__":
    from io import StringIO
    sys.stdin = StringIO('4\n 1 3 5 7\n')
    solve()
