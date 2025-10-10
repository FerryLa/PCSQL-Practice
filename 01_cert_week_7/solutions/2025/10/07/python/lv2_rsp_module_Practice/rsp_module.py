# 모듈 사용 : dictionary
wintable = {
    '가위':'보',
    '바위':'가위',
    '보':'바위'
}

def rsp(mine, yours):
    if mine == yours:
        return 'draw'
    elif wintable[mine] == yours:
        return 'win'
    else:
        return 'lose'
