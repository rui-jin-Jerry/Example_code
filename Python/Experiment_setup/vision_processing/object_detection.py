import cv2
from imageai.Detection import ObjectDetection

obj_detect = ObjectDetection()
#obj_detect.setModelTypeAsYOLOv3()
obj_detect.setModelTypeAsTinyYOLOv3()

obj_detect.setModelPath(r"C:\Users\jinr2.STUDENT\Downloads\tiny-yolov3.pt")
obj_detect.loadModel()


class object_detection:

    def __int__(self):
        pass

    def process(self, frame):

        frame = frame[:, :, :3]

        annotated_image, preds = obj_detect.detectObjectsFromImage(input_image=frame,
                                                                   output_type="array",
                                                                   display_percentage_probability=False,
                                                                   display_object_name=True)

        return annotated_image
