# 딕셔너리 - 모듈 사용 재복습 (가위바위보)

# 모듈 변수 설정
ROCK = '바위'
SISSOR = '가위'
PAPER = '보'

scan = {
    '바위' : ROCK,
    '가위' : SISSOR,
    '보' : PAPER
}

wintable = {
    '바위' : '가위',
    '가위' : '보',
    '보' : '바위'
}



# 랜덤 초이스 설정
def random_choice_rsp() -> str:
    import random
    return random.choice(['가위', '바위', '보'])

# 가위바위보 설정
def input_rsp() -> str:
    select = input("'가위', '바위', '보'중에 입력: ")   # 프롬프트 출력 후 한 줄 입력, 반환형은 str
    last_select = scan[select]
    return last_select

# 가위바위보
mine = input_rsp() # 가위바위보 입력
yours = random_choice_rsp()

# 가위바위보 승리 조건
def rsp_winner(mine, yours) -> str :
    if mine == yours:
        return 'draw'
    elif wintable[mine] == yours:
        return 'win'
    else:
        return 'lose'

# 가위바위보 결과값
result = rsp_winner(mine, yours)

message = {
    'win' : '이겼다..!',
    'lose' : '졌다..ㅜ',
    'draw' : '비겼다...'
}
rsp_result = message[result]
print(rsp_result)
