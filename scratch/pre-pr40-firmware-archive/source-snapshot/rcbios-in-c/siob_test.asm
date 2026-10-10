; siob_test.asm — SIO-B receive test for RC700 CP/M
;
; Sets IOBYTE RDR:=UR1 (SIO-B), reads bytes via BIOS READER entry,
; prints each as hex to console, then checks for marker string.
; Prints PASS or FAIL and exits to CP/M.
;
; Does NOT use PIP or STAT — calls BIOS directly.
;
; Build:  zmac -z siob_test.asm
; Output: zout/siob_test.cim (rename to SIOBTEST.COM)

        .z80
        org     0100h

; BIOS entry points (56K, BIOS at 0xDA00)
BIOS    equ     0DA00h
CONOUT  equ     BIOS + 0Ch      ; C = char
READER  equ     BIOS + 15h      ; returns A = byte from RDR:
READS   equ     BIOS + 4Dh      ; returns A = FF if data ready, 0 if not

; BIOS BSS addresses for direct ring buffer access (from nm bios.elf)
; rxhead_b and rxtail_b are wb struct members at wb+5 and wb+6
RXHEAD_B equ    0ECE8h          ; wb.rxhead_b (wb=0xECE3, offset 5)
RXTAIL_B equ    0ECE9h          ; wb.rxtail_b (wb=0xECE3, offset 6)
RXBUF_B  equ    0EDF5h          ; _rxbuf_b (256 bytes)

; CP/M
BDOS    equ     0005h
IOBYTE  equ     0003h
C_WRITE equ     02h
C_PRINT equ     09h

; IOBYTE RDR: field is bits 3:2
; UR1 (SIO-B) = value 2 in bits 3:2 = 0x08
IOB_RDR_MASK equ 0Ch           ; bits 3:2
IOB_RDR_UR1  equ 08h           ; value 2 << 2

start:
        ; Set IOBYTE RDR: = UR1 (SIO-B) FIRST, before any BDOS calls
        ld      a, (IOBYTE)
        and     ~IOB_RDR_MASK   ; clear RDR field
        or      IOB_RDR_UR1     ; set to UR1
        ld      (IOBYTE), a

        ; Print banner (IOBYTE already set)
        ld      de, msg_banner
        ld      c, C_PRINT
        call    BDOS

        ; Print "IOBYTE="
        ld      de, msg_iobyte
        ld      c, C_PRINT
        call    BDOS
        ld      a, (IOBYTE)
        call    puthex
        call    putcrlf

        ; Verify IOBYTE wasn't clobbered by BDOS
        ld      a, (IOBYTE)
        push    af
        ld      de, msg_iob2
        ld      c, C_PRINT
        call    BDOS
        pop     af
        call    puthex
        call    putcrlf

        ; Re-assert IOBYTE in case BDOS changed it
        ld      a, (IOBYTE)
        and     ~IOB_RDR_MASK
        or      IOB_RDR_UR1
        ld      (IOBYTE), a

        ; Read up to 128 bytes from READER, stop on Ctrl-Z (0x1A)
        ; or after 128 bytes, whichever comes first.
        ld      hl, rxdata      ; store received data here
        ld      b, 128          ; max bytes to read

        ; Wait up to ~10 seconds for first byte (500 polls with HALT)
        ld      de, 500
wait_first:
        ld      a, (RXTAIL_B)
        ld      c, a
        ld      a, (RXHEAD_B)
        cp      c               ; head != tail means data available
        jr      nz, read_loop
        ei
        halt                    ; yield to ISRs
        dec     de
        ld      a, d
        or      e
        jr      nz, wait_first

        ; Timeout — no data received
        ld      de, msg_timeout
        ld      c, C_PRINT
        call    BDOS
        jp      fail

read_loop:
        push    bc              ; save loop counter (READER clobbers B)
        push    hl              ; save store pointer
        ; Spin until SIO-B ring buffer has data
.rwait: ld      a, (RXTAIL_B)
        ld      c, a
        ld      a, (RXHEAD_B)
        cp      c
        jr      z, .rwait
        ; Read rxbuf_b[tail]
        ld      e, c
        ld      d, 0
        ld      hl, RXBUF_B
        add     hl, de
        ld      a, (hl)         ; A = received byte
        ; Advance tail
        inc     c
        push    af
        ld      a, c
        ld      (RXTAIL_B), a
        pop     af
        pop     hl              ; restore store pointer
        pop     bc              ; restore loop counter
        cp      1Ah             ; Ctrl-Z?
        jr      z, read_done
        ld      (hl), a         ; store byte
        inc     hl
        djnz    read_loop

read_done:
        ; HL points past last byte, B = remaining count
        ld      a, 128
        sub     b
        ld      (rxlen), a      ; save received length

        ; Print received data as hex
        ld      de, msg_received
        ld      c, C_PRINT
        call    BDOS
        ld      a, (rxlen)
        call    puthex
        ld      de, msg_bytes
        ld      c, C_PRINT
        call    BDOS

        ; Print received data as hex dump (first 32 bytes)
        ld      de, msg_data
        ld      c, C_PRINT
        call    BDOS
        ld      hl, rxdata
        ld      a, (rxlen)
        or      a
        jr      z, check_marker
        cp      32
        jr      c, hex_count_ok
        ld      a, 32           ; cap at 32 bytes for hex dump
hex_count_ok:
        ld      b, a
hex_data:
        ld      a, (hl)
        push    hl
        push    bc
        call    puthex
        ld      e, ' '
        ld      c, C_WRITE
        call    BDOS
        pop     bc
        pop     hl
        inc     hl
        djnz    hex_data
        call    putcrlf

check_marker:
        ; Check if received data contains "SIOB-IOBYTE-TEST-OK"
        ld      a, (rxlen)
        cp      19              ; marker is 19 bytes
        jr      c, fail         ; too short

        ld      hl, rxdata
        ld      de, marker
        ld      b, 19
cmp_loop:
        ld      a, (de)
        cp      (hl)
        jr      nz, fail
        inc     hl
        inc     de
        djnz    cmp_loop

        ; PASS
        ld      de, msg_pass
        ld      c, C_PRINT
        call    BDOS
        jr      restore

fail:
        ld      de, msg_fail
        ld      c, C_PRINT
        call    BDOS

restore:
        ; Restore IOBYTE RDR: to PTR (SIO-A, value 0)
        ld      a, (IOBYTE)
        and     ~IOB_RDR_MASK
        ld      (IOBYTE), a

        ; Return to CP/M
        rst     0

; ---- Subroutines ----

; Print A as 2 hex digits
puthex:
        push    af
        rrca
        rrca
        rrca
        rrca
        call    putnib
        pop     af
putnib:
        and     0Fh
        add     a, '0'
        cp      '9'+1
        jr      c, putnib_out
        add     a, 'A'-'0'-10
putnib_out:
        ld      e, a
        ld      c, C_WRITE
        call    BDOS
        ret

putcrlf:
        ld      e, 13
        ld      c, C_WRITE
        call    BDOS
        ld      e, 10
        ld      c, C_WRITE
        call    BDOS
        ret

; ---- Data ----

msg_banner:  defm 'SIO-B BIOS test',13,10,'$'
msg_iobyte:  defm 'IOBYTE=$'
msg_timeout: defm 'TIMEOUT: no data from SIO-B',13,10,'$'
msg_received:defm 'Received $'
msg_bytes:   defm ' bytes',13,10,'$'
msg_data:    defm 'Data: $'
msg_pass:    defm 13,10,'SIOB-IOBYTE-TEST-OK',13,10,'$'
msg_fail:    defm 13,10,'SIOB-IOBYTE-TEST-FAIL',13,10,'$'

msg_iob2:    defm 'IOB2=$'
marker:      defm 'SIOB-IOBYTE-TEST-OK'

rxlen:       defb 0
rxdata:      defs 128
