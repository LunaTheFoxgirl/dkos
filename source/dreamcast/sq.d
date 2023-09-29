/** \file   dc/sq.h
    \brief  Functions to access the SH4 Store Queues.
 
    The store queues are a way to do efficient burst transfers from the CPU to
    external memory. They can be used in a variety of ways, such as to transfer
    a texture to PVR memory. The transfers are in units of 32-bytes, and the
    destinations must be 32-byte aligned.
 
    \author Andrew Kieschnick
    \author Luna the Foxgirl
*/
module dreamcast.sq;
import core.volatile;

extern(C):
nothrow:
@nogc:



/** \brief  Store Queue 0 access register */
// enum uint* QACR0 = cast(uint*)0xff000038;

/** \brief  Store Queue 1 access register */
// enum uint* QACR1 = cast(uint*)0xff00003c;

enum QACR0 = VolatileRef!(uint, cast(uint*)0xff000038)();
enum QACR1 = VolatileRef!(uint, cast(uint*)0xff00003c)();

 
/** \brief  Clear a block of memory.
 
    This function is similar to calling memset() with a value to set of 0, but
    uses the store queues to do its work.
 
    \param  dest            The address to begin clearing at (32-byte aligned).
    \param  n               The number of bytes to clear (multiple of 32).
*/
void sq_clr(void* dest, int n);
 
/** \brief  Copy a block of memory.
 
    This function is similar to memcpy4(), but uses the store queues to do its
    work.
 
    \param  dest            The address to copy to (32-byte aligned).
    \param  src             The address to copy from (32-bit (4-byte) aligned).
    \param  n               The number of bytes to copy (multiple of 32).
    \return                 The original value of dest.
*/
void* sq_cpy(void* dest, const(void)* src, int n);
 
/** \brief  Set a block of memory to an 8-bit value.
 
    This function is similar to calling memset(), but uses the store queues to
    do its work.
 
    \param  s               The address to begin setting at (32-byte aligned).
    \param  c               The value to set (in the low 8-bits).
    \param  n               The number of bytes to set (multiple of 32).
    \return                 The original value of dest.
*/
void* sq_set(void* s, uint c, int n);
 
/** \brief  Set a block of memory to a 16-bit value.
 
    This function is similar to calling memset2(), but uses the store queues to
    do its work.
 
    \param  s               The address to begin setting at (32-byte aligned).
    \param  c               The value to set (in the low 16-bits).
    \param  n               The number of bytes to set (multiple of 32).
    \return                 The original value of dest.
*/
void* sq_set16(void* s, uint c, int n);
 
/** \brief  Set a block of memory to a 32-bit value.
 
    This function is similar to calling memset4(), but uses the store queues to
    do its work.
 
    \param  s               The address to begin setting at (32-byte aligned).
    \param  c               The value to set (all 32-bits).
    \param  n               The number of bytes to set (multiple of 32).
    \return                 The original value of dest.
*/
void* sq_set32(void* s, uint c, int n);