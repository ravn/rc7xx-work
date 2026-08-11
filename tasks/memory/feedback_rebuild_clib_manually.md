# z88dk clibs must be rebuilt MANUALLY after any libsrc change

**User directive (2026-08-11):** "noter i din hukommelse at clib skal genbygges
manuelt efter behov" — the classic clibs are not auto-rebuilt; rebuild them by
hand whenever a `libsrc` source that feeds them changes.

## The rule

After editing any `libsrc/**` source that lands in a classic library, you MUST
rebuild and reinstall the library before it takes effect in a `zcc` build or the
test suite:

```sh
cd /Users/ravn/z80/z88dk
export PATH="$PWD/bin:$PATH" ZCCCFG="$PWD/lib/config"
make -C libsrc TARGETS=cpm            # recompiles changed objs, relinks libsrc/*.lib
make -C libsrc TARGETS=cpm install    # blind `cp libsrc/*.lib lib/clibs/` (no deps)
```

`TARGETS=cpm` builds the +cpm family (`cpm_clib.lib`, `cpmixiy_clib.lib`, …).
Use the matching `TARGETS=` for other platforms, or omit it to build all
(slow). The z88dk `bin/` tools are native (sccz80/z80asm) — no Docker needed
for the classic clib.

## Why the build system does NOT detect staleness on its own

Verified during ravn/z88dk#57 hosted-default work:

1. **The consumed lib is a git-ignored artifact.** `lib/.gitignore` has
   `**/*.lib`, so `lib/clibs/cpm_clib.lib` (what zcc links) is not tracked. A
   source-only commit (e.g. #53 editing `_freopen1.c` + adding a test) ships the
   fix source but NEVER a rebuilt binary lib — every other checkout keeps the old
   lib until someone reruns the lib build locally.
2. **Two-stage build with a dependency-less install.**
   `cpm_clib.lib: $(TARGET_CLIB_DEPS)` (libsrc/Makefile:890) DOES track
   `.c -> .o -> libsrc/cpm_clib.lib` correctly (touch a source and `make -n`
   recompiles + relinks). But `install:` (libsrc/Makefile:2487) is a bare
   `cp $(OUTPUT_DIRECTORY)/*.lib ../lib/clibs` with NO prerequisites — it can't
   "detect" anything; it just copies, and only when explicitly invoked.
3. **The program-build path never touches libs.** `zcc … prog.c` (and the test
   suite) has no dependency on the libraries, so building a program or running
   tests never triggers a lib rebuild. There is no edge from
   `lib/clibs/cpm_clib.lib` to the source.

**Smoking gun:** `lib/clibs/cpm_clib.lib` mtime 01:40 predated the #53
`_freopen1.c` fix (01:41) by one minute; the committer rebuilt in their own tree
but this working tree's installed lib was never refreshed until a manual rebuild
at 13:13.

## Debugging corollary

Before blaming a code regression for a z88dk classic runtime test failure,
FIRST check that the consumed lib is newer than the changed source:

```sh
stat -f '%Sm %N' lib/clibs/cpm_clib.lib libsrc/classic/stdio/_freopen1.c
```

If the lib is older, rebuild+install and re-test before investigating further.
(Note: staleness is not always the cause — during #57 the FILE* failures
persisted after a fresh rebuild, i.e. a genuine defect — but rule it out first.)
