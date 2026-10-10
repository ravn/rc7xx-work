; CONOTEST.COM — Exercise RC702 display memory-moving control codes
; Focus: scroll, insert line (0x01), delete line (0x02)
; Non-interactive — writes results to screen, no keypress waits.
; Assembles: zmac -8 --dri conout_test.asm

BDOS	EQU	5
CONOUT	EQU	2
PRTSTR	EQU	9

	ORG	100H

	; ===== TEST: INSERT LINE =====
	CALL	CLRSCR
	CALL	FILL5		; rows 00-04

	; Insert at row 2 — pushes rows 2-4 down
	CALL	GOXY
	DB	0, 2
	MVI	E,01H		; INSERT LINE
	CALL	PUTCH
	LXI	D,S$INS2
	CALL	PUTS

	; Insert at row 0 — pushes everything down
	CALL	GOXY
	DB	0, 0
	MVI	E,01H
	CALL	PUTCH
	LXI	D,S$INS0
	CALL	PUTS

	; Print result label
	CALL	GOXY
	DB	0, 10
	LXI	D,S$IRESULT
	CALL	PUTS

	; Expected screen (rows 0-9):
	; 0: >>>INS@0
	; 1: 00:AAAAA
	; 2: 01:BBBBB
	; 3: >>>INS@2
	; 4: 02:CCCCC
	; 5: 03:DDDDD
	; 6: 04:EEEEE
	; 7: (blank)
	; ...
	; 10: INSERT RESULT: see above

	RET

; ===== Subroutines =====

; Fill 5 numbered rows
FILL5:	XRA	A
	STA	ROWNUM
FL5:	LDA	ROWNUM
	CALL	PUTDEC
	MVI	E,':'
	CALL	PUTCH
	; Fill 5 chars of pattern
	LDA	ROWNUM
	ADI	'A'
	STA	FILCHR
	MVI	A,5
	STA	FILCNT
FLC5:	LDA	FILCHR
	MOV	E,A
	CALL	PUTCH
	LDA	FILCNT
	DCR	A
	STA	FILCNT
	JNZ	FLC5
	; CR+LF
	MVI	E,0DH
	CALL	PUTCH
	MVI	E,0AH
	CALL	PUTCH
	LDA	ROWNUM
	INR	A
	STA	ROWNUM
	CPI	5
	JC	FL5
	RET

CLRSCR:	MVI	E,0CH
	JMP	PUTCH

PUTCH:	MVI	C,CONOUT
	JMP	BDOS

PUTS:	MVI	C,PRTSTR
	JMP	BDOS

; XY cursor addressing: inline X,Y follow CALL
; Uses memory to survive BDOS register trashing
GOXY:	POP	H
	MOV	A,M		; X
	ADI	' '
	STA	GOXY_X
	INX	H
	MOV	A,M		; Y
	ADI	' '
	STA	GOXY_Y
	INX	H
	PUSH	H
	MVI	E,06H		; start XY addressing
	CALL	PUTCH
	LDA	GOXY_X
	MOV	E,A
	CALL	PUTCH
	LDA	GOXY_Y
	MOV	E,A
	JMP	PUTCH

; Print A as 2-digit decimal
PUTDEC:	MVI	E,'0'
PD10:	CPI	10
	JC	PD1
	SUI	10
	INR	E
	JMP	PD10
PD1:	ADI	'0'
	STA	ONES
	CALL	PUTCH
	LDA	ONES
	MOV	E,A
	JMP	PUTCH

; --- Variables ---
ROWNUM:	DS	1
FILCHR:	DS	1
FILCNT:	DS	1
ONES:	DS	1
GOXY_X:	DS	1
GOXY_Y:	DS	1

; --- Strings ---
S$INS2:	DB	'>>>INS@2','$'
S$INS0:	DB	'>>>INS@0','$'
S$IRESULT: DB 'INSERT RESULT: 0=INS@0 1=00A 2=01B 3=INS@2 4=02C 5=03D 6=04E','$'

	END
