# 모듈 사용 : dictionary
import rsp_module
import random

message = {
    'win':'이겼습니다.',
    'lose':'졌습니다.',
    'draw':'비겼습니다.'
}

# result = rsp_module.rsp('가위', '바위')
random_rsp = ['가위','바위','보']
mine = random.choice(random_rsp)
yours = random.choice(random_rsp)

result = rsp_module.rsp(mine, yours)

print(message[result])

