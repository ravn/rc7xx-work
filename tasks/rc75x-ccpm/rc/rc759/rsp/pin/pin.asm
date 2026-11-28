; ===========================================================================
; Regnecentralen RC759 Piccoline — PIN.RSP
;
; Process INput (tastatur- og linjeeditering for Piccoline)
; SW1400 CCP/M-86 release 3.1
;
; Filformat: CP/M-86 .CMD format (128-byte header, kode-, data-grupper,
; afrundet til 128-byte blokstørrelse = 3.328 bytes / 26 records).
; ===========================================================================

bits 16
org 0

; ---------------------------------------------------------------------------
; CP/M-86 CMD Header (128 bytes)
; ---------------------------------------------------------------------------
cmd_header:
  ; Gruppe 1: Code Group (type 1)
  db 1                                          ; G-Form: 1 = Code Group
  dw 0x00a7                                     ; G-Length: 167 paragraffer = 2.672 bytes
  dw 0x0000                                     ; G-Base: 0 (relokerbar)
  dw 0x00a7                                     ; G-Min: minimum hukommelse i paragraffer
  dw 0x0000                                     ; G-Max: 0

  ; Gruppe 2: Data Group (type 2)
  db 2                                          ; G-Form: 2 = Data Group
  dw 0x001e                                     ; G-Length: 30 paragraffer = 480 bytes
  dw 0x0000                                     ; G-Base: 0 (relokerbar)
  dw 0x001e                                     ; G-Min: minimum hukommelse i paragraffer
  dw 0x0000                                     ; G-Max: 0

  ; Gruppe 0: End of Group descriptors
  db 0                                          ; Slut på gruppe-deskriptorer

  ; Udfyld resten af 128-byte headeren med nuller
  times (128 - ($ - cmd_header)) db 0

; ---------------------------------------------------------------------------
; Gruppe 1: Code Group (2.672 bytes)
; ---------------------------------------------------------------------------
code_start:
%include "rsp_pin_code.asm"
code_end:

; ---------------------------------------------------------------------------
; Gruppe 2: Data Group (480 bytes)
; ---------------------------------------------------------------------------
data_start:
%include "rsp_pin_data.asm"
data_end:

; ---------------------------------------------------------------------------
; Padding til 128-byte blokgrænse (3.328 bytes total = 26 records á 128 bytes)
; ---------------------------------------------------------------------------
times (3328 - ($ - $$)) db 0
