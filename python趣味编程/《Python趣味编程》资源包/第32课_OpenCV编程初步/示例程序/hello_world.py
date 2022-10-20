'''
程序：hello, world
作者：苏秦@小海豚科学馆公众号
来源：图书《Python趣味编程：从入门到人工智能》
'''
import cv2

#从文件中读取图像
img = cv2.imread('images/face1.jpg')

#设置文件的位置、字体、颜色等参数
pos = (10, 50)
font = cv2.FONT_HERSHEY_SIMPLEX
color = (255, 0, 0)

#在图像中显示文本"hello, world"
cv2.putText(img, 'hello, world', pos, font, 2, color, 2)

#显示图像窗口
cv2.imshow('Image', img)

#按任意键退出
cv2.waitKey(0)

#销毁所有窗口
cv2.destroyAllWindows()
