'''
题目描述：
给出两个int 数，a、b。

如果两数不同，则输出两数之和，否则将其之和翻倍输出.

示例代码:

print a+b if a!=b else (a+b)*2
'''




a , b = int(input('a')),int(input('b'))
 # print(f'{a+b} if {a}!={b} else {（a+b）*2})

if a != b:
    print((a + b) * 2)
else :
    print(a + b)