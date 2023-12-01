"""
RealSense input streams

Author: @RuizSerra
Date:   20220909
Modified by @rui_jin_jerry
Data: 20221020
"""

import pyrealsense2 as rs
import numpy as np

from input_streams.base import InputStream
from utils.archival_handler import ArchivalHandler
from utils.logging import input_logger
from datetime import datetime
import os

Z16_TO_METRES = 1.0 / 1000
# We will be removing the background of objects more than
#  clipping_distance_in_meters meters away
clipping_distance_in_meters = 1  # 1 meter
clipping_distance = clipping_distance_in_meters / Z16_TO_METRES


def preprocess_depth_map(depth_map, min_depth: int, max_depth: int):
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
    # Clip to max value
    depth_map[np.where(depth_map > max_depth)] = max_depth
    depth_map[np.where(depth_map == 0)] = max_depth
    # Clip to min value
    depth_map[np.where(depth_map < min_depth)] = min_depth

    depth_map = depth_to_uint8(depth_map, min_depth, max_depth)

    return depth_map


def depth_to_uint8(src, min_value, max_value, power=None):
    """
    Linear map from (min_value, max_value) to (255, 0)

    NOTE: The gradient of the map is negative, so output is (255, 0) -- not (0, 255)!

    If power is provided, a non-linear function is used to map

    :param src:  Can be a single value (e.g. int or float), or a np.ndarray
    :param min_value:
    :param max_value:
    :param power: (float) exponent for non-linear power function
    :return:  An int, or a np.ndarray of dtype=np.uint8
    """
    gradient = (0 - 255) / (max_value - min_value)
    intercept = 255 * min_value / (max_value - min_value) + 255
    ret = gradient * src + intercept
    # TODO Between 30% to max, most of change happens early, device is off, mid, high just noticiable difference
    # TODO Use static image for calibration and training
    # Apply nonlinear map to accentuate close values, attenuate far values
    if power:
        ret = 255 ** (1 - power) * ret ** power

    if isinstance(ret, np.ndarray):
        ret = ret.astype(np.uint8)
    elif isinstance(ret, float):
        ret = int(ret)
    return ret


class RealSenseBase(InputStream):

    def __init__(self):
        super().__init__()

        # filters source: BVT kitchen pancake/input_capture/realsense_ic.py
        # NOTE: this could be moved to config file if the end user needs to
        #       touch it much.
        # enable decimation filter
        decimation = rs.decimation_filter()
        decimation.set_option(rs.option.filter_magnitude, 2)

        # enable spatial filter
        spatial = rs.spatial_filter()
        spatial.set_option(rs.option.filter_magnitude, 2)
        spatial.set_option(rs.option.filter_smooth_alpha, 0.5)
        spatial.set_option(rs.option.filter_smooth_delta, 20)
        spatial.set_option(rs.option.holes_fill, 1)

        # enable temporal filter
        temporal = rs.temporal_filter()
        temporal.set_option(rs.option.filter_smooth_alpha, 0.1)
        temporal.set_option(rs.option.filter_smooth_delta, 40)

        # enable hole filling filter
        hole_filling = rs.hole_filling_filter()
        hole_filling.set_option(rs.option.holes_fill, 1)

        # enable depth to disparity and disparity to depth filters
        depth_to_disparity = rs.disparity_transform(True)
        disparity_to_depth = rs.disparity_transform(True)

        # Create a dictionary containing all of the realsense filters
        self.filters = {
            #            'decimation': decimation,
            #            'spatial': spatial,
            'temporal': temporal,
            #            'hole_filling': hole_filling,
            #            'depth_to_disparity': depth_to_disparity,
            #            'disparity_to_depth': disparity_to_depth
        }

        self.pipeline = None  # pipeline to be instantiated in each subclass
        self.align = None
        self.config = None

    def read(self):
        frames = self.pipeline.wait_for_frames()
        aligned_frames = self.align.process(frames)

        # RGB frame
        color_frame = aligned_frames.get_color_frame()
        rgb_img = np.asanyarray(color_frame.get_data())

        # Depth frame: filtered, value-scaled
        depth_frame = aligned_frames.get_depth_frame()
        for f in self.filters.values():
            depth_frame = f.process(depth_frame)
        depth_img = np.asanyarray(depth_frame.get_data())
        # Uncomment this for pre-processing depth image here, moved to vp module
        # depth_img = preprocess_depth_map(depth_img, 0, 2)

        return np.dstack((rgb_img, depth_img))

    def stop(self):
        self.pipeline.stop()

        # Properly close any objects/streams to ensure correct video file writing
        del self.pipeline
        del self.config
        # del self.sensors
        # del self.device
        self.pipeline = None
        self.config = None
        # self.sensors = None
        # self.device = None


class RealSenseCapture(RealSenseBase):

    def __init__(self, archival_dir=None):
        super().__init__()

        self.pipeline = rs.pipeline()
        self.name = 'realsense'
        self.config = rs.config()
        self.config.enable_stream(rs.stream.depth, rs.format.z16, 30)
        self.config.enable_stream(rs.stream.color)
        self.timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        if archival_dir:
            self.archival_handler = ArchivalHandler(
                archival_dir,
                output_size=None,
                pipeline_config=None)
            # TODO refactor this to self.archival_handler.video_filepath)
            self.filename = self.timestamp + '.bag'
            self.path = os.path.join(archival_dir, self.filename)
            self.config.enable_record_to_file(self.path)

        profile = self.pipeline.start(self.config)
        self.align = rs.align(rs.stream.color)

        # Skip 5 first frames to give the Auto-Exposure time to adjust
        for _ in range(5):
            self.pipeline.wait_for_frames()

    def init_archival(self, pipeline_config=None, frame_width=None):
        self.archival_handler.pipeline_config = pipeline_config

    def archive(self, frame):
        pass

class RealSenseBag(RealSenseBase):

    def __init__(self, bag_filepath: str):
        super().__init__()
        self.name = 'realsense'
        self.pipeline = rs.pipeline()
        self.config = rs.config()
        self.config.enable_device_from_file(bag_filepath, repeat_playback=False)
        self.config.enable_stream(rs.stream.depth, rs.format.z16, 30)
        self.config.enable_stream(rs.stream.color)
        profile = self.pipeline.start(self.config)
        profile.get_device().as_playback().set_real_time(False)
        self.align = rs.align(rs.stream.color)

        # Skip 5 first frames to give the Auto-Exposure time to adjust
        for _ in range(5):
            self.pipeline.wait_for_frames()

    def init_archival(self, pipeline_config=None, frame_width=None):
        input_logger.warning('Archival is not allowed for .bag file inputs.')

    def archive(self, frame):
        pass
