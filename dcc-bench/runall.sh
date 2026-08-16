#!/usr/bin/env bash
set -uo pipefail

# Usage: ./runall.sh [emulator] [--stack-check]
#   emulator       emulator command to run the built .COM files (default ntvcm)
#   --stack-check  build every app with dcc -fstack-check (lightweight
#                  stack-overflow guard).  A guarded app that overflows its
#                  reserve prints "?stack overflow" and exits, which then shows
#                  up as a diff against the baseline.  Also enabled by the
#                  STACK_CHECK=1 environment variable.
EMULATOR=""
FORCE_STACK_CHECK=${STACK_CHECK:-0}
for arg in "$@"; do
    case "$arg" in
        --stack-check|-stack-check|--fstack-check) FORCE_STACK_CHECK=1 ;;
        *) if [ -z "$EMULATOR" ]; then EMULATOR="$arg"; fi ;;
    esac
done
EMULATOR=${EMULATOR:-"$(cd "$(dirname "$0")" && pwd)/runticks.sh"}
BUILD_DIR=${BUILD_DIR:-build}

if [ "$FORCE_STACK_CHECK" = "1" ]; then
    export DCC_FORCE_STACK_CHECK=1
    echo "--- stack-check: building every app with -fstack-check ---"
fi

mkdir -p "$BUILD_DIR"

APPLIST="sieve e ttt tstruct trw tstr tbug tprintf ts tcmp tunary tlong \
         tpi mm tm tfio wumpus triangle fileops nqueens fact tsetjmp \
         tenum tunion tgoto tarray tchess targs tstdc tvariad tsprintf tscanf \
         tdowhile tmuldiv tbdos tdirent tc89core tc89uac tc89init tc89fp \
         tc89ptr tc89size tc89decl tc89qual tc89comp tc89swjt tc89bit \
         tc89pp tc89fnty tc89flt tc89fltc tc89flta tc89fptr tc89fs tc89fcmp \
         tc89fcnv tc89fadd tc89fmul tc89fdiv tc89ffio tc89flng tc89fmat \
         ttrig tlog tphi tap cpmenumd tbits tfo pihex tstrify tlcont primes \
         tpreproc trwold tlimits spsmash tcrcfix trtl2 tsyntax tstr2 tstr3 tstring \
         tlongaud tlongreg tlongopt tctxops tppreg tinitreg ttypesr ttype2 tdecinit tmalloch \
         tallocx tstdlib tioerr tqsort tbsearch trw2 terrno tpostfld tswitch tppifcom tpostidx \
         tpostut tbug2 tlongsub treg tret tstructv tstructi tstructp tstri2 \
         tunion2 tbitfld tcnstfld tpromo tkandr tc89ini2 tdecl tctype tifcom \
         tptrdiff tmulpow2 toffset tc89fini tmod3216 tpromo2 tunaryp tstfield \
         pint cobint forint bint fint cint adaint tstretst tportio tlongidx tforsco \
         tforblk tcmt99 tc99scpe tctxflt tmathf tstrconv tfarrsub t2darr too tzpad tesc \
         tkbd tstackov tasm tcodegen a1 \
         ttmp tungetc tfpos tatexit tabort tassert tfreopen tc89c2"

run_args() {
    case "$1" in
        ttt) echo "10" ;;
        pint) echo "e.pas" ;;
        cobint) echo "e.cob" ;;
        forint) echo "e.for" ;;
        adaint) echo "e.ada" ;;
        bint) echo "e.bas" ;;
        fint) echo "e.f" ;;
        cint) echo "eu.cin" ;;
        wumpus|tchess) echo "-c" ;;
        a1) echo "-l:HELLO.BAS" ;;
        targs) echo "a bb ccc dddd eeeee" ;;
        *) echo "" ;;
    esac
}

# Per-app C stack reserve (bytes), passed to ma.sh as DCC_STACK_SIZE.  Most apps
# use the dcc default (512); a few recursive ones need more headroom, which only
# matters under --stack-check (otherwise the unused reserve is harmless).  An
# empty result means "use the default".  A global STACK_SIZE env var, if set,
# overrides this table for every app.
#
# Measured minimum-to-pass under -fstack-check (then rounded up for headroom):
#   triangle  ~626  -> 768
#   cobint    ~1376 -> 1536
#   spsmash   has NO passing size: factorial(4e9) recurses until it smashes the
#             stack on purpose, so the guard always fires.  Left at the default.
stack_size_for() {
    if [ -n "${STACK_SIZE:-}" ]; then echo "$STACK_SIZE"; return; fi
    case "$1" in
        triangle) echo "768" ;;
        cobint)   echo "1536" ;;
        *)        echo "" ;;
    esac
}

to_lf() {
    if command -v dos2unix >/dev/null 2>&1; then
        dos2unix "$1" >/dev/null 2>&1 || true
    else
        perl -0pi -e 's/\r\n/\n/g' "$1"
    fi
}

clean_one() {
    app="$1"
    upper="$(printf '%s' "$app" | tr '[:lower:]' '[:upper:]')"
    rm -f "${BUILD_DIR}/${upper}.MAC" "${BUILD_DIR}/${upper}.REL" "${BUILD_DIR}/${upper}.PRN" "${BUILD_DIR}/${upper}.COM" \
          "${BUILD_DIR}/${app}.mac" "${BUILD_DIR}/${app}.rel" "${BUILD_DIR}/${app}.prn" "${BUILD_DIR}/${app}.com" "${BUILD_DIR}/${app}.COM" \
          "${BUILD_DIR}/DCCRTL.MAC" "${BUILD_DIR}/RTLMIN.MAC" "${BUILD_DIR}/RTLMIN.REL" "${BUILD_DIR}/RTLMIN.PRN" "${BUILD_DIR}/_PEEPOUT.MAC"
}

stage_fixture_inputs() {
    # CP/M data fixtures are every file in tests/ that is not a C source or repo
    # metadata (*.c, *.json, *.md, dotfiles). This is filesystem-independent: it
    # does not depend on the case of the stored filename, so it behaves the same
    # on case-sensitive (Linux) and case-insensitive (macOS) checkouts. CP/M
    # uppercases every filename a program opens, so stage each under its
    # UPPERCASE name; a single canonical copy in tests/ (any case) suffices.
    for src in tests/*; do
        [ -f "$src" ] || continue
        base="$(basename "$src")"
        case "$base" in
            *.c|*.json|*.md|.*) continue ;;
        esac
        upper="$(printf '%s' "$base" | tr '[:lower:]' '[:upper:]')"
        cp -f "$src" "${BUILD_DIR}/$upper"
    done
}

run_set() {
    mode="$1"       # peep or nopeep, passed directly to ma.sh
    outfile="$2"

    : > "$outfile"
    stage_fixture_inputs

    for app in $APPLIST; do
        upper="$(printf '%s' "$app" | tr '[:lower:]' '[:upper:]')"
        echo "test $app"
        echo "test $app" >> "$outfile"

        clean_one "$app"
        stack_sz="$(stack_size_for "$app")"
        if [ -n "$stack_sz" ]; then
            DCC_STACK_SIZE="$stack_sz" ./ma.sh "$app" "$mode" >/dev/null
        else
            ./ma.sh "$app" "$mode" >/dev/null
        fi

        args="$(run_args "$app")"
        if [ "$app" = "tkbd" ]; then
            echo x | (cd "$BUILD_DIR" && "$EMULATOR" "$upper") >> "$outfile"
        elif [ -n "$args" ]; then
            # shellcheck disable=SC2086
            (cd "$BUILD_DIR" && "$EMULATOR" "$upper" $args) >> "$outfile"
        else
            (cd "$BUILD_DIR" && "$EMULATOR" "$upper") >> "$outfile"
        fi

        clean_one "$app"
    done
}

echo "--- optimized ---"
run_set peep test_dcc.txt

echo "--- unoptimized ---"
run_set nopeep test_dccu.txt

to_lf test_dcc.txt
to_lf test_dccu.txt

set +e
diff baseline_test_dcc.txt test_dcc.txt
diff baseline_test_dcc.txt test_dccu.txt
