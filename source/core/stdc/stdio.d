/**
 * D header file for C99 <stdio.h>
 *
 * $(C_HEADER_DESCRIPTION pubs.opengroup.org/onlinepubs/009695399/basedefs/_stdio.h.html, _stdio.h)
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License: Distributed under the
 *      $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0).
 *    (See accompanying file LICENSE)
 * Authors:   Sean Kelly,
 *            Alex Rønne Petersen
 * Source:    https://github.com/dlang/druntime/blob/master/src/core/stdc/stdio.d
 * Standards: ISO/IEC 9899:1999 (E)
 */
module core.stdc.stdio;

import core.stdc.config;
import core.stdc.stdarg; // for va_list
import core.stdc.stdint : intptr_t;
import core.stdc.wchar_ : mbstate_t;

extern (C):
@system:
nothrow:
@nogc:

enum
{
    ///
    BUFSIZ       = 8192,
    ///
    EOF          = -1,
    ///
    FOPEN_MAX    = 16,
    ///
    FILENAME_MAX = 4095,
    ///
    TMP_MAX      = 238328,
    ///
    L_tmpnam     = 20
}

enum
{
    /// Offset is relative to the beginning
    SEEK_SET,
    /// Offset is relative to the current position
    SEEK_CUR,
    /// Offset is relative to the end
    SEEK_END
}

///
struct fpos_t
{
    long __pos; // couldn't use off_t because of static if issue
    mbstate_t __state;
}

///
struct _IO_FILE
{
    int     _flags;
    char*   _read_ptr;
    char*   _read_end;
    char*   _read_base;
    char*   _write_base;
    char*   _write_ptr;
    char*   _write_end;
    char*   _buf_base;
    char*   _buf_end;
    char*   _save_base;
    char*   _backup_base;
    char*   _save_end;
    void*   _markers;
    _IO_FILE* _chain;
    int     _fileno;
    int     _flags2;
    ptrdiff_t _old_offset;
    ushort  _cur_column;
    byte    _vtable_offset;
    char[1] _shortbuf = 0;
    void*   _lock;

    ptrdiff_t _offset;

    /*_IO_codecvt*/ void* _codecvt;
    /*_IO_wide_data*/ void* _wide_data;
    _IO_FILE *_freeres_list;
    void *_freeres_buf;
    size_t __pad5;
    int _mode;

    char[15 * int.sizeof - 4 * (void*).sizeof - size_t.sizeof] _unused2;
}

///
alias _iobuf = _IO_FILE;
///
alias FILE = shared(_IO_FILE);


enum
{
    ///
    _F_RDWR = 0x0003, // non-standard
    ///
    _F_READ = 0x0001, // non-standard
    ///
    _F_WRIT = 0x0002, // non-standard
    ///
    _F_BUF  = 0x0004, // non-standard
    ///
    _F_LBUF = 0x0008, // non-standard
    ///
    _F_ERR  = 0x0010, // non-standard
    ///
    _F_EOF  = 0x0020, // non-standard
    ///
    _F_BIN  = 0x0040, // non-standard
    ///
    _F_IN   = 0x0080, // non-standard
    ///
    _F_OUT  = 0x0100, // non-standard
    ///
    _F_TERM = 0x0200, // non-standard
}

enum
{
    ///
    _IOFBF = 0,
    ///
    _IOLBF = 1,
    ///
    _IONBF = 2,
}

///
extern shared FILE* stdin;
///
extern shared FILE* stdout;
///
extern shared FILE* stderr;

///
int remove(scope const char* filename);
///
int rename(scope const char* from, scope const char* to);

///
@trusted FILE* tmpfile(); // No unsafe pointer manipulation.
///
char* tmpnam(char* s);

///
int   fclose(FILE* stream);

// No unsafe pointer manipulation.
@trusted
{
    ///
    int   fflush(FILE* stream);
}

///
FILE* fopen(scope const char* filename, scope const char* mode);
///
FILE* freopen(scope const char* filename, scope const char* mode, FILE* stream);

///
void setbuf(FILE* stream, char* buf);
///
int  setvbuf(FILE* stream, char* buf, int mode, size_t size);


///
pragma(printf)
int fprintf(FILE* stream, scope const char* format, scope const ...);

///
pragma(scanf)
int fscanf(FILE* stream, scope const char* format, scope ...);

///
pragma(printf)
int sprintf(scope char* s, scope const char* format, scope const ...);

///
pragma(scanf)
int sscanf(scope const char* s, scope const char* format, scope ...);

///
pragma(printf)
int vfprintf(FILE* stream, scope const char* format, va_list arg);

///
pragma(scanf)
int vfscanf(FILE* stream, scope const char* format, va_list arg);

///
pragma(printf)
int vsprintf(scope char* s, scope const char* format, va_list arg);

///
pragma(scanf)
int vsscanf(scope const char* s, scope const char* format, va_list arg);

///
pragma(printf)
int vprintf(scope const char* format, va_list arg);

///
pragma(scanf)
int vscanf(scope const char* format, va_list arg);

///
pragma(printf)
int printf(scope const char* format, scope const ...);

///
pragma(scanf)
int scanf(scope const char* format, scope ...);


// No unsafe pointer manipulation.
@trusted
{
    ///
    int fgetc(FILE* stream);
    ///
    int fputc(int c, FILE* stream);
}

///
char* fgets(char* s, int n, FILE* stream);
///
int   fputs(scope const char* s, FILE* stream);
///
char* gets(char* s);
///
int   puts(scope const char* s);

// No unsafe pointer manipulation.
extern (D) @trusted
{
    ///
    int getchar()()                 { return getc(stdin);     }
    ///
    int putchar()(int c)            { return putc(c,stdout);  }
}

///
alias getc = fgetc;
///
alias putc = fputc;

///
@trusted int ungetc(int c, FILE* stream); // No unsafe pointer manipulation.

///
size_t fread(scope void* ptr, size_t size, size_t nmemb, FILE* stream);
///
size_t fwrite(scope const void* ptr, size_t size, size_t nmemb, FILE* stream);

// No unsafe pointer manipulation.
@trusted
{
    ///
    int fgetpos(FILE* stream, scope fpos_t * pos);
    ///
    int fsetpos(FILE* stream, scope const fpos_t* pos);

    ///
    int    fseek(FILE* stream, long offset, int whence);
    ///
    long ftell(FILE* stream);
}

///
pragma(printf)
int _snprintf(scope char* s, size_t n, scope const char* format, scope const ...);
///
pragma(printf)
int  snprintf(scope char* s, size_t n, scope const char* format, scope const ...);

///
pragma(printf)
int _vsnprintf(scope char* s, size_t n, scope const char* format, va_list arg);
///
pragma(printf)
int  vsnprintf(scope char* s, size_t n, scope const char* format, va_list arg);
  