/* fmt64.c -- nanoprintf implementation TU for the Phase 4 IEEE double
 * formatter.  This is the single translation unit that pulls in the nanoprintf
 * implementation; all other TUs include npf_cpm.h for declarations only. */
#define NANOPRINTF_IMPLEMENTATION
#include "npf_cpm.h"

/* --------------------------------------------------------------------------
 * npf_snprintf_f: a FIXED-ARGUMENT %f formatter.
 *
 * Why this exists: clang-z80 has a broken va_start (ravn/llvm-z80#270) that
 * makes every C-level variadic function read garbage, so nanoprintf's normal
 * variadic npf_snprintf yields "0.000000" for every value on Z80.  This entry
 * takes the double as a normal fixed parameter, so it sidesteps varargs
 * entirely while still exercising the exact conversion code we want to validate
 * on Z80 (nanoprintf's npf_parse_format_spec + npf_ftoa_rev).  It reimplements
 * only the small sign/pad/reverse output-assembly loop from npf_vpprintf, for
 * the %f subset (no %e/%g/%a, no '*' width/prec, no length modifiers).
 *
 * REMOVE and switch ft_fmt back to npf_snprintf once #270 is fixed.
 *
 * `fmt` must point at a single "%[-+ 0][width][.prec]f" spec.  Output is
 * NUL-terminated; return value is the length that would have been written.
 * -------------------------------------------------------------------------- */
int npf_snprintf_f(char *out, size_t sz, const char *fmt, double v) {
  npf_format_spec_t fs;
  int const fs_len = (*fmt == '%') ? npf_parse_format_spec(fmt, &fs) : 0;
  size_t oi = 0;
#define NPFF_PUT(c) do { if (oi + 1 < sz) out[oi] = (char)(c); ++oi; } while (0)

  if (!fs_len) {                       /* not a spec: copy literally */
    for (const char *p = fmt; *p; ++p) NPFF_PUT(*p);
    if (sz) out[(oi < sz) ? oi : sz - 1] = '\0';
    return (int)oi;
  }

  /* Default precision for %f is 6 -- npf_parse_format_spec leaves prec_opt=NONE;
   * npf_vpprintf applies the default, so we must too. */
  if (fs.prec_opt == NPF_FMT_SPEC_OPT_NONE) fs.prec = 6;

  char cbuf[NANOPRINTF_CONVERSION_BUFFER_SIZE];
  int cbuf_len = npf_ftoa_rev(cbuf, &fs, v);     /* reversed magnitude digits */

  /* Sign + all-zero test come from the raw IEEE bits (mirrors npf_vpprintf). */
  char sign_c;
  int zero;
  { npf_real_bin_t const b = npf_real_to_int_rep(v);
    sign_c = (b >> NPF_REAL_SIGN_POS) ? '-' : fs.prepend;
    zero = !(b & ~((npf_real_bin_t)1 << NPF_REAL_SIGN_POS)); }

  if (cbuf_len < 0) {                   /* special value ("inf"/"nan" text) */
    cbuf_len = -cbuf_len;
    fs.leading_zero_pad = 0;
  }

  char pad_c = 0;
  if (fs.field_width_opt != NPF_FMT_SPEC_OPT_NONE) {
    if (fs.leading_zero_pad && !fs.left_justified) {
      /* '0' flag with an explicit zero precision on a zero value -> spaces. */
      if ((fs.prec_opt != NPF_FMT_SPEC_OPT_NONE) && !fs.prec && zero) pad_c = ' ';
      else pad_c = '0';
    } else pad_c = ' ';
  }

  int field_pad = fs.field_width - cbuf_len - (sign_c ? 1 : 0);
  if (field_pad < 0) field_pad = 0;

  if (!fs.left_justified && pad_c) {    /* right-justified padding */
    if (pad_c == '0' && sign_c) { NPFF_PUT(sign_c); sign_c = 0; }
    while (field_pad-- > 0) NPFF_PUT(pad_c);
  }

  if (sign_c) NPFF_PUT(sign_c);
  while (cbuf_len-- > 0) NPFF_PUT(cbuf[cbuf_len]);   /* payload is reversed */

  if (fs.left_justified && pad_c)       /* left-justified padding */
    while (field_pad-- > 0) NPFF_PUT(pad_c);

  if (sz) out[(oi < sz) ? oi : sz - 1] = '\0';
  return (int)oi;
#undef NPFF_PUT
}
