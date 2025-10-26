# (Python)과제: <<A+B 계산하기>>
# [난이도] EASY | [원문] https://www.acmicpc.net/problem/1000
# [예제 입력]
# 1 2
# [예제 출력]
# 3
import sys
def solve():
    a, b = map(int, sys.stdin.readline().split())
    print(a + b)

if __name__ == "__main__":
    import io
    sys.stdin = io.StringIO('''1 3''')
    solve()


# [답지]
# a, b = map(int, input().split())
# print(a + b)

# ⏳경과 시간: 5분
# 🛑오답 이유: 아직 sys 적응 안됨
# 추가로 split()이나 strip()이 들어가면 input과 readline은 똑같다. 개행제거의 차이기 때문이다.
# 📝복기 :

a, b = map(int, sys.stdin.readline().split())
print(a + b)