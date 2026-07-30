/* Converging control for the differential oracle.
 *
 * Non-variadic classic-clib calls returning a 16-bit int (strlen/atoi) ARE
 * __ZPROTO-bridged (their clang decls end `ex de,hl`), so both ez80-clang and
 * llvmz80 read the return correctly.  This case MUST converge; it guards
 * against the oracle going falsely red on everything and proves llvmz80's
 * bridged 16-bit-return paths are sound.
 *
 * NOTE: 32-bit `long` returns (e.g. strtol) are deliberately excluded -- the
 * two backends disagree there too (ez80-clang mis-returns), so a `long`-return
 * case is NOT a clean control: ez80-clang is only a trustworthy reference for
 * 16-bit int returns.
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(void) {
    const char *s = "hello";
    int len = strlen(s);      /* 5    */
    int v   = atoi("4200");   /* 4200 */

    printf("len=%d atoi=%d\n", len, v);
    return 0;
}
