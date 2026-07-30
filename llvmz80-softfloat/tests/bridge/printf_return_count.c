/* ravn/z88dk#31 regression: printf/fprintf return the count they emitted.
 *
 * Complements z88dk31_variadic_return.c (which covers sprintf/sscanf/snprintf).
 * These go through _printf/_fprintf, which read their varargs at a different
 * stack offset than _sprintf -- so they exercise a second worker shape.  All
 * return the 16-bit count in HL; after the fix (variadic decls == sdcccall(0))
 * llvmz80 reads HL and converges with the ez80-clang reference.
 *
 * printf("hello %d\n", 5) emits "hello 5\n" = 8 chars -> returns 8.
 * fprintf(stdout, "%d", 12345) emits "12345" -> returns 5.
 * The oracle diffs the whole stdout, so the emitted text and the printed
 * counts are both checked.
 */
#include <stdio.h>

int main(void) {
    int a = printf("hello %d\n", 5);       /* emits "hello 5\n", returns 8 */
    int b = fprintf(stdout, "%d", 12345);  /* emits "12345",    returns 5 */
    printf("|a=%d b=%d\n", a, b);
    return 0;
}
