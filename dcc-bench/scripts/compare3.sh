#!/usr/bin/env bash
# compare3.sh: Compare dcc vs zsdcc for C test programs.
# Reports: .COM size (bytes) and T-states (via z88dk-ticks).
# Clang/CP/M support is a future addition (needs crt0 + BDOS library).
#
# Usage:
#   scripts/compare3.sh <test_name>       -- one test
#   scripts/compare3.sh --all             -- all tests in TEST_LIST
#   scripts/compare3.sh --csv [tests...]  -- CSV output
#   scripts/compare3.sh --html [tests...] -- HTML table (writes $HTML_OUT,
#                                            default /tmp/compare3.html, and
#                                            auto-opens it when `open` exists)
#
# All compilers and tools are discovered from the rc7xx-work superproject's
# submodules relative to this script (no hardcoded /Users/... paths), so the
# top-level workspace can compare compilers straight from its submodules on
# any host.  Layout expected under the workspace root:
#   dcc/          davidly dcc compiler + m80.com/l80.com/DCCRTL.MAC (submodule)
#   llvm-z80/     clang (llvm-z80 backend)                          (submodule)
#   z88dk/        zsdcc (zcc) + z88dk-ticks                         (submodule)
#   cpnet-z80/    VirtualCpm.jar                                    (submodule)
#   dcc-bench/    this harness (tests/, runcpm.sh, build/)
#
# Environment overrides (all optional; sensible workspace-relative defaults):
#   WORKSPACE     rc7xx-work root (default: parent of dcc-bench/)
#   DCC_DIR       dcc submodule root (default: $WORKSPACE/dcc)
#   LLVM_Z80      llvm-z80 submodule root (default: $WORKSPACE/llvm-z80)
#   Z88DK_BIN     z88dk bin dir (default: $WORKSPACE/z88dk/bin)
#   TICKS         z88dk-ticks binary (default: $Z88DK_BIN/z88dk-ticks)
#   VCPM_JAR      VirtualCpm.jar (default: $WORKSPACE/cpnet-z80/tools/VirtualCpm.jar)
#   Z88DK_CFG     z88dk config dir (default: Z88DK_BIN/../lib/config)
#   CLANG_BUILD   llvm-z80 build bin dir (default: first of build-macos/
#                 build-linux/build under $LLVM_Z80)
#   MAX_TSTATES   T-state counter ceiling (default: 2000000000 = 2B)
#   HTML_OUT      output path for --html (default: /tmp/compare3.html)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# BENCH_DIR = dcc-bench/ (this harness: tests/, runcpm.sh, build/).
BENCH_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# WORKSPACE = rc7xx-work root; the compiler submodules are its children.
WORKSPACE="${WORKSPACE:-$(cd "$BENCH_DIR/.." && pwd)}"

# DCC_DIR is the dcc *submodule* (compiler binaries on PATH + the m80.com/
# l80.com/DCCRTL.MAC assets build_dcc copies).  It is NOT the harness dir any
# more — test sources are resolved separately (see find_test_src).
DCC_DIR="${DCC_DIR:-$WORKSPACE/dcc}"
LLVM_Z80="${LLVM_Z80:-$WORKSPACE/llvm-z80}"
Z88DK_BIN="${Z88DK_BIN:-$WORKSPACE/z88dk/bin}"
TICKS="${TICKS:-$Z88DK_BIN/z88dk-ticks}"
VCPM_JAR="${VCPM_JAR:-$WORKSPACE/cpnet-z80/tools/VirtualCpm.jar}"
Z88DK_CFG="${Z88DK_CFG:-$Z88DK_BIN/../lib/config}"
RUNCPM="${BENCH_DIR}/runcpm.sh"
MAX_TSTATES="${MAX_TSTATES:-2000000000}"

if [ -z "${CLANG_BUILD:-}" ]; then
    for _d in "$LLVM_Z80/build-macos/bin" "$LLVM_Z80/build-linux/bin" "$LLVM_Z80/build/bin"; do
        [ -d "$_d" ] && { CLANG_BUILD="$_d"; break; }
    done
fi
CLANG_BUILD="${CLANG_BUILD:-}"
CPM_DIR="$LLVM_Z80/z80-utils/cpm"
Z80_RT="${CLANG_BUILD%/bin}/lib/z80/z80_rt.a"

export PATH="$Z88DK_BIN:$DCC_DIR:$PATH"
export ZCCCFG="$Z88DK_CFG"
# Export VCPM_JAR so the child runcpm.sh (invoked by build_dcc for M80/L80)
# uses the same workspace jar rather than its own hardcoded fallback.
export VCPM_JAR

BUILD_DIR="${BENCH_DIR}/build/compare3"

# Pure-compute C89 tests portable between dcc and zsdcc (no file I/O, no
# CP/M-specific calls, no floating-point, no long-specific args).
# Add more from the dcc test suite as needed.
TEST_LIST="sieve e nqueens fact triangle ttt tstring tqsort tbsearch tsetjmp tmalloch fwdelay fwfdc fwsector fwbitops fwcoord fwxlt fwcrc"

usage() {
    echo "usage: compare3.sh [--csv | --html] [--all | <test> ...]" >&2
    exit 1
}

CSV_MODE=0
HTML_MODE=0
ALL_MODE=0
TESTS=""
for arg in "$@"; do
    case "$arg" in
        --csv)  CSV_MODE=1 ;;
        --html) HTML_MODE=1; CSV_MODE=1 ;;  # HTML is rendered from CSV rows
        --all)  ALL_MODE=1 ;;
        -h|--help) usage ;;
        -*) echo "unknown flag: $arg" >&2; usage ;;
        *)  TESTS="$TESTS $arg" ;;
    esac
done
if [ "$ALL_MODE" -eq 1 ]; then TESTS="$TEST_LIST"; fi
TESTS="${TESTS#" "}"
if [ -z "$TESTS" ]; then usage; fi

mkdir -p "$BUILD_DIR"

# ---------- helpers ----------

# Run a command under a hard wall-clock timeout in its OWN process group, so a
# hung child AND all of its descendants (clang / zcc / java / ticks) are killed
# together -- no orphans, no stalled sweep.  macOS has no GNU timeout(1); perl
# gives us fork + setpgrp + alarm.  Returns the command's exit status, or 124 if
# the timeout fired (the child was SIGKILLed).
#
# Worked example: with_timeout 240 env _C3_ONE=1 bash compare3.sh sieve
#   - perl forks; the grandchild calls setpgrp(0,0) -> becomes group leader,
#     then exec's `env ... bash ...`; clang/ld/ticks it spawns inherit the group.
#   - if 240 s elapse first, SIGALRM -> kill('KILL', -$pid) reaps the whole group.
with_timeout() {
    local secs="$1"; shift
    perl -e '
        my $secs = shift @ARGV;
        my $pid  = fork();
        die "fork: $!" unless defined $pid;
        if ($pid == 0) { setpgrp(0, 0); exec @ARGV or exit 127; }
        local $SIG{ALRM} = sub { kill("KILL", -$pid); };
        alarm $secs;
        waitpid($pid, 0);
        my $st = $?;
        alarm 0;
        exit(($st & 127) ? 124 : ($st >> 8));
    ' "$secs" "$@"
}

# Build a 65536-byte CP/M image (page-zero stub + .COM at 0x0100) for ticks.
make_ticks_image() {
    local com_file="$1"
    local img="$BUILD_DIR/$(basename "${com_file%.COM}").img"
    python3 - "$com_file" "$img" <<'PYEOF'
import sys
com_path, out_path = sys.argv[1], sys.argv[2]
mem = bytearray(65536)

# CP/M page-zero setup compatible with both dcc and z88dk (zsdcc) CP/M runtimes.
#
# z88dk crt0 reads the BDOS address from (0x0006) and uses it to set SP:
#   LD SP,(0x0006)   ; SP = BDOS addr (= 0xDC00)
#   LD HL,0xFFC0     ; SP = SP + 0xFFC0 (near top of TPA)
#   ADD HL,SP
#   LD SP,HL
# If 0x0006 holds only 0x07 (from a JP 7 opcode), SP ends up at 7 and the
# first CALL corrupts the BDOS stub.  We avoid that by routing BDOS to 0xDC00.
#
# 0x0000: JP 0x0000  (warm-boot: ticks -end 0 triggers here — also the exit
#                    path for programs that use JP 0)
# 0x0005: JP 0xDC00  (BDOS entry; bytes at 0x0006/0x0007 = 0x00/0xDC so that
#                    LD SP,(0x0006) gives SP=0xDC00, a safe stack start)
# 0xDC00: mini-BDOS  LD A,C / OR A / JP Z,0x0000 / RET
#   — function 0 (terminate) routes to warm-boot → ticks stops via -end 0
#   — all other functions return immediately (I/O silently discarded)

mem[0x0000] = 0xC3; mem[0x0001] = 0x00; mem[0x0002] = 0x00   # JP 0x0000

mem[0x0005] = 0xC3; mem[0x0006] = 0x00; mem[0x0007] = 0xDC   # JP 0xDC00

# mini-BDOS at 0xDC00
mem[0xDC00] = 0x79          # LD A,C
mem[0xDC01] = 0xB7          # OR A
mem[0xDC02] = 0xCA          # JP Z, ...
mem[0xDC03] = 0x00          # lo = 0x00
mem[0xDC04] = 0x00          # hi = 0x00  -> JP Z, 0x0000 (terminate)
mem[0xDC05] = 0xC9          # RET (all other functions)

with open(com_path, 'rb') as f:
    com_data = f.read()
mem[0x0100:0x0100+len(com_data)] = com_data
with open(out_path, 'wb') as f:
    f.write(mem)
PYEOF
    echo "$img"
}

# Run a .COM file through z88dk-ticks, return T-state count.
# Uses -counter MAX_TSTATES so long-running programs report the limit rather
# than hanging indefinitely.  The count printed at the end is always the
# actual T-states elapsed (slightly above the limit when the limit fires).
measure_tstates() {
    local com_file="$1"
    local img
    img=$(make_ticks_image "$com_file")
    "$TICKS" -pc 100 -end 0 -counter "$MAX_TSTATES" "$img" 2>/dev/null | tail -1
}

# Run a .COM file via vcpm, capture console output for correctness check.
run_via_vcpm() {
    local com_file="$1"
    local stem
    stem=$(basename "${com_file%.COM}")
    local tmproot tmphome
    tmproot=$(mktemp -d /tmp/vcpmroot_XXXXXX)
    tmphome=$(mktemp -d /tmp/vcpmhome_XXXXXX)
    ln -s "$(dirname "$com_file")" "$tmproot/a"
    cat > "$tmphome/.vcpmrc" <<EOF
vcpm_root_dir = $tmproot
vcpm_dso = def,a:,b,c
silent
EOF
    local out
    # Hard timeout (perl alarm — macOS has no GNU timeout) so a program that
    # reads console input, or a missing .COM, can never hang the harness.
    # Feed /dev/null to stdin so any console-read returns EOF immediately.
    out=$(perl -e 'alarm shift; exec @ARGV' "${VCPM_TIMEOUT:-20}" \
            java -Duser.home="$tmphome" -jar "$VCPM_JAR" "$stem" \
            < /dev/null 2>/dev/null || true)
    rm -rf "$tmproot" "$tmphome"
    # Strip the "A>STEM" prompt line vcpm echoes; normalize CR so dcc fn9
    # and clang fn2 output can be compared on content only.
    printf '%s' "$out" | tail -n +2 | tr -d '\r'
}

# ---------- build functions ----------

# Resolve a test's C source across the two post-relocation locations:
#   $BENCH_DIR/tests/  — RC7xx firmware benchmarks (fw*.c, ackerman, hanoi,
#                        tak, whetston), added by this project.
#   $DCC_DIR/tests/    — davidly's canonical dcc suite (sieve, e, nqueens,
#                        fact, triangle, ttt, tstring, ...), in the submodule.
# Prefer the local benchmark dir; fall back to the dcc submodule.  Prints the
# resolved path, or nothing (empty) when the test exists in neither.
find_test_src() {
    local name="$1"
    if [ -f "$BENCH_DIR/tests/${name}.c" ]; then
        echo "$BENCH_DIR/tests/${name}.c"
    elif [ -f "$DCC_DIR/tests/${name}.c" ]; then
        echo "$DCC_DIR/tests/${name}.c"
    fi
}

build_dcc() {
    local name="$1"
    local src; src=$(find_test_src "$name")
    [ -n "$src" ] && [ -f "$src" ] || return 1
    local upper
    upper="$(printf '%s' "$name" | tr '[:lower:]' '[:upper:]')"
    local out="$BUILD_DIR/dcc_${upper}.COM"
    local work="$BUILD_DIR/dcc_work_${name}"
    rm -rf "$work" && mkdir -p "$work"
    cp -f "$DCC_DIR/m80.com"     "$work/M80.COM"
    cp -f "$DCC_DIR/l80.com"     "$work/L80.COM"
    cp -f "$DCC_DIR/DCCRTL.MAC"  "$work/DCCRTL.MAC"
    local mac="$work/${upper}.MAC"
    dcc "$src" -o "$mac"
    dccpeep "$mac" "$work/_PEEP.MAC" && mv "$work/_PEEP.MAC" "$mac"
    perl -0pi -e 's/\r?\n/\r\n/g' "$mac"
    (cd "$work" && "$RUNCPM" M80.COM "=${upper}.MAC /X /O /Z /L" >/dev/null 2>&1)
    dccrtlstrip -r "$work/DCCRTL.MAC" -o "$work/RTLMIN.MAC" "$mac"
    perl -0pi -e 's/\r?\n/\r\n/g' "$work/RTLMIN.MAC"
    (cd "$work" && "$RUNCPM" M80.COM "=RTLMIN.MAC /X /O /Z"             >/dev/null 2>&1)
    (cd "$work" && "$RUNCPM" L80.COM "/P:100,RTLMIN,${upper},${upper}/N/E" >/dev/null 2>&1)
    cp "$work/${upper}.COM" "$out"
    echo "$out"
}

build_clang() {
    local name="$1"
    local src; src=$(find_test_src "$name")
    [ -n "$src" ] && [ -f "$src" ] || return 1
    local upper
    upper="$(printf '%s' "$name" | tr '[:lower:]' '[:upper:]')"
    local out="$BUILD_DIR/clang_${upper}.COM"
    local clang="$CLANG_BUILD/clang"
    local ld="$CLANG_BUILD/ld.lld"
    local objcopy="$CLANG_BUILD/llvm-objcopy"
    local elf="$BUILD_DIR/clang_${upper}.elf"
    # Remove stale outputs so a failed compile/link can't masquerade as success.
    rm -f "$out" "$elf" "$BUILD_DIR/clang_${name}.o"
    local cflags="--target=z80 -Os -fno-builtin -ffunction-sections -fdata-sections -nostdlib -nostartfiles -I $CPM_DIR"
    # Runtime objects are shared; rebuild them each time (cheap, always fresh).
    "$clang" $cflags -c "$CPM_DIR/cpm_crt0.s"   -o "$BUILD_DIR/clang_crt0.o"   2>/dev/null || return 1
    "$clang" $cflags -c "$CPM_DIR/cpm_io.c"     -o "$BUILD_DIR/clang_io.o"     2>/dev/null || return 1
    "$clang" $cflags -c "$CPM_DIR/cpm_stdlib.c" -o "$BUILD_DIR/clang_stdlib.o" 2>/dev/null || return 1
    "$clang" $cflags -c "$src" -o "$BUILD_DIR/clang_${name}.o" 2>/dev/null || return 1
    "$ld" --gc-sections -T "$CPM_DIR/cpm.ld" \
        "$BUILD_DIR/clang_crt0.o" "$BUILD_DIR/clang_io.o" \
        "$BUILD_DIR/clang_stdlib.o" \
        "$BUILD_DIR/clang_${name}.o" "$Z80_RT" \
        -o "$elf" 2>/dev/null || return 1
    "$objcopy" -O binary --only-section=.text "$elf" "$out" 2>/dev/null || return 1
    [ -f "$out" ] || return 1
    echo "$out"
}

build_zsdcc() {
    local name="$1"
    local src; src=$(find_test_src "$name")
    [ -n "$src" ] && [ -f "$src" ] || return 1
    local upper
    upper="$(printf '%s' "$name" | tr '[:lower:]' '[:upper:]')"
    local out="$BUILD_DIR/zsdcc_${upper}.COM"
    # zcc produces an output file without extension; rename to .COM
    zcc +cpm -compiler=sdcc --opt-code-size -o "$BUILD_DIR/zsdcc_${name}" "$src" 2>/dev/null
    mv -f "$BUILD_DIR/zsdcc_${name}" "$out"
    echo "$out"
}

# ---------- run one test for all compilers ----------

# Output-agreement verdict is by CONSENSUS, not against any single compiler:
# dcc lacks %ld/%lu (prints literal "lu"), so it is NOT a trustworthy oracle.
#   AGREE  — output matches at least one other compiler (cross-validated)
#   SOLO   — the only compiler that built+ran this test (no peer to check)
#   DIFF   — built+ran but disagrees with every peer (the outlier — suspect)
run_test() {
    local test="$1"
    local src; src=$(find_test_src "$test")
    if [ -z "$src" ] || [ ! -f "$src" ]; then
        echo "SKIP $test: no source" >&2
        return
    fi

    # Defensive: a previously SIGKILLed test (watchdog) may have left stale
    # per-compiler scratch files (.r_dcc_built=1 with no matching size/out).
    # Clear them so this test's consensus verdict can't read another test's
    # leftovers.
    rm -f "$BUILD_DIR"/.r_* 2>/dev/null || true

    local compilers="dcc clang zsdcc"
    local c
    # Pass 1: build, measure, capture output into per-compiler temp files
    for c in $compilers; do
        local com_file="" build_ok=0
        case "$c" in
            dcc)   com_file=$(build_dcc   "$test" 2>/dev/null) && build_ok=1 || true ;;
            clang) com_file=$(build_clang "$test" 2>/dev/null) && build_ok=1 || true ;;
            zsdcc) com_file=$(build_zsdcc "$test" 2>/dev/null) && build_ok=1 || true ;;
        esac
        if [ "$build_ok" -eq 1 ] && [ -n "${com_file:-}" ] && [ -f "$com_file" ]; then
            echo "$(wc -c < "$com_file")"               > "$BUILD_DIR/.r_${c}_size"
            measure_tstates "$com_file" 2>/dev/null      > "$BUILD_DIR/.r_${c}_ts" || echo "?" > "$BUILD_DIR/.r_${c}_ts"
            run_via_vcpm "$com_file" 2>/dev/null          > "$BUILD_DIR/.r_${c}_out" || true
            echo "1" > "$BUILD_DIR/.r_${c}_built"
        else
            echo "0" > "$BUILD_DIR/.r_${c}_built"
        fi
    done

    # Pass 2: consensus verdict + print
    for c in $compilers; do
        if [ "$(cat "$BUILD_DIR/.r_${c}_built")" != "1" ]; then
            if [ "$CSV_MODE" -eq 1 ]; then
                printf "%s,%s,BUILD_FAIL,,\n" "$test" "$c"
            else
                printf "%-12s  %-8s  %10s  %15s  %s\n" "$test" "$c" "BUILD_FAIL" "" ""
            fi
            continue
        fi
        local size tstates verdict mine peers
        size=$(cat "$BUILD_DIR/.r_${c}_size")
        tstates=$(cat "$BUILD_DIR/.r_${c}_ts")
        mine=$(cat "$BUILD_DIR/.r_${c}_out" 2>/dev/null)
        # Compare against the other built compilers
        verdict="SOLO"
        local other agreed=0 had_peer=0
        for other in $compilers; do
            [ "$other" = "$c" ] && continue
            [ "$(cat "$BUILD_DIR/.r_${other}_built")" = "1" ] || continue
            had_peer=1
            peers=$(cat "$BUILD_DIR/.r_${other}_out" 2>/dev/null)
            [ "$mine" = "$peers" ] && agreed=1
        done
        if [ "$had_peer" = "1" ]; then
            [ "$agreed" = "1" ] && verdict="AGREE" || verdict="DIFF"
        fi
        if [ "$CSV_MODE" -eq 1 ]; then
            printf "%s,%s,%d,%s,%s\n" "$test" "$c" "$size" "$tstates" "$verdict"
        else
            printf "%-12s  %-8s  %10d  %15s  %s\n" "$test" "$c" "$size" "$tstates" "$verdict"
        fi
    done
    rm -f "$BUILD_DIR"/.r_*
    [ "$CSV_MODE" -eq 0 ] && echo || true
}

# ---------- driver ----------

# Per-test wall-clock budget.  A test that builds 3 compilers + emulates each
# can legitimately take a while (fwsector dcc ~180 M tstates), so default high.
TEST_TIMEOUT="${TEST_TIMEOUT:-300}"

# Emit a single diagnostic row when a whole test could not be completed (the
# child aborted or was killed by the watchdog), so the failure is VISIBLE in
# the output and the sweep keeps going instead of silently dropping the test.
emit_harness_row() {
    local t="$1" label="$2"
    if [ "$CSV_MODE" -eq 1 ]; then
        printf "%s,harness,%s,,\n" "$t" "$label"
    else
        printf "%-12s  %-8s  %10s  %15s  %s\n" "$t" "harness" "$label" "" ""
        echo
    fi
}

# Print the header (parent only) + run every test.  Wrapped in a function so
# --html can capture the CSV stream and render it, while plain/--csv runs stream
# straight to stdout.
run_sweep() {
    # In child mode (_C3_ONE set) we run exactly one test and print no header --
    # the parent already printed it once.
    if [ -z "${_C3_ONE:-}" ]; then
        if [ "$CSV_MODE" -eq 1 ]; then
            printf "test,compiler,size_bytes,tstates,verdict\n"
        else
            printf "%-12s  %-8s  %10s  %15s  %s\n" \
                "test" "compiler" "size(B)" "T-states" "verdict"
            printf "%s\n" "$(printf '%0.s-' {1..62})"
        fi
    fi

    if [ -n "${_C3_ONE:-}" ]; then
        # Child mode: run the single requested test in-process.
        for t in $TESTS; do
            run_test "$t"
        done
    else
        # Parent mode: run EACH test as an isolated child under a hard timeout in
        # its own process group.  This is the resilience boundary -- a hang,
        # crash, or `set -e` abort inside one test kills only that child; the
        # parent records a TIMEOUT/ERROR row and proceeds to the next test.
        # Results are flushed per test (each child prints its rows before the
        # next starts), so redirecting stdout to a file always yields a complete
        # partial record.
        local childflags=""
        [ "$CSV_MODE" -eq 1 ] && childflags="--csv"
        local t rc
        for t in $TESTS; do
            rm -f "$BUILD_DIR"/.r_* 2>/dev/null || true
            rc=0
            with_timeout "$TEST_TIMEOUT" env _C3_ONE=1 bash "$0" $childflags "$t" || rc=$?
            if [ "$rc" -ne 0 ]; then
                if [ "$rc" -eq 124 ]; then
                    emit_harness_row "$t" "TIMEOUT"
                else
                    emit_harness_row "$t" "ERROR"
                fi
            fi
        done
        rm -f "$BUILD_DIR"/.r_* 2>/dev/null || true
    fi
}

if [ "$HTML_MODE" -eq 1 ]; then
    # Buffer the CSV stream to a temp file, then render it to HTML.  A child
    # invocation (_C3_ONE) never reaches here -- children always run CSV rows.
    HTML_OUT="${HTML_OUT:-/tmp/compare3.html}"
    _tmpcsv="$(mktemp "${TMPDIR:-/tmp}/compare3_XXXXXX.csv")"
    run_sweep > "$_tmpcsv"
    python3 "$SCRIPT_DIR/compare3_html.py" "$_tmpcsv" "$HTML_OUT"
    rm -f "$_tmpcsv"
    # Auto-open on a desktop (macOS `open` / Linux `xdg-open`) when available.
    if command -v open >/dev/null 2>&1; then
        open "$HTML_OUT"
    elif command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$HTML_OUT" >/dev/null 2>&1 || true
    fi
else
    run_sweep
fi
