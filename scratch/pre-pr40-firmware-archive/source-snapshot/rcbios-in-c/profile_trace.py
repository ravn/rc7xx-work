#!/usr/bin/env python3
"""Post-process a MAME instruction trace into a profiling report.

Usage:
    python3 profile_trace.py /tmp/bios_trace.log [map_file]

Input:  MAME trace file (format: "ADDR: INSTRUCTION ..." per line)
Output: Function-level and instruction-level profiles to stdout,
        raw histogram to /tmp/bios_profile_hist.txt
"""
import sys
import re
from collections import Counter

def load_symbols(map_file):
    """Load symbols from z88dk .map file (format: _name = $XXXX ; ...)"""
    syms = []
    try:
        with open(map_file) as f:
            for line in f:
                m = re.match(r'(\w+)\s*=\s*\$([0-9A-Fa-f]+)', line)
                if m:
                    syms.append((int(m.group(2), 16), m.group(1)))
    except FileNotFoundError:
        pass
    syms.sort()
    return syms

def addr_to_func(addr, syms):
    """Map address to nearest symbol (binary search)."""
    lo, hi = 0, len(syms) - 1
    best = None
    while lo <= hi:
        mid = (lo + hi) // 2
        if syms[mid][0] <= addr:
            best = mid
            lo = mid + 1
        else:
            hi = mid - 1
    if best is not None:
        return syms[best][1], addr - syms[best][0]
    return f"0x{addr:04X}", 0

def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    trace_file = sys.argv[1]
    map_file = sys.argv[2] if len(sys.argv) > 2 else None

    syms = load_symbols(map_file) if map_file and map_file != "none" else []

    # Parse trace file: extract PC from each line
    # MAME format: "XXXX: INSTRUCTION" or "  XXXX: INSTRUCTION"
    pc_re = re.compile(r'^\s*([0-9A-Fa-f]{4}):')
    pc_counts = Counter()
    total_insns = 0

    print(f"Reading {trace_file}...", file=sys.stderr)
    with open(trace_file) as f:
        for line in f:
            m = pc_re.match(line)
            if m:
                addr = int(m.group(1), 16)
                pc_counts[addr] += 1
                total_insns += 1

    if total_insns == 0:
        print("No instructions found in trace file.", file=sys.stderr)
        sys.exit(1)

    print(f"Total instructions: {total_insns:,}", file=sys.stderr)

    # Build function-level profile
    func_counts = Counter()
    for addr, count in pc_counts.items():
        func_name, _ = addr_to_func(addr, syms)
        func_counts[func_name] += count

    # Address range breakdown
    bios_insns = sum(c for a, c in pc_counts.items() if 0xDA00 <= a <= 0xFFFF)
    bdos_insns = sum(c for a, c in pc_counts.items() if 0xCC06 <= a < 0xDA00)
    ccp_insns = sum(c for a, c in pc_counts.items() if 0xC400 <= a < 0xCC06)
    tpa_insns = sum(c for a, c in pc_counts.items() if a < 0xC400)

    print(f"\n{'='*60}")
    print(f"Instruction Profile ({total_insns:,} total)")
    print(f"{'='*60}")
    print(f"\n--- Address Range Breakdown ---")
    print(f"  BIOS  (DA00-FFFF): {bios_insns:>12,}  {100*bios_insns/total_insns:5.1f}%")
    print(f"  BDOS  (CC06-D9FF): {bdos_insns:>12,}  {100*bdos_insns/total_insns:5.1f}%")
    print(f"  CCP   (C400-CC05): {ccp_insns:>12,}  {100*ccp_insns/total_insns:5.1f}%")
    print(f"  TPA   (0000-C3FF): {tpa_insns:>12,}  {100*tpa_insns/total_insns:5.1f}%")

    # Function-level profile (top 30)
    print(f"\n--- Function Profile (top 30) ---")
    print(f"{'Function':<35s} {'Instructions':>12s} {'%':>6s}")
    print(f"{'-'*35} {'-'*12} {'-'*6}")
    for name, count in func_counts.most_common(30):
        print(f"{name:<35s} {count:>12,} {100*count/total_insns:5.1f}%")

    # Instruction-level hotspots (top 30 addresses)
    print(f"\n--- Instruction Hotspots (top 30) ---")
    print(f"{'Address':<8s} {'Function+Offset':<35s} {'Count':>12s} {'%':>6s}")
    print(f"{'-'*8} {'-'*35} {'-'*12} {'-'*6}")
    for addr, count in pc_counts.most_common(30):
        func_name, offset = addr_to_func(addr, syms)
        label = f"{func_name}+{offset}" if offset else func_name
        print(f"0x{addr:04X}  {label:<35s} {count:>12,} {100*count/total_insns:5.1f}%")

    # BIOS-only function profile (filter to DA00+)
    bios_funcs = {k: v for k, v in func_counts.items()
                  if any(0xDA00 <= a <= 0xFFFF for a, _ in [(0,0)] +
                         [(a, c) for a, c in pc_counts.items()
                          if addr_to_func(a, syms)[0] == k])}
    if bios_funcs and bios_insns > 0:
        print(f"\n--- BIOS Function Profile (top 20) ---")
        print(f"{'Function':<35s} {'Instructions':>12s} {'% of BIOS':>9s}")
        print(f"{'-'*35} {'-'*12} {'-'*9}")
        for name, count in sorted(bios_funcs.items(), key=lambda x: -x[1])[:20]:
            print(f"{name:<35s} {count:>12,} {100*count/bios_insns:7.1f}%")

    # Write raw histogram for external tools
    hist_file = "/tmp/bios_profile_hist.txt"
    with open(hist_file, "w") as f:
        f.write("# addr\tcount\tfunction\n")
        for addr in sorted(pc_counts.keys()):
            func_name, offset = addr_to_func(addr, syms)
            f.write(f"0x{addr:04X}\t{pc_counts[addr]}\t{func_name}+{offset}\n")
    print(f"\nRaw histogram written to {hist_file}", file=sys.stderr)

if __name__ == "__main__":
    main()
