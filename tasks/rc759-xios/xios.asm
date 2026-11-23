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
org 0

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

; -----------------------------------------------------------------------------
; CCP/M-86 .CMD Header (128 bytes)
; Gruppe 1: Code group. Paragraf-størrelse afhænger af antal virtuelle konsoller.
; -----------------------------------------------------------------------------
cmd_header:
  db 1                                         ; G-gruppe (Code group)
%if NUM_VIR_CONS == 1
  dw 0x0633                                    ; Længde i paragraffer (25.392 bytes)
  dw 0x0000                                    ; Min ekstra paragraffer
  dw 0x0633                                    ; Max ekstra paragraffer
%else
  dw 0x0719                                    ; Længde i paragraffer (29.072 bytes)
  dw 0x0000                                    ; Min ekstra paragraffer
  dw 0x0719                                    ; Max ekstra paragraffer
%endif
  dw 0x0000                                    ; Ekstra segment
  db 0
  times 115 db 0
%if NUM_VIR_CONS == 1
  db 0xc8, 0x00, 0x80
%else
  db 0xe5, 0x00, 0x80
%endif

; -----------------------------------------------------------------------------
; SYSDAT Reservation Prefix (3072 bytes / 0x0C00)
; Ulinket template, som udfyldes af GENCCPM under systemgenerering.
; -----------------------------------------------------------------------------
xios_code_base:
xios_prefix:
  times 0x8c db 0
  dw 0xffff
  times (3072 - 0x8e) db 0

; -----------------------------------------------------------------------------
; XIOS Driver Code
; -----------------------------------------------------------------------------
%if NUM_VIR_CONS == 1
  %include "xios_code.asm"

xios_tail:
  times 80 db 0
  db 0x11, 0x32, 0x04, 0x07, 0x11, 0x32, 0x04, 0x0b
  times 120 db 0
%else
  %include "xios4_code.asm"
%endif
