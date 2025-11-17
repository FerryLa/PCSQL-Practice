# (Python)과제: 주어진 점수들의 평균을 조작하여 새로운 점수를 구하고, 그 평균을 출력하라
# Title: 평균 (BOJ 1546)
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/1546
# 설명: 시험 점수들을 입력받아, 가장 높은 점수를 M이라 할 때 모든 점수를 (점수 / M * 100) 으로 바꾼 후 새로운 평균을 구하라.

# 예제 입력
# 40 80 60

# 예제 출력
# 75.0


score = list(map(int, input().strip()))
ints = []
res = 0
for i in score:
    M = 0
    for j in score:
        if M < j:
            M = j
        else: pass

    ints = i / M * 100

res = ints/range(score)


# [답지]
# n = int(input())                    # 과목 개수
# scores = list(map(int, input().split()))   # 점수 리스트 입력
# m = max(scores)                     # 최고 점수 구하기
# new_scores = [(x / m) * 100 for x in scores]
# avg = sum(new_scores) / n           # 평균 계산
# print(avg)                          # 결과 출력


# [풀이]
# max()와 sum() 기본 내장함수라는 것이 있군
# list comprehension 리스트 컴프리헨션을 자꾸 익숙하게 느끼도록 해야 함
# 리스트 나누기는 split이다 실수 하지말것 /
# 문법 이해 : 리스트 지정 list(map(int, ...) / 리스트 컴프리헨션 ({x포함 값} for {x} in ...}

# [복기]
scores = list(map(int, input().split()))
m = max(scores)

n_scores = [x / M * 100 for x in scores]
avg = sum(n_scores) / len(scores)
print(avg)