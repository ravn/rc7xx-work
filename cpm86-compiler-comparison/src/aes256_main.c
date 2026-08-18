/* aes256_main.c -- runnable driver for the AES-256 kernel.
 *
 * aes256.c is a bare code-size kernel with no main(), so it cannot link into a
 * runnable .CMD on its own. This driver supplies main(), runs one known-answer
 * encrypt, and prints the first ciphertext byte as a verification marker. The
 * aes256_context layout is duplicated here (it must match aes256.c). Kept in the
 * K&R/C89 common subset so it builds under all four compilers.
 */
#include <stdio.h>

typedef unsigned char uint8_t;
typedef struct {
    uint8_t key[32];
    uint8_t enckey[32];
    uint8_t deckey[32];
} aes256_context;

extern void aes256_init();
extern void aes256_encrypt_ecb();

int main()
{
    aes256_context ctx;
    uint8_t key[32], buf[16];
    int i;

    for (i = 0; i < 32; i++) key[i] = i;
    for (i = 0; i < 16; i++) buf[i] = i * 16 + i;
    aes256_init(&ctx, key);
    aes256_encrypt_ecb(&ctx, buf);
    printf("aes256 ct[0]=%d\n", buf[0]);
    return 0;
}
