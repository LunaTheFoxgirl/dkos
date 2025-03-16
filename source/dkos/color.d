/**
    DKOS Color Conversion
    
    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module dkos.color;

@nogc nothrow:

/**
    Convert floating point RGBA to 32-bit ARGB.
*/
pragma(inline, true)
uint rgbafToARGB32(float r, float g, float b, float a) @safe {
    return 
        (cast(ubyte)(a * 255)) << 0  |
        (cast(ubyte)(r * 255)) << 8  |
        (cast(ubyte)(g * 255)) << 16 |
        (cast(ubyte)(b * 255)) << 24;
}

/**
    Convert floating point RGBA to 32-bit RGBA.
*/
pragma(inline, true)
uint rgbafToRGBA32(float r, float g, float b, float a) @safe {
    return 
        (cast(ubyte)(r * 255)) << 0  |
        (cast(ubyte)(g * 255)) << 8  |
        (cast(ubyte)(b * 255)) << 16 |
        (cast(ubyte)(a * 255)) << 24;
}