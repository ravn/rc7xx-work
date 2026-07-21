/* fmt64.c -- nanoprintf implementation TU for the Phase 4 IEEE double
 * formatter.  This is the single translation unit that pulls in the nanoprintf
 * implementation; all other TUs include npf_cpm.h for declarations only.
 *
 * The variadic npf_snprintf() is now the primary interface.  The previous
 * npf_snprintf_f() non-variadic shim (workaround for ravn/llvm-z80#270) has
 * been removed: va_start/va_arg work correctly since z88dk bb914a18 deferred
 * to __builtin_va_start under __LLVMZ80 (2026-07-21). */
#define NANOPRINTF_IMPLEMENTATION
#include "npf_cpm.h"
