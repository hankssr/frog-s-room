import os
import time


import one_copy_page
import two_add_text


start=time.process_time()


one_copy_page
two_add_text

os.remove('2笔记本_增加页面.pptx')
    # sleep(0.01)

end=time.process_time()
print(f'程序运行了%.1{end - start}秒')
