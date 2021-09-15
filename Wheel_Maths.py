import math
from matplotlib import pyplot
import numpy

mem_storage = 8e6 #1Gbits
fps = 15
timer_freq = 100e6 #100MHz
sys_freq = 480e6
proc_margin = 0.50
n_DRIVERS = 4
n_LEDS = n_DRIVERS * 16 #LEDS per driver
r = 32 #cm
a = 1 #theta spacing constant
d_PIXEL = r / (n_LEDS) #cm
d_THETA = math.degrees(math.acos(1 - (a*a)/(2*n_LEDS*n_LEDS)))
frame_len = math.ceil(360 / d_THETA)
image_PIXELS = 2 * n_LEDS
time_per_update = ((n_LEDS + 3) * 8) / 80e6 + (16 * 16) / 25e6 #+3 for instruction and starting address
max_SPEED = (1 - proc_margin) / (frame_len * time_per_update) #proc margin without margin for 3 colors

print("Number of LEDs: {:d}".format(n_LEDS))
print("Update angle: {:.5f} degrees".format(d_THETA))
print("Updates per revolution: {}".format(frame_len))
print("Pixel spacing: {:.5f} cm".format(d_PIXEL))
print("Max speed(@{:2.0f}%Margin)= {:.3f}".format(proc_margin * 100,max_SPEED) + "Hz")
print("Time to update: {:.5f} uS".format(time_per_update * (1 - proc_margin) / 1e-6))
print("Time per update: {:.5f} uS".format(time_per_update / 1e-6))
print("Timer counts per update (@{:0.0f}MHz): {:0.0f}".format(timer_freq/1e6, time_per_update*timer_freq))

theta = 0
frames_x = numpy.zeros([frame_len, n_LEDS])
frames_y = numpy.zeros([frame_len, n_LEDS])
frame_cnt = numpy.zeros(frame_len)
frame_label = []
for update in range(frame_len):
    for LED in range(1, n_LEDS):
        angle_rad = math.radians(theta)
        frames_x[update, LED] = round(image_PIXELS / n_LEDS * LED * (math.cos(angle_rad)))
        frames_y[update, LED] = round(image_PIXELS / n_LEDS * LED * (math.sin(angle_rad)))
    frame_cnt[update] = update
    frame_label.append("LED " + str(update))
    theta = theta + 360 / frame_len

print("Bytes of data in frame: {:.0f}".format(image_PIXELS**2*3))
print("Maximum frames in memory: {:.0f}".format(mem_storage / 8 / (image_PIXELS**2*3)))
print("Total time in memory({:.0f}MB @ {}fps): {:.3f} seconds".format(mem_storage / 8 /  1e6, fps, mem_storage / 8 / (image_PIXELS**2*3) / fps))

def mem_comparison(LEDS):
    sLED = 16
    y = numpy.zeros([LEDS - sLED, 2])
    LEDS = numpy.arange(16, LEDS)
    for LED in LEDS:
        y[LED - sLED, 0] = (2 * LED) * (2 * LED) * 3
        theta = math.degrees(math.acos(1 - (a*a)/(2*LED*LED)))
        updates = math.ceil(360 / theta)
        y[LED - sLED, 1] = updates * LED * 3
    fig, ax = pyplot.subplots()
    ax.plot(y)
    ax.legend(['Square', 'Radial'])
    pyplot.show()

def mem_comparison2(start, finish):
    aS = numpy.arange(start, finish, 0.001)
    y = numpy.zeros([len(aS), 2])
    for n in range(len(aS)):
        y[n, 0] = (2 * n_LEDS) * (2 * n_LEDS) * 3
        theta = math.degrees(math.acos(1 - (aS[n]*aS[n])/(2*n_LEDS*n_LEDS)))
        updates = math.ceil(360 / theta)
        y[n, 1] = updates * n_LEDS * 3
    fig, ax = pyplot.subplots()
    ax.plot(aS,y)
    ax.legend(['Square', 'Radial'])
    pyplot.show()

##Hidden data
## (row 0, col 0) to (row 0, col 23) used as name
## (row 1, col 0) to (row 1, col 3) used as current frame #
## (row 2, col 0) to (row 2, col 3) used as last frame #
## (row 3, col 0) to (row 3, col 1) used as fps
## (row 4, col 0) to (row 4, col 1) used as loop?
