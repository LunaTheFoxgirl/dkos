/**
    Binding to `arch/dreamcast/include/timer.h`

    Copyright:
        Copyright (c) 2000, 2001 Megan Potter
        Copyright (c) 2023 Falco Girgis
        Copyright (c) 2024 Paul Cercueil

    Authors:
        Megan Potter
        Falco Girgis
*/
module dreamcast.timer;

extern(C):
nothrow:
@nogc:

enum TMU0 = 0;
enum TMU1 = 1;
enum TMU2 = 2;

alias timer_primary_callback_t = void function(void*);

int timer_prime(int channel, uint speed, int interrupts);
int timer_start(int channel);
int timer_stop(int channel);
int timer_running(int channel);
uint timer_count(int channel);
int timer_clear(int channel);
void timer_enable_ints(int channel);
void timer_disable_ints(int channel);
int timer_ints_enabled(int channel);
void timer_ms_enable();
void timer_ms_disable();
void timer_ms_gettime(uint *secs, uint *msecs);
ulong timer_ms_gettime64();
void timer_us_gettime(uint *secs, uint *usecs);
ulong timer_us_gettime64();
void timer_ns_gettime(uint *secs, uint *nsecs);
ulong timer_ns_gettime64();
void timer_spin_sleep(int ms);
void timer_spin_delay_us(ushort us);
void timer_spin_delay_ns(ushort ns);
timer_primary_callback_t timer_primary_set_callback(timer_primary_callback_t callback);
void timer_primary_wakeup(uint millis);
int timer_init();
void timer_shutdown();
