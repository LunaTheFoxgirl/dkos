module mem;
import std.traits;
import core.lifetime;

/**
    Allocates
*/
T mallocNew(T, Args...)(Args args) {
    static if (is(T == class))
        immutable size_t allocSize = __traits(classInstanceSize, T);
    else
        immutable size_t allocSize = T.sizeof;

    void* rawMemory = malloc(allocSize);
    if (!rawMemory)
        onOutOfMemoryErrorNoGC();

    static if (is(T == class))
    {
        emplace
        T obj = cast(T)rawMemory;
        obj.__ctor(args);
    }
    else
    {
        T* obj = cast(T*)rawMemory;
        obj.__ctor(args);
    }

    return obj;
}