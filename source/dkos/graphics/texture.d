/**
    Textures
    
    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module dkos.graphics.texture;
import dreamcast.pvr.pvr;
import dkos.image;
import numem.core.hooks;
import numem;

/**
    Texture formats
*/
enum TextureFormat : uint {

    /**
        No or invalid texture.
    */
    none = 0,

    /**
        16-bit RGB
    */
    rgb                 = PVR_TXRFMT_RGB565,
    
    /**
        16-bit ARGB
    */
    argb                = PVR_TXRFMT_ARGB4444,

    /**
        8-bit YUV422 format
    */
    yuv442              = PVR_TXRFMT_YUV422,
    
    /**
        Bumpmap format
    */
    bumpmap             = PVR_TXRFMT_BUMP,
    
    /**
        4BPP paletted format
    */
    pal4bpp             = PVR_TXRFMT_PAL4BPP,
    
    /**
        8BPP paletted format
    */
    pal8bpp             = PVR_TXRFMT_PAL8BPP,
    
    /**
        16-bit RGB (Compressed)
    */
    rgbCompressed       = PVR_TXRFMT_RGB565 | PVR_TXRFMT_VQ_ENABLE,
    
    /**
        16-bit ARGB (Compressed)
    */
    argbCompressed      = PVR_TXRFMT_ARGB4444 | PVR_TXRFMT_VQ_ENABLE,
    
    /**
        8-bit YUV422 format (Compressed)
    */
    yuv442Compressed    = PVR_TXRFMT_YUV422 | PVR_TXRFMT_VQ_ENABLE,
    
    /**
        Bumpmap format (Compressed)
    */
    bumpmapCompressed   = PVR_TXRFMT_BUMP | PVR_TXRFMT_VQ_ENABLE,
}

/**
    Texture filters
*/
enum TextureFilter : uint {
    
    /**
        Bi-linear filtering
    */
    linear  = PVR_FILTER_BILINEAR,
    
    /**
        Nearest neighbour filtering.
    */
    nearest = PVR_FILTER_NEAREST
}


/**
    A 2D texture which can be used for rendering.
*/
class Texture2D : NuRefCounted {
@nogc:
private:
    uint width_;
    uint height_;
    TextureFormat format_;
    pvr_ptr_t data_;

public:
    
    /**
        Width of the image
    */
    @property uint width() @safe => width_;
    
    /**
        Height of the image
    */
    @property uint height() @safe => height_;

    /**
        Color format of the texture.
    */
    @property TextureFormat format() @safe => format_;
    
    /**
        Pointer to the underlying data of the texture.
    */
    @property pvr_ptr_t data() @system => data;

    /**
        Whether the texture has an alpha channel.
    */
    @property bool hasAlpha() @safe {
        return format_ == TextureFormat.argb || format_ == TextureFormat.argbCompressed; 
    }

    ~this() {
        if (data_) {
            pvr_mem_free(data_);
            data_ = null;
            format_ = TextureFormat.none;
            width_ = 0;
            height_ = 0;
        }
    }

    /**
        Constructs a Texture2D from the given image and format.

        Note:
            Compressing textures on load is **not** supported!

        Params:
            image =     The image to get the data from.
            format =    The format of the image.
    */
    this(Image image, TextureFormat format) {
        uint flags;        
        uint alignment;
        switch(format) {
            default: 
                break;
            case TextureFormat.argb:
            case TextureFormat.rgb:
                alignment = 2;
                flags |= PVR_TXRLOAD_16BPP;
                break;

            case TextureFormat.pal8bpp:
            case TextureFormat.yuv442:
                alignment = 1;
                flags |= PVR_TXRLOAD_8BPP;
                break;

        }

        if (flags != 0) {
            data_ = pvr_mem_malloc(image.width * image.height * alignment);
            pvr_txr_load_kimg(image.handle(), data_, flags);
        }
    }
}
