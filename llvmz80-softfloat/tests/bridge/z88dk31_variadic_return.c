/* ravn/z88dk#31 differential repro: variadic stdio return value.
 *
 * The classic clib's printf/scanf family return their count in HL (the
 * sccz80/sdcc convention).  A clang backend that returns 16-bit ints in
 * HL (ez80-clang, __stdc) reads the count correctly; one that returns in
 * DE (llvmz80, sdcccall(1)) reads garbage, because the variadic decls are
 * NOT __ZPROTO-bridged (no `ex de,hl`).  Formatting/parsing themselves are
 * correct on both — only the RETURNED count differs.
 *
 * The differential oracle (diff_ez80clang_llvmz80.sh) compiles this with
 * both backends and diffs stdout; ez80-clang is the known-good reference.
 * Expected today: ez80-clang prints the exp values, llvmz80 prints garbage.
 * When llvmz80's variadic-return path is fixed, the two outputs match.
 */
#include <stdio.h>

int main(void) {
    char b[40];
    int  a, c;
    char w[16];

    int n_sprintf  = sprintf(b, "%d-%d", 3, 4);              /* exp 3 */
    int n_sscanf   = sscanf("12 34 word", "%d %d %s", &a, &c, w); /* exp 3 */
    int n_snprintf = snprintf(b, sizeof b, "%d", 12345);     /* exp 5 */

    printf("sprintf=%d sscanf=%d snprintf=%d\n",
           n_sprintf, n_sscanf, n_snprintf);
    return 0;
}
