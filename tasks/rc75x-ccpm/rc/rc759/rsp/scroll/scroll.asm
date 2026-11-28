; ===========================================================================
; Regnecentralen RC759 Piccoline — SCROLL.RSP (Intel 82730 Smooth Scroll Driver)
;
; Rekonstrueret og reverse-engineeret kildetekst for SCROLL.RSP fra
; SW1400 CCP/M-86 release 3.1 (SW1400 Disk 2/4).
;
; WHAT:
;   Resident System Process (RSP), der udfører blød lodret rulning (smooth scroll)
;   ved at koordinere Intel 82730 Text Coprocessor og Intel 80186 DMA kanal 0.
;
; WHY:
;   Intel 82730 på Piccoline understøtter hardware smooth scrolling per pixel-linje.
;   Når en virtuel konsol skal rulle blødt, venter SCROLL.RSP på synkroniserings-
;   flag (Flag 7), griber mutex'en "MXdma0  " for DMA kanal 0, triggerer hardware-
;   rulningen trinvist via INT 28h (AL=2), og frigiver mutex'en igen.
; ===========================================================================

bits 16
org 0

; ---------------------------------------------------------------------------
; CP/M-86 CMD fil-header (128 bytes)
; ---------------------------------------------------------------------------
cmd_header:
  db 0x01                                      ; Group 1: Code group
  dw 0x0007                                    ; Code length: 7 paragraphs (112 bytes)
  dw 0x0000                                    ; Code base paragraph
  dw 0x0007                                    ; Code min alloc
  dw 0x0000                                    ; Code max alloc (0 = unconstrained)
  db 0x02                                      ; Group 2: Data group
  dw 0x0014                                    ; Data length: 20 paragraphs (320 bytes)
  dw 0x0000                                    ; Data base paragraph
  dw 0x0014                                    ; Data min alloc
  dw 0x0000                                    ; Data max alloc
  times 128 - ($ - cmd_header) db 0            ; Resterende header udfyldes med nuller

; ---------------------------------------------------------------------------
; CODE GROUP (Offset 0x0080 i filen, 112 bytes)
; ---------------------------------------------------------------------------
code_start:
scroll_main:
  mov dx, mxdma0_qd - data_start               ; 0x0080: DX = offset til MXdma0 Queue Descriptor (0x00a8)
  mov cl, 0x87                                 ; 0x0083: CL = DEV_FLAGWAIT (System Flag 7)
  call bdos_call                               ; 0x0085: Vent på scroll-forespørgsel
  jmp short loop_start                         ; 0x0088: Start rulningsløkke

loop_again:
  call sig_mxdma                               ; 0x008a: Frigiv DMA0 mutex (QueueWrite / FlagSet)
loop_start:
  call set_flag10                              ; 0x008d: Sæt Flag 10 (rulning aktiv)
  call clr_flag4                               ; 0x0090: Nulstil Flag 4
  call wait_mxdma                              ; 0x0093: Reserver DMA0 mutex (QueueRead)

step_loop:
  call trigger_step                            ; 0x0096: Udfør hardware rulningstrin via INT 28h (AL=2)
  mov dx, 0x0009                               ; 0x0099: Flag 9
  call set_flag_dx                             ; 0x009c: Sæt Flag 9
  call dispatch_0                              ; 0x009f: Afgiv CPU (Dispatch / Sleep 0)
  call trig_and_dispatch                       ; 0x00a2: Udfør trin + dispatch
  call sig_mxdma                               ; 0x00a5: Frigiv DMA0 mutex midlertidigt
  call trig_and_dispatch                       ; 0x00a8: Udfør trin + dispatch
  call wait_mxdma                              ; 0x00ab: Genoptag DMA0 mutex
  call trig_and_dispatch                       ; 0x00ae: Udfør trin + dispatch
  call trig_and_dispatch                       ; 0x00b1: Udfør trin + dispatch
  call trigger_step                            ; 0x00b4: Udfør sidste hardware trin
  db 0x0a, 0xc0                                ; 0x00b7: or al, al (d=1 retning, modsat NASM d=0 default)
  jz loop_again                                ; 0x00b9: Hvis færdig -> frigiv og vent på næste
  call set_flag10                              ; 0x00bb: Stadig aktiv -> forny Flag 10
  call clr_flag4                               ; 0x00be: Nulstil Flag 4
  jmp short step_loop                          ; 0x00c1: Næste rulningssekvens

set_flag10:
  mov dx, 0x000a                               ; 0x00c3: DX = Flag 10
set_flag_dx:
  mov cl, 0x85                                 ; 0x00c6: CL = DEV_FLAGSET (133)
  jmp short bdos_call                          ; 0x00c8: Eksekver BDOS-kald

clr_flag4:
  mov cl, 0x84                                 ; 0x00ca: CL = DEV_FLAGRESET (132)
  mov dx, 0x0004                               ; 0x00cc: DX = Flag 4
  jmp short bdos_call                          ; 0x00cf: Eksekver BDOS-kald

wait_mxdma:
  mov dx, mxdma0_qd - data_start               ; 0x00d1: DX = offset mxdma0_qd (0x00a8)
  mov cl, 0x89                                 ; 0x00d4: CL = Queue Read / Semaphore Wait (137)
  jmp short bdos_call                          ; 0x00d6: Eksekver BDOS-kald

sig_mxdma:
  mov dx, mxdma0_qd - data_start               ; 0x00d8: DX = offset mxdma0_qd (0x00a8)
  mov cl, 0x8b                                 ; 0x00db: CL = Queue Write / Semaphore Signal (139)
  jmp short bdos_call                          ; 0x00dd: Eksekver BDOS-kald

trig_and_dispatch:
  call trigger_step                            ; 0x00df: Udfør hardware rulningstrin
dispatch_0:
  mov cl, 0x8d                                 ; 0x00e2: CL = Dispatch / Sleep (141)
  mov dx, 0x0000                               ; 0x00e4: DX = 0 ticks (afgiv blot tidsskive)
bdos_call:
  int 0xe0                                     ; 0x00e7: CCP/M-86 systemkald (INT 224)
  ret                                          ; 0x00e9

trigger_step:
  mov al, 0x02                                 ; 0x00ea: Subfunktion 2 = 82730 smooth scroll step
  int 0x28                                     ; 0x00ec: XIOS/Hardware afbrydelse for videocoprocessor
  ret                                          ; 0x00ee
  db 0x00                                      ; 0x00ef: Justerings-byte

; Udfyld kode-sektoren op til 128 bytes (Group 1 er 112 bytes kode + 16 bytes nul-pad)
times 128 - ($ - code_start) db 0

; ---------------------------------------------------------------------------
; DATA GROUP (Offset 0x0100 i filen, 320 bytes = 20 paragraphs)
; ---------------------------------------------------------------------------
data_start:
rsp_header:
  dw 0x0000, 0x0000                            ; +0x00: Link fields
  db 0x00                                      ; +0x04: Status
  db 0xb0                                      ; +0x05: Prioritet = 176 (højere end normale processer)
  dw 0x0002                                    ; +0x06: Flags = Keep (må ikke dræbes)
  db 'SCROLL  '                                ; +0x08: Procesnavn (8 tegn)
  dw 0x0004                                    ; +0x10: UDA paragraf-offset (0x0400 = 64 bytes)
  times 46 db 0                                ; +0x12: Resterende PD-felter (udfyldes af GENSYS)

uda_area:
  times 36 db 0                                ; +0x40: UDA headers
  dw 0x013a                                    ; +0x64: Initial stak-top pointer (offset 0x013a)
  times 42 db 0                                ; +0x66: UDA kontekstfelter
  dw 0x0001                                    ; +0x90: Initial aktiv status
  dw 0xcccc, 0xcccc, 0xcccc                    ; +0x92: UDA INT3 stak-fyld
  times 8 db 0                                 ; +0x98: Mellemrum

mxdma0_queue:
  db 'MXdma0  '                                ; +0xa0: Mutex-navn: Mutual Exclusion DMA kanal 0
mxdma0_qd:
  times 65 dw 0xcccc                           ; +0xa8: 130 bytes INT3 fyld / Queue Descriptor buffer
  times 22 db 0                                ; +0x12a: Bufferhale
  times 16 db 0                                ; +0x130: Stakbund

times 384 - ($ - data_start) db 0              ; Data-gruppen fylder 320 bytes + 64 bytes pad = 384 bytes
