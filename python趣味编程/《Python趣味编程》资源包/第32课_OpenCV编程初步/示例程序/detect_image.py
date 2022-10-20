'''
程序：人脸检测
作者：苏秦@小海豚科学馆公众号
来源：图书《Python趣味编程：从入门到人工智能》
'''
import cv2

#从文件读取图像并转为灰度图像
img = cv2.imread('images/face1.jpg')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

#创建人脸检测器
file = 'haarcascade_frontalface_default.xml'
face_cascade = cv2.CascadeClassifier(file)

#检测人脸区域
faces = face_cascade.detectMultiScale(gray, 1.3, 5)

#标注人脸区域
for (x, y, w, h) in faces:
    cv2.rectangle(img, (x, y), (x+w, y+h), (255, 0, 0), 3)

#显示检测结果到窗口
cv2.imshow('Image', img)

#按任意键退出
cv2.waitKey(0)

#销毁所有窗口
cv2.destroyAllWindows()
