; BGSTAR foreground/background test for RC702 BIOS
; Tests background/foreground/clear, insert/delete line, erase ops.

	.z80
	org	0x100

BDOS	equ	5
CONOUT	equ	2

	jp	MAIN

; Print string (HL = null-terminated)
PUTS:	ld	a,(hl)
	or	a
	ret	z
	push	hl
	ld	e,a
	ld	c,CONOUT
	call	BDOS
	pop	hl
	inc	hl
	jr	PUTS

; Send control code in A
CTRL:	ld	e,a
	ld	c,CONOUT
	jp	BDOS

; Cursor to col B, row C (saves BC across BDOS calls)
GOTOXY:	push	bc
	ld	a,6
	call	CTRL
	pop	bc
	push	bc
	ld	a,b
	add	a,32
	call	CTRL
	pop	bc
	ld	a,c
	add	a,32
	jp	CTRL

MAIN:
; --- TEST 1: BG drawing + clear FG (no insert/delete) ---
	ld	a,0x0C		; clear screen
	call	CTRL
	ld	a,0x13		; background mode
	call	CTRL
	; Draw cat at (35,2)
	ld	b,35
	ld	c,2
	call	GOTOXY
	ld	hl,CAT1
	call	PUTS
	ld	b,35
	ld	c,3
	call	GOTOXY
	ld	hl,CAT2
	call	PUTS
	ld	b,35
	ld	c,4
	call	GOTOXY
	ld	hl,CAT3
	call	PUTS
	ld	b,35
	ld	c,5
	call	GOTOXY
	ld	hl,CAT4
	call	PUTS
	ld	b,35
	ld	c,6
	call	GOTOXY
	ld	hl,CAT5
	call	PUTS
	ld	a,0x14		; foreground
	call	CTRL
	; Write foreground text at (35,4)
	ld	b,35
	ld	c,4
	call	GOTOXY
	ld	hl,STR_FG
	call	PUTS
	; Clear foreground — should keep cat, remove FG text
	ld	a,0x15
	call	CTRL
	; Marker
	ld	b,0
	ld	c,23
	call	GOTOXY
	ld	hl,STR_T1
	call	PUTS
	ld	c,1
	call	BDOS

; --- TEST 2: BG + insert line + clear FG ---
	ld	a,0x0C
	call	CTRL
	ld	a,0x13		; background
	call	CTRL
	ld	b,35
	ld	c,2
	call	GOTOXY
	ld	hl,CAT1
	call	PUTS
	ld	b,35
	ld	c,3
	call	GOTOXY
	ld	hl,CAT2
	call	PUTS
	ld	b,35
	ld	c,4
	call	GOTOXY
	ld	hl,CAT3
	call	PUTS
	ld	b,35
	ld	c,5
	call	GOTOXY
	ld	hl,CAT4
	call	PUTS
	ld	b,35
	ld	c,6
	call	GOTOXY
	ld	hl,CAT5
	call	PUTS
	ld	a,0x14		; foreground
	call	CTRL
	; Insert line at row 3 — shifts rows 3+ down
	ld	b,0
	ld	c,3
	call	GOTOXY
	ld	a,0x01		; insert line
	call	CTRL
	; Clear foreground
	ld	a,0x15
	call	CTRL
	; Marker
	ld	b,0
	ld	c,23
	call	GOTOXY
	ld	hl,STR_T2
	call	PUTS
	ld	c,1
	call	BDOS

; --- TEST 3: BG + delete line + clear FG ---
	ld	a,0x0C
	call	CTRL
	ld	a,0x13		; background
	call	CTRL
	ld	b,35
	ld	c,2
	call	GOTOXY
	ld	hl,CAT1
	call	PUTS
	ld	b,35
	ld	c,3
	call	GOTOXY
	ld	hl,CAT2
	call	PUTS
	ld	b,35
	ld	c,4
	call	GOTOXY
	ld	hl,CAT3
	call	PUTS
	ld	b,35
	ld	c,5
	call	GOTOXY
	ld	hl,CAT4
	call	PUTS
	ld	b,35
	ld	c,6
	call	GOTOXY
	ld	hl,CAT5
	call	PUTS
	ld	a,0x14		; foreground
	call	CTRL
	; Delete line at row 3 — shifts rows 4+ up
	ld	b,0
	ld	c,3
	call	GOTOXY
	ld	a,0x02		; delete line
	call	CTRL
	; Clear foreground
	ld	a,0x15
	call	CTRL
	; Marker
	ld	b,0
	ld	c,23
	call	GOTOXY
	ld	hl,STR_T3
	call	PUTS
	ld	c,1
	call	BDOS

; --- DONE ---
	ld	a,0x0C
	call	CTRL
	ld	hl,STR_DONE
	call	PUTS
	rst	0

; Data
CAT1:	db	' /\_/\ ',0
CAT2:	db	'( o.o )',0
CAT3:	db	' > ^ < ',0
CAT4:	db	'/|   |\',0
CAT5:	db	'(|   |)',0

STR_FG:	db	'XXXXXXX',0
STR_T1:	db	'TEST1 OK',0
STR_T2:	db	'TEST2 OK',0
STR_T3:	db	'TEST3 OK',0
STR_DONE:	db	'ALL BGSTAR TESTS PASSED',0

	end
