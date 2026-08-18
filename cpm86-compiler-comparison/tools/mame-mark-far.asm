; mame-mark-far.asm -- LARGE-model (FAR) MAME bracket markers for DR C 1.11
; builds. DR C defaults to the large model and calls external functions with a
; FAR call, so these procs are FAR (retf). They take no arguments: each just
; drives one 16-bit word onto the undecoded I/O port 0x2FE with a single
; `OUT DX,AX`, which the MAME rc759 host taps to read its emulated clock.
;
;   mame_start -> word 0xB000  (loop entry)
;   mame_end   -> word 0xE000  (loop exit)
;
; Assembled by Open Watcom bwasm with -nm=MM so DR LINK-86 accepts the OMF
; module name (a long absolute mktemp THEADR would trip "OBJECT FILE ERROR 10"),
; exactly as tools/putchar-far.asm is handled by drc-oracle.sh.
	.8086
CGROUP	group	CODE
CODE	segment	byte public 'CODE'
	assume	cs:CODE
	public	mame_start
	public	mame_end
mame_start	proc	far
	mov	dx,02FEh
	mov	ax,0B000h
	out	dx,ax
	retf
mame_start	endp
mame_end	proc	far
	mov	dx,02FEh
	mov	ax,0E000h
	out	dx,ax
	retf
mame_end	endp
CODE	ends
	end
