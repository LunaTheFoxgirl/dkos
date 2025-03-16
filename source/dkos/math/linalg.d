/**
    DKOS Linear Algebra
    
    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module dkos.math.linalg;

/**
    Vectors
*/
struct VectorImpl(T, int dims) {
@nogc:
public:
    alias data this;

    static assert(dims >= 2 && dims <= 4, "Invalid vector size for this platform.");

    union {
        struct {
            T x;
            T y;
            static if (dims >= 3) T z;
            static if (dims == 4) T w;
        }

        /**
            The vector as a tightly packed static array.
        */
        T[dims] data;
    }
}

/**
    A 2-dimensional vector
*/
alias vec2 = VectorImpl!(float, 2);
alias vec2i = VectorImpl!(int, 2); /// ditto
alias vec2u = VectorImpl!(uint, 2); /// ditto

/**
    A 3-dimensional vector
*/
alias vec3 = VectorImpl!(float, 3);
alias vec3i = VectorImpl!(int, 3); /// ditto
alias vec3u = VectorImpl!(uint, 3); /// ditto

/**
    A 4-dimensional vector
*/
alias vec4 = VectorImpl!(float, 4);
alias vec4i = VectorImpl!(int, 4); /// ditto
alias vec4u = VectorImpl!(uint, 4); /// ditto

/**
    A rectangle
*/
struct RectImpl(T) {
@nogc:
public:
    union {
        struct {
            T x;
            T y;
            T width;
            T height;
        }

        struct {
            vec2 position;
            vec2 size;
        }
    }

    /**
        Left side of rectangle
    */
    @property T left() => x;
    
    /**
        Right side of rectangle
    */
    @property T right() => x+width;
    
    /**
        Top of rectangle
    */
    @property T top() => y;
    
    /**
        Bottom of rectangle
    */
    @property T bottom() => y+height;
}

/**
    A rectangle
*/
alias rect = RectImpl!int;
alias rectf = RectImpl!float; /// ditto
