; z88dk_section_layout.asm — Section ordering and origin addresses for z88dk linker.
;
; All code and data are in C files. This file defines only the binary
; layout: section ordering and origin addresses that z88dk requires.
;
; BOOT sections (physical address 0x0000, loaded by ROM from Track 0):
;   BOOT       — boot header: pointer, signature, builddate (boot_block.c)
;   BOOT_DATA  — CONFI defaults + conversion tables (boot_confi.c)
;   BOOT_CODE  — cold boot code: coldboot(), LDIR helpers (boot_entry.c)
;
; BIOS section (runtime address BIOSAD, relocated by coldboot):
;   BIOSAD is passed from the Makefile via -Ca-DBIOSAD=0xNNNN
;   BIOS       — JP table + JTVARS (const struct from bios_jump_vector_table.c)
;   code_compiler, rodata_compiler, data_compiler — compiled C code
;
; BSS (not stored on disk, zeroed by coldboot):
;   BSS, bss_compiler

    SECTION BOOT
    org 0x0000

    SECTION BOOT_DATA
    SECTION BOOT_CODE

    SECTION BIOS
    org BIOSAD              ; derived from MSIZE in Makefile

    SECTION code_compiler
    SECTION rodata_compiler
    SECTION data_compiler
    SECTION code_l_sccz80
    SECTION code_clib
    SECTION code_string

    ; Sentinel word: verified by verify_relocation() after BSS clear (#51).
    ; Must be between last data and BSS.
    SECTION SENTINEL
GLOBAL __sentinel_addr
__sentinel_addr:
    defw 0x1842

    SECTION BSS
    SECTION bss_compiler
