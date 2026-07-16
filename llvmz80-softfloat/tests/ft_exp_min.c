/* ft_exp_min.c -- verify musl exp() on Z80 with putchar-only output (no printf)
 * to fit under the 64 KB TPA alongside the f64 closure (pulled from mathf64.lib).
 * Expected (native double, x1e4, truncated):  27182 16487
 *   exp(1.0)*1e4 = 27182.818 ; exp(0.5)*1e4 = 16487.212 */
#include <stdio.h>
double exp(double);
volatile double one = 1.0, half = 0.5;
static void putl(long v){ unsigned long u; char b[12]; int i=0;
  if(v<0){putchar('-');u=(unsigned long)(-v);}else u=(unsigned long)v;
  if(!u){putchar('0');return;} while(u){b[i++]='0'+(int)(u%10);u/=10;} while(i)putchar(b[--i]); }
int main(void){
  putl((long)(exp(one)*10000.0));  putchar(' ');
  putl((long)(exp(half)*10000.0)); putchar('\n');
  return 0;
}
