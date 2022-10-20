'''
程序：目标检测
作者：苏秦@小海豚科学馆公众号
来源：图书《Python趣味编程：从入门到人工智能》
'''
import cv2
import numpy

#指定图像和模型文件路径
image_path = './images/example_1.jpg'
prototxt = './model/MobileNetSSD_deploy.prototxt'
model = './model/MobileNetSSD_deploy.caffemodel'

#设定目标名称
CLASSES = ('background', 'aeroplane', 'bicycle', 'bird', 'boat',
 'bottle', 'bus', 'car', 'cat', 'chair', 'cow', 'diningtable',
 'dog', 'horse', 'motorbike', 'person', 'pottedplant', 'sheep',
 'sofa', 'train', 'tvmonitor')
COLORS = numpy.random.uniform(0, 255, size=(len(CLASSES), 3))
FONT = cv2.FONT_HERSHEY_SIMPLEX

#加载网络模型
net = cv2.dnn.readNetFromCaffe(prototxt, model)

#读取图像并进行预处理
image = cv2.imread(image_path)
(h, w) = image.shape[:2]
input_img = cv2.resize(image, (300, 300))
blob = cv2.dnn.blobFromImage(input_img, 0.007843, (300, 300), 127.5)

#将图像传入网络
net.setInput(blob)
detections = net.forward()

#对结果进行处理
for i in numpy.arange(0, detections.shape[2]):
    idx = int(detections[0, 0, i, 1])
    confidence = detections[0, 0, i, 2]
    if confidence > 0.2:
        #画矩形框
        box = detections[0, 0, i, 3:7] * numpy.array([w, h, w, h])
        (x1, y1, x2, y2) = box.astype('int')
        cv2.rectangle(image, (x1, y1), (x2, y2), COLORS[idx], 2)
        #标注信任度
        label = '[INFO] {}: {:.2f}%'.format(CLASSES[idx], confidence * 100)
        print(label)
        cv2.putText(image, label, (x1, y1), FONT, 1, COLORS[idx], 1)

#显示图像并等待
cv2.imshow('Image', image)
cv2.waitKey(0)
cv2.destroyAllWindows()
