from main import *
import pyrealsense2 as rs
import numpy as np
import cv2
# import imutil

import pyc3dserver as c3d
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import find_peaks
import pandas as pd
from scipy import signal
import textwrap
from scipy.signal import butter, lfilter
import math


class LowVisionSubjectLocation():

    def __init__(self, config_filepath: str, marker_filepath: str, recording_filepath: str):

        self.config_filepath = config_filepath
        self.marker_filepath = marker_filepath
        self.recording_filepath = recording_filepath

        # Initialise config variable
        self.config = None

        # Initialise marker varible
        self.marker = None
        self.sync_signal = None
        self.dict_group = None
        self.marker_header = None
        self.segment_com = None
        self.com = None
        self.cane = None
        self.trigger = None

        # Initial output variable
        self.output_intensity = []

        # Initial fixed value
        self.startpoint = None  # Should be a fixed number of positional x,y

    def load_config(self, config_filepath):
        # Load meta file for each trial recording data
        self.config = load_config_from_file(config_filepath)

    def load_marker(self, marker_filepath):
        # Load marker set positional data from c3d file segment com and com

        itf = c3d.c3dserver()
        c3d_data = c3d.open_c3d(itf, marker_filepath)

        # For the information of all markers(points)
        self.marker = c3d.get_dict_markers(itf)
        self.sync_signal = c3d.get_dict_analogs(itf)
        self.dict_group = c3d.get_dict_groups(itf)
        self.marker_header = c3d.get_dict_header(itf)
        #         self.event_labels = self.dict_group['EVENT']['LABELS']
        #         self.event_times = self.dict_group['EVENT']['TIMES']
        self.rate = self.dict_group['POINT']['RATE']

        # Output center of mass variables
        self.com = self.get_marker('COFM')
        self.com_absvel = self.get_marker('COFMAbsoluteVel')[:, 2]
        self.com_lvel = self.get_marker('COFMLVel')

        # Output mobility cane parameters
        self.cane = self.get_marker('CANEc')
        self.cane_angel = self.get_marker('CANEAngle')
        self.cane_angelvel = self.get_marker('CANEsegAngVelDeg')

        # Set the start and end frame number
        #         self.trial_start_frame = int(self.event_times[np.where(self.event_labels == 'start')][0][0]*60 + self.event_times[np.where(self.event_labels == 'start')][0][1]*self.rate)
        #         self.trial_end_frame =  int(self.event_times[np.where(self.event_labels == 'touch')][0][0]*60 + self.event_times[np.where(self.event_labels == 'touch')][0][1]*self.rate)

        self.trial_start_frame = 0
        self.trial_end_frame = self.dict_group['POINT']['FRAMES']

    #         self.trial_found_frame = int(self.event_times[np.where(self.event_labels == 'found')][0][0]*60 + self.event_times[np.where(self.event_labels == 'found')][0][1]*self.rate)

    def load_recording_bag(self, recording_filepath):

        self.config['pipeline']['input_stream']['name'] = self.recording_filepath
        # Initialise input stream and vision process module chain
        input_stream = initialise_input_stream(self.config['pipeline']['input_stream'])
        module_chain = initialise_modules(self.config['pipeline']['module_chain'])

        # text config
        font = cv2.FONT_HERSHEY_SIMPLEX
        font_scale = 2
        thickness = 2
        color = (0, 0, 255)  # white
        frame_num = 0
        output_string = ""

        for key, value in self.config['pipeline'].items():
            output_string += f"{key}: {value}\n"

        lines = textwrap.wrap(str(self.config['pipeline']['module_chain']), width=50)

        # Initial frame list to store frames

        frame_number = 0

        # Loop through the frames in the bag file
        while True:

            try:

                frame = input_stream.read()

                frame = imutils.resize(frame, width=800)

                for module in module_chain:
                    frame = module.process(frame)

                frame = frame.astype(np.uint8)

                output = cv2.resize(frame[:, 0:800, 1],
                                    (self.config['pipeline']['module_chain'][0]['kwargs']['kernel_size'],
                                     self.config['pipeline']['module_chain'][0]['kwargs']['kernel_size']))

                #         output = average_without_zero(output.flatten())

                self.output_intensity.append(output)

                frame = cv2.resize(frame, (1500, 450))

                frame_number += 1

                cv2.putText(frame, str(frame_number), (30, 400), font, font_scale, color, thickness)

                y = 10
                for line in lines:
                    cv2.putText(frame, line, (30, y), font, 0.4, color, 1)
                    y += 13

                cv2.imshow('Image', frame)

                if cv2.waitKey(1) & 0xFF == ord('q'):
                    break

            except RuntimeError:

                break

        # Clean up
        input_stream.stop()
        cv2.destroyAllWindows()

    def set_sampling_rate(self):

        from scipy import signal

        self.sync_signal_resampled = signal.resample(self.sync_signal['DATA']['Voltage.Sync'],
                                                     self.dict_group['TRIAL']['ACTUAL_END_FIELD'][0])

    def set_trigger(self):

        peaks, _ = find_peaks(self.sync_signal_resampled, height=0.5, distance=8)

        threshold = 500
        numbers = peaks
        nnumbers = np.array(numbers)
        self.trigger = pd.DataFrame({
            'numbers': numbers,
            'segment': np.cumsum([0] + list(1 * (nnumbers[1:] - nnumbers[0:-1] > threshold))) + 1
        }).groupby('segment').agg({'numbers': set}).to_dict()['numbers']

        plt.plot(self.sync_signal_resampled);
        plt.plot(peaks, self.sync_signal_resampled[peaks], "x")

        self.trigger_recording = []
        self.trigger_unmute = []
        self.trigger_obstacle = []

        for key, items in self.trigger.items():
            if len(items) == 2:
                self.trigger_obstacle.append(items)
            elif len(items) == 4:
                self.trigger_unmute.append(items)
            elif len(items) == 6:
                self.trigger_recording.append(items)
            else:
                pass

    def get_marker(self, marker_name: str):

        # Get the needed marker
        marker_position = self.marker['DATA']['POS'][marker_name]

        return marker_position

    def plot_output_time(self):

        import matplotlib.pyplot as plt

        plt.plot(np.mean(self.output_intensity, axis=(1, 2)))
        plt.xlabel('Frame_number')
        plt.ylabel('Average_intensity')

        # Set assistant line for start of trial
        plt.axvline(x=list(self.trigger_unmute[0])[0], color='gray', linestyle='--')

    def plot_marker_position(self, marker_name: str):

        import matplotlib.pyplot as plt

        plt.plot(self.marker['DATA']['POS'][marker_name][:, 0], self.marker['DATA']['POS'][marker_name][:, 1])
        plt.ylim([-3000, 3000]);
        plt.xlim([-3000, 3000])

    def plot_caneamp_time(self):

        """ Plot cane amplitude over time period """

    def plot_hesitation_time(self):

        """ Plot highlighted hesitation periods over time period """

        hesitations, segments = self.hesitations(self.get_marker('COFMAbsoluteVel')[:, 2])
        plt.plot(self.get_marker('COFMAbsoluteVel')[:, 2])

        for i in range(0, len(segments)):
            x = segments[i]
            y = self.get_marker('COFMAbsoluteVel')[segments[i], 2]
            plt.plot(x, y, color='r')

    def plot_margins_stability(self, frame_num):

        """ Plot and supporting foot and extroploted com and Mos """

        from scipy.constants import g
        import math
        gravity_constant = g

        #         # Determine the leading foot
        #         # Decide which one is the support foot or at standing phase
        #         left_heel = self.get_marker('LCAL')
        #         right_heel = self.get_marker('RCAL')
        #         height_difference = right_heel[frame_num,2] - left_heel[frame_num,2]

        #         # Draw the support foot and the COM
        #         if height_difference < -5:
        #             position = 'R'
        #         elif height_difference > 5:
        #             position = 'L'
        #         else:
        #             position = 'R'

        #         com  = self.get_marker('COFM')
        #         vcom = self.get_marker('COFMLVel')
        #         heel = self.get_marker(position + 'CAL')
        #         lmal = self.get_marker(position + 'LMAL')
        #         mmal = self.get_marker(position + 'MMAL')
        #         mt5  = self.get_marker(position + 'MT5')
        #         mt23 = self.get_marker(position + 'MT23')
        #         mt1  = self.get_marker(position + 'MT1')

        #         plt.scatter(heel[frame_num,0],heel[frame_num,1])
        #         plt.scatter(lmal[frame_num,0],lmal[frame_num,1])
        #         plt.scatter(mmal[frame_num,0],mmal[frame_num,1])
        #         plt.scatter(mt5[frame_num,0],mt5[frame_num,1])
        #         plt.scatter(mt23[frame_num,0],mt23[frame_num,1])
        #         plt.scatter(mt1[frame_num,0],mt1[frame_num,1])

        #         plt.scatter(com[frame_num,0],com[frame_num,1], marker='*', s=100)

        #         com_x = com[frame_num,0]/1000
        #         com_y = com[frame_num,1]/1000
        #         com_vx = vcom[frame_num,0]
        #         com_vy = vcom[frame_num,1]
        #         L = com[frame_num,2]/1000
        #         xcom_x = com_x + com_vx*math.sqrt(L/gravity_constant)
        #         xcom_y = com_y + com_vy*math.sqrt(L/gravity_constant)
        #         xcom_x = xcom_x*1000
        #         xcom_y = xcom_y*1000

        #         plt.scatter(xcom_x,xcom_y, marker='*', s=100)

        #         draw_pointer_line([com[frame_num,0],com[frame_num,1]],[xcom_x,xcom_y])
        #         draw_pointer_line([heel[frame_num,0],heel[frame_num,1]],[xcom_x,xcom_y])

        # Computer mos
        com = self.get_marker('COFM')
        vcom = self.get_marker('COFMLVel')
        left_heel = self.get_marker('LCAL')
        right_heel = self.get_marker('RCAL')

        mos = [compute_margin_stability(x, y, z, m) for x, y, z, m in zip(com, vcom, left_heel, right_heel)]
        plt.plot(mos)

    # Define functions to calculate these variables

    def response_time(self):

        """ Output: Response time in second"""
        # Time from the start of trial to when participant pressed the button
        try:

            self.event_labels = self.dict_group['EVENT']['LABELS']
            self.event_times = self.dict_group['EVENT']['TIMES']

            #         self.trial_start_time = self.event_times[np.where(self.event_labels == 'start')][0][0]*60 + self.event_times[np.where(self.event_labels == 'start')][0][1]
            self.trial_response_time = self.event_times[np.where(self.event_labels == 'found')][0][0] * 60 + \
                                       self.event_times[np.where(self.event_labels == 'found')][0][1]
            self.trial_start_time = self.dict_group['TRIAL']['ACTUAL_START_FIELD'][0] / self.rate

            response_time = self.trial_response_time - self.trial_start_time

        except:
            response_time = 0

        return response_time

    def contact_time(self):

        """ Output: Contact time in second, trial finish time"""
        # Time from the start of trial to when participant contact the target (using their finger)
        #         self.trial_start_time = self.event_times[np.where(self.event_labels == 'start')][0][0]*60 + self.event_times[np.where(self.event_labels == 'start')][0][1]
        #         self.trial_touch_time =  self.event_times[np.where(self.event_labels == 'touch')][0][0]*60 + self.event_times[np.where(self.event_labels == 'touch')][0][1]

        #         results = self.trial_touch_time - self.trial_start_time

        self.total_frames = self.dict_group['POINT']['FRAMES']
        self.rate = self.dict_group['POINT']['RATE']
        contact_time = self.total_frames / self.rate

        return contact_time

    def velocity(self, vel_data):

        """ Output: Max attained valocity in mm/s"""
        # TODO: ADD average velocity
        # Max attained speed and average speed in trial  plot bird eye view
        # Import marker comlvel/acc overall (i.e  mnot y axis only)
        # vel_data = self.get_marker(marker_name)
        vel_data = vel_data[:, 2]

        sos = signal.butter(50, 35, 'lp', fs=1000, output='sos')
        vel_data_buttered = signal.sosfiltfilt(sos, vel_data)

        return vel_data_buttered, max(vel_data_buttered)

    def gait_parameters(self):

        # Step length / Step width over time
        # Define the gait event store the frame number

        self.toe_off_events = np.where(self.event_labels == 'Foot Off')[0]
        self.heel_strike_events = np.where(self.event_labels == 'Foot Strike')[0]

        return results

    def cane_parameters(self):

        """ Output: Left extreme width; in deg
                    Right extreme width in deg
                    Average swing velocity in deg/s"""

        # The cane postional data (relative to shoulder segment)
        self.cane = self.get_marker('CANEc')[:, :]

        # The cane degree data (relative to shoulder segment)
        self.cane_deg = self.get_marker('CANEAngle')[:, 1]

        # The cane velocity data (relative to shoulder segment)
        self.cane_vel = self.get_marker('CANEsegAngVelDeg')[:, 1]

        """TODO: Change it to common value 5Hz for smooth velocity data"""
        sos = signal.butter(50, 5, 'lp', fs=1000, output='sos')
        self.cane_vel = signal.sosfiltfilt(sos, self.cane_vel)

        return max(self.cane_deg), min(self.cane_deg), np.average(abs(self.cane_vel))

    def found_distance(self):

        """ Output: Distance in m """

        # Output target obstacles
        self.target_1 = self.get_marker('CYL1')
        self.target_2 = self.get_marker('CYL2')
        self.target_3 = self.get_marker('CYL3')
        self.cylinder = self.get_marker('CYLcenter')

        try:

            self.event_labels = self.dict_group['EVENT']['LABELS']
            self.event_times = self.dict_group['EVENT']['TIMES']

            for time in self.event_times:
                #         self.trial_start_time = self.event_times[np.where(self.event_labels == 'start')][0][0]*60 + self.event_times[np.where(self.event_labels == 'start')][0][1]
                self.trial_response_time = time[0] * 60 + time[
                    1]  # self.event_times[np.where(self.event_labels == 'found')][0][0]*60 + self.event_times[np.where(self.event_labels == 'found')][0][1]
                self.trial_start_time = self.dict_group['TRIAL']['ACTUAL_START_FIELD'][0] / self.rate

                self.response_time = self.trial_response_time - self.trial_start_time
                self.deviating_frames = int(self.response_time * self.rate)

                results = compute_distance(self.cylinder[self.deviating_frames, :], self.com[self.deviating_frames, :])

                results_all = results / 1000

        except:

            self.response_time = 0
            results_all = 0

        return results_all

    def deviation(self):

        """ Output: distance in mm """

        # Output target obstacles
        self.target_1 = self.get_marker('CYL1')
        self.target_2 = self.get_marker('CYL2')
        self.target_3 = self.get_marker('CYL3')
        self.cylinder = self.get_marker('CYLcenter')

        # The start and end point
        self.end_point = self.get_marker('CYLcenter')[1][0:2]
        self.start_point = self.get_marker('COFM')[1][0:2]
        self.deviation_all = [point_line_distance(item, self.start_point, self.end_point) for item in self.com]

        return self.deviation_all

    def hesitations(self, marker_velocity):

        """ Output: Number of hesitation period defined """
        # For a fixed number of frames, participants’ movements are  limited to an area, or the sum of speed fluctuations

        # Define the hesitation event use COM valocity when vel less than (e.g., 0.1) and more than
        threshold = 0.1
        length_threshold = 100  # In frame number
        signal = marker_velocity

        # Find the indices of data below the threshold
        indices_below_threshold = np.where(signal < threshold)[0]

        if len(indices_below_threshold) != 0:

            # Split the indices into segments based on their difference
            split_indices = np.split(indices_below_threshold, np.where(np.diff(indices_below_threshold) != 1)[0] + 1)

            # Find the segments that are above the length threshold
            segments_above_length_threshold = [segment for segment in split_indices if len(segment) >= length_threshold]

            # Find the start and end indices of each continuous segment of data above the threshold
            hesitations = [(segment[0], segment[-1]) for segment in segments_above_length_threshold]

        else:
            hesitations = []  # If there is no heistation event defined

        return hesitations, segments_above_length_threshold

    def margins_stability_all(self):

        com = self.get_marker('COFM')
        vcom = self.get_marker('COFMLVel')
        left_heel = self.get_marker('LCAL')
        right_heel = self.get_marker('RCAL')

        return [compute_margin_stability(x, y, z, m) for x, y, z, m in zip(com, vcom, left_heel, right_heel)]

    def margins_stability(self, frame_num):

        """ Output: Margins of stability The Mos is calculated as the difference between the extrapolated center of mass
        and the heel of the leading foot, we calculated the Mos at each contact position"""

        from scipy.constants import g
        import math
        gravity_constant = g

        # Determine the leading foot
        # Decide which one is the support foot or at standing phase
        left_heel = self.get_marker('LCAL')
        right_heel = self.get_marker('RCAL')
        height_difference = right_heel[frame_num, 2] - left_heel[frame_num, 2]

        if height_difference < -5:
            position = 'R'
        elif height_difference > 5:
            position = 'L'
        else:
            position = 'R'

        com = self.get_marker('COFM')
        vcom = self.get_marker('COFMLVel')
        heel = self.get_marker(position + 'CAL')
        lmal = self.get_marker(position + 'LMAL')
        mmal = self.get_marker(position + 'MMAL')
        mt5 = self.get_marker(position + 'MT5')
        mt23 = self.get_marker(position + 'MT23')
        mt1 = self.get_marker(position + 'MT1')

        com_x = com[frame_num, 0] / 1000
        com_y = com[frame_num, 1] / 1000
        com_vx = vcom[frame_num, 0]
        com_vy = vcom[frame_num, 1]
        L = com[frame_num, 2] / 1000
        xcom_x = com_x + com_vx * math.sqrt(L / gravity_constant)
        xcom_y = com_y + com_vy * math.sqrt(L / gravity_constant)
        xcom_x = xcom_x * 1000
        xcom_y = xcom_y * 1000

        Mos = compute_distance_2d([heel[frame_num, 0], heel[frame_num, 1]], [xcom_x, xcom_y])

        return Mos

    def travel_distance(self, marker_data):

        """ Output: Travel distance in m """
        # Distance that participants travel from the starting point to the target
        # Computer the trajectory distance (differ consective points) in the trigger_start and touch_event

        distance = 0.0
        trajectory = marker_data
        for i in range(1, len(trajectory)):
            distance += compute_distance(trajectory[i - 1], trajectory[i])

        return distance / 1000  # Convert unit to m


class LowVisionSubjectAvoid():

    def __init__(self, config_filepath: str, marker_filepath: str, recording_filepath: str):

        self.config_filepath = config_filepath
        self.marker_filepath = marker_filepath
        self.recording_filepath = recording_filepath

        # Initialise config variable
        self.config = None

        # Initialise marker varible
        self.marker = None
        self.sync_signal = None
        self.dict_group = None
        self.marker_header = None
        self.segment_com = None
        self.com = None
        self.cane = None
        self.trigger = None

        # Initial output variable
        self.output_intensity = []

        # Initial fixed value
        self.startpoint = None  # Should be a fixed number of positional x,y

    def load_config(self, config_filepath):
        # Load meta file for each trial recording data
        self.config = load_config_from_file(config_filepath)

    def load_marker(self, marker_filepath):
        # Load marker set positional data from c3d file segment com and com

        itf = c3d.c3dserver()
        c3d_data = c3d.open_c3d(itf, marker_filepath)

        # For the information of all markers(points)
        self.marker = c3d.get_dict_markers(itf)
        self.sync_signal = c3d.get_dict_analogs(itf)
        self.dict_group = c3d.get_dict_groups(itf)
        self.marker_header = c3d.get_dict_header(itf)
        #         self.event_labels = self.dict_group['EVENT']['LABELS']
        #         self.event_times = self.dict_group['EVENT']['TIMES']
        self.rate = self.dict_group['POINT']['RATE']

        # Output center of mass variables
        self.com = self.get_marker('COFM')
        self.com_absvel = self.get_marker('COFMAbsoluteVel')[:, 2]
        self.com_lvel = self.get_marker('COFMLVel')

        # Output mobility cane parameters
        self.cane = self.get_marker('CANEc')
        self.cane_angel = self.get_marker('CANEAngle')
        self.cane_angelvel = self.get_marker('CANEsegAngVelDeg')

        # Output target obstacles
        self.target_1 = self.get_marker('CYL1')
        self.target_2 = self.get_marker('CYL2')
        self.target_3 = self.get_marker('CYL3')

        self.cylinder = self.get_marker('CYLcenter')
        self.small_square = self.get_marker('SMALLcenter')
        self.larger_square = self.get_marker('LARGEcenter')

        # Set the start and end frame number
        #         self.trial_start_frame = int(self.event_times[np.where(self.event_labels == 'start')][0][0]*60 + self.event_times[np.where(self.event_labels == 'start')][0][1]*self.rate)
        #         self.trial_end_frame =  int(self.event_times[np.where(self.event_labels == 'end')][0][0]*60 + self.event_times[np.where(self.event_labels == 'end')][0][1]*self.rate)
        #         self.trial_found_frame = int(self.event_times[np.where(self.event_labels == 'found')][0][0]*60 + self.event_times[np.where(self.event_labels == 'found')][0][1]*self.rate)

        self.trial_start_frame = 0
        self.trial_end_frame = self.dict_group['POINT']['FRAMES']

    def load_recording_bag(self, recording_filepath):

        self.config['pipeline']['input_stream']['name'] = self.recording_filepath
        # Initialise input stream and vision process module chain
        input_stream = initialise_input_stream(self.config['pipeline']['input_stream'])
        module_chain = initialise_modules(self.config['pipeline']['module_chain'])

        # text config
        font = cv2.FONT_HERSHEY_SIMPLEX
        font_scale = 2
        thickness = 2
        color = (0, 0, 255)  # white
        frame_num = 0
        output_string = ""

        for key, value in self.config['pipeline'].items():
            output_string += f"{key}: {value}\n"

        lines = textwrap.wrap(str(self.config['pipeline']['module_chain']), width=50)

        # Initial frame list to store frames

        frame_number = 0

        # Loop through the frames in the bag file
        while True:

            try:

                frame = input_stream.read()

                frame = imutils.resize(frame, width=800)

                for module in module_chain:
                    frame = module.process(frame)

                frame = frame.astype(np.uint8)

                output = cv2.resize(frame[:, 0:800, 1],
                                    (self.config['pipeline']['module_chain'][0]['kwargs']['kernel_size'],
                                     self.config['pipeline']['module_chain'][0]['kwargs']['kernel_size']))

                #         output = average_without_zero(output.flatten())

                self.output_intensity.append(output)

                frame = cv2.resize(frame, (1500, 450))

                frame_number += 1

                cv2.putText(frame, str(frame_number), (30, 400), font, font_scale, color, thickness)

                y = 10
                for line in lines:
                    cv2.putText(frame, line, (30, y), font, 0.4, color, 1)
                    y += 13

                cv2.imshow('Image', frame)

                if cv2.waitKey(1) & 0xFF == ord('q'):
                    break

            except RuntimeError:

                break

        # Clean up
        input_stream.stop()
        cv2.destroyAllWindows()

    def set_sampling_rate(self):

        from scipy import signal

        self.sync_signal_resampled = signal.resample(self.sync_signal['DATA']['Voltage.Sync'],
                                                     self.dict_group['TRIAL']['ACTUAL_END_FIELD'][0])

    def set_trigger(self):

        peaks, _ = find_peaks(self.sync_signal_resampled, height=0.5, distance=8)

        threshold = 500
        numbers = peaks
        nnumbers = np.array(numbers)
        self.trigger = pd.DataFrame({
            'numbers': numbers,
            'segment': np.cumsum([0] + list(1 * (nnumbers[1:] - nnumbers[0:-1] > threshold))) + 1
        }).groupby('segment').agg({'numbers': set}).to_dict()['numbers']

        plt.plot(self.sync_signal_resampled);
        plt.plot(peaks, self.sync_signal_resampled[peaks], "x")

        self.trigger_recording = []
        self.trigger_unmute = []
        self.trigger_obstacle = []

        for key, items in self.trigger.items():
            if len(items) == 2:
                self.trigger_obstacle.append(items)
            elif len(items) == 4:
                self.trigger_unmute.append(items)
            elif len(items) == 6:
                self.trigger_recording.append(items)
            else:
                pass

    def get_marker(self, marker_name: str):

        # Get the needed marker
        marker_position = self.marker['DATA']['POS'][marker_name]

        return marker_position

    def plot_output_time(self):

        import matplotlib.pyplot as plt

        plt.plot(np.mean(self.output_intensity, axis=(1, 2)))
        plt.xlabel('Frame_number')
        plt.ylabel('Average_intensity')

        # Set assistant line for start of trial
        plt.axvline(x=list(self.trigger_unmute[0])[0], color='gray', linestyle='--')

    def plot_marker_position(self, marker_name: str):

        import matplotlib.pyplot as plt

        plt.plot(self.marker['DATA']['POS'][marker_name][:, 0], self.marker['DATA']['POS'][marker_name][:, 1])
        plt.ylim([-3000, 3000]);
        plt.xlim([-3000, 3000])

    def plot_caneamp_time(self):

        """ Plot cane amplitude over time period """

    def plot_hesitation_time(self):

        """ Plot highlighted hesitation periods over time period """

        hesitations, segments = self.hesitations(self.get_marker('COFMAbsoluteVel')[:, 2])
        plt.plot(self.get_marker('COFMAbsoluteVel')[:, 2])

        for i in range(0, len(segments)):
            x = segments[i]
            y = self.get_marker('COFMAbsoluteVel')[segments[i], 2]
            plt.plot(x, y, color='r')

    def plot_margins_stability(self, frame_num):

        """ Plot and supporting foot and extroploted com and Mos """

        from scipy.constants import g
        import math
        gravity_constant = g

        #         # Determine the leading foot
        #         # Decide which one is the support foot or at standing phase
        #         left_heel = self.get_marker('LCAL')
        #         right_heel = self.get_marker('RCAL')
        #         height_difference = right_heel[frame_num,2] - left_heel[frame_num,2]

        #         # Draw the support foot and the COM
        #         if height_difference < -5:
        #             position = 'R'
        #         elif height_difference > 5:
        #             position = 'L'
        #         else:
        #             position = 'R'

        #         com  = self.get_marker('COFM')
        #         vcom = self.get_marker('COFMLVel')
        #         heel = self.get_marker(position + 'CAL')
        #         lmal = self.get_marker(position + 'LMAL')
        #         mmal = self.get_marker(position + 'MMAL')
        #         mt5  = self.get_marker(position + 'MT5')
        #         mt23 = self.get_marker(position + 'MT23')
        #         mt1  = self.get_marker(position + 'MT1')

        #         plt.scatter(heel[frame_num,0],heel[frame_num,1])
        #         plt.scatter(lmal[frame_num,0],lmal[frame_num,1])
        #         plt.scatter(mmal[frame_num,0],mmal[frame_num,1])
        #         plt.scatter(mt5[frame_num,0],mt5[frame_num,1])
        #         plt.scatter(mt23[frame_num,0],mt23[frame_num,1])
        #         plt.scatter(mt1[frame_num,0],mt1[frame_num,1])

        #         plt.scatter(com[frame_num,0],com[frame_num,1], marker='*', s=100)

        #         com_x = com[frame_num,0]/1000
        #         com_y = com[frame_num,1]/1000
        #         com_vx = vcom[frame_num,0]
        #         com_vy = vcom[frame_num,1]
        #         L = com[frame_num,2]/1000
        #         xcom_x = com_x + com_vx*math.sqrt(L/gravity_constant)
        #         xcom_y = com_y + com_vy*math.sqrt(L/gravity_constant)
        #         xcom_x = xcom_x*1000
        #         xcom_y = xcom_y*1000

        #         plt.scatter(xcom_x,xcom_y, marker='*', s=100)

        #         draw_pointer_line([com[frame_num,0],com[frame_num,1]],[xcom_x,xcom_y])
        #         draw_pointer_line([heel[frame_num,0],heel[frame_num,1]],[xcom_x,xcom_y])

        # Computer mos
        com = self.get_marker('COFM')
        vcom = self.get_marker('COFMLVel')
        left_heel = self.get_marker('LCAL')
        right_heel = self.get_marker('RCAL')

        mos = [compute_margin_stability(x, y, z, m) for x, y, z, m in zip(com, vcom, left_heel, right_heel)]
        plt.plot(mos)

    # Define functions to calculate these variables

    def passing_time(self):

        """ Output: Passing time in second"""
        # Time from the start of trial to when participant contact the target (using their finger)
        #         self.trial_start_time = self.event_times[np.where(self.event_labels == 'start')][0][0]*60 + self.event_times[np.where(self.event_labels == 'start')][0][1]
        #         self.trial_end_time =  self.event_times[np.where(self.event_labels == 'end')][0][0]*60 + self.event_times[np.where(self.event_labels == 'end')][0][1]

        #         results = self.trial_end_time - self.trial_start_time

        self.total_frames = self.dict_group['POINT']['FRAMES']
        self.rate = self.dict_group['POINT']['RATE']
        passing_time = self.total_frames / self.rate

        return passing_time

    def velocity(self, vel_data):

        """ Output: Max attained valocity in mm/s"""
        """ Chaneg the velocity to PPWS relative speed"""
        """ Fluctuation in the speed and hesitation number """
        # Max attained speed and average speed in trial  plot bird eye view
        # Import marker comlvel/acc overall (i.e  mnot y axis only)
        # vel_data = self.get_marker(marker_name)
        vel_data = vel_data[:, 2]

        sos = signal.butter(50, 35, 'lp', fs=1000, output='sos')
        vel_data_buttered = signal.sosfiltfilt(sos, vel_data)

        return vel_data_buttered, max(vel_data_buttered)

    def gait_parameters(self):

        # Step length / Step width over time
        # Define the gait event store the frame number

        self.toe_off_events = np.where(self.event_labels == 'Foot Off')[0]
        self.heel_strike_events = np.where(self.event_labels == 'Foot Strike')[0]

        return results

    def cane_parameters(self):
        # Swing angle (degs) /angular velocity (degs/s) (relative   to holding hand/shoulder) over time

        # Defined in body builder cane velocity

        # Define the near side (shoulder joint) and fat side (mobility cane tip) of the cane and computer

        """ Output: Left extreme width; in rad
                    Right extreme width in rad
                    Average swing velocity in rad/s"""

        """ Need a new parameter to tell how wide they scaning """

        # The cane postional data (relative to shoulder segment)
        self.cane = self.get_marker('CANEc')[:, :]

        # The cane degree data (relative to shoulder segment)
        self.cane_deg = self.get_marker('CANEAngle')[:, 1]

        # The cane velocity data (relative to shoulder segment)
        self.cane_vel = self.get_marker('CANEsegAngVelDeg')[:, 1]
        sos = signal.butter(50, 35, 'lp', fs=1000, output='sos')
        self.cane_vel = signal.sosfiltfilt(sos, self.cane_vel)

        return max(self.cane_deg), min(self.cane_deg), np.average(abs(self.cane_vel))

    def hesitations(self, marker_velocity):

        """ Output: Number of hesitation period defined """
        """ Slightly change to the hesitation number change the number to the time of hesitation period 
        and remove the first and the last period (starting and ending) stage"""
        # For a fixed number of frames, participants’ movements are  limited to an area, or the sum of speed fluctuations

        # Define the hesitation event use COM valocity when vel less than (e.g., 0.1) and more than
        threshold = 0.1
        length_threshold = 100  # In frame number
        signal = marker_velocity

        # Find the indices of data below the threshold
        indices_below_threshold = np.where(signal < threshold)[0]

        if len(indices_below_threshold) != 0:

            # Split the indices into segments based on their difference
            split_indices = np.split(indices_below_threshold, np.where(np.diff(indices_below_threshold) != 1)[0] + 1)

            # Find the segments that are above the length threshold
            segments_above_length_threshold = [segment for segment in split_indices if len(segment) >= length_threshold]

            # Find the start and end indices of each continuous segment of data above the threshold
            hesitations = [(segment[0], segment[-1]) for segment in segments_above_length_threshold]

        else:
            hesitations = []  # If there is no heistation event defined

        return hesitations, segments_above_length_threshold

    def margins_stability_all(self):

        com = self.get_marker('COFM')
        vcom = self.get_marker('COFMLVel')
        left_heel = self.get_marker('LCAL')
        right_heel = self.get_marker('RCAL')

        return [compute_margin_stability(x, y, z, m) for x, y, z, m in zip(com, vcom, left_heel, right_heel)]

    def margins_stability(self, frame_num):

        """ Output: Margins of stability The Mos is calculated as the difference between the extrapolated center of mass
        and the heel of the leading foot, we calculated the Mos at each contact position"""

        """Slightly change the definition to define their movment when both feet on the ground , use the middle point 
        between both feet in the middle"""

        from scipy.constants import g
        import math
        gravity_constant = g

        # Determine the leading foot
        # Decide which one is the support foot or at standing phase
        left_heel = self.get_marker('LCAL')
        right_heel = self.get_marker('RCAL')
        height_difference = right_heel[frame_num, 2] - left_heel[frame_num, 2]

        if height_difference < -5:
            position = 'R'
        elif height_difference > 5:
            position = 'L'
        else:
            position = 'R'

        com = self.get_marker('COFM')
        vcom = self.get_marker('COFMLVel')
        heel = self.get_marker(position + 'CAL')
        lmal = self.get_marker(position + 'LMAL')
        mmal = self.get_marker(position + 'MMAL')
        mt5 = self.get_marker(position + 'MT5')
        mt23 = self.get_marker(position + 'MT23')
        mt1 = self.get_marker(position + 'MT1')

        com_x = com[frame_num, 0] / 1000
        com_y = com[frame_num, 1] / 1000
        com_vx = vcom[frame_num, 0]
        com_vy = vcom[frame_num, 1]
        L = com[frame_num, 2] / 1000
        xcom_x = com_x + com_vx * math.sqrt(L / gravity_constant)
        xcom_y = com_y + com_vy * math.sqrt(L / gravity_constant)
        xcom_x = xcom_x * 1000
        xcom_y = xcom_y * 1000

        Mos = compute_distance_2d([heel[frame_num, 0], heel[frame_num, 1]], [xcom_x, xcom_y])

        return Mos

    def travel_distance(self, marker_data):

        """ Output: Travel distance in m """
        # Distance that participants travel from the starting point to the target
        # Computer the trajectory distance (differ consective points) in the trigger_start and touch_event

        distance = 0.0
        trajectory = marker_data
        for i in range(1, len(trajectory)):
            distance += compute_distance(trajectory[i - 1], trajectory[i])

        return distance / 1000

    def deviating_distance(self):
        # When participants detect an obstacle, the distance between participants and the obstacle when they start making deviation to avoid the obstacle.
        # Distance between COM and the center point of the obstacle

        """ Output: Distance in m """

        try:

            results_all = []

            self.event_labels = self.dict_group['EVENT']['LABELS']
            self.event_times = self.dict_group['EVENT']['TIMES']

            for time in self.event_times:
                #         self.trial_start_time = self.event_times[np.where(self.event_labels == 'start')][0][0]*60 + self.event_times[np.where(self.event_labels == 'start')][0][1]
                self.trial_response_time = time[0] * 60 + time[
                    1]  # self.event_times[np.where(self.event_labels == 'found')][0][0]*60 + self.event_times[np.where(self.event_labels == 'found')][0][1]
                self.trial_start_time = self.dict_group['TRIAL']['ACTUAL_START_FIELD'][0] / self.rate

                self.response_time = self.trial_response_time - self.trial_start_time
                self.deviating_frames = int(self.response_time * self.rate)

                self.com[self.deviating_frames, 0]
                dist_list = [self.cylinder[self.deviating_frames, 0] - self.com[self.deviating_frames, 0], \
                             self.larger_square[self.deviating_frames, 0] - self.com[self.deviating_frames, 0], \
                             self.small_square[self.deviating_frames, 0] - self.com[self.deviating_frames, 0]]

                smallest_index = find_smallest_positive_index(dist_list)

                if smallest_index == 1:
                    results = compute_distance(self.larger_square[self.deviating_frames, :],
                                               self.com[self.deviating_frames, :])
                elif smallest_index == 2:
                    results = compute_distance(self.small_square[self.deviating_frames, :],
                                               self.com[self.deviating_frames, :])
                elif smallest_index == 0:
                    results = compute_distance(self.cylinder[self.deviating_frames, :],
                                               self.com[self.deviating_frames, :])

                results_all.append(results / 1000)

        except:

            self.response_time = 0
            results_all = 0

        return results_all

    def clearing_distance(self):
        # When participants avoid an obstacle, the minimum distance between participants and the obstacle while they are passing the obstacle.
        # Distance between COM and the center point of the obstacle

        """ Output: Distance in m """

        try:

            results_all = []

            self.event_labels = self.dict_group['EVENT']['LABELS']
            self.event_times = self.dict_group['EVENT']['TIMES']

            for time in self.event_times:
                #         self.trial_start_time = self.event_times[np.where(self.event_labels == 'start')][0][0]*60 + self.event_times[np.where(self.event_labels == 'start')][0][1]
                self.trial_response_time = time[0] * 60 + time[
                    1]  # self.event_times[np.where(self.event_labels == 'found')][0][0]*60 + self.event_times[np.where(self.event_labels == 'found')][0][1]
                self.trial_start_time = self.dict_group['TRIAL']['ACTUAL_START_FIELD'][0] / self.rate

                self.response_time = self.trial_response_time - self.trial_start_time

                self.deviating_frames = int(self.response_time * self.rate)
                self.com[self.deviating_frames, 0]
                dist_list = [self.cylinder[self.deviating_frames, 0] - self.com[self.deviating_frames, 0], \
                             self.larger_square[self.deviating_frames, 0] - self.com[self.deviating_frames, 0], \
                             self.small_square[self.deviating_frames, 0] - self.com[self.deviating_frames, 0]]

                smallest_index = find_smallest_positive_index(dist_list)

                if smallest_index == 1:
                    ver_dist = self.larger_square[:, 0] - self.com[:, 0]
                    ver_dist_index = np.where(ver_dist > 0)
                    self.clearing_frames = max(ver_dist_index[0])
                    results = compute_distance(self.larger_square[self.clearing_frames, :],
                                               self.com[self.clearing_frames, :])
                elif smallest_index == 2:
                    ver_dist = self.small_square[:, 0] - self.com[:, 0]
                    ver_dist_index = np.where(ver_dist > 0)
                    self.clearing_frames = max(ver_dist_index[0])
                    results = compute_distance(self.small_square[self.clearing_frames, :],
                                               self.com[self.clearing_frames, :])
                elif smallest_index == 0:
                    ver_dist = self.cylinder[:, 0] - self.com[:, 0]
                    ver_dist_index = np.where(ver_dist > 0)
                    self.clearing_frames = max(ver_dist_index[0])
                    results = compute_distance(self.cylinder[self.clearing_frames, :],
                                               self.com[self.clearing_frames, :])

                results_all.append(results / 1000)

        except:

            self.event_times = 0
            self.response_time = 0
            results_all = 0

        return results_all


def compute_margin_stability(com, vcom, left_heel, right_heel):
    from scipy.constants import g
    import math
    gravity_constant = g

    height_difference = right_heel[2] - left_heel[2]

    if height_difference < -5:
        heel = right_heel
    elif height_difference > 5:
        heel = left_heel
    else:
        heel = (right_heel + left_heel) / 2

    com_x = com[0] / 1000
    com_y = com[1] / 1000
    com_vx = vcom[0]
    com_vy = vcom[1]
    L = com[2] / 1000
    xcom_x = com_x + com_vx * math.sqrt(L / gravity_constant)
    xcom_y = com_y + com_vy * math.sqrt(L / gravity_constant)
    xcom_x = xcom_x * 1000
    xcom_y = xcom_y * 1000

    Mos = compute_distance_2d([heel[0], heel[1]], [xcom_x, xcom_y])

    return Mos

def find_smallest_positive_index(numbers):
    positive_numbers = [num for num in numbers if num > 0]
    if positive_numbers:
        smallest_positive = min(positive_numbers)
        smallest_positive_index = numbers.index(smallest_positive)
        return smallest_positive_index
    else:
        return None


def compute_distance(point1, point2):
    import math
    """Compute the Euclidean distance between two 3D points."""
    return math.sqrt((point1[0] - point2[0]) ** 2 + (point1[1] - point2[1]) ** 2 + (point1[2] - point2[2]) ** 2)


def compute_distance_2d(point1, point2):
    import math
    """Compute the Euclidean distance between two 2D points."""
    return math.sqrt((point1[0] - point2[0]) ** 2 + (point1[1] - point2[1]) ** 2)


def draw_pointer_line(start_point, end_point):
    x_values = [start_point[0], end_point[0]]
    y_values = [start_point[1], end_point[1]]

    plt.plot(x_values, y_values, 'b-')  # 'b-' represents a blue line

    # Draw a marker at the start point
    # plt.plot(start_point[0], start_point[1], 'bo')  # 'bo' represents a blue circle marker

    # Draw an arrow at the end point
    dx = end_point[0] - start_point[0]
    dy = end_point[1] - start_point[1]
    plt.arrow(start_point[0], start_point[1], dx, dy, color='b', head_width=0.15, head_length=0.15)


def point_line_distance(point, line_start, line_end):
    x1, y1 = line_start
    x2, y2 = line_end
    x0, y0 = point[0:2]

    numerator = abs((y2 - y1) * x0 - (x2 - x1) * y0 + x2 * y1 - y2 * x1)
    denominator = math.sqrt((y2 - y1) ** 2 + (x2 - x1) ** 2)

    distance = numerator / denominator
    return distance


