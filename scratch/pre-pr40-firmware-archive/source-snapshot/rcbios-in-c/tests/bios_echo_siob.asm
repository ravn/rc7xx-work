; bios_echo_siob.asm -- full-speed bidirectional SIO-B test, 4096 bytes.
;
; Sets IOBYTE to route CON:=TTY (SIO-B only input) and LST:=TTY (SIO-B only
; output), then loops: CONIN → LIST.  This bypasses CRT escape-sequence
; processing so raw 0x00..0xFF bytes pass through the BIOS without side
; effects.
;
; BIOS jump table (BIOSAD = 0xDA00):
;   CONIN  = 0xDA09   (entry 3)
;   LIST   = 0xDA0F   (entry 5)   -- routes via IOBYTE_LST
;
; Result block at 0x180: 'R!@#' tag + 16-bit count + mismatch + status.

        .z80
        ORG     0x0100

BIOSAD  EQU     0xDA00
CONIN   EQU     BIOSAD + 3*3
BLIST   EQU     BIOSAD + 5*3
IOBYTE  EQU     0x0003          ; CP/M zero-page IOBYTE address

start:
        ; Save IOBYTE; set CON=TTY(0), LST=TTY(0) so both I/O paths are SIO-B only.
        LD      A, (IOBYTE)
        LD      (saved_iobyte), A
        XOR     A               ; iobyte = 0x00
        LD      (IOBYTE), A

        LD      A, 0xFF
        LD      (result_status), A
        XOR     A
        LD      (result_mismatch), A
        LD      (result_count_lo), A
        LD      (result_count_hi), A

        ; Handshake: write 0xA5 sync byte so host feeder knows we're ready.
        LD      C, 0xA5
        CALL    BLIST

        LD      D, 16
        LD      B, 0
outer:
inner:
        PUSH    BC
        PUSH    DE
        CALL    CONIN           ; A = byte from SIO-B
        POP     DE
        POP     BC

        CP      B
        JR      Z, no_err
        PUSH    AF
        LD      A, (result_mismatch)
        CP      0xFF
        JR      Z, sat_done
        INC     A
        LD      (result_mismatch), A
sat_done:
        POP     AF
no_err:
        LD      C, A
        PUSH    BC
        PUSH    DE
        CALL    BLIST           ; write to SIO-B (LST=TTY)
        POP     DE
        POP     BC

        LD      A, (result_count_lo)
        INC     A
        LD      (result_count_lo), A
        JR      NZ, no_carry
        LD      A, (result_count_hi)
        INC     A
        LD      (result_count_hi), A
no_carry:

        INC     B
        JR      NZ, inner
        DEC     D
        JR      NZ, outer

        LD      A, 0xAA
        LD      (result_status), A

        ; Restore IOBYTE, warm boot
        LD      A, (saved_iobyte)
        LD      (IOBYTE), A
        LD      C, 0
        CALL    0x0005

saved_iobyte: DB 0

        ORG     0x0180
result_tag:      DB 'R','!','@','#'
result_count_lo: DB 0
result_count_hi: DB 0
result_mismatch: DB 0
result_status:   DB 0xFF

        END     start
