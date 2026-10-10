#!/usr/bin/env python3
"""Verify that hand-written skew tables in bios.c match the CP/M skew algorithm.

Analog of the DRI assembler macro that generated XLT tables from (SPT, SKEW).
We don't emit the tables (they stay hand-written for readability); instead,
this script is called from the Makefile as a build-time correctness check.

Exit status 0 on match, non-zero on mismatch (which fails the build).
"""

import re
import sys
from pathlib import Path

# (variable name, sectors-per-track, skew factor, description)
FORMATS = [
    ("xlt_maxi_128",  26, 6, '8" FM 128 B/S, skew 6 (boot track)'),
    ("xlt_maxi_512",  15, 4, '8" DD 512 B/S, skew 4 (data area)'),
    ("xlt_mini_512",  9, 2, '5.25" DD 512 B/S, skew 2'),
    ("xlt_identity", 26, 1, '8" DD 256 B/S, identity (skew 1)'),
]


def skew_table(spt, skew):
    """CP/M sector-skew algorithm: start at sector 1, step by `skew`, skip placed."""
    table, cur = [], 1
    for _ in range(spt):
        while cur in table:
            cur = cur + 1 if cur < spt else 1
        table.append(cur)
        cur = ((cur - 1 + skew) % spt) + 1
    return table


def extract_table(source: str, name: str) -> list[int]:
    """Pull a `const byte NAME[] = { ... };` array out of C source."""
    m = re.search(
        rf"const\s+byte\s+{re.escape(name)}\s*\[\s*\]\s*=\s*\{{([^}}]*)\}}",
        source,
        re.DOTALL,
    )
    if not m:
        raise ValueError(f"table '{name}' not found in source")
    body = m.group(1)
    # Strip C comments and whitespace, split on commas.
    body = re.sub(r"/\*.*?\*/", "", body, flags=re.DOTALL)
    body = re.sub(r"//[^\n]*", "", body)
    return [int(x.strip()) for x in body.split(",") if x.strip()]


def main(bios_c_path: Path) -> int:
    source = bios_c_path.read_text()
    failures = 0
    for name, spt, skew, desc in FORMATS:
        actual = extract_table(source, name)
        expected = skew_table(spt, skew)
        if actual == expected:
            print(f"  OK  {name:7s} ({spt:2} sectors, skew {skew}) — {desc}")
        else:
            failures += 1
            # Send failures to stderr so Makefile builds surface them even
            # when stdout is redirected to /dev/null.
            print(f"  FAIL {name:7s} ({spt:2} sectors, skew {skew}) — {desc}", file=sys.stderr)
            print(f"       expected: {expected}", file=sys.stderr)
            print(f"       actual:   {actual}", file=sys.stderr)
    if failures:
        print(f"\n{failures} skew table(s) do not match the algorithm.", file=sys.stderr)
        return 1
    print(f"\nAll {len(FORMATS)} skew tables match the CP/M algorithm.")
    return 0


if __name__ == "__main__":
    bios_c = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).parent / "bios.c"
    sys.exit(main(bios_c))
