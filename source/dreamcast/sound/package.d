/** KallistiOS ##version##

   aica_comm.h
   Copyright (C) 2000-2002 Megan Potter

   Structure and constant definitions for the SH-4/AICA interface. This file is
   included from both the ARM and SH-4 sides of the fence.
*/
module dreamcast.sound;

public import dreamcast.sound.sfxmgr;
public import dreamcast.sound.sound;
public import dreamcast.sound.stream;

extern(C):
nothrow:
@nogc:

/* Command queue; one of these for passing data from the SH-4 to the
   AICA, and another for the other direction. If a command is written
   to the queue and it is longer than the amount of space between the
   head point and the queue size, the command will wrap around to
   the beginning (i.e., queue commands _can_ be split up). */
struct aica_queue_t {
    uint      head;       /* Insertion point offset (in bytes) */
    uint      tail;       /* Removal point offset (in bytes) */
    uint      size;       /* Queue size (in bytes) */
    uint      valid;      /* 1 if the queue structs are valid */
    uint      process_ok; /* 1 if it's ok to process the data */
    uint      data;       /* Pointer to queue data buffer */
}

/* Command queue struct for commanding the AICA from the SH-4 */
struct aica_cmd_t {
    uint      size;         /* Command data size in dwords */
    uint      cmd;          /* Command ID */
    uint      timestamp;    /* When to execute the command (0 == now) */
    uint      cmd_id;       /* Command ID, for cmd/response pairs, or channel id */
    uint[4]   misc;         /* Misc Parameters / Padding */
    ubyte*    cmd_data;     /* Command data */
}

/* Maximum command size -- 256 dwords */
enum AICA_CMD_MAX_SIZE = 256;

/* This is the cmd_data for AICA_CMD_CHAN. Make this 16 dwords long
   for two aica bus queues. */
struct aica_channel_t {
    uint      cmd;        /* Command ID */
    uint      base;       /* Sample base in RAM */
    uint      type;       /* (8/16bit/ADPCM) */
    uint      length;     /* Sample length */
    uint      loop;       /* Sample looping */
    uint      loopstart;  /* Sample loop start */
    uint      loopend;    /* Sample loop end */
    uint      freq;       /* Frequency */
    uint      vol;        /* Volume 0-255 */
    uint      pan;        /* Pan 0-255 */
    uint      pos;        /* Sample playback pos */
    uint[5]   pad;        /* Padding */
}

// TOD: Expose AICA_CMDSTR_CHANNEL?
/* Declare an aica_cmd_t big enough to hold an aica_channel_t
   using temp name T, aica_cmd_t name CMDR, and aica_channel_t name CHANR */
// #define AICA_CMDSTR_CHANNEL(T, CMDR, CHANR) \
//     ubyte   T[sizeof(aica_cmd_t) + sizeof(aica_channel_t)]; \
//     aica_cmd_t  * CMDR = (aica_cmd_t *)T; \
//     aica_channel_t  * CHANR = (aica_channel_t *)(CMDR->cmd_data);

enum AICA_CMDSTR_CHANNEL_SIZE   = (aica_cmd_t.sizeof+aica_channel_t.sizeof)/4;

/* Command values (for aica_cmd_t) */
enum AICA_CMD_NONE              = 0x00000000;  /* No command (dummy packet)    */
enum AICA_CMD_PING              = 0x00000001;  /* Check for signs of life  */
enum AICA_CMD_CHAN              = 0x00000002;  /* Perform a wavetable action   */
enum AICA_CMD_SYNC_CLOCK        = 0x00000003;  /* Reset the millisecond clock  */

/* Response values (for aica_cmd_t) */
enum AICA_RESP_NONE             = 0x00000000;
enum AICA_RESP_PONG             = 0x00000001;  /* Response to CMD_PING             */
enum AICA_RESP_DBGPRINT         = 0x00000002;  /* Entire payload is a null-terminated string   */

/* Command values (for aica_channel_t commands) */
enum AICA_CH_CMD_MASK           = 0x0000000f;

enum AICA_CH_CMD_NONE           = 0x00000000;
enum AICA_CH_CMD_START          = 0x00000001;
enum AICA_CH_CMD_STOP           = 0x00000002;
enum AICA_CH_CMD_UPDATE         = 0x00000003;

/* Start values */
enum AICA_CH_START_MASK         = 0x00300000;

enum AICA_CH_START_DELAY        = 0x00100000; /* Set params, but delay key-on */
enum AICA_CH_START_SYNC         = 0x00200000; /* Set key-on for all selected channels */

/* Update values */
enum AICA_CH_UPDATE_MASK        = 0x000ff000;

enum AICA_CH_UPDATE_SET_FREQ    = 0x00001000; /* frequency     */
enum AICA_CH_UPDATE_SET_VOL     = 0x00002000; /* volume        */
enum AICA_CH_UPDATE_SET_PAN     = 0x00004000; /* panning       */

/* Sample types */
enum AICA_SM_8BIT               = 1;
enum AICA_SM_16BIT              = 0;
enum AICA_SM_ADPCM              = 2;