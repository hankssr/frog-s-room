'''
程序：检测人脸和眼睛
作者：苏秦@小海豚科学馆公众号
来源：图书《Python趣味编程：从入门到人工智能》
'''
import cv2

#创建人脸检测器、眼睛检测器
face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
eye_cascade = cv2.CascadeClassifier('haarcascade_eye.xml')

#从文件读取图像并转为灰度图像
face_img = cv2.imread('images/face_eye.jpg')
gray_img = cv2.cvtColor(face_img, cv2.COLOR_BGR2GRAY)

#检测人脸区域
faces = face_cascade.detectMultiScale(gray_img, 1.3, 5)

#标注人脸区域
for (x,y,w,h) in faces:
    cv2.rectangle(face_img, (x,y), (x+w,y+h), (255,0,0), 2)

    #检测眼睛区域
    roi_gray = gray_img[y:y+h, x:x+w]
    roi_color = face_img[y:y+h, x:x+w]
    eyes = eye_cascade.detectMultiScale(roi_gray)

    #检测眼睛区域
    for (ex,ey,ew,eh) in eyes:
        cv2.rectangle(roi_color, (ex,ey), (ex+ew,ey+eh), (0,255,0), 2)

#显示检测结果到窗口
cv2.imshow('Image',face_img)

#按任意键退出
cv2.waitKey(0)

#销毁所有窗口
cv2.destroyAllWindows()
