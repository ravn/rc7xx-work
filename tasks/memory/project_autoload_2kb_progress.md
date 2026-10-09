---
name: project_autoload_2kb_progress
description: autoload-in-c PROM 2KB recovery work — progress log, current size, what's left
metadata:
  type: project
---

## Status (2026-10-09)

PROM: **2216 B / 2048 B cap** — 168 B over. Was 2444 B at start of 2026-10-09 session.

Active branch: `autoload-2kb-recovery-20261009` in llvm-z80 repo.
Merges: `fix-indexiv-unit-stride` + `no-recurse-attr` + shadow-isr.

**Why:** Hard 2 KB cap (no A11 address bridge on user's RC702 hardware).

## Savings achieved (this session)

| Change | PROM delta |
|---|---|
| Z80IndexIV unit-stride skip (compiler) | −168 B |
| Shadow ISR `+shadow-isr` feature (compiler) | −17 B |
| `check_sysfile` const char* → const byte* (source) | −43 B |
| **Total** | **−228 B** |

## Remaining gap: 168 B

Known sources of regression vs c863c55:

1. **CP (HL) optimization missing** (issue #401): `fdc_select_drive_cylinder_head`,
   `check_fdc_result`, `fdc_read_data_from_current_location`, `verify_seek_result` all
   grew 18–47 B each because the compiler doesn't generate `CP (HL)`. c863c55 used it
   in 4 places. Estimated savings if fixed: ~40–60 B PROM.

2. **Static frames for IX-frame functions**: 10 functions still use dynamic IX frames.
   Blocked by `fdc_read_when_ready` being shared between ISR and boot contexts —
   Z80NonReentrant correctly marks related functions as reentrant. Estimated if fixed:
   ~50 B PROM.

3. **`refresh_crt_dma_50hz_body` not inlined**: ISR body function has `always_inline`
   but generates a separate call. Minor (3 B overhead).

## Architecture insight

The `+shadow-isr` feature (see [[reference_shadow_isr_feature]]) is needed in
autoload's Makefile because main code never uses EXX. rcbios/cpnos Makefiles do NOT
get this flag.

## Key comparison: c863c55 baseline

c863c55 compiler commit (llvm-z80 repo) produced autoload at 2034 B with no static
frames (`+static-frame` was silently ignored). Current with full static frame support
but CP(HL) missing is 2216 B.

The 182 B gap (2216 vs 2034) is mostly:
- New features added since c863c55: display_banner (+64), display_sw1 (+57),
  banner_string (+47) = 168 B intentional growth
- CP(HL) regression: ~90 B raw across multiple FDC functions
