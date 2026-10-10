#!/usr/bin/env python3
"""Verify that relocate_bios() and any function it transitively calls
don't spill to BSS frame slots.

The BSS area is being cleared inside relocate_bios(), so any function-local
BSS spill (__sframe_*/__sfrend_*) used during this function would be
clobbered mid-execution. This caused #51 (boot banner missing).

Usage:
    python3 check_no_bss_in_relocate.py rcbios-in-c/bios.lis

Exits 0 if clean, 1 if BSS spills are found in pre-relocation code.
"""

import re
import sys
from pathlib import Path

# Functions that run BEFORE the BSS is fully cleared.
# Anything called from these (transitively) must not use BSS spills.
PRE_RELOC_FUNCS = {"_relocate_bios"}

def parse_listing(path):
    """Return dict mapping function name → (start_addr, lines)."""
    funcs = {}
    cur_name = None
    cur_lines = []
    cur_addr = None
    func_re = re.compile(r"^([0-9a-f]+) <(_[a-zA-Z_][a-zA-Z0-9_]*)>:")
    for line in Path(path).read_text().splitlines():
        m = func_re.match(line)
        if m:
            if cur_name:
                funcs[cur_name] = (cur_addr, cur_lines)
            cur_name = m.group(2)
            cur_addr = int(m.group(1), 16)
            cur_lines = []
        elif cur_name:
            cur_lines.append(line)
    if cur_name:
        funcs[cur_name] = (cur_addr, cur_lines)
    return funcs

def find_callees(lines):
    """Return set of function addresses called from these lines."""
    callees = set()
    call_re = re.compile(r"\s+call\s+\$([0-9a-f]+)")
    for line in lines:
        m = call_re.search(line)
        if m:
            callees.add(int(m.group(1), 16))
    return callees

def has_bss_frame_access(lines):
    """Return list of (line, slot_name) for any BSS frame slot reference."""
    # Match comments like "; 0xec59 <__sframe_funcname>" or "<__sfrend_funcname>"
    pat = re.compile(r"<(__sframe_[a-zA-Z_]\w*|__sfrend_[a-zA-Z_]\w*)")
    hits = []
    for line in lines:
        m = pat.search(line)
        if m:
            hits.append((line.strip(), m.group(1)))
    return hits

def main():
    if len(sys.argv) != 2:
        print(f"usage: {sys.argv[0]} bios.lis", file=sys.stderr)
        sys.exit(2)

    funcs = parse_listing(sys.argv[1])
    addr_to_name = {addr: name for name, (addr, _) in funcs.items()}

    # Build the transitive call set starting from PRE_RELOC_FUNCS
    visited = set()
    queue = list(PRE_RELOC_FUNCS)
    while queue:
        name = queue.pop()
        if name in visited or name not in funcs:
            continue
        visited.add(name)
        addr, lines = funcs[name]
        for callee_addr in find_callees(lines):
            callee_name = addr_to_name.get(callee_addr)
            if callee_name and callee_name not in visited:
                queue.append(callee_name)

    # Check each function for BSS frame spills
    failures = 0
    for name in sorted(visited):
        _, lines = funcs[name]
        hits = has_bss_frame_access(lines)
        if hits:
            print(f"FAIL: {name} accesses BSS frame slots:")
            for line, slot in hits:
                print(f"  {slot}: {line}")
            failures += 1

    if failures:
        print(f"\n{failures} function(s) with BSS spills in pre-relocation code.")
        print("This will clobber BSS during relocate_bios() — see #51, #53.")
        sys.exit(1)

    print(f"OK: {len(visited)} pre-relocation function(s) have no BSS frame spills:")
    for name in sorted(visited):
        print(f"  {name}")

if __name__ == "__main__":
    main()
