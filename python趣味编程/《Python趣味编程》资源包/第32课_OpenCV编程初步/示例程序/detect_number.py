'''
程序：车牌检测
作者：苏秦@小海豚科学馆公众号
来源：图书《Python趣味编程：从入门到人工智能》
'''
import cv2

#从文件中读取图像并转为灰度图像
img = cv2.imread('images/car1.jpg')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

#创建车牌检测器
file = 'haarcascade_russian_plate_number.xml'
face_cascade = cv2.CascadeClassifier(file)

#检测车牌区域
faces = face_cascade.detectMultiScale(img, 1.2, 5)

for (x, y, w, h) in faces:
    #标注车牌区域
    cv2.rectangle(img, (x, y), (x+w, y+h), (255, 0, 0), 3)
    #将车牌区域的图像写入文件
    number_img = img[y:y+h, x:x+w]
    cv2.imwrite('images/car_number.jpg', number_img)

#显示检测结果到窗口
cv2.imshow('Image', img)

#按任意键退出
cv2.waitKey(0)

#销毁所有窗口
cv2.destroyAllWindows()
