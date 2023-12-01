"""
Adapted from: https://pyimagesearch.com/2019/09/02/opencv-stream-video-to-web-browser-html-page/

Author: @RuizSerra
Date:	20220908
"""

import numpy as np
import imutils
import cv2
import gin

from utils.logging import vp_logger

@gin.configurable
class SingleMotionDetector:

	FRAME_SPEC = {'channels': 3}

	def __init__(self, accumWeight=0.5, frameCount=32, color=(0, 0, 255)):
		# store the accumulated weight factor
		self.accumWeight = accumWeight
		self.frameCount = frameCount
		self.color = color
		# initialize the background model
		self.bg = None
		self.total = 0

	def process(self, image):
		gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
		gray = cv2.GaussianBlur(gray, (7, 7), 0)

		# if the total number of frames has reached a sufficient
		# number to construct a reasonable background model, then
		# continue to process the frame
		if self.total > self.frameCount:
			# detect motion in the image
			motion = self._detect(gray)
			# check to see if motion was found in the frame
			if motion is not None:
				# unpack the tuple and draw the box surrounding the
				# "motion area" on the output frame
				(thresh, (minX, minY, maxX, maxY)) = motion
				cv2.rectangle(image, (minX, minY), (maxX, maxY),
							  self.color, 2)

		# if the background model is None, initialize it
		if self.bg is None:
			self.bg = gray.copy().astype("float")
			return image
		# update the background model by accumulating the weighted
		# average
		cv2.accumulateWeighted(gray, self.bg, self.accumWeight)
		self.total += 1

		return image

	def _detect(self, image, tVal=25):
		# compute the absolute difference between the background model
		# and the image passed in, then threshold the delta image
		delta = cv2.absdiff(self.bg.astype("uint8"), image)
		thresh = cv2.threshold(delta, tVal, 255, cv2.THRESH_BINARY)[1]
		# perform a series of erosions and dilations to remove small
		# blobs
		thresh = cv2.erode(thresh, None, iterations=2)
		thresh = cv2.dilate(thresh, None, iterations=2)

		# find contours in the thresholded image and initialize the
		# minimum and maximum bounding box regions for motion
		cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,
								cv2.CHAIN_APPROX_SIMPLE)
		cnts = imutils.grab_contours(cnts)
		(minX, minY) = (np.inf, np.inf)
		(maxX, maxY) = (-np.inf, -np.inf)

		# if no contours were found, return None
		if len(cnts) == 0:
			return None
		# otherwise, loop over the contours
		for c in cnts:
			# compute the bounding box of the contour and use it to
			# update the minimum and maximum bounding box regions
			(x, y, w, h) = cv2.boundingRect(c)
			(minX, minY) = (min(minX, x), min(minY, y))
			(maxX, maxY) = (max(maxX, x + w), max(maxY, y + h))
		# otherwise, return a tuple of the thresholded image along
		# with bounding box
		return (thresh, (minX, minY, maxX, maxY))