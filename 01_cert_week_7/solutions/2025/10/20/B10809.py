# https://www.acmicpc.net/problem/10809
# 백준 10809번 - 알파벳 찾기

import sys

def solve():
    s = sys.stdin.readline().strip()
    # TODO: a~z 각각의 첫 등장 인덱스 출력 (없으면 -1)
    print(s[0])
    pass

if __name__ == "__main__":
    # 테스트용 데이터를 sys.stdin에 주입
    from io import StringIO
    sys.stdin = StringIO('take\n')
    solve()


