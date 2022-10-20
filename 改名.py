import os
import pandas as pd

soure = pd.read_csv('文件名.csv')
print(soure)

#
#
# def batch_rename(work_dir, old_ext, new_ext):
#     """
#     This will batch rename a group of files in a given directory,
#     once you pass the current and new extensions
#     """
#     # files = os.listdir(work_dir)
#     for filename in os.listdir(work_dir):
#         # Get the file extension 从后面检索到.的字符串,然后以.建立一个文件名,扩展名列表
#         split_file = os.path.splitext(filename)
#         # 分解文件名
#         root_name, file_ext = split_file
#         # Start of the logic to check the file extensions, if old_ext = file_ext
#         if old_ext == file_ext:
#             # Returns changed name of the file with new extention
#             newfile = root_name + new_ext
#
#             # Write the files
#             os.rename(os.path.join(work_dir, filename), os.path.join(work_dir, newfile))
#     print("rename is done!")
#     print(os.listdir(work_dir))
#
