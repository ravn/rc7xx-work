bits 16
org 0

%define æ 0x7B
%define ø 0x7C
%define å 0x7D
%define Æ 0x5B
%define Ø 0x5C
%define Å 0x5D
%include "hardware.inc"

cmd_header:
  db 1
  dw 0x0719
  dw 0x0000
  dw 0x0719
  dw 0x0000
  db 0
  times 115 db 0
  db 0xe5, 0x00, 0x80

xios_code_base:
xios_prefix:
  times 0x8c db 0
  dw 0xffff
  times (3072 - 0x8e) db 0

%include "xios4_code.asm"
