#!/bin/bash
cd /work/pages
for p in p-*.png; do
    out="${p%.png}"
    [ -f "${out}.txt" ] && continue
    tesseract "$p" "$out" -l dan+eng 2>/dev/null
done
