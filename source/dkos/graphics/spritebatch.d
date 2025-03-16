/**
    Sprite Batching
    
    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module dkos.graphics.spritebatch;
import dkos.graphics.sprite;
import dkos.math;
import nulib.collections.vector;
import dreamcast.pvr.pvr;

import numem;

@nogc:

/**
    A simple sprite batch.
    
    Sprite batches expect all of the drawing commands to happen to the 
    same command list.

    NOTE:
        SpriteBatch is an expensive object memory wise; you should create
        them sparingly.
*/
final
class SpriteBatch : NuRefCounted {
@nogc:
private:
    bool recording = false;
    SpriteBucket* current;
    weak_vector!(SpriteBucket)[5] buckets;

    SpriteBucket* findBucket(Sprite sprite) {
        if (current && current.sprite is sprite && current.numCmds < 255) {
            return current;
        }

        foreach(ref bucket; buckets[sprite.drawList]) {
            if (bucket.sprite is sprite && bucket.numCmds < 255)
                return &bucket;
        }

        buckets[sprite.drawList] ~= SpriteBucket(sprite, 0);
        return &buckets[sprite.drawList][$-1];
    }

    void flush() {
        pvr_scene_begin();
        static foreach(i; 0..buckets.length) {
            if (!buckets[i].empty) {

                pvr_list_begin(cast(int)i);
                foreach(ref SpriteBucket bucket; buckets[i][])
                    bucket.submit();
                pvr_list_finish();
                buckets[i].resize(0);
            }
        }
        pvr_scene_finish();
    }

public:

    /**
        Begins a sprite batch render pass.
    */
    void begin() {
        if (!recording) {
            recording = true;
        }
    }

    /**
        Ends a sprite batch render pass.
    */
    void end() {
        if (recording) {
            recording = false;
            flush();
        }
    }

    /**
        Draws a sprite.
    */
    void draw(Sprite sprite, rect area) {
        if (!recording)
            return;
        
        current = findBucket(sprite);
        current.cmds[current.numCmds++] = SpriteCmd(
            area.position,
            area.size,
            vec2(0, 0),
            vec2(1, 1)
        );
    }

    /**
        Draws a sprite.
    */
    void draw(Sprite sprite, rect area, rectf uvs) {
        if (!recording)
            return;
        
        current = findBucket(sprite);
        current.cmds[current.numCmds++] = SpriteCmd(
            area.position,
            area.size,
            vec2(uvs.left, uvs.top),
            vec2(uvs.bottom, uvs.right)
        );
    }
}

private:

// A bucket which stores draw instances for the sprite.
struct SpriteBucket {
@nogc:
    Sprite sprite;

    uint numCmds = 0;
    SpriteCmd[255] cmds;

    void submit() {
        auto hdr = sprite.next();
        pvr_prim(&hdr, pvr_sprite_hdr_t.sizeof);
    
        foreach(i; 0..numCmds) {

            auto cmd = cmds[i].build(i+1 == numCmds);
            pvr_prim(&cmd, pvr_sprite_txr_t.sizeof);
        }

        numCmds = 0;
        sprite = null;
    }
}

// An individual command within the batch.
struct SpriteCmd {
@nogc:
    vec2 position;
    vec2 size;
    vec2 uvTopLeft;
    vec2 uvBottomRight;

    pvr_sprite_txr_t build(bool eol) {
        pvr_sprite_txr_t data;
        data.ax = position.x;
        data.ay = position.y;
        data.bx = position.x+size.x;
        data.by = position.y;
        data.cx = position.x+size.x;
        data.cy = position.y+size.y;
        data.dx = position.x;
        data.dy = position.y+size.y;
        data.auv = PVR_PACK_16BIT_UV(uvTopLeft.x, uvTopLeft.y);
        data.buv = PVR_PACK_16BIT_UV(uvBottomRight.x, uvTopLeft.y);
        data.cuv = PVR_PACK_16BIT_UV(uvBottomRight.x, uvBottomRight.y);

        if (eol)
            data.flags = PVR_CMD_VERTEX_EOL;
        
        return data;
    }
}