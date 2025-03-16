/**
    Sprites
    
    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module dkos.graphics.sprite;
import dkos.graphics.texture;
import dkos.graphics;
import dkos.color;
import dkos.math.linalg;

import dreamcast.pvr.pvr;
import numem;

/**
    Base class for all sprites.
*/
abstract
class Sprite : NuRefCounted {
@nogc:
protected:
    pvr_sprite_cxt_t pvrSprite;

public:

    /**
        Which PVR draw list this sprite will be submitted to.
    */
    final @property uint drawList() => pvrSprite.list_type;

    /**
        Whether the sprite is opaque.
    */
    abstract @property bool isOpaque();

    /**
        Gets the next texture header for use with a sprite batch.

        This is usually used internally, as such it's marked as unsafe,
        you can however use it to submit the sprite to the PVR drawlist.

        Returns:
            A pvr_sprite_hdr_t
    */
    pvr_sprite_hdr_t next() @system {
        pvrSprite.list_type = isOpaque ? PVR_LIST_OP_POLY : PVR_LIST_TR_POLY;

        pvr_sprite_hdr_t hdr;
        pvr_sprite_compile(&hdr, &pvrSprite);
        return hdr;
    }
}

/**
    A 2D sprite which contains a solid color and isn't depth sorted.
*/
class SolidSprite2D : Sprite {
@nogc:
private:
    vec4 color = vec4(1, 1, 1, 1);

public:

    /**
        Constructs a new solid color sprite.
    */
    this(vec4 color) {
        pvr_sprite_cxt_col(&pvrSprite, PVR_LIST_TR_POLY);
        this.color = color;
    }

    /**
        Constructs a new solid color sprite.
    */
    this(vec3 color) {
        pvr_sprite_cxt_col(&pvrSprite, PVR_LIST_OP_POLY);
        this.color = vec4(color.x, color.y, color.z, 1);
    }

    /**
        Whether the sprite is opaque.
    */
    override
    @property bool isOpaque() {
        return color.w >= 1;
    }

    /**
        Gets the next texture header for use with a sprite batch.

        This is usually used internally, as such it's marked as unsafe,
        you can however use it to submit the sprite to the PVR drawlist.

        Returns:
            A pvr_sprite_hdr_t
    */
    override
    pvr_sprite_hdr_t next() @system {
        auto hdr = super.next();
        hdr.argb = rgbafToARGB32(color.x, color.y, color.z, color.w);
        return hdr;
    }
}

/**
    A 2D sprite which contains a texture and isn't depth sorted.
*/
class Sprite2D : Sprite {
@nogc:
private:
    Texture2D texture_;
    uint color_ = 0xFFFFFFFF;

public:

    /**
        The texture filter to use when rendering the sprite.
    */
    @property TextureFilter filter() @safe => cast(TextureFilter)pvrSprite.txr.filter;
    @property void filter(TextureFilter filter) @safe {
        pvrSprite.txr.filter = filter;
    }

    /**
        The texture filter to use when rendering the sprite.
    */
    @property BlendFactor sourceBlendingFactor() @safe => cast(BlendFactor)pvrSprite.blend.src;
    @property void sourceBlendingFactor(BlendFactor factor) @safe {
        pvrSprite.blend.src = factor;
    }

    /**
        The texture filter to use when rendering the sprite.
    */
    @property BlendFactor destBlendingFactor() @safe => cast(BlendFactor)pvrSprite.blend.dst;
    @property void destBlendingFactor(BlendFactor factor) @safe {
        pvrSprite.blend.dst = factor;
    }


    /**
        The color of the sprite.
    */
    @property uint color() @safe => color_;
    @property void color(uint value) { color_ = value; }
    @property void color(vec4 value) { color_ = rgbafToARGB32(value.x, value.y, value.z, value.w); }

    ~this() {
        if (texture_) {
            texture_.release();
            texture_ = null;
        }
    }

    /**
        Constructs a new sprite.
    */
    this(Texture2D texture, TextureFilter filter = TextureFilter.linear) {
        if (texture) {
            this.texture_ = texture.retained;

            pvr_sprite_cxt_txr(
                &pvrSprite, 
                texture.hasAlpha() ? PVR_LIST_TR_POLY : PVR_LIST_OP_POLY, 
                texture.format(), 
                texture.width, 
                texture.height(), 
                texture.data, 
                filter
            );

            pvrSprite.blend.src_enable = true;
            pvrSprite.blend.dst_enable = true;
            pvrSprite.txr.filter = filter;
		    pvrSprite.txr.alpha = texture.hasAlpha();
		    pvrSprite.gen.specular = true;
		    pvrSprite.txr.env = PVR_TXRENV_REPLACE;
        }
    }

    /**
        Whether the sprite is opaque.
    */
    override
    @property bool isOpaque() {
        return pvrSprite.list_type == PVR_LIST_OP_POLY;
    }

    /**
        Gets the next texture header for use with a sprite batch.

        This is usually used internally, as such it's marked as unsafe,
        you can however use it to submit the sprite to the PVR drawlist.

        Returns:
            A pvr_sprite_hdr_t
    */
    override
    pvr_sprite_hdr_t next() @system {
        auto hdr = super.next();
        hdr.argb = color; 
        return hdr;
    }
}
