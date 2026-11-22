; ccpm.sys — PICCOLINE CCPM 3.1 reassembly
; Master assembly file (modulariseret opdelt i 5 MEMIF-moduler)
; Assemblér: nasm -f bin -o ccpm_out.sys ccpm.asm

BITS 16
ORG 0x0000

; ISO-646-DK tegnkonstanter for RC759 Piccoline
; Giver mulighed for at skrive æ, ø, å, Æ, Ø, Å direkte i tekster,
; så NASM genererer Piccolines 7-bit koder (0x7B, 0x7C, 0x7D, 0x5B, 0x5C, 0x5D).
%define æ 0x7B
%define ø 0x7C
%define å 0x7D
%define Æ 0x5B
%define Ø 0x5C
%define Å 0x5D

; Modul 0: Supervisor & Real-Time Monitor (SUP+RTM)
%include "mod0_rtm.asm"

; Modul 1: BDOS File System
%include "mod1_bdos.asm"

; Modul 2: Memory Manager (MEMIF.MEM)
%include "mod2_mem.asm"

; Modul 3: Character I/O (CIOIF.CIO)
%include "mod3_cio.asm"

; Modul 4: RC759 Hardware XIOS & SYSDAT (Flemming Kraglund)
%include "mod4_xios.asm"

; ===========================================================================
; Resident System Processes (RSP):
; ===========================================================================

; RSP 1: TMP759 — Terminal Message Processor (Piccoline CLI / kommandofortolker)
%include "rsp_tmp759.asm"

; RSP 2: CLOCK — Tids- og datostyring via system-tick (venter på Flag 2)
%include "rsp_clock.asm"

; RSP 3: PIN — Process INput (tastatur- og linjeeditering for Piccoline)
%include "rsp_pin.asm"

; RSP 4: VOUT — Virtual OUTput multiplexer (skærmoutput)
%include "rsp_vout.asm"

; RSP 5: SCROLL — Blød rulning via Intel 82730 tekstprocessor og MXdma0
%include "rsp_scroll.asm"

