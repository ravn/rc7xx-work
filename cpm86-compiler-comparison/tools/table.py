#!/usr/bin/env python3
"""Aggregate `bench|compiler|label|bytes` rows (from each per-compiler Makefile's
`sizes` target) into a per-benchmark code-size table."""
import sys, collections

rows = collections.OrderedDict()
for line in sys.stdin:
    line = line.strip()
    if line.count('|') != 3:
        continue
    b, comp, label, by = line.split('|')
    rows.setdefault(b, []).append((comp, label, by))

order = ['sieve', 'dhry', 'whet', 'aes256']
for b in sorted(rows, key=lambda x: order.index(x) if x in order else 99):
    print("=== %s -- module code size (bytes), small model unless noted ===" % b)
    print("%-20s %-12s %s" % ("compiler", "opt/model", "code bytes"))
    for comp, label, by in rows[b]:
        print("%-20s %-12s %s" % (comp, label, by))
    print()
