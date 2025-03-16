/**
    DKOS Math Primitives.
    
    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module dkos.math;
public import nulib.math;
public import nulib.c.math;
public import dreamcast.fmath;
public import dkos.math.linalg;

/**
    Linearly interpolates between values.

    Params:
        x = First value
        y = Second value
        t = the interpolation step.
    
    Returns:
        Interpolated value between $(D x) and $(D y).
*/
T lerp(T)(T x, T y, T t) if (__traits(isScalar, T)) {
	return (1 - t) * x + t * y;
}