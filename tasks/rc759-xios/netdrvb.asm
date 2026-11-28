bits 16

; =============================================================================
; Regnecentralen RC759 Piccoline — NETDRVB.RSP (Revision B)
; RC-Net Datalink Driver for Intel 82586 Ethernet LAN Controller (Revision B)
; 1413 paragraffer = 22.608 bytes payload, 22.784 bytes total
; Bygger via fælles master-kildetekst: rsp_netdrv_common.asm
; =============================================================================

%define NETDRV_REV 'B'

; ---------------------------------------------------------------------------
; CP/M-86 CMD Header (128 bytes)
; ---------------------------------------------------------------------------
section header vstart=0
cmd_header:
  ; Gruppe 1: Code Group (type 1)
  db 1                                          ; G-Form: 1 = Code Group
  dw 0x0585                                     ; G-Length: 1413 paragraffer = 22.608 bytes
  dw 0x0000                                     ; G-Base: 0 (relokerbar)
  dw 0x0585                                     ; G-Min: minimum hukommelse i paragraffer
  dw 0x0000                                     ; G-Max: 0

  ; Gruppe 0: End of Group descriptors
  db 0                                          ; Slut paa gruppe-deskriptorer

  times 118 db 0

; ---------------------------------------------------------------------------
; Gruppe 1: Code Group (22.608 bytes)
; ---------------------------------------------------------------------------
section text vstart=0
code_start:
%include "rsp_netdrv_common.asm"
code_end:

; ---------------------------------------------------------------------------
; Padding til 128-byte blokgraense (22.784 bytes total = 178 records)
; ---------------------------------------------------------------------------
section pad
times 48 db 0
