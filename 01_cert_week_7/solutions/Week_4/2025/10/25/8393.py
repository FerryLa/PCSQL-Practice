# (Python)과제: N개의 줄에 걸쳐 입력되는 정수를 모두 더해 출력

# Title: 합
# Difficulty: EASY
# Link: https://www.acmicpc.net/problem/8393
# Example Input:
# 3
# 1
# 2
# 3
# Example Output:
# 6
import sys
read = sys.stdin.readline

def solve():
    n = int(sys.stdin.readline())      # 첫 줄: 줄 개수
    total = 0
    for _ in range(n):
        x = int(sys.stdin.readline().strip())  # 각 줄 정수 하나
        total += x                # ???: 누적
    print(total)

if __name__ == "__main__":
    import io
    sys.stdin = io.StringIO('''3
    12
    33
    44
    ''')
    solve()






# - [답지]
# 입력 처리...
# n = int(input())
# total = 0
# for _ in range(n):
#     total += int(input())
# 로직...
# (누적합 완료)
# 출력...
# print(total)

# ⌛경과 시간:
# 🛑오답 이유:
# 📜복기 :
