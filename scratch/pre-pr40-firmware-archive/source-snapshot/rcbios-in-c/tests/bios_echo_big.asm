; bios_echo_big.asm -- full-speed bidirectional SIO-A test, 4096 bytes.
;
; Uses BIOS jump table directly (BIOSAD = 0xDA00 for MSIZE=56):
;   PUNCH  = 0xDA12   (entry 6)
;   READER = 0xDA15   (entry 7)
;   CONOUT = 0xDA0C   (entry 4)
;
; For each byte of 4096: read via READER, compare with expected counter,
; echo back via PUNCH.  Problem detection:
;   - byte mismatch: bumps saturating mismatch counter (max 255)
;   - result tag 'R!@#' + status written to 0x180 for external (Lua) pickup
;   - status = 0xFF while running, 0xAA when complete
;
; Invoke with the BIOS default IOBYTE (RDR:=PTR→SIO-A, PUN:=PTP→SIO-A).
; Call as a normal CP/M .COM; warm-boots on completion.

        .z80
        ORG     0x0100

BIOSAD  EQU     0xDA00
CONOUT  EQU     BIOSAD + 4*3
PUNCH   EQU     BIOSAD + 6*3
READER  EQU     BIOSAD + 7*3

start:
        ; mark status = running
        LD      A, 0xFF
        LD      (result_status), A
        LD      A, 0
        LD      (result_mismatch), A
        LD      (result_count_lo), A
        LD      (result_count_hi), A

        ; Handshake: emit 0xA5 sync byte so host feeder waits for us.
        LD      C, 0xA5
        CALL    PUNCH

        LD      D, 16           ; D = outer cycle count (16 * 256 = 4096)
        LD      B, 0            ; B = expected byte

outer:
inner:
        ; read one byte via BIOS READER
        PUSH    BC
        PUSH    DE
        CALL    READER          ; A = received byte
        POP     DE
        POP     BC

        CP      B               ; compare with expected
        JR      Z, no_err

        ; mismatch: increment saturating counter at result_mismatch
        PUSH    AF
        LD      A, (result_mismatch)
        CP      0xFF
        JR      Z, sat_done
        INC     A
        LD      (result_mismatch), A
sat_done:
        POP     AF

no_err:
        ; echo back via BIOS PUNCH (C = byte per CP/M convention)
        LD      C, A
        PUSH    BC
        PUSH    DE
        CALL    PUNCH
        POP     DE
        POP     BC

        ; bump count lo/hi in result block
        LD      A, (result_count_lo)
        INC     A
        LD      (result_count_lo), A
        JR      NZ, no_carry
        LD      A, (result_count_hi)
        INC     A
        LD      (result_count_hi), A
no_carry:

        INC     B               ; expected++
        JR      NZ, inner       ; 256-loop
        DEC     D               ; outer cycle--
        JR      NZ, outer

        ; All bytes processed. Mark done.
        LD      A, 0xAA
        LD      (result_status), A

        ; Print completion msg
        LD      HL, msg_done
print_loop:
        LD      A, (HL)
        OR      A
        JR      Z, print_done
        PUSH    HL
        LD      C, A
        CALL    CONOUT
        POP     HL
        INC     HL
        JR      print_loop
print_done:

        ; Warm boot via BDOS fn 0 (simpler than BIOS WBOOT lookup)
        LD      C, 0
        CALL    0x0005

msg_done: DB    'ECHO DONE', 0x0D, 0x0A, 0

        ORG     0x0180          ; result block at fixed address
result_tag:     DB  'R','!','@','#'
result_count_lo: DB 0
result_count_hi: DB 0
result_mismatch: DB 0
result_status:   DB 0xFF

        END     start
