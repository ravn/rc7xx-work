; ccpm.sys — PICCOLINE CCPM 3.1 reassembly
; Master assembly file (modulariseret opdelt i 5 MEMIF-moduler)
; Assemblér: nasm -f bin -o ccpm_out.sys ccpm.asm

BITS 16
ORG 0x0000

; Modul 0: Supervisor & Real-Time Monitor (SUP+RTM)
%include "mod0_rtm.asm"

; Modul 1: BDOS File System
%include "mod1_bdos.asm"

; Modul 2: Memory Manager (MEMIF.MEM)
%include "mod2_mem.asm"

; Modul 3: Character I/O (CIOIF.CIO)
%include "mod3_cio.asm"

; Modul 4: RC759 Hardware XIOS & SYSDAT
%include "mod4_xios.asm"

