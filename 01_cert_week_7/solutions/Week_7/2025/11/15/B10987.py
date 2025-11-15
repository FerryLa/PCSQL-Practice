# (Python)과제: 문자열에서 모음(a, e, i, o, u)의 개수를 출력하라
# Title: 모음의 개수 (BOJ 10987)
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/10987
# 설명: 단어 하나가 주어질 때, 그 안에 포함된 모음(a, e, i, o, u)의 개수를 출력한다.
#
# 예제 입력
# baekjoon

# 예제 출력
# 4

# Python PCCP 시험 대비 풀이 예시
# 1. 문자열 입력 받기
# 2. 반복문으로 한 글자씩 확인
# 3. 해당 글자가 모음이면 카운트 증가
# 4. 총 개수 출력

s = input().strip()           # 문자열 입력받기
vowels = "aeiou"              # 모음 문자열
count = 0                     # 모음 개수 카운터

for ch in s:                  # 문자열의 각 문자를 순회
    if ch in vowels:          # 모음인지 확인
        count += 1            # 모음이면 카운트 +1

print(count)                  # 최종 결과 출력


# 💡 풀이 요약
# 핵심은 "aeiou"를 기준으로 in 연산자 사용
# 대문자 포함 입력일 땐 s.lower()로 통일해도 된다.
# 문자열 탐색 문제의 기본형, 시험에서도 “문자열 순회” 패턴으로 자주 나온다.