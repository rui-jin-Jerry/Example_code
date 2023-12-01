# Architecture

## High level overview

The Otchkies application is comprised of the following pillars:

* `main.py`
* `input_streams/`
* `vision_processing/`
* `output_streams/`
* `web_streaming/`
* `utils/`


## `main.py`

The main entry point to the application. In charge of loading and parsing the 
configuration file, instantiating the main pipeline loop, keeping track of 
stats like FPS, and tearing everything down upon application shutdown. The main
pipeline loop runs in a separate thread, operating as a bus to read frames from
the input stream and distribute them to the output streams.

Here we also spin up the `web` output stream server and give it special status 
by setting it as a _control stream_, so that it can trigger the config reload 
procedure.

## `input_streams/`

Two main types of input stream: 

### `RealSense`-based input streams

Input coming from a RealSense camera or `.bag` file will be consumed by these 
streams.

### `imutils`-based input streams

These include webcam and Raspberry Pi inputs.

## `vision_processing/`

Here we place some basic VP modules for convenience:

* `ToBlackAndWhite`
* `Invert`
* `GaussianBlur`
* `SingleMotionDetector`

Note that this is *not intended to be a place for users to add their VP 
module code*---they should instead provide a path to their code in their config 
file (see [docs/configuration.md](./configuration.md#module-chain)).

## `output_streams/`

To include output streams, provide an interface class in `output_streams/interfaces.py`
with `set_current_frame()` and `process_output()` methods.

* vOICe output
* BrainPort output

## `web_streaming/`

Admittedly this could be an interface within `output_streams`, but since it 
comprises `.html` template files and provides UI functionality, it has been
promoted to be a separate architectural element. It runs as a simple `Flask` app.

## `utils/`

Any code that is to be used across multiple elements, such as logging, 
archival handlers, data transformations, etc.

### Archival handler

In charge of writing video data to disk. Sets a file name using a timestamp and
stores in the appropriate format. It will also store a metadata file containing
the pipeline configuration and running stats like elapsed time and approx FPS.

For the moment, it will only store input stream data, as any output can be 
re-created given the input and the pipeline configuration used. Note that when
using `.bag` files, archival is disabled (because we already have a `.bag` file!).

### Logging

Simple logging handlers and formatting using python's `logging` package.
Writes output to the terminal for now. Log level can be set in the file itself 
(hardcoded `LOG_LEVEL` constant).

