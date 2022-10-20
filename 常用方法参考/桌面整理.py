"""
作者：敲键盘的甜甜
链接：https://www.zhihu.com/question/20799742/answer/2444342006
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
最近桌面实在是太乱了，自己都看不下去了，几乎占满了整个屏幕。虽然整理桌面的软件很多，
但是对于其他路径下的文件，我同样需要整理，于是我想到使用Python，完成这个需求。
我一共为将文件分为9个大类，分别是图片、视频、音频、文档、压缩文件、常用格式、程序脚本、可执行程序和字体文件。
file_dict是自己定义的一个字典，里面包含了我们学习、工作中常用的格式。常用格式需要为大家解释一下，对于平时经常使用，但是又不知道放在哪一类的文件，
都存放在这里。注意：如果你的电脑中，有着其它更多的文件格式，只需要修改上述的file_dict字典即可。开发思路开发这样一个小工具，一共涉及到三个Python库，
分别是os模块、shutil模块、glob模块，它们搭配使用，用来处理文件和文件夹，简直超给力！整个开发步骤，大致思路是这样的：
① 任意给定一个文件路径；
② 获取当前文件路径下的所有文件，并取得每个文件对应的后缀；
③ 判断每个文件，是否在指定的嵌套字典中，并返回对应的文件分类；
④ 判断每个文件分类的文件夹是否存在。因为需要创建新的文件夹，用于分类存放文件；
⑤ 将每个文件，复制到对应的分类中；


"""
import glob
# 导入相关库
import os
import shutil

# 采用input()函数，动态输入要处理的文件路径。
path = input("请输入要清理的文件路径：")

# 定义一个文件字典，不同的文件类型，属于不同的文件夹，一共9个大类。
file_dict = {
            '图片': ['jpg','png','gif','webp'],
            '视频': ['rmvb','mp4','avi','mkv','flv'],
            "音频": ['cd','wave','aiff','mpeg','mp3','mpeg-4'],
            '文档': ['xls','xlsx','csv','doc','docx','ppt','pptx','pdf','txt'],
            '压缩文件': ['7z','ace','bz','jar','rar','tar','zip','gz'],
            '常用格式': ['json','xml','md','ximd'],
            '程序脚本': ['py','java','html','sql','r','css','cpp','c','sas','js','go'],
            '可执行程序': ['exe','bat','lnk','sys','com'],
            '字体文件': ['eot','otf','fon','font','ttf','ttc','woff','woff2']
        }

# 定义一个函数，传入每个文件对应的后缀。判断文件是否存在于字典file_dict中；
# 如果存在，返回对应的文件夹名；如果不存在，将该文件夹命名为"未知分类"；
def func(suffix):
    for name, type_list in file_dict.items():
        if suffix.lower() in type_list:
            return name
    return "未知分类"

# 递归获取 "待处理文件路径" 下的所有文件和文件夹。
for file in glob.glob(f"{path}/**/*",recursive=True):
 # 由于我们是对文件分类，这里需要挑选出文件来。
    if os.path.isfile(file):
     # 由于isfile()函数，获取的是每个文件的全路径。这里再调用basename()函数，直接获取文件名；
        file_name = os.path.basename(file)
        suffix = file_name.split(".")[-1]
        # 判断 "文件名" 是否在字典中。
        name = func(suffix)
        print(func(suffix))
        # 根据每个文件分类，创建各自对应的文件夹。
        if not os.path.exists(f"{path}\\{name}"):
            os.mkdir(f"{path}\\{name}")
        # 将文件复制到各自对应的文件夹中。
        shutil.copy(file,f"{path}\\{name}")