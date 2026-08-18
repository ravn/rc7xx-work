#!/usr/bin/env python3
"""Read Aztec C86 `obd` object-dump output on stdin, print the module code size.

Aztec's object dumper (`aztecNN_obd`) lists every function as
`... Block start, ends @ NNNN` where NNNN is the CUMULATIVE end offset -- obd
lays functions end-to-end, so the LARGEST end offset is the whole module's
code size. (Do NOT sum the per-block ends; they are cumulative.)
"""
import sys, re

ends = [int(x, 16) for x in re.findall(r'ends @ *([0-9a-fA-F]+)', sys.stdin.read())]
print(max(ends) if ends else 0)
