/* ft_atan_min.c -- verify musl atan() on Z80 with putchar-only output
 * (no printf) to fit under the 64768 B TPA ceiling alongside the f64 closure.
 * Expected (native double): 7853 4636
 *   atan(1.0)*1e4=7853.982 ; atan(0.5)*1e4=4636.476 */
#include <stdio.h>
double atan(double);
volatile double one = 1.0, half = 0.5;
static void putl(long v){ unsigned long u; char b[12]; int i=0;
  if(v<0){putchar('-');u=(unsigned long)(-v);}else u=(unsigned long)v;
  if(!u){putchar('0');return;} while(u){b[i++]='0'+(int)(u%10);u/=10;} while(i)putchar(b[--i]); }
int main(void){
  putl((long)(atan(one)*10000.0)); putchar(' ');
  putl((long)(atan(half)*10000.0)); putchar('\n');
  return 0;
}
