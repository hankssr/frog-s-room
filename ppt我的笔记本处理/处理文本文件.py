"""
   打开名人名言文本文件
   按行读取
   如果一行文本超过20个字符（20个汉字）则跳过
   读取成功的文本生成到新文件new_名人名言.txt
"""

#打开文件,并且按行读取文件
f=open('new_名人名言.txt','w')
for line in open('名人名言.txt','r',encoding='UTF-16') :
    if len(line) <= 20:
      print(line,end='', file=f)

#读取文件

f.close()





