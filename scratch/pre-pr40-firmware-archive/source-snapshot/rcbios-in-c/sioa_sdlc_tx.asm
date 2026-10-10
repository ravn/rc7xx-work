; sioa_sdlc_tx.asm — SIO-A SDLC transmit test (MIC702 / PCB530)
;
; Transmits one SDLC/HDLC I-frame from SIO channel A at 125 kbaud
; (CTC ch0 timer mode, 4 MHz / 16 / 2).  NRZI, CRC-CCITT, flag idle.
;
; SIO-A is the *data* port in the current BIOS (session 19: console
; on SIO-B, data/RDR/PUN/LPT on SIO-A).  This program commandeers
; SIO-A for SDLC while the console stays alive on SIO-B.
;
; Build:  zmac -z sioa_sdlc_tx.asm
; Output: zout/sioa_sdlc_tx.cim  →  SIOASDLC.COM
;
; Exit:   restores CTC ch0 + SIO-A to 38400 async baseline.

        .z80
        org     0100h

; --- Ports -----------------------------------------------------------

CTC_CH0 equ     0Ch             ; CTC channel 0 drives SIO-A clock
SIO_A_D equ     08h             ; SIO channel A data
SIO_A_C equ     0Ah             ; SIO channel A control

; --- CP/M ------------------------------------------------------------

BDOS    equ     0005h
C_PRINT equ     09h

; --- Program ---------------------------------------------------------

start:
        ld      de, msg_banner
        ld      c, C_PRINT
        call    BDOS

        di

        ; CTC ch0 → timer mode, prescaler /16, TC = 50.
        ; Nominal output = CTC_CLK / 16 / 50.
        ; CTC CLK rate on PCB530 is not yet verified by scope —
        ; empirical bit-rate measurements suggest ~5 MHz source
        ; (yielding ~6.25 kHz SIO clock, not the 10 kHz expected
        ; from the 8 MHz value MAME uses).  See session20-sdlc-
        ; summary.md "CTC CLK on PCB530" for details.
        ; Kept at TC=50 because current purpose is a low-baud
        ; correctness test of the decoder pipeline, and the exact
        ; rate doesn't matter — the receiver sweeps sps to find it.
        ld      a, 007h         ; no-int, timer, /16, TC follows, reset, ctrl
        out     (CTC_CH0), a
        ld      a, 50
        out     (CTC_CH0), a

        ; SIO-A channel reset.
        ld      a, 018h
        out     (SIO_A_C), a

        ; WR4 = 0x20 — SDLC mode, x1 clock.
        ld      a, 004h
        out     (SIO_A_C), a
        ld      a, 020h
        out     (SIO_A_C), a

        ; WR3 = 0x00 — Rx disabled.
        ld      a, 003h
        out     (SIO_A_C), a
        ld      a, 000h
        out     (SIO_A_C), a

        ; WR6 = 0x00, WR7 = 0x7E (flag).
        ld      a, 006h
        out     (SIO_A_C), a
        ld      a, 000h
        out     (SIO_A_C), a
        ld      a, 007h
        out     (SIO_A_C), a
        ld      a, 07Eh
        out     (SIO_A_C), a

        ; WR10 = 0xA0 — CRC preset 1, NRZI, flag idle, flag on
        ; underrun (auto CRC).
        ld      a, 00Ah
        out     (SIO_A_C), a
        ld      a, 0A0h
        out     (SIO_A_C), a

        ; WR1 = 0x00 — no interrupts.
        ld      a, 001h
        out     (SIO_A_C), a
        ld      a, 000h
        out     (SIO_A_C), a

        ; WR2 = 0x10 — interrupt vector (unused, matches BIOS default).
        ld      a, 002h
        out     (SIO_A_C), a
        ld      a, 010h
        out     (SIO_A_C), a

        ; WR5 = 0x6B — Tx enable, 8 bits, Tx-CRC enable, SDLC CRC,
        ; RTS asserted.
        ld      a, 005h
        out     (SIO_A_C), a
        ld      a, 06Bh
        out     (SIO_A_C), a

        ei

        ; ~200 ms of flag idle so the host DPLL locks.
        ld      bc, 40000
delay:
        dec     bc
        ld      a, b
        or      c
        jr      nz, delay

        ; Reset Tx Underrun/EOM latch so the underrun after the last
        ; data byte triggers auto CRC + closing flag.
        di
        ld      a, 0C0h
        out     (SIO_A_C), a

        ; Transmit frame payload.
        ld      hl, payload
        ld      b, payload_len
tx_loop:
        in      a, (SIO_A_C)    ; RR0
        bit     2, a            ; Tx buffer empty?
        jr      z, tx_loop
        ld      a, (hl)
        out     (SIO_A_D), a
        inc     hl
        djnz    tx_loop

        ; Wait for "All Sent" (RR1 bit 0).
wait_sent:
        ld      a, 001h         ; select RR1
        out     (SIO_A_C), a
        in      a, (SIO_A_C)
        bit     0, a
        jr      z, wait_sent

        ei

        ld      de, msg_done
        ld      c, C_PRINT
        call    BDOS

        ; Restore CTC ch0 + SIO-A to 38400 async baseline.
        di
        ld      a, 047h
        out     (CTC_CH0), a
        ld      a, 1
        out     (CTC_CH0), a

        ld      a, 018h
        out     (SIO_A_C), a
        ld      a, 002h
        out     (SIO_A_C), a
        ld      a, 010h
        out     (SIO_A_C), a
        ld      a, 004h
        out     (SIO_A_C), a
        ld      a, 044h         ; async, x16, 1 stop, no parity
        out     (SIO_A_C), a
        ld      a, 003h
        out     (SIO_A_C), a
        ld      a, 0E1h         ; Rx enable, 8 bits, auto-enables
        out     (SIO_A_C), a
        ld      a, 005h
        out     (SIO_A_C), a
        ld      a, 068h         ; Tx enable, 8 bits, RTS asserted — matches
                                ; BIOS async init so RTS/CTS flow control
                                ; keeps working after this program exits.
        out     (SIO_A_C), a

        ; WR10 back to all zero: cancel NRZI, CRC preset, flag idle
        ; — leaves SIO-A in plain async NRZ.
        ld      a, 00Ah
        out     (SIO_A_C), a
        ld      a, 000h
        out     (SIO_A_C), a
        ld      a, 001h
        out     (SIO_A_C), a
        ld      a, 01Fh
        out     (SIO_A_C), a
        ei

        rst     0

; --- Data -----------------------------------------------------------

msg_banner:
        defm    'SIOASDLC: 10kb SDLC TX on SIO-A',13,10
        defm    'Emitting flags, then one frame, then idle.',13,10,'$'
msg_done:
        defm    'Frame sent. Restoring async 38400.',13,10,'$'

payload:
        defm    'SDLC-TX-TEST'
        defb    0x00, 0x01, 0x02, 0x03
        defb    0xFF, 0xFF, 0xFF, 0xFF
        defb    0x7E, 0x7E
        defb    0xAA, 0x55, 0xAA, 0x55
        defb    0xDE, 0xAD, 0xBE, 0xEF
payload_len equ $ - payload
