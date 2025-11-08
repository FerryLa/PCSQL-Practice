# (Python)과제: <<윤년 판별하기>>
# [난이도] EASY | [원문] https://www.acmicpc.net/problem/2753
# [예제 입력]
# 2000
# [예제 출력]
# 1

import sys
def solve():
    year = int(sys.stdin.readline().strip())
    result = 0
    for i in year:
        if i % 100 == 0:
            if i % 4 == 0:
                if i % 400 == 0:
                  result = 1
                else : result = 0
            else : result = 1

    print(result)
if __name__ == "__main__":
    import io
    sys.stdin = io.StringIO('2000')
    solve()



# [답지]
# y = int(input())
# print(1 if (y % 400 == 0) or (y % 4 == 0 and y % 100 != 0) else 0)

# ⏳경과 시간: 10분 경과
# 🛑오답 이유: 윤년 규칙은 단순하다.
# 400으로 나누어떨어지면 윤년
# 그게 아니고 100으로 나누어떨어지면 평년
# 그게 아니고 4로 나누어떨어지면 윤년
# 나머지는 평년

# 📝복기 :
y = 0
result = 0
if y % 400 == 0:
    result = 1
else:
    if y % 100 == 0:
        result = 0
    else:
        if y % 4 == 0:
            result = 1

if result == 1:
    print('윤년')
else:
    print('평년')


print(1 if (y % 400 == 0) or (y % 4 == 0 and y % 100 != 0) else 0)



