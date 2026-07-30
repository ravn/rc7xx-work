---
name: rcbios 32-bit RTC is a 50Hz boot-relative tick counter — differences only, not epoch time
description: rcbios rtc0/rtc2 (0xFFFC/0xFFFE) counts 20ms ticks; use for elapsed-time diffs, never as a since-epoch timestamp
type: reference
metadata:
  type: reference
---

**rcbios's 32-bit clock is for time DIFFERENCES, not absolute time-since-epoch**
(user, 2026-07-25).

The counter is `rtc0` (word @ `0xFFFC`, low) + `rtc2` (word @ `0xFFFE`, high) in
the BIOS scratch area (`rcbios-in-c/bios.h`), incremented by the CRT timer ISR
(`bios.c` ~L2191: `rtc0++; if (rtc0==0) rtc2++;`). The ISR fires every **20 ms =
50 Hz** (same rate as the z88dk rc700 `clock()` `CLOCKS_PER_SEC=50`; see
`waitd(50)` "50 * 20ms = 1 second").

Consequences:
- It counts **ticks, not seconds**, and is **boot-relative** (starts at 0 at
  boot), so it is not wall-clock time.
- 2^32 ticks / 50 Hz = ~85.9M s = **~994 days (~2.72 years)** before it wraps.
- It therefore **cannot represent seconds-since-epoch** (Unix time is ~1.7e9 s
  and growing over decades). Do NOT try to build `time()`/epoch timestamps on it.
- It IS good for **elapsed-time differences** (subtract two readings; divide by
  50 for seconds) within a wrap period.

If a program needs wall-clock date/time on RC700, that needs a real RTC/CP/M-3
clock source, not this counter. **Under CP/NOS the wall-clock time is fetched
from the CP/NET server (the master), not kept locally** — there is a demo of
this (user, 2026-07-25). So the split is: local 50Hz counter = elapsed-time
diffs; absolute date/time = ask the server over CP/NET. The z88dk rc700 target's
`clock()` runs at the same 50 Hz (`libsrc/target/rc700/README.md`).
