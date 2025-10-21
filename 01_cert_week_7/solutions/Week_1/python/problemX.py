# Week_1/problemX.py
# PCCP 느낌의 5문제 (난이도 순서대로)
# 범위: 변수/계산, 조건문, 함수, 자료형, 문자열/리스트, for 반복문,
#       모듈(기본만), 딕셔너리 & 튜플 기초

from typing import List, Tuple, Dict, Optional

# ------------------------------------------------------------
# 토글: 풀이 공개/테스트 실행
#   False: 문제 스켈레톤만 사용 (네가 직접 구현)
#   True : 참고용 정답과 예시 테스트 실행
# ------------------------------------------------------------
SOLUTION_MODE = True


# ============================================================
# Problem 1) 합격 판정
# 설명: 국어/영어/수학 점수(0~100)를 받아 평균이 60 이상이고
#      모든 과목이 40 이상이면 "PASS", 아니면 "FAIL"을 반환하라.
# 시그니처: pass_or_fail(kor:int, eng:int, math:int) -> str
# 포인트: 조건문, 평균 계산, and/or
# ============================================================
import random

def pass_or_fail(kor: vars(int), eng: int, math: int) -> str:
    # TODO: 여기에 구현

    avg = (kor + eng + math) / 3

    if avg >= 60 :
        if kor >= 40 and eng >= 40 and math >= 40 :
            return "PASS"
        else:
            return "FAIL"
    return "FAIL"  # 임시 반환

list = [40, 50, 60, 70, 80, 90]
a = random.choice(list)

print(a);
print(pass_or_fail(a, 60, 50));


# ============================================================
# Problem 2) 3 또는 5의 배수 합
# 설명: 1부터 n까지의 정수 중 3 또는 5의 배수의 합을 구하라.
#       단, 15의 배수는 한 번만 더한다(중복 합산 금지).
# 시그니처: sum_of_multiples(n:int) -> int
# 포인트: for, if, continue
# ============================================================
def sum_of_multiples(n: int) -> int:
    # TODO: 여기에 구현
    total = 0
    for i in range(1, n+1):
        if i % 3 == 0 or i % 5 == 0:
            print(total)
            total += i
    return total;

print('합계: ', sum_of_multiples(50));

# ============================================================
# Problem 3) 중복 제거 후 오름차순
# 설명: 정수 리스트에서 중복을 제거한 뒤 오름차순으로 정렬한 새 리스트를 반환하라.
#       (set 미사용. 리스트와 in 만 사용)
# 시그니처: unique_sorted(nums:List[int]) -> List[int]
# 포인트: 리스트, membership, 정렬
# ============================================================
def unique_sorted(nums: List[int]) -> List[int]:
    # TODO: 여기에 구현
    uniq: List[int] = []
    for x in nums:
        if x not in uniq:
            uniq.append(x)
    uniq.sort()
    return uniq

print(unique_sorted([3, 1, 2, 3, 2, 1, 8, 9]))


# uniq = []
    # for x in nums:
    #     if x not in uniq:
    #         uniq.append(x)
    # uniq.sort()
    # return uniq


# ============================================================
# Problem 4) 주문 합계 집계
# 설명: 주문 목록이 (item:str, price:int|None) 튜플로 주어진다.
#       price 가 None 인 항목은 무시하고, 아이템별 총 가격 합계를 딕셔너리로 반환하라.
# 예: [("apple", 100), ("apple", None), ("pear", 200)] -> {"apple":100, "pear":200}
# 시그니처: merge_orders(orders:List[Tuple[str, Optional[int]]]) -> Dict[str,int]
# 포인트: 딕셔너리 누적, None 체크
# ============================================================
def merge_orders(orders: List[Tuple[str, Optional[int]]]) -> Dict[str, int]:
    # TODO: 여기에 구현
    # totals = {}
    # for name, price in orders:
    #     if price is None:
    #         continue
    #     if name not in totals:
    #         totals[name] = 0
    #     totals[name] += price
    # return totals
    return {}  # 임시 반환


# ============================================================
# Problem 5) 직원-매니저 매칭 (Self-Join 흉내)
# 설명: 직원 목록은 딕셔너리들의 리스트로 제공된다.
#   각 딕셔너리는 {"id":int, "name":str, "manager_id": Optional[int]} 형태.
#   직원 id 오름차순으로, (직원명, 매니저명 또는 None) 튜플 리스트를 반환하라.
# 시그니처: manager_pairs(employees:List[Dict[str, ...]]) -> List[Tuple[str, Optional[str]]]
# 포인트: 딕셔너리 조회, 보조 인덱스, None 처리
# ============================================================
def manager_pairs(employees: List[Dict[str, object]]) -> List[Tuple[str, Optional[str]]]:
    # TODO: 여기에 구현
    # id_to_name = {e["id"]: e["name"] for e in employees}
    # result = []
    # for e in sorted(employees, key=lambda x: x["id"]):
    #     mid = e["manager_id"]
    #     mname = id_to_name.get(mid) if mid is not None else None
    #     result.append((e["name"], mname))
    # return result
    return []  # 임시 반환


# ------------------------------------------------------------
# [SOLUTION] 참고 구현
#   풀이를 보고 싶으면 SOLUTION_MODE=True 로 바꿔 실행
# ------------------------------------------------------------
if SOLUTION_MODE:
    def pass_or_fail(kor: int, eng: int, math: int) -> str:
        avg = (kor + eng + math) / 3
        return "PASS" if (avg >= 60 and kor >= 40 and eng >= 40 and math >= 40) else "FAIL"

    def sum_of_multiples(n: int) -> int:
        total = 0
        for i in range(1, n + 1):
            if i % 3 == 0 or i % 5 == 0:
                total += i
        return total

    def unique_sorted(nums: List[int]) -> List[int]:
        uniq: List[int] = []
        for x in nums:
            if x not in uniq:
                uniq.append(x)
        uniq.sort()
        return uniq

    def merge_orders(orders: List[Tuple[str, Optional[int]]]) -> Dict[str, int]:
        totals: Dict[str, int] = {}
        for name, price in orders:
            if price is None:
                continue
            if name not in totals:
                totals[name] = 0
            totals[name] += int(price)
        return totals

    def manager_pairs(employees: List[Dict[str, object]]) -> List[Tuple[str, Optional[str]]]:
        id_to_name: Dict[int, str] = {int(e["id"]): str(e["name"]) for e in employees}
        result: List[Tuple[str, Optional[str]]] = []
        for e in sorted(employees, key=lambda x: int(x["id"])):
            mid = e.get("manager_id")
            mname = id_to_name.get(int(mid)) if mid is not None else None
            result.append((str(e["name"]), mname))
        return result

    # ------------------ 예시 테스트 ------------------
    def _run_sample_tests():
        # P1
        assert pass_or_fail(70, 55, 60) == "PASS"
        assert pass_or_fail(100, 20, 100) == "FAIL"

        # P2
        assert sum_of_multiples(10) == (3 + 5 + 6 + 9 + 10)

        # P3
        assert unique_sorted([3, 1, 2, 3, 2, 1]) == [1, 2, 3]

        # P4
        sample_orders = [("apple", 100), ("apple", None), ("pear", 200), ("apple", 50)]
        assert merge_orders(sample_orders) == {"apple": 150, "pear": 200}

        # P5
        emps = [
            {"id": 1, "name": "Kim", "manager_id": None},
            {"id": 2, "name": "Lee", "manager_id": 1},
            {"id": 3, "name": "Park", "manager_id": 1},
            {"id": 4, "name": "Choi", "manager_id": 3},
        ]
        assert manager_pairs(emps) == [
            ("Kim", None),
            ("Lee", "Kim"),
            ("Park", "Kim"),
            ("Choi", "Park"),
        ]
        print("Sample tests passed.")

    if __name__ == "__main__":
        _run_sample_tests()
