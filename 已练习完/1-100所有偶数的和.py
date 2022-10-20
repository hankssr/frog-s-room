num = 1 #计数器初始值
sum1 = 0       #合计初始值
while num <= 100 :
    if num//2 == num/2 : #如果整除的结果和除2的结果一样，则是偶数；或者 num %2 ==0
        sum1 += num
    num += 1
print('1-100的偶数和为%d'%(sum1))

