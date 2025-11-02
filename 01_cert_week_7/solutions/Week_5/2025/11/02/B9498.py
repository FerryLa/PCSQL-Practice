# (Python)과제: 주어진 점수에 따라 학점을 출력하라
# Title: 시험 성적 (BOJ 9498)
# Difficulty: EASY
# 원문 링크: https://www.acmicpc.net/problem/9498
# 설명: 시험 점수가 90점 이상이면 A, 80~89점이면 B, 70~79점이면 C, 60~69점이면 D, 나머지는 F를 출력하라.
# 예제 입력
# 100
# 예제 출력
# A
# 예제 입력 2
# 73
# 예제 출력 2
# C

test = 0
def prac():
    if test >= 90:
        return 'A'
    elif test >= 80 or test <= 89:
        return 'B'
    elif test >= 70 or test <= 79:
        return 'C'
    elif test >= 60 or test <= 69:
        return 'D'
    else:
        return 'F'



# [답지]
# Python PCCP 시험에 들어가는 답지
# ⌛경과 시간: 1분?
# 🛑오답 이유: or이 아니라 AND 바보같은 실수 / 파이썬에서는 연속 비교식 가능 / test 전역변수 사용
# 📜복기 :

def prac(test):
    if test >= 90:
        return 'A'
    elif 80 <= test <= 89:
        return 'B'
    elif 70 <= test <= 79:
        return 'C'
    elif 60 <= test <= 69:
        return 'D'
    else:
        return 'F'

print(prac(100))  # A
print(prac(73))   # C
print(prac(55))   # F