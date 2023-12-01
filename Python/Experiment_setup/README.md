# 🥽 otchkies

Modular interface for several input, output, and processing methods for vision processing.

## Requirements

* `conda`

## Quickstart

```bash
# Install dependencies
conda env create -f environment.yml
# NOTE: the pyrealsense2 dependency may need some attention, as it is 
# different for apple silicon (in which otchkies was developed)

# Activate conda environment
conda activate oto

# Run server 
python main.py --config config/default.yml

# Go to <your-ip>:8000 in your browser (or phone's browser, if in the same network) if in browser mode
```

## Documentation

* End users: refer to [docs/configuration.md](./docs/configuration.md) for more 
details about how to configure the pipeline.
* Developers: refer to [docs/architecture.md](./docs/architecture.md) for implementation
details.