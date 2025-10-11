# while로 가위바위보 입력 받기
'''
selected = None
while selected not in ['가위', '바위', '보']:
    selected = input('가위, 바위, 보 중에 하나를 입력하세요> ')
print('선택된 값은: ', selected)
'''

# if 조건 문은 한번만 실행 => 그래서 입력 값을 제대로 반환을 받기 어려움
'''
selected = None
if selected not in ['가위', '바위', '보']:
    selected = input('가위, 바위, 보 중에 하나를 입력하세요> ')
print('선택된 값은: ', selected)
'''

# for in, for in range
patterns = ['가위','보','보']
for i in range(len(patterns)):
    print(patterns[i])
    i = i + 1

# # while로 하려면 이렇게 오래 걸려
# patterns = ['가위','보','보']
# length = len(patterns)
# i = 0
# while i < length:
#     print(patterns[i])
#     i = i + 1

