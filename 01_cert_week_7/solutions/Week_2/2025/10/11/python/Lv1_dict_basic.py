# 딕셔너리

# 가위바위보 바로 해보기
'''
import Lv1_dict_basic_module
'''

# 리스트
''' 
# 리스트 수정, 삭제
print('# 리스트 수정, 삭제')

list = [1, 22, 33, 44]
print('list = [1, 22, 33, 44] -> list =', list)

list[2] = 55
print('list[2] = 55 -> list =', list)

list.append(6)
print('list.append(6) -> list =', list)

del list[0]
print('del list[0] -> list =', list)

list.pop(0)
print("list.pop(0) -> list =", list)

print('\n# 딕셔너리 수정, 삭제')
dict = {
    'one': 1,
    'two' : 2
}
print("dict = {'one': 1, 'two' : 2} -> dict =", dict)

dict['one'] = '!'
print("dict['one'] = '!' -> dict =", dict)

dict['three'] = '#'
print("dict['three'] = '#' -> dict =", dict)

del(dict['one'])
print("del(dict['one']) -> dict =", dict)

dict.pop('two')
print("dict.pop('two') -> dict =", dict)
# for in 활용 (간략하게)

'''

# for in으로 key value 가져오기
'''
ages = {
    'Tod' : 35,
    'Jane' : 23,
    'Paul' : 62
}

for key in ages.keys():
    print(key)

for key in ages:
    print('{}의 {}입니다.'.format(key, ages[key]))

for value in ages.values():
    print(value)

# 키와 밸류가 같이 필요할 때는 .items()를 사용
for key, value in ages.items():
    print(key, ':', value)
'''

# 리스트와 비교
'''
list = [1, 2, 3, 4, 5]
dict = {'one' : 1, 'two' : 2}
print(list[0])
print(dict['one'])
del(list[0])
del(dict['one'])
print(list)
print(dict)

print(len(dict))
print(3 in list)
print(2 in dict.values())
print('one' in dict.keys())

list = [1, 2, 3, 4, 5]
dict = {'one' : 1, 'two' : 2}
list.pop(0)
print(list[2])

big_list = [1,2,3] + [4,5,6]
print(big_list)

# 빠르고 간편한 딕셔너리 추가, 수정
dict1 = {1:100, 2:200}
dict2 = {1:1000, 2:200, 3:300}
dict1.update(dict2)
print(dict1)

dict1 = {1:100, 2:200}
dict2 = {1:1000, 3:300}
dict2.update(dict1)
print(dict2)
'''

# tuple
'''
list1 = [1,2,3,4]
list1.append(5)
print(list1)
list1.remove(1)
print(list1)

tuple1 = (1,2,3,4)
print(tuple1)

tuple2 = 1,2,3
print(tuple2)
print(type(tuple2))

tuple3 = tuple(list1)
print(tuple3)
print(tuple3[1])

# tuple3[0] = 5

del tuple[3]

tuple.pop
'''

# 튜플 packing, unpacking
'''
a, b = 1, 2
print(a, b)

c = (3,4)
print(c)

d, e = c # c의 값을 언패킹해서 d와 e에 넣음
print(d, e)

f = d, e # f에 d와 e를 패킹했다.
print(f)

x = 5
y = 10
temp = x
x = y
y = temp
print(x, y)
x,y = y,x # 값을 바꾸기
print(x, y)

def tuple_func():
    return 1, 2

q, w = tuple_func()
q, w = w, q
z = q, w

print('z =', z)
'''

### 튜플을 이용한 함수의 리턴값
'''
products = {"풀" : 800, "색종이": 1000}

for product_detail in products.items():
    print("{}의 가격: {}원".format(*product_detail))

for product_detail in products.items():
    print("{}의 가격: {}원".format(product_detail[0], product_detail[1]))
'''
