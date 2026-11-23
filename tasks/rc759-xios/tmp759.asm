; ===========================================================================
; Regnecentralen RC759 Piccoline — TMP759.RSP (Terminal Message Processor)
;
; Rekonstrueret og reverse-engineeret kildetekst for TMP759.RSP fra
; SW1400 CCP/M-86 release 3.1 (SW1400 Disk 2/4).
;
; WHAT:
;   Resident System Process (RSP), der udgør Piccolines kommandofortolker (CLI).
;   Erstatter DRI's primitive 2 KB TMP.A86 stub med en fuld, resident 7.168 bytes
;   kommandoprocessor.
;
; FEATURES:
;   - 22 indbyggede kommandoopslag (danske og engelske synonymer):
;       USER/BRUGER, PRINTER/SKRIVER, SIZE, DIR, ABORT,
;       NETON/TILMELD, NETOFF/AFMELD, LOGON/OPRET, LOGOFF/AFBRYD,
;       NAVNGIV/NET, LOCAL/LOKAL, SCREEN, LINE, ?
;   - Fuld dansk lokalisering af alle BDOS disk-, fil- og systemfejlmeddelelser
;     (kodet i dansk 7-bit ASCII med { = æ, | = ø, } = å).
;   - RC-Net integration via standard DR-NET BDOS kald (INT 0E0h, CL=40h..4Ah)
;     og opslag i NAMSVR.DAT / PASSWORD.
;   - Multi-konsol håndtering for Piccolines 4 virtuelle skærme og startfiler
;     (STARTUP.0 .. STARTUP.3).
;   - Rulningskontrol mod SCROLL.RSP (Intel 82730 tekstprocessor / DMA kanal 0).
;
; BYGGEVEJLEDNING:
;   DOCKER_HOST="unix:///Users/ravn/.docker/run/docker.sock" docker run --rm \
;     -v "$(pwd):/work" -w /work rc759-nasm \
;     nasm -f bin -o /work/tasks/rc759-xios/tmp759.bin /work/tasks/rc759-xios/tmp759.asm
;   cmp tasks/rc759-xios/tmp759.bin scratch/tmp/dist/TMP759.RSP
; ===========================================================================

bits 16
org 0

; ISO-646-DK tegnkonstanter for RC759 Piccoline
%define æ 0x7B
%define ø 0x7C
%define å 0x7D
%define Æ 0x5B
%define Ø 0x5C
%define Å 0x5D

%include "tasks/rc759-xios/hardware.inc"

; ---------------------------------------------------------------------------
; CP/M-86 CMD fil-header (128 bytes)
; ---------------------------------------------------------------------------
cmd_header:
  db 0x01                                      ; Group 1: Code group
  dw 0x016F                                    ; Code length: 367 paragraphs (5.872 bytes)
  dw 0x0000                                    ; Code base paragraph (relokerbar)
  dw 0x016F                                    ; Code min alloc
  dw 0x0000                                    ; Code max alloc
  db 0x02                                      ; Group 2: Data group
  dw 0x0046                                    ; Data length: 70 paragraphs (1.120 bytes)
  dw 0x0000                                    ; Data base paragraph (relokerbar)
  dw 0x0046                                    ; Data min alloc
  dw 0x0000                                    ; Data max alloc
  times 128 - ($ - cmd_header) db 0            ; Resterende header udfyldes med nuller

; ---------------------------------------------------------------------------
; CODE GROUP (Offset 0x0080 i filen, 5.872 bytes)
; ---------------------------------------------------------------------------
code_start:
%include "tasks/rc759-xios/rsp_tmp759.asm"
times 5872 - ($ - code_start) db 0

; ---------------------------------------------------------------------------
; DATA GROUP (Offset 0x1770 i filen, 1.120 bytes)
; ---------------------------------------------------------------------------
data_start:
%include "tasks/rc759-xios/rsp_tmp759_data.asm"
times 1120 - ($ - data_start) db 0

; ---------------------------------------------------------------------------
; Pad til 128-byte blokgrænse (56 records = 7.168 bytes)
; ---------------------------------------------------------------------------
times 7168 - ($ - cmd_header) db 0
