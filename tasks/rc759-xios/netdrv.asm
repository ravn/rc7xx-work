bits 16
org 0

; ---------------------------------------------------------------------------
; CP/M-86 CMD Header (128 bytes)
; ---------------------------------------------------------------------------
cmd_header:
  ; Gruppe 1: Code Group (type 1)
  db 1                                          ; G-Form: 1 = Code Group
  dw 0x0447                                     ; G-Length: 1095 paragraffer = 17.520 bytes
  dw 0x0000                                     ; G-Base: 0 (relokerbar)
  dw 0x0447                                     ; G-Min: minimum hukommelse i paragraffer
  dw 0x0000                                     ; G-Max: 0

  ; Gruppe 0: End of Group descriptors
  db 0                                          ; Slut paa gruppe-deskriptorer

  times 118 db 0

; ---------------------------------------------------------------------------
; Gruppe 1: Code Group (17.520 bytes)
; ---------------------------------------------------------------------------
code_start:
%include "rsp_netdrv_code.asm"
code_end:

; ---------------------------------------------------------------------------
; Padding til 128-byte blokgraense (17.664 bytes total = 138 records)
; ---------------------------------------------------------------------------
times 16 db 0
