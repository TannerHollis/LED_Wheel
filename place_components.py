import math
from pcbnew import *

def place_circle(refdes, start_angle, center, radius, component_offset=0, hide_ref=True, lock=False):
    
    """
    Places components in a circle
    refdes: List of component references
    start_angle: Starting angle
    center: Tuple of (x, y) mils of circle center
    radius: Radius of the circle in mils
    component_offset: Offset in degrees for each component to add to angle
    hide_ref: Hides the reference if true, leaves it be if None
    lock: Locks the footprint if true
    """
    pcb = GetBoard()
    deg_per_idx = 360 / len(refdes)
    for idx, rd in enumerate(refdes):
        part = pcb.FindModuleByReference(rd)
        angle = (deg_per_idx * idx + start_angle) % 360;
        print("{0}: {1}".format(rd, angle))
        xmils = center[0] + math.cos(math.radians(angle)) * radius
        ymils = center[1] + math.sin(math.radians(angle)) * radius
        part.SetPosition(wxPoint(FromMils(xmils), FromMils(ymils)))
        part.SetOrientation(angle * -10)
        if hide_ref is not None:
            part.Reference().SetVisible(not hide_ref)
    Refresh()

def place_LEDs(center=(0,0), component_spacing=(0, 0), hide_ref=False, lock=False):
    
    """
    Places LEDs
    center: starting point to place the components 
    component_spacing: spacing in x and y direction
    hide_ref: Hides the reference if true, leaves it be if None
    lock: Locks the footprint if true
    """

    r_start = 64
    g_start = 0
    b_start = 128
    r_LEDS = []
    g_LEDS = []
    b_LEDS = []
    for j in range(1, 65, 2):
        r_LEDS.append("D{}".format(j + r_start))
        g_LEDS.append("D{}".format(j + g_start))
        b_LEDS.append("D{}".format(j + b_start))
    for j in range(2, 66, 2):
        r_LEDS.append("D{}".format(j + r_start))
        g_LEDS.append("D{}".format(j + g_start))
        b_LEDS.append("D{}".format(j + b_start))
    
    pcb = GetBoard()
    for color in range(0, 3):
        for led in range(0, 64):
            if color == 0:
                part = pcb.FindModuleByReference(r_LEDS[led])
            if color == 1:
                part = pcb.FindModuleByReference(g_LEDS[led])
            if color == 2:
                part = pcb.FindModuleByReference(b_LEDS[led])
            xmm = center[0] + component_spacing[0]*color
            ymm = center[1] + component_spacing[1]*led
            part.SetPosition(wxPoint(FromMM(xmm), FromMM(ymm)))
            print("({},{})".format(xmm, ymm))
            part.SetOrientation(0)
            if hide_ref is not None:
                part.Reference().SetVisible(not hide_ref)
    Refresh()
