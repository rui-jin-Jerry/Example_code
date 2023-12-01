#import face_recognition
#
# Modified by @rui_jin_jerry
# Data: 20221020
import cv2
import numpy as np

# class face_detection:
#
#     def __int__(self):
#         pass
#
#     def process(self, frame):
#         frame = frame[:, :, 0:1:2]
#         small_frame = cv2.resize(frame, (0, 0), fx=0.25, fy=0.25)
#
#         face_location = face_recognition.face_locations(small_frame, model="cnn")
#
#         for top, right, bottom, left in face_location:
#             top *= 4
#             right *= 4
#             bottom *= 4
#             left *= 4
#
#             face_image = frame[left:right, top:bottom, :]
#
#             face_image = cv2.GaussianBlur(face_image,(99, 99), 30)
#
#             # print(np.shape(face_image))
#             # print(np.shape(frame))
#
#             frame[left:right, top:bottom, :] = face_image
#
#         return frame
#
#
# faceCascade = cv2.CascadeClassifier(
#     r"C:\Users\jinr2.STUDENT\Software\vision_processing\haarcascade_frontalface_default.xml")
#
#
# class face_detection_ultra_light:
#
#     def __int__(self):
#         pass
#
#     def process(self, frame):
#         frame = frame[:, :, :3]
#         frame = np.array(frame, dtype='uint8')
#         gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
#         faces = faceCascade.detectMultiScale(
#             gray,
#             scaleFactor=1.1,
#             minNeighbors=5,
#             minSize=(30, 30)
#         )
#
#         # Draw a rectangle around the faces
#         for (x, y, w, h) in faces:
#             cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
#
#         return frame
#
#
# directory = os.path.dirname(__file__)
# weights = os.path.join(directory, "face_detection_yunet_2022mar-act_int8-wt_int8-quantized.onnx")
face_detector = cv2.FaceDetectorYN_create(r"C:\Users\jinr2.STUDENT\opencv_zoo\models\face_detection_yunet\face_detection_yunet_2022mar.onnx","",(0,0))

class face_detection_yunet:

    def __init__(self):
        pass

    def process(self, frame):

        image = np.uint8(frame)
        channels = 1 if len(image.shape) == 2 else image.shape[2]
        if channels == 1:
            image = cv2.cvtColor(image, cv2.COLOR_GRAY2BGR)
        if channels == 4:
            image = cv2.cvtColor(image, cv2.COLOR_BGRA2BGR)


        height, width, _ = image.shape
        face_detector.setInputSize((width, height))


        _, faces = face_detector.detect(image)
        faces = faces if faces is not None else []
        image_rgb = image.copy()

        # Creat a blind image
        image = np.zeros((600, 800, 3), dtype=np.uint8)
        processed_image = image
        image_face_3d = cv2.resize(image, (600, 400))
        image_p = np.ones((600, 600, 3), dtype=np.uint8)
        image_p = image_p*100
        image_p[99:499, :, :] = 0


        for face in faces:

            box = list(map(int, face[:4]))
            color = (0, 0, 255)
            thickness = 2
            cv2.rectangle(image, box, color, thickness, cv2.LINE_AA)


            landmarks = list(map(int, face[4:len(face) - 1]))
            landmarks = np.array_split(landmarks, len(landmarks) / 2)
            for landmark in landmarks:
                radius = 5
                thickness = -1
                cv2.circle(image, landmark, radius, color, thickness, cv2.LINE_AA)


            confidence = face[-1]
            confidence = "{:.2f}".format(confidence)
            position = (box[0], box[1] - 10)
            font = cv2.FONT_HERSHEY_SIMPLEX
            scale = 0.5
            thickness = 2
            cv2.putText(image, confidence, position, font, scale, color, thickness, cv2.LINE_AA)

            # post processing to highlight face area
            white_color = 255
            try:
                image[box[1]:(box[1]+box[3]), box[0]:(box[0]+box[2]), :3] = white_color
                processed_image = image
            except:
                pass

            # post processing for output view
            # image = cv2.resize(image, (20, 20))
            image_face = cv2.resize(image, (12, 8))
            #image = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY)
            # image_3d = cv2.resize(image, (600, 600))
            image_face_3d = cv2.resize(image_face, (600, 400))

        image_p[99:499,:,:] = image_face_3d

            #image_3d = np.dstack((image, image, image))

            # face_image = image[box[1]:(box[1]+box[3]), box[0]:(box[0]+box[2]), :3]
            # # face_image = cv2.GaussianBlur(face_image,(99, 99), 30)
            # alpha = 2
            # beta = 50
            #
            # face_image = cv2.addWeighted(face_image,alpha,np.zeros(face_image.shape,face_image.dtype),0,beta)
            # #
            # try:
            #     image[box[1]:(box[1]+box[3]), box[0]:(box[0]+box[2]), :3] = face_image
            # except:
            #     pass



        return np.hstack((processed_image, image_rgb, image_p))
