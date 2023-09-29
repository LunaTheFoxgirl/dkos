/* KallistiOS ##version##

   dc/fmath_base.h
   Copyright (C) 2001 Andrew Kieschnick
   Copyright (C) 2014 Josh Pearson

*/
module dreamcast.fmath;

extern(C):
nothrow:
@nogc:

enum F_PI = 3.1415926f;

pragma(inline, true)
float __fsin(float x) {
    float __value = x;
    float __arg = x;
    float __scale = 10430.37835;
    asm @nogc nothrow {
        "fmul %2,%1
        ftrc %1,fpul
        fsca fpul,dr0
        fmov fr0,%0"
        : "=f" (__value), "+&f" (__scale)
        : "f" (__arg)
        : "fpul", "fr0", "fr1";
    }
    
    return __value;
}

pragma(inline, true)
float __fcos(float x) {
    float __value = x;
    float __arg = x;
    float __scale = 10430.37835;
    asm @nogc nothrow {
        "fmul %2,%1
        ftrc %1,fpul
        fsca fpul,dr0
        fmov fr1,%0"
        : "=f" (__value), "+&f" (__scale)
        : "f" (__arg)
        : "fpul", "fr0", "fr1";
    }
    
    return __value;
}