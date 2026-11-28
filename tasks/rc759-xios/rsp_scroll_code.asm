; ===========================================================================
; Regnecentralen RC759 Piccoline — SCROLL.RSP Code Segment
; Blød rulning via Intel 82730 tekstprocessor og MXdma0
; 7 paragraphs = 112 bytes
; ===========================================================================

%define F_FLAGWAIT           0x84 ; BDOS 132: Vent paa systemflag
%define F_FLAGSET            0x85 ; BDOS 133: Saet systemflag
%define F_QOPEN              0x87 ; BDOS 135: Aabn koe
%define F_QREAD              0x89 ; BDOS 137: Laes/reserver koe (lock)
%define F_QWRITE             0x8B ; BDOS 139: Skriv/frigiv koe (unlock)
%define F_DELAY              0x8D ; BDOS 141: Forsinkelse / proces-yield

%define FLAG_SCROLL_REQ      4    ; Flag 4: XIOS anmoder om rulning
%define FLAG_SCROLL_STEP     9    ; Flag 9: Rulle-deltrin signal
%define FLAG_SCROLL_PHASE    10   ; Flag 10: Rulle-fase signal
%define Q_MXDMA0             0xA8 ; Offset til MXdma0 koe-deskriptor i datasegment

scroll_main:
  mov dx, Q_MXDMA0                             ; 0080: Aabn MXdma0 koe
  mov cl, F_QOPEN                              ; 0083: BDOS 135 (q_open)
  call scroll_bdos_call                        ; 0085
  jmp short scroll_wait_trigger                ; 0088

scroll_done_release:
  call scroll_unlock_dma                       ; 008A: Frigiv MXdma0 efter endt rulning

scroll_wait_trigger:
  call scroll_set_flag10                       ; 008D: Saet Flag 10 (fase klar)
  call scroll_wait_flag4                       ; 0090: Vent paa Flag 4 (anmodning fra XIOS)
  call scroll_lock_dma                         ; 0093: Overtag MXdma0 (eksklusiv DMA-adgang)

scroll_step_loop:
  call scroll_xios_step                        ; 0096: XIOS AL=2 (udfoer 1 scanline rulning)
  mov dx, FLAG_SCROLL_STEP                     ; 0099: DX = Flag 9
  call scroll_set_flag_dx                      ; 009C: Saet Flag 9 (deltrin udfoert)
  call scroll_yield                            ; 009F: Yield CPU (DX=0 ticks)
  call scroll_step_and_yield                   ; 00A2: Nyt scanline-trin og yield
  call scroll_unlock_dma                       ; 00A5: Frigiv midlertidigt DMA
  call scroll_step_and_yield                   ; 00A8: Nyt scanline-trin og yield
  call scroll_lock_dma                         ; 00AB: Gen-overtag DMA
  call scroll_step_and_yield                   ; 00AE: Nyt scanline-trin og yield
  call scroll_step_and_yield                   ; 00B1: Nyt scanline-trin og yield
  call scroll_xios_step                        ; 00B4: XIOS AL=2 scanline-trin
  db 0x0A, 0xC0                                ; 00B7: or al, al (d=1) — AL == 0 naar hele tegnraekken er rullet
  je scroll_done_release                       ; 00B9: Hvis faerdig, frigiv lock og vent
  call scroll_set_flag10                       ; 00BB: Flere scanlines mangler: saet Flag 10
  call scroll_wait_flag4                       ; 00BE: Vent paa naeste VSYNC / Flag 4
  jmp short scroll_step_loop                   ; 00C1: Fortsaet scanline-loop

scroll_set_flag10:
  mov dx, FLAG_SCROLL_PHASE                    ; 00C3: DX = Flag 10

scroll_set_flag_dx:
  mov cl, F_FLAGSET                            ; 00C6: BDOS 133 (Flag Set)
  jmp short scroll_bdos_call                   ; 00C8

scroll_wait_flag4:
  mov cl, F_FLAGWAIT                           ; 00CA: BDOS 132 (Flag Wait)
  mov dx, FLAG_SCROLL_REQ                      ; 00CC: DX = Flag 4
  jmp short scroll_bdos_call                   ; 00CF

scroll_lock_dma:
  mov dx, Q_MXDMA0                             ; 00D1: DX -> MXdma0 koe
  mov cl, F_QREAD                              ; 00D4: BDOS 137 (Queue Read / lock)
  jmp short scroll_bdos_call                   ; 00D6

scroll_unlock_dma:
  mov dx, Q_MXDMA0                             ; 00D8: DX -> MXdma0 koe
  mov cl, F_QWRITE                             ; 00DB: BDOS 139 (Queue Write / unlock)
  jmp short scroll_bdos_call                   ; 00DD

scroll_step_and_yield:
  call scroll_xios_step                        ; 00DF: XIOS AL=2 scanline-trin

scroll_yield:
  mov cl, F_DELAY                              ; 00E2: BDOS 141 (Delay / yield)
  mov dx, 0                                    ; 00E4: 0 ticks (frivilligt CPU-afkald)

scroll_bdos_call:
  int 0xe0                                     ; 00E7: CCP/M-86 BDOS software-afbrydelse
  ret                                          ; 00E9

scroll_xios_step:
  mov al, 2                                    ; 00EA: XIOS funktion 2 (scanline scroll)
  int 0x28                                     ; 00EC: XIOS software-afbrydelse
  ret                                          ; 00EE

  db 0x00                                      ; 00EF: Padding byte til word-justering
