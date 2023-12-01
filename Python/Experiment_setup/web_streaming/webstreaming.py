"""
Stream frames to web endpoint

Adapted from: https://pyimagesearch.com/2019/09/02/opencv-stream-video-to-web-browser-html-page/

Author: @RuizSerra
Date:   20220908
"""

from flask import Flask, Response, request, render_template
import threading
import cv2
import gin
import datetime

from utils.logging import ws_logger
import utils.systemsynchandler as SS
# HOST_IP = '0.0.0.0'
# PORT = 8000

HOST_IP = '0.0.0.0'
PORT = 8080

@gin.configurable
class StreamingServer:

    def __init__(self, use_timestamp: bool = True):

        # Initialize the output frame and a lock used to ensure thread-safe
        # exchanges of the output frames (useful when multiple browsers/tabs
        # are viewing the stream)
        self.current_frame = None
        self.lock = threading.Lock()
        # The web UI has a button that can be used to refresh the config
        # (i.e. reload the config file). The button sets this flag, which
        # is checked by the main PipelineLoop at each timestep.
        self.config_refresh_flag = False
        self.config_refresh = False
        self.mute_flag = False
        self.Add_flag = False
        self.Minus_flag = False
        self.use_timestamp = use_timestamp
        # self.sync_handler = SS.SystemSyncHandler(serial_port='COM12')

    def set_current_frame(self, frame):
        # TODO: refactor this to inherit from output_streams.interfaces.OutputStream
        if self.use_timestamp:
            # grab the current timestamp and draw it on the frame
            timestamp = datetime.datetime.now()
            cv2.putText(frame, timestamp.strftime(
                "%A %d %B %Y %I:%M:%S%p"), (10, frame.shape[0] - 10),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.55, (0, 0, 255), 1)
        self.current_frame = frame

    def generate_encoded_frame(self):

        # loop over frames from the output stream
        while True:
            # wait until the lock is acquired
            with self.lock:
                # check if the output frame is available, otherwise skip
                # the iteration of the loop
                if self.current_frame is None:
                    continue
                #Resize for website view
                self.current_frame = cv2.resize(self.current_frame,(1500,370))
                # encode the frame in JPEG format
                (flag, encodedImage) = cv2.imencode(".jpg", self.current_frame)
                # ensure the frame was successfully encoded
                if not flag:
                    continue
            # yield the output frame in the byte format
            yield (b'--frame\r\n' b'Content-Type: image/jpeg\r\n\r\n' +
                   bytearray(encodedImage) + b'\r\n')


app = Flask(__name__)
ws_logger.info('Starting Streaming Server...')
server = StreamingServer()


@app.route("/", methods=['GET', 'POST'])
def index():
    """return the rendered template"""
    if request.method == 'POST':
        # Buttons to refresh (reload) the configuration (files)
        if request.form.get('refresh_config') == 'Refresh config':
            server.config_refresh_flag = "default"
            server.config_refresh = True
        elif request.form.get('Calibration_AOV') == 'Calibration_AOV':
            server.config_refresh_flag = 'calibration'
            server.config_refresh = True
            server.sync_handler.write(SS.SyncCodes.Recording_Start)
        elif request.form.get('Calibration_Threshold') == 'Calibration_Threshold':
            server.config_refresh_flag = 'calibration_threshold'
            server.config_refresh = True
            server.sync_handler.write(SS.SyncCodes.Recording_Start)
        elif request.form.get('vOICe_Intensity') == 'vOICe_Intensity':
            server.config_refresh_flag = 'vOICe_Intensity'
            server.config_refresh = True
            #server.sync_handler.write(SS.SyncCodes.Recording_Start)
        elif request.form.get('vOICe_Depth') == 'vOICe_Depth':
            server.config_refresh_flag = 'vOICe_Depth'
            server.config_refresh = True
            #server.sync_handler.write(SS.SyncCodes.Recording_Start)
        elif request.form.get('BrainPort_Intensity') == 'BrainPort_Intensity':
            server.config_refresh_flag = 'BrainPort_Intensity'
            server.config_refresh = True
            #server.sync_handler.write(SS.SyncCodes.Recording_Start)
        elif request.form.get('BrainPort_Depth') == 'BrainPort_Depth':
            server.config_refresh_flag = 'BrainPort_Depth'
            server.config_refresh = True
            #server.sync_handler.write(SS.SyncCodes.Recording_Start)
        elif request.form.get('Face') == 'Face':
            server.config_refresh_flag = 'Face'
            server.config_refresh = True
        elif request.form.get('Mute') == 'Mute':
            server.mute_flag = True
        elif request.form.get('Unmute') == 'Unmute':
            server.mute_flag = False
            server.sync_handler.write(SS.SyncCodes.Unmute_Start)
        elif request.form.get('Add') == 'Add':
            server.Add_flag = True
        elif request.form.get('Minus') == 'Minus':
            server.Minus_flag = True
        elif request.form.get('other_button_action') == 'Other button value':
            pass  # do something else
        else:
            ws_logger.error('Unknown value from button.')
    elif request.method == 'GET':
        return render_template('index.html')
    return render_template("index.html")


@app.route("/video_feed")
def video_feed():
    """
    return the response generated along with the specific media type (mime type)

    NOTE: before app.run(), we must set app.ss = StreamingServer()
    """
    return Response(server.generate_encoded_frame(),
                    mimetype="multipart/x-mixed-replace; boundary=frame")
