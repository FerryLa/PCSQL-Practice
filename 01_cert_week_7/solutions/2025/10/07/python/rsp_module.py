# 모듈 만들기 : 함수 def, random.choice

def random_rsp():
    """무작위 가위바위보를 낸다."""
    import random
    return random.choice(['가위', '바위', '보'])

# 변수 저장

ROCK = '바위'
PAPER = '보'
SISSOR = '가위'
