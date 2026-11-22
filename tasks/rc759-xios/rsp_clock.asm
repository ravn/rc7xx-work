; ===========================================================================
; RSP 2: CLOCK — Tids- og datostyring via system-tick (Digital Research)
; Placering i ccpm.sys: 0x11430 - 0x115EF (448 bytes = 28 paragraffer)
;   - Del 1: Data Segment (0x11430 - 0x1156F, 320 bytes: RSPHDR + PD + UDA)
;   - Del 2: Code Segment (0x11570 - 0x115EF, 128 bytes: kode)
;
; Kildeforlæg: Digital Research CCP/M-86 v3.1 "CLOCK.A86"
;
; Funktion:
;   Venter på System Flag 2 (sec_flag, sekund-tick fra XIOS).
;   For hvert sekund:
;     1. Kalder XIOS funktion 8 (io_statline) for at opdatere statuslinjen på
;        en virtuel konsol (cirkulerer over alle fysiske konsoller).
;     2. Tæller sekunder op i BCD i Time-of-Day (TOD) strukturen.
;     3. Ved 60 sekunder: nulstiller sekunder og tæller minutter op (BCD).
;     4. Ved 60 minutter: nulstiller minutter og tæller timer op (BCD).
;     5. Ved 24 timer (midnat): nulstiller timer og tæller dage op (16-bit word).
; ===========================================================================

%define CCPM_INT             0xE0 ; BDOS software-interrupt
%define F_FLAGWAIT           132  ; BDOS funktion 132: Flag Wait
%define F_FLAGSET            133  ; BDOS funktion 133: Flag Set

%define SEC_FLAG             2    ; Flag 2: Sekund-tick fra XIOS
%define MIN_FLAG             3    ; Flag 3: Minut-tick

; Faste offsets i SYSDAT (DS peger på SYSDAT under kørsel)
%define SYSDAT_XIOSENTRY     0x28 ; SYSDAT:0x0028 - Far pointer (dword) til XIOS entry point
%define SYSDAT_RLR           0x68 ; SYSDAT:0x0068 - Ready List Root (pointer til aktiv PD)
%define SYSDAT_TOD           0x7E ; SYSDAT:0x007E - Time of Day (TOD) struktur
%define SYSDAT_NPCONS        0x9F ; SYSDAT:0x009F - Antal fysiske konsoller (npcons)

; Time of Day (TOD) struktur offsets (relativt til SYSDAT:0x007E)
; Format:
;   +0: Dage siden 1. jan 1978 (word, binært tal)
;   +2: Timer (byte, BCD 00-23)
;   +3: Minutter (byte, BCD 00-59)
;   +4: Sekunder (byte, BCD 00-59)
%define TOD_DAY              0
%define TOD_HOUR             2
%define TOD_MIN              3
%define TOD_SEC              4

; XIOS sub-funktion kaldt via SYSDAT:xiosentry
%define IO_STATLINE          8    ; XIOS funktion 8: Opdater konsol-statuslinje


; ===========================================================================
; DEL 1: CLOCK DATA SEGMENT (RSPHDR + PD + UDA) — 320 bytes (0x11430 - 0x1156F)
; ===========================================================================

clock_data_start:

; --- RSP Header (0x11430) ---
clock_rsphdr:
  dw 0x0FCE                                    ; 11430: p_link (GENCCPM pointer til næste RSP: PIN0)
  times 7 dw 0                                 ; 11432: Reserveret / ubrugt

; --- Process Descriptor (PD) for CLOCK (0x11440) ---
clock_pd:
  dw 0, 0                                      ; 11440: p_link, p_thread
  db 0                                         ; 11444: p_stat (0 = ps_run)
  db 190                                       ; 11445: p_prior (prioritet 190, høj prioritet for tidsstyring)
  dw 2                                         ; 11446: p_flag (2 = pf_keep, må aldrig termineres)
  db "CLOCK   "                                ; 11448: p_name (8 tegn, rum-padded)
  dw 4                                         ; 11450: p_uda (UDA paragraf offset = 4 paragraffer = 0x40 bytes)
  db 0, 0, 0, 0                                ; 11452: p_dsk, p_usr, p_ldsk, p_luser
  dw 0                                         ; 11456: p_mem (hukommelsespartition)
  dw 0, 0                                      ; 11458: p_dvract, p_wait
  db 0, 0                                      ; 1145C: p_org, p_net
  dw 0                                         ; 1145E: p_parent
  db 0, 0, 0, 0                                ; 11460: p_cns, p_abort, p_cin, p_cout
  db 0, 0, 0, 0                                ; 11464: p_lst, p_sf3, p_sf4, p_sf5
  dw 0, 0, 0, 0                                ; 11468: p_reserved, p_pret, p_scratch

; --- User Data Area (UDA) (0x11470) ---
clock_uda:
  times 26 dw 0                                ; 11470: Default DMA buffer og scratch (52 bytes)
  dw 0x013A                                    ; 114A4: p_sp (initial stakpeger = 0x013A)
  times 13 dw 0                                ; 114A6: Reserveret UDA plads (26 bytes)
  dw 0x1197, 0x1183, 0x1183, 0x1183            ; 114C0: Runtime segmenter patched af GENCCPM
  times 4 dw 0                                 ; 114C8
  db 1, 0                                      ; 114D0: UDA flag (INSYS <> 0: bliv på UDA stak ved SUP-kald)

; --- UDA Stakområde fyldt med 0xCC (0x114D2) ---
clock_stack:
  times 152 db 0xCC

; --- Initial Stack Frame (0x1156A) ---
clock_stack_top:
  dw clock_entry - clock_code_start            ; 1156A: Initial IP = 0x0003
  dw 0                                         ; 1156C: Initial CS (sat af GENCCPM)
  dw 0                                         ; 1156E: Initiale flag (sat af GENCCPM)


; ===========================================================================
; DEL 2: CLOCK CODE SEGMENT — 128 bytes (0x11570 - 0x115EF)
; ===========================================================================

clock_code_start:

; --- BDOS systemkalds-wrapper ---
clock_bdos_call:
  int CCPM_INT                                 ; 11570: INT 0xE0 til CCP/M-86 BDOS
  ret                                          ; 11572

; --- Processtart ---
clock_entry:
  mov ds, [0]                                  ; 11573: DS = SYSDAT segmentadresse (fra offset 0)
  mov dl, [SYSDAT_NPCONS]                      ; 11577: DL = Antal fysiske konsoller (npcons ved 0x009F)
  mov si, [SYSDAT_RLR]                         ; 1157B: SI -> Ready List Root (aktuel kørende proces)
  mov es, [si + 0x10]                          ; 1157F: ES -> UDA segment (p_uda)

clock_loop:
  push dx                                      ; 11582: Gem konsoltæller
  mov cx, F_FLAGWAIT                           ; 11583: CL = 132 (BDOS Flag Wait)
  mov dx, SEC_FLAG                             ; 11586: DX = Flag 2 (Sekund-tick)
  call clock_bdos_call                         ; 11589: Vent på sekundflag fra XIOS tick
  pop dx                                       ; 1158C: Gendan konsoltæller

  ; Opdater statuslinje på en virtuel konsol per sekund (cirkulerer over alle konsoller)
  mov ax, IO_STATLINE                          ; 1158D: AX = Funktion 8 (io_statline)
  db 0x33, 0xC9                                ; 11590: xor cx, cx
  cmp dl, 0                                    ; 11592: Er alle konsoller opdateret?
  jne clock_dec_console                        ; 11595: Hvis nej, tag næste
  mov dl, [SYSDAT_NPCONS]                      ; 11597: Hvis ja, genstart fra npcons

clock_dec_console:
  dec dl                                       ; 1159B: Konsolindeks = DL - 1
  push dx                                      ; 1159D: Gem konsoltæller
  call far [SYSDAT_XIOSENTRY]                  ; 1159E: Far call til XIOS entry point (SYSDAT:0x0028)
  pop dx                                       ; 115A2

  ; Opdater sekunder i Time-of-Day (TOD)
  mov bx, SYSDAT_TOD                           ; 115A3: BX -> TOD struktur (SYSDAT:0x007E)
  clc                                          ; 115A6: Ryd carry før BCD addition
  mov al, [bx + TOD_SEC]                       ; 115A7: AL = Aktuelle sekunder (BCD)
  inc al                                       ; 115AA: Inkrementér
  db 0x27                                      ; 115AC: daa (Decimal Adjust for Addition)
  mov [bx + TOD_SEC], al                       ; 115AD: Gem opdateret sekund
  cmp al, 0x60                                 ; 115B0: Nået 60 sekunder?
  jae clock_update_min                         ; 115B2: Ja -> opdater minut
  jmp near clock_loop                          ; 115B4: Nej -> vent på næste sekundtick

clock_update_min:
  mov byte [bx + TOD_SEC], 0                   ; 115B7: Nulstil sekunder
  clc                                          ; 115BB
  mov al, [bx + TOD_MIN]                       ; 115BC: AL = Aktuelle minutter (BCD)
  inc al                                       ; 115BF
  db 0x27                                      ; 115C1: daa
  mov [bx + TOD_MIN], al                       ; 115C2: Gem opdateret minut
  cmp al, 0x60                                 ; 115C5: Nået 60 minutter?
  jae clock_update_hour                        ; 115C7: Ja -> opdater time
  jmp near clock_loop                          ; 115C9: Nej -> vent på næste sekundtick

clock_update_hour:
  mov byte [bx + TOD_MIN], 0                   ; 115CC: Nulstil minutter
  clc                                          ; 115D0
  mov al, [bx + TOD_HOUR]                      ; 115D1: AL = Aktuelle timer (BCD)
  inc al                                       ; 115D4
  db 0x27                                      ; 115D6: daa
  mov [bx + TOD_HOUR], al                      ; 115D7: Gem opdateret time
  cmp al, 0x24                                 ; 115DA: Nået 24 timer (midnat)?
  jae clock_update_day                         ; 115DC: Ja -> opdater dag
  jmp near clock_loop                          ; 115DE: Nej -> vent på næste sekundtick

clock_update_day:
  mov byte [bx + TOD_HOUR], 0                  ; 115E1: Nulstil timer
  inc word [bx + TOD_DAY]                      ; 115E5: Tæl dage op (binært 16-bit tal siden 01-01-1978)
  jmp near clock_loop                          ; 115E7: Fortsæt uendelig løkke

; --- Paragraf-padding til næste proces (PIN0 ved 0x115F0) ---
  times 6 db 0                                 ; 115EA
