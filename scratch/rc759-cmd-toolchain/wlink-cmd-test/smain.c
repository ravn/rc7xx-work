char msg[] = "SMALL-MODEL C ON RC759 VIA WLINK format cpm86\r\n$";
void putstr( char *s );
#pragma aux putstr = "mov cl,9" "int 0E0h" parm [dx] modify [cl];
void mame_done( unsigned w );
#pragma aux mame_done = "mov dx,02FEh" "out dx,ax" parm [ax] modify [dx];
int main( void ) { putstr( msg ); mame_done( 0x5A11 ); return 0; }
