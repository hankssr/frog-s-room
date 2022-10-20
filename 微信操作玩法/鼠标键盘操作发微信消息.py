import random

import pyautogui as pg
import pyperclip as pl


#  PyAutoGUI中文输入需要用粘贴实现
#  Python 2版本的pyperclip提供中文复制
def paste(foo):
    pl.copy(foo)
    pg.hotkey('ctrl', 'v')

mingyan_list=[]
files= open('彩虹屁.txt', 'r', encoding='UTF-8')
mingyan_list = files.readlines()
mingyan_num=len(mingyan_list)
files_nike=open('群昵称.txt', 'r', encoding='UTF-8')
name_list = files_nike.readlines()
name_list_num=len(name_list)
#  移动到文本框
# pg.click(130,30)
# paste(foo)
'''
让鼠标移动到屏幕中间

'''
# pg.alert(text='准备开始轰炸', title='警告', button='OK')
screenWidth, screenHeight = pg.size()
currentMouseX, currentMouseY = pg.position()
pg.moveTo(1276,2142)
pg.click()
pg.moveTo(2857,1942)
pg.click()
# pg.typewrite('Hello world!', interval=0.25)
for aa in range(60):   #循环次数
    b = random.randint(0, mingyan_num+1)
    c = random.randint(0, name_list_num+1)
    nick_name=str("@"+name_list[c]+' ')
    paste(nick_name)   #发给群里随机人
    # paste("@新疆小麦姐 ")     #发给特定人
    # pg.press('enter')
    paste(mingyan_list[ b ])

    print(nick_name+mingyan_list[b])
    pg.press('enter')
    pg.PAUSE = 1.5

files.close()
files_nike.close()
