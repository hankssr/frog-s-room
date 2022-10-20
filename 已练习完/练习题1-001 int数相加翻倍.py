"""
题目描述：
给出两个int 数，a、b。

如果两数不同，则输出两数之和，否则将其之和翻倍输出.

示例代码:

print a+b if a!=b else (a+b)*2

pythoner 就是这么炫酷，喜欢一行代码，环保节约！

示例：
输入：a = 1 b = 1

输出：4
"""
a = int(input('请输入a：'))
b = int(input('请输入b：'))
# if a != b:
#     print(a + b)
# else:
#     print((a + b) * 2)
print (a+b if a!=b else (a+b)*2)


