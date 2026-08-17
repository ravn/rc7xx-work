# owc-drc (Watcom linked against the DR C runtime) is RETIRED — standalone Watcom works

**Status (user, 2026-08-17): the owc-drc path is DROPPED.** The user got the
modern Open Watcom C toolchain to build/run CP/M-86 programs **on its own**, so
bridging Watcom object code against the genuine Digital Research C run-time
(`clears.l86` via DR `LINK-86`) is no longer needed.

User input: "den vej er droppet fordi jeg fik watcom til at vorke selv"
(that path is dropped because I got Watcom to work by itself).

## What this means for future work
- **Do NOT invest further in `open-watcom-v2/contrib/ravn/owc-drc/`** (the
  "Open Watcom C + DR C run-time" demo: bwcc → OMF → DR LINK-86 → .CMD, with
  unmodified Dhrystone 2.1 as the headline). It served its purpose (proving the
  bridge worked / DR C as correctness+size oracle) and is now superseded.
- The forward direction is the **standalone Watcom CP/M-86 toolchain** (its own
  runtime/startup, no dependency on DR C's `CLEAR?.L86`). Related durable notes:
  reference_watcom_wlink_cpm86_format, reference_watcom_cpm86_startup_initfini,
  reference_cpm86_cmd_header, reference_watcom_drc_abi_bridge (bridge = legacy).
- The DR C compiler/runtime (drc86111, rc759-drc-official) remains useful as a
  **correctness/size/speed ORACLE**, not as a link-time dependency.

## Note on the 2026-08-17 diskdef fix
`owc-drc/diskdefs` was corrected maxdir 256→512 (RC759 CCP/M dir is 512 entries;
old value corrupted images on cpmcp — see reference_rc759_official_drc_disk.md /
ravn/mame#25). That fix is correct and harmless but sits on a RETIRED path, so
it is low priority. The same fix on the ACTIVE toolchain lives in
scratch/rc759-pce/images/diskdefs.
