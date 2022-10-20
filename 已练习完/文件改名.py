import os
flog = 1 # 添加或者删除文件名标示： 1为添加  2为删除）
prefix = str(input('请输入要添加或删除文件的前缀:'))
cur_path = os.getcwd()   #得到当前目录名
cdr_path = os.chdir("./renamepath") # 进入renamepath目录
flog = int(input("请输入添加或删除标识 1 or 2"))
for files in os.listdir(cdr_path) :       #显示当前文件夹文件名称


    if flog == 1:
        newname = prefix + files
        os.rename(files,newname)
        print("%s改名后文件名变更为%s" % (files,newname))

    elif flog ==2:
        index1 = len(prefix)           #确定删除字符串长度
        index2 = files.find(prefix)     #返回要求删除的字符串在文件中的位置
        if index2 == -1 :
            print("未找到此字符串,请重新确认")
            break
        """ newname1是删除字符串前几位文件名,newname2是删除字符串后几位文件名,newname是删掉要删除文件名后重新整合的文件名"""
        newname_1 = files[0:index2]
        newname_2 = files[index2+index1:]
        newname = newname_1+newname_2
        os.rename(files, newname)
        # newname = files[index2:index1]   #文件名切片，从被删除字符串位置起，到删除字符串总长完毕
        print("%s删名后文件名变更为%s" % (files,newname))
    else :
        print("标识输入错误")


