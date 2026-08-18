#!/usr/bin/env python3
"""Aggregate `bench|compiler|label|value` rows (from each per-compiler Makefile's
`sizes`/`speed` target) into a per-benchmark table.

Usage: table.py [title] [column]
  default -- code-size table.
  speed   -- table.py "80186 clocks/iteration (differential, lower is faster)" "clk/iter"
"""
import sys, collections

title = sys.argv[1] if len(sys.argv) > 1 else \
    "module code size (bytes), small model unless noted"
column = sys.argv[2] if len(sys.argv) > 2 else "code bytes"

rows = collections.OrderedDict()
for line in sys.stdin:
    line = line.strip()
    if line.count('|') != 3:
        continue
    b, comp, label, by = line.split('|')
    rows.setdefault(b, []).append((comp, label, by))

order = ['sieve', 'dhry', 'whet', 'aes256']
for b in sorted(rows, key=lambda x: order.index(x) if x in order else 99):
    print("=== %s -- %s ===" % (b, title))
    print("%-20s %-12s %s" % ("compiler", "opt/model", column))
    for comp, label, by in rows[b]:
        print("%-20s %-12s %s" % (comp, label, by))
    print()
