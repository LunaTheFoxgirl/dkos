/**
    DKOS Game Class
    
    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module dkos.game;
import dkos.video;
import numem;
import dreamcast.timer;

/**
    A base game class which helps manage the overall game loop
    and resources of your game.
*/
abstract
class Game : NuObject {
@nogc:
private:
    ulong lastTime;
    ulong currTime;

    DisplayCable cable;
    DisplayMode targetMode;
    DisplayFormat targetFormat;

    float nextDelta() {
        lastTime = currTime;
        currTime = timer_ms_gettime64();
        return cast(float)(currTime-lastTime) * 0.0001;
    }
public:

    /**
        Whether the screen can be drawn to.
    */
    final
    @property bool canDraw() {
        auto ccable = Display.queryCable();
        if (cable != ccable) {
            this.onInputChanged(ccable);
            this.cable = ccable;
        }

        return cable != DisplayCable.none;
    }

    this(DisplayMode mode, DisplayFormat format = DisplayFormat.rgb565) {
        this.targetMode = mode;
        this.targetFormat = format;
    }

    /**
        Optional function which is called when the input
        is changed; the cable type is given during the
        display change.
    */
    void onInputChanged(DisplayCable cableType) { }

    /**
        Function which is called whenever the game
        should update.
    */
    abstract void update(float delta);

    final
    void run() {
        while(true) {
            float dt = this.nextDelta();
            
            if (!this.canDraw()) {

                // don't bother rendering and updating
                // if no cable is connected.
                timer_spin_sleep(100);
                continue;
            }

            this.update(dt);
            Display.flip(true);
        }
    }
}