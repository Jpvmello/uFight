import cv2
import time
import mxnet
import socket
import gluoncv
import numpy as np

from gluoncv.model_zoo import get_model
from gluoncv.utils.viz import cv_plot_keypoints
from gluoncv.data.transforms.presets.ssd import transform_test
from gluoncv.data.transforms.pose import detector_to_simple_pose, heatmap_to_coord

def list_available_cams():
    cams = []
    for i in range(10):
        cam = cv2.VideoCapture(i)
        print(i, cam)
        if cam.read()[0]:
            cams.append(i)
            cam.release()
    return cams

if __name__ == '__main__':
    server_socket = socket.socket()
    server_socket.bind(('localhost', 8000))
    server_socket.listen(5)
    print('Accepting connection with client...')
    socket_obj, address = server_socket.accept()
    #server_socket.connect(address)

    #print(list_available_cams())
    cam = cv2.VideoCapture(0)
    context = mxnet.cpu()

    detector = get_model('ssd_512_mobilenet1.0_coco', pretrained = True, ctx = context)
    detector.reset_class(classes = ['person'], reuse_weights = {'person': 'person'})
    detector.hybridize()

    pose_estimator = get_model('simple_pose_resnet18_v1b', pretrained='ccd24037', ctx = context)
    pose_estimator.hybridize()

    while True:    
        frame = cv2.cvtColor(cam.read()[1], cv2.COLOR_BGR2RGB)
        frame = cv2.flip(frame, 1)

        #print('Original frame shape:', frame.shape)

        frame = mxnet.nd.array(frame).astype(np.uint8)
        x, frame = transform_test(frame, short = 512, max_size = 350)
        x.as_in_context(context)

        class_ids, scores, bboxes = detector(x)
        pose, upscale_bboxes = detector_to_simple_pose(frame, class_ids, scores, bboxes,
                                                        output_shape = (128, 96), ctx = context)
        if len(upscale_bboxes) > 0:
            heatmap = pose_estimator(pose)
            coords, confidences = heatmap_to_coord(heatmap, upscale_bboxes)
            frame = cv_plot_keypoints(frame, coords, confidences, class_ids, bboxes,
                                        scores, box_thresh = 0.5, keypoint_thresh = 0.2)
            
            norm_x_coords = list(coords[0, :, 0].asnumpy()/frame.shape[1])
            norm_y_coords = list(coords[0, :, 1].asnumpy()/frame.shape[0])
            confidences = list(confidences[0, :, 0].asnumpy())
            line = ''
            for i in range(len(confidences)):
                line += str(norm_x_coords[i]) + ',' + str(norm_y_coords[i]) + ',' + str(confidences[i]) + ','
            #output_file.write(line[:-1] + '\n')
            socket_obj.send(line.encode('utf8'))

        #print('Final frame shape:', frame.shape)
        cv2.imshow('', cv2.resize(frame, (0, 0), fx = 2.5, fy = 2.5))
        cv2.waitKey(1)

    cv2.destroyAllWindows()
    cam.release()
