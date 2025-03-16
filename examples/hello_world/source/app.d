/**
    DKOS Example
    
    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module app;
import dkos.video;
import dkos.math;
import dkos.logging;
import numem;

void main() {
	dbg_log("Hello, world!\n");

	// Set mode and remove the border by setting the
	// drawing area to the entire screen.
	Display.setMode(DisplayMode.mode640x480);
	Display.drawArea = rect(0, 0, 640, 480);

	dbg_draw(vec2i(32, 32), "Hello, world!");
	Display.flip();
}
