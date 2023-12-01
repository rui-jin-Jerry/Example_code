"""
Main entry point, execution loop

Author: @RuizSerra
Date:   20220909

Modified by @rui_jin_jerry
Data: 20221020
"""

import argparse

import cv2
import gin
import importlib
import imutils
import os
import sys
import threading
import time
import numpy as np
import winsound  # for sound
import time  # for sleep


import input_streams
import output_streams
import web_streaming
import utils.frame_format
import window_streaming.windowstreaming
from utils.logging import main_logger
import utils.systemsynchandler as SS
import keyboard

@gin.configurable
class PipelineLoop:
    FRAME_WIDTH = 800

    def __init__(self,
                 config_filepath: str,
                 warmup_time: float = 2.0):
        """Backbone of the application, a bus to coordinate the information flow.

        :param config_filepath: path to configuration file
        :type config_filepath: str
        :param warmup_time: Pause time after initialisation to let the system warm up (camera adjustment).
        :type warmup_time: float
        """

        self.input_stream = None
        self.module_chain = None
        self.output_streams = None
        self.control_stream = None
        self.archival_handler = None
        self.config_filepath = config_filepath
        self.load_config(config_filepath)
        time.sleep(warmup_time)  # Allow system warm-up time
        self.fps = imutils.video.FPS().start()
        self.stopped = False
        # Move this to webstreaming
        #self.sync_handler = SS.SystemSyncHandler(serial_port='COM12')
        self.key_flag = True



    def load_config(self, config_filepath):
        """
        :param config_filepath:
        :type config_filepath:
        :return:
        :rtype:
        """

        # Load configuration from file
        pipeline_config = load_config_from_file(config_filepath)['pipeline']

        # Initialise input and archival handling
        self.input_stream = initialise_input_stream(pipeline_config['input_stream'])
        # Get stream frame size to configure the archival handler's video writer
        if pipeline_config['input_stream'].get('archival_dir'):
            self.input_stream.init_archival(pipeline_config, frame_width=self.FRAME_WIDTH)
            self.control_stream.sync_handler.write(SS.SyncCodes.Recording_Start)
            main_logger.info("Send trigger at the start of recording: ")

        # Initialise vision processing modules and output streams
        self.module_chain = initialise_modules(pipeline_config['module_chain'])
        self.output_streams = initialise_output_streams(pipeline_config['output_streams'])


    def process_frame_stream(self):
        """Main entry point, this is started in a separate thread as a daemon,
        and keeps coordinating information (frames) between streams.
        """
        # Loop over frames from the video stream
        while not self.stopped:
            # Check if we need to reload the configuration
            if self.control_stream and self.control_stream.config_refresh:
                if self.control_stream.config_refresh_flag == 'default':
                    self.load_config(r"C:\Users\jinr2.STUDENT\Software\config\default.yml")
                    self.control_stream.config_refresh = False
                elif self.control_stream.config_refresh_flag == 'calibration':
                    self.load_config(r"C:\Users\jinr2.STUDENT\Software\config\calibration_aov_config.yml")
                    self.control_stream.config_refresh = False
                elif self.control_stream.config_refresh_flag == 'calibration_threshold':
                    self.load_config(r"C:\Users\jinr2.STUDENT\Software\config\calibration_threshold_config.yml")
                    self.control_stream.config_refresh = False
                elif self.control_stream.config_refresh_flag == 'vOICe_Intensity':
                    self.load_config(r"C:\Users\jinr2.STUDENT\Software\config\vOICe_Intensity_config.yml")
                    self.control_stream.config_refresh = False
                elif self.control_stream.config_refresh_flag == 'vOICe_Depth':
                    self.load_config(r"C:\Users\jinr2.STUDENT\Software\config\vOICe_Depth_config.yml")
                    self.control_stream.config_refresh = False
                elif self.control_stream.config_refresh_flag == 'BrainPort_Intensity':
                    self.load_config(r"C:\Users\jinr2.STUDENT\Software\config\BrainPort_Intensity_config.yml")
                    self.control_stream.config_refresh = False
                elif self.control_stream.config_refresh_flag == 'BrainPort_Depth':
                    self.load_config(r"C:\Users\jinr2.STUDENT\Software\config\BrainPort_Depth_config.yml")
                    self.control_stream.config_refresh = False
                elif self.control_stream.config_refresh_flag == 'Face':
                    self.load_config(r"C:\Users\jinr2.STUDENT\Software\config\Face_config.yml")
                    self.control_stream.config_refresh = False
                elif self.control_stream.config_refresh_flag == 'Cane':
                    self.load_config(r"C:\Users\jinr2.STUDENT\Software\config\Cane_config.yml")
                    self.control_stream.config_refresh = False
                elif self.control_stream.config_refresh_flag == 'MiniGuide':
                    self.load_config(r"C:\Users\jinr2.STUDENT\Software\config\MiniGuide_config.yml")
                    self.control_stream.config_refresh = False
                else:
                    pass

            # Send the signal when space/button been pressed and flase flag when release
            if keyboard.is_pressed('t') and self.key_flag:
                self.control_stream.sync_handler.write(SS.SyncCodes.Obstacle_Found)
                winsound.Beep(800, 500)
                # time.sleep(0.25)
                self.key_flag = False
            else:
                pass

            if not keyboard.is_pressed('t'):
                self.key_flag = True
                pass
            else:
                self.key_flag = False
                pass

            # Read the next frame from the video stream and resize it
            frame = self.input_stream.read()
            frame = imutils.resize(frame, width=self.FRAME_WIDTH)

            # Put frame in the queue is recording without realsense capture
            if not 'realsense' in [self.input_stream.name]:
                if hasattr(self.input_stream, 'archival_handler') and \
                        self.input_stream.archival_handler:
                    if self.input_stream.archival_handler.frame_queue.full():
                        main_logger.warning('Archival handler frame queue full')
                    self.input_stream.archival_handler.frame_queue.put(frame)

            # Perform processing by active modules
            # TODO: eventually we probably want a separate module_chain for
            #       each output_stream, so that each output can have video
            #       processed differently.
            for module in self.module_chain:

                utils.frame_format.format(module, frame)
                if 'Calibration_Threshold' in [type(module).__name__]:
                    if self.control_stream.Add_flag:
                        frame = module.process(frame, self.control_stream.Add_flag, False)
                        self.control_stream.Add_flag = False
                    elif self.control_stream.Minus_flag:
                        frame = module.process(frame, False, self.control_stream.Minus_flag)
                        self.control_stream.Minus_flag = False
                    else:
                        frame = module.process(frame, False, False)
                else:
                    frame = module.process(frame)


            for output in self.output_streams:

                # Mute device output when mute_flag is true
                if 'VOICeOutput' in [type(output).__name__] and self.control_stream.mute_flag:
                    frame = np.zeros((600, 800, 3), dtype=np.uint8)
                    cv2.putText(frame, 'Muted', (50, frame.shape[0] - 50),
                                cv2.FONT_HERSHEY_SIMPLEX, 3, (0, 0, 255), 3)

                if 'BrainportOutput' in [type(output).__name__] and self.control_stream.mute_flag:
                    frame = np.zeros((600, 800, 3), dtype=np.uint8)
                    cv2.putText(frame, 'Muted', (50, frame.shape[0] - 50),
                                cv2.FONT_HERSHEY_SIMPLEX, 3, (0, 0, 255), 3)

                if 'WindowGUI' in [type(output).__name__] and self.control_stream.mute_flag:
                    frame = np.zeros((600, 800, 3), dtype=np.uint8)
                    cv2.putText(frame, 'Muted', (50, frame.shape[0] - 50),
                                cv2.FONT_HERSHEY_SIMPLEX, 3, (0, 0, 255), 3)

                # Acquire the lock, set the output frame, and release the lock
                with output.lock:
                    # TODO: may need to change frame to output.FRAME_SPEC
                    #       like we did in utils.frame_format.format() above
                    output.set_current_frame(frame.copy())
            # Update fps statistic
            self.fps.update()

    def stop(self):
        main_logger.info('Stopping video stream...')
        self.stopped = True

        # FPS statistics
        self.fps.stop()
        main_logger.info("Elasped time: {:.2f}".format(self.fps.elapsed()))
        main_logger.info("Approx. FPS: {:.2f}".format(self.fps.fps()))

        # Release any output video stream we were writing to
        if self.input_stream.archival_handler:
            self.input_stream.archival_handler.stop(fps_object=self.fps)
        # Stop the input stream
        self.input_stream.stop()

    def set_control_stream(self, control_stream):
        self.control_stream = control_stream


def load_config_from_file(filepath):
    """Load configuration from file. File can be `.yml`, `.gin`.

    Refer to `docs/modules.md` for more details, or see `config/default.yml`
    for reference.

    :return config (dict)"""

    if filepath.endswith('.yml') or filepath.endswith('.yaml'):
        import yaml
        import sys
        sys.path.append('.')
        with open(filepath, "r") as f:
            try:
                config = yaml.full_load(f)
            except yaml.YAMLError as exc:
                exit(exc)
    elif filepath.endswith('.gin'):
        gin.parse_config_file(filepath)
    else:
        raise ValueError(
            f'Config file format "{args["config"].split(".")[-1]}" invalid.')

    try:
        main_logger.info(f'Loaded config from file "{filepath}"')
    except:
        pass

    return config


def initialise_input_stream(input_stream: dict):
    """Instantiate the relevant video stream given the name.

    Allowed values:
      - webcam: use the laptop's webcam
      - realsense: use a connected Intel RealSense
      - path/to/bag_file.bag: path to a `.bag` file
      - RPi: use a Raspberry Pi camera?

    :param input_stream: a string defining the input stream type (or path)
    :type input_stream: str
    :return: an input stream
    :rtype: {VideoStream, input_streams.realsense.RealSenseBase}
    """

    # Reading from camera
    stream_registry = {
        'realsense': input_streams.realsense.RealSenseCapture,
        'webcam': input_streams.imutils_vs.WebcamCapture,
        'RPi': input_streams.imutils_vs.RaspberryPiCapture,
    }
    if input_stream['name'] in stream_registry.keys():
        vs = stream_registry[input_stream['name']](input_stream.get('archival_dir'))
    elif input_stream['name'].endswith('.bag') and os.path.exists(input_stream['name']):
        vs = input_streams.realsense.RealSenseBag(input_stream['name'])
    else:
        raise ValueError(f'Invalid input_stream "{input_stream["name"]}"')

    main_logger.info(f'Loaded input stream "{input_stream["name"]}"')

    return vs


def initialise_modules(module_list: tuple):
    """Given a list of modules, find their implementation and instantiate them.

    See `config/default.yml` for module spec reference.

    :param module_list: A list of module specs (dict)
    :type module_list: tuple
    :return: instantiated and initialised VP modules
    :rtype: tuple
    """
    if not module_list:
        return ()
    mods = []
    for module_dict in module_list:
        if module_dict.get('path'):
            sys.path.append(module_dict.get('path'))
        m = '.'.join(module_dict['implementation'].split('.')[:-1])
        c = module_dict['implementation'].split('.')[-1]
        mod = importlib.import_module(m)
        mods.append(getattr(mod, c)(**module_dict.get('kwargs', {})))
        main_logger.info(
            f'Loaded vision processing module: "{module_dict["name"]}"')
    return tuple(mods)


def initialise_output_streams(outputs: tuple):
    """Initialise the output streams provided

    :param outputs: dicts with o['name'] in {'web', 'voice', 'brainport'}
    :type outputs: tuple
    :return: instantiated and initialised output streams
    :rtype: tuple
    """
    output_names = [o['name'] for o in outputs]
    ret = []
    for output_config in outputs:
        if output_config['name'] == 'web':
            ret.append(web_streaming.server)
        elif output_config['name'] == 'window':
            ret.append(window_streaming.windowstreaming.my_gui)
        elif output_config['name'] == 'voice':
            ret.append(output_streams.interfaces.VOICeOutput())
        elif output_config['name'] == 'brainport':
                ret.append(output_streams.interfaces.BrainportOutput())
                main_logger.info(f'Connection to BrainPort successful')

    return tuple(ret)


if __name__ == '__main__':

    # Command line argument parsing --------------------------------------------
    # Parse the command line arguments provided at startup
    ap = argparse.ArgumentParser()
    ap.add_argument("-c", "--config", type=str, default='config/default.yml',
        help="path/to/config_file.yml defining pipeline")
    args = vars(ap.parse_args())

    # Start application --------------------------------------------------------
    # Initialise each of the components of the application (input streams,
    # vision processing modules, output streams), and pass them to the pipeline
    # loop, which is the backbone of the application, acting as a "bus" of sorts.
    main_pipeline = PipelineLoop(config_filepath=args['config'])

    # Start a thread that will distribute the work to and from streams and VP
    # modules.
    t = threading.Thread(target=main_pipeline.process_frame_stream)
    # t.daemon = True
    t.start()

    main_logger.debug('Active threads: %s', threading.active_count())

    # # get a list of all active threads
    # threads = threading.enumerate()
    # # report the name of all active threads
    # for thread in threads:
    #     print(thread.name)

    # print(main_pipeline.output_streams)
    if 'WindowGUI' in [type(o).__name__ for o in main_pipeline.output_streams]:

        control_stream = main_pipeline.output_streams[
            [type(o).__name__
             for o in main_pipeline.output_streams].index('WindowGUI')]
        main_pipeline.set_control_stream(control_stream)

        window_streaming.windowstreaming.root.mainloop()

    # Tear down ----------------------------------------------------------
    main_pipeline.stop()
    main_logger.info('Stopped Window Streaming. Exit.')


    # If the web output stream is configured, start up the streaming server
    # (Flask app)
    if 'StreamingServer' in [type(o).__name__ for o in main_pipeline.output_streams]:
        # Set the StreamingServer as a control stream for the main pipeline
        # so that we can change the main pipeline attributes from the web UI.
        # Excuse the obscure way of getting the web server object off the
        # output_streams list!
        control_stream = main_pipeline.output_streams[
            [type(o).__name__
             for o in main_pipeline.output_streams].index('StreamingServer')]
        main_pipeline.set_control_stream(control_stream)

        # Start the flask app
        web_streaming.app.run(host=web_streaming.HOST_IP,
                              port=web_streaming.PORT,
                              debug=True,
                              threaded=True, use_reloader=False)

    # Tear down ----------------------------------------------------------
    main_pipeline.stop()
    main_logger.info('Stopped Streaming Server. Exit.')
