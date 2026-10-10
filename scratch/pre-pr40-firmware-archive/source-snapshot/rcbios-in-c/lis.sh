#!/bin/bash
# Navigate between bios.c / crt0.asm and bios.c.lis listing file.
#
# Usage:
#   ./lis.sh <function>        show listing output for that function
#   ./lis.sh -l                list all functions (with .lis line numbers and addresses)
#   ./lis.sh -s <pattern>      search listing for pattern
#   ./lis.sh -a <hex_addr>     find function containing address (e.g. 0546 or 0x0546)
#   ./lis.sh -c <function>     show bios.c / crt0.asm source for that function
#
# Function names: with or without leading underscore, partial matches OK.
# Output uses file:line format for IntelliJ IDEA click-to-navigate.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LIS="$SCRIPT_DIR/bios.c.lis"
SRC="$SCRIPT_DIR/bios.c"
CRT="$SCRIPT_DIR/crt0.asm"

if [ ! -f "$LIS" ]; then
    echo "error: $LIS not found — run 'make bios' first." >&2
    exit 1
fi

# Extract all "; Function <name>" lines with .lis line numbers and addresses
build_func_table() {
    # Output: lis_line  address  func_name
    grep -n '; Function ' "$LIS" | while IFS= read -r line; do
        local lineno func label_line addr
        lineno=$(echo "$line" | cut -d: -f1)
        func=$(echo "$line" | sed 's/.*; Function //')
        # The label is 2 lines after comment; address is on label line or first instruction after
        # Try lines +2 through +4 to find the first hex address
        addr=""
        for off in 2 3 4; do
            local try_line
            try_line=$(sed -n "$((lineno + off))p" "$LIS")
            addr=$(echo "$try_line" | sed -n 's/^[[:space:]]*[0-9]\{1,\}[[:space:]]\{1,\}\([0-9a-f]\{4\}\)[[:space:]]\{1,\}.*/\1/p')
            [ -n "$addr" ] && break
        done
        printf "%d\t%s\t%s\n" "$lineno" "${addr:-????}" "$func"
    done
}

# Find bios.c line for a function name
find_src_line() {
    local name="$1"
    # Try C function definition
    grep -n "\b${name}\b" "$SRC" 2>/dev/null | grep -E '^\d+:\s*(static )?(void|byte|word|uint[0-9]|int )' | grep '(' | head -1 | cut -d: -f1
}

# Find crt0.asm line for a function name
find_crt_line() {
    local name="$1"
    grep -n "^_${name}:" "$CRT" 2>/dev/null | head -1 | cut -d: -f1
}

cmd_list() {
    echo "Functions in listing order:"
    echo ""
    build_func_table | while IFS=$'\t' read -r lineno addr func; do
        local src_ln crt_ln loc
        src_ln=$(find_src_line "$func")
        crt_ln=$(find_crt_line "$func")
        if [ -n "$src_ln" ]; then
            loc="bios.c:${src_ln}"
        elif [ -n "$crt_ln" ]; then
            loc="crt0.asm:${crt_ln}"
        else
            loc=""
        fi
        printf "  %-24s 0x%s  lis:%d" "$func" "$addr" "$lineno"
        [ -n "$loc" ] && printf "  %s" "$loc"
        printf "\n"
    done
}

cmd_show() {
    local name="${1#_}"

    # Find matching function(s)
    local matches
    matches=$(grep -n "; Function ${name}" "$LIS")
    if [ -z "$matches" ]; then
        echo "error: no function matching '${name}' in listing." >&2
        echo "Use './lis.sh -l' to list all." >&2
        exit 1
    fi

    local count
    count=$(echo "$matches" | wc -l | tr -d ' ')
    if [ "$count" -gt 1 ]; then
        echo "Multiple matches:" >&2
        echo "$matches" | sed 's/.*; Function /  /' >&2
        exit 1
    fi

    local start_line func_name
    start_line=$(echo "$matches" | cut -d: -f1)
    func_name=$(echo "$matches" | sed 's/.*; Function //')
    start_line=$((start_line - 1))  # include separator

    # End at next function separator
    local end_line
    end_line=$(tail -n +$((start_line + 3)) "$LIS" | grep -n '^.*;\t-\{5,\}' | head -1 | cut -d: -f1)
    if [ -n "$end_line" ]; then
        end_line=$((start_line + 2 + end_line))
    else
        end_line=$(wc -l < "$LIS")
    fi

    # Print source cross-reference (IntelliJ-clickable)
    local src_ln crt_ln
    src_ln=$(find_src_line "$func_name")
    crt_ln=$(find_crt_line "$func_name")
    [ -n "$src_ln" ] && echo "  Source: bios.c:${src_ln}"
    [ -n "$crt_ln" ] && echo "  Source: crt0.asm:${crt_ln}"
    echo "  Listing: bios.c.lis:${start_line}"
    echo ""

    sed -n "${start_line},${end_line}p" "$LIS"
}

cmd_source() {
    local name="${1#_}"

    # Try bios.c
    local src_ln
    src_ln=$(find_src_line "$name")
    if [ -n "$src_ln" ]; then
        # Find closing brace
        local end_ln
        end_ln=$(tail -n +$((src_ln + 1)) "$SRC" | grep -n '^}' | head -1 | cut -d: -f1)
        [ -n "$end_ln" ] && end_ln=$((src_ln + end_ln)) || end_ln=$((src_ln + 40))
        echo "bios.c:${src_ln}:"
        sed -n "${src_ln},${end_ln}p" "$SRC"
        return
    fi

    # Try crt0.asm
    local crt_ln
    crt_ln=$(find_crt_line "$name")
    if [ -n "$crt_ln" ]; then
        local end_ln
        end_ln=$(tail -n +$((crt_ln + 1)) "$CRT" | grep -n '^_[a-z]' | head -1 | cut -d: -f1)
        [ -n "$end_ln" ] && end_ln=$((crt_ln + end_ln - 1)) || end_ln=$((crt_ln + 30))
        echo "crt0.asm:${crt_ln}:"
        sed -n "${crt_ln},${end_ln}p" "$CRT"
        return
    fi

    echo "error: no function '$name' found in bios.c or crt0.asm." >&2
    exit 1
}

cmd_addr() {
    local target="${1#0x}"
    target="${target#0X}"
    local target_dec=$((16#$target))

    # Build table into temp file to avoid subshell variable scoping
    local tmpfile
    tmpfile=$(mktemp)
    build_func_table > "$tmpfile"

    local prev_name="" result=""
    while IFS=$'\t' read -r lineno addr func; do
        [ "$addr" = "????" ] && continue
        local addr_dec=$((16#$addr))
        if [ "$addr_dec" -gt "$target_dec" ] && [ -n "$prev_name" ]; then
            result="$prev_name"
            break
        fi
        prev_name="$func"
    done < "$tmpfile"
    rm -f "$tmpfile"

    # If no function had a higher address, target is in the last function
    [ -z "$result" ] && result="$prev_name"

    if [ -n "$result" ]; then
        echo "$result"
    else
        echo "error: address 0x$target not found." >&2
        return 1
    fi
}

cmd_search() {
    # Output with lis file prefix for IntelliJ clickability
    grep -n -i "$1" "$LIS" | sed "s|^|bios.c.lis:|" | head -40
}

case "${1:-}" in
    -l|--list)     cmd_list ;;
    -s|--search)   [ -z "${2:-}" ] && { echo "Usage: $0 -s <pattern>" >&2; exit 1; }; cmd_search "$2" ;;
    -a|--addr)     [ -z "${2:-}" ] && { echo "Usage: $0 -a <hex_addr>" >&2; exit 1; }
                   func=$(cmd_addr "$2")
                   if [ -n "$func" ]; then echo "$func"; echo ""; cmd_show "$func"; fi ;;
    -c|--source)   [ -z "${2:-}" ] && { echo "Usage: $0 -c <function>" >&2; exit 1; }; cmd_source "$2" ;;
    -h|--help|"")  sed -n '2,12p' "$0" ;;
    -*)            echo "Unknown option: $1" >&2; sed -n '2,12p' "$0"; exit 1 ;;
    *)             cmd_show "$1" ;;
esac
