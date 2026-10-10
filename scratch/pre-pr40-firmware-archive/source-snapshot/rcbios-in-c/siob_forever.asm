; siob_forever.asm — minimal SIO-B forever-loop reader for RC700 CP/M
;
; Reads bytes from the BIOS SIO-B ring buffer one at a time and prints
; each as a 2-digit hex value followed by a space on CON: (SIO-A).
; Loops forever — exit with RC700 reset.
;
; Build:
;   z88dk/bin/z80asm -b -oCOM siob_forever.asm
; Output is siob_forever.bin (rename or cat to .COM)

        org $0100

RXHEAD_B equ $EDE9
RXTAIL_B equ $EDEA
RXBUF_B  equ $EDEB
BDOS     equ $0005
C_WRITE  equ $02

start:
        ; Reset the ring buffer so we start clean
        xor     a
        ld      (RXHEAD_B), a
        ld      (RXTAIL_B), a

        ; Banner
        ld      de, banner
        ld      c, $09          ; BDOS print string ($-terminated)
        call    BDOS

wait:
        ; Yield to CRT refresh / other ISRs, then check for data.
        ; Without HALT the busy loop starves the 50 Hz CRT ISR and the
        ; display goes dark.
        ei
        halt
        ld      a, (RXHEAD_B)
        ld      hl, RXTAIL_B
        cp      (hl)
        jr      z, wait

        ; HL still points at RXTAIL_B; (hl) = tail index
        ld      a, (hl)         ; A = tail
        ld      e, a            ; save tail in E for buffer index
        ld      d, 0
        ; advance tail
        inc     (hl)
        ; load rxbuf_b[tail]
        ld      hl, RXBUF_B
        add     hl, de
        ld      a, (hl)         ; A = received byte

        ; Print as 2 hex digits + space
        push    af
        rrca
        rrca
        rrca
        rrca
        call    putnib
        pop     af
        call    putnib
        ld      e, ' '
        ld      c, C_WRITE
        call    BDOS

        jr      wait

; Print low nibble of A as an ASCII hex digit via BDOS C_WRITE.
; Clobbers A, E; preserves nothing else.
putnib:
        and     $0F
        add     a, '0'
        cp      '9' + 1
        jr      c, putnib_out
        add     a, 'A' - '0' - 10
putnib_out:
        ld      e, a
        ld      c, C_WRITE
        call    BDOS
        ret

banner:
        defm    "SIO-B forever reader"
        defb    13,10,'$'
