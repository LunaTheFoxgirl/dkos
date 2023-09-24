/**
 * D header file for C99.
 *
 * $(C_HEADER_DESCRIPTION pubs.opengroup.org/onlinepubs/009695399/basedefs/_math.h.html, _math.h)
 *
 * Copyright: Copyright Sean Kelly 2005 - 2012.
 * License: Distributed under the
 *      $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0).
 *    (See accompanying file LICENSE)
 * Authors:   Sean Kelly
 * Source:    $(DRUNTIMESRC core/stdc/_math.d)
 */

module core.stdc.math;

import core.stdc.config;

extern (C):
@trusted: // All functions here operate on floating point and integer values only.
nothrow:
@nogc:

///
alias float_t = float;
///
alias double_t = double;

///
enum double HUGE_VAL      = double.infinity;
///
enum double HUGE_VALF     = float.infinity;
///
enum double HUGE_VALL     = real.infinity;

///
enum float INFINITY       = float.infinity;
///
enum float NAN            = float.nan;

enum {
    ///
    FP_SUBNORMAL = -2,
    ///
    FP_NORMAL    = -1,
    ///
    FP_ZERO      =  0,
    ///
    FP_INFINITE  =  1,
    ///
    FP_NAN       =  2,
}

enum {
    ///
    FP_FAST_FMA  = 0,
    ///
    FP_FAST_FMAF = 0,
    ///
    FP_FAST_FMAL = 0,
}

//int fpclassify(real-floating x);
    ///
pragma(mangle, "__fpclassifyf") pure int fpclassify(float x);
///
pragma(mangle, "__fpclassifyd")  pure int fpclassify(double x);

//int isfinite(real-floating x);
///
pragma(mangle, "__finitef") pure int isfinite(float x);
///
pragma(mangle, "__finited")  pure int isfinite(double x);

//int isinf(real-floating x);
///
pragma(mangle, "__isinff") pure int isinf(float x);
///
pragma(mangle, "__isinfd")  pure int isinf(double x);

//int isnan(real-floating x);
///
pragma(mangle, "__isnanf") pure int isnanf(float x);
///
pragma(mangle, "__isnand")  pure int isnand(double x);

//int isnormal(real-floating x);
///
extern (D) pure int isnormal(float x)       { return fpclassify(x) == FP_NORMAL; }
///
extern (D) pure int isnormal(double x)      { return fpclassify(x) == FP_NORMAL; }

//int signbit(real-floating x);
///
pragma(mangle, "__signbitf") pure int signbitf(float x);
///
pragma(mangle, "__signbitd")  pure int signbitd(double x);

extern (D)
{
    //int isgreater(real-floating x, real-floating y);
    ///
    pure int isgreater(float x, float y)        { return x > y; }
    ///
    pure int isgreater(double x, double y)      { return x > y; }
    ///
    pure int isgreater(real x, real y)          { return x > y; }

    //int isgreaterequal(real-floating x, real-floating y);
    ///
    pure int isgreaterequal(float x, float y)   { return x >= y; }
    ///
    pure int isgreaterequal(double x, double y) { return x >= y; }
    ///
    pure int isgreaterequal(real x, real y)     { return x >= y; }

    //int isless(real-floating x, real-floating y);
    ///
    pure int isless(float x, float y)           { return x < y; }
    ///
    pure int isless(double x, double y)         { return x < y; }
    ///
    pure int isless(real x, real y)             { return x < y; }

    //int islessequal(real-floating x, real-floating y);
    ///
    pure int islessequal(float x, float y)      { return x <= y; }
    ///
    pure int islessequal(double x, double y)    { return x <= y; }
    ///
    pure int islessequal(real x, real y)        { return x <= y; }

    //int islessgreater(real-floating x, real-floating y);
    ///
    pure int islessgreater(float x, float y)    { return x != y && !isunordered(x, y); }
    ///
    pure int islessgreater(double x, double y)  { return x != y && !isunordered(x, y); }

    //int isunordered(real-floating x, real-floating y);
    ///
    pure int isunordered(float x, float y)      { return isnanf(x) || isnanf(y); }
    ///
    pure int isunordered(double x, double y)    { return isnand(x) || isnand(y); }
}

///
float  acosf(float x);

///
float  asinf(float x);

///
pure float  atanf(float x);

///
float  atan2f(float y, float x);

///
pure float  cosf(float x);

///
pure float  sinf(float x);

///
pure float  tan(float x);

///
float  acosh(float x);

///
pure float  asinh(float x);

///
float  atanh(float x);

///
float  cosh(float x);

///
float  sinh(float x);

///
pure float  tanh(float x);

///
float  exp(float x);

///
float  exp2(float x);

///
float  expm1(float x);

///
pure float  frexp(float value, int* exp);

///
int     ilogb(float x);

///
float  ldexp(float x, int exp);

///
float  log(float x);

///
float  log10(float x);

///
float  log1p(float x);

///
float  log2(float x);

///
float  logb(float x);

///
pure float  modf(float value, float* iptr);

///
float  scalbn(float x, int n);

///
float  scalbln(float x, c_long n);

///
pure float  cbrt(float x);

///
pure float  fabs(float x);

///
float  hypot(float x, float y);

///
float  pow(float x, float y);

///
float  sqrt(float x);

///
pure float  erf(float x);

///
float  erfc(float x);

///
float  lgamma(float x);

///
float  tgamma(float x);

///
pure float  ceil(float x);

///
pure float  floor(float x);

///
pure float  nearbyint(float x);

///
pure float  rint(float x);

///
c_long  lrint(float x);

///
long    llrint(float x);

///
pure float  round(float x);

///
c_long  lround(float x);

///
long    llround(float x);

///
pure float  trunc(float x);

///
float  fmod(float x, float y);

///
float  remainder(float x, float y);

///
float  remquo(float x, float y, int* quo);

///
pure float  copysign(float x, float y);

///
pure float  nan(char* tagp);

///
float  nextafter(float x, float y);

///
float  nexttoward(float x, real y);

///
float  fdim(float x, float y);

///
pure float  fmax(float x, float y);

///
pure float  fmin(float x, float y);

///
pure float  fma(float x, float y, float z);