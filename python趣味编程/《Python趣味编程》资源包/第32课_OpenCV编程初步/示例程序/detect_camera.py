'''
程序：通过摄像头检测人脸
作者：苏秦@小海豚科学馆公众号
来源：图书《Python趣味编程：从入门到人工智能》
'''
import cv2

#创建人脸检测器
file = 'haarcascade_frontalface_default.xml'
face_cascade = cv2.CascadeClassifier(file)

#打开摄像头，设置画面大小
vc = cv2.VideoCapture(0)
vc.set(cv2.CAP_PROP_FRAME_WIDTH, 480)
vc.set(cv2.CAP_PROP_FRAME_HEIGHT, 320)

#处理视频流
while True:
    #读取视频帧图像
    retval, frame = vc.read()
    
    #按Q键退出
    if not retval or cv2.waitKey(16) & 0xFF == ord('q'):
        break

    #转换为灰度图像，再进行人脸检测
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)

    #标注人脸区域
    for (x, y, w, h) in faces:
        cv2.rectangle(frame, (x, y), (x+w, y+h), (255, 0, 0), 3)

    #将标注人脸的视频帧图像显示到窗口中
    cv2.imshow('Video', frame)

#关闭摄像头
vc.release()

#销毁所有窗口
cv2.destroyAllWindows()
