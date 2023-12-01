"""
Handles the storage of data to disk for archival purposes

Author: @RuizSerra
Date:   202109 (for BVT-kitchen)
Modified by @rui_jin_jerry
Data: 20221020
"""

import cv2
from datetime import datetime
import os
from queue import Queue
import yaml

from utils.logging import ah_logger


class ArchivalHandler:
    # When writing video to disk, we need to know the FPS in advance. As a quick
    # workaround for this, we can use approximate values for each type, based on
    # very rough very quick tests.
    APPROX_FPS = {'webcam': 220.0,
                  'realsense': 15.0}

    OUTPUT_FORMAT = '.mp4'


    def __init__(self,
                 exports_dir,
                 output_size=None,
                 pipeline_config=None):

        self.stopped = False

        # Pipeline config will be written to metadata file at the end (when
        # calling self.stop()), to keep track of the processing done during
        # a trial, to be able to replicate output later on.
        self.pipeline_config = pipeline_config

        # Filenames
        self.exports_dir = exports_dir
        if not os.path.exists(self.exports_dir):
            os.mkdir(self.exports_dir)
        self.timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        video_filename = f'otchkies_{self.timestamp}'
        self.video_filepath = os.path.join(self.exports_dir,
                                           video_filename + self.OUTPUT_FORMAT)


        # Initialise video writer if needed
        if output_size:
            self.video_writer = get_video_writer(
                self.video_filepath,
                output_size=output_size) #,
                #fps=self.APPROX_FPS.get(pipeline_config['input_stream']['name'], 15.0))
            self.frame_queue = Queue(maxsize=0)

        ah_logger.info("Storing input stream to disk: "
                       f"{self.video_filepath} {output_size}")


    def write_to_video(self, frame):
        """Write frame to video_writer video stream"""
        self.video_writer.write(frame)

    def write_to_disk(self, frame):
        """Write image to disk"""
        img_filename = f'otchkies_{datetime.now().strftime("%Y%m%d-%H%M%S-%f")}.png'
        img_path = os.path.join(self.exports_dir, img_filename)
        cv2.imwrite(img_path, frame)

    def run(self):
        while not self.stopped:
            # get frame from queue
            frame = self.frame_queue.get()
            # NOTE: we are only writing RGB, not depth channel,
            #       but this should be enough since this handler is only
            #       used for 'webcam'-type streams---RealSense input has
            #       its own handler built in (see
            #       input_streams.realsense.RealSenseCapture)
            self.write_to_video(frame[:, :, :3])

    def stop(self, fps_object=None):
        """

        :param fps_object:
        :type fps_object: imutils.video.FPS
        :return:
        :rtype:
        """
        self.stopped = True

        # Release video stream (IO)
        if hasattr(self, 'video_writer'):
            self.video_writer.release()
            ah_logger.info(f"Released video")

        # Write config and stats to metadata file
        self.archival_dir = self.pipeline_config['input_stream']['archival_dir']
        module_name = self.pipeline_config['module_chain'][0]['name']
        output_name = self.pipeline_config['output_streams'][0]['name']
        self.file_name = output_name+'_'+module_name+'_'+self.timestamp+'.yml'
        metadata_file = os.path.join(self.exports_dir,self.file_name)
        output_data = {
            'video_file': metadata_file,
            'pipeline': self.pipeline_config
        }
        if fps_object:
            output_data.update({
                'elapsed_time': fps_object.elapsed(),
                'fps': fps_object.fps()
            })

        with open(metadata_file, 'w') as f:
            yaml.dump(output_data, f, default_flow_style=False)

        ah_logger.info(f"Wrote metadata file {metadata_file}")

    def __del__(self):
        self.stop()


def get_video_writer(video_filename, output_size=(384, 768), fps=23.0):
    codec_formats = {'mp4': 'mp4v',
                     'avi': 'XVID',
                     'fmp4': 'FMP4'}

    output_format = video_filename.split('.')[-1]

    # Define the codec and create VideoWriter object
    try:
        fourcc = cv2.VideoWriter_fourcc(*codec_formats[output_format])
    except KeyError:
        fourcc = -1

    out = cv2.VideoWriter(video_filename, fourcc, fps, output_size[::-1])

    ah_logger.debug(f'New video writer for file: {video_filename} '
                    f'with codec {codec_formats[output_format]}')
    ah_logger.debug(f'Output size: {output_size}')

    return out
