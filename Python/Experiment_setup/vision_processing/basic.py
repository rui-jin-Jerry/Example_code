"""
Basic vision processing modules, for convenience.

NOTE: these wrappers may be overkill but they provide a simple interface
      to be able to specify modules in a config file for serial processing.

Author: @RuizSerra
Date:   ca. 202104
"""

import cv2
import numpy as np
from utils.logging import vp_logger

Z16_TO_METRES = 1.0 / 1000

class ToBlackAndWhite:

    def __init__(self):
        pass

    def process(self, frame):
        frame = cv2.merge((cv2.cvtColor(frame, cv2.COLOR_RGB2GRAY),) * 3)
        cv2.imshow("Result", frame)
        cv2.waitKey(20)

        return frame


class Invert:  # (ProcessingModule):

    def __init__(self):
        pass

    def process(self, frame):
        return cv2.bitwise_not(frame)


class GaussianBlur:  # (ProcessingModule):

    def __init__(self, kernel_size=(5, 5), kernel_sigma=2):
        self.kernel_size = tuple(kernel_size)
        self.kernel_sigma = kernel_sigma

    def process(self, frame):
        return cv2.GaussianBlur(frame, self.kernel_size, self.kernel_sigma)

    # TODO Add more depth to color option here for presenting


class Calibration_AOV:  # (ProcessingModule):

    def __init__(self):
        pass

    def process(self, frame):

        frame = frame[:, :, :3].astype(np.uint8)

        # Put assistant line in the vertical middle for calibration of the AOV
        frame = cv2.line(frame, (int(frame.shape[1] / 2), 0), (int(frame.shape[1] / 2), 50), (0, 0, 225), 9)
        frame = cv2.line(frame, (int(frame.shape[1] / 2), 600), (int(frame.shape[1] / 2), frame.shape[0] - 50),
                         (0, 0, 225), 9)

        # Put assistant line in the horizonal middle for calibration of the AOV

        frame = cv2.line(frame, (0, int(frame.shape[0] / 2)), (50, int(frame.shape[0] / 2)), (0, 0, 225), 9)
        frame = cv2.line(frame, (800, int(frame.shape[0] / 2)), (750, int(frame.shape[0] / 2)),
                         (0, 0, 225), 9)

        img_output = np.zeros((600, 600, 3), dtype=np.uint8)

        return np.hstack((frame,frame,img_output))


class Calibration_Threshold:  # (ProcessingModule):

    def __init__(self, intensity = 0, all_white = False):
        self.intensity = intensity
        self.all_white = all_white
        pass

    def process(self, frame, Add_flag = False, Minus_flag = False):

        color_image = frame[:, :, :3]

        if self.all_white:
            # create a white image
            img = np.ones((600, 800, 3), dtype=np.uint8)
            img_output = np.ones((600, 600, 3), dtype=np.uint8)
            img = 255 * img
            img_output = 255 * img_output

        else:
            if Add_flag:
                self.intensity += 5
                vp_logger.info('Intensity set at: %d', self.intensity)
            elif Minus_flag:
                self.intensity -= 5
                vp_logger.info('Intensity set at: %d', self.intensity)

            img = np.ones((600, 800, 3), dtype=np.uint8)
            img[300:600, 325:470,:] = self.intensity
            img_output = cv2.resize(img,(600,600))

        return np.hstack((img,color_image,img_output))


class Depth2color:

    def __int__(self):
        pass

    def process(self, frame):
        depth_image = frame[:, :, -1]
        color_image = frame[:, :, :3]

        # Remove background - Set pixels further than clipping_distance to grey
        grey_color = 153
        depth_image_3d = np.dstack(
            (depth_image, depth_image, depth_image))  # depth image is 1 channel, color is 3 channels
        bg_removed = np.where((depth_image_3d > clipping_distance) | (depth_image_3d <= 0), grey_color, color_image)

        # Render images:
        #   depth align to color on left
        #   depth on right
        depth_colormap = cv2.applyColorMap(cv2.convertScaleAbs(depth_image, alpha=0.03), cv2.COLORMAP_JET)
        images = np.hstack((bg_removed, depth_colormap))

        return images

class Intensity:

    def __init__(self, kernel_size=20, clipping_distance=2, lower_hsv=[0, 0, 0], upper_hsv=[180, 255, 50]):
        self.kernel_size = kernel_size
        self.clipping_distance = clipping_distance / Z16_TO_METRES
        self.lower_hsv = lower_hsv
        self.upper_hsv = upper_hsv

    def process(self, frame):
        # Grab the depth and color channel
        depth_image = frame[:, :, -1]
        color_image = frame[:, :, :3]

        # converting the image to HSV format
        img = np.uint8(color_image)
        hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

        # defining the lower and upper values of HSV,
        # this will detect yellow colour
        # creating the mask by eroding,morphing,
        # dilating process
        Mask = cv2.inRange(hsv, np.array(self.lower_hsv), np.array(self.upper_hsv))
        Mask_3d = np.dstack((Mask, Mask, Mask))

        # Remove background - Set pixels further than clipping_distance to black
        black_color = 0
        depth_image_3d = np.dstack(
            (depth_image, depth_image, depth_image))  # depth image is 1 channel, color is 3 channels
        bg_removed = np.where((depth_image_3d > self.clipping_distance) | (depth_image_3d <= 0), black_color, Mask_3d)

        # Resize for output
        image = cv2.resize(bg_removed, (self.kernel_size, self.kernel_size))
        image = cv2.resize(image, (600, 600))

        # Render images:
        #   rgb on the left
        #   depth rendered on the right
        return np.hstack((bg_removed, color_image, image))


class Depth:

    def __init__(self, kernel_size=20, min=0.5, max=2, power=3, min_intensity = 20, ground_removal = False,
                 ground_mask = True, lower_hsv = [0,0,0], upper_hsv = [180,255,50]):
        self.kernel_size = kernel_size
        self.min = min
        self.max = max
        self.power = power
        self.min_intensity = min_intensity
        self.ground_removal = ground_removal
        self.ground_mask = ground_mask
        self.lower_hsv = lower_hsv
        self.upper_hsv = upper_hsv
        A = np.exp(np.log(255 /self.min_intensity) / self.power)
        self.max_distance = -(self.min-self.max*A) / (A - 1)


    def process(self, frame):
        # Grab the depth and color channel
        depth_image = frame[:, :, -1]
        color_image = frame[:, :, :3]

        # Remove background - Set pixels on the ground to black
        if self.ground_mask:
            # converting the image to HSV format
            img = np.uint8(color_image)
            hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

            # defining the lower and upper values of HSV,
            # this will detect ground colour of testing field
            # creating the mask by eroding,morphing,
            # dilating process
            Mask = cv2.inRange(hsv, np.array(self.lower_hsv), np.array(self.upper_hsv))
            depth_image[Mask==0] = 0

        # Invert the depth channel and make anything close look brighter and further darker
        depth_image = preprocess_depth_map(depth_image, self.min, self.max, self.min_intensity, self.power)

        # depth image is 1 channel, color is 3 channels
        depth_image_3d = np.dstack(
            (depth_image, depth_image, depth_image))

        # Resize for output
        image = cv2.resize(depth_image_3d, (self.kernel_size, self.kernel_size))
        image = cv2.resize(image, (600, 600))

        # Render images:
        #   rgb on the left
        #   depth rendered on the right
        return np.hstack((depth_image_3d, color_image, image))

def preprocess_depth_map(depth_map, min_depth: float, max_depth: float, min_intensity: int, power: float):
    """Convert depth map from RealSense to more sensible values, by
    scaling and clipping.

    :param depth_map:
    :type depth_map: np.array I think
    :param min_depth:
    :type min_depth: int
    :param max_depth:
    :type max_depth: int
    :return: the processed depth map
    :rtype:
    """
    min_depth = min_depth / Z16_TO_METRES
    max_depth = max_depth / Z16_TO_METRES

    x = [min_depth, max_depth]
    y = [255, min_intensity]
    pw = power

    A = np.exp(np.log(y[0] / y[1]) / pw)
    a = (x[0] - x[1] * A) / (A - 1)
    b = y[0] / (x[0] + a) ** pw

    # Clip to max value
    depth_map[np.where(depth_map > max_depth)] = -a # max_depth
    depth_map[np.where(depth_map == 0)] = -a  # max_depth
    # Clip to min value
    depth_map[np.where(depth_map < min_depth)] = min_depth

    depth_map = func(depth_map, a, b, pw)

    if isinstance(depth_map, np.ndarray):
        depth_map = depth_map.astype(np.uint8)
    elif isinstance(depth_map, float):
        depth_map = int(depth_map)
    return depth_map

def func(x, adj1, adj2, pw):
    return ((x + adj1) ** pw) * adj2