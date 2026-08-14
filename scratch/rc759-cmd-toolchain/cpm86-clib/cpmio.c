#include "cpmsys.h"
void _conout( char c )
{
    if( c == '\n' )
        (void)_bdos( _BDOS_CONOUT, '\r' );
    (void)_bdos( _BDOS_CONOUT, (unsigned char)c );
}
