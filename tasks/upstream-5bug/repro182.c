unsigned char a[100];
void g(void) {
   unsigned short i;
   for (i = 0; i < 100; ++i) a[i] = 0;
   for (i = 0; i < 100; ++i) ++a[i];
}
