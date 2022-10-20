import zipfile

# 描述：这将扫描当前目录和所有子目录并显示大小。
import os
import sys  # 为参数向量加载库模块和sys模块'''
#
# try:
#     directory = sys.argv[1]  # 将变量目录设置为用户提供的参数
#
# except IndexError:
#     sys.exit("必须提供参数.")

dir_size = 0  # Set the size to 0
Zip_f=[]
fsizedicr = {
    "Bytes": 1,
    "Kilobytes": float(1) / 1024,
    "Megabytes": float(1) / (1024 * 1024),
    "Gigabytes": float(1) / (1024 * 1024 * 1024),
}
for (path, dirs, files) in os.walk('T:\\欧美'):  # 遍历所有目录。对于每次迭代，os.walk 返回目录中的文件夹、子文件夹和文件
    for file in files:  # 获取所有文件
        filename = os.path.join(path, file)
        print(filename)
        new_f=filename.rsplit('.')
        if new_f[1]=='zip':
            cc=new_f[0]+'.'+new_f[1]
            Zip_f.append(cc)
        print(new_f)

    print(Zip_f,len(Zip_f))
        # dir_size += os.path.getsize(filename)  # 将根目录中每个文件的大小相加得到总大小。

def un_zip(file_name):
    """unzip zip file"""
    zip_file = zipfile.ZipFile(file_name)
    if os.path.isdir(file_name + "_files"):
        pass
    else:
        os.mkdir(file_name + "_files")
    for names in zip_file.namelist():
        zip_file.extract(names, file_name + "_files/")
    zip_file.close()


for aa in range(0,len(Zip_f)):
    un_zip(Zip_f[aa])
    os.remove(Zip_f[aa])   #@解压后删除压缩文件




#
# fsizeList = [str(round(fsizedicr[key] * dir_size, 2)) + " " + key for key in fsizedicr]  # List of units
#
# if dir_size == 0:
#     print("文件空")  # 完整性检查以消除空文件的极端情况。
# else:
#     for units in sorted(fsizeList)[
#                  ::-1
#                  ]:  # 对单位列表进行反向排序，因此最小的单位首先打印。
#         print("文件夹大小: " + units)
