'''
程序：图像风格迁移
作者：苏秦@小海豚科学馆公众号
来源：图书《Python趣味编程：从入门到人工智能》
'''
import cv2

#指定图像和模型路径
image_file = 'image01.jpg'
model = 'starry_night.t7'

#加载风格迁移模型
net = cv2.dnn.readNetFromTorch('models/' + model)

#从文件中读取图像
image = cv2.imread('images/' + image_file)
(h, w) = image.shape[:2]
blob = cv2.dnn.blobFromImage(image, 1.0, (w, h),
    (103.939, 116.779, 123.680), swapRB=False, crop=False)

#将图像传入风格迁移网络，并对返回结果进行计算
net.setInput(blob)
out = net.forward()

#修正输出张量，加上平均减法，然后交换通道排序。
out = out.reshape(3, out.shape[2], out.shape[3])
out[0] += 103.939
out[1] += 116.779
out[2] += 123.68
out /= 255
out = out.transpose(1, 2, 0)

#显示图像到窗口，并保存图像
#cv2.namedWindow('Image', cv2.WINDOW_NORMAL)
cv2.imshow('Image', out)
out *= 255.0
cv2.imwrite('output-' + model + '_' + image_file, out)
cv2.waitKey(0)
cv2.destroyAllWindows()
