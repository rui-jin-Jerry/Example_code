# Configuration

## Input streams

Otchkies allows the following input types:
* `webcam`
* `realsense`
* `/path/to/video_file.bag`

```yaml
pipeline:
  input_stream:
    name: webcam
    archival_dir: /path/to/dir/ 
```

## Module chain 

The module chain is designed for modules to be specified in the `.yml` config file.
This means that the end user (VP researcher) can include their VP modules in a 
'plugin' fashion without needing to touch the `Otchkies` codebase at all. They 
would simply provide the path to their config file when they start the application up,
and in the config file they would set the location of their implementations. E.g.:

```yaml
pipeline:
  module_chain:
    - name: My Arbitrary Name for logging purposes
      path: /path/to/my/implementation/directory
      implementation: package_dir.module_file.MyVisionProcessingClass
      kwargs:
        color: [0, 255, 0]
        some_arg: 0.1     
```

The user can point to any file that has a class with the appropriate
interface `[__init__(**kwargs), process(frame)]`, and it will be automatically
imported and initialised.

## Output streams

Otchkies supports the following output stream types:

* `web`: Webpage showing the VP output, with "refresh config" button.
* `voice`: Play audio representation using the [vOICe algorithm](https://github.com/RuizSerra/vOICe-python).
* `brainport`: Send representations to BrainPort IOD device via websockets.

```yaml
pipeline:
  output_streams:
    - name: web
    - name: voice
#    - name: brainport
```