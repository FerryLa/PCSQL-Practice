# (Python)과제: 그룹 단어란 단어에 존재하는 모든 문자에 대해서, 각 문자가 연속해서 나타나는 경우만을 말한다.
# 예를 들면, ccazzzzbb는 c, a, z, b가 모두 연속해서 나타나고, kin도 k, i, n이 연속해서 나타나기 때문에 그룹 단어이지만,
# aabbbccb는 b가 떨어져서 나타나기 때문에 그룹 단어가 아니다.
# 단어 N개를 입력으로 받아 그룹 단어의 개수를 출력하는 프로그램을 작성하시오.
# Title: 그룹 단어 체커 (BOJ 1316)
# Difficulty: MEDIUM
# Link: https://www.acmicpc.net/problem/1316
# 설명: 그룹 단어란 같은 알파벳이 연속한 하나의 구간으로만 등장하는 단어다. 예를 들어 ccazzzzbb는 그룹 단어지만,
# aabbbccb는 그룹 단어가 아니다. 첫 줄에 단어 개수 N, 이어서 N개의 소문자 단어가 주어졌을 때 그룹 단어의 개수를 출력하라.

# 예제 입력
# 4
# aba
# abc
# a
# abca

# 예제 출력
# 2

n = int(input().strip())
answer = 0

for _ in range(n):
    word = input().strip()
    seen = set()          # 이미 나온 적 있는 문자들
    prev = ''             # 바로 이전 문자
    is_group = True       # 그룹 단어인지 여부

    for ch in word:
        if ch != prev:        # 문자가 바뀌는 순간에만 체크
            if ch in seen:    # 전에 나온 적 있는 문자가 다시 나타남 → 그룹 단어 아님
                is_group = False
                break
            seen.add(prev)    # 이전 문자를 '완전히 끝난 문자'로 처리
            prev = ch

    if is_group:
        answer += 1

print(answer)





# 🗝️ 힌트
# 각 단어에 대해 이전 문자와 현재 문자가 달라지는 순간에만 “등장한 적 있는 문자”를 체크해라.
# 이미 본 문자가 다시 등장하면 그 단어는 실패.
# 한 단어 통과 시 카운트 +1.

