---
name: reference_z88dk_rc700_wiki
description: TODO-later — opdater z88dk wiki-siden for RC700 med de nye diskformater og llvmz80-understøttelse
metadata:
  type: reference
---

**z88dk wiki: Platform-Regnecentralen-RC700**
https://github.com/z88dk/z88dk/wiki/Platform-Regnecentralen-RC700

TODO-later: opdater siden (eller opret den hvis den mangler) med:
- De nye diskformater `rc700-5dd`, `rc700-8dd`, `rc700-8sd`, `rc703-qd`
- At `+cpm -subtype=rc700` ikke længere auto-genererer disk (eksplicit `+cpmdisk -f <format>`)
- llvmz80-backend som alternativ compiler til `+cpm -subtype=rc700`
- Link til `CALLING_CONVENTION.md` og bridge-lag

Trigger: før eller i forbindelse med en upstream PR til z88dk for diskformat-ændringerne.
