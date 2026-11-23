; ===========================================================================
; Regnecentralen RC759 Piccoline — CLOCK.RSP (Time-of-Day Clock Driver)
;
; Rekonstrueret og reverse-engineeret kildetekst for CLOCK.RSP fra
; SW1400 CCP/M-86 release 3.1 (SW1400 Disk 2/4).
;
; WHAT:
;   Resident System Process (RSP), der udfører tids- og datostyring via
;   systemtick. Venter på System Flag 2 (sekund-tick fra XIOS), opdaterer
;   XIOS statuslinje (funktion 8) og vedligeholder Time-of-Day (TOD)
;   strukturen i SYSDAT (sekunder, minutter, timer i BCD samt dage binært).
;
; BYGGEVEJLEDNING:
;   DOCKER_HOST="unix:///Users/ravn/.docker/run/docker.sock" docker run --rm \
;     -v "$(pwd):/work" -w /work rc759-nasm \
;     nasm -f bin -o /work/tasks/rc759-xios/clock.bin /work/tasks/rc759-xios/clock.asm
;   cmp tasks/rc759-xios/clock.bin scratch/tmp/dist/CLOCK.RSP
; ===========================================================================

bits 16
org 0

%define CCPM_INT             0xE0 ; BDOS software-interrupt
%define F_FLAGWAIT           132  ; BDOS funktion 132: Flag Wait
%define SEC_FLAG             2    ; Flag 2: Sekund-tick fra XIOS

; Faste offsets i SYSDAT (DS peger på SYSDAT under kørsel)
%define SYSDAT_XIOSENTRY     0x28 ; SYSDAT:0x0028 - Far pointer (dword) til XIOS entry point
%define SYSDAT_RLR           0x68 ; SYSDAT:0x0068 - Ready List Root (pointer til aktiv PD)
%define SYSDAT_TOD           0x7E ; SYSDAT:0x007E - Time of Day (TOD) struktur
%define SYSDAT_NPCONS        0x9F ; SYSDAT:0x009F - Antal fysiske konsoller (npcons)

; Time of Day (TOD) struktur offsets (relativt til SYSDAT:0x007E)
%define TOD_DAY              0
%define TOD_HOUR             2
%define TOD_MIN              3
%define TOD_SEC              4

; XIOS sub-funktion
%define IO_STATLINE          8    ; XIOS funktion 8: Opdater konsol-statuslinje

; ---------------------------------------------------------------------------
; CP/M-86 CMD fil-header (128 bytes)
; ---------------------------------------------------------------------------
cmd_header:
  db 0x01                                      ; Group 1: Code group
  dw 0x0008                                    ; Code length: 8 paragraphs (128 bytes)
  dw 0x0000                                    ; Code base paragraph (relokerbar)
  dw 0x0008                                    ; Code min alloc
  dw 0x0000                                    ; Code max alloc
  db 0x02                                      ; Group 2: Data group
  dw 0x0014                                    ; Data length: 20 paragraphs (320 bytes)
  dw 0x0000                                    ; Data base paragraph (relokerbar)
  dw 0x0014                                    ; Data min alloc
  dw 0x0000                                    ; Data max alloc
  times 128 - ($ - cmd_header) db 0            ; Resterende header udfyldes med nuller

; ---------------------------------------------------------------------------
; CODE GROUP (Offset 0x0080 i filen, 128 bytes)
; ---------------------------------------------------------------------------
code_start:
clock_bdos_call:
  int CCPM_INT                                 ; 0x0000: INT 0xE0 til CCP/M-86 BDOS
  ret                                          ; 0x0002

clock_entry:
  mov ds, [0]                                  ; 0x0003: DS = SYSDAT segmentadresse (fra offset 0)
  mov dl, [SYSDAT_NPCONS]                      ; 0x0007: DL = Antal fysiske konsoller (npcons ved 0x009F)
  mov si, [SYSDAT_RLR]                         ; 0x000B: SI -> Ready List Root (aktuel kørende proces)
  mov es, [si + 0x10]                          ; 0x000F: ES -> UDA segment (p_uda)

clock_loop:
  push dx                                      ; 0x0012: Gem konsoltæller
  mov cx, F_FLAGWAIT                           ; 0x0013: CL = 132 (BDOS Flag Wait)
  mov dx, SEC_FLAG                             ; 0x0016: DX = Flag 2 (Sekund-tick)
  call clock_bdos_call                         ; 0x0019: Vent på sekundflag fra XIOS tick
  pop dx                                       ; 0x001C: Gendan konsoltæller

  ; Opdater statuslinje på en virtuel konsol per sekund (cirkulerer over alle konsoller)
  mov ax, IO_STATLINE                          ; 0x001D: AX = Funktion 8 (io_statline)
  db 0x33, 0xC9                                ; 0x0020: xor cx, cx
  cmp dl, 0                                    ; 0x0022: Er alle konsoller opdateret?
  jne clock_dec_console                        ; 0x0025: Hvis nej, tag næste
  mov dl, [SYSDAT_NPCONS]                      ; 0x0027: Hvis ja, genstart fra npcons

clock_dec_console:
  dec dl                                       ; 0x002B: Konsolindeks = DL - 1
  push dx                                      ; 0x002D: Gem konsoltæller
  call far [SYSDAT_XIOSENTRY]                  ; 0x002E: Far call til XIOS entry point (SYSDAT:0x0028)
  pop dx                                       ; 0x0032

  ; Opdater sekunder i Time-of-Day (TOD)
  mov bx, SYSDAT_TOD                           ; 0x0033: BX -> TOD struktur (SYSDAT:0x007E)
  clc                                          ; 0x0036: Ryd carry før BCD addition
  mov al, [bx + TOD_SEC]                       ; 0x0037: AL = Aktuelle sekunder (BCD)
  inc al                                       ; 0x003A: Inkrementér
  db 0x27                                      ; 0x003C: daa (Decimal Adjust for Addition)
  mov [bx + TOD_SEC], al                       ; 0x003D: Gem opdateret sekund
  cmp al, 0x60                                 ; 0x0040: Nået 60 sekunder?
  jae clock_update_min                         ; 0x0042: Ja -> opdater minut
  jmp near clock_loop                          ; 0x0044: Nej -> vent på næste sekundtick

clock_update_min:
  mov byte [bx + TOD_SEC], 0                   ; 0x0047: Nulstil sekunder
  clc                                          ; 0x004B
  mov al, [bx + TOD_MIN]                       ; 0x004C: AL = Aktuelle minutter (BCD)
  inc al                                       ; 0x004F
  db 0x27                                      ; 0x0051: daa
  mov [bx + TOD_MIN], al                       ; 0x0052: Gem opdateret minut
  cmp al, 0x60                                 ; 0x0055: Nået 60 minutter?
  jae clock_update_hour                        ; 0x0057: Ja -> opdater time
  jmp near clock_loop                          ; 0x0059: Nej -> vent på næste sekundtick

clock_update_hour:
  mov byte [bx + TOD_MIN], 0                   ; 0x005C: Nulstil minutter
  clc                                          ; 0x0060
  mov al, [bx + TOD_HOUR]                      ; 0x0061: AL = Aktuelle timer (BCD)
  inc al                                       ; 0x0064
  db 0x27                                      ; 0x0066: daa
  mov [bx + TOD_HOUR], al                      ; 0x0067: Gem opdateret time
  cmp al, 0x24                                 ; 0x006A: Nået 24 timer (midnat)?
  jae clock_update_day                         ; 0x006C: Ja -> opdater dag
  jmp near clock_loop                          ; 0x006E: Nej -> vent på næste sekundtick

clock_update_day:
  mov byte [bx + TOD_HOUR], 0                  ; 0x0071: Nulstil timer
  inc word [bx + TOD_DAY]                      ; 0x0075: Tæl dage op (binært 16-bit tal siden 01-01-1978)
  jmp near clock_loop                          ; 0x0077: Fortsæt uendelig løkke

times 128 - ($ - code_start) db 0

; ---------------------------------------------------------------------------
; DATA GROUP (Offset 0x0100 i filen, 320 bytes)
; ---------------------------------------------------------------------------
data_start:
  times 21 db 0                                ; +0x0000: Link / reserveret
  db 0xbe                                      ; +0x0015: p_prior (190)
  dw 0x0002                                    ; +0x0016: p_flag (pf_keep)
  db "CLOCK   "                                ; +0x0018: p_name (8 tegn)
  dw 0x0004                                    ; +0x0020: p_uda (4 paragraffer = 0x40 bytes)
  times 82 db 0                                ; +0x0022: PD reserveret

  ; User Data Area (UDA)
  dw 0x013a                                    ; +0x0074: p_sp (initial SP = 0x013A)
  times 42 db 0                                ; +0x0076: UDA scratch
  db 0x01, 0x00                                ; +0x00a0: INSYS
  times 152 db 0xcc                            ; +0x00a2: INT3 stakfyld op til 0x013A
  dw 0x0003                                    ; +0x013a: Initial IP = 0x0003
  dw 0x0000                                    ; +0x013c: Initial CS
  dw 0x0000                                    ; +0x013e: Initial Flags
  times 320 - ($ - data_start) db 0            ; Pad til præcis 320 bytes

; ---------------------------------------------------------------------------
; Pad til 128-byte blokgrænse (5 records = 640 bytes)
; ---------------------------------------------------------------------------
times 640 - ($ - cmd_header) db 0
