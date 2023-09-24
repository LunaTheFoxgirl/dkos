module core.stdc.stdarg;
import gcc.builtins;


T alignUp(size_t alignment = size_t.sizeof, T)(T base) pure
{
    enum mask = alignment - 1;
    static assert(alignment > 0 && (alignment & mask) == 0, "alignment must be a power of 2");
    auto b = cast(size_t) base;
    b = (b + mask) & ~mask;
    return cast(T) b;
}

alias va_copy = __builtin_va_copy;
alias va_end = __builtin_va_end;
void va_arg(T)(ref va_list ap, ref T parmn); // intrinsic
T va_arg(T)(ref va_list ap); // intrinsic
void va_start(T)(out va_list ap, ref T parmn);
alias va_list = __gnuc_va_list;
alias __gnuc_va_list = __builtin_va_list;