---
name: Concurrent CP/M Programmer's Reference Guide (DRI, Jan 1984) — cached
description: Authoritative Concurrent CP/M (incl. CP/M-86 BDOS/XIOS) programmer's reference, DRI original Jan84, cached in the workspace.
metadata:
  type: reference
---

**Digital Research — Concurrent CP/M Operating System Programmer's Reference
Guide**, January 1984 (DRI doc 1034-2023), 357 pages. Good-quality bitsavers
scan; user pointed to it 2026-08-15 as the high-quality copy.

Cached locally (per the caching directive):
- **`open-watcom-v2/contrib/ravn/Concurrent_CPM_Programmers_Reference_Guide_Jan84.pdf`**
  (9.95 MB, PDF 1.3). Origin:
  `bitsavers.../pdf/digitalResearch/concurrent_cpm/1034-2023_Concurrent_CPM_Programmers_Reference_Guide_Jan84.pdf`.
  **Do NOT re-download.**
- **`..._Jan84.txt`** (492 KB, 11.5k lines) — text extraction of all 357 pages
  (embedded text layer, no OCR needed; pypdf). Form-feed `--- page N ---` markers
  per page. System calls are in **Section 6** (6.2 Concurrent CP/M System Calls:
  6.2.1 Console I/O …); grep it for BDOS/XIOS call details. **Do NOT re-extract.**

This is the DRI ORIGINAL; the workspace also has the Siemens reprint
`open-watcom-v2/contrib/ravn/Siemens_Concurrent_CPM-86_Programmers_Reference_Guide.pdf`
(+ .txt) and the plain CP/M-86 books `CPM-86_Programmers_Guide_Jan83.{pdf,txt}` /
`CPM-86_System_Guide_Jun83.{pdf,txt}`.

Authoritative for the native Watcom CP/M-86 work: BDOS/XIOS call numbers &
semantics, the .CMD header/group format, memory allocation, and the interrupt/
IVT conventions (`[[reference_cpm86_interrupt_vector_install]]`,
`[[reference_cpm86_cmd_header]]`, `[[reference_watcom_wlink_cpm86_format]]`).
