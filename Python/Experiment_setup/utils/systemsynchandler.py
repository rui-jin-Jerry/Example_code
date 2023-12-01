"""
Handles sync signal writing via serial port (through Arduino)

NOTE: may need to add linux user to "dialout" group or similar in
      order to access the serial port

Author: Jaime RS
Date:   Sep 2021
"""

import serial
from utils.logging import output_logger


class SyncCodes:
    Obstacle_Found = 1
    Unmute_Start = 2
    Recording_Start = 3


class SystemSyncHandler:

    def __init__(self, serial_port: str = 'COM13'):
        self.__serial_port = serial_port
        self.__arduino = self.__attempt_connection()

    def write(self, code: int):
        """The Arduino is programmed to to write `code` pulses of 100ms width to pin D13"""
        # self.__arduino = self.__attempt_connection()
        if self.__arduino:
            self.__arduino.write(bytes(str(code), 'utf-8'))
            output_logger.info(f"Sent sync signal '{code}' to serial port '{self.__serial_port}'")

    def __attempt_connection(self):
        try:
            arduino = serial.Serial(self.__serial_port, 9600)
        except Exception as e:
            arduino = None
            output_logger.error(f"Serial port '{self.__serial_port}' not available.")
        #arduino = serial.Serial(self.__serial_port, 9600)

        return arduino
