import os

if not os.path.exists("国内电视台.txt"):
    print("国内电视台文本文件不存在")
else:
    sour_f = open("国内电视台.txt", 'r', encoding="utf8")

export_f = open("导出.txt", 'w', encoding="utf8")
num_text = sour_f.readlines()
a=1
for line in range(0,len(num_text)):
    arrow=num_text[line]
    if arrow.find("rtp://") == -1 and  arrow.find("1080p") == -1 and arrow.find("720p") == -1:
        arrow=" "
    export_f.write(arrow)
    print(f'第{a}条:{arrow}')
    a +=1

sour_f.close()
export_f.close()
