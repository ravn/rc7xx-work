; =============================================================================
; RC759 Piccoline — Hardware I/O Ports and System Definitions
; References:
;   - PICCOLINE Programmer's Guide v2 (Appendix B & C)
;   - Intel 80186 / 8259A / 8255A / 82730 / WD2797 Datasheets
; =============================================================================

%ifndef _HARDWARE_INC_
%define _HARDWARE_INC_

; -----------------------------------------------------------------------------
; Interrupt Vector Table (IVT) byte-offsets (= interrupt_number × 4)
; Piccoline RC759 interrupt-tildelinger:
IVT_NMI                 equ 0x08        ; INT 0x02: NMI → xios_nmi_handler
IVT_INT3                equ 0x0C        ; INT 0x03: Breakpoint → xios_int3_handler
IVT_IRQ2                equ 0x28        ; INT 0x0A: IRQ2 (FDC INT10) → fdc_int10_handler
IVT_IRQ3                equ 0x2C        ; INT 0x0B: IRQ3 (FDC INT11) → fdc_int11_handler
IVT_IRQ5                equ 0x34        ; INT 0x0D: IRQ5 (SIO serial) → xios_serial_isr
IVT_IRQ7                equ 0x3C        ; INT 0x0F: IRQ7 (timer/clock) → xios_timer_isr
IVT_INT20               equ 0x80        ; INT 0x20: FDC overførsels-ISR → fdc_transfer_isr
IVT_INT22               equ 0x88        ; INT 0x22: CRT-ISR → xios_crt_isr
IVT_INT23               equ 0x8C        ; INT 0x23: Tick-ISR → xios_tick_isr

; Master Interrupt Controller (Intel 8259A PIC)
; -----------------------------------------------------------------------------
PORT_PIC_CMD            equ 0x0000      ; ICW1, OCW2 (EOI), OCW3
PORT_PIC_IMR            equ 0x0002      ; ICW2-4, OCW1 (Interrupt Mask Register)

; -----------------------------------------------------------------------------
; Keyboard Interface
; -----------------------------------------------------------------------------
PORT_KBD_DATA           equ 0x0020      ; Read keyboard scancode / ASCII

; -----------------------------------------------------------------------------
; Sound Generator (TI SN76494 / SN76489A)
; -----------------------------------------------------------------------------
PORT_SOUND              equ 0x0056      ; Sound frequency & attenuation write

; -----------------------------------------------------------------------------
; Real Time Clock (MM58167A)
; -----------------------------------------------------------------------------
PORT_RTC_DATA           equ 0x005A      ; RTC data write
PORT_RTC_ADDR           equ 0x005C      ; RTC address write / data read

; MM58167A Internal Register Map (0x00 - 0x1F)
RTC_REG_MSEC_1_10       equ 0x00        ; Milliseconds (1/1000 & 1/100 sec, BCD)
RTC_REG_MSEC_100        equ 0x01        ; Milliseconds (1/10 & tenths sec, BCD)
RTC_REG_SEC             equ 0x02        ; Seconds (00-59, BCD)
RTC_REG_MIN             equ 0x03        ; Minutes (00-59, BCD)
RTC_REG_HOUR            equ 0x04        ; Hours (00-23, BCD)
RTC_REG_DAY_OF_WEEK     equ 0x05        ; Day of week (1-7)
RTC_REG_DAY             equ 0x06        ; Day of month (01-31, BCD)
RTC_REG_MONTH           equ 0x07        ; Month (01-12, BCD)
RTC_REG_RAM_BASE        equ 0x08        ; Scratchpad RAM (8 bytes, 0x08..0x0F)
; MM58167A Control registers (A4=1, adresser 0x10-0x1F)
; Reference: RC759 CPU Board Reference Manual (RCSL-99-0-00825) §5, s.22-27
RTC_REG_STATUS          equ 0x10        ; alias: Interrupt Status (R) — bevaret for kompatibilitet
RTC_REG_INT_STATUS      equ 0x10        ; Interrupt Status (R): hvilke hændelser er pending
RTC_REG_CTL             equ 0x11        ; Interrupt Control (W): aktivér interrupt-kilder (D0-D7)
                                        ;   D0=rollover, D1=1/10s, D2=sek, D3=min, D4=time
                                        ;   D5=ugedag, D6=dag, D7=måned
                                        ;   Control-reg bits: B2=start(1)/stop(0), B3=tæller(0)/latch(1)
                                        ;   B4-B7=klokfrekvens, B0-B1=altid 0
RTC_REG_CRESET          equ 0x12        ; Counter Reset (W): nulstil tæller(e) via bit-maske D0-D7
RTC_REG_LRESET          equ 0x13        ; Latch Reset (W): nulstil latch(er) via bit-maske D0-D7
RTC_REG_STATUS_BIT      equ 0x14        ; Status bit (R): D0=1 hvis tæller ændret under læsning
RTC_REG_GO              equ 0x15        ; GO Command (W): nulstil sekund+brøkdel-tæller præcist
RTC_REG_STANDBY_INT     equ 0x16        ; Standby Interrupt (W): D0=1 aktivér standby-interrupt
RTC_REG_COUNT_RESET     equ 0x19        ; Counter reset register
RTC_REG_RAM_RESET       equ 0x1A        ; RAM reset register

; -----------------------------------------------------------------------------
; Intel 82730 Text Coprocessor (CRT)
; -----------------------------------------------------------------------------
PORT_CRT_CTRL           equ 0x0060      ; CRT control write
PORT_PALETTE_BASE       equ 0x0180      ; 16 IRGB farvepalet-indgange, 2 på hinanden flg. ligetal-adresser pr. indgang (0x180-0x1BE)
PORT_CRT_RESET          equ 0x0230      ; Intel 82730 System Reset (IRST)
PORT_CRT_CA             equ 0x0240      ; Intel 82730 Channel Attention (CA)

; -----------------------------------------------------------------------------
; Programmable Peripheral Interface (Intel 8255A PPI)
; -----------------------------------------------------------------------------
PORT_PPI_PORTA          equ 0x0070      ; Port A: Cassette in, RAM ident, iSBX status
PORT_PPI_PORTB          equ 0x0072      ; Port B: Monitor type, sound ready, net ident
PORT_PPI_PORTC          equ 0x0074      ; Port C: Keyboard en, GFX, NVM bank, motor
PORT_PPI_CTRL           equ 0x0076      ; PPI Control word register
PPI_CTRL_INIT           equ 0x92        ; Initial mode: Port A=in, Port B=in, Port C low=out, high=out

; PPI Port A bit masks (IOBASE+0x70, input)
PPI_PORTA_CAS_DATA      equ 0x01        ; Bit 0: CASSETTE DATA IN (seriel data fra bånd)
PPI_PORTA_MPST          equ 0x02        ; Bit 1: /MPST — 0 hvis iSBX modul installeret
PPI_PORTA_OPT0          equ 0x04        ; Bit 2: OPTION0 — iSBX-specifik statussignal
PPI_PORTA_OPT1          equ 0x08        ; Bit 3: OPTION1 — iSBX-specifik statussignal
PPI_PORTA_nMEMID0       equ 0x10        ; Bit 4: /MEM IDENT0 — RAM-konfiguration (se tabel)
PPI_PORTA_nMEMID1       equ 0x20        ; Bit 5: /MEM IDENT1 — RAM-konfiguration
PPI_PORTA_nDPC          equ 0x40        ; Bit 6: /DPC CONNECT — 0 hvis ekstern diskette/printer boks

; PPI Port B bit masks (IOBASE+0x72, input)
PPI_PORTB_nNETID        equ 0x04        ; Bit 2: /NET IDENT — 0 hvis MICRONET controller er monteret
PPI_PORTB_nRTC_SEC      equ 0x08        ; Bit 3: /RTC SEC SOURCE — 0 hvis RCA CDP1879 bruges som RTC
PPI_PORTB_nSOGE         equ 0x10        ; Bit 4: /SOGE — detektion af lydgenerator
PPI_PORTB_MONO          equ 0x20        ; Bit 5: MONOCHROME — 1 hvis monokrom skærm tilsluttet
PPI_PORTB_22KHZ         equ 0x40        ; Bit 6: 22KHZ — 1 hvis skærm kører 22 kHz linjefrekvens

; PPI Port C bit masks
PPI_PORTC_CAS_EN        equ 0x01        ; Bit 0: Enable cassette interface
PPI_PORTC_CAS_MOTOR_OFF equ 0x02        ; Bit 1: Cassette motor off (1=off, 0=on)
PPI_PORTC_DRQ_MASK      equ 0x0C        ; Bit 2-3: DMA request routing mask
PPI_PORTC_NVM_BANK_MASK equ 0x30        ; Bit 4-5: NVRAM bank select mask
PPI_PORTC_nGRAPHIC      equ 0x40        ; Bit 6: /GRAPHIC — 0=grafik-tilstand, 1=alfanumerisk (aktiv-lav)
PPI_PORTC_KBD_EN        equ 0x80        ; Bit 7: Keyboard receive enable

; -----------------------------------------------------------------------------
; Non-Volatile RAM (256x4 CMOS RAM, 4 banks of 64 nibbles)
; -----------------------------------------------------------------------------
PORT_NVRAM_BASE         equ 0x0080      ; Even I/O addresses 0x80 - 0xFE

; -----------------------------------------------------------------------------
; Local Centronics Parallel Printer Interface
; -----------------------------------------------------------------------------
PORT_PRN_DATA           equ 0x0250      ; Centronics 8-bit printer data
PORT_PRN_CTRL           equ 0x0260      ; Centronics control / status

; -----------------------------------------------------------------------------
; Floppy Disk Controller (Western Digital WD2797)
; -----------------------------------------------------------------------------
PORT_FDC_CMD            equ 0x0280      ; WD2797 Command write / Status read
PORT_FDC_STATUS         equ 0x0280      ; WD2797 Status read
PORT_FDC_TRACK          equ 0x0282      ; WD2797 Track register
PORT_FDC_SECTOR         equ 0x0284      ; WD2797 Sector register
PORT_FDC_DATA           equ 0x0286      ; WD2797 Data register
PORT_FDC_CTRL           equ 0x0288      ; Drive/Side/Motor/Clock/Density control

; WD2797 Status Register bit masks (port 0x0280, læses ved statusforespørgsel)
FDC_ST_BUSY             equ 0x01        ; Bit 0: Kommando aktiv (BUSY)
FDC_ST_INDEX            equ 0x02        ; Bit 1: Indekspuls registreret (Type I)
FDC_ST_DRQ              equ 0x02        ; Bit 1: Data Request (Type II/III)
FDC_ST_TRACK0           equ 0x04        ; Bit 2: Hoved på spor 0 (Type I)
FDC_ST_LOST_DATA        equ 0x04        ; Bit 2: Datatab / DRQ ikke behandlet (Type II/III)
FDC_ST_CRC_ERR          equ 0x08        ; Bit 3: CRC-fejl
FDC_ST_SEEK_ERR         equ 0x10        ; Bit 4: Seek Error (Type I)
FDC_ST_RNF              equ 0x10        ; Bit 4: Record Not Found (Type II/III)
FDC_ST_HEAD_LOADED      equ 0x20        ; Bit 5: Hoved indkoblet (Type I)
FDC_ST_WRITE_FAULT      equ 0x40        ; Bit 6: Skrivefejl / skrivebeskyttet
FDC_ST_NOT_READY        equ 0x80        ; Bit 7: Drev ikke klar
FDC_ST_ERR_MASK         equ 0x99        ; Fejlmaske: NOT_READY|SEEK_ERR|CRC_ERR|BUSY

; FDC Control Register (0x0288) bit masks
FDC_CTRL_DRIVE_B        equ 0x01        ; Bit 0: 0 = Drive A, 1 = Drive B
FDC_CTRL_MOTOR_A        equ 0x02        ; Bit 1: Motor on for Drive A
FDC_CTRL_MOTOR_B        equ 0x04        ; Bit 2: Motor on for Drive B
FDC_CTRL_PRECOMP_EN     equ 0x08        ; Bit 3: Write precompensation enable
FDC_CTRL_PRECOMP_TIME   equ 0x10        ; Bit 4: Precomp timing (125/250 ns)
FDC_CTRL_nDD            equ 0x20        ; Bit 5: /DD — 0=dual density (MFM), 1=single density (FM)
FDC_CTRL_CLOCK_2MHZ     equ 0x40        ; Bit 6: 0 = 1 MHz (5.25"), 1 = 2 MHz (8")
FDC_CTRL_FORCE_READY    equ 0x80        ; Bit 7: Force Ready signal to WD2797

; WD2797 Command bytes (skrives til PORT_FDC_CMD / 0x0280)
FDC_CMD_RESTORE         equ 0x0C        ; Restore (Type I): spor til 0
FDC_CMD_SEEK            equ 0x1C        ; Seek (Type I): spor til DR
FDC_CMD_READ_SECT       equ 0x88        ; Read Sector (Type II): 1000 1000b (side-compare)
FDC_CMD_WRITE_SECT      equ 0xA8        ; Write Sector (Type II): 1010 1000b (side-compare)
FDC_CMD_READ_ADDR       equ 0xC4        ; Read Address (Type III): 1100 0100b
FDC_CMD_FORCE_INT       equ 0xD0        ; Force Interrupt (Type IV): afbryd kommando

; fdc_drive_unit_map enheds-type koder (tabel indekseret af drevnummer)
FDC_UNIT_NONE           equ 0x00        ; Ingen enhed / drev ikke installeret
FDC_UNIT_FLOPPY         equ 0x01        ; Standard diskette (5.25" eller 8")
FDC_UNIT_MDISK          equ 0xC0        ; M-disk (RAM-disk, drev 0xC=12); sættes ved boot
FDC_UNIT_WDISK          equ 0xD0        ; Winchester harddisk (multi-sektor overførsel)

; -----------------------------------------------------------------------------
; DPC (Disk/Printer-Adaptor) Shared Peripheral Control
; -----------------------------------------------------------------------------
PORT_DPC_PRN_DATA       equ 0x028A      ; DPC external printer data
PORT_DPC_PRN_CTRL       equ 0x028C      ; DPC external printer control/status
PORT_FDC_RESERVE        equ 0x028E      ; Floppy reserve (W) / ACK (R)
PORT_FDC_RELEASE        equ 0x0290      ; Floppy release (W)
PORT_PRN_RESERVE        equ 0x0292      ; Printer reserve (W) / ACK (R)
PORT_PRN_RELEASE        equ 0x0294      ; Printer release (W)

; -----------------------------------------------------------------------------
; iSBX Multimodule Expansion Bus
; -----------------------------------------------------------------------------
PORT_ISBX_MCS0_BASE     equ 0x0300      ; iSBX MCS0 I/O space (0x300 - 0x30E)
PORT_ISBX_MCS0_02       equ 0x0302      ; iSBX MCS0 register 2 (e.g. 8251 USART)
PORT_ISBX_MCS1_BASE     equ 0x0310      ; iSBX MCS1 I/O space (0x310 - 0x31E)
PORT_ISBX_MCS1_04       equ 0x0314      ; iSBX MCS1 register 4 (e.g. 8253 timer)
PORT_ISBX_MCS1_06       equ 0x0316      ; iSBX MCS1 register 6 (e.g. 8253 timer)
PORT_ISBX_DMA_ACK       equ 0x0320      ; iSBX DMA Acknowledge
PORT_ISBX_TC            equ 0x0330      ; iSBX Terminal Count

; -----------------------------------------------------------------------------
; Intel 80186 On-Chip Peripheral Control Block (PCB at 0xFF00 - 0xFFFF)
; -----------------------------------------------------------------------------
PORT_PCB_EOI            equ 0xFF22      ; End Of Interrupt register
PCB_EOI_NONSPEC         equ 0x8000      ; 80186 PCB: Non-specific EOI (bit 15 = kvitter højest prioritet)
PIC_EOI_NONSPEC         equ 0x20        ; 8259A PIC: Non-specific EOI (OCW2 bit 5)
PORT_PCB_POLL           equ 0xFF24      ; Poll register
PORT_PCB_POLLST         equ 0xFF26      ; Poll status register
PORT_PCB_IMR            equ 0xFF28      ; Interrupt Mask Register
PORT_PCB_PMR            equ 0xFF2A      ; Priority Mask Register
PORT_PCB_ISR            equ 0xFF2C      ; In-Service Register
PORT_PCB_IRR            equ 0xFF2E      ; Interrupt Request Register

PORT_PCB_T0_CNT         equ 0xFF50      ; Timer 0 Count register
PORT_PCB_T0_MAXA        equ 0xFF52      ; Timer 0 Max Count A
PORT_PCB_T0_MAXB        equ 0xFF54      ; Timer 0 Max Count B
PORT_PCB_T0_CON         equ 0xFF56      ; Timer 0 Mode / Control register (se PCB_TCR_* nedenfor)

PORT_PCB_T1_CNT         equ 0xFF58      ; Timer 1 Count register
PORT_PCB_T1_MAXA        equ 0xFF5A      ; Timer 1 Max Count A
PORT_PCB_T1_MAXB        equ 0xFF5C      ; Timer 1 Max Count B
PORT_PCB_T1_CON         equ 0xFF5E      ; Timer 1 Mode / Control register

PORT_PCB_T2_CNT         equ 0xFF60      ; Timer 2 Count register
PORT_PCB_T2_MAXA        equ 0xFF62      ; Timer 2 Max Count A
PORT_PCB_T2_CON         equ 0xFF66      ; Timer 2 Mode / Control register

; 80186 PCB Timer Control Register bit-definitioner (Timers 0 og 1, Fig. 56 iAPX186 HW Ref. Manual)
; Reference: 270788-001 iAPX 80186/80188 Hardware Reference Manual, s. 6-2
PCB_TCR_EN              equ 0x8000      ; bit 15: Timer Enable (1=kørende)
PCB_TCR_INH             equ 0x4000      ; bit 14: Inhibit: 1=skriv til EN er effektivt
PCB_TCR_INT             equ 0x2000      ; bit 13: Interrupt Enable (1=interrupt ved max count)
PCB_TCR_RIU             equ 0x1000      ; bit 12: Register In Use (read-only statusbit)
PCB_TCR_MC              equ 0x0020      ; bit 5:  Max Count: 0=MAXA, 1=MAXA+MAXB alternerende
PCB_TCR_RTG             equ 0x0010      ; bit 4:  Retrigger enable
PCB_TCR_P               equ 0x0008      ; bit 3:  Prescale (1=÷4 ekstra)
PCB_TCR_EXT             equ 0x0004      ; bit 2:  External CLK (1=ekstern tasterpin)
PCB_TCR_ALT             equ 0x0002      ; bit 1:  Alternate: 0=brug MAXA, 1=brug MAXB
PCB_TCR_CONT            equ 0x0001      ; bit 0:  Continuous (1=genstart automatisk)
; 0xC013 = PCB_TCR_EN|PCB_TCR_INH|PCB_TCR_RTG|PCB_TCR_ALT|PCB_TCR_CONT
;        = Timer kørende, internt ur (CPU÷4), retriggerable, bruger MAXB, continuous
;        = Bruges til kassettebånd bit-bredde-måling (MAXA=MAXB=0xFFFF)

PORT_PCB_DMA0_SRCLO     equ 0xFFC0      ; DMA 0 Source Address (low)
PORT_PCB_DMA0_SRCHI     equ 0xFFC2      ; DMA 0 Source Address (high)
PORT_PCB_DMA0_DSTLO     equ 0xFFC4      ; DMA 0 Destination Address (low)
PORT_PCB_DMA0_DSTHI     equ 0xFFC6      ; DMA 0 Destination Address (high)
PORT_PCB_DMA0_CNT       equ 0xFFC8      ; DMA 0 Transfer Count register
PORT_PCB_DMA0_CON       equ 0xFFCA      ; DMA 0 Control word register

PORT_PCB_DMA1_SRCLO     equ 0xFFD0      ; DMA 1 Source Address (low)
PORT_PCB_DMA1_SRCHI     equ 0xFFD2      ; DMA 1 Source Address (high)
PORT_PCB_DMA1_DSTLO     equ 0xFFD4      ; DMA 1 Destination Address (low)
PORT_PCB_DMA1_DSTHI     equ 0xFFD6      ; DMA 1 Destination Address (high)
PORT_PCB_DMA1_CNT       equ 0xFFD8      ; DMA 1 Transfer Count register
PORT_PCB_DMA1_CON       equ 0xFFDA      ; DMA 1 Control word register

; -----------------------------------------------------------------------------
; ISO-646-DK (Dansk 7-bit tegnsæt til RC759 Piccoline)
; -----------------------------------------------------------------------------
; Standard tegn-ækvivalenter:
;   æ -> { (0x7B)
;   ø -> | (0x7C)
;   å -> } (0x7D)
;   Æ -> [ (0x5B)
;   Ø -> \ (0x5C)
;   Å -> ] (0x5D)
;
; db_dk konverterer automatisk en UTF-8 streng til 7-bit ISO-646-DK koder:
; Eksempel:
;   db_dk 'Blåbærgrød på Rømø'
; -----------------------------------------------------------------------------
%macro db_dk 1
  %strlen %%len %1
  %assign %%i 1
  %rep %%len
    %if %%i <= %%len
      %substr %%c %1 %%i
      %if %%c == 0xC3
        %assign %%i %%i + 1
        %substr %%c2 %1 %%i
        %if %%c2 == 0xA6
          db 0x7B       ; æ -> {
        %elif %%c2 == 0xB8
          db 0x7C       ; ø -> |
        %elif %%c2 == 0xA5
          db 0x7D       ; å -> }
        %elif %%c2 == 0x86
          db 0x5B       ; Æ -> [
        %elif %%c2 == 0x98
          db 0x5C       ; Ø -> 0x5C (backslash)
        %elif %%c2 == 0x85
          db 0x5D       ; Å -> 0x5D (bracket right)
        %else
          db 0xC3, %%c2 ; Ukendt C3-sekvens bevares uændret
        %endif
      %else
        db %%c          ; Standard ASCII
      %endif
      %assign %%i %%i + 1
    %endif
  %endrep
%endmacro

; -----------------------------------------------------------------------------
; db_pstr konverterer en UTF-8 streng til en Pascal-streng i 7-bit ISO-646-DK
; med automatisk foranstillet længdebyte:
; Eksempel:
;   db_pstr 'Venter på fælles skriver'  ->  db 24, "Venter p} f{lles skriver"
; -----------------------------------------------------------------------------
%macro db_pstr 1
  db (%%pstr_end - %%pstr_start)
  %%pstr_start:
    db_dk %1
  %%pstr_end:
%endmacro

%endif ; _HARDWARE_INC_


