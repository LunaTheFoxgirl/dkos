/**
 * D header file for C99.
 *
 * $(C_HEADER_DESCRIPTION pubs.opengroup.org/onlinepubs/009695399/basedefs/_stdlib.h.html, _stdlib.h)
 *
 * Copyright: Copyright Sean Kelly 2005 - 2014.
 * License: Distributed under the
 *      $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0).
 *    (See accompanying file LICENSE)
 * Authors:   Sean Kelly
 * Standards: ISO/IEC 9899:1999 (E)
 * Source: $(DRUNTIMESRC core/stdc/_stdlib.d)
 */

module core.stdc.stdlib;
import core.stdc.config;
import core.stdc.stddef;

extern(C):
nothrow:
@nogc:

///
struct div_t
{
    int quot,
        rem;
}

///
struct ldiv_t
{
    c_long quot,
           rem;
}

///
struct lldiv_t
{
    long quot,
         rem;
}

///
enum EXIT_SUCCESS = 0;
///
enum EXIT_FAILURE = 1;
///
enum MB_CUR_MAX   = 1;


///
double  atof(scope const char* nptr);
///
int     atoi(scope const char* nptr);
///
c_long  atol(scope const char* nptr);
///
long    atoll(scope const char* nptr);

///
double  strtod(scope inout(char)* nptr, scope inout(char)** endptr);
///
float   strtof(scope inout(char)* nptr, scope inout(char)** endptr);
///
c_long  strtol(scope inout(char)* nptr, scope inout(char)** endptr, int base);
///
long    strtoll(scope inout(char)* nptr, scope inout(char)** endptr, int base);
///
c_ulong strtoul(scope inout(char)* nptr, scope inout(char)** endptr, int base);
///
ulong   strtoull(scope inout(char)* nptr, scope inout(char)** endptr, int base);

/// These two were added to Bionic in Lollipop.
int     rand();

///
void    srand(uint seed);

// We don't mark these @trusted. Given that they return a void*, one has
// to do a pointer cast to do anything sensible with the result. Thus,
// functions using these already have to be @trusted, allowing them to
// call @system stuff anyway.
///
void*   malloc(size_t size);
///
void*   calloc(size_t nmemb, size_t size);
///
void*   realloc(void* ptr, size_t size);
///
void    free(void* ptr);

///
noreturn abort() @safe;
///
noreturn exit(int status);
///
int     atexit(void function() func);
///
noreturn _Exit(int status);

///
char*   getenv(scope const char* name);
///
int     system(scope const char* string);

// These only operate on integer values.
@trusted
{
    ///
    pure int     abs(int j);
    ///
    pure c_long  labs(c_long j);
    ///
    pure long    llabs(long j);

    ///
    div_t   div(int numer, int denom);
    ///
    ldiv_t  ldiv(c_long numer, c_long denom);
    ///
    lldiv_t lldiv(long numer, long denom);
}

///
int     mblen(scope const char* s, size_t n);
///
int     mbtowc(scope wchar_t* pwc, scope const char* s, size_t n);
///
int     wctomb(scope char* s, wchar_t wc);
///
size_t  mbstowcs(scope wchar_t* pwcs, scope const char* s, size_t n);
///
size_t  wcstombs(scope char* s, scope const wchar_t* pwcs, size_t n);

void* alloca(size_t size) pure; // compiler intrinsic