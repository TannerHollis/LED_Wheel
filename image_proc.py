import cv2
import os
import math

IMG_HEIGHT = 64
IMG_WIDTH = 64

def open_image(filepath):
    img = cv2.imread(filepath)
    return img

def save_image(img, filename):
    cv2.imwrite(filename, img)

def resize_image(img):
    width = img.shape[1]
    height = img.shape[0]
    if width > height:
        factor = height / IMG_HEIGHT
        size = (int(width / factor), IMG_HEIGHT)
    elif height > width:
        factor = width / IMG_WIDTH
        size = (IMG_WIDTH, int(height / factor))
    elif height == width:
        size = (IMG_WIDTH, IMG_HEIGHT)
    return cv2.resize(img, size, interpolation = cv2.INTER_AREA)

def crop_image(img):
    width = img.shape[1]
    height = img.shape[0]
    center = [int(width / 2), int(height / 2)]
    return img[int(center[1] - IMG_HEIGHT / 2): int(center[1] + IMG_HEIGHT / 2), int(center[0] - IMG_WIDTH / 2): int(center[0] + IMG_WIDTH / 2)]

def add_hidden_data(img, name, frame_current, frame_end, fps, loop):
    name = "{:20s}".format(name).encode('ascii')
    for char in range(20):
        img[0, char, 0] = name[char]
        
    img[1,0,0] = int(splitByte(frame_current)[0])
    img[1,1,0] = int(splitByte(frame_current)[1])

    img[2,0,0] = int(splitByte(frame_end)[0])
    img[2,1,0] = int(splitByte(frame_end)[1])

    img[3,0,0] = int(fps)
    img[4,0,0] = int(loop)
    return img
    
def splitByte(b):
    lowerMask = b'\x0F'
    lowerHalf = bytes([b & lowerMask[0]])[0]
    upperMask = b'\xF0'
    upperHalf = bytes([b & upperMask[0]])[0]
    return [upperHalf,lowerHalf]

def img_to_bin_file(img, filename, append=False):
    if append:
        f_format = 'ab'
    else:
        f_format = 'wb'
    f = open(filename, f_format)
    width = img.shape[1]
    height = img.shape[0]
    for c in range(3):
        for h in range(height):
            for w in range(width):
                f.write(img[h][w][c])
    f.close()

def mp4_to_bin_file(filepath):
    basename = os.path.splitext(os.path.basename(filepath))[0]
    vid = cv2.VideoCapture(filepath)
    n_frames = int(vid.get(cv2.CAP_PROP_FRAME_COUNT))
    fps = int(vid.get(cv2.CAP_PROP_FPS))
    first_frame = True
    print("Writing {} @{}fps".format(basename, fps))
    for frame in range(n_frames):
        success, frame_img = vid.read()
        frame_img = resize_image(frame_img)
        frame_img = crop_image(frame_img)
        frame_img = add_hidden_data(img, basename, frame, n_frames, fps, 0)
        
        img_to_bin_file(img, "{:s}.bin".format(basename), append = not(first_frame))
        if first_frame:
            first_frame = False

def mod_image(img2, scale):
    img = img2.copy()
    width = img.shape[1]
    height = img.shape[0]
    for w in range(width):
        for h in range(height):
            for c in range(3):
                img[h,w,c] = int(img[h,w,c] * scale % 256)
    cv2.imshow("Modulus", img)

def log_image(img2, scale):
    img = img2.copy()
    width = img.shape[1]
    height = img.shape[0]
    a = math.log(257)
    for w in range(width):
        for h in range(height):
            for c in range(3):
                img[h,w,c] = int(img[h,w,c]/a*math.log(img[h,w,c] + 1))
    cv2.imshow("Logarithm", img)

if __name__ == "__main__":
    test_image = "Hidden Data.png"
    img = open_image(test_image)
    img = add_hidden_data(img, "Test Image", 128, 128, 15, 0)
    save_image(img, "Test output.png")
    img_to_bin_file(img, "Test output.bin")
    mp4_to_bin_file("Test MP4.mp4")
    img = open_image("test_image.jpg")
    
