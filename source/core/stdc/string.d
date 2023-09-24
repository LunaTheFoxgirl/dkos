module core.stdc.string;


extern (C):
@system:
nothrow:
@nogc:

///
inout(void)* memchr(return scope inout void* s, int c, size_t n) pure;

///
int   memcmp(scope const void* s1, scope const void* s2, size_t n) pure;

///
void* memcpy(return scope void* s1, scope const void* s2, size_t n) pure;

///
void* memmove(return scope void* s1, scope const void* s2, size_t n) pure;

///
void* memset(return scope void* s, int c, size_t n) pure;

///
char*  strcat(return scope char* s1, scope const char* s2) pure;

///
inout(char)*  strchr(return scope inout(char)* s, int c) pure;

///
int    strcmp(scope const char* s1, scope const char* s2) pure;

///
int    strcoll(scope const char* s1, scope const char* s2);

///
char*  strcpy(return scope char* s1, scope const char* s2) pure;

///
size_t strcspn(scope const char* s1, scope const char* s2) pure;

///
char*  strdup(scope const char *s);

///
char*  strerror(int errnum);

int strerror_r(int errnum, scope char* buf, size_t buflen);

///
size_t strlen(scope const char* s) pure;

///
char*  strncat(return scope char* s1, scope const char* s2, size_t n) pure;

///
int    strncmp(scope const char* s1, scope const char* s2, size_t n) pure;

///
char*  strncpy(return scope char* s1, scope const char* s2, size_t n) pure;

///
inout(char)*  strpbrk(return scope inout(char)* s1, scope const char* s2) pure;

///
inout(char)*  strrchr(return scope inout(char)* s, int c) pure;

///
size_t strspn(scope const char* s1, scope const char* s2) pure;

///
inout(char)*  strstr(return scope inout(char)* s1, scope const char* s2) pure;

///
char*  strtok(return scope char* s1, scope const char* s2);

///
size_t strxfrm(scope char* s1, scope const char* s2, size_t n);
