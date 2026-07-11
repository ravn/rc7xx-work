	.globl _start
	.text
; --- BDOS stub, org 0xF000, reached via JP at 0x0005 ---
; C = BDOS function.  Supported (CP/M 2.2 console subset + a few conveniences):
;   0    (exit)                2   (conout E)         6   (direct console out E)
;   9    (print DE..'$')       11  (console status -> 0)
;   12   (return version -> CP/M 2.2, HL=0x0022)
;   13   (disk reset -> no-op) 14  (select disk -> no-op, A=0)
;   25   (get current disk -> A=0)  26  (set DMA addr -> no-op)
;   108  (CP/M3 P_RETCODE)     dummy: prints "[108 rc=NNNN]" (DE) back to us, ret
; Any other function is fatal: run an illegal opcode (ED FF) as a semantic trap,
; write sentinel 0xDEAD + the function number to 0xFFF0, then exit.  The wrapper
; reads the RAM dump and reports fatal; ticks silently ignores illegal opcodes
; so it cannot signal the error itself.
_start:
bdos:
	; debug: print "Bxx" where xx is the BDOS function number in hex
	push	af
	push	bc
	ld	a,'B'
	out	(0),a
	ld	a,c
	call	hexb
	ld	a,' '
	out	(0),a
	pop	bc
	pop	af
	ld	a,c
	or	a
	jp	z,cexit        ; fn 0 = system reset
	cp	2
	jr	z,fn2
	cp	6
	jr	z,fn6
	cp	9
	jr	z,fn9
	cp	11
	jr	z,fn11
	cp	12
	jr	z,fn12
	cp	13
	jr	z,fn_nop       ; disk reset: no-op
	cp	14
	jr	z,fn_nop0      ; select disk: return 0
	cp	25
	jr	z,fn_nop0      ; get current disk: return 0 (drive A)
	cp	26
	jr	z,fn_nop       ; set DMA addr: no-op
	cp	0x6c
	jr	z,fn108
	jr	unsup
fn2:
	ld	a,e
	out	(0),a
	ret
fn6:
	ld	a,e
	cp	0xff
	ret	z              ; input request: ignore
	out	(0),a
	ret
fn9:
	ld	a,(de)
	cp	0x24           ; '$'
	ret	z
	out	(0),a
	inc	de
	jr	fn9
fn11:                          ; console status: return 0 (no char available)
	xor	a
	ret
fn_nop:                        ; no-op: return without value
	ret
fn_nop0:                       ; no-op returning 0
	xor	a
	ret
fn12:
	ld	l,0x22         ; CP/M 2.2
	ld	h,0
	ld	b,h            ; BDOS returns B=H, A=L
	ld	a,l
	ret
; fn 108 P_RETCODE: dummy that echoes the return code (DE) to us as "[108 rc=NNNN]"
fn108:
	ld	hl,msg108
p108:
	ld	a,(hl)
	or	a
	jr	z,pv108
	out	(0),a
	inc	hl
	jr	p108
pv108:
	ld	a,d
	call	hexb
	ld	a,e
	call	hexb
	ld	a,0x5d         ; ']'
	out	(0),a
	ld	a,0x0a
	out	(0),a
	ret
hexb:                          ; print A as two hex nibbles
	push	af
	rra
	rra
	rra
	rra
	call	hexn
	pop	af
hexn:
	and	0x0f
	add	a,0x90
	daa
	adc	a,0x40
	daa
	out	(0),a
	ret
msg108:
	.asciz	"[108 rc=0x"
unsup:
	.byte	0xed,0xff      ; illegal opcode (semantic trap; NOP on ticks)
	ld	a,0xde
	ld	(0xfff0),a     ; sentinel byte 0
	ld	a,0xad
	ld	(0xfff1),a     ; sentinel byte 1
	ld	a,c
	ld	(0xfff2),a     ; offending function number
	jp	cexit
cexit:
	jp	0x0000         ; exit -> HALT at 0x0000 (-end 0x0000)
