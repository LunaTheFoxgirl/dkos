/** \file   dc/pvr.h
    \brief  Color math utilities

    This file provides some extra utilities for color handling and conversion.

    \author Luna the Foxgirl
*/
module extra.color;

/**
    Converts HSV to RGB
*/
float[3] hsv2rgb(float h, float s, float v) {
    if(s == 0.0f) { // s
        return [v, v, v]; // v
    } else {
        float var_h = h * 6;
        float var_i = floor(var_h);
        float var_1 = v * (1 - s);
        float var_2 = v * (1 - s * (var_h - var_i));
        float var_3 = v * (1 - s * (1 - (var_h - var_i)));

        if(var_i == 0.0f)      return [v, var_3, var_1];
        else if(var_i == 1.0f) return [var_2, v, var_1];
        else if(var_i == 2.0f) return [var_1, v, var_3];
        else if(var_i == 3.0f) return [var_1, var_2, v];
        else if(var_i == 4.0f) return [var_3, var_1, v];
        else                   return [v, var_1, var_2];
    }
}