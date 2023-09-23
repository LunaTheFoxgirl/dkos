module core.stdc.config;

static if ( (void*).sizeof > int.sizeof ) {
    enum __c_longlong : long;
    enum __c_ulonglong : ulong;

    alias   c_long = long;
    alias  c_ulong = ulong;

    alias cpp_long = long;
    alias cpp_ulong = ulong;

    alias cpp_longlong = __c_longlong;
    alias cpp_ulonglong = __c_ulonglong;
} else {
    enum __c_long  : int;
    enum __c_ulong : uint;

    alias c_long = int;
    alias c_ulong = uint;

    alias cpp_long = __c_long;
    alias cpp_ulong = __c_ulong;

    alias cpp_longlong = long;
    alias cpp_ulonglong = ulong;
}

alias c_long_double = real;