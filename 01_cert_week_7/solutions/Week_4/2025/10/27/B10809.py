# (Python)과제: 주어진 소문자 문자열에서 a~z 각 알파벳의 첫 등장 인덱스를 공백으로 출력하라
# Title: BOJ 10809 알파벳 찾기
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/10809
# 예제 입력:
# baekjoon
# 예제 출력:
# 1 0 -1 -1 4 -1 -1 7 -1 -1 -1 -1 -1 -1 5 -1 -1 -1 -1 6 -1 -1 -1 -1 -1 -1

import sys
s = list(input().sys.stdin.readline().split())
a = 26
for i in range(a):

# [답지]
# Python PCCP 시험에 들어가는 답지
#
# import sys
#
# s = sys.stdin.readline().strip()
# pos = [-1] * 26
# for i, ch in enumerate(s):
#     idx = ord(ch) - 97 # 'a' -> 0
# if pos[idx] == -1:
#     pos[idx] = i
# print(*pos)
#
# ⌛경과 시간: 5분 경과
# 🛑오답 이유: 아예 모르는 문제
# 📜복기 :
# 1. 알파벳이 총 26개니까 길이 26짜리 리스트를 만들고
# 처음엔 전부 -1로 채움 : pos = [-1] * 26

# 2. 문자열을 한 글자씩 돌면서
# 그 문자의 알파벳 순서('a'=0, 'b'=1 ...)를 계산해서
# 그 위치에 처음 나온 인덱스만 기록한다.

# 3. 이미 한 번 기록한 문자는 바꾸지 않는다.
# (처음 등장 인덱스만 출력해야 하니까.)


s = sys.stdin.readline().strip()
pos = [-1] * 26
for i, ch in enumerate(s): # (인덱스, 문자) 순서대로 반복
    idx = ord(ch) - 97  # 'a'의 아스키값이 97 -> a=0, b=1, ...
    if pos[idx] == -1:  # 처음 등장한 문자면
        pos[idx] = i    # 그 위치 저장
print(*pos)             # 공백으로 출력

