"""
具体的功能很简单，给定一个打算整理的文件夹目录，这个脚本可以将该目录下的所有文件都揪出来，并且根据后缀名归类到不同的文件夹里
"""


import os
import shutil
import glob

# os库可以完成操作系统层面大量操作，例如文件夹的创建、移动、重命名、删除等，有些功能实现的不是很完美，就用到shutil库跟其互补了，例如文件的复制、移动等。glob库可以利用通配符进行文件的搜索获取，非常强大




import os
import shutil
import glob
# 设置建立分类总文件夹的路径，这里按自己的实际路径修改

mkdir_path = r'C:\Users\chenx\文件夹分类'
# 设置需要遍历整理的文件夹路径，可以依据自己的实际需求修改

goal_dir = r'C:\xxxxxxxx'

if not os.path.exists(mkdir_path):
    os.mkdir(mkdir_path)

file_num = 0
dir_num = 0
# os.mkdir可以在指定路径创建文件夹，但如果文件夹已经存在则会报错，因此谨慎一点可以利用os.path.exists先对文件夹的存在与否进行判断，接下来是代码核心循环，为了方便理解先简化成如下形式：

# glob.glob(f'{goal_dir}/**/*', recursive=True)中**/*是通配符的重要用法，*可以代表任意个字符，包括0个字符，recursive参数的设置确保遍历。由于需要找出所有的文件而非文件夹，这里用os.path.isfile进行判断。最后可以输出文件的绝对路径先看看代码有没出现错误，让我们继续往下写
# 这里发生了什么呢？确认遍历到的是文件后，先用os.path.basename获取绝对路径中的文件名，接下来就是获取后缀名了。可以简单用split根据.将字符串“劈开”，然后取最后一个元素就是后缀名了，但注意这里必须要考虑一个特殊情况：有些文件没有后缀名(文件类型就叫 文件)，且名字中也没有.，这时用字符串方法split就会报错。如下图：
# 因此需要先判断文件中有没有.。由于我们是利用后缀名建立文件夹，所以索性将文件名中没有.的 文件 类型统一分类到others文件夹了，(这个实现逻辑大致上没有问题，但是依然忽略了一种极端情况：有些文件没有后缀名，且文件名中有个.，哈哈哈哈这种就会被上面的实现逻辑拆解出错误的后缀名了。更好的方法是有个函数可以直接获取文件的后缀名，利用这个对文件进行分类，感兴趣的读者可以自己尝试)，接下来就可以根据后缀名产生文件夹了，这里依然要注意先判断文件夹是否已经产生
# 为了避免移动文件夹而造成的异常，尤其是系统盘，因此这里用的是复制。按照需要也可以换成shutil.move最后我们可以加上分类文件夹和所有文件的计数并输出。完整代码如下，拿走就能用！
for file in glob.glob(f'{goal_dir}/**/*', recursive=True):
    if os.path.isfile(file):
        filename = os.path.basename(file)
        if '.' in filename:
            suffix = filename.split('.')[-1]
        else:
            suffix = 'others'
        if not os.path.exists(f'{mkdir_path}/{suffix}'):
            os.mkdir(f'{mkdir_path}/{suffix}')
            dir_num += 1
        shutil.copy(file, f'{mkdir_path}/{suffix}')
        file_num += 1

print(f'整理完成，有{file_num}个文件分类到了{dir_num}个文件夹中')