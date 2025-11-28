# (Python)과제: 주어진 단어가 팰린드롬인지 판별하라
# Title: 팰린드롬인지 확인하기 (BOJ 10988)
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/10988
# 설명: 단어를 입력받아, 그 단어가 앞뒤가 똑같은 문자열(팰린드롬) 인지 판별한다.
# 같으면 1, 아니면 0을 출력한다.

# 예제 입력
# level
# 예제 출력
# 1

# 예제 입력 2
# baekjoon
# 예제 출력 2
# 0

# 다운 for문이랑 업 for문을 비교해서 같으면 되겠네요
# import sys
# input = sys.stdin.readline
#
# string = input().split()
# front = []
# back = []
# for _ in range(input):
#     front


# s = input().strip()
s = 'level'
if s == s[::-1]:
    print(1)
else:
    print(0)

# 슬라이스 사용법으로 [:3] 이런 식으로 앞부분을 생략하면 처음부터 3까지 가져온다.
# [::]괄호 안에는 인덱스의 위치를 [시작:끝:위치] 이런 방식으로 입력해준다.