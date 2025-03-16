/**
    DKOS Video Modes
    
    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module dkos.video;
import dkos.math.linalg;

import dreamcast.video;
import numem;
import dreamcast.pvr.pvr;
import nulib.math;

/**
    Enumeration of the different kinds of display cables
    that can be used.
*/
enum DisplayCable : int {
    
    /**
        No cable is connected.
    */
    none        = CT_NONE,
    
    /**
        Composite/RF cable connected.
    */
    composite   = CT_COMPOSITE,
    
    /**
        Component RGB/SCART cable.
    */
    component   = CT_RGB,
    
    /**
        VGA cable.
    */
    vga         = CT_VGA,
}

/**
    The display pixel format.
*/
enum DisplayFormat : int {

    /**
        15-bit RGB
    */
    rgb555  = PM_RGB555,

    /**
        16-bit RGB
    */
    rgb565  = PM_RGB565,

    /**
        24-bit packed RGB
    */
    rgb24   = PM_RGB888P,

    /**
        32-bit RGB with 8 bytes of padding.
    */
    rgb32   = PM_RGB0888
}

/**
    Display Modes
*/
enum DisplayMode : uint {
    
    /**
        320x240 resolution
    */
    mode320x240 = DM_320x240,
    
    /**
        640x480 resolution
    */
    mode640x480 = DM_640x480,
    
    /**
        800x608 resolution
    */
    mode800x608 = DM_800x608,
    
    /**
        256x256 resolution
    */
    mode256x256 = DM_256x256,
    
    /**
        768x480 resolution
    */
    mode768x480 = DM_768x480,
    
    /**
        768x576 resolution
    */
    mode768x576 = DM_768x576,
}

/**
    Interface to the display.
*/
final
class Display {
@nogc nothrow:
public static:

    /**
        Current width of the display in pixels.
    */
    @property uint width() @trusted => vid_mode.width;

    /**
        Current height of the display in pixels.
    */
    @property uint height() @trusted => vid_mode.width;

    /**
        Current area that can be drawn in.
    */
    @property rect drawArea() @trusted => rect(
        vid_mode.borderx1, 
        vid_mode.bordery1,
        vid_mode.borderx2-vid_mode.borderx1, 
        vid_mode.bordery2-vid_mode.bordery1
    );
    @property void drawArea(rect area) @trusted {
        vid_waitvbl();

        uint x1 = clamp(area.left, 0, width);
        uint y1 = clamp(area.top, 0, height);
        uint x2 = clamp(area.right, x1, width);
        uint y2 = clamp(area.bottom, y1, height);

        vid_mode.borderx1 = cast(ushort)x1;
        vid_mode.bordery1 = cast(ushort)y1;
        vid_mode.borderx2 = cast(ushort)x2;
        vid_mode.bordery2 = cast(ushort)y2;

        pvr_set(PVR_BORDER_X, (vid_mode.borderx1 << 16) | vid_mode.borderx2);
        pvr_set(PVR_BORDER_Y, (vid_mode.bordery1 << 16) | vid_mode.bordery2);

        vid_empty();
    }

    @property uint borderColor() @trusted => *pvr_get_addr(PVR_BORDER_COLOR);
    @property void borderColor(uint value) @trusted {
        pvr_set(PVR_BORDER_COLOR, value & 0xFFFFFF);
    }

    /**
        The type of cable used by the display system.
    */
    @property DisplayCable cable() @trusted => cast(DisplayCable)vid_mode.cable_type;

    /**
        Pointer to the current writing index of the framebuffer.
    */
    @property ushort* fbptr() @system {
        if (vid_mode.fb_count > 0)
            return vram_s + vid_mode.fb_base[vid_mode.fb_curr];
        return vram_s;
    }

    /**
        Queries the console for which cable is currently connected.
    */
    DisplayCable queryCable() @trusted {
        return cast(DisplayCable)vid_check_cable();
    }

    /**
        Gets a starting offset into the framebuffer, based on
        the active drawing area.

        Params:

    */
    ushort* getFbOffset(uint x, uint y) @system {
        rect area = drawArea();
        return fbptr + ((y+area.y) * width) + x + area.x;
    }

    /**
        Waits for the next blanking interval, then switches
        the video mode of the display.

        Params:
            newMode = The new KOS mode to apply.
    */
    void setMode(vid_mode_t* newMode) @trusted {
        vid_waitvbl();
        vid_set_mode_ex(newMode);
        vid_empty();
    }

    /**
        Waits for the next blanking interval, then switches
        the video mode of the display.
        
        Params:
            mode    = The display mode (resolution) to apply.
            format  = The pixel format to apply.
    */
    void setMode(DisplayMode mode, DisplayFormat format = DisplayFormat.rgb565) @trusted {
        vid_waitvbl();
        vid_set_mode(mode, format);
        vid_empty();
    }

    /**
        Flips the framebuffers and optionally waits for the next
        vertical blanking interval.

        Params:
            await = Whether to wait for the next blanking interval.
    */
    void flip(bool await = true) @trusted { 
        if (vid_mode.fb_count > 0)
            vid_flip(-1);
        
        if (await)
            vid_waitvbl();
    }
}