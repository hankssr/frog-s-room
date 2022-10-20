'''
程序：检测视频中的人脸
作者：苏秦@小海豚科学馆公众号
来源：图书《Python趣味编程：从入门到人工智能》
'''
import cv2

#创建人脸检测器
file = 'haarcascade_frontalface_default.xml'
face_cascade = cv2.CascadeClassifier(file)

#加载视频文件
vc = cv2.VideoCapture('images/video.mp4')

#处理视频流
while True:
    #读取视频帧
    retval, frame = vc.read()
    
    #按Q键退出
    if not retval or cv2.waitKey(16) & 0xFF == ord('q'):
        break
    
    #检测人脸区域
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)
    
    #标注人脸区域
    for (x, y, w, h) in faces:
        cv2.rectangle(frame, (x, y), (x+w, y+h), (255, 0, 0), 3)
        
    #显示视频帧到窗口
    cv2.imshow('Video', frame)

#关闭视频
vc.release()

#销毁所有窗口
cv2.destroyAllWindows()
