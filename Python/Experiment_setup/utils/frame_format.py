import cv2
from utils.logging import utils_logger


def format(module, frame):
    spec = getattr(module, 'FRAME_SPEC', {})

    # Channels
    channels = spec.get('channels')
    if channels and len(frame.shape) == 3 and frame.shape[-1] != channels:
        if channels == 3:
            frame = frame[:, :, :3].astype("uint8")
        if channels == 1:
            frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # Size
    size = spec.get('size')
    if size and frame.shape[:-1] != size:
        frame = image_resize(frame, width=size[1])

    return frame


def image_resize(image, width=None, height=None, square=True, inter=cv2.INTER_AREA):
    """Resize image to match width *or* height

    Args:
        image (array)    Image as loaded by cv2.imread() or otherwise processed
        width (int)
        height (int)
        square (bool)    Whether the output image should be square or not
        inter (cv2.INTER_AREA)  ??

    If square=False, it maintains the original width/height ratio

    If no width or height are give, it uses width = self._image_size

    source: https://stackoverflow.com/a/44659589/5928048
    """
    # initialize the dimensions of the image to be resized and
    # grab the image size
    dim = None

    # crop to square?
    if square:
        # Crop to (IMAGE_SIZE, IMAGE_SIZE)
        image_size = min(image.shape[:2])
        y = image.shape[0] // 2 - image_size // 2
        x = image.shape[1] // 2 - image_size // 2
        image = image[y:y + image_size, x:x + image_size]

    (h, w) = image.shape[:2]

    if not (width or height):
        raise ValueError('Must provide one of width, height.')

    if width is None:
        # calculate the ratio of the height and construct the
        # dimensions
        r = height / float(h)
        dim = (int(w * r), height)

    # otherwise, the height is None
    elif height is None:
        # calculate the ratio of the width and construct the
        # dimensions
        r = width / float(w)
        dim = (width, int(h * r))

    # TODO: what happens if both the width AND the height are provided?
    else:
        pass

    # resize the image
    # print('Resizing image to', dim)
    resized = cv2.resize(image, dim, interpolation=inter)

    # return the resized image
    return resized
