import os

list_dir = []
dq_dir = os.getcwd()
print('当前所在目录为:%s'%dq_dir)
os.mkdir("images")
os.mkdir("test")
list_dir = os.listdir(dq_dir)
print('当前目录结构为\n:%s'%list_dir)
#os.rmdir("test")
print('当前目录结构为\n:%s'%list_dir)
