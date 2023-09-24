module std.math;
import core.stdc.math;

enum float PI = 3.14159;

/// PI / 180 at compiletime, used for degrees/radians conversion.
enum float PI_180 = PI / 180;

/// 180 / PI at compiletime, used for degrees/radians conversion.
enum float _180_PI = 180 / PI;

float sin(float x) { return sinf(x); }
float cos(float x) { return cos(x); }
float tan(float x) { return tan(x); }
float mod(float x, float y) { return fmod(x, y); }

float floor(float x) { return core.stdc.math.floor(x); }
float min(float x, float y) { return x < y ? x : y; }
float max(float x, float y) { return x > y ? x : y; }
float clamp(float x, float minV, float maxV) { return min(max(x, minV), maxV); }

bool isNaN(float x) { return cast(bool)isnanf(x); }
bool isInfinity(float x) { return cast(bool)isinf(x); }



/// Converts degrees to radians.
real radians(real degrees) {
    return PI_180 * degrees;
}

/// Compiletime version of $(I radians).
real cradians(real degrees)() {
    return radians(degrees);
}

/// Converts radians to degrees.
real degrees(real radians) {
    return _180_PI * radians;
}

/// Compiletime version of $(I degrees).
real cdegrees(real radians)() {
    return degrees(radians);
}

/// Returns 0.0 if x <= edge0 and 1.0 if x >= edge1 and performs smooth 
/// hermite interpolation between 0 and 1 when edge0 < x < edge1. 
/// This is useful in cases where you would want a threshold function with a smooth transition.
float smoothstep(float edge0, float edge1, float x) {
    auto t = clamp((x - edge0) / (edge1 - edge0), 0, 1);
    return t * t * (3 - 2 * t);
}