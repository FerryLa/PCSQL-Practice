# (Python)과제: 주어진 영어 단어에서 가장 많이 등장한 알파벳의 대문자를 출력하라. 단, 최빈 알파벳이 둘 이상이면 ?를 출력하라
# Title: 단어 공부 (BOJ 1157)
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/1157
# 예제 입력
# Mississipi
# 예제 출력
# ?
# 예제 입력 2
# zZa
# 예제 출력 2
# Z

# 복습만 하자.


# [답지]

from collections import Counter  # 문자 개수 세려고 가져옴

word = input().strip().upper()  # 공백 제거하고 대문자로 통일

counter = Counter(word)  # 알파벳 빈도 계산
max_cnt = max(counter.values())  # 가장 많이 등장한 횟수
candidates = [ch for ch, cnt in counter.items() if cnt == max_cnt]  # 최빈 알파벳 목록

if len(candidates) > 1:  # 최빈값이 여러 개면
    print("?")  # 물음표 출력
else:
    print(candidates[0])  # 하나면 그대로 출력


# Python PCCP 시험에 들어가는 답지
# (힌트) 모두 대문자(또는 소문자)로 통일 → 빈도 세기(dict or collections.Counter) → 최빈값이 여러 개인지 체크 → 출력

# ⌛경과 시간:
# 🛑오답 이유:
# 📜복기 :