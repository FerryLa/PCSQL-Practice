# https://www.acmicpc.net/problem/11720
# 백준 11720번 - 숫자의 합

import sys

def solve():
    _ = sys.stdin.readline()
    digits = sys.stdin.readline().strip()
    
    total = sum(int(d) for d in digits)
    print(total)

if __name__ == "__main__":
    from io import StringIO
    sys.stdin = StringIO('5\n54321\n')

    solve()


