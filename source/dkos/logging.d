/**
    DKOS Debugging primitives
    
    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module dkos.logging;
import dkos.video;
import dkos.math;

import dreamcast.minifont;
import nulib.c.stdio;

@nogc nothrow:

/**
    Writes a log output which is present in all builds.
*/
void log(Args...)(const(char)* fmt, Args args) {
    cast(void)printf(fmt, args);
}

/**
    Writes a log output which is present in debug builds.
*/
void dbg_log(Args...)(const(char)* fmt, Args args) {
    debug cast(void)printf(fmt, args);
}

/**
    Draws text to the screen with a debug font. (max 255 characters, ASCII only.)
*/
void dbg_draw(Args...)(vec2i offset, const(char)* fmt, Args args) {
    cast(void)snprintf(__tmp_buffer.ptr, 255, fmt, args);
    minifont_draw_str(Display.getFbOffset(offset.x, offset.y), Display.width, __tmp_buffer.ptr);
}

//
//      IMPLEMENTATION DETAILS.
//
private:

// Buffer for format string, thread local.
char[255] __tmp_buffer;
