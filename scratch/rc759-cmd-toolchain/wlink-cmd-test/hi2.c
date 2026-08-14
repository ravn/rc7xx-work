char msg[] = "HELLO FROM A WLINK-BUILT CMD\r\n$";
void putstr( char *s );
#pragma aux putstr = \
    "mov cl,9"   \
    "int 0E0h"   \
    parm [dx] modify [cl];
int main( void ) { putstr( msg ); return 0; }
