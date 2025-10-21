# B2-1: 10430 나머지
# 문제 설명:
#   세 정수 A, B, C가 주어질 때 다음 네 값을 차례대로 출력하라.
#     1) (A + B) % C
#     2) ((A % C) + (B % C)) % C
#     3) (A * B) % C
#     4) ((A % C) * (B % C)) % C
#
# 입력 형식:
#   한 줄에 A B C (정수) 가 공백으로 주어진다.
#
# 출력 형식:
#   위 네 값을 각 줄에 하나씩 출력한다.
#
# 제약(참고):
#   2 ≤ A, B, C ≤ 10000
#
# 예제:
#   입력: 5 8 4
#   출력:
#     1
#     1
#     0
#     0
import sys

def solve():
    # TODO: 위 설명대로 계산해서 4줄 출력
    a, b, c = map(int, sys.stdin.readline().split())
    print((a + b) % c)
    print(((a % c) + (b % c)) % c)
    print((a * b) % c)
    print(((a % c) * (b * c)) % c)
    # a, b, c = map(int, sys.stdin.readline().split())
    # print((a + b) % c)
    # print(((a % c) + (b % c)) % c)
    # print((a * b) % c)
    # print(((a % c) * (b % c)) % c)
    pass

if __name__ == "__main__":
    # 로컬 테스트 (기대값 비교)
    from io import StringIO
    from contextlib import redirect_stdout
    test_in = "5 8 4\n"
    expected = "1\n1\n0\n0\n"
    sys.stdin = StringIO(test_in)
    import io
    buf = io.StringIO()
    with redirect_stdout(buf):
        solve()
    out = buf.getvalue()
    print("[10430] 기대값:\n" + expected + "[10430] 실행값:\n" + out + "[10430] 결과:", "OK" if out == expected else "NG")

###

# B2-2: 2588 곱셈
# 문제 설명:
#   세 자리 자연수 A, B가 주어진다. 다음을 순서대로 출력하라.
#     1) A × (B의 일의 자리)
#     2) A × (B의 십의 자리)
#     3) A × (B의 백의 자리)
#     4) A × B
#
# 입력 형식:
#   첫째 줄에 A
#   둘째 줄에 B
#
# 출력 형식:
#   위 4개의 값을 각 줄에 하나씩 출력한다.
#
# 제약(참고):
#   100 ≤ A, B ≤ 999
#
# 예제:
#   입력:
#     472
#     385
#   출력:
#     2360
#     3776
#     1416
#     181720
import sys

def solve():
    # TODO: 자리수 접근(문자열 인덱싱) 또는 //, % 로 계산
    a = int(sys.stdin.readline().strip())
    b = sys.stdin.readline().strip()
    print(a * int(b[2]))
    print(a * int(b[1]))
    print(a * int(b[0]))
    print(a * int(b))
    # a = int(sys.stdin.readline().strip())
    # b = sys.stdin.readline().strip()
    # print(a * int(b[2]))
    # print(a * int(b[1]))
    # print(a * int(b[0]))
    # print(a * int(b))
    pass

if __name__ == "__main__":
    from io import StringIO
    from contextlib import redirect_stdout
    test_in = "472\n385\n"
    expected = "2360\n3776\n1416\n181720\n"
    sys.stdin = StringIO(test_in)
    import io
    buf = io.StringIO()
    with redirect_stdout(buf):
        solve()
    out = buf.getvalue()
    print("[2588] 기대값:\n" + expected + "[2588] 실행값:\n" + out + "[2588] 결과:", "OK" if out == expected else "NG")


# B2-6: 2884 알람 시계
# 입력: H M (0 ≤ H ≤ 23, 0 ≤ M ≤ 59)
# 요구: 현재 시각에서 45분 앞당긴 시각을 출력

import sys

def solve():
    # TODO: 한 줄에 H, M 읽기
    H, M = map(int, sys.stdin.readline().split())
    M -= 45

    # TODO: 45분 감소 처리 (분이 음수가 되면 시(hour)에서 1 빼고 60 더하기)
    if M < 0:
        H -= 1
        M += 60

        # TODO: 시가 음수가 되면 23으로 순환 (하위행)
        if H < 0:
            H = 23

    # TODO: 조정된 H, M 출력
    print("H = ", H, ", M = ", M)
    pass

if __name__ == "__main__":
    # 로컬 테스트: 기대값도 "그냥 출력"으로 먼저 찍음, 그다음 네 결과가 바로 이어서 찍힘
    from io import StringIO
    sys.stdin = StringIO("10 10\n")   # 입력 예시
    print("기대값: 9 25")                     # 기대 출력 (레이블 없음)
    solve()                           # 네 출력 (직접 구현해서 확인)
