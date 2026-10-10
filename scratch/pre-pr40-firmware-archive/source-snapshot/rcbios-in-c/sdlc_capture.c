/*
 * sdlc_capture.c — tight-loop bit-bang capture from FT2232D.
 *
 * Uses libftdi1's async stream API (ftdi_readstream) for highest
 * throughput — multiple outstanding libusb transfers, no gaps
 * between them, no per-chunk Python/ctypes overhead.  Dumps raw
 * samples to a file.
 *
 * Built without libftdi1-dev headers: we declare the handful of
 * ABI entry points ourselves.  Links at runtime against the
 * distro's libftdi1.so.2.
 *
 * Build:  cc -O2 -Wall -o sdlc_capture sdlc_capture.c -lftdi1
 *
 * Usage:  sdlc_capture [-i A|B] [-s SAMPLE_HZ] [-t SECONDS] OUT.bin
 *   -i A|B        FTDI interface (default A)
 *   -s SAMPLE_HZ  desired bit-bang sample rate (default 1_000_000)
 *   -t SECONDS    capture duration (default 3.0)
 */

#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

/* --- minimal libftdi1 ABI declarations ------------------------------ */

typedef void *ftdi_ctx_t;

enum { INTERFACE_ANY = 0, INTERFACE_A = 1, INTERFACE_B = 2 };
enum { BITMODE_BITBANG = 0x01, BITMODE_RESET = 0x00 };

extern ftdi_ctx_t ftdi_new(void);
extern void ftdi_free(ftdi_ctx_t);
extern int ftdi_set_interface(ftdi_ctx_t, int);
extern int ftdi_usb_open(ftdi_ctx_t, int vid, int pid);
extern int ftdi_usb_close(ftdi_ctx_t);
extern int ftdi_set_bitmode(ftdi_ctx_t, unsigned char bitmask, unsigned char mode);
extern int ftdi_set_baudrate(ftdi_ctx_t, int baudrate);
extern int ftdi_set_latency_timer(ftdi_ctx_t, unsigned char ms);
extern int ftdi_read_data(ftdi_ctx_t, unsigned char *buf, int size);
extern void ftdi_read_data_set_chunksize(ftdi_ctx_t, unsigned int size);
extern const char *ftdi_get_error_string(ftdi_ctx_t);

/* Async stream callback + API. */
typedef int (*FTDIStreamCallback)(uint8_t *buffer, int length,
                                  void *progress, void *userdata);
extern int ftdi_readstream(ftdi_ctx_t, FTDIStreamCallback,
                           void *userdata, int packetsPerTransfer,
                           int numTransfers);

/* libusb attach (optional, for driver reattach on exit).  Accessing
 * libftdi's usb_dev pointer requires the struct layout; instead we
 * link libusb ourselves and re-find the device.  Simpler: let the
 * user `udevadm trigger` or replug if ttyUSB* doesn't come back —
 * we do a best-effort bitmode reset which is usually enough. */

/* --- helpers -------------------------------------------------------- */

static double now_s(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ts.tv_nsec / 1e9;
}

/* Shared state for the stream callback. */
struct capstate {
    FILE *fp;
    size_t total;
    size_t callbacks;
    size_t biggest;
    double t_start;
    double t_deadline;
};

static int capture_cb(uint8_t *buf, int len, void *progress, void *ud)
{
    struct capstate *s = (struct capstate *)ud;
    (void)progress;
    if (len > 0) {
        s->callbacks++;
        if ((size_t)len > s->biggest) s->biggest = len;
        if (fwrite(buf, 1, len, s->fp) != (size_t)len) {
            perror("fwrite");
            return 1;
        }
        s->total += len;
    }
    if (now_s() >= s->t_deadline) {
        return 1;                 /* non-zero → stop stream */
    }
    return 0;
}

/* --- main ----------------------------------------------------------- */

int main(int argc, char **argv)
{
    int iface = INTERFACE_A;
    int sample_hz = 1000000;
    double secs = 3.0;

    int opt;
    while ((opt = getopt(argc, argv, "i:s:t:")) != -1) {
        switch (opt) {
        case 'i':
            iface = (optarg[0] == 'B' || optarg[0] == 'b') ? INTERFACE_B
                                                           : INTERFACE_A;
            break;
        case 's': sample_hz = atoi(optarg); break;
        case 't': secs = strtod(optarg, NULL); break;
        default:
            fprintf(stderr,
                    "usage: %s [-i A|B] [-s SAMPLE_HZ] [-t SECONDS] OUT.bin\n",
                    argv[0]);
            return 2;
        }
    }
    if (optind >= argc) {
        fprintf(stderr, "missing OUT.bin\n");
        return 2;
    }
    const char *outpath = argv[optind];

    ftdi_ctx_t ftdi = ftdi_new();
    if (!ftdi) { fprintf(stderr, "ftdi_new failed\n"); return 1; }

#define FCHECK(call) do { \
        int _rc = (call); \
        if (_rc < 0) { \
            fprintf(stderr, #call ": %s\n", ftdi_get_error_string(ftdi)); \
            return 1; \
        } \
    } while (0)

    FCHECK(ftdi_set_interface(ftdi, iface));
    FCHECK(ftdi_usb_open(ftdi, 0x0403, 0x6010));
    FCHECK(ftdi_set_bitmode(ftdi, 0x00, BITMODE_BITBANG));
    /* Bit-bang: actual sample rate = baudrate_param × 16 on FT2232C/D. */
    FCHECK(ftdi_set_baudrate(ftdi, sample_hz / 16));
    FCHECK(ftdi_set_latency_timer(ftdi, 1));
    ftdi_read_data_set_chunksize(ftdi, 65536);

    FILE *fp = fopen(outpath, "wb");
    if (!fp) { fprintf(stderr, "fopen %s: %s\n", outpath, strerror(errno)); return 1; }

    struct capstate st = {
        .fp = fp,
        .total = 0,
        .callbacks = 0,
        .biggest = 0,
    };
    st.t_start = now_s();
    st.t_deadline = st.t_start + secs;

    /* FT2232D can't use ftdi_readstream (it's FT2232H+ only — the
     * C/D variant is full-speed USB without the HS async FIFO).
     * Fall back to a tight synchronous read loop.  Because we're
     * in C with no interpreter overhead, each read call returns
     * immediately and we re-issue without any sleep.  Chunk size
     * of 256 KB means one libusb_bulk_transfer per ~256 ms worth
     * of samples at 1 MHz — large enough that bulk-transfer
     * setup overhead is negligible. */
    enum { BUFSZ = 262144 };
    unsigned char *buf = malloc(BUFSZ);
    if (!buf) { fprintf(stderr, "oom\n"); return 1; }

    while (now_s() < st.t_deadline) {
        int n = ftdi_read_data(ftdi, buf, BUFSZ);
        if (n < 0) {
            fprintf(stderr, "read_data: %s\n", ftdi_get_error_string(ftdi));
            break;
        }
        if (n > 0) {
            capture_cb(buf, n, NULL, &st);
        }
    }
    free(buf);

    double elapsed = now_s() - st.t_start;
    fclose(fp);

    double rate = st.total / elapsed;
    fprintf(stderr, "# captured %zu bytes in %.3fs\n", st.total, elapsed);
    fprintf(stderr, "# effective rate: %.0f Hz  (%.1f%% of %d configured)\n",
            rate, 100.0 * rate / sample_hz, sample_hz);
    fprintf(stderr, "# callbacks: %zu  biggest chunk: %zu B\n",
            st.callbacks, st.biggest);

    ftdi_set_bitmode(ftdi, 0x00, BITMODE_RESET);
    ftdi_usb_close(ftdi);
    ftdi_free(ftdi);

    /* Note: /dev/ttyUSB* may disappear after this program exits.  To
     * restore, either run `udevadm trigger` or briefly replug, or
     * run our Python reattach helper. */
    return 0;
}
