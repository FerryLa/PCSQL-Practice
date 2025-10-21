# 가위바위보 : if else

SISSOR = '가위'
ROCK = '바위'
PAPER = '보'

WIN = '이겼다'
DRAW = '비겼다.'
LOSE = '졌다.'

mine = '보'
yours = '바위'

# if mine == yours:
#     result = DRAW
# else:
#     if mine == SISSOR:
#         if yours == PAPER:
#             result = WIN
#         else:
#             result = LOSE
#     else:
#         if mine == ROCK:
#             if yours == SISSOR:
#                 result = WIN
#             else:
#                 result = LOSE
#         else:
#             if mine == PAPER:
#                 if yours == ROCK:
#                     result = WIN
#                 else:
#                     result = LOSE

if mine == yours:
    result = DRAW
elif mine == SISSOR:
    if yours == PAPER:
        result = WIN
    else:
        result = LOSE
elif mine == ROCK:
    if yours == SISSOR:
        result = WIN
    else:
        result = LOSE
elif mine == PAPER:
    if yours == ROCK:
        result = WIN
    else:
        result = LOSE

print(result)