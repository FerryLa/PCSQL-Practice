
# https://www.acmicpc.net/problem/2675
# 백준 2675번 - 문자열 반복

import sys

def solve():
    t = int(sys.stdin.readline())

    # TODO: 각 테스트케이스: R S -> 문자 S의 각 글자를 R번 반복해 출력
    for _ in range(t):
        line = sys.stdin.readline().split()
        r = int(line[0])
        s = line[1]

        result = ""
        for char in s:
            result += char * r
        print(result)

if __name__ == "__main__":
    from io import StringIO
    sys.stdin = StringIO("3\n3 ABC\n5 /HTP\n 6 TAKE")
    solve()


# 풀이 : 테스트케이스 t를 넣어주는 이유는 프로그램이 언제 멈춰야 할지 알기 위해서
# 그래서 break로 처리해줘야 한다. 또, line으로 한 번에 입력값을 받아서 split을 이용하여
# 공백을 사이로 구분해서 두 가지 입력값을 받는다.
# 두 가지 입력 받은 것을 for문을 이용하여 (파이썬에서 for문은 더이상 꺼낼게 없을 때 종료)
# 문자 s를 개수 r만큼 result에 담아주고 main 실행문에서 sys.stdin = StringIO()문에서
# 괄호에 (테스트케이스 개수(t) \n r s) 식으로 넣어준다.