# Watcom↔DR C / Watcom↔Aztec INTEROP is RETIRED — standalone Watcom works

**Status (user, 2026-08-17): ALL efforts to make Open Watcom work TOGETHER WITH
DR C or Aztec C are DROPPED**, now that the standalone Open Watcom CP/M-86
toolchain works on its own. This is broader than just owc-drc: it covers every
"bridge/link Watcom against another vendor's runtime" attempt (owc-drc =
Watcom obj + DR C `clears.l86` via DR `LINK-86`; owc-drlink; any Aztec pairing).

User input: "alle tiltag med at få watcom til at fungere med dr c eller aztec er
droppet efter at vi fik watcom til at virke. DR C er det ultimative orakel på
filformat og hvordan hukommelsesmodeller implementeres, men det er for at få
watcom til at gøre det samme, ikke for at få dem til at virke sammen."
(Earlier: "den vej er droppet fordi jeg fik watcom til at vorke selv.")

## The precise role of DR C going forward: ORACLE, not a dependency
DR C (1.11 / drc86111 / rc759-drc-official) is the **ultimate oracle** for:
- the **CP/M-86 `.CMD` file format** (group descriptors, base page, fixups), and
- **how the memory models are implemented** (small/compact/large; DS/ES/SS
  setup; near/far pointer + return-register ABI).
The goal is to make **standalone Watcom produce the SAME behaviour** (byte-format
+ model semantics), i.e. replicate DR C — **NOT to make Watcom and DR C
interoperate / link together**. Use DR C to check correctness/size/format; never
as a link-time runtime for Watcom output.

## HARD RULE: never use owc-drc unless explicitly asked (user, 2026-08-17)
User input: "jeg vil aldrig mere have owc-drc med mindre der bliver bedt om det."
owc-drc (the Watcom-obj + DR C `clears.l86` hybrid) must NOT appear in any build,
benchmark, comparison, or oracle **unless the user explicitly asks for it by
name**. When a task needs "DR C", use the GENUINE DR C 1.11 compiler
`scratch/rc759-cmd-toolchain/drc86111/DRC.CMD` (run under cpm86/emu2), NOT the
owc-drc hybrid. Do not reach for owc-drc as a convenience even when it would be
faster.

## Implications for future work
- Do NOT invest in Watcom+DR C or Watcom+Aztec bridging/linking. The legacy
  bridge notes (reference_watcom_drc_abi_bridge, reference_wlink_drc_omf_l86,
  reference_watcom_drc_long_loop_bug, the "via Watcom→DR C bridge" benches) are
  historical — the interop angle is closed.
- Forward direction = standalone Watcom CP/M-86 (own runtime/startup): see
  reference_watcom_wlink_cpm86_format, reference_watcom_cpm86_startup_initfini,
  reference_cpm86_cmd_header.
- `open-watcom-v2/contrib/ravn/owc-drc/` and `owc-drlink/` are retired demos.

## Note on the 2026-08-17 diskdef fix
`owc-drc/diskdefs` was corrected maxdir 256→512 (RC759 CCP/M dir is 512 entries;
old value corrupted images on cpmcp — see reference_rc759_official_drc_disk.md /
ravn/mame#25). Correct and harmless but on a RETIRED path → low priority. The
same fix on the ACTIVE toolchain lives in scratch/rc759-pce/images/diskdefs.
