import cv2

net = cv2.dnn.readNetFromTorch('../models/candy.t7')
net.setPreferableBackend(cv2.dnn.DNN_BACKEND_OPENCV);

cap = cv2.VideoCapture('../images/overpass.mp4')

while cv2.waitKey(1) < 0:
    hasFrame, frame = cap.read()
    if not hasFrame:
        cv2.waitKey()
        break

    inWidth = 480
    inHeight = 320
    inp = cv2.dnn.blobFromImage(frame, 1.0, (inWidth, inHeight),
                                (103.939, 116.779, 123.68),
                                swapRB=False, crop=False)

    net.setInput(inp)
    out = net.forward()

    out = out.reshape(3, out.shape[2], out.shape[3])
    out[0] += 103.939
    out[1] += 116.779
    out[2] += 123.68
    out /= 255
    out = out.transpose(1, 2, 0)
    
    cv2.namedWindow('Video', cv2.WINDOW_NORMAL)
    cv2.imshow('Video', out)
    
cv2.destroyAllWindows()

