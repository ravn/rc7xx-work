; ccpm.sys — PICCOLINE CCPM 3.1 reassembly
; Master assembly file (modulariseret opdelt i rene moduler)
; Assemblér: nasm -f bin -o ccpm_out.sys ccpm.asm

BITS 16
ORG 0x0000

%define CCPM_SYS 1

; ISO-646-DK tegnkonstanter for RC759 Piccoline
; Giver mulighed for at skrive æ, ø, å, Æ, Ø, Å direkte i tekster,
; så NASM genererer Piccolines 7-bit koder (0x7B, 0x7C, 0x7D, 0x5B, 0x5C, 0x5D).
%define æ 0x7B
%define ø 0x7C
%define å 0x7D
%define Æ 0x5B
%define Ø 0x5C
%define Å 0x5D

%include "rasm86.inc"

; Modul 0: Supervisor & Real-Time Monitor (SUP+RTM)
%include "mod0_rtm.asm"

; Modul 1: BDOS File System
%include "mod1_bdos.asm"

; Modul 2: Memory Manager (MEMIF.MEM)
%include "mod2_mem.asm"

; Modul 3: Character I/O (CIOIF.CIO)
%include "mod3_cio.asm"

; Modul 4: RC759 Hardware XIOS & SYSDAT
; Del A: DRI XIOS Dispatcher og Interface (0x03AD0 - 0x0779F)
%include "mod4_xiosif.asm"

; Del B: RC759 Hardware XIOS Driver (Flemming Kraglund, 0x077A0 - 0x0CED0)
; Fælles kanonisk kildekode delt med XIOS1.CON og XIOS4.CON.
section xios_code vstart=0x0C00 align=1
%define NUM_VIR_CONS 1
sysdat_dispatcher        equ 0x38
sysdat_endseg            equ 0x44
sysdat_srchdisk          equ 0x4b
sysdat_tempdisk          equ 0x50
sysdat_mdul              equ 0x58
sysdat_mfl               equ 0x5a
sysdat_rlr               equ 0x68
sysdat_tod_day           equ 0x7e
sysdat_tod_hr            equ 0x80
sysdat_tod_min           equ 0x81
sysdat_tod_sec           equ 0x82
sysdat_nlstdev           equ 0x88
sysdat_openvec           equ 0x8c
sysdat_abort_vec         equ 0xa0
sysdat_int_vec           equ 0xa2
sysdat_err_intercept     equ 0xa4
sysdat_err_intercept_seg equ 0xa6
%include "xios_code.asm"

; Del C: XIOS Allokeret Databuffer & Systemtabeller (0x0CED0 - 0x0FD3F)
section xios_tail vstart=0x0CED0 align=1
%include "mod4_xios_data.asm"

; ===========================================================================
; Resident System Processes (RSP):
; ===========================================================================
section rsps vstart=0x0FD40 align=1

; RSP 1: TMP759 — Terminal Message Processor (Piccoline CLI / kommandofortolker)
%include "rsp_tmp759.asm"

; RSP 2: CLOCK — Tids- og datostyring via system-tick (venter på Flag 2)
%include "rsp_clock.asm"

; RSP 3: PIN — Process INput (tastatur- og linjeeditering for Piccoline)
%include "rsp_pin_data.asm"
%include "rsp_pin_code.asm"

; RSP 4: VOUT — Virtual OUTput multiplexer (skærmoutput)
%include "rsp_vout_data.asm"
%include "rsp_vout_code.asm"

; RSP 5: SCROLL — Blød rulning via Intel 82730 tekstprocessor og MXdma0
%include "rsp_scroll_data.asm"
%include "rsp_scroll.asm"
