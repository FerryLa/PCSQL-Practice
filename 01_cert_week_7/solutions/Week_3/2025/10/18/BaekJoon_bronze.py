# B1-1: 2557 Hello World
# 핵심: 출력 기본
import sys

def solve():
    # TODO: 'Hello World!' 정확히 한 줄 출력
    # 힌트: print("Hello World!")

    print("Hello World!")
    pass


def main():
    solve()

if __name__ == "__main__":
    # 로컬 테스트
    from io import StringIO
    sys.stdin = StringIO("")  # 입력 없음
    solve()

# B1-2: 1000 A+B
# 두 정수 A와 B를 입력받은 다음, A+B를 출력하는 프로그램을 작성하시오.
# 핵심: 한 줄 입력, 공백 분리, 정수 변환
import sys

def solve():
    line = sys.stdin.readline().strip()
    a, b = map(int, line.split())
    # TODO: a와 b의 합을 출력
    print(a+b)
    pass

def main():
    solve()

if __name__ == "__main__":
    # 로컬 테스트
    from io import StringIO
    sys.stdin = StringIO("1 8\n")
    solve()   # 기대 출력: 9

# B1-3: 9498 시험 성적
# 시험 점수를 입력받아 90 ~ 100점은 A, 80 ~ 89점은 B, 70 ~ 79점은 C,
# 60 ~ 69점은 D, 나머지 점수는 F를 출력하는 프로그램을 작성하시오.
# 핵심: 조건문 분기
import sys

def solve():
    n = int(sys.stdin.readline().strip())
    # TODO: 90~100:A, 80~89:B, 70~79:C, 60~69:D, 나머지:F
    if n <= 100 and n >= 90 :
        print('A')
    elif n <= 89 and n >= 80 :
        print('B')
    elif n <= 79 and n >= 70 :
        print('C')
    elif n <= 69 and n >= 60 :
        print('D')
    else:
        print('F')
    # 힌트: if-elif-else 사다리
    pass

def main():
    solve()

if __name__ == "__main__":
    # 로컬 테스트
    from io import StringIO
    for v in [100, 85, 73, 61, 42]:
        sys.stdin = StringIO(str(v) + "\n")
        solve()  # 기대: A B C D F

# B1-4: 2753 윤년
#시간 제한: 1초 메모리 제한: 128MB
# 연도가 주어졌을 때, 윤년이면 1, 아니면 0을 출력하는 프로그램을 작성하시오.
# 윤년은 연도가 4의 배수이면서, 100의 배수가 아닐 때 또는 400의 배수일 때이다.
# 예를 들어, 2012년은 4의 배수이면서 100의 배수가 아니라서 윤년이다.
# 1900년은 100의 배수이고 400의 배수는 아니기 때문에 윤년이 아니다.
# 하지만, 2000년은 400의 배수이기 때문에 윤년이다.
# 핵심: 논리식 결합
import sys

def is_leap(year: int) -> int:
    # TODO:
    if year % 400 == 0:
        return 1
    elif year % 4 == 0 and year % 100 != 0:
        return 1
    else:
        return 0

    # 윤년이면 1, 아니면 0  (지구 공전 주기: 365.2422일)
    # 규칙: (4의 배수이면서 100의 배수 아님) 또는 (400의 배수)
    # 힌트: and, or, not 대신 파이썬은 논리연산자 그대로 씀
    pass

def solve():
    y = int(sys.stdin.readline().strip())
    print(is_leap(y))

def main():
    solve()

if __name__ == "__main__":
    from io import StringIO
    tests = [(2000,1), (1999,0), (1900,0), (2012,1)]
    for y, expect in tests:
        sys.stdin = StringIO(str(y) + "\n")
        solve()  # 기대: expect 값들


# B1-5: 10871 X보다 작은 수
# 시간 제한: 1초 메모리 제한: 256MB
# 정수 N개로 이루어진 수열 A와 정수 X가 주어진다.
# 이때, A에서 X보다 작은 수를 모두 출력하는 프로그램을 작성하시오.
# 핵심: 여러 개 숫자 읽기, 필터링, 출력 포맷
import sys

def solve():
    n, x = map(int, sys.stdin.readline().split())
    arr = list(map(int, sys.stdin.readline().split()))
    # 보장: len(arr) == n
    # TODO: arr에서 x보다 작은 값만 뽑아 공백으로 구분해 한 줄 출력
    # <기본 for문 문법>
    # result = []
    # for num in arr:
    #     if num < x:
    #         result.append(str(num))

    # <리스트 컴프리헨션>
    result = [str(num) for num in arr if num < x]
    print(' '.join(result))
    # 힌트: 리스트 컴프리헨션 + join
    pass

def main():
    solve()

if __name__ == "__main__":
    from io import StringIO
    sys.stdin = StringIO("10 5\n1 10 4 9 2 3 8 5 7 6\n")
    solve()  # 기대 출력: 1 4 2 3