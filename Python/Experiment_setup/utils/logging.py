"""
Handles the logging for all of otchkies

Different loggers for different components (web streaming, etc)

Author: @RuizSerra
Date:   20220909
Modified by @rui_jin_jerry
Data: 20221020
"""

import logging

LOG_LEVEL = logging.DEBUG

# create console handler and set level to debug
ch = logging.StreamHandler()
fh = logging.FileHandler('std.log')
ch.setLevel(logging.DEBUG)
formatter = logging.Formatter(
    '[%(levelname).1s %(asctime)s %(name)s] %(message)s'
    )
ch.setFormatter(formatter)
fh.setFormatter(formatter)

# Create loggers ---------------------------------------------------------------
main_logger = logging.getLogger('Main')
main_logger.setLevel(LOG_LEVEL)
main_logger.addHandler(ch)
main_logger.addHandler(fh)

utils_logger = logging.getLogger('Utils')
utils_logger.setLevel(LOG_LEVEL)
utils_logger.addHandler(ch)
utils_logger.addHandler(fh)

input_logger = logging.getLogger('InputInterface')
input_logger.setLevel(LOG_LEVEL)
input_logger.addHandler(ch)
input_logger.addHandler(fh)

vp_logger = logging.getLogger('VisionProcessing')
vp_logger.setLevel(LOG_LEVEL)
vp_logger.addHandler(ch)
vp_logger.addHandler(fh)

output_logger = logging.getLogger('OutputInterface')
output_logger.setLevel(LOG_LEVEL)
output_logger.addHandler(ch)
output_logger.addHandler(fh)

ws_logger = logging.getLogger('WebStreaming')
ws_logger.setLevel(LOG_LEVEL)
ws_logger.addHandler(ch)
ws_logger.addHandler(fh)

ah_logger = logging.getLogger('ArchivalHandler')
ah_logger.setLevel(LOG_LEVEL)
ah_logger.addHandler(ch)
ah_logger.addHandler(fh)