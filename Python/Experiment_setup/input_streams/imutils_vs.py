"""
imutils input streams wrapper

Author: @RuizSerra
Date:   20220925
"""

from imutils.video import VideoStream

from input_streams.base import InputStream
from utils.logging import input_logger


class RaspberryPiCapture(InputStream):

    def __init__(self, archival_dir=None):
        super().__init__(archival_dir)
        self.vs = VideoStream(usePiCamera=1).start()

    def read(self):
        return self.vs.read()

    def stop(self):
        return self.vs.stop()


class WebcamCapture(InputStream):

    def __init__(self, archival_dir=None):
        super().__init__(archival_dir)

        for i in range(0,5):
            self.vs = VideoStream(src=i).start()
            try:
                self.vs.read()
                break
            except Exception as e:
                input_logger.warning(f'Input source {i} failed, trying next.')

    def read(self):
        return self.vs.read()

    def stop(self):
        return self.vs.stop()
