#include <string.h>

size_t strlen( const char *s ) { const char *p = s; while( *p ) p++; return (size_t)(p - s); }
char *strcpy( char *d, const char *s ) { char *r = d; while( (*d++ = *s++) != 0 ) ; return r; }
char *strncpy( char *d, const char *s, size_t n ) {
    char *r = d; while( n && (*d = *s) ) { d++; s++; n--; } while( n-- ) *d++ = 0; return r; }
char *strcat( char *d, const char *s ) { char *r = d; while( *d ) d++; while( (*d++ = *s++) != 0 ) ; return r; }
int strcmp( const char *a, const char *b ) {
    while( *a && *a == *b ) { a++; b++; } return (unsigned char)*a - (unsigned char)*b; }
int strncmp( const char *a, const char *b, size_t n ) {
    while( n && *a && *a == *b ) { a++; b++; n--; }
    return n ? (unsigned char)*a - (unsigned char)*b : 0; }
char *strchr( const char *s, int c ) {
    while( *s ) { if( *s == (char)c ) return (char *)s; s++; } return (c == 0) ? (char *)s : 0; }
void *memcpy( void *d, const void *s, size_t n ) {
    char *dp = d; const char *sp = s; while( n-- ) *dp++ = *sp++; return d; }
void *memmove( void *d, const void *s, size_t n ) {
    char *dp = d; const char *sp = s;
    if( dp < sp ) while( n-- ) *dp++ = *sp++;
    else { dp += n; sp += n; while( n-- ) *--dp = *--sp; }
    return d; }
void *memset( void *d, int c, size_t n ) { char *dp = d; while( n-- ) *dp++ = (char)c; return d; }
int memcmp( const void *a, const void *b, size_t n ) {
    const unsigned char *pa = a, *pb = b;
    while( n-- ) { if( *pa != *pb ) return *pa - *pb; pa++; pb++; } return 0; }
