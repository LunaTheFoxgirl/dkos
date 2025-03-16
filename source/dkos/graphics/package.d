/**
    DKOS Graphics Framework

    This module provides an easy to use graphics framework for rendering
    2D and 3D constructs to the display.

    Authors:
        Luna Nielsen
*/
module dkos.graphics;
import dreamcast.pvr.pvr;

/**
    Blending Factors
*/
enum BlendFactor : int {
    
    /**
        Zero
    */
    zero                = PVR_BLEND_ZERO,
    
    /**
        One
    */
    one                 = PVR_BLEND_ONE,
    
    /**
        Destination Color
    */
    destColor           = PVR_BLEND_DESTCOLOR,
    
    /**
        1 - Destination Color
    */
    oneMinusDestColor   = PVR_BLEND_INVDESTCOLOR,
    
    /**
        Destination Alpha
    */
    destAlpha           = PVR_BLEND_DESTALPHA,
    
    /**
        1 - Destination Alpha
    */
    oneMinusDestAlpha   = PVR_BLEND_INVDESTALPHA,
    
    /**
        Source Alpha
    */
    sourceAlpha         = PVR_BLEND_SRCALPHA,
    
    /**
        1 - Source Alpha
    */
    oneMinusSourceAlpha = PVR_BLEND_INVSRCALPHA,
}