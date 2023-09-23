module mem;
import std.traits;
import core.lifetime;
import core.stdc.stdlib;

/**
    Allocates a new object
*/
T mallocNew(T, Args...)(Args args) {
    static if (is(T == class))
        immutable size_t allocSize = __traits(classInstanceSize, T);
    else
        immutable size_t allocSize = T.sizeof;

    void* rawMemory = malloc(allocSize);
    if (!rawMemory) {
        exit(-1);
    }

    static if (is(T == class))
    {
        T obj = emplace!T(rawMemory[0 .. allocSize], args);
    }
    else
    {
        T* obj = cast(T*)rawMemory;
        emplace!T(obj, args);
    }

    return obj;
}

/**
    Destroys and frees the memory.

    For structs this will call the struct's destructor if it has any.
*/
void destroyFree(T)(T obj_) {
    static if (__traits(isPointer, T) || __traits(isAbstractClass, T) || __traits(isFinalClass, T)) {
        if (obj_) {
            obj_.__xdtor();
            free(obj_);
        }
    } else static if (__traits(hasMember, T, "__dtor")) {
            obj_.__dtor();
    }
}