/** \file   arch/types.h
    \brief  Common integer types.
 
    This file contains typedefs for some common/useful integer types. These
    types include ones that tell you exactly how long they are, as well as some
    BSD-isms.
 
    \author Megan Potter
    \author Luna the Foxgirl
*/
module dreamcast.arch.types;

// NOTE: DLang defines these well.
/* Generic types */
// alias unsigned long long uint64;  /**< \brief 64-bit unsigned integer */
// alias unsigned long uint32;       /**< \brief 32-bit unsigned integer */
// alias unsigned short uint16;      /**< \brief 16-bit unsigned integer */
// alias unsigned char uint8;        /**< \brief 8-bit unsigned integer */
// alias long long int64;            /**< \brief 64-bit signed integer */
// alias long int32;                 /**< \brief 32-bit signed integer */
// alias short int16;                /**< \brief 16-bit signed integer */
// alias char int8;                  /**< \brief 8-bit signed integer */
 
// NOTE: D doesn't have the concept of volatile types.
/* Volatile types */
// alias volatile uint64 vuint64;    /**< \brief 64-bit volatile unsigned type */
// alias volatile uint32 vuint32;    /**< \brief 32-bit volatile unsigned type */
// alias volatile uint16 vuint16;    /**< \brief 16-bit volatile unsigned type */
// alias volatile uint8 vuint8;      /**< \brief 8-bit volatile unsigned type */
// alias volatile int64 vint64;      /**< \brief 64-bit volatile signed type */
// alias volatile int32 vint32;      /**< \brief 32-bit volatile signed type */
// alias volatile int16 vint16;      /**< \brief 16-bit volatile signed type */
// alias volatile int8 vint8;        /**< \brief 8-bit volatile signed type */
 
/* Pointer arithmetic types */
alias ptr_t = uint;               /**< \brief Pointer arithmetic type */