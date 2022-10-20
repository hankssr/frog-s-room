'''
palyerplayer 和 npc npc 完石头剪刀布游戏
判断palyer赢还是输
'''

palyer = int(input('请出拳 0 石头  1  剪刀   2 布'))    #palyer出拳，0代表石头；1代表剪刀；2代表
import random


npc = random.randint(0,2)   #npc随机出0，1,2之中的整数
if palyer == 0 and npc == 1 or palyer == 1 and npc ==2 or  palyer ==2 and npc ==0 :
    print('电脑出%d palyer赢'% npc)
elif palyer ==  npc :
    print(('电脑出%d' % npc))
    print('平局')
else:
    print(('电脑出%d' % npc))
    print('npc赢')

