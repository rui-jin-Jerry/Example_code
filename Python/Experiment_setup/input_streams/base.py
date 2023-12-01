"""
Base class for input stream
"""

import imutils
import threading

from utils.archival_handler import ArchivalHandler
from utils.logging import input_logger


class InputStream:

    def __init__(self, archival_dir=None):
        self.stopped = False
        self.archival_dir = archival_dir
        self.archival_handler = None

    def init_archival(self, pipeline_config=None, frame_width=None,
                      queue_max: int = 1024):

        if not self.archival_dir:
            return

        output_size = imutils.resize(
            self.read(),
            width=frame_width).shape
        self.archival_handler = ArchivalHandler(
            self.archival_dir,
            output_size=output_size[:2],
            pipeline_config=pipeline_config)

        input_logger.debug('Spinning up thread for archival')
        t = threading.Thread(target=self.archival_handler.run)
        # t.daemon = True
        t.start()

    def read(self):
        raise NotImplementedError

    def stop(self):
        raise NotImplementedError
