        name    crt0
        extrn   main_ : near
        public  _cstart_
        public  _small_code_
_small_code_    equ     0

DGROUP  group   _DATA, STACK

_TEXT   segment word public 'CODE'
        assume  cs:_TEXT, ds:DGROUP, ss:DGROUP
; CMD loader enters at CS:0000 with DS=SS=data group already set.
_cstart_:
        mov     sp, offset DGROUP:stktop
        call    main_
        xor     dx, dx
        mov     cl, 0                   ; BDOS 0 = system reset / exit
        int     0E0h
_TEXT   ends

_DATA   segment word public 'DATA'
_DATA   ends

STACK   segment word stack 'STACK'
        db      128 dup(?)
stktop  label   word
STACK   ends
        end
