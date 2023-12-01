"""
Interfaces to output streams

Author: @RuizSerra
Date:   20220909
Modified by @rui_jin_jerry
Data: 20221020
"""

import cv2
import json
import numpy as np
import simpleaudio
import threading
import time
import websockets
import asyncio
import ssl

from utils.logging import output_logger
from utils import voice

# https://websockets.readthedocs.io/en/stable/design.html?highlight=state#state
CONNECTION_STATES = ('connecting', 'open', 'closing', 'closed')


class OutputStream:

    def __init__(self):
        self.current_frame = None
        self.lock = threading.Lock()
        self.release = threading.Lock().release

    def set_current_frame(self, frame):
        self.current_frame = frame


class VOICeOutput(OutputStream):

    def __init__(self):
        super().__init__()
        output_logger.info('Started vOICe output stream')
        self.__im2sound = voice.ImageToSound()

    def set_current_frame(self, frame):
        #Select processed frame from output frame
        frame = frame[:, 0:800, :]
        self.current_frame = frame
        self.process_output()


    def process_output(self):
        if (self.__im2sound.play_obj is None) or (not self.__im2sound.play_obj.is_playing()):
            if np.squeeze(self.current_frame).ndim > 2:  # Ensure images are 1-channel only
                self.current_frame = self.current_frame[:, :, 0]
            img_for_sound = cv2.resize(self.current_frame, (64, 64), interpolation=cv2.INTER_AREA)
            audio = self.__im2sound.process_image(img_for_sound, bspl=False)
            self.__im2sound.play_obj = simpleaudio.play_buffer(audio, 2, 2, self.__im2sound.sampling_freq)
            return 1
        return 0


class BrainportOutput(OutputStream):

    def __init__(self,
                 ws_uri: str = "wss://10.152.187.1:443",
                 connection_timeout: int = 5):
        """

        :param ws_uri:
        :type ws_uri:
        :param connection_timeout:
        :type connection_timeout:
        """
        super().__init__()

        self.ws = None
        self.ws_uri = ws_uri
        #self.loop = asyncio.get_event_loop()
        self.loop = asyncio.new_event_loop()
        # perform a synchronous connect
        self.loop.run_until_complete(asyncio.wait_for(self.__async_connect(self.ws_uri), connection_timeout))
        # self.__async_connect(self.ws_uri)
        # subscribe the payload handler to the stim loop topic
        # pub.subscribe(self.payload_handler, StimLoop.TOPIC_NEW_BRAINPORT_FRAME)
        #self.is_running = True

        output_logger.info('Started Brainport output stream')

    async def __async_connect(self, ws_uri):
        # perform async connect, and store the connected WebSocketClientProtocol
        # object, for later reuse for send & recv
        if ws_uri.startswith("wss"):
            self.ws = await websockets.connect(ws_uri,
                                               subprotocols=["iod-protocol"],
                                               ssl=ssl.SSLContext(),
                                               ping_interval=999999, ping_timeout=999999)
            # NOTE: the connection with BP will close after ping_interval*ping_timeout seconds,
            #       regardless of whether we are sending data or not

        else:
            self.ws = await websockets.connect(ws_uri, subprotocols=["iod-protocol"])

    def set_current_frame(self, frame):
        frame = frame[:, 0:800, :]
        self.current_frame = frame
        self.loop.run_until_complete(self.process_output())

    async def process_output(self):

        image = cv2.resize(self.current_frame, (20, 20))
        image = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY)
        img_bytes = image.astype(np.uint8).tobytes()
        data = self.generate_header(img_bytes)

        if not img_bytes:
            output_logger.error(f"NO input data ")

        if self.ws.state == CONNECTION_STATES.index('open'):
            await self.ws.send(data)
            await self.ws.send(img_bytes)
        else:
            close_code = getattr(self.ws, 'close_code', None)
            output_logger.error(
                f"Connection with BrainPort {CONNECTION_STATES[self.ws.state]}. "
                f"State code: {self.ws.state}. Close code: {close_code}")



    @staticmethod
    def generate_header(img_bytes: bytes) -> str:
        """
        Given an image in binary, generate the header for the image in JSON.

        For now, with hardcoded values. `d['length']` could use `sys.getsizeof(img_bytes)` instead.

        Seconds, nanoseconds, continue to increase as the program executes.

        Returns a stringified JSON object that can be sent to BP as is
        """

        # Get current timestamp and convert to seconds, nanoseconds
        sec, ns = divmod(time.monotonic(), 1)
        sec = int(sec)
        ns = int(round(ns, 6) * 1E6)

        # Populate data for header
        d = {"session": {
            #         "id": string,
            #         "ip": string,
            "timespec": {
                "seconds": sec,
                "nanoseconds": ns
            },
            "length": 400,  # <--------
            "format": "gray",
            "window": {
                "x": 0,
                "y": 0,
                "w": 20,
                "h": 20
            },
            "stream": True,  # Enable streaming to SEND data to BP from this client (as opposed to receive)
            #         "status": string,
            "close": False
        }
        }

        return json.dumps(d)
