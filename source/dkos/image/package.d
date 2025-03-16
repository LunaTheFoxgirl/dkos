/**
    DKOS Image Handling

    This module provides a platform-independent image type that is designed to
    hold any sort of textures or other image data. This type contains a very
    basic description of the image data (width, height, pixel format), as well
    as the image data itself.

    Additionally, compatibility with `kos/img.h` is provided.

    Authors:
        Megan Potter
        Luna Nielsen
*/
module dkos.image;
import numem.core.hooks;
import numem;

extern(C):
@nogc:
nothrow:

/// Opaque low-level kos image struct.
struct kos_img_t;

/**
    Image color formats supported by the image system.
*/
enum PixelFormat {
    none        = 0x00,
    rgb888      = 0x01,
    argb8888    = 0x02,
    rgb565      = 0x03,
    argb4444    = 0x04,
    argb1555    = 0x05,
    pal4BPP     = 0x06,
    pal8BPP     = 0x07,
    yuv422      = 0x08,
    bgr565      = 0x09,
    rgba8888    = 0x10,
}

/**
    Gets the bits-per-pixel for the given format.
*/
uint getBitsPerPixel(PixelFormat format) {
    final switch(format) with(PixelFormat) {
        case none: return 0;
        case rgb888: return 24;
        case argb8888: return 32;
        case rgb565: return 16;
        case argb4444: return 16;
        case argb1555: return 8;
        case pal4BPP: return 8;
        case pal8BPP: return 8;
        case yuv422: return 8;
        case bgr565: return 15;
        case rgba8888: return 32;
    }
}

/**
    Gets the bits-per-pixel for the given format.
*/
uint getBytesPerPixel(PixelFormat format) {
    final switch(format) with(PixelFormat) {
        case none: return 0;
        case rgb888: return 3;
        case argb8888: return 4;
        case rgb565: return 2;
        case argb4444: return 2;
        case argb1555: return 1;
        case pal4BPP: return 1;
        case pal8BPP: return 1;
        case yuv422: return 1;
        case bgr565: return 2;
        case rgba8888: return 4;
    }
}

/**
    A platform independent, reference counted image.
*/
class Image : NuRefCounted {
@nogc:
private:
    __kos_img_t img;

public:
    
    /**
        Width of the image
    */
    @property uint width() => img.w;
    
    /**
        Height of the image
    */
    @property uint height() => img.h;

    /**
        Bits-per-pixel
    */
    @property uint bpp() => format.getBitsPerPixel();
    
    /**
        Color format of the image.
    */
    @property PixelFormat format() @trusted => cast(PixelFormat)(img.fmt & KOS_IMG_FMT_MASK);
    
    /**
        A slice of the data contained within the image.
    */
    @property ubyte[] data() @trusted => cast(ubyte[])img.data[0..img.byte_count];
    
    /**
        The low level KOS handle.
    */
    @property kos_img_t* handle() @trusted => cast(kos_img_t*)&img;

    ~this() @trusted {
        if ((img.fmt & KOS_IMG_NOT_OWNER) == 0) {
            nu_free(img.data);
        }
    }

    /**
        Constructs an Image from a low-level KallistiOS image.
    */
    this(kos_img_t* img) @trusted {
        this.img = *cast(__kos_img_t*)img;
        nu_free(img);
    }

    /**
        Creates a new image with the given format.
    */
    this(uint width, uint height, PixelFormat format) {
        img.fmt = cast(kos_img_fmt)format;
        img.w = width;
        img.h = height;
        img.data = cast(ubyte*)nu_malloc(format.getBytesPerPixel()*img.w*img.h);
    }

}

private:
extern(C): 

enum KOS_IMG_FMT_I(x) = ((x) & 0xffff);
enum KOS_IMG_FMT_D(x) = (((x) >> 16) & 0xffff);
enum KOS_IMG_FMT(i, d) = ( ((i) & 0xffff) | (((d) & 0xffff) << 16) );

alias kos_img_fmt = uint;
enum kos_img_fmt KOS_IMG_FMT_NONE        = 0x00;
enum kos_img_fmt KOS_IMG_FMT_RGB888      = 0x01;
enum kos_img_fmt KOS_IMG_FMT_ARGB8888    = 0x02;
enum kos_img_fmt KOS_IMG_FMT_RGB565      = 0x03;
enum kos_img_fmt KOS_IMG_FMT_ARGB4444    = 0x04;
enum kos_img_fmt KOS_IMG_FMT_ARGB1555    = 0x05;
enum kos_img_fmt KOS_IMG_FMT_PAL4BPP     = 0x06;
enum kos_img_fmt KOS_IMG_FMT_PAL8BPP     = 0x07;
enum kos_img_fmt KOS_IMG_FMT_YUV422      = 0x08;
enum kos_img_fmt KOS_IMG_FMT_BGR565      = 0x09;
enum kos_img_fmt KOS_IMG_FMT_RGBA8888    = 0x10;
enum kos_img_fmt KOS_IMG_FMT_MASK        = 0xff;
enum kos_img_fmt KOS_IMG_INVERTED_X      = 0x0100;
enum kos_img_fmt KOS_IMG_INVERTED_Y      = 0x0200;
enum kos_img_fmt KOS_IMG_NOT_OWNER       = 0x0400;

struct __kos_img_t {
    void* data;
    uint w;
    uint h;
    kos_img_fmt fmt;
    uint byte_count;
}

extern void kos_img_free(kos_img_t* img, int struct_also);