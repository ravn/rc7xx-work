; =============================================================================
; RC759 Piccoline CCP/M-86 XIOS (Extended I/O System)
; Oprindelig forfatter: Flemming Kraglund, Regnecentralen (1983-1984)
; =============================================================================
; Fælles master assembly-fil for RC759 XIOS:
;   NUM_VIR_CONS = 1 -> Genererer XIOS1.CON (25.728 bytes, 1 virtuel konsol)
;   NUM_VIR_CONS = 4 -> Genererer XIOS4.CON (29.440 bytes, 4 virtuelle konsoller)
;
; Assemblér med:
;   nasm -f bin -DNUM_VIR_CONS=1 -I. -o xios1.bin xios.asm
;   nasm -f bin -DNUM_VIR_CONS=4 -I. -o xios4.bin xios.asm
; =============================================================================

bits 16

%ifndef NUM_VIR_CONS
  %define NUM_VIR_CONS 1
%endif

%if NUM_VIR_CONS != 1 && NUM_VIR_CONS != 4
  %fatal "NUM_VIR_CONS skal være 1 eller 4"
%endif

; ISO-646-DK (Dansk 7-bit tegnsæt til RC759 Piccoline)
%define æ 0x7B
%define ø 0x7C
%define å 0x7D
%define Æ 0x5B
%define Ø 0x5C
%define Å 0x5D

; RC759 Hardware I/O Ports and Definitions
%include "hardware.inc"

; RASM-86 Instruction Encoding Compatibility Macros
%include "rasm86.inc"

; -----------------------------------------------------------------------------
; CCP/M-86 .CMD Header (128 bytes)
; Gruppe 1: Code group. Paragraf-størrelse beregnes dynamisk fra kodens længde.
; -----------------------------------------------------------------------------
section header vstart=0 align=1
cmd_header:
  db 1                                         ; G-gruppe (Code group)
  dw (xios_code_end - xios_code_base) / 16     ; Længde i paragraffer (dynamisk beregnet)
  dw 0x0000                                    ; Min ekstra paragraffer
  dw (xios_code_end - xios_code_base) / 16     ; Max ekstra paragraffer (dynamisk beregnet)
  dw 0x0000                                    ; Ekstra segment
  db 0
  times 115 db 0
  dw 1 + (xios_fixups - xios_code_base) / 128  ; ch_fixrec (record-nummer for fixup-tabel)
  db 0x80                                      ; ch_lbyte (bit 7 sat = fixups til stede)

; -----------------------------------------------------------------------------
; SYSDAT Reservation Prefix (3072 bytes / 0x0C00)
; Ulinket template, som udfyldes af GENCCPM under systemgenerering.
; Sektion text vstart=0 starter ved offset 0x0000 i CS (efter 128 bytes header).
; -----------------------------------------------------------------------------
section text vstart=0 align=1
xios_code_base:
xios_prefix:
  times 0x38 db 0
sysdat_dispatcher:
  dw 0, 0
  times (0x44 - 0x3c) db 0
sysdat_endseg:
  dw 0
  times (0x4b - 0x46) db 0
sysdat_srchdisk:
  db 0
  times (0x50 - 0x4c) db 0
sysdat_tempdisk:
  db 0
  times (0x58 - 0x51) db 0
sysdat_mdul:
  dw 0
sysdat_mfl:
  dw 0
  times (0x68 - 0x5c) db 0
sysdat_rlr:
  dw 0
  times (0x88 - 0x6a) db 0
sysdat_nlstdev:
  db 0
  times (0x8c - 0x89) db 0
sysdat_openvec:
  dw 0xffff
  times (0xa4 - 0x8e) db 0
sysdat_err_intercept:
  dw 0, 0
  times (3072 - 0xa8) db 0

; -----------------------------------------------------------------------------
; XIOS Driver Code
; -----------------------------------------------------------------------------
%include "xios_code.asm"

xios_code_end:

; -----------------------------------------------------------------------------
; Fixup-tabel og padding (align til 128-byte disk records)
; 4-byte poster genereres dynamisk fra adresserne på de relokerede far pointers.
; -----------------------------------------------------------------------------
%macro FIXUP_CODE 1
  db 0x11                                      ; Location group: Code, Target group: Code
  dw ((%1) - xios_code_base) / 16             ; Paragraf-offset i kodesegmentet
  db ((%1) - xios_code_base) % 16             ; Byte-offset i paragraffen
%endmacro

xios_tail:
  align 128, db 0
xios_fixups:
  FIXUP_CODE xios_fixup_target_1
  FIXUP_CODE xios_fixup_target_2
  align 128, db 0

