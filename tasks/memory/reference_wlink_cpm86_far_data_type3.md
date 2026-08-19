# wlink `format cpm86`: program far data goes in ONE type-3 EXTRA group

FIXED 2026-08-19 (open-watcom-v2 `bld/wl/c/loadcpm86.c`, local commit
`09c2eb3099`). Verified on the Unicorn oracle + Stage B regression suite.

## The bug

The `format cpm86` .CMD writer classified EVERY non-code group as type-2 DATA
and encoded fixup nibbles as a code(1)/data(2) binary. CP/M-86 keys groups by
TYPE (at most one of each type; the loader + base-page descriptor slots resolve
a fixup nibble by type). So a program's initialised **far data** became a SECOND
type-2 group — unplaceable, and its P_LOAD fixups collided with DGROUP. This
capped the near DGROUP at 64 KB and blocked the compact model and INFO-Zip
UnZip's DEFLATE path.

## The fix (3 group buckets, like a real loader)

- all `CLASS_CODE` groups  -> ONE type-1 CODE  (coalesced; unchanged)
- the DGROUP auto group     -> ONE type-2 DATA  (near DS/SS data)
- every other non-code group-> ONE type-3 EXTRA (far data, coalesced)

Key correctness points (each was a wrong turn first):

1. **Identify DGROUP via the linker's `DataGroup` pointer, NOT by Groups-list
   position.** `OrderGroups(CompareDosSegments)` can list a `FAR_DATA`/AUTO
   group AHEAD of DGROUP, so "first non-code group == DGROUP" is FALSE — a
   position-based guess put far data in type-2 and DGROUP in type-3, exactly
   inverted (seen in both the repro and UnZip: DGROUP was at frame 3, far data
   at frame 2). `cpm86GroupCmdType()`: code->1; `target==DataGroup`->2; else 3.

2. **On-disk image order MUST match descriptor order** (CP/M-86 concatenates
   group images in descriptor order, no per-descriptor file offset). The
   non-code image write is therefore TWO passes — DATA (DGROUP) image first,
   then all EXTRA images — even though Groups-list order may be far-first.

3. **Fixup nibbles carry each group's actual assigned CMD type**
   (`cpm86GroupCmdType`), so a far-data reference names type-3 EXTRA and the
   loader relocates it through the correct base-page slot. Each far object's
   segment word is relocated individually to `EXTRA_load_seg + object_paragraph`,
   so the coalesced EXTRA image may span **>64 KB in total** as long as no single
   object exceeds 64 KB (a genuine >64 KB far-data arena; huge single objects are
   out of scope).

4. **OPTION FARHEAP + far data no longer emit two type-3 groups.** If a far-data
   EXTRA descriptor already exists, FARHEAP raises that descriptor's G_Max (heap
   headroom in the same Extra segment) instead of appending a second type-3
   (which would collide). With no far data, FARHEAP still appends its own
   imageless type-3 as before (farheap-small test unchanged).

## Verification oracles (all pass with the new wlink)

- Repro `/tmp/farsplit.c` (`static const char __far fmsg[]`, printed char by
  char): `python3 contrib/ravn/cpm86run_unicorn.py FARSPLIT.CMD` prints
  `FARDATA-OK` (was blank = failing baseline).
- `contrib/ravn/test_stageb_farcall.sh` (medium-model far-call/far-ptr +
  small-model no-fixup guard): 3 passed.
- `contrib/ravn/test_cpm86_reloc.py` (consumer): 4 passed.
- `watcom-cpm86-libc/build-farheap-small.sh`: type-1 + type-2 + imageless
  type-3, Unicorn PASS.
- UnZip (`infozip-cpm86-builds/build-cpm86.sh`, branch `cpm86-port`) links as
  CODE 59808 B + type-2 DGROUP 29376 B + type-3 far data 36352 B — the 64 KB
  DGROUP ceiling is broken. (Also needs the `check_for_windows` stub, infozip
  local commit `7aa569d`.) NOTE: full UnZip runtime CRC verification still needs
  emu2 P_LOAD fixup support (ravn/emu2-cpm86#1) or MAME — the Unicorn runner has
  no disk I/O. The `FARDATA-OK` repro is the near-term mechanism gate.

Related: `[[reference_watcom_wlink_cpm86_format.md]]`,
`[[reference_cpm86_big_model]]` (far data -> G-Type=3 Extra),
`[[reference_drc_cpm86_reloc_mechanism_VERIFIED]]` (nibble/base-page mechanism),
`[[reference_cpm86_cmd_header]]`.
