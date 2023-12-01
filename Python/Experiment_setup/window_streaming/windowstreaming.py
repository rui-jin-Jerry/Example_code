# Modified by @rui_jin_jerry
# Data: 20221020

import tkinter as tk
import threading
import cv2
import numpy as np
import re
import winsound  # for sound
import time  # for sleep

import utils.systemsynchandler as SS
from utils.logging import ws_logger

class WindowGUI:
    def __init__(self, master):
        self.master = master
        self.current_frame = None
        self.lock = threading.Lock()
        master.title("WindowGUI")

        self.mute_flag = False
        self.Add_flag = False
        self.Minus_flag = False
        self.config_refresh_flag = False
        self.config_refresh = False

        self.label = tk.Label(master, text="Mobility on SSD")
        self.label.pack()

        # Create some buttons
        self.button = tk.Button(master, text="Quit", command=master.quit)
        self.button1 = tk.Button(master, text="Add", command=self.Add)
        self.button2 = tk.Button(master, text="Minus", command=self.Minus)
        self.button3 = tk.Button(master, text="Mute", command=self.Mute)
        self.button4 = tk.Button(master, text="Unmute", command=self.Unmute)
        self.button5 = tk.Button(master, text="Calibration_AOV", command=self.Calibration_AOV)
        self.button6 = tk.Button(master, text="Calibration_Threshold", command=self.Calibration_Threshold)
        self.button7 = tk.Button(master, text="vOICe_Intensity", command=self.vOICe_Intensity)
        self.button8 = tk.Button(master, text="vOICe_Depth", command=self.vOICe_Depth)
        self.button9 = tk.Button(master, text="BrainPort_Intensity", command=self.BrainPort_Intensity)
        self.button10 = tk.Button(master, text="BrainPort_Depth", command=self.BrainPort_Depth)
        self.button12 = tk.Button(master, text="Cane", command=self.Cane)
        self.button13 = tk.Button(master, text="MiniGuide", command=self.MiniGuide)
        self.button11 = tk.Button(master, text="Refresh_config", command=self.Refresh_config)

        self.buttons = [self.button,self.button1,self.button2,self.button3,self.button4,self.button5,
                        self.button6,self.button7,self.button8,self.button9,self.button10,self.button11, self.button12, self.button13]

        self.button.pack(side=tk.LEFT)
        self.button1.pack(side=tk.LEFT)
        self.button2.pack(side=tk.LEFT)
        self.button3.pack(side=tk.LEFT)
        self.button4.pack(side=tk.LEFT)
        self.button5.pack(side=tk.LEFT)
        self.button6.pack(side=tk.LEFT)
        self.button7.pack(side=tk.LEFT)
        self.button8.pack(side=tk.LEFT)
        # self.button9.pack(side=tk.LEFT)
        # self.button10.pack(side=tk.LEFT)
        self.button12.pack(side=tk.LEFT)
        self.button13.pack(side=tk.LEFT)
        self.button11.pack(side=tk.LEFT)

        self.sync_handler = SS.SystemSyncHandler(serial_port='COM13')

        # Create an input box to set recording file name
        self.input = tk.StringVar()
        self.input_value = None
        self.input_box = tk.Entry(master, textvariable=self.input)
        self.label2 = tk.Button(master, text="Submit", command=self.handle_submit_click)
        self.label3 = tk.Label(master, text="")

        self.input_box.pack(side=tk.LEFT)
        self.label2.pack(side=tk.LEFT)
        self.label3.pack(side=tk.TOP)


    def set_current_frame(self, frame):

        self.current_frame = frame.astype(np.uint8)
        frame_show = cv2.resize(self.current_frame, (1500, 450))
        cv2.imshow('frame', frame_show)
        # cv2.resizeWindow('frame',700,200)

        cv2.waitKey(10)
        # cv2.destroyAllWindows()

    def Add(self):
        self.Add_flag = True
        # self.button1.config(bg='red')

    def Minus(self):
        self.Minus_flag = True

    def Mute(self):
        self.mute_flag = True

        # Set pressed button to red
        self.button3.config(bg='red')
        # Set all other buttons to white
        # for other_button in self.buttons:
        #     if other_button != self.button3:
        #         other_button.config(bg="white")

    def Unmute(self):
        self.mute_flag = False
        self.sync_handler.write(SS.SyncCodes.Unmute_Start)

        winsound.Beep(700, 1000)
        time.sleep(0.25)

        # Set pressed button to re
        self.button3.config(bg='White')
        # Set all other buttons to white
        # for other_button in self.buttons:
        #     if other_button != self.button4:
        #         other_button.config(bg="white")

    def Calibration_AOV(self):
        self.config_refresh_flag = 'calibration'
        self.config_refresh = True
        self.sync_handler.write(SS.SyncCodes.Recording_Start)

        # Set pressed button to red
        self.button5.config(bg='red')
        # Set all other buttons to white
        for other_button in self.buttons:
            if other_button != self.button5:
                other_button.config(bg="white")

    def Calibration_Threshold(self):
        self.config_refresh_flag = 'calibration_threshold'
        self.config_refresh = True
        self.sync_handler.write(SS.SyncCodes.Recording_Start)

        # Set pressed button to red
        self.button6.config(bg='red')
        # Set all other buttons to white
        for other_button in self.buttons:
            if other_button != self.button6:
                other_button.config(bg="white")

    def vOICe_Intensity(self):
        self.config_refresh_flag = 'vOICe_Intensity'
        self.config_refresh = True
        self.sync_handler.write(SS.SyncCodes.Recording_Start)

        # Set pressed button to red
        self.button7.config(bg='red')
        # Set all other buttons to white
        for other_button in self.buttons:
            if other_button != self.button7:
                other_button.config(bg="white")

    def vOICe_Depth(self):
        self.config_refresh_flag = 'vOICe_Depth'
        self.config_refresh = True
        self.sync_handler.write(SS.SyncCodes.Recording_Start)

        # Set pressed button to red
        self.button8.config(bg='red')
        # Set all other buttons to white
        for other_button in self.buttons:
            if other_button != self.button8:
                other_button.config(bg="white")

    def BrainPort_Intensity(self):
        self.config_refresh_flag = 'BrainPort_Intensity'
        self.config_refresh = True
        self.sync_handler.write(SS.SyncCodes.Recording_Start)

        # Set pressed button to red
        self.button9.config(bg='red')
        # Set all other buttons to white
        for other_button in self.buttons:
            if other_button != self.button9:
                other_button.config(bg="white")


    def BrainPort_Depth(self):
        self.config_refresh_flag = 'BrainPort_Depth'
        self.config_refresh = True
        self.sync_handler.write(SS.SyncCodes.Recording_Start)

        # Set pressed button to red
        self.button10.config(bg='red')
        # Set all other buttons to white
        for other_button in self.buttons:
            if other_button != self.button10:
                other_button.config(bg="white")

    def Cane(self):
        self.config_refresh_flag = 'Cane'
        self.config_refresh = True
        self.sync_handler.write(SS.SyncCodes.Recording_Start)

        # Set pressed button to red
        self.button12.config(bg='red')
        # Set all other buttons to white
        for other_button in self.buttons:
            if other_button != self.button12:
                other_button.config(bg="white")


    def MiniGuide(self):
        self.config_refresh_flag = 'MiniGuide'
        self.config_refresh = True
        self.sync_handler.write(SS.SyncCodes.Recording_Start)

        # Set pressed button to red
        self.button13.config(bg='red')
        # Set all other buttons to white
        for other_button in self.buttons:
            if other_button != self.button13:
                other_button.config(bg="white")

    def Refresh_config(self):
        self.config_refresh_flag = 'default'
        self.config_refresh = True

    def handle_submit_click(self):
        self.input_value = self.input.get()
        ws_logger.info('Trial : %s', self.input_value)
        self.label.config(text=self.label.cget("text") + ' ' + self.input_value)
        self.input.set(update_trial_num(self.input_value))
        # self.input_box.delete(0,tk.END)

def update_trial_num(string):
    # Find the number using regular expressions
    match = re.search(r'\d+', string)

    if match:
        # Extract the number from the match object
        number = int(match.group(0))
        # Add one to the number
        number += 1
        # Replace the original number with the updated number in the string
        string = re.sub(r'\d+', str(number), string)

    return string

# if __name__ == '__main__':
root = tk.Tk()
my_gui = WindowGUI(root)
#root.mainloop()


