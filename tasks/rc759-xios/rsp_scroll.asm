; ===========================================================================
; RSP 5: SCROLL — Bloed rulning via Intel 82730 tekstprocessor og MXdma0
; Offset range: 0x12E60 - 0x12EFF (160 bytes: 112 bytes kode + 48 bytes trailer)
;
; Processen haandterer smooth scrolling paa RC759 Piccoline ved at flytte
; skaermbilledet trinvis over flere VSYNC-intervaller i samspil med Intel 82730.
;
; Synkronisering:
; - Koe MXdma0 (offset 0x00A8): Gensidig udelukkelse paa DMA-kanal 0.
; - Flag 4:  Udloeses af XIOS naar konsoloutput kraever linjerulning.
; - Flag 9:  Signaleres per deltrin.
; - Flag 10: Signaleres naar rulning afsluttes / er i fase.
; - INT 0x28, AL=2: XIOS hardware-kald der rykker 82730 startadresse med 1 scanline.
;   Returnerer AL=0 naar hele tegnraekken er rullet, ellers AL != 0.
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
%define Q_MXDMA0             0xA8 ; Offset til MXdma0 koe-deskriptor

scroll_main:
  mov dx, Q_MXDMA0                             ; 12E60: Aabn MXdma0 koe
  mov cl, F_QOPEN                              ; 12E63: BDOS 135 (q_open)
  call scroll_bdos_call                        ; 12E65
  jmp short scroll_wait_trigger                ; 12E68

scroll_done_release:
  call scroll_unlock_dma                       ; 12E6A: Frigiv MXdma0 efter endt rulning

scroll_wait_trigger:
  call scroll_set_flag10                       ; 12E6D: Saet Flag 10 (fase klar)
  call scroll_wait_flag4                       ; 12E70: Vent paa Flag 4 (anmodning fra XIOS)
  call scroll_lock_dma                         ; 12E73: Overtag MXdma0 (eksklusiv DMA-adgang)

scroll_step_loop:
  call scroll_xios_step                        ; 12E76: XIOS AL=2 (udfoer 1 scanline rulning)
  mov dx, FLAG_SCROLL_STEP                     ; 12E79: DX = Flag 9
  call scroll_set_flag_dx                      ; 12E7C: Saet Flag 9 (deltrin udfoert)
  call scroll_yield                            ; 12E7F: Yield CPU (DX=0 ticks)
  call scroll_step_and_yield                   ; 12E82: Nyt scanline-trin og yield
  call scroll_unlock_dma                       ; 12E85: Frigiv midlertidigt DMA
  call scroll_step_and_yield                   ; 12E88: Nyt scanline-trin og yield
  call scroll_lock_dma                         ; 12E8B: Gen-overtag DMA
  call scroll_step_and_yield                   ; 12E8E: Nyt scanline-trin og yield
  call scroll_step_and_yield                   ; 12E91: Nyt scanline-trin og yield
  call scroll_xios_step                        ; 12E94: XIOS AL=2 scanline-trin
  db 0x0A, 0xC0                                ; 12E97: or al, al (d=1) — AL == 0 naar hele tegnraekken er rullet
  je scroll_done_release                       ; 12E99: Hvis faerdig, frigiv lock og vent
  call scroll_set_flag10                       ; 12E9B: Flere scanlines mangler: saet Flag 10
  call scroll_wait_flag4                       ; 12E9E: Vent paa naeste VSYNC / Flag 4
  jmp short scroll_step_loop                   ; 12EA1: Fortsaet scanline-loop

scroll_set_flag10:
  mov dx, FLAG_SCROLL_PHASE                    ; 12EA3: DX = Flag 10

scroll_set_flag_dx:
  mov cl, F_FLAGSET                            ; 12EA6: BDOS 133 (Flag Set)
  jmp short scroll_bdos_call                   ; 12EA8

scroll_wait_flag4:
  mov cl, F_FLAGWAIT                           ; 12EAA: BDOS 132 (Flag Wait)
  mov dx, FLAG_SCROLL_REQ                      ; 12EAC: DX = Flag 4
  jmp short scroll_bdos_call                   ; 12EAF

scroll_lock_dma:
  mov dx, Q_MXDMA0                             ; 12EB1: DX -> MXdma0 koe
  mov cl, F_QREAD                              ; 12EB4: BDOS 137 (Queue Read / lock)
  jmp short scroll_bdos_call                   ; 12EB6

scroll_unlock_dma:
  mov dx, Q_MXDMA0                             ; 12EB8: DX -> MXdma0 koe
  mov cl, F_QWRITE                             ; 12EBB: BDOS 139 (Queue Write / unlock)
  jmp short scroll_bdos_call                   ; 12EBD

scroll_step_and_yield:
  call scroll_xios_step                        ; 12EBF: XIOS AL=2 scanline-trin

scroll_yield:
  mov cl, F_DELAY                              ; 12EC2: BDOS 141 (Delay / yield)
  mov dx, 0                                    ; 12EC4: 0 ticks (frivilligt CPU-afkald)

scroll_bdos_call:
  int 0xe0                                     ; 12EC7: CCP/M-86 BDOS software-afbrydelse
  ret                                          ; 12EC9

scroll_xios_step:
  mov al, 2                                    ; 12ECA: XIOS funktion 2 (scanline scroll)
  int 0x28                                     ; 12ECC: XIOS software-afbrydelse
  ret                                          ; 12ECE

  db 0x00                                      ; 12ECF: Padding byte til word-justering

; --- GENCCPM trailer og sektor-padding (48 bytes: 0x12ED0 - 0x12EFF) ---
genccpm_trailer:
  db "GENCCPM  v3.1  [2/7/84]", 0x0A, 0x00    ; 12ED0: GENCCPM versionsstempel
  times 23 db 0x00                             ; 12EE9: Nul-fyld frem til 77.568 bytes
